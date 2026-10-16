#pragma once
#include <QEventLoop>
#include <QQuickItem>
#include <QQuickWindow>
#include <QTimer>
#include <QFile>
#include <QTextStream>
#include <QVector3D>
#include <QDir>
#include <cmath>

// Offline visual review of a CAD edit at three manual Z positions. Runs
// before live startup and neither connects to nor commands a controller.
inline int runRouterVisualChecks(QQuickWindow* window, Motion& motion, const QString& directory) {
    QDir().mkpath(directory);
    window->contentItem()->setEnabled(false);
    auto nav=window->findChild<QObject*>("cameraNavigation");
    auto model=window->property("convertedObject").value<QObject*>();
    auto router=model?model->findChild<QObject*>("9KW.001"):nullptr;
    if(!nav||!router)return 1;
    auto origin=nav->property("origin").value<QObject*>();
    if(!origin)return 2;
    nav->setProperty("smoothing",false);nav->setProperty("minimumDistance",300);
    QMetaObject::invokeMethod(nav,"setDistance",Q_ARG(QVariant,QVariant(850)));
    auto settle=[&]{window->update();QEventLoop loop;QTimer::singleShot(350,&loop,&QEventLoop::quit);loop.exec();};
    motion.setAxis(0,1000);motion.setAxis(1,1050);motion.setAxis(2,0);settle();
    const auto initial=window->property("testRouterPosition").value<QVector3D>();
    const auto target=router->property("scenePosition").value<QVector3D>()+QVector3D(0,400,-114);
    origin->setProperty("position",target);origin->setProperty("eulerRotation",QVector3D(-5,-90,0));
    int failures=0;
    for(int z:{0,60,120}) {
        motion.setAxis(2,z);settle();
        const auto actual=window->property("testRouterPosition").value<QVector3D>();
        if(std::abs(actual.x()-initial.x())>1e-6||std::abs(actual.z()-initial.z())>1e-6||std::abs(actual.y()-initial.y()-z/1000.0)>1e-6)++failures;
        if(!window->grabWindow().save(directory+QString("/z-%1.png").arg(z)))++failures;
    }
    QFile report(directory+"/checks.txt");if(!report.open(QIODevice::WriteOnly))return 3;
    QTextStream out(&report);out<<"z_samples=3\nfailures="<<failures<<"\n";
    return failures?4:0;
}

// Offline checks: no CNI reader, injected mouse events or machine commands.
inline int runVisualPerformanceChecks(QQuickWindow* window,VigorProfile& profile,const QString& directory,Motion* reviewMotion=nullptr){
    QDir().mkpath(directory);
    window->contentItem()->setEnabled(false);
    auto nav=window->findChild<QObject*>("cameraNavigation");
    auto camera=window->findChild<QObject*>("machineCamera");
    auto view=window->findChild<QQuickItem*>("machineViewport");
    if(!nav||!camera||!view)return 1;
    auto origin=nav->property("origin").value<QObject*>();if(!origin)return 2;
    nav->setProperty("smoothing",false);
    auto settle=[&]{window->update();QEventLoop loop;QTimer::singleShot(reviewMotion?500:150,&loop,&QEventLoop::quit);loop.exec();};
    auto callDistance=[&](double value){QMetaObject::invokeMethod(nav,"setDistance",Q_ARG(QVariant,QVariant(value)));};
    auto drag=[&](double dx,double dy,bool pan){QMetaObject::invokeMethod(nav,"queueDrag",Q_ARG(QVariant,QVariant(dx)),Q_ARG(QVariant,QVariant(dy)),Q_ARG(QVariant,QVariant(pan)));};
    auto flush=[&]{QMetaObject::invokeMethod(nav,"flushDrag");};
    int failed=0,comparisons=0;qsizetype changedPixels=0;
    QMetaObject::invokeMethod(window,"homeView");settle();
    const auto original=origin->property("eulerRotation").value<QVector3D>();auto expected=original;
    for(int i=0;i<1000;++i){const double dx=i%3-1,dy=i%7==0?80:-.1;drag(dx,dy,false);expected=QVector3D(std::clamp(double(expected.x())-dy*.25,-89.9,0.0),expected.y()-dx*.25,0);}
    const bool deferred=origin->property("eulerRotation").value<QVector3D>()==original;
    flush();const bool rotationEqual=(origin->property("eulerRotation").value<QVector3D>()-expected).length()<.0001;
    if(!deferred||!rotationEqual)++failed;
    const auto initialPan=origin->property("position").value<QVector3D>();auto expectedPan=initialPan;
    const auto right=origin->property("right").value<QVector3D>(),up=origin->property("up").value<QVector3D>();
    const double factor=2*camera->property("z").toDouble()*std::tan(camera->property("fieldOfView").toDouble()*3.141592653589793/360)/std::max(1.0,nav->property("height").toDouble());
    for(int i=0;i<1000;++i){drag(.1,-.2,true);expectedPan=expectedPan+right*float(-.1*factor)+up*float(-.2*factor);}
    flush();const bool panEqual=(origin->property("position").value<QVector3D>()-expectedPan).length()<.001;
    if(!panEqual)++failed;
    // A preset must cancel any outstanding pose rather than being overwritten.
    drag(100,50,false);QMetaObject::invokeMethod(window,"homeView");settle();
    if((origin->property("eulerRotation").value<QVector3D>()-QVector3D(-25,25,0)).length()>.001)++failed;
    callDistance(-1e9);if(std::abs(camera->property("z").toDouble()-nav->property("minimumDistance").toDouble())>.1)++failed;
    callDistance(1e9);if(std::abs(camera->property("z").toDouble()-nav->property("maximumDistance").toDouble())>.1)++failed;
    QFile report(directory+"/checks.txt");if(!report.open(QIODevice::WriteOnly))return 3;QTextStream out(&report);
    out<<"queued_rotation_inputs=1000\nrotation_pose_publications_before_flush="<<(!deferred)
       <<"\nrotation_matches_original="<<rotationEqual<<"\nqueued_pan_inputs=1000\npan_matches_original="<<panEqual<<"\n";
    for(const auto& id:{"2142","2136","2128"}){
        profile.select(id);
        if(reviewMotion){reviewMotion->setAxis(0,profile.length()*.35);reviewMotion->setAxis(1,1050);reviewMotion->setAxis(2,90);}
        for(const auto& preset:{"homeView","topView","frontView","close"}){
            QMetaObject::invokeMethod(window,QString(preset)=="close"?"homeView":preset);
            if(QString(preset)=="close")callDistance(nav->property("minimumDistance").toDouble());
            camera->setProperty("frustumCullingEnabled",false);settle();
            const QPoint point=view->mapToScene(QPointF()).toPoint();
            const QRect region(point,QSize(int(view->width()),int(view->height())));
            auto before=window->grabWindow().copy(region).convertToFormat(QImage::Format_RGB32);
            camera->setProperty("frustumCullingEnabled",reviewMotion?false:true);settle();
            auto after=window->grabWindow().copy(region).convertToFormat(QImage::Format_RGB32);
            qsizetype different=0;
            if(before.isNull()||before.size()!=after.size()){++failed;continue;}
            // Exclude the changing FPS overlay, not any machine pixels.
            for(int y=0;y<before.height();++y){const auto a=reinterpret_cast<const QRgb*>(before.constScanLine(y)),b=reinterpret_cast<const QRgb*>(after.constScanLine(y));
                for(int x=0;x<before.width();++x)if(!(x>=before.width()-150&&y<85)&&a[x]!=b[x])++different;}
            ++comparisons;changedPixels+=different;if(different)++failed;
            out<<id<<"_"<<preset<<"_different_pixels="<<different<<"\n";
            if(QString(id)=="2142"&&QString(preset)=="homeView")after.save(directory+"/home.png");
            if(QString(id)=="2142"&&QString(preset)=="close")after.save(directory+"/close.png");
            if(QString(preset)=="topView"||QString(preset)=="frontView")after.save(directory+"/"+id+"_"+preset+".png");
            if(QString(preset)=="homeView"||QString(preset)=="close")after.save(directory+"/"+id+"_"+preset+".png");
        }
    }
    out<<"image_comparisons="<<comparisons<<"\ndifferent_pixels="<<changedPixels<<"\nfailures="<<failed<<"\n";
    return failed?4:0;
}
