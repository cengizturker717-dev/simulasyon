#pragma once
#include <QObject>
#include <QTimer>
#include <QElapsedTimer>
#include <QVariantList>
#include <cmath>
#include <algorithm>

class Motion : public QObject {
    Q_OBJECT
    Q_PROPERTY(double x READ x NOTIFY xChanged)
    Q_PROPERTY(double y READ y NOTIFY yChanged)
    Q_PROPERTY(double z READ z NOTIFY zChanged)
    Q_PROPERTY(double machineX READ machineX NOTIFY machineAxesChanged)
    Q_PROPERTY(double machineY READ machineY NOTIFY machineAxesChanged)
    Q_PROPERTY(double machineZ READ machineZ NOTIFY machineAxesChanged)
    Q_PROPERTY(bool hasMachinePosition READ hasMachinePosition NOTIFY machineAxesChanged)
    Q_PROPERTY(double lift READ lift NOTIFY liftChanged)
    Q_PROPERTY(bool running READ running NOTIFY runningChanged)
    Q_PROPERTY(double speed READ speed WRITE setSpeed NOTIFY speedChanged)
    Q_PROPERTY(bool programMode READ programMode NOTIFY programModeChanged)
    Q_PROPERTY(bool cutting READ cutting NOTIFY cuttingChanged)
    Q_PROPERTY(bool liveMode READ liveMode NOTIFY liveModeChanged)
    Q_PROPERTY(double machineXLimit READ machineXLimit NOTIFY machineXLimitChanged)
    Q_PROPERTY(double workLength READ workLength NOTIFY workspaceChanged)
    Q_PROPERTY(double toolDepth READ toolDepth NOTIFY operationChanged)
    Q_PROPERTY(double toolDiameter READ toolDiameter NOTIFY operationChanged)
    Q_PROPERTY(QString toolKind READ toolKind NOTIFY operationChanged)
    Q_PROPERTY(QString toolName READ toolName NOTIFY operationChanged)
    Q_PROPERTY(int programLine READ programLine NOTIFY operationChanged)
    Q_PROPERTY(QVariantList activeDrills READ activeDrills NOTIFY operationChanged)
public:
    explicit Motion(QObject *parent=nullptr) : QObject(parent) {
        timer.setTimerType(Qt::PreciseTimer);
        timer.setInterval(33);
        connect(&timer, &QTimer::timeout, this, [this] {
            const double dt=std::min(elapsed.restart()/1000.0,0.1);
            if(programMode()) {
                double remaining=dt*rate;
                while(remaining>0 && next<route.size()) {
                    auto p=route[next].toMap(); double tx=p["x"].toDouble(),ty=p["y"].toDouble();
                    double oldX=px,oldY=py,oldDepth=pdepth;
                    const bool detailed=p.contains("depth"),travel=p.value("travel",false).toBool();
                    const double targetDepth=p.value("depth",0).toDouble();
                    const double velocity=p.value("feed",200).toDouble();
                    double distance=std::hypot(std::hypot(tx-px,ty-py),targetDepth-pdepth);
                    const double fraction=distance>0?std::min(1.0,remaining*velocity/distance):1.0;
                    px+=(tx-px)*fraction;py+=(ty-py)*fraction;pdepth+=(targetDepth-pdepth)*fraction;
                    pdiam=p.value("diameter",8).toDouble();pangle=p.value("angle",0).toDouble();pkind=p.value("kind","router").toString();pname=p.value("tool").toString();pline=p.value("line").toInt();
                    pdrills=p.value("holes").toList();
                    isCutting=!travel&&std::max(oldDepth,pdepth)>0;
                    if(detailed)emit machined(oldX,oldY,oldDepth,px,py,pdepth,pdiam,travel,p.value("holes").toList());
                    else {isCutting=!travel;emit swept(oldX,oldY,px,py,travel);}
                    remaining-=velocity>0?distance*fraction/velocity:remaining;
                    if(fraction>=1)++next;else remaining=0;
                }
                if(next>=route.size()){timer.stop();isCutting=false;emit finished();}
                emit operationChanged();publishChanges(); return;
            }
            phase += dt * rate * 0.35;
            px=workLength()/2-(workLength()/2-130)*std::cos(phase);
            py=1050+900*std::sin(phase*0.63);
            pz=60+50*std::sin(phase*1.7);
            plift=250+250*std::sin(phase*0.4);
            publishChanges();
        });
    }
    double lift() const {return plift;}
    double x() const {return px;} double y() const {return py;} double z() const {return pz;}
    double machineX()const{return rawX-refX;}double machineY()const{return rawY-refY;}double machineZ()const{return rawZ-refZ;}
    bool hasMachinePosition()const{return machinePosition;}
    bool running() const {return timer.isActive();} double speed() const {return rate;}
    bool programMode() const {return !route.isEmpty();}
    bool completed() const {return programMode()&&next>=route.size();}
    bool cutting() const {return isCutting;}
    bool liveMode() const {return live;}
    double machineXLimit() const {return std::max(0.0,maxX-refX);}
    double workLength()const{return panelLimit;}
    void setWorkLength(double length){if(length>=2800&&length<=4200){workspaceConfigured=true;if(length!=panelLimit){pause();panelLimit=length;emit workspaceChanged();}}}
    double toolDepth() const{return pdepth;}double toolDiameter() const{return pdiam;}double toolAngle() const{return pangle;}
    QString toolKind() const{return pkind;}QString toolName() const{return pname;}int programLine() const{return pline;}
    QVariantList activeDrills() const{return pdrills;}
    void configureAxisRanges(double xMin,double xMax,double xReference,double yMin,double yMax,double yReference,double zMin,double zMax,double zReference){
        if(xMax>xReference&&xReference>=xMin&&yMax>yReference&&yReference>=yMin&&zMax>zReference&&zReference>=zMin){
            minX=xMin;maxX=xMax;refX=xReference;minY=yMin;maxY=yMax;refY=yReference;minZ=zMin;maxZ=zMax;refZ=zReference;
            publishChanges();
        }
    }
    Q_INVOKABLE void setLiveAxes(double rawX,double rawY,double rawZ) {
        if(!std::isfinite(rawX)||!std::isfinite(rawY)||!std::isfinite(rawZ))return;
        const bool rawChanged=!machinePosition||this->rawX!=rawX||this->rawY!=rawY||this->rawZ!=rawZ;
        machinePosition=true;
        this->rawX=rawX;this->rawY=rawY;this->rawZ=rawZ;
        pause();route.clear();live=true;isCutting=false;
        // Axis references produce machine coordinates. Work-origin offsets are
        // displayed separately and are applied only to program visualization.
        px=std::clamp(rawX-refX,0.0,machineXLimit());
        // Live Y uses the same edge-zero coordinates as manual positioning.
        // The demo animation's midpoint is not a machine-axis offset.
        py=std::clamp(rawY-refY,0.0,2100.0);
        pz=std::clamp(60.0+rawZ-refZ,0.0,120.0);
        publishChanges();
        if(rawChanged)emit machineAxesChanged();
    }
    Q_INVOKABLE void endLive() {if(live){live=false;publishChanges();}}
    Q_INVOKABLE bool loadPath(const QVariantList& points) {
        pause();
        live=false;
        for(const auto& value:points) {
            auto p=value.toMap(); bool okX=false,okY=false;
            double x=p.value("x").toDouble(&okX),y=p.value("y").toDouble(&okY);
            if(!okX||!okY||!std::isfinite(x)||!std::isfinite(y)||x<0||x>workLength()||y<0||y>2100) return false;
            if(p.contains("depth")&&(!std::isfinite(p["depth"].toDouble())||!std::isfinite(p["feed"].toDouble())||p["feed"].toDouble()<=0))return false;
        }
        if(points.size()<2) return false;
        route=points; reset(); return true;
    }
    Q_INVOKABLE void clearPath() {pause();route.clear();reset();}
    void setSpeed(double value) {if(std::isfinite(value)){rate=std::clamp(value,0.25,10.0); publishChanges();}}
    Q_INVOKABLE void setAxis(int axis, double value) {
        if(!std::isfinite(value) || axis<0 || axis>3) return;
        if(programMode()||liveMode()) return;
        if(machinePosition){machinePosition=false;emit machineAxesChanged();}
        pause();
        if(axis==0) px=std::clamp(value,0.0,workspaceConfigured?std::min(panelLimit,machineXLimit()):machineXLimit());
        if(axis==1) py=std::clamp(value,0.0,2100.0);
        if(axis==2) pz=std::clamp(value,0.0,120.0);
        if(axis==3) plift=std::clamp(value,0.0,500.0);
        publishChanges();
    }
    Q_INVOKABLE void play() {if(liveMode())return;if(programMode() && next>=route.size()) reset();elapsed.start();timer.start();publishChanges();}
    Q_INVOKABLE void pause() {timer.stop();publishChanges();}
    Q_INVOKABLE void reset() {if(liveMode())return;pause();if(machinePosition){machinePosition=false;emit machineAxesChanged();}phase=0;px=0;py=0;pz=60;plift=0;pdepth=0;next=1;isCutting=false;if(programMode()){auto p=route.first().toMap();px=p["x"].toDouble();py=p["y"].toDouble();pdepth=p.value("depth",0).toDouble();pkind=p.value("kind","router").toString();pdiam=p.value("diameter",8).toDouble();pname=p.value("tool").toString();pline=p.value("line").toInt();pdrills=p.value("holes").toList();}emit routeReset();emit operationChanged();publishChanges();}
signals:
    void workspaceChanged();
    void machineAxesChanged();
    void xChanged(); void yChanged(); void zChanged(); void liftChanged();
    void runningChanged(); void speedChanged(); void programModeChanged();
    void cuttingChanged(); void liveModeChanged(); void machineXLimitChanged();
    void changed();
    void swept(double ax,double ay,double bx,double by,bool travel);
    void routeReset();
    void operationChanged();void finished();
    void machined(double ax,double ay,double ad,double bx,double by,double bd,double diameter,bool travel,const QVariantList& holes);
private:
    // Property notifications are independent: moving X must not invalidate Y,
    // Z, speed, running-state labels or every CAD binding at the same time.
    void publishChanges() {
        bool any=false;
        auto real=[&](double value,double& last,auto signal) {
            if(value!=last){last=value;any=true;(this->*signal)();}
        };
        auto flag=[&](bool value,bool& last,auto signal) {
            if(value!=last){last=value;any=true;(this->*signal)();}
        };
        real(px,sentX,&Motion::xChanged);real(py,sentY,&Motion::yChanged);
        real(pz,sentZ,&Motion::zChanged);real(plift,sentLift,&Motion::liftChanged);
        real(rate,sentSpeed,&Motion::speedChanged);
        real(machineXLimit(),sentLimit,&Motion::machineXLimitChanged);
        flag(running(),sentRunning,&Motion::runningChanged);
        flag(programMode(),sentProgram,&Motion::programModeChanged);
        flag(cutting(),sentCutting,&Motion::cuttingChanged);
        flag(liveMode(),sentLive,&Motion::liveModeChanged);
        if(any)emit changed();
    }
    double sentX=0,sentY=0,sentZ=60,sentLift=0,sentSpeed=1,sentLimit=5235;
    bool sentRunning=false,sentProgram=false,sentCutting=false,sentLive=false;
    QTimer timer;
    QElapsedTimer elapsed;
    QVariantList route;
    bool isCutting=false,live=false;
    qsizetype next=1;
    double px=0,py=0,pz=60,plift=0,rate=1,phase=0;
    double pdepth=0,pdiam=8,pangle=0;QString pkind="router",pname;int pline=0;QVariantList pdrills;
    double minX=-34,maxX=5235,refX=0,minY=-240,maxY=2310,refY=0,minZ=-295,maxZ=46,refZ=-280;
    double rawX=0,rawY=0,rawZ=-280;
    bool machinePosition=false;
    double panelLimit=3660;
    bool workspaceConfigured=false;
};
