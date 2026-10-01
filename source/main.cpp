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
#include <vector>
#include "Motion.h"
#include "Pcni.h"
#include "StockGeometry.h"
#include "LiveCni.h"
#include "MachineData.h"

int main(int argc,char **argv) {
    QGuiApplication app(argc,argv);
    app.setApplicationName("SolidSim Native");
    app.setOrganizationName("Poyraz Prototype");
    QQuickStyle::setStyle("Basic");
    const auto args=app.arguments();
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
        motion.configureAxisRanges(-34,5235,0,-240,2310,100,-295,46,-270);
        motion.setLiveAxes(0,100,-270);
        if(motion.x()!=0 || motion.y()!=1050 || motion.z()!=60 || !motion.liveMode()) return 9;
        motion.endLive();
        motion.setAxis(0,-10); if(motion.x()!=0) return 10;
        motion.setAxis(1,9000); if(motion.y()!=2100) return 11;
        motion.setAxis(2,900); if(motion.z()!=120) return 12;
        motion.setSpeed(99); if(motion.speed()!=3) return 13;
        motion.reset(); if(motion.running() || motion.x()!=0 || motion.y()!=1050) return 14;
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
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("motion",&motion);
    engine.rootContext()->setContextProperty("pcni",&pcni);
    engine.rootContext()->setContextProperty("cni",&cni);
    engine.rootContext()->setContextProperty("stock",&stock);
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
    const int pcniIndex=args.indexOf("--pcni");
    if(pcniIndex>=0 && pcniIndex+1<args.size()) {
        pcni.load(args[pcniIndex+1]);
        if(args.contains("--material")) {
            if(pcni.property("ready").toBool()) {
                motion.loadPath(pcni.property("points").toList());
                stock.configure(pcni.property("width").toDouble(),pcni.property("height").toDouble(),pcni.property("thickness").toDouble(),pcni.property("toolDiameter").toDouble());
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
                const bool ok=window->property("motionBound").toBool() && std::abs(bridge-2.35045)<.001 && std::abs(spindle-.65)<.001 && std::abs(vertical-.754551)<.001;
                window->grabWindow().save(directory+"/moved.png");
                QFile f(directory+"/motion-test.txt"); if(f.open(QIODevice::WriteOnly)) { QTextStream o(&f); o<<"passed="<<ok<<"\nbridge_m="<<bridge<<"\nspindle_m="<<spindle<<"\nspindle_height_m="<<vertical<<"\nlift_delta_m="<<lift-initialLift<<"\n"; }
                motion.reset(); app.exit(ok?0:30);
            });
        });
    }
    const int benchmarkIndex=args.indexOf("--benchmark");
    QElapsedTimer benchmarkClock;
    std::vector<double> benchmarkFrames;
    bool collecting=false;
    if(benchmarkIndex>=0 && benchmarkIndex+1<args.size()) {
        window->setProperty("benchmarkMode",true);
        QMetaObject::invokeMethod(window,"homeView");
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
            }
            app.exit(count?0:31);
        });
        });
    }
    if(args.contains("--demo")) motion.play();
    if(args.contains("--cni-live")) cni.start();
    if(args.contains("--show-machine-data")) QTimer::singleShot(1000,&app,[&]{QMetaObject::invokeMethod(window,"showMachineData");});
    if(args.contains("--inspection")) QTimer::singleShot(12000,&app,[&]{QMetaObject::invokeMethod(window,"inspectionView");});
    const int captureIndex=args.indexOf("--capture");
    if(captureIndex>=0 && captureIndex+1<args.size()) {
        if(!args.contains("--model")) motion.play();
        QTimer::singleShot(18000,&app,[&]{
            const auto image=window->grabWindow();
            bool ok=!image.isNull() && image.save(args[captureIndex+1]);
            if(args.contains("--material") && motion.programMode()) {
                const double tipX=window->property("testBridge").toDouble()+0.02517972;
                const double tipY=window->property("testZ").toDouble()+0.57505423;
                const double tipZ=window->property("testSpindle").toDouble()-0.21110186;
                const double desiredY=1.0825051+(motion.cutting()?stock.thickness()-stock.depth():stock.thickness()+30)/1000;
                const bool aligned=std::abs(tipX-(-0.3099066+motion.x()/1000))<0.0001
                    && std::abs(tipZ-(-1.2046434+motion.y()/1000))<0.0001 && std::abs(tipY-desiredY)<0.0001;
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
                    << "\ncniOriginNumber=" << cni.originNumber()
                    << "\ncniOriginX=" << cni.property("originX").toDouble()
                    << "\ncniOriginY=" << cni.property("originY").toDouble()
                    << "\ncniOriginZ=" << cni.property("originZ").toDouble()
                    << "\ncniToolReference=" << cni.property("toolReference").toInt()
                    << "\nmodelState=" << window->property("modelState").toString()
                    << "\ncapture=" << ok << "\n";
            }
            motion.pause();
            app.exit(ok?0:3);
        });
    }
    return app.exec();
}
