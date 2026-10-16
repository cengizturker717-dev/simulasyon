#pragma once
#include <QQuickWindow>
#include <QEventLoop>
#include <QTimer>
#include <QTextStream>
#include <QFile>
#include "../MachineData.h"

// Synthetic snapshots against a copied test library. No live CNI connection,
// machine writes, commands, or guessed production tool dimensions.
inline int runDrillRigChecks(QQuickWindow* window,Motion& motion,Pcni& pcni,StockGeometry& stock,Machining& machining,MachineData& data,const QVariantMap& frame,const QString& directory) {
    QDir().mkpath(directory);window->contentItem()->setEnabled(false);
    int checks=0;QString errors;
    auto check=[&](bool ok,const QString& name){++checks;if(!ok)errors+=name+"\n";};
    auto settle=[&]{window->update();QEventLoop loop;QTimer::singleShot(150,&loop,&QEventLoop::quit);loop.exec();};
    auto object=window->property("convertedObject").value<QObject*>();
    auto instances=object?object->findChild<QObject*>("drillInstances"):nullptr;
    auto body=object?object->findChild<QObject*>("SIM_DRILL_BANK_BODY"):nullptr;
    if(!instances||!body)return 2;
    check(!object->findChild<QObject*>("SIM_CLOSED_REAR_CAGE_DOOR_PANEL"),"reviewed rear yellow panel is absent");
    check(data.verticalDrills().size()==3,"only three registered fixture drills are instantiated");
    auto pose=[&](int n){QVariantMap answer;QMetaObject::invokeMethod(instances,"toolPose",Q_RETURN_ARG(QVariantMap,answer),Q_ARG(int,n));return answer;};
    auto capture=[&](int channel,const QString& name){
        auto nav=window->findChild<QObject*>("cameraNavigation");if(!nav)return;
        auto orbit=nav->property("origin").value<QObject*>();if(!orbit)return;
        const auto p=pose(channel);nav->setProperty("smoothing",false);nav->setProperty("minimumDistance",300);
        orbit->setProperty("position",QVector3D(p["x"].toDouble()*540,(machining.stockY()+stock.thickness()/1000+.025)*540,p["z"].toDouble()*540));
        orbit->setProperty("eulerRotation",QVector3D(-7,-110,0));
        QMetaObject::invokeMethod(nav,"setDistance",Q_ARG(QVariant,QVariant(850)));settle();
        check(window->grabWindow().save(directory+"/"+name),"close drill rig image saved");
    };
    check(pcni.load("rig-check.pcni"),"mixed router and three-channel drill program parses");
    const auto path=pcni.property("points").toList();
    if(path.isEmpty())return 3;
    bool run=true;double depth=-20;
    auto sample=[&](const QVariantMap& operation,double d,bool valid=true){
        depth=d;const bool drill=operation["kind"]=="drill";const auto holes=operation["holes"].toList();
        const auto first=holes.isEmpty()?QVariantMap():holes.first().toMap();
        const double x=operation["x"].toDouble(),y=operation["y"].toDouble();
        const double tipY=machining.stockY()+(18-d)/1000;
        const double physicalX=machining.stockX()+x/1000-(drill?.048644+first["mountX"].toDouble()/1000:.02517972+frame["routerX"].toDouble());
        const double physicalZ=machining.stockZ()+y/1000-(drill?.073707+first["mountY"].toDouble()/1000:-.21110186+frame["routerZ"].toDouble());
        const double anchor=drill?1.3783175:1.27960551+frame["routerY"].toDouble();
        motion.setLiveAxes((physicalX-frame["bridgeHome"].toDouble())*1000+data.axisReference(0),(physicalZ-frame["carriageHome"].toDouble())*1000+data.axisReference(1),(frame["zHome"].toDouble()+anchor-tipY)*1000+data.axisReference(2));
        QJsonObject snapshot{{"metadataValid",valid},{"workValid",true},{"panelFrameValid",true},{"executing",run},
            {"program",pcni.root()+"/User/Prog/rig-check.pcni"},{"spoilboard",18.0},{"workX",x},{"workY",y},{"workZ",d-36}};
        machining.snapshot(snapshot);settle();
    };
    int milling=0,drilling=0;double minMillingClearance=1e9,maxTipError=0;
    for(const auto& value:path) {
        const auto operation=value.toMap();sample(operation,operation["depth"].toDouble());
        if(operation["travel"].toBool()||depth<=0)continue;
        check(machining.status().startsWith("Canlı işleme"),"operation matches before animating a piston");
        const double surface=machining.stockY()+stock.thickness()/1000;
        const double bodyBottom=body->property("scenePosition").value<QVector3D>().y()/540+.7037665;
        check(bodyBottom>surface,"drill bank housing never enters the stock");
        if(operation["kind"]=="router") {
            ++milling;
            for(int n:{1,2,3}) {const auto p=pose(n);minMillingClearance=std::min(minMillingClearance,p["y"].toDouble()-surface);check(!p["active"].toBool()&&p["extension"].toDouble()==0&&p["y"].toDouble()>=surface+.01499,"milling keeps every drill retracted above the panel");}
            capture(1,"milling.png");
        } else {
            ++drilling;QSet<int> selected;
            for(const auto& hole:operation["holes"].toList()) {
                const auto h=hole.toMap();const int n=h["tool"].toInt();selected.insert(n);const auto p=pose(n);
                const double error=std::max({std::abs(p["x"].toDouble()-machining.stockX()-(operation["x"].toDouble()+h["dx"].toDouble())/1000),std::abs(p["z"].toDouble()-machining.stockZ()-(operation["y"].toDouble()+h["dy"].toDouble())/1000),std::abs(p["y"].toDouble()-surface+depth/1000)});
                maxTipError=std::max(maxTipError,error);
                check(p["active"].toBool()&&p["extension"].toDouble()>0&&error<1e-6,"only selected piston reaches the measured hole and depth");
            }
            for(int n:{1,2,3})if(!selected.contains(n)){const auto p=pose(n);check(!p["active"].toBool()&&p["y"].toDouble()>=surface+.01499,"unselected drill stays safely retracted");}
            capture(*selected.begin(),QString("drilling-%1.png").arg(drilling));
        }
    }
    check(milling>0&&drilling==2,"both multi-drill and single-drill cycles were exercised");
    const auto last=path.last().toMap();sample(last,-5);
    for(int n:{1,2,3})check(!pose(n)["active"].toBool()&&pose(n)["extension"].toDouble()==0,"retraction closes all visual pistons");
    sample(last,5,false);check(!instances->property("engaged").toBool(),"unverified program metadata cannot plunge a drill");
    stock.flush();
    check(stock.heightAt(200,200)<=10.01&&stock.heightAt(232,200)<=10.01&&stock.heightAt(400,300)<=13.01,"selected drills remove the programmed material");
    // Exercise the separate offline preview bindings as well as live samples.
    machining.clearPreview();motion.endLive();
    check(pcni.load("rig-check.pcni")&&machining.load(),"mixed program loads for offline preview");
    motion.setSpeed(3);motion.play();int offlineDrillSamples=0;
    QEventLoop offlineLoop;QTimer poll;
    QObject::connect(&poll,&QTimer::timeout,&offlineLoop,[&]{
        if(motion.toolKind()=="drill"&&motion.cutting()&&machining.depth()>0){
            ++offlineDrillSamples;
            check(instances->property("engaged").toBool(),"offline drilling opens the selected visual piston");
            for(const auto& value:motion.activeDrills()){const auto h=value.toMap();const auto p=pose(h["tool"].toInt());check(p["active"].toBool()&&std::abs(p["y"].toDouble()-machining.stockY()-(stock.thickness()-machining.depth())/1000)<1e-6,"offline drill tip follows interpolated cutting depth");}
        }
        if(!motion.running())offlineLoop.quit();
    });
    poll.start(20);QTimer::singleShot(15000,&offlineLoop,&QEventLoop::quit);offlineLoop.exec();poll.stop();
    check(!motion.running()&&offlineDrillSamples>0,"offline mixed cycle finishes and exercised the pistons");motion.pause();
    QFile report(directory+"/checks.txt");if(!report.open(QIODevice::WriteOnly))return 4;
    QTextStream out(&report);out<<"checks="<<checks<<"\npassed="<<errors.isEmpty()<<"\nmillingSamples="<<milling<<"\ndrillingSamples="<<drilling<<"\nofflineDrillSamples="<<offlineDrillSamples<<"\nminimumMillingClearanceMm="<<minMillingClearance*1000<<"\nmaxDrillTipErrorMm="<<maxTipError*1000<<"\n"<<errors;
    return errors.isEmpty()?0:1;
}
