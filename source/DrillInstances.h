#pragma once
#include <QtQuick3D/qquick3dinstancing.h>
#include <QtQml/qqmlregistration.h>
#include <QVariantList>
#include <QSet>
#include <cmath>

// Presentation only: all channels share one draw call. The program's confirmed
// drill operation supplies the plunge, not a command to a physical piston.
class DrillInstances : public QQuick3DInstancing {
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QVariantList tools MEMBER tools NOTIFY rigChanged)
    Q_PROPERTY(QVariantList selected MEMBER selected NOTIFY rigChanged)
    Q_PROPERTY(QVector3D origin MEMBER origin NOTIFY rigChanged)
    Q_PROPERTY(double restTip MEMBER restTip NOTIFY rigChanged)
    Q_PROPERTY(double cutTip MEMBER cutTip NOTIFY rigChanged)
    Q_PROPERTY(bool engaged MEMBER engaged NOTIFY rigChanged)
public:
    explicit DrillInstances(QQuick3DObject* parent=nullptr):QQuick3DInstancing(parent) {
        connect(this,&DrillInstances::rigChanged,this,[this]{dirty=true;markDirty();});
    }
    Q_INVOKABLE QVariantMap toolPose(int channel) const {
        for(const auto& value:tools) {
            const auto tool=value.toMap();if(tool["tool"].toInt()!=channel)continue;
            bool active=false;for(const auto& v:selected)if(v.toMap()["tool"].toInt()==channel){active=engaged;break;}
            const double tip=active?std::min(restTip,cutTip):restTip;
            return {{"x",origin.x()+tool["mountX"].toDouble()/1000},{"y",tip},
                    {"z",origin.z()+tool["mountY"].toDouble()/1000},{"extension",restTip-tip},{"active",active}};
        }
        return {};
    }
signals:void rigChanged();
protected:
    QByteArray getInstanceBuffer(int* count) override {
        if(dirty) {
            buffer.clear();QSet<int> channels;
            auto cylinder=[&](double x,double tip,double z,double diameter,double length){
                if(length<=0||diameter<=0)return;
                const auto entry=calculateTableEntry(QVector3D(x,tip+length/2,z),QVector3D(diameter/100,length/100,diameter/100),QVector3D(),Qt::white);
                buffer.append(reinterpret_cast<const char*>(&entry),sizeof(entry));
            };
            for(const auto& value:tools) {
                const auto tool=value.toMap();const int channel=tool["tool"].toInt();
                const double diameter=tool["diameter"].toDouble()/1000;
                if(channel<=0||channels.contains(channel)||!std::isfinite(diameter)||diameter<=0)continue;
                channels.insert(channel);const auto pose=toolPose(channel);
                const double x=pose["x"].toDouble(),tip=pose["y"].toDouble(),z=pose["z"].toDouble();
                // The exposed tool segment is separate from the pneumatic rod.
                cylinder(x,tip,z,diameter,.030);
                cylinder(x,tip+.030,z,diameter*.55,pose["extension"].toDouble());
            }
            dirty=false;
        }
        *count=buffer.size()/sizeof(InstanceTableEntry);return buffer;
    }
private:
    QVariantList tools,selected;QVector3D origin;
    double restTip=0,cutTip=0;bool engaged=false,dirty=true;QByteArray buffer;
};
