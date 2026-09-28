#pragma once
#include <QObject>
#include <QTimer>
#include <QElapsedTimer>
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
public:
    explicit Motion(QObject *parent=nullptr) : QObject(parent) {
        timer.setTimerType(Qt::PreciseTimer);
        timer.setInterval(16);
        connect(&timer, &QTimer::timeout, this, [this] {
            phase += elapsed.restart() / 1000.0 * rate * 0.35;
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
    void setSpeed(double value) {if(std::isfinite(value)){rate=std::clamp(value,0.25,3.0); emit changed();}}
    Q_INVOKABLE void setAxis(int axis, double value) {
        if(!std::isfinite(value) || axis<0 || axis>3) return;
        pause();
        if(axis==0) px=std::clamp(value,0.0,3660.0);
        if(axis==1) py=std::clamp(value,0.0,2100.0);
        if(axis==2) pz=std::clamp(value,0.0,120.0);
        if(axis==3) plift=std::clamp(value,0.0,500.0);
        emit changed();
    }
    Q_INVOKABLE void play() {elapsed.start();timer.start();emit changed();}
    Q_INVOKABLE void pause() {timer.stop();emit changed();}
    Q_INVOKABLE void reset() {pause();phase=0;px=0;py=1050;pz=60;plift=0;emit changed();}
signals:
    void changed();
private:
    QTimer timer;
    QElapsedTimer elapsed;
    double px=0,py=1050,pz=60,plift=0,rate=1,phase=0;
};
