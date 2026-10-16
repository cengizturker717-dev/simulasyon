#pragma once
#include <QQuickWindow>
#include <QJsonDocument>
#include <QTextStream>
#include "../Machining.h"

// Exercises the real QML scene with local snapshots only; never sends CNI commands.
inline int runStartFrameChecks(QQuickWindow* window,Motion& motion,Pcni& pcni,StockGeometry& stock,Machining& machining,const QVariantMap& frame,const QString& directory,const QString& tracePath) {
    QDir().mkpath(directory);int checks=0;QString errors;
    auto check=[&](bool ok,const QString& name){++checks;if(!ok)errors+=name+"\n";};
    auto update=[&]{QCoreApplication::processEvents();};
    auto bridge=[&]{return window->property("testBridge").toDouble();};
    auto carriage=[&]{return window->property("testCarriagePosition").value<QVector3D>();};
    auto router=[&]{return window->property("testRouterPosition").value<QVector3D>();};
    update();const double idleBridge=bridge();const auto idleCarriage=carriage(),idleRouter=router();
    motion.setLiveAxes(0,0,-280);update();
    check(std::abs(bridge()-idleBridge)<.000001&&(carriage()-idleCarriage).length()<.000001&&(router()-idleRouter).length()<.000001,"connecting at machine zero preserves the offline idle pose");
    QMetaObject::invokeMethod(window,"topView");update();
    const double homeBridge=bridge();const auto homeCarriage=carriage(),homeRouter=router();
    window->grabWindow().save(directory+"/before-start.png");
    auto samePose=[&]{update();return std::abs(bridge()-homeBridge)<.000001&&(carriage()-homeCarriage).length()<.000001&&(router()-homeRouter).length()<.000001;};
    QJsonObject snapshot{{"x",0.0},{"y",0.0},{"z",-280.0},{"metadataValid",true},{"workValid",true},{"panelFrameValid",true},
        {"spoilboard",18.0},{"workX",-786.95},{"workY",9.6},{"workZ",-56.0},{"executing",true},{"program",pcni.root()+"/User/Prog/Delikli_S01.pcni"}};
    machining.snapshot(snapshot);update();
    check(frame["calibrated"].toBool(),"setup frame calibrated from registered origin and spindle data");
    check(pcni.property("ready").toBool()&&samePose(),"Start with stationary physical axes preserves bridge and both heads");
    check(stock.stockWidth()==2800&&stock.stockHeight()==2100,"Start loads actual panel dimensions");
    check(machining.stockX()==-1.017&&machining.stockZ()==-1.2046434,"panel zero is the fixed table corner");
    window->grabWindow().save(directory+"/after-start.png");
    snapshot["workX"]=-1500.0;snapshot["workY"]=-500.0;snapshot["workZ"]=-90.0;
    snapshot["originX"]=1500.0;snapshot["originY"]=500.0;machining.snapshot(snapshot);
    check(samePose(),"work-origin and tool correction changes cannot move stationary CAD axes");
    snapshot["executing"]=false;machining.snapshot(snapshot);check(samePose(),"Stop preserves physical pose");
    snapshot["executing"]=true;snapshot["program"]=pcni.root()+"/User/Prog/Test366_S01.pcni";machining.snapshot(snapshot);
    check(pcni.property("ready").toBool()&&stock.stockWidth()==3660&&samePose(),"different panel dimensions preserve machine pose");
    check(machining.stockX()==-1.017&&machining.stockZ()==-1.2046434,"different panel dimensions preserve the same corner");
    window->grabWindow().save(directory+"/larger-panel.png");
    motion.setLiveAxes(100,120,-260);update();
    check(std::abs(bridge()-homeBridge-.1)<.000001&&std::abs(carriage().z()-homeCarriage.z()-.12)<.000001&&std::abs(carriage().y()-homeCarriage.y()+.02)<.000001,"only measured XYZ motion changes CAD pose with correct scale and Z direction");
    motion.endLive();machining.disconnectLive();update();check(std::abs(bridge()-homeBridge-.1)<.000001&&(carriage()-homeCarriage-QVector3D(.1,-.02,.12)).length()<.000001,"telemetry disconnect alone cannot teleport CAD");
    // The actual recorded drill/router cycle must still align with the fixed
    // table corner after replacing the old work-mode pose shortcut.
    int aligned=0;double maxXY=0,maxZ=0;
    QFile trace(tracePath);if(trace.open(QIODevice::ReadOnly))while(!trace.atEnd()) {
        const auto document=QJsonDocument::fromJson(trace.readLine());if(!document.isObject())continue;
        const auto o=document.object();motion.setLiveAxes(o["x"].toDouble(),o["y"].toDouble(),o["z"].toDouble());machining.snapshot(o);
        if(!machining.status().startsWith("Canlı işleme")||machining.depth()<=0)continue;
        const bool drill=machining.drilling();const auto first=machining.activeDrills().isEmpty()?QVariantMap():machining.activeDrills().first().toMap();
        const auto p=drill?carriage():router();
        const double tx=p.x()+(drill?.048644+first["mountX"].toDouble()/1000:.02517972);
        const double ty=p.y()+(drill?.6737665:.57505423);
        const double tz=p.z()+(drill?.073707+first["mountY"].toDouble()/1000:-.21110186);
        maxXY=std::max(maxXY,std::hypot(tx-machining.stockX()-machining.workX()/1000,tz-machining.stockZ()-machining.workY()/1000));
        maxZ=std::max(maxZ,std::abs(ty-machining.stockY()-(stock.thickness()-machining.depth())/1000));++aligned;
    }
    check(aligned>0&&maxXY<.0001&&maxZ<.0001,"real recorded FAM/router tips remain aligned with stock in the fixed machine frame");
    stock.flush();window->grabWindow().save(directory+"/recorded-cycle.png");
    QFile report(directory+"/checks.txt");report.open(QIODevice::WriteOnly);QTextStream out(&report);
    out<<"checks="<<checks<<"\npassed="<<errors.isEmpty()<<"\nalignedCuttingSamples="<<aligned<<"\nmaxXYErrorMm="<<maxXY*1000<<"\nmaxZErrorMm="<<maxZ*1000<<"\ncompletedHoles="<<machining.completedHoles()<<"\n"<<errors;
    return errors.isEmpty()?0:1;
}
