#pragma once
#include "Motion.h"
#include "Pcni.h"
#include "StockGeometry.h"
#include <QJsonObject>
#include <vector>

// Material preview only. This class has no machine-command interface.
class Machining : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool liveJob READ liveJob NOTIFY jobStateChanged)
    Q_PROPERTY(bool visible READ visible NOTIFY jobStateChanged)
    Q_PROPERTY(bool error READ error NOTIFY jobStateChanged)
    Q_PROPERTY(QString status READ status NOTIFY statusChanged)
    Q_PROPERTY(QString tool READ tool NOTIFY toolChanged)
    Q_PROPERTY(double depth READ depth NOTIFY depthChanged)
    Q_PROPERTY(double stockX READ stockX CONSTANT)
    Q_PROPERTY(double stockY READ stockY CONSTANT)
    Q_PROPERTY(double stockZ READ stockZ CONSTANT)
    Q_PROPERTY(double workX READ workX NOTIFY workPositionChanged)
    Q_PROPERTY(double workY READ workY NOTIFY workPositionChanged)
    Q_PROPERTY(bool drilling READ drilling NOTIFY toolChanged)
    Q_PROPERTY(QVariantList activeDrills READ activeDrills NOTIFY activeDrillsChanged)
public:
    Machining(Motion& m,Pcni& p,StockGeometry& s):motion(m),pcni(p),stock(s) {
        connect(&motion,&Motion::machined,this,[this](double ax,double ay,double ad,double bx,double by,double bd,double diameter,bool travel,const QVariantList& holes){remove(ax,ay,ad,bx,by,bd,diameter,travel,holes,this->motion.toolAngle());});
        connect(&motion,&Motion::operationChanged,this,&Machining::publishChanges);
        connect(&motion,&Motion::programModeChanged,this,&Machining::publishChanges);
        connect(&motion,&Motion::runningChanged,this,[this]{if(!job&&motion.programMode()){message=motion.running()?"İşleme sürüyor":motion.completed()?"İşleme önizlemesi tamamlandı":"İşleme duraklatıldı";publishChanges();}});
        connect(&motion,&Motion::finished,this,[this]{stock.flush();message="İşleme önizlemesi tamamlandı";publishChanges();});
    }
    bool liveJob() const{return job&&!blocked;}bool visible()const{return job||motion.programMode();}
    bool error() const{return blocked;}
    QString status()const{return message;}QString tool()const{return job?liveTool:motion.toolName()+" · "+(motion.toolKind()=="drill"?"FAM matkap":"freze");}
    double depth()const{return job?liveDepth:motion.toolDepth();}
    double stockX()const{return -1.017;}
    double stockY()const{return 1.0825051;}
    double stockZ()const{return -1.2046434;}
    double workX()const{return measuredX;}double workY()const{return measuredY;}
    bool drilling()const{return job&&liveKind=="drill";}
    QVariantList activeDrills()const{return liveDrills;}
    int completedHoles()const{return completedDrills;}
    void clearPreview(){motion.clearPath();job=false;executing=false;previous=false;blocked=false;activeProgram.clear();livePath.clear();segments.clear();setLiveDrills({});pendingDrill.clear();completedDrills=0;message="PCNI seçip plakayı yükleyin veya CNI canlı izlemeye bağlanın";publishChanges();}
    Q_INVOKABLE bool load() {
        if(motion.liveMode()){message="Çevrimdışı işleme için canlı bağlantıyı kapatın";publishChanges();return false;}
        if(!pcni.property("ready").toBool())return false;
        job=false;blocked=false;pendingDrill.clear();completedDrills=0;configure();
        bool ok=motion.loadPath(pcni.property("points").toList());
        message=ok?"Hazır · programdaki derinlikler ve takımlar uygulanacak":"Program yolu yüklenemedi";publishChanges();return ok;
    }
    void disconnectLive(){executing=false;previous=false;pendingDrill.clear();if(!blocked)message=job?"Bağlantı kesildi · malzeme hesabı durduruldu":"CNI bağlantısı kapalı";publishChanges();}
    void snapshot(const QJsonObject& o) {
        if(!o.value("metadataValid").toBool()){previous=false;pendingDrill.clear();if(!blocked)message="Eksenler okunuyor · çalışan program bilgisi bekleniyor";publishChanges();return;}
        const bool run=o.value("executing").toBool();const QString program=o.value("program").toString().trimmed();
        // EXE may already be set while PrgStart is still empty during CNI
        // startup. Wait without latching an error, clearing stock or cutting.
        // The first named program must still pass all normal tool checks.
        if(run&&program.isEmpty()){
            previous=false;pendingDrill.clear();if(!blocked)message="CNI bağlı · çalışan program adı bekleniyor";publishChanges();return;
        }
        if(run&&(!executing||program!=activeProgram)) {
            activeProgram=program;previous=false;cursor=1;job=false;blocked=false;liveDepth=-20;livePath.clear();segments.clear();setLiveDrills({});pendingDrill.clear();completedDrills=0;completedDrillCursor=-1;liveKind="router";
            if(program.isEmpty()||!pcni.load(program)){
                blocked=true;message="İşleme başlatılmadı · "+(program.isEmpty()?QString("çalışan program adı bulunamadı"):pcni.property("status").toString());
                if(!program.isEmpty()&&validPanel()){configure();job=true;}
                executing=run;publishChanges();return;
            }
            configure();job=true;livePath=pcni.property("points").toList();prepareSegments();message="Start · plaka program ölçülerinden yüklendi";
        }
        executing=run;
        if(blocked){publishChanges();return;}
        if(!job){message="CNI hazır · program Start bekleniyor";publishChanges();return;}
        if(!o["workValid"].toBool()||!o["panelFrameValid"].toBool()) {previous=false;pendingDrill.clear();message="Takım düzeltmesi / tabla sıfırı bekleniyor · malzeme hesabı durdu";publishChanges();return;}
        // PRIMO applies ZO=-CSag. SharedAx CorrTotale removes origin, spindle and
        // tool offsets, while this program ZO is restored explicitly here.
        const double x=o["workX"].toDouble(),y=o["workY"].toDouble();
        const double d=stock.thickness()+o["workZ"].toDouble()+o["spoilboard"].toDouble();
        if(!std::isfinite(x)||!std::isfinite(y)||!std::isfinite(d)){previous=false;pendingDrill.clear();message="Geçersiz takım koordinatı · malzeme hesabı durdu";publishChanges();return;}
        liveDepth=d;
        measuredX=x;measuredY=y;
        if(!run){previous=false;pendingDrill.clear();message="Program durdu · işlenen plaka korunuyor";stock.flush();publishChanges();return;}
        const double targetDepth=stock.thickness()+o["targetZ"].toDouble()+o["spoilboard"].toDouble();
        const bool targetValid=o["targetValid"].toBool()&&o["targetX"].isDouble()&&o["targetY"].isDouble()&&o["targetZ"].isDouble()&&std::isfinite(targetDepth);
        // A G99 plunge can reach its programmed bottom and begin retracting
        // between two samples. Complete the PROGRAMMED preview only after its
        // bottom target was observed and the CNC switches to retract at the
        // same hole. Stop, stale data or an XY jump never complete a hole.
        if(!pendingDrill.isEmpty()) {
            const double hx=pendingDrill["x"].toDouble(),hy=pendingDrill["y"].toDouble();
            if(!targetValid||std::hypot(x-hx,y-hy)>=2)pendingDrill.clear();
            else if(targetDepth<0&&d<pendingPeak-.05) {
                const double hd=pendingDrill["depth"].toDouble();
                if(pendingPeak>=hd-std::min(2.5,hd*.25)) {
                    remove(hx,hy,hd,hx,hy,hd,pendingDrill["diameter"].toDouble(),false,pendingDrill["holes"].toList());
                    completedDrills+=std::max(1,int(pendingDrill["holes"].toList().size()));completedDrillCursor=pendingCursor;
                }
                pendingDrill.clear();
            }
            else pendingPeak=std::max(pendingPeak,d);
        }
        // A raised tool can cross the XY projection of a future entry ramp.
        // Matching that air move would advance cursor past unfinished cuts.
        // Finish any confirmed drill retract above, but never consume a path
        // operation until the measured tip is inside the material.
        if(d<=0){previous=false;message="Takım plakanın üzerinde · kesim yok";publishChanges();return;}
        // Only an unambiguous programmed cutting segment may remove material.
        // If the measured work origin/tool path disagrees, keep the stock intact.
        int match=-1;QString matchedKind;QVariantMap operation,candidate;double best=2.0;bool ambiguous=false;
        for(qsizetype i=cursor;i<qsizetype(segments.size());++i){
            const auto& s=segments[size_t(i)];
            // Conservative bounds only reject impossible matches. The exact
            // distance/depth test, order and ambiguity rules remain unchanged.
            constexpr double broadMargin=2.000001;
            if(s.travel||x<s.minX-broadMargin||x>s.maxX+broadMargin||y<s.minY-broadMargin||y>s.maxY+broadMargin||d<s.lo-1||d>s.hi+1)continue;
            const auto& b=s.operation;
            double t=s.len>0?std::clamp(((x-s.ax)*s.vx+(y-s.ay)*s.vy)/s.len,0.0,1.0):0;
            double distance=std::hypot(x-s.ax-t*s.vx,y-s.ay-t*s.vy);
            if(distance<2.0&&d>=s.lo-1&&d<=s.hi+1){
                if(!candidate.isEmpty()&&(candidate["kind"]!=b["kind"]||candidate["tool"]!=b["tool"]||candidate["diameter"]!=b["diameter"]||candidate["holes"]!=b["holes"]))ambiguous=true;
                candidate=b;
                if(distance<best){best=distance;match=int(i);operation=b;matchedKind=b["kind"].toString();}
            }
        }
        if(ambiguous){previous=false;pendingDrill.clear();message="Takım / çevrim eşlemesi belirsiz · malzeme hesabı bekliyor";publishChanges();return;}
        if(match<0||x<0||y<0||x>stock.stockWidth()||y>stock.stockHeight()){
            previous=false;message=d>0?"İşleme yolu / iş sıfırı eşleşmesi bekleniyor":"Takım plakanın üzerinde · kesim yok";publishChanges();return;
        }
        liveTool=operation["tool"].toString()+" · "+(matchedKind=="drill"?"FAM matkap":"freze");
        liveKind=matchedKind;setLiveDrills(operation["holes"].toList());
        if(matchedKind=="drill"&&d>0&&targetValid&&match!=completedDrillCursor&&std::abs(targetDepth-operation["depth"].toDouble())<.1&&std::hypot(o["targetX"].toDouble()-operation["x"].toDouble(),o["targetY"].toDouble()-operation["y"].toDouble())<.1) {
            if(pendingDrill.isEmpty()||pendingCursor!=match)pendingPeak=d;else pendingPeak=std::max(pendingPeak,d);
            pendingDrill=operation;pendingCursor=match;
        }
        bool continuous=previous&&lastCursor==match&&std::hypot(x-lastX,y-lastY)<100;
        if(previous&&match==lastCursor+1&&std::hypot(x-lastX,y-lastY)<100){
            auto corner=livePath[lastCursor].toMap();
            if(!corner["travel"].toBool()&&corner["tool"]==operation["tool"]&&corner["kind"]==operation["kind"]){
                const double cx=corner["x"].toDouble(),cy=corner["y"].toDouble(),cd=corner["depth"].toDouble();
                remove(lastX,lastY,lastDepth,cx,cy,cd,corner["diameter"].toDouble(),false,corner["holes"].toList(),corner["angle"].toDouble());
                lastX=cx;lastY=cy;lastDepth=cd;continuous=true;
            }
        }
        remove(continuous?lastX:x,continuous?lastY:y,continuous?lastDepth:d,x,y,d,operation["diameter"].toDouble(),false,operation["holes"].toList(),operation["angle"].toDouble());
        cursor=match;lastCursor=match;lastX=x;lastY=y;lastDepth=d;previous=true;
        message=QString("Canlı işleme · N%1 · %2").arg(operation["line"].toInt()).arg(liveTool);publishChanges();
    }
signals:void changed();void activeDrillsChanged();
    void jobStateChanged();void statusChanged();void toolChanged();void depthChanged();void workPositionChanged();
private:
    void publishChanges(){
        bool any=false;
        if(sentJob!=liveJob()||sentVisible!=visible()||sentError!=error()){
            sentJob=liveJob();sentVisible=visible();sentError=error();any=true;emit jobStateChanged();
        }
        const auto currentTool=tool();
        if(sentTool!=currentTool||sentDrilling!=drilling()){
            sentTool=currentTool;sentDrilling=drilling();any=true;emit toolChanged();
        }
        if(sentStatus!=message){sentStatus=message;any=true;emit statusChanged();}
        if(sentDepth!=depth()){sentDepth=depth();any=true;emit depthChanged();}
        if(sentX!=measuredX||sentY!=measuredY){sentX=measuredX;sentY=measuredY;any=true;emit workPositionChanged();}
        if(any)emit changed();
    }
    bool sentJob=false,sentVisible=false,sentError=false,sentDrilling=false;
    double sentDepth=0,sentX=0,sentY=0;
    QString sentTool=" · freze",sentStatus="PCNI seçip plakayı yükleyin veya CNI canlı izlemeye bağlanın";
    struct Segment {
        QVariantMap operation;
        double ax,ay,vx,vy,len,lo,hi,minX,maxX,minY,maxY;
        bool travel;
    };
    std::vector<Segment> segments;
    void prepareSegments(){
        segments.clear();segments.resize(size_t(livePath.size()));
        for(qsizetype i=1;i<livePath.size();++i){
            const auto a=livePath[i-1].toMap(),b=livePath[i].toMap();
            const double ax=a["x"].toDouble(),ay=a["y"].toDouble(),bx=b["x"].toDouble(),by=b["y"].toDouble();
            const double vx=bx-ax,vy=by-ay,ad=a["depth"].toDouble(),bd=b["depth"].toDouble();
            segments[size_t(i)]={b,ax,ay,vx,vy,vx*vx+vy*vy,std::min(ad,bd),std::max(ad,bd),std::min(ax,bx),std::max(ax,bx),std::min(ay,by),std::max(ay,by),b["travel"].toBool()};
        }
    }
    // A shared general NOTIFY recreated the Repeater3D drill models for every
    // depth/status sample, even when the selected drill group had not changed.
    void setLiveDrills(const QVariantList& value){if(liveDrills!=value){liveDrills=value;emit activeDrillsChanged();}}
    bool validPanel()const{double w=pcni.property("width").toDouble(),h=pcni.property("height").toDouble(),t=pcni.property("thickness").toDouble();return std::isfinite(w)&&std::isfinite(h)&&std::isfinite(t)&&w>0&&w<=pcni.workLength()&&h>0&&h<=2100&&t>0&&t<=120;}
    void configure(){stock.configure(pcni.property("width").toDouble(),pcni.property("height").toDouble(),pcni.property("thickness").toDouble(),pcni.property("toolDiameter").toDouble());}
    void remove(double ax,double ay,double ad,double bx,double by,double bd,double diameter,bool travel,const QVariantList& holes,double angle=0){
        if(holes.isEmpty())stock.cutProfile(ax,ay,ad,bx,by,bd,diameter,travel,angle);
        else for(const auto& value:holes){auto h=value.toMap();double dx=h["dx"].toDouble(),dy=h["dy"].toDouble();stock.cutProfile(ax+dx,ay+dy,ad,bx+dx,by+dy,bd,h["diameter"].toDouble(),travel);}
    }
    Motion& motion;Pcni& pcni;StockGeometry& stock;
    bool job=false,executing=false,previous=false,blocked=false;int cursor=1,lastCursor=-1;
    double originX=0,originY=0,measuredX=0,measuredY=0,liveDepth=-20,lastX=0,lastY=0,lastDepth=0;
    QString activeProgram,liveTool,liveKind="router",message="PCNI seçip plakayı yükleyin veya CNI canlı izlemeye bağlanın";QVariantList livePath,liveDrills;
    QVariantMap pendingDrill;double pendingPeak=0;int pendingCursor=-1,completedDrillCursor=-1,completedDrills=0;
};
