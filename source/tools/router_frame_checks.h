#pragma once
#include <QQuickWindow>
#include <QTextStream>
#include "../Machining.h"

// Offline integration against the supplied controller Dati files. These are
// synthetic telemetry samples, not machine commands or a real-controller test.
inline int runRouterFrameChecks(QQuickWindow* window,Motion& motion,Pcni& pcni,StockGeometry& stock,Machining& machining,const QVariantMap& frame,const QString& directory){
    QDir().mkpath(directory);int checks=0;QString errors;double maxError=0;
    auto check=[&](bool ok,const QString& label){++checks;if(!ok)errors+=label+"\n";};
    auto update=[] {QCoreApplication::processEvents();};
    check(frame["calibrated"].toBool()&&frame["reference"]=="TP1"&&!frame["drillCalibrated"].toBool(),"router-only data uses its registered TP1 reference");
    // Read the supplied fixture, rather than assuming the older archive's
    // origin, spoilboard and tool length also apply to the current controller.
    const QString dir=pcni.root()+"/Dati/";
    QSettings general(dir+"fametec_dat.ini",QSettings::IniFormat),origins(dir+"datvari_dat.ini",QSettings::IniFormat);
    QSettings mand(dir+"protmand_dat.ini",QSettings::IniFormat),offsets(dir+"datmand_01_dat.ini",QSettings::IniFormat);
    QSettings assigned(dir+"datconf_01_dat.ini",QSettings::IniFormat),tools(dir+"datpunt_dat.ini",QSettings::IniFormat);
    QString originGroup,routerGroup,toolGroup;
    for(const auto& g:origins.childGroups())if(origins.value(g+"/NOME").toString()=="ORIG"+general.value("GENERAL000/ORIG_SX").toString())originGroup=g;
    for(const auto& g:mand.childGroups())if(mand.value(g+"/name")=="TP1")routerGroup=g;
    for(const auto& g:tools.childGroups())if(tools.value(g+"/NOME")==assigned.value(routerGroup+"/UTE00"))toolGroup=g;
    check(!originGroup.isEmpty()&&!routerGroup.isEmpty()&&!toolGroup.isEmpty(),"fixture contains an origin and an assigned router tool");
    if(originGroup.isEmpty()||routerGroup.isEmpty()||toolGroup.isEmpty())return 2;
    const double ox=origins.value(originGroup+"/OFFX").toDouble()-offsets.value(routerGroup+"/OFFX").toDouble();
    const double oy=origins.value(originGroup+"/OFFY").toDouble()-offsets.value(routerGroup+"/OFFY").toDouble();
    const double spoil=general.value("GENERAL000/CSag").toDouble();
    const double toolLength=tools.value(toolGroup+"/LUNG").toDouble();
    const double zDatum=origins.value(originGroup+"/OFFZ").toDouble()-offsets.value(routerGroup+"/OFFZ").toDouble()-toolLength-spoil;
    check(pcni.load("router-frame.pcni"),"diagnostic program parses with the supplied library");
    const auto path=pcni.property("points").toList();
    if(path.size()<2)return 2;
    const double thickness=pcni.property("thickness").toDouble();
    const auto first=path[1].toMap();
    motion.setLiveAxes(first["x"].toDouble()+ox,first["y"].toDouble()+oy,zDatum-thickness+first["depth"].toDouble());update();
    const auto initial=window->property("testRouterPosition").value<QVector3D>();
    QJsonObject o{{"metadataValid",true},{"workValid",true},{"panelFrameValid",true},{"spoilboard",spoil},
        {"workX",first["x"].toDouble()},{"workY",first["y"].toDouble()},{"workZ",first["depth"].toDouble()-thickness-spoil},
        {"executing",true},{"program",pcni.root()+"/User/Prog/router-frame.pcni"}};
    machining.snapshot(o);update();
    check(pcni.property("ready").toBool()&&!machining.error()&&machining.liveJob(),"registered router program loads with original controller tool library");
    check((window->property("testRouterPosition").value<QVector3D>()-initial).length()<1e-7,"Start cannot relocate stationary spindle");
    int xSamples=0,ySamples=0;QList<QVariantMap> midpoints;
    for(qsizetype i=1;i<path.size();++i){
        const auto a=path[i-1].toMap(),b=path[i].toMap();
        const double ax=a["x"].toDouble(),ay=a["y"].toDouble(),ad=a["depth"].toDouble();
        const double bx=b["x"].toDouble(),by=b["y"].toDouble(),bd=b["depth"].toDouble();
        const int steps=std::max(2,int(std::ceil(std::hypot(bx-ax,by-ay)/25)));
        if(!b["travel"].toBool()&&bd>0&&ad==bd&&std::hypot(bx-ax,by-ay)>20)
            midpoints.append(QVariantMap{{"x",(ax+bx)/2},{"y",(ay+by)/2},{"height",thickness-bd}});
        for(int n=1;n<=steps;++n){
            const double t=double(n)/steps,x=ax+(bx-ax)*t,y=ay+(by-ay)*t,d=ad+(bd-ad)*t;
            motion.setLiveAxes(x+ox,y+oy,zDatum-thickness+d);
            o["workX"]=x;o["workY"]=y;o["workZ"]=d-thickness-spoil;machining.snapshot(o);update();
            if(b["travel"].toBool()||d<=0)continue;
            if(bx!=ax&&by==ay)++xSamples;if(by!=ay&&bx==ax)++ySamples;
            const auto p=window->property("testRouterPosition").value<QVector3D>();
            const double error=std::max({std::abs(p.x()+.02517972-machining.stockX()-x/1000),
                std::abs(p.z()-.21110186-machining.stockZ()-y/1000),
                std::abs(p.y()+.57505423-machining.stockY()-(thickness-d)/1000)});
            maxError=std::max(maxError,error);
            check(error<.000001&&machining.status().startsWith("Canlı işleme"),"QML spindle tip aligns with the cut from physical axes");
        }
    }
    stock.flush();
    for(const auto& p:midpoints)check(std::abs(stock.heightAt(p["x"].toDouble(),p["y"].toDouble())-p["height"].toDouble())<.01,"material removed at the programmed segment midpoint");
    check(stock.heightAt(200,240)==18,"adjacent material remains intact");
    check(machining.stockX()==-1.017&&machining.stockZ()==-1.2046434,"stock origin stays at the fixed table corner");
    QMetaObject::invokeMethod(window,"homeView");update();
    check(window->grabWindow().save(directory+"/real-data-router.png"),"real-data QML image exported");
    // Reveal the finished cuts after the geometric checks; this is an offline
    // test pose only and sends no axis commands to a controller.
    motion.setLiveAxes(ox+1200,oy+1000,zDatum-thickness-20);
    QMetaObject::invokeMethod(window,"topView");update();
    check(window->grabWindow().save(directory+"/finished-cuts-top.png"),"unobstructed finished cuts exported");
    QFile report(directory+"/checks.txt");if(!report.open(QIODevice::WriteOnly))return 2;
    QTextStream out(&report);out<<"checks="<<checks<<"\npassed="<<errors.isEmpty()<<"\nmaxTipErrorMm="<<maxError*1000
        <<"\nremovedCm3="<<stock.removed()<<"\nreference="<<frame["reference"].toString()
        <<"\nxDirectionSamples="<<xSamples<<"\nyDirectionSamples="<<ySamples
        <<"\nspoilboard="<<spoil<<"\ntoolLength="<<toolLength<<"\n"<<errors;
    return errors.isEmpty()?0:1;
}
