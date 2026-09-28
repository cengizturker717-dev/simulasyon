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

int main(int argc,char **argv) {
    QGuiApplication app(argc,argv);
    app.setApplicationName("SolidSim Native");
    app.setOrganizationName("Poyraz Prototype");
    QQuickStyle::setStyle("Basic");
    const auto args=app.arguments();
    Motion motion;
    if(args.contains("--self-test")) {
        motion.setAxis(0,-10); if(motion.x()!=0) return 10;
        motion.setAxis(1,9000); if(motion.y()!=2100) return 11;
        motion.setAxis(2,900); if(motion.z()!=120) return 12;
        motion.setSpeed(99); if(motion.speed()!=3) return 13;
        motion.reset(); if(motion.running() || motion.x()!=0 || motion.y()!=1050) return 14;
        motion.play();
        QTimer::singleShot(250,&app,[&] {
            bool ok=motion.running() && motion.x()>0 && motion.x()<=3660;
            motion.pause();
            app.exit(ok && !motion.running()?0:15);
        });
        return app.exec();
    }
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("motion",&motion);
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
            cameraTestOk &= z>=5999 && z<=35001 && camera->property("clipNear").toDouble()==20 && camera->property("clipFar").toDouble()==60000;
            if(step==40 || step==100 || step==150 || step==170) {
                cameraTestOk &= window->grabWindow().save(directory+QString("/zoom-%1.png").arg(step));
                if(step==40) cameraTestOk &= std::abs(z-35000)<1;
                if(step==100) cameraTestOk &= std::abs(z-6000)<1;
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
                const bool ok=window->property("motionBound").toBool() && std::abs(bridge-3.0)<.001 && std::abs(spindle-.65)<.001 && std::abs(vertical-.754551)<.001;
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
    const int captureIndex=args.indexOf("--capture");
    if(captureIndex>=0 && captureIndex+1<args.size()) {
        if(!args.contains("--model")) motion.play();
        QTimer::singleShot(18000,&app,[&]{
            const auto image=window->grabWindow();
            bool ok=!image.isNull() && image.save(args[captureIndex+1]);
            QFile report(args[captureIndex+1]+".txt");
            if(report.open(QIODevice::WriteOnly)) {
                QTextStream out(&report);
                out << "fps=" << window->property("measuredFps").toDouble()
                    << "\nx=" << motion.x() << "\ny=" << motion.y() << "\nz=" << motion.z()
                    << "\nmodelState=" << window->property("modelState").toString()
                    << "\ncapture=" << ok << "\n";
            }
            motion.pause();
            app.exit(ok?0:3);
        });
    }
    return app.exec();
}
