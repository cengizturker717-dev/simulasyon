#pragma once
#include <QtQuick3D/qquick3dinstancing.h>
#include <QtQml/qqmlregistration.h>
#include <algorithm>
class GridInstances : public QQuick3DInstancing {
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int columns MEMBER columns NOTIFY gridChanged)
    Q_PROPERTY(int rows MEMBER rows NOTIFY gridChanged)
    Q_PROPERTY(QVector3D start MEMBER start NOTIFY gridChanged)
    Q_PROPERTY(QVector3D columnStep MEMBER columnStep NOTIFY gridChanged)
    Q_PROPERTY(QVector3D rowStep MEMBER rowStep NOTIFY gridChanged)
    Q_PROPERTY(QVector3D dimensions MEMBER dimensions NOTIFY gridChanged)
    Q_PROPERTY(QVector3D rotation MEMBER rotation NOTIFY gridChanged)
public:
    explicit GridInstances(QQuick3DObject *parent=nullptr) : QQuick3DInstancing(parent) {
        connect(this,&GridInstances::gridChanged,this,[this]{dirty=true;markDirty();});
    }
signals:
    void gridChanged();
protected:
    QByteArray getInstanceBuffer(int *count) override {
        if(dirty) {
            buffer.clear();
            for(int row=0;row<std::clamp(rows,0,1000);++row)
                for(int col=0;col<std::clamp(columns,0,1000);++col) {
                    const auto entry=calculateTableEntry(start+columnStep*col+rowStep*row,dimensions/100,rotation,Qt::white);
                    buffer.append(reinterpret_cast<const char*>(&entry),sizeof(entry));
                }
            dirty=false;
        }
        *count=buffer.size()/sizeof(InstanceTableEntry);
        return buffer;
    }
private:
    int columns=1,rows=1;
    QVector3D start,columnStep,rowStep,dimensions{100,100,100},rotation;
    QByteArray buffer;
    bool dirty=true;
};
