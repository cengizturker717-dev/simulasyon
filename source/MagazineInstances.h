#pragma once

#include <QtQuick3D/qquick3dinstancing.h>
#include <QtQml/qqmlregistration.h>
#include <QVariantList>
#include <algorithm>
#include <cmath>

// Read-only magazine presentation driven by Dati (datmag CMB_* rows, sorted by
// pocket). Every pocket is placed from its own data relative to pocket one:
//  - linear (fixed magazine): XMAG/YMAG millimetres -> scene x/z metres from `origin`
//  - radial (rotary magazine): CrtMAG degrees -> angle around `center`, so a
//    template drawn at `templateAngle` is turned into place.
// One instanced draw call per layer (forks, holders); never writes machine data.
class MagazineInstances : public QQuick3DInstancing {
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QVariantList pockets MEMBER pockets NOTIFY magazineChanged)
    Q_PROPERTY(bool radial MEMBER radial NOTIFY magazineChanged)
    Q_PROPERTY(bool occupiedOnly MEMBER occupiedOnly NOTIFY magazineChanged)
    Q_PROPERTY(QVector3D origin MEMBER origin NOTIFY magazineChanged)
    Q_PROPERTY(double radius MEMBER radius NOTIFY magazineChanged)
    Q_PROPERTY(double baseAngle MEMBER baseAngle NOTIFY magazineChanged)
    Q_PROPERTY(double templateAngle MEMBER templateAngle NOTIFY magazineChanged)
    // +1: CrtMAG grows counter-clockwise seen from above; -1: clockwise.
    Q_PROPERTY(double direction MEMBER direction NOTIFY magazineChanged)
    // 0: the template as is (forks, holders). 1: tool body (#Cylinder) and
    // 2: V tip (#Cone), sized per pocket from datpunt DIAM/LUNG and the V angle.
    Q_PROPERTY(int part MEMBER part NOTIFY magazineChanged)
public:
    explicit MagazineInstances(QQuick3DObject* parent=nullptr):QQuick3DInstancing(parent) {
        connect(this,&MagazineInstances::magazineChanged,this,[this]{dirty=true;markDirty();});
    }
    // Scene position (relative to the model node) of a pocket; used by checks.
    Q_INVOKABLE QVariantList placements() {rebuild();return lastPlacements;}
signals:
    void magazineChanged();
protected:
    QByteArray getInstanceBuffer(int* count) override {
        rebuild();
        *count=int(buffer.size()/sizeof(InstanceTableEntry));
        return buffer;
    }
private:
    void rebuild() {
        if(!dirty)return;
        buffer.clear();lastPlacements.clear();
        const int total=std::min(int(pockets.size()),64);
        if(total>0) {
            const auto first=pockets[0].toMap();
            const double x0=first.value("x").toDouble(),y0=first.value("y").toDouble(),a0=first.value("angle").toDouble();
            for(int index=0;index<total;++index) {
                const auto pocket=pockets[index].toMap();
                if(occupiedOnly&&!pocket.value("occupied").toBool())continue;
                QVector3D position=origin;QVector3D rotation;
                if(radial) {
                    double angle=direction*(pocket.value("angle").toDouble()-a0);
                    if(!std::isfinite(angle))angle=360.0*index/total;
                    angle+=baseAngle;
                    const double r=angle*3.14159265358979323846/180.0;
                    position+=QVector3D(float(std::sin(r)*radius),0,float(std::cos(r)*radius));
                    rotation=QVector3D(0,float(angle-templateAngle),0);
                } else {
                    const double dx=(pocket.value("x").toDouble()-x0)/1000.0,dz=(pocket.value("y").toDouble()-y0)/1000.0;
                    if(std::isfinite(dx)&&std::isfinite(dz))position+=QVector3D(float(dx),0,float(dz));
                }
                QVector3D scale(1,1,1);
                if(part>0) {
                    // Holder template: nose at 0.10 m, gauge plane ~0.14 m above its base.
                    // The tip sits LUNG below the gauge plane; Qt primitives are 100 units.
                    constexpr double nose=.10,gauge=.14;
                    double d=pocket.value("diameter").toDouble()/1000,length=pocket.value("length").toDouble()/1000;
                    if(!(d>0&&d<.1))d=.006;
                    if(!(length>gauge-nose&&length<.4))length=.1;
                    const double tip=gauge-length,angle=pocket.value("tipAngle").toDouble();
                    const double cone=angle>0&&angle<180?(d/2)/std::tan(angle*3.14159265358979323846/360):0;
                    const double coneHeight=std::min(cone,nose-tip);
                    if(part==1) {
                        const double top=nose,bottom=tip+coneHeight;
                        if(top-bottom<=1e-4)continue;
                        position+=QVector3D(0,float((top+bottom)/2),0);
                        scale=QVector3D(float(d/100),float((top-bottom)/100),float(d/100));
                    } else {
                        if(coneHeight<=0)continue;
                        position+=QVector3D(0,float(tip+coneHeight/2),0);
                        scale=QVector3D(float(d/100),float(coneHeight/100),float(d/100));
                        rotation.setX(180);   // apex down
                    }
                }
                const auto entry=calculateTableEntry(position,scale,rotation,Qt::white);
                buffer.append(reinterpret_cast<const char*>(&entry),sizeof(entry));
                lastPlacements.append(QVariantMap{{"pocket",pocket.value("pocket")},{"x",position.x()},{"y",position.y()},{"z",position.z()},{"turn",rotation.y()}});
            }
        }
        dirty=false;
    }
    QVariantList pockets,lastPlacements;
    bool radial=false,occupiedOnly=false,dirty=true;
    QVector3D origin;
    double radius=0,baseAngle=0,templateAngle=0,direction=1;int part=0;
    QByteArray buffer;
};
