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
#include <QFile>
#include <QDir>
#include <QDateTime>
#include <QStandardPaths>
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
    Q_PROPERTY(bool workFresh READ workFresh NOTIFY changed)
    Q_PROPERTY(int toolReference MEMBER activeToolReference NOTIFY changed)
public:
    explicit LiveCni(QObject* parent=nullptr,const QString& reader={},const QStringList& arguments={},const QStringList& programArguments={}):QObject(parent),readerFile(reader),readerArguments(arguments),metadataArguments(programArguments),isolatedMetadata(reader.isEmpty()||!programArguments.isEmpty()) {
        watchdog.setInterval(200);
        connect(&watchdog,&QTimer::timeout,this,[this]{
            if(age.elapsed()>(valid?1000:15000)){fail(readerFailure(valid ? "Canlı eksen verisi kesildi; son makine konumu korunuyor" : "CNI okuyucusundan 15 saniye içinde eksen verisi gelmedi"));return;}
            if(isolatedMetadata&&requested){
                if(metadataWanted&&metadataAge.elapsed()>(metadataReceived?1000:5000))metadataFailed("Program bilgisi beklemede"+(metadataDetail.isEmpty()?QString():": "+metadataDetail));
                if(!metadataWanted&&metadataProcess.state()==QProcess::NotRunning&&metadataRetry.elapsed()>=5000)startMetadata();
            }
        });
        connect(&process,&QProcess::readyReadStandardOutput,this,[this]{
            if(!requested){process.readAllStandardOutput();return;}
            pending+=process.readAllStandardOutput();
            if(pending.size()>65536){fail("Geçersiz CNI veri boyutu");return;}
            while(pending.contains('\n')) {
                int end=pending.indexOf('\n');auto line=pending.left(end).trimmed();pending.remove(0,end+1);
                if(!line.startsWith('{'))continue;
                auto doc=QJsonDocument::fromJson(line);auto o=doc.object();
                if(!o["x"].isDouble()||!o["y"].isDouble()||!o["z"].isDouble()) {fail("Geçersiz eksen verisi");return;}
                double x=o["x"].toDouble(),y=o["y"].toDouble(),z=o["z"].toDouble();
                if(!std::isfinite(x)||!std::isfinite(y)||!std::isfinite(z)){fail("Geçersiz eksen koordinatı");return;}
                if(isolatedMetadata){
                    const bool usable=metadataReceived&&metadataAge.elapsed()<=1000&&metadata.value("metadataValid").toBool();
                    for(const auto& key:{"metadataValid","panelFrameValid","spoilboard","executing","program"})o.remove(key);
                    o.insert("metadataValid",usable);
                    if(usable)for(auto it=metadata.begin();it!=metadata.end();++it)o.insert(it.key(),it.value());
                }
                px=x;py=y;pz=z;
                centerNumber=o.value("center").toInt(0);activeOriginIndex=o.value("originIndex").toInt(-1);
                ox=o.value("originX").toDouble();oy=o.value("originY").toDouble();oz=o.value("originZ").toDouble();
                activeToolReference=o.value("toolReference").toInt(0);
                corrected=o.value("workValid").toBool()&&o.value("panelFrameValid").toBool();
                wx=o.value("workX").toDouble();wy=o.value("workY").toDouble();wz=o.value("workZ").toDouble()+o.value("spoilboard").toDouble();
                corrected=corrected&&std::isfinite(wx)&&std::isfinite(wy)&&std::isfinite(wz);
                valid=true;age.restart();message=isolatedMetadata&&!o.value("metadataValid").toBool()?"CNI eksenleri canlı · "+(metadataDetail.isEmpty()?QString("program bilgisi bekleniyor"):metadataDetail):"CNI canlı veri · salt okunur · 3D izleme aktif";emit axes(px,py,pz);emit changed();
                emit snapshot(o);
            }
        });
        connect(&process,&QProcess::readyReadStandardError,this,[this]{readErrors();});
        connect(&process,&QProcess::errorOccurred,this,[this](QProcess::ProcessError error){
            if(requested && error==QProcess::FailedToStart)fail("CNI okuyucusu başlatılamadı: "+process.errorString());
        });
        connect(&process,qOverload<int,QProcess::ExitStatus>(&QProcess::finished),this,[this](int code,QProcess::ExitStatus){
            readErrors();
            if(requested)fail(readerFailure(QString("CNI okuyucusu durdu (kod %1)").arg(code)));
        });
        connect(&metadataProcess,&QProcess::readyReadStandardOutput,this,[this]{readMetadata();});
        connect(&metadataProcess,&QProcess::readyReadStandardError,this,[this]{
            auto bytes=metadataProcess.readAllStandardError();if(bytes.isEmpty())return;
            metadataErrors=(metadataErrors+bytes).right(8192);
            for(const auto& line:metadataErrors.split('\n')){
                const auto detail=QString::fromUtf8(line).trimmed();
                if(detail.startsWith("CNI_STAGE: "))metadataDetail=detail.mid(11);
                if(detail.startsWith("CNI_ERROR: "))metadataDetail=detail.mid(11);
            }
            writeLog("Program okuyucusu: "+QString::fromUtf8(bytes).trimmed());
        });
        connect(&metadataProcess,&QProcess::errorOccurred,this,[this](QProcess::ProcessError error){if(requested&&metadataWanted&&error==QProcess::FailedToStart)metadataFailed("Program okuyucusu başlatılamadı: "+metadataProcess.errorString());});
        connect(&metadataProcess,qOverload<int,QProcess::ExitStatus>(&QProcess::finished),this,[this](int code,QProcess::ExitStatus){if(requested&&metadataWanted)metadataFailed("Program okuyucusu durdu (kod "+QString::number(code)+")"+(metadataDetail.isEmpty()?QString():": "+metadataDetail));});
    }
    ~LiveCni() {requested=false;process.kill();metadataProcess.kill();process.waitForFinished(500);metadataProcess.waitForFinished(500);}
    bool active()const{return requested;} bool fresh()const{return valid;} QString status()const{return message;}
    int originNumber()const{return activeOriginIndex>=0?activeOriginIndex+1:0;}
    bool workFresh()const{return valid&&corrected&&(!isolatedMetadata||(metadataWanted&&metadataReceived&&metadataAge.elapsed()<=1000&&metadata.value("metadataValid").toBool()&&metadata.value("panelFrameValid").toBool()));}
    double workX()const{return wx;} double workY()const{return wy;} double workZ()const{return wz;}
    void setStartAllowed(bool allowed){startAllowed=allowed;}
    Q_INVOKABLE void start() {
        if(!startAllowed){message="Seçili Vigor için makine datası klasörünü seçin";emit changed();return;}
        if(process.state()!=QProcess::NotRunning||metadataProcess.state()!=QProcess::NotRunning)return;
        const QString helper=readerFile.isEmpty()?QCoreApplication::applicationDirPath()+"/CniTelemetry.exe":readerFile;
        if(!QFileInfo::exists(helper)){message="CniTelemetry.exe bulunamadı";emit changed();return;}
        pending.clear();readerError.clear();lastReaderDetail.clear();lastReaderStage.clear();valid=false;corrected=false;requested=true;message="CNI kontrol ünitesinden canlı veri bekleniyor…";
        auto env=QProcessEnvironment::systemEnvironment();env.insert("PATH","C:/CNI/Ncone/CnData/Bin;"+env.value("PATH"));process.setProcessEnvironment(env);
        process.setWorkingDirectory(QCoreApplication::applicationDirPath());writeLog("Bağlantı isteği: "+helper);process.start(helper,readerArguments);age.start();watchdog.start();if(isolatedMetadata)startMetadata();emit changed();
    }
    Q_INVOKABLE void stop() {fail("CNI bağlantısı kapalı");}
signals:
    void changed();
    void axes(double x,double y,double z);
    void disconnected();
    void snapshot(const QJsonObject& data);
private:
    void startMetadata(){
        metadata={};metadataReceived=false;metadataWanted=true;metadataPending.clear();metadataErrors.clear();metadataDetail.clear();metadataAge.start();
        const QString helper=readerFile.isEmpty()?QCoreApplication::applicationDirPath()+"/CniTelemetry.exe":readerFile;
        auto arguments=metadataArguments;if(arguments.isEmpty())arguments={"--metadata"};
        metadataProcess.setProcessEnvironment(process.processEnvironment());metadataProcess.setWorkingDirectory(QCoreApplication::applicationDirPath());metadataProcess.start(helper,arguments);
    }
    void metadataFailed(const QString& reason){
        metadataWanted=false;metadataReceived=false;metadata={};metadataDetail=reason;metadataRetry.start();metadataProcess.kill();writeLog(reason);
    }
    void readMetadata(){
        if(!requested||!metadataWanted){metadataProcess.readAllStandardOutput();return;}
        metadataPending+=metadataProcess.readAllStandardOutput();
        if(metadataPending.size()>65536){metadataFailed("Geçersiz program verisi boyutu");return;}
        while(metadataPending.contains('\n')){
            const int end=metadataPending.indexOf('\n');const auto line=metadataPending.left(end).trimmed();metadataPending.remove(0,end+1);if(!line.startsWith('{'))continue;
            const auto o=QJsonDocument::fromJson(line).object();
            if(!o["metadataValid"].isBool()){metadataFailed("Geçersiz program bilgisi");return;}
            if(o["metadataValid"].toBool()&&(!o["executing"].isBool()||!o["program"].isString()||!o["panelFrameValid"].isBool()||(o["panelFrameValid"].toBool()&&(!o["spoilboard"].isDouble()||!std::isfinite(o["spoilboard"].toDouble())||o["spoilboard"].toDouble()<0||o["spoilboard"].toDouble()>1000)))){metadataFailed("Geçersiz program / tabla sıfırı bilgisi");return;}
            metadata={};for(const auto& key:{"metadataValid","panelFrameValid","spoilboard","executing","program"})if(o.contains(key))metadata.insert(key,o.value(key));
            metadataReceived=true;metadataAge.restart();if(o["metadataValid"].toBool())metadataDetail.clear();
        }
    }
    void writeLog(const QString& text){
        const QString folder=QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
        if(folder.isEmpty()||!QDir().mkpath(folder))return;
        const QString file=folder+"/cni-connection.log";
        QFile log(file);if(log.size()>131072){if(log.open(QIODevice::WriteOnly|QIODevice::Truncate))log.close();}
        if(log.open(QIODevice::WriteOnly|QIODevice::Append))log.write((QDateTime::currentDateTime().toString(Qt::ISODate)+" "+text+"\n").toUtf8());
    }
    void readErrors(){
        auto bytes=process.readAllStandardError();if(bytes.isEmpty())return;
        readerError=(readerError+bytes).right(8192);
        for(const auto& line:readerError.split('\n')){
            const auto trimmed=QString::fromUtf8(line).trimmed();
            if(trimmed.startsWith("CNI_ERROR: "))lastReaderDetail=trimmed.mid(11).left(1200);
            if(trimmed.startsWith("CNI_STAGE: "))lastReaderStage=trimmed.mid(11).left(300);
        }
        writeLog(QString::fromUtf8(bytes).trimmed());
    }
    QString readerFailure(const QString& fallback)const{
        if(!lastReaderDetail.isEmpty())return "CNI bağlantısı kurulamadı: "+lastReaderDetail;
        if(!lastReaderStage.isEmpty())return fallback+" · son adım: "+lastReaderStage;
        const QString raw=QString::fromUtf8(readerError).trimmed();
        return raw.isEmpty()?fallback:fallback+" · "+raw.right(1200);
    }
    void fail(const QString& reason){requested=false;valid=false;corrected=false;metadataWanted=false;metadataReceived=false;metadata={};watchdog.stop();process.kill();metadataProcess.kill();message=reason;writeLog(reason);emit disconnected();emit changed();}
    QProcess process,metadataProcess;QTimer watchdog;QElapsedTimer age,metadataAge,metadataRetry;QByteArray pending,metadataPending,metadataErrors;QJsonObject metadata;
    bool requested=false,valid=false,corrected=false;double px=0,py=0,pz=0,ox=0,oy=0,oz=0,wx=0,wy=0,wz=0;
    int centerNumber=0,activeOriginIndex=-1,activeToolReference=0;
    QString message="CNI bağlantısı kapalı";
    bool startAllowed=true;
    QString readerFile,lastReaderDetail,lastReaderStage,metadataDetail;QStringList readerArguments,metadataArguments;QByteArray readerError;
    bool isolatedMetadata=false,metadataWanted=false,metadataReceived=false;
};
