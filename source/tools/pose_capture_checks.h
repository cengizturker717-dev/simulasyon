#pragma once
#include <QEventLoop>
#include <QQuickItem>
#include <QQuickWindow>
#include <QTimer>
#include <QFile>
#include <QTextStream>
#include <QVector3D>
#include <QDir>
#include "../VigorProfile.h"

// Offline review captures for mesh edits. Each line of the pose file:
//   name profile axisX axisY axisZ originX originY originZ pitch yaw distance
// Viewport pixels only; no CNI reader, injected input or machine commands.
inline int runPoseCaptures(QQuickWindow* window,VigorProfile& profile,Motion& motion,const QString& directory,const QString& poses){
    QDir().mkpath(directory);
    window->contentItem()->setEnabled(false);
    auto nav=window->findChild<QObject*>("cameraNavigation");
    auto view=window->findChild<QQuickItem*>("machineViewport");
    if(!nav||!view)return 1;
    auto origin=nav->property("origin").value<QObject*>();if(!origin)return 2;
    nav->setProperty("smoothing",false);
    QFile file(poses);if(!file.open(QIODevice::ReadOnly|QIODevice::Text))return 3;
    auto settle=[&](int ms){window->update();QEventLoop loop;QTimer::singleShot(ms,&loop,&QEventLoop::quit);loop.exec();};
    int count=0;QString current;
    while(!file.atEnd()){
        const auto f=QString::fromUtf8(file.readLine()).simplified().split(' ');
        if(f.size()!=11)continue;
        if(f[1]!=current){profile.select(f[1]);current=f[1];settle(800);}
        motion.setAxis(0,f[2].toDouble());motion.setAxis(1,f[3].toDouble());motion.setAxis(2,f[4].toDouble());
        origin->setProperty("position",QVector3D(f[5].toFloat(),f[6].toFloat(),f[7].toFloat()));
        origin->setProperty("eulerRotation",QVector3D(f[8].toFloat(),f[9].toFloat(),0));
        QMetaObject::invokeMethod(nav,"setDistance",Q_ARG(QVariant,QVariant(f[10].toDouble())));
        settle(300);
        const QPoint point=view->mapToScene(QPointF()).toPoint();
        const QRect region(point,QSize(int(view->width()),int(view->height())));
        if(!window->grabWindow().copy(region).save(directory+"/"+f[0]+".png"))return 4;
        ++count;
    }
    QFile report(directory+"/checks.txt");if(!report.open(QIODevice::WriteOnly))return 5;
    QTextStream(&report)<<"captures="<<count<<"\n";
    return count?0:6;
}
