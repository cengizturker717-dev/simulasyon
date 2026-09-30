#pragma once
#include <QObject>
#include <QProcess>
#include <QTimer>
#include <QElapsedTimer>
#include <QCoreApplication>
#include <QFileInfo>
#include <QProcessEnvironment>
#include <QJsonDocument>
#include <QJsonObject>
#include <cmath>

class LiveCni : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool active READ active NOTIFY changed)
    Q_PROPERTY(bool fresh READ fresh NOTIFY changed)
    Q_PROPERTY(QString status READ status NOTIFY changed)
    Q_PROPERTY(double x MEMBER px NOTIFY changed)
    Q_PROPERTY(double y MEMBER py NOTIFY changed)
    Q_PROPERTY(double z MEMBER pz NOTIFY changed)
    Q_PROPERTY(int center MEMBER centerNumber NOTIFY changed)
    Q_PROPERTY(int originIndex MEMBER activeOriginIndex NOTIFY changed)
    Q_PROPERTY(int originNumber READ originNumber NOTIFY changed)
    Q_PROPERTY(double originX MEMBER ox NOTIFY changed)
    Q_PROPERTY(double originY MEMBER oy NOTIFY changed)
    Q_PROPERTY(double originZ MEMBER oz NOTIFY changed)
    Q_PROPERTY(double workX READ workX NOTIFY changed)
    Q_PROPERTY(double workY READ workY NOTIFY changed)
    Q_PROPERTY(double workZ READ workZ NOTIFY changed)
    Q_PROPERTY(int toolReference MEMBER activeToolReference NOTIFY changed)
public:
    explicit LiveCni(QObject* parent=nullptr):QObject(parent) {
        watchdog.setInterval(200);
        connect(&watchdog,&QTimer::timeout,this,[this]{
            if(age.elapsed()>(valid?1000:3000)) fail("Veri yok / bağlantı kesildi. NcOne simülatörünü açıp tekrar bağlanın.");
        });
        connect(&process,&QProcess::readyReadStandardOutput,this,[this]{
            pending+=process.readAllStandardOutput();
            if(pending.size()>65536){fail("Geçersiz CNI veri boyutu");return;}
            while(pending.contains('\n')) {
                int end=pending.indexOf('\n');auto line=pending.left(end).trimmed();pending.remove(0,end+1);
                if(!line.startsWith('{'))continue;
                auto doc=QJsonDocument::fromJson(line);auto o=doc.object();
                if(!o["x"].isDouble()||!o["y"].isDouble()||!o["z"].isDouble()) {fail("Geçersiz eksen verisi");return;}
                double x=o["x"].toDouble(),y=o["y"].toDouble(),z=o["z"].toDouble();
                if(!std::isfinite(x)||!std::isfinite(y)||!std::isfinite(z)){fail("Geçersiz eksen koordinatı");return;}
                px=x;py=y;pz=z;
                centerNumber=o.value("center").toInt(0);activeOriginIndex=o.value("originIndex").toInt(-1);
                ox=o.value("originX").toDouble();oy=o.value("originY").toDouble();oz=o.value("originZ").toDouble();
                activeToolReference=o.value("toolReference").toInt(0);
                valid=true;age.restart();message="CNI canlı veri · salt okunur · 3D izleme aktif";emit axes(px,py,pz);emit changed();
            }
        });
        connect(&process,&QProcess::readyReadStandardError,this,[this]{process.readAllStandardError();});
        connect(&process,&QProcess::errorOccurred,this,[this](QProcess::ProcessError){if(requested)fail("CNI okuyucusu başlatılamadı veya durdu");});
        connect(&process,qOverload<int,QProcess::ExitStatus>(&QProcess::finished),this,[this]{if(requested)fail("CNI verisi alınamadı. NcOne simülatörünü kontrol edin.");});
    }
    ~LiveCni() {requested=false;process.kill();process.waitForFinished(500);}
    bool active()const{return requested;} bool fresh()const{return valid;} QString status()const{return message;}
    int originNumber()const{return activeOriginIndex>=0?activeOriginIndex+1:0;}
    double workX()const{return px-ox;} double workY()const{return py-oy;} double workZ()const{return pz-oz;}
    Q_INVOKABLE void start() {
        if(process.state()!=QProcess::NotRunning)return;
        const QString helper=QCoreApplication::applicationDirPath()+"/CniTelemetry.exe";
        if(!QFileInfo::exists(helper)){message="CniTelemetry.exe bulunamadı";emit changed();return;}
        pending.clear();valid=false;requested=true;message="CNI simülatörüne bağlanılıyor…";
        auto env=QProcessEnvironment::systemEnvironment();env.insert("PATH","C:/CNI/Ncone/CnData/Bin;"+env.value("PATH"));process.setProcessEnvironment(env);
        process.setWorkingDirectory(QCoreApplication::applicationDirPath());process.start(helper,{});age.start();watchdog.start();emit changed();
    }
    Q_INVOKABLE void stop() {fail("CNI bağlantısı kapalı");}
signals:
    void changed();
    void axes(double x,double y,double z);
    void disconnected();
private:
    void fail(const QString& reason){requested=false;valid=false;watchdog.stop();process.kill();message=reason;emit disconnected();emit changed();}
    QProcess process;QTimer watchdog;QElapsedTimer age;QByteArray pending;
    bool requested=false,valid=false;double px=0,py=0,pz=0,ox=0,oy=0,oz=0;
    int centerNumber=0,activeOriginIndex=-1,activeToolReference=0;
    QString message="CNI bağlantısı kapalı";
};
