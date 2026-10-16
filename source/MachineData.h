#pragma once
#include <QObject>
#include <QSettings>
#include <QFileInfo>
#include <QDir>
#include <QVariantList>
#include <QTimer>
#include <algorithm>
#include <cmath>

// Read-only view of NcOne Dati files. It never changes machine data.
class MachineData : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString root READ root WRITE setRoot NOTIFY changed)
    Q_PROPERTY(QString status READ status NOTIFY changed)
    Q_PROPERTY(QVariantList axes READ axes NOTIFY changed)
    Q_PROPERTY(QVariantList origins READ origins NOTIFY changed)
    Q_PROPERTY(QVariantList tools READ tools NOTIFY changed)
    Q_PROPERTY(QVariantList magazineTools READ magazineTools NOTIFY changed)
    Q_PROPERTY(int magazineType READ magazineType NOTIFY changed)
    Q_PROPERTY(QString magazineTypeName READ magazineTypeName NOTIFY changed)
    Q_PROPERTY(int magazinePocketCount READ magazinePocketCount NOTIFY changed)
    Q_PROPERTY(bool rotaryMagazine READ rotaryMagazine NOTIFY changed)
    Q_PROPERTY(QVariantList verticalDrills READ verticalDrills NOTIFY changed)
    Q_PROPERTY(int rearLeftOrigin READ rearLeftOrigin NOTIFY changed)
    Q_PROPERTY(int rearRightOrigin READ rearRightOrigin NOTIFY changed)
    Q_PROPERTY(int frontLeftOrigin READ frontLeftOrigin NOTIFY changed)
    Q_PROPERTY(int frontRightOrigin READ frontRightOrigin NOTIFY changed)
public:
    explicit MachineData(QObject *parent=nullptr):QObject(parent){
        refresh();poll.setInterval(2000);connect(&poll,&QTimer::timeout,this,[this]{if(fileSignature()!=signature)refresh();});poll.start();
    }
    QString root()const{return base;} QString status()const{return message;}
    QVariantList axes()const{return axisRows;} QVariantList origins()const{return originRows;}
    QVariantList tools()const{return toolRows;} QVariantList magazineTools()const{return magazineRows;}
    int magazineType()const{return activeMagazineType;}
    QString magazineTypeName()const{return activeMagazineType==2?"Döner":activeMagazineType>0?"Sabit":"Tanımsız";}
    int magazinePocketCount()const{return magazineRows.size();}
    bool rotaryMagazine()const{return activeMagazineType==2;}
    QVariantList verticalDrills()const{return drillRows;}
    int rearLeftOrigin()const{return rearLeft;} int rearRightOrigin()const{return rearRight;}
    int frontLeftOrigin()const{return frontLeft;} int frontRightOrigin()const{return frontRight;}
    double axisMin(int i)const{return i>=0&&i<mins.size()?mins[i]:0;}
    double axisMax(int i)const{return i>=0&&i<maxs.size()?maxs[i]:1;}
    double axisReference(int i)const{return i>=0&&i<references.size()?references[i]:0;}
    void setRoot(const QString& value){base=QDir::cleanPath(value);refresh();}
    Q_INVOKABLE void refresh(){
        axisRows.clear();originRows.clear();toolRows.clear();magazineRows.clear();drillRows.clear();mins.clear();maxs.clear();references.clear();activeMagazineType=0;
        const QString data=base+"/Dati/";
        const QString axisFile=data+"datassi_01_dat.ini",originFile=data+"datvari_dat.ini";
        const QString generalFile=data+"fametec_dat.ini",toolFile=data+"datpunt_dat.ini",magFile=data+"datmag_01_dat.ini";
        if(!QFileInfo::exists(axisFile)||!QFileInfo::exists(originFile)||!QFileInfo::exists(toolFile)){
            message="Dati klasörü veya gerekli NcOne dosyaları bulunamadı";emit changed();return;
        }
        QSettings ax(axisFile,QSettings::IniFormat);
        for(const QString& g:ax.childGroups()) if(g.startsWith("AX_")){
            ax.beginGroup(g);int index=g.mid(3).toInt();double origin=ax.value("ORIG").toDouble();
            double lo=ax.value("FINDW").toDouble(),hi=ax.value("FINUP").toDouble(),recovery=ax.value("QRIP").toDouble();ax.endGroup();
            while(mins.size()<=index){mins.append(0);maxs.append(1);references.append(0);}mins[index]=lo;maxs[index]=hi;references[index]=origin;
            axisRows.append(QVariantMap{{"index",index},{"name",index==0?"X":index==1?"Y":index==2?"Z":QString("A%1").arg(index)},
                {"machineZero",origin},{"min",lo},{"max",hi},{"recovery",recovery}});
        }
        QSettings org(originFile,QSettings::IniFormat);
        for(const QString& g:org.childGroups()) if(g.startsWith("DATORIG_")){
            org.beginGroup(g);QString name=org.value("NOME").toString();int number=name.mid(4).toInt();
            originRows.append(QVariantMap{{"number",number},{"name",name},{"x",org.value("OFFX").toDouble()},
                {"y",org.value("OFFY").toDouble()},{"z",org.value("OFFZ").toDouble()},
                {"additionalX",org.value("OFFDX").toDouble()},{"additionalY",org.value("OFFDY").toDouble()},
                {"additionalZ",org.value("OFFDZ").toDouble()},{"translateX",org.value("TRASL_X").toInt()!=0},
                {"translateY",org.value("TRASL_Y").toInt()!=0},{"mirrorX",org.value("SPEC_X").toInt()!=0},
                {"corner",org.value("CORNER").toInt()},{"disabled",org.value("DISABLE").toInt()!=0}});org.endGroup();
        }
        QSettings gen(generalFile,QSettings::IniFormat);gen.beginGroup("GENERAL000");
        rearLeft=gen.value("ORIG_SX").toInt();rearRight=gen.value("ORIG_DX").toInt();
        frontLeft=gen.value("ORIG_SXP").toInt();frontRight=gen.value("ORIG_DXP").toInt();gen.endGroup();
        QVariantList configuredPockets;QSettings mags(magFile,QSettings::IniFormat);
        for(const QString& g:mags.childGroups()) if(g.startsWith("CMB_")){
            mags.beginGroup(g);
            const int pocket=mags.value("PMAG").toInt(),type=mags.value("TIPO").toInt();
            const bool disabled=mags.value("DISABLE").toInt()!=0;
            if(!disabled&&pocket>0) {
                if(activeMagazineType==0)activeMagazineType=type;
                if(type==activeMagazineType)configuredPockets.append(QVariantMap{
                    {"pocket",pocket},{"magazine",mags.value("NMAG").toInt()},{"type",type},
                    {"angle",mags.value("CrtMAG").toDouble()},{"machineAngle",mags.value("CrMAG").toDouble()},
                    {"x",mags.value("XMAG").toDouble()},{"y",mags.value("YMAG").toDouble()},
                    {"z",mags.value("ZMAG").toDouble()},{"occupied",false},{"toolId",0},
                    {"name",QString()},{"diameter",0.0},{"length",0.0}});
            }
            mags.endGroup();
        }
        std::sort(configuredPockets.begin(),configuredPockets.end(),[](const QVariant& a,const QVariant& b){
            return a.toMap().value("pocket").toInt()<b.toMap().value("pocket").toInt();
        });
        QSettings tl(toolFile,QSettings::IniFormat);
        for(const QString& g:tl.childGroups()) if(g.startsWith("PANT_")){
            tl.beginGroup(g);int pocket=tl.value("PMAG").toInt();QVariantMap row{{"id",g.mid(5).toInt()},
                {"name",tl.value("NOME").toString()},{"diameter",tl.value("DIAM").toDouble()},
                {"length",tl.value("LUNG").toDouble()},{"pocket",pocket},{"magazine",0},
                {"maxRpm",tl.value("VMAX").toDouble()},{"workRpm",tl.value("VROT").toDouble()}};
            toolRows.append(row);tl.endGroup();
        }
        for(auto& value:configuredPockets) {
            auto pocket=value.toMap();
            for(const auto& toolValue:toolRows) {
                const auto tool=toolValue.toMap();
                if(tool.value("pocket").toInt()!=pocket.value("pocket").toInt())continue;
                pocket["occupied"]=true;pocket["toolId"]=tool.value("id");pocket["name"]=tool.value("name");
                pocket["diameter"]=tool.value("diameter");pocket["length"]=tool.value("length");break;
            }
            value=pocket;magazineRows.append(pocket);
        }
        for(auto& value:toolRows) {
            auto tool=value.toMap();
            for(const auto& pocketValue:magazineRows) {
                const auto pocket=pocketValue.toMap();
                if(tool.value("pocket").toInt()==pocket.value("pocket").toInt()) {tool["magazine"]=pocket.value("magazine");break;}
            }
            value=tool;
        }
        QSettings mand(data+"protmand_dat.ini",QSettings::IniFormat),assigned(data+"datconf_01_dat.ini",QSettings::IniFormat),offsets(data+"datmand_01_dat.ini",QSettings::IniFormat);
        for(const QString& group:mand.childGroups()) {
            const QString channel=mand.value(group+"/name").toString();
            bool channelOk=false;const int number=channel.mid(1).toInt(&channelOk);
            if(!channel.startsWith('T')||!channelOk||number<1||mand.value(group+"/type").toString()!="VERT")continue;
            const QString toolName=assigned.value(group+"/UTE00").toString();
            for(const auto& value:toolRows) {
                const auto tool=value.toMap();if(toolName.isEmpty()||tool["name"].toString()!=toolName||tool["diameter"].toDouble()<=0)continue;
                bool okX=false,okY=false;const double x=offsets.value(group+"/OFFX").toDouble(&okX),y=offsets.value(group+"/OFFY").toDouble(&okY);
                if(okX&&okY&&std::isfinite(x)&&std::isfinite(y)&&std::abs(x)<500&&std::abs(y)<500)
                    drillRows.append(QVariantMap{{"tool",number},{"name",toolName},{"diameter",tool["diameter"]},{"mountX",x},{"mountY",y}});
                break;
            }
        }
        int occupied=0;for(const auto& value:magazineRows)if(value.toMap().value("occupied").toBool())++occupied;
        message=QString("%1 eksen · %2 orijin · %3 takım · %4 magazin: %5 yuva, %6 takım")
            .arg(axisRows.size()).arg(originRows.size()).arg(toolRows.size()).arg(magazineTypeName()).arg(magazineRows.size()).arg(occupied);
        signature=fileSignature();
        emit changed();
    }
signals:void changed();
private:
    QString base="C:/CNI/Ncone/MachineData/POYRAZ_VIGOR2136_ETH",message;
    QVariantList axisRows,originRows,toolRows,magazineRows,drillRows;QList<double> mins,maxs,references;
    int rearLeft=0,rearRight=0,frontLeft=0,frontRight=0,activeMagazineType=0;
    QTimer poll;QString signature;
    QString fileSignature()const{
        QString s;for(const QString& name:QStringList{"datassi_01_dat.ini","datvari_dat.ini","fametec_dat.ini","datpunt_dat.ini","datmag_01_dat.ini","protmand_dat.ini","datconf_01_dat.ini","datmand_01_dat.ini"}){
            QFileInfo f(base+"/Dati/"+name);s+=name+":"+QString::number(f.size())+":"+QString::number(f.lastModified().toMSecsSinceEpoch())+";";
        }return s;
    }
};
