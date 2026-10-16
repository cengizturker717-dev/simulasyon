#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QQuickStyle>
#include <QImage>
#include <QFile>
#include <QFileInfo>
#include <QPointer>
#include <QTextStream>
#include <QQuickItem>
#include <QWheelEvent>
#include <QDir>
#include <cstring>
#include <vector>
#include <memory>
#include <functional>
#include "Motion.h"
#include "Pcni.h"
#include "StockGeometry.h"
#include "LiveCni.h"
#include "MachineData.h"
#include "Machining.h"
#include "SceneFrame.h"
#include "VigorProfile.h"
#include "tools/machining_checks.h"
#include "tools/start_frame_checks.h"
#include "tools/router_frame_checks.h"
#include "tools/visual_performance_checks.h"
#include "tools/drill_rig_checks.h"
#include "tools/pose_capture_checks.h"
#include <QJsonArray>
#include <QJsonDocument>

int main(int argc,char **argv) {
    QGuiApplication app(argc,argv);
    app.setApplicationName("SolidSim Native");
    app.setOrganizationName("Poyraz Prototype");
    QQuickStyle::setStyle("Basic");
    const auto args=app.arguments();
    const int machiningTestIndex=args.indexOf("--machining-test");
    if(machiningTestIndex>=0) return runMachiningChecks(args.value(machiningTestIndex+1,QDir::tempPath()+"/SolidSim-machining-checks.txt"));
    Motion motion;
    Pcni pcni;
    MachineData machineData;
    auto applyRanges=[&]{motion.configureAxisRanges(
        machineData.axisMin(0),machineData.axisMax(0),machineData.axisReference(0),
        machineData.axisMin(1),machineData.axisMax(1),machineData.axisReference(1),
        machineData.axisMin(2),machineData.axisMax(2),machineData.axisReference(2));};
    QObject::connect(&machineData,&MachineData::changed,&motion,applyRanges);applyRanges();
    LiveCni cni;
    QObject::connect(&cni,&LiveCni::axes,&motion,&Motion::setLiveAxes);
    QObject::connect(&cni,&LiveCni::disconnected,&motion,&Motion::endLive);
    if(args.contains("--cni-probe")) {
        cni.start();
        QTimer::singleShot(4000,&app,[&]{qInfo()<<cni.status()<<cni.property("x")<<cni.property("y")<<cni.property("z");app.exit(cni.fresh()?0:60);});
        return app.exec();
    }
    StockGeometry stock;
    Machining machining(motion,pcni,stock);
    QObject::connect(&cni,&LiveCni::snapshot,&machining,&Machining::snapshot);
    QObject::connect(&cni,&LiveCni::disconnected,&machining,&Machining::disconnectLive);
    QObject::connect(&motion,&Motion::swept,&stock,&StockGeometry::cut);
    QObject::connect(&motion,&Motion::routeReset,&stock,&StockGeometry::reset);
    if(args.contains("--stock-test")) {
        stock.configure(100,80,18,8);
        stock.cut(10,40,90,40,true);if(stock.removed()!=0)return 50;
        stock.setDepth(6);stock.cut(10,40,90,40,false);
        if(stock.heightAt(50,40)!=12 || stock.heightAt(50,10)!=18 || stock.removed()<=0)return 51;
        double volume=stock.removed();stock.cut(10,40,90,40,false);if(stock.removed()!=volume)return 52;
        stock.setDepth(18);stock.cut(10,40,90,40,false);stock.flush();
        if(stock.heightAt(50,40)!=0||stock.heightAt(50,10)!=18)return 53;
        stock.reset();if(stock.removed()!=0||stock.heightAt(50,40)!=18)return 54;
        stock.configure(2800,2100,18,8);QElapsedTimer t;t.start();
        stock.cut(0,600,2700,600,false);stock.flush();qInfo()<<"stock update ms"<<t.elapsed();return 0;
    }
    const int stockPerformanceIndex=args.indexOf("--stock-performance-test");
    if(stockPerformanceIndex>=0&&stockPerformanceIndex+1<args.size()) {
        // Compare rendered surfaces against the height field after partial and
        // through cuts, including cuts crossing tile boundaries and plate edges.
        auto verifySurface=[&] {
            const auto bytes=stock.vertexData();
            struct TestVertex {float x,y,z,nx,ny,nz,r,g,b,a;};
            double topIntegral=0,topArea=0,bottomArea=0,walls=0;
            for(qsizetype i=0;i+qsizetype(3*sizeof(TestVertex))<=bytes.size();i+=3*sizeof(TestVertex)) {
                TestVertex v[3];std::memcpy(v,bytes.constData()+i,sizeof v);
                QVector3D a(v[0].x,v[0].y,v[0].z),b(v[1].x,v[1].y,v[1].z),c(v[2].x,v[2].y,v[2].z);
                double area=QVector3D::crossProduct(b-a,c-a).length()/2;
                if(v[0].ny>.5){topArea+=area;topIntegral+=area*std::max(0.0,double(v[0].y));}
                else if(v[0].ny<-.5)bottomArea+=area;
                else walls+=area;
            }
            double integral=0,bottom=0,wallArea=0;
            for(int y=0;y<280;y+=2)for(int x=0;x<300;x+=2) {
                double h=stock.heightAt(x+1,y+1);integral+=h*4;if(h>0)bottom+=4;
                for(auto offset:{QPoint(-2,0),QPoint(2,0),QPoint(0,-2),QPoint(0,2)})
                    wallArea+=std::max(0.0,h-double(stock.heightAt(x+1+offset.x(),y+1+offset.y())))*2;
            }
            return std::abs(topArea-84000)<.01&&std::abs(topIntegral-integral)<.1
                &&std::abs(bottomArea-bottom)<.01&&std::abs(walls-wallArea)<.1;
        };
        stock.configure(300,280,18,8);stock.setDepth(6);
        for(int i=0;i<80;++i)stock.cut((i*37)%300,(i*23)%280,(i*79+128)%300,(i*47+128)%280,false);
        stock.flush();bool partial=verifySurface();
        stock.setDepth(18);
        for(int i=0;i<80;++i)stock.cut((i*37)%300,(i*23)%280,(i*79+128)%300,(i*47+128)%280,false);
        stock.flush();bool through=verifySurface();
        stock.configure(3660,2100,18,8);
        const int flatTriangles=stock.triangleCount();
        std::vector<double> updates;
        for(int i=0;i<100;++i) {
            double x=100+(i*31)%3400,y=100+(i*47)%1900;
            stock.cut(x,y,x+40,y+30,false);stock.flush();updates.push_back(stock.rebuildMilliseconds());
        }
        std::sort(updates.begin(),updates.end());
        QFile report(args[stockPerformanceIndex+1]);
        if(!report.open(QIODevice::WriteOnly))return 58;
        QTextStream out(&report);
        out<<"partial_surface_passed="<<partial<<"\nthrough_surface_passed="<<through
           <<"\ncell_mm=2\nflat_triangles="<<flatTriangles<<"\ncut_triangles="<<stock.triangleCount()
           <<"\nlast_updated_tiles="<<stock.rebuiltTileCount()<<"\nmedian_update_ms="<<updates[50]
           <<"\np95_update_ms="<<updates[94]<<"\nmax_update_ms="<<updates.back()<<"\n";
        return partial&&through&&stock.rebuiltTileCount()<20?0:57;
    }
    const int dataIndex=args.indexOf("--machine-data");
    if(dataIndex>=0 && dataIndex+1<args.size()){pcni.setRoot(args[dataIndex+1]);machineData.setRoot(args[dataIndex+1]);}
    if(args.contains("--machine-data-test")){
        qInfo()<<machineData.status()<<"rear origins"<<machineData.rearLeftOrigin()<<machineData.rearRightOrigin();
        return machineData.axes().size()>=3&&machineData.origins().size()>=1&&machineData.tools().size()>=1?0:41;
    }
    if(args.contains("--pcni-test")) {
        int failed=0,labels=0,points=0;
        for(const auto& name:pcni.programs()) {
            bool ok=pcni.load(name);
            labels+=pcni.property("labels").toList().size(); points+=pcni.property("points").toList().size();
            if(!ok) {++failed; qWarning()<<name<<pcni.property("status").toString();}
        }
        qInfo()<<"programs"<<pcni.programs().size()<<"labels"<<labels<<"points"<<points<<"failed"<<failed;
        return pcni.programs().isEmpty()||failed?40:0;
    }
    if(args.contains("--self-test")) {
        motion.configureAxisRanges(-34,5235,0,-240,2310,0,-295,46,-280);
        motion.setLiveAxes(0,0,-280);
        if(motion.x()!=0 || motion.y()!=0 || motion.z()!=60 || !motion.liveMode()) return 9;
        // Live zero, midpoint, full stroke and configured reference must agree
        // with manual Y coordinates, without the demo midpoint offset.
        motion.setLiveAxes(0,1050,-280);if(motion.y()!=1050)return 23;
        motion.setLiveAxes(0,2100,-280);if(motion.y()!=2100)return 24;
        motion.setLiveAxes(0,-240,-280);if(motion.y()!=0)return 25;
        motion.setLiveAxes(0,2310,-280);if(motion.y()!=2100)return 26;
        motion.configureAxisRanges(-34,5235,0,-240,2310,100,-295,46,-280);
        motion.setLiveAxes(0,100,-280);if(motion.y()!=0)return 27;
        motion.setLiveAxes(0,1150,-280);if(motion.y()!=1050)return 28;
        motion.configureAxisRanges(-34,5235,0,-240,2310,0,-295,46,-280);
        motion.endLive();
        motion.setAxis(0,9000); if(motion.x()!=5235) return 22;
        motion.setAxis(0,-10); if(motion.x()!=0) return 10;
        motion.setAxis(1,9000); if(motion.y()!=2100) return 11;
        motion.setAxis(2,900); if(motion.z()!=120) return 12;
        motion.setSpeed(99); if(motion.speed()!=10) return 13;
        motion.reset(); if(motion.running() || motion.x()!=0 || motion.y()!=0) return 14;
        QVariantList sample{QVariantMap{{"x",100.0},{"y",200.0}},QVariantMap{{"x",102.0},{"y",200.0}}};
        if(!motion.loadPath(sample) || !motion.programMode() || motion.x()!=100 || motion.y()!=200) return 16;
        if(motion.loadPath({QVariantMap{{"x",-1},{"y",0}},sample.last()})) return 17;
        motion.clearPath(); if(motion.programMode()) return 18;
        motion.play();
        QTimer::singleShot(250,&app,[&] {
            bool ok=motion.running() && motion.x()>0 && motion.x()<=3660;
            motion.pause();
            if(!ok || motion.running()) {app.exit(15);return;}
            motion.loadPath({QVariantMap{{"x",100.0},{"y",200.0}},QVariantMap{{"x",102.0},{"y",200.0}}});
            motion.play();
            QTimer::singleShot(250,&app,[&]{
                bool ended=!motion.running() && motion.x()==102 && motion.y()==200 && motion.z()==60;
                motion.reset();
                app.exit(ended && motion.x()==100 && motion.programMode()?0:19);
            });
        });
        return app.exec();
    }
    VigorProfile profile(!args.contains("--capture")&&!args.contains("--start-frame-test")&&!args.contains("--router-frame-test")&&!args.contains("--benchmark")&&!args.contains("--visual-performance-test")&&!args.contains("--router-visual-test")&&!args.contains("--drill-rig-test")&&!args.contains("--batch-visual-test")&&!args.contains("--pose-capture"));
    const int profileIndex=args.indexOf("--vigor-profile");
    if(profileIndex>=0)profile.select(args.value(profileIndex+1));
    if(dataIndex>=0&&dataIndex+1<args.size())profile.assignData(args[dataIndex+1]);
    QQmlApplicationEngine engine;
    QVariantMap sceneFrame;
    auto applyProfile=[&]{
        cni.stop();machining.clearPreview();
        motion.setWorkLength(profile.length());pcni.setWorkLength(profile.length());
        machineData.setRoot(profile.dataRoot());pcni.setRoot(profile.dataRoot());
        cni.setStartAllowed(profile.dataAssigned());
        sceneFrame=machineSceneFrame(machineData.root(),machineData.axisReference(0),machineData.axisReference(1),machineData.axisReference(2));
        engine.rootContext()->setContextProperty("sceneFrame",sceneFrame);
    };
    QObject::connect(&profile,&VigorProfile::changed,&engine,applyProfile);applyProfile();
    engine.rootContext()->setContextProperty("vigorProfile",&profile);
    engine.rootContext()->setContextProperty("motion",&motion);
    engine.rootContext()->setContextProperty("pcni",&pcni);
    engine.rootContext()->setContextProperty("cni",&cni);
    engine.rootContext()->setContextProperty("stock",&stock);
    engine.rootContext()->setContextProperty("machining",&machining);
    engine.rootContext()->setContextProperty("machineData",&machineData);
    QUrl startupModel;
    const int modelIndex=args.indexOf("--model");
    if(modelIndex>=0 && modelIndex+1<args.size()) {
        startupModel=QUrl::fromLocalFile(args.value(modelIndex+1));
    } else {
        const QString bundled=QCoreApplication::applicationDirPath()+"/../assets/catalog/VigorLite.qml";
        if(QFileInfo::exists(bundled)) startupModel=QUrl::fromLocalFile(QFileInfo(bundled).canonicalFilePath());
    }
    engine.rootContext()->setContextProperty("startupModel",startupModel);
    engine.loadFromModule("Poyraz.Native","Main");
    if(engine.rootObjects().isEmpty()) {
        qWarning() << "SolidSimNative: QML root failed";
        return 2;
    }
    auto window=qobject_cast<QQuickWindow*>(engine.rootObjects().first());
    const int batchVisualIndex=args.indexOf("--batch-visual-test");
    if(batchVisualIndex>=0){
        QTimer::singleShot(2000,&app,[&]{app.exit(runVisualPerformanceChecks(window,profile,args.value(batchVisualIndex+1),&motion));});
        return app.exec();
    }
    const int poseCaptureIndex=args.indexOf("--pose-capture");
    if(poseCaptureIndex>=0){
        QTimer::singleShot(2000,&app,[&]{
            const int result=runPoseCaptures(window,profile,motion,args.value(poseCaptureIndex+1),args.value(poseCaptureIndex+2));
            // The magazine rows the data dialog lists, for offline review.
            QFile rows(args.value(poseCaptureIndex+1)+"/magazine.json");
            if(rows.open(QIODevice::WriteOnly))rows.write(QJsonDocument(QJsonArray::fromVariantList(machineData.magazineTools())).toJson());
            app.exit(result);
        });
        return app.exec();
    }
    // Offline review of the program dialog: --dialog-capture <png> [program path]
    const int dialogCaptureIndex=args.indexOf("--dialog-capture");
    if(dialogCaptureIndex>=0){
        QTimer::singleShot(2000,&app,[&]{
            const QString what=args.value(dialogCaptureIndex+2);
            // "data:N" opens the machine data dialog on tab N, anything else is a program.
            if(what.startsWith("data:"))QMetaObject::invokeMethod(window,"showMachineData",Q_ARG(QVariant,QVariant(what.mid(5).toInt())));
            else {QMetaObject::invokeMethod(window,"showPcni");if(!what.isEmpty())pcni.load(what);
                QFile points(args.value(dialogCaptureIndex+1)+".points.json");
                if(points.open(QIODevice::WriteOnly))points.write(QJsonDocument(QJsonArray::fromVariantList(pcni.property("points").toList())).toJson(QJsonDocument::Compact));}
            QTimer::singleShot(1500,&app,[&]{app.exit(window->grabWindow().save(args.value(dialogCaptureIndex+1))?0:1);});
        });
        return app.exec();
    }
    const int drillRigIndex=args.indexOf("--drill-rig-test");
    if(drillRigIndex>=0){
        QTimer::singleShot(2000,&app,[&]{app.exit(runDrillRigChecks(window,motion,pcni,stock,machining,machineData,sceneFrame,args.value(drillRigIndex+1)));});
        return app.exec();
    }
    const int routerVisualIndex=args.indexOf("--router-visual-test");
    if(routerVisualIndex>=0){
        QTimer::singleShot(2000,&app,[&]{app.exit(runRouterVisualChecks(window,motion,args.value(routerVisualIndex+1)));});
        return app.exec();
    }
    const int visualPerformanceIndex=args.indexOf("--visual-performance-test");
    if(visualPerformanceIndex>=0){
        QTimer::singleShot(2000,&app,[&]{app.exit(runVisualPerformanceChecks(window,profile,args.value(visualPerformanceIndex+1)));});
        return app.exec();
    }
    const int routerFrameTestIndex=args.indexOf("--router-frame-test");
    if(routerFrameTestIndex>=0){
        QTimer::singleShot(4000,&app,[&]{app.exit(runRouterFrameChecks(window,motion,pcni,stock,machining,sceneFrame,args.value(routerFrameTestIndex+1)));});
        return app.exec();
    }
    const int frameTestIndex=args.indexOf("--start-frame-test");
    if(frameTestIndex>=0) {
        QTimer::singleShot(4000,&app,[&]{app.exit(runStartFrameChecks(window,motion,pcni,stock,machining,sceneFrame,args.value(frameTestIndex+1),args.value(frameTestIndex+2)));});
        return app.exec();
    }
    const int pcniIndex=args.indexOf("--pcni");
    if(pcniIndex>=0 && pcniIndex+1<args.size()) {
        pcni.load(args[pcniIndex+1]);
        if(args.contains("--material")) {
            if(pcni.property("ready").toBool()) {
                machining.load();
                QTimer::singleShot(1000,&app,[&]{QMetaObject::invokeMethod(window,"homeView");if(args.contains("--demo"))motion.play();});
            }
        } else QTimer::singleShot(1000,&app,[&]{QMetaObject::invokeMethod(window,"showPcni");});
    }
    int frames=0;
    QObject::connect(window,&QQuickWindow::frameSwapped,&app,[&]{++frames;});
    QElapsedTimer fpsClock; fpsClock.start();
    QTimer fpsTimer;
    QObject::connect(&fpsTimer,&QTimer::timeout,&app,[&]{
        window->setProperty("measuredFps",frames*1000.0/fpsClock.restart()); frames=0;
    });
    fpsTimer.start(1000);
    const int cameraTestIndex=args.indexOf("--camera-test");
    QTimer cameraTestTimer;
    int cameraTestStep=0;
    bool cameraTestOk=true;
    std::vector<double> frameIntervals;
    QElapsedTimer frameClock; frameClock.start();
    if(cameraTestIndex>=0 && cameraTestIndex+1<args.size()) {
        const QString directory=args[cameraTestIndex+1];
        QDir().mkpath(directory);
        auto camera=window->findChild<QObject*>("machineCamera");
        auto viewport=window->findChild<QQuickItem*>("machineViewport");
        if(!camera || !viewport) return 20;
        motion.play();
        QObject::connect(window,&QQuickWindow::frameSwapped,&app,[&] {
            const double interval=frameClock.nsecsElapsed()/1000000.0;
            frameClock.restart();
            if(cameraTestStep>5) frameIntervals.push_back(interval);
        });
        QObject::connect(&cameraTestTimer,&QTimer::timeout,&app,[&,camera,viewport,directory] {
            const int step=cameraTestStep++;
            int delta=0;
            if(step<20 || (step>100 && step<=130)) delta=-120;
            if(step>40 && step<=80) delta=120;
            if(delta) {
                const auto point=viewport->mapToScene(QPointF(viewport->width()/2,viewport->height()/2));
                QWheelEvent event(point,window->mapToGlobal(point.toPoint()),QPoint(),QPoint(0,delta),Qt::NoButton,Qt::NoModifier,Qt::NoScrollPhase,false);
                QCoreApplication::sendEvent(window,&event);
            }
            const auto z=camera->property("z").toDouble();
            cameraTestOk &= z>=1199 && z<=10001 && camera->property("clipNear").toDouble()==20 && camera->property("clipFar").toDouble()==60000;
            if(step==40 || step==100 || step==150 || step==170) {
                cameraTestOk &= window->grabWindow().save(directory+QString("/zoom-%1.png").arg(step));
                if(step==40) cameraTestOk &= std::abs(z-10000)<1;
                if(step==100) cameraTestOk &= std::abs(z-1200)<1;
                if(step==150) QMetaObject::invokeMethod(window,"homeView");
            }
            if(step==170) {
                cameraTestOk &= std::abs(z-window->property("homeDistance").toDouble())<1;
                cameraTestTimer.stop();
                std::sort(frameIntervals.begin(),frameIntervals.end());
                QFile report(directory+"/camera-test.txt");
                if(report.open(QIODevice::WriteOnly)) {
                    QTextStream out(&report);
                    out << "passed=" << cameraTestOk << "\nsamples=" << frameIntervals.size();
                    if(!frameIntervals.empty()) out << "\nmedianFrameMs=" << frameIntervals[frameIntervals.size()/2] << "\np95FrameMs=" << frameIntervals[size_t((frameIntervals.size()-1)*0.95)] << "\nmaxFrameMs=" << frameIntervals.back();
                    out << "\nfinalDistance=" << z << "\nclipFar=" << camera->property("clipFar").toDouble() << "\n";
                }
                app.exit(cameraTestOk?0:21);
            }
        });
        cameraTestTimer.start(30);
    }
    const int motionTestIndex=args.indexOf("--motion-test");
    if(motionTestIndex>=0 && motionTestIndex+1<args.size()) {
        const QString directory=args[motionTestIndex+1]; QDir().mkpath(directory);
        motion.reset();
        QTimer::singleShot(4000,&app,[&,directory]{
            window->grabWindow().save(directory+"/rest.png");
            const double initialLift=window->property("testLift").toDouble();
            motion.setAxis(0,3000); motion.setAxis(1,1700); motion.setAxis(2,110); motion.setAxis(3,300);
            QTimer::singleShot(1000,&app,[&,directory,initialLift]{
                const double bridge=window->property("testBridge").toDouble();
                const double spindle=window->property("testSpindle").toDouble();
                const double lift=window->property("testLift").toDouble();
                const double vertical=window->property("testZ").toDouble();
                const bool ok=window->property("motionBound").toBool() && std::abs(bridge-sceneFrame["bridgeHome"].toDouble()-3)<.001 && std::abs(spindle-sceneFrame["carriageHome"].toDouble()-sceneFrame["routerZ"].toDouble()-1.7)<.001 && std::abs(vertical-.754551-sceneFrame["zHome"].toDouble()-sceneFrame["routerY"].toDouble())<.001;
                window->grabWindow().save(directory+"/moved.png");
                QFile f(directory+"/motion-test.txt"); if(f.open(QIODevice::WriteOnly)) { QTextStream o(&f); o<<"passed="<<ok<<"\nbridge_m="<<bridge<<"\nspindle_m="<<spindle<<"\nspindle_height_m="<<vertical<<"\nlift_delta_m="<<lift-initialLift<<"\n"; }
                motion.reset(); app.exit(ok?0:30);
            });
        });
    }
    const int x2000TopIndex=args.indexOf("--x2000-top-check");
    if(x2000TopIndex>=0 && x2000TopIndex+1<args.size()) {
        const QString directory=args[x2000TopIndex+1]; QDir().mkpath(directory);
        motion.reset();
        QTimer::singleShot(4000,&app,[&,directory]{
            motion.setAxis(0,2000);
            QMetaObject::invokeMethod(window,"topView");
            QTimer::singleShot(1500,&app,[&,directory]{
                const double bridge=window->property("testBridge").toDouble();
                const bool ok=window->property("motionBound").toBool()
                    && std::abs(motion.x()-2000)<.001
                    && std::abs(bridge-sceneFrame["bridgeHome"].toDouble()-2)<.001;
                const bool saved=window->grabWindow().save(directory+"/x2000-top.png");
                QFile f(directory+"/x2000-top.txt");
                if(f.open(QIODevice::WriteOnly)) {
                    QTextStream o(&f); o<<"passed="<<(ok&&saved)<<"\nx_mm="<<motion.x()<<"\nbridge_m="<<bridge<<"\nimage_saved="<<saved<<"\n";
                }
                app.exit(ok&&saved?0:32);
            });
        });
    }
    const int rearLimitIndex=args.indexOf("--rear-limit-check");
    if(rearLimitIndex>=0 && rearLimitIndex+1<args.size()) {
        const QString directory=args[rearLimitIndex+1]; QDir().mkpath(directory);
        motion.reset();
        QTimer::singleShot(4000,&app,[&,directory]{
            motion.setAxis(0,5235);
            QMetaObject::invokeMethod(window,"homeView");
            QTimer::singleShot(1500,&app,[&,directory]{
                const bool saved=window->grabWindow().save(directory+"/rear-limit.png");
                QFile f(directory+"/rear-limit.txt");
                if(f.open(QIODevice::WriteOnly)) {
                    QTextStream o(&f); o<<"passed="<<(saved&&std::abs(motion.x()-5235)<.001)<<"\nx_mm="<<motion.x()<<"\nimage_saved="<<saved<<"\n";
                }
                app.exit(saved&&std::abs(motion.x()-5235)<.001?0:33);
            });
        });
    }
    const int ySweepIndex=args.indexOf("--y-sweep-check");
    if(ySweepIndex>=0 && ySweepIndex+1<args.size()) {
        const QString directory=args[ySweepIndex+1]; QDir().mkpath(directory);
        const auto positions=std::make_shared<QList<int>>(QList<int>{0,1050,2100});
        const auto step=std::make_shared<int>(0);
        const auto capture=std::make_shared<std::function<void()>>();
        motion.reset();
        QTimer::singleShot(4000,&app,[&,directory,positions,step,capture]{
            QMetaObject::invokeMethod(window,"homeView");
            *capture=[&,directory,positions,step,capture]{
                if(*step>=positions->size()) { app.exit(0); return; }
                const int y=positions->at((*step)++);
                motion.setAxis(1,y);
                QTimer::singleShot(1000,&app,[&,directory,y,capture]{
                    window->grabWindow().save(directory+QString("/y-%1.png").arg(y));
                    (*capture)();
                });
            };
            (*capture)();
        });
    }
    const int topSweepIndex=args.indexOf("--top-sweep-check");
    if(topSweepIndex>=0 && topSweepIndex+1<args.size()) {
        const QString directory=args[topSweepIndex+1]; QDir().mkpath(directory);
        const auto positions=std::make_shared<QList<int>>(QList<int>{0,1000,2000,3000,3660,5235});
        const auto step=std::make_shared<int>(0);
        const auto capture=std::make_shared<std::function<void()>>();
        motion.reset();
        QTimer::singleShot(4000,&app,[&,directory,positions,step,capture]{
            QMetaObject::invokeMethod(window,"topView");
            *capture=[&,directory,positions,step,capture]{
                if(*step>=positions->size()) { app.exit(0); return; }
                const int x=positions->at((*step)++);
                motion.setAxis(0,x);
                QTimer::singleShot(800,&app,[&,directory,x,capture]{
                    window->grabWindow().save(directory+QString("/top-x%1.png").arg(x));
                    (*capture)();
                });
            };
            (*capture)();
        });
    }
    const int frontSweepIndex=args.indexOf("--front-sweep-check");
    if(frontSweepIndex>=0 && frontSweepIndex+1<args.size()) {
        const QString directory=args[frontSweepIndex+1]; QDir().mkpath(directory);
        const auto positions=std::make_shared<QList<int>>(QList<int>{0,2000,3660,5235});
        const auto step=std::make_shared<int>(0);
        const auto capture=std::make_shared<std::function<void()>>();
        motion.reset();
        QTimer::singleShot(4000,&app,[&,directory,positions,step,capture]{
            QMetaObject::invokeMethod(window,"frontView");
            *capture=[&,directory,positions,step,capture]{
                if(*step>=positions->size()) { app.exit(0); return; }
                const int x=positions->at((*step)++);
                motion.setAxis(0,x);
                QTimer::singleShot(800,&app,[&,directory,x,capture]{
                    window->grabWindow().save(directory+QString("/front-x%1.png").arg(x));
                    (*capture)();
                });
            };
            (*capture)();
        });
    }
    const int inspectionSweepIndex=args.indexOf("--inspection-sweep-check");
    if(inspectionSweepIndex>=0 && inspectionSweepIndex+1<args.size()) {
        const QString directory=args[inspectionSweepIndex+1]; QDir().mkpath(directory);
        const auto positions=std::make_shared<QList<int>>(QList<int>{0,2000,3660,5235});
        const auto step=std::make_shared<int>(0);
        const auto capture=std::make_shared<std::function<void()>>();
        motion.reset();
        QTimer::singleShot(4000,&app,[&,directory,positions,step,capture]{
            QMetaObject::invokeMethod(window,"inspectionView");
            *capture=[&,directory,positions,step,capture]{
                if(*step>=positions->size()) { app.exit(0); return; }
                const int x=positions->at((*step)++);
                motion.setAxis(0,x);
                QTimer::singleShot(900,&app,[&,directory,x,capture]{
                    window->grabWindow().save(directory+QString("/inspection-x%1.png").arg(x));
                    (*capture)();
                });
            };
            (*capture)();
        });
    }
    const int benchmarkIndex=args.indexOf("--benchmark");
    QElapsedTimer benchmarkClock;
    std::vector<double> benchmarkFrames;
    bool collecting=false;
    if(benchmarkIndex>=0 && benchmarkIndex+1<args.size()) {
        window->setProperty("benchmarkMode",true);
        const auto benchmarkViewport=window->findChild<QObject*>("machineViewport");
        if(benchmarkViewport){
            if(auto stats=benchmarkViewport->property("renderStats").value<QObject*>())
                stats->setProperty("extendedDataCollectionEnabled",true);
        }
        QMetaObject::invokeMethod(window,"homeView");
        if(args.contains("--benchmark-stock")) {
            stock.configure(3660,2100,18,8);
            QVariantList route;
            for(int i=0;i<50;++i) {
                const double y=100+i*38;
                route.append(QVariantMap{{"x",i%2?3500.0:100.0},{"y",y},{"travel",false}});
                route.append(QVariantMap{{"x",i%2?100.0:3500.0},{"y",y},{"travel",false}});
            }
            motion.loadPath(route);motion.setSpeed(3);
        }
        motion.play();
        QObject::connect(window,&QQuickWindow::frameSwapped,&app,[&]{
            if(collecting) benchmarkFrames.push_back(benchmarkClock.nsecsElapsed()/1000000.0);
            benchmarkClock.restart();
        });
        QTimer::singleShot(3000,&app,[&]{
        collecting=true;benchmarkClock.start();
        QTimer::singleShot(10000,&app,[&]{
            collecting=false;
            const int count=int(benchmarkFrames.size());
            double sum=0;for(double t:benchmarkFrames)sum+=t;
            std::sort(benchmarkFrames.begin(),benchmarkFrames.end());
            QFile report(args[benchmarkIndex+1]);
            if(report.open(QIODevice::WriteOnly) && count) {
                QTextStream out(&report);
                out<<"frames="<<count<<"\navg_fps="<<count*1000.0/sum<<"\nmedian_ms="<<benchmarkFrames[count/2]<<"\np95_ms="<<benchmarkFrames[size_t((count-1)*.95)]<<"\n";
                const int stalled=std::count_if(benchmarkFrames.begin(),benchmarkFrames.end(),[](double ms){return ms>100;});
                out<<"max_ms="<<benchmarkFrames.back()<<"\nframes_over_100ms="<<stalled
                   <<"\ncutting="<<args.contains("--benchmark-stock")<<"\nviewport_width="<<window->width()
                   <<"\nviewport_height="<<window->height()<<"\nstock_triangles="<<stock.triangleCount()<<"\n";
                const auto viewport=window->findChild<QObject*>("machineViewport");
                if(viewport){
                    const QSize texture=viewport->property("effectiveTextureSize").toSize();
                    out<<"texture_size="<<texture.width()<<"x"<<texture.height()<<"\n"
                       <<"native_resolution="<<(std::abs(texture.width()-viewport->property("width").toDouble()*window->devicePixelRatio())<=1
                           &&std::abs(texture.height()-viewport->property("height").toDouble()*window->devicePixelRatio())<=1)<<"\n";
                    if(auto stats=viewport->property("renderStats").value<QObject*>()){
                        for(const auto& name:{"graphicsAPIName","drawCallCount","drawVertexCount","renderPassCount","meshDataSize","imageDataSize","syncTime","renderPrepareTime","renderTime","lastCompletedGpuTime"})
                            out<<name<<"="<<stats->property(name).toString()<<"\n";
                    }
                }
            }
            app.exit(count?0:31);
        });
        });
    }
    if(args.contains("--demo")) motion.play();
    if(args.contains("--cni-live") || (args.size()==1&&QFileInfo::exists("C:/CNI/Ncone/CnData/Bin/SharedAxCs.dll"))) cni.start();
    if(args.contains("--show-machine-data")) QTimer::singleShot(1000,&app,[&]{QMetaObject::invokeMethod(window,"showMachineData");});
    if(args.contains("--inspection")) QTimer::singleShot(17000,&app,[&]{QMetaObject::invokeMethod(window,"inspectionView");});
    const int captureIndex=args.indexOf("--capture");
    if(captureIndex>=0 && captureIndex+1<args.size()) {
        if(!args.contains("--model") && !args.contains("--cni-live")) motion.play();
        QTimer::singleShot(18000,&app,[&]{
            motion.pause();stock.flush();window->update();QCoreApplication::processEvents();
            const auto image=window->grabWindow();
            bool ok=!image.isNull() && image.save(args[captureIndex+1]);
            if(args.contains("--cni-live")) {
                // Check a direct live startup, before any demo/manual motion
                // has had a chance to repair an incorrect initial QML binding.
                const bool drill=machining.liveJob()&&machining.drilling();
                const double bridge=sceneFrame["bridgeHome"].toDouble()+motion.machineX()/1000;
                const double carriage=sceneFrame["carriageHome"].toDouble()+motion.machineY()/1000+(drill?0:sceneFrame["routerZ"].toDouble());
                const double head=.704551+sceneFrame["zHome"].toDouble()-motion.machineZ()/1000+(drill?0:sceneFrame["routerY"].toDouble());
                ok &= cni.fresh() && motion.liveMode()
                    && std::abs(window->property("testBridge").toDouble()-bridge)<0.0001
                    && std::abs(window->property("testSpindle").toDouble()-carriage)<0.0001
                    && std::abs(window->property("testZ").toDouble()-head)<0.0001;
            }
            if(args.contains("--material") && motion.programMode()) {
                const bool drill=motion.toolKind()=="drill";
                const auto first=motion.activeDrills().isEmpty()?QVariantMap():motion.activeDrills().first().toMap();
                const double tipX=window->property("testBridge").toDouble()+(drill?0.048644+first["mountX"].toDouble()/1000:0.02517972+sceneFrame["routerX"].toDouble());
                const double tipY=window->property("testZ").toDouble()+(drill?0.6737665:0.57505423);
                const double tipZ=window->property("testSpindle").toDouble()+(drill?0.073707+first["mountY"].toDouble()/1000:-0.21110186);
                const double desiredY=1.0825051+(stock.thickness()-motion.toolDepth())/1000;
                const bool aligned=std::abs(tipX-(machining.stockX()+motion.x()/1000))<0.0001
                    && std::abs(tipZ-(machining.stockZ()+motion.y()/1000))<0.0001 && std::abs(tipY-desiredY)<0.0001;
                qInfo()<<"stock/tool alignment"<<aligned<<"removed cm3"<<stock.removed();
                ok &= aligned;
            }
            QFile report(args[captureIndex+1]+".txt");
            if(report.open(QIODevice::WriteOnly)) {
                QTextStream out(&report);
                out << "fps=" << window->property("measuredFps").toDouble()
                    << "\nx=" << motion.x() << "\ny=" << motion.y() << "\nz=" << motion.z()
                    << "\nliveMode=" << motion.liveMode() << "\ncniFresh=" << cni.fresh()
                    << "\ncniRawX=" << cni.property("x").toDouble()
                    << "\ncniRawY=" << cni.property("y").toDouble()
                    << "\ncniRawZ=" << cni.property("z").toDouble()
                    << "\nmodelBridge=" << window->property("testBridge").toDouble()
                    << "\nmodelSpindle=" << window->property("testSpindle").toDouble()
                    << "\nmodelSpindleHeight=" << window->property("testZ").toDouble()
                    << "\ncniOriginNumber=" << cni.originNumber()
                    << "\ncniOriginX=" << cni.property("originX").toDouble()
                    << "\ncniOriginY=" << cni.property("originY").toDouble()
                    << "\ncniOriginZ=" << cni.property("originZ").toDouble()
                    << "\ncniToolReference=" << cni.property("toolReference").toInt()
                    << "\nprogram=" << pcni.property("name").toString()
                    << "\nprogramReady=" << pcni.property("ready").toBool()
                    << "\ntoolDepth=" << machining.depth()
                    << "\ntool=" << machining.tool()
                    << "\nremovedCm3=" << stock.removed()
                    << "\ncompletedHoles=" << machining.completedHoles()
                    << "\nmachiningError=" << machining.error()
                    << "\nmachiningStatus=" << machining.status()
                    << "\nmodelState=" << window->property("modelState").toString()
                    << "\ncapture=" << ok << "\n";
            }
            motion.pause();
            app.exit(ok?0:3);
        });
    }
    return app.exec();
}
