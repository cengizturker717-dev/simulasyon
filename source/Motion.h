#pragma once
#include <QObject>
#include <QTimer>
#include <QElapsedTimer>
#include <QVariantList>
#include <cmath>
#include <algorithm>

class Motion : public QObject {
    Q_OBJECT
    Q_PROPERTY(double x READ x NOTIFY changed)
    Q_PROPERTY(double y READ y NOTIFY changed)
    Q_PROPERTY(double z READ z NOTIFY changed)
    Q_PROPERTY(double lift READ lift NOTIFY changed)
    Q_PROPERTY(bool running READ running NOTIFY changed)
    Q_PROPERTY(double speed READ speed WRITE setSpeed NOTIFY changed)
    Q_PROPERTY(bool programMode READ programMode NOTIFY changed)
    Q_PROPERTY(bool cutting READ cutting NOTIFY changed)
    Q_PROPERTY(bool liveMode READ liveMode NOTIFY changed)
public:
    explicit Motion(QObject *parent=nullptr) : QObject(parent) {
        timer.setTimerType(Qt::PreciseTimer);
        timer.setInterval(33);
        connect(&timer, &QTimer::timeout, this, [this] {
            const double dt=std::min(elapsed.restart()/1000.0,0.1);
            if(programMode()) {
                double remaining=dt*rate*200; // Preview speed in mm/s, not CNC feed.
                while(remaining>0 && next<route.size()) {
                    auto p=route[next].toMap(); double tx=p["x"].toDouble(),ty=p["y"].toDouble();
                    double oldX=px,oldY=py;bool travel=p.value("travel",false).toBool();isCutting=!travel;
                    double distance=std::hypot(tx-px,ty-py);
                    if(distance<=remaining) {px=tx;py=ty;remaining-=distance;++next;}
                    else {px+=(tx-px)*remaining/distance;py+=(ty-py)*remaining/distance;remaining=0;}
                    emit swept(oldX,oldY,px,py,travel);
                }
                if(next>=route.size()) timer.stop();
                emit changed(); return;
            }
            phase += dt * rate * 0.35;
            px=1830-1700*std::cos(phase);
            py=1050+900*std::sin(phase*0.63);
            pz=60+50*std::sin(phase*1.7);
            plift=250+250*std::sin(phase*0.4);
            emit changed();
        });
    }
    double lift() const {return plift;}
    double x() const {return px;} double y() const {return py;} double z() const {return pz;}
    bool running() const {return timer.isActive();} double speed() const {return rate;}
    bool programMode() const {return !route.isEmpty();}
    bool cutting() const {return isCutting;}
    bool liveMode() const {return live;}
    Q_INVOKABLE void setLiveAxes(double rawX,double rawY,double rawZ) {
        if(!std::isfinite(rawX)||!std::isfinite(rawY)||!std::isfinite(rawZ))return;
        pause();route.clear();live=true;isCutting=false;
        // Machine data limits: X -34..5235, Y -240..2310, Z -295..46.
        // Map full configured strokes into this lightweight model's visual strokes.
        px=std::clamp((rawX+34.0)/5269.0*3660.0,0.0,3660.0);
        py=std::clamp((rawY+240.0)/2550.0*2100.0,0.0,2100.0);
        pz=std::clamp((rawZ+295.0)/341.0*120.0,0.0,120.0);
        emit changed();
    }
    Q_INVOKABLE void endLive() {if(live){live=false;emit changed();}}
    Q_INVOKABLE bool loadPath(const QVariantList& points) {
        pause();
        live=false;
        for(const auto& value:points) {
            auto p=value.toMap(); bool okX=false,okY=false;
            double x=p.value("x").toDouble(&okX),y=p.value("y").toDouble(&okY);
            if(!okX||!okY||!std::isfinite(x)||!std::isfinite(y)||x<0||x>3660||y<0||y>2100) return false;
        }
        if(points.size()<2) return false;
        route=points; reset(); return true;
    }
    Q_INVOKABLE void clearPath() {pause();route.clear();reset();}
    void setSpeed(double value) {if(std::isfinite(value)){rate=std::clamp(value,0.25,3.0); emit changed();}}
    Q_INVOKABLE void setAxis(int axis, double value) {
        if(!std::isfinite(value) || axis<0 || axis>3) return;
        if(programMode()||liveMode()) return;
        pause();
        if(axis==0) px=std::clamp(value,0.0,3660.0);
        if(axis==1) py=std::clamp(value,0.0,2100.0);
        if(axis==2) pz=std::clamp(value,0.0,120.0);
        if(axis==3) plift=std::clamp(value,0.0,500.0);
        emit changed();
    }
    Q_INVOKABLE void play() {if(liveMode())return;if(programMode() && next>=route.size()) reset();elapsed.start();timer.start();emit changed();}
    Q_INVOKABLE void pause() {timer.stop();emit changed();}
    Q_INVOKABLE void reset() {if(liveMode())return;pause();phase=0;px=0;py=1050;pz=60;plift=0;next=1;isCutting=false;if(programMode()){auto p=route.first().toMap();px=p["x"].toDouble();py=p["y"].toDouble();}emit routeReset();emit changed();}
signals:
    void changed();
    void swept(double ax,double ay,double bx,double by,bool travel);
    void routeReset();
private:
    QTimer timer;
    QElapsedTimer elapsed;
    QVariantList route;
    bool isCutting=false,live=false;
    qsizetype next=1;
    double px=0,py=1050,pz=60,plift=0,rate=1,phase=0;
};
