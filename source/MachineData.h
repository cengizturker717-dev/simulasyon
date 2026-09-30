#pragma once
#include <QObject>
#include <QSettings>
#include <QFileInfo>
#include <QDir>
#include <QVariantList>
#include <QTimer>

// Read-only view of NcOne Dati files. It never changes machine data.
class MachineData : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString root READ root WRITE setRoot NOTIFY changed)
    Q_PROPERTY(QString status READ status NOTIFY changed)
    Q_PROPERTY(QVariantList axes READ axes NOTIFY changed)
    Q_PROPERTY(QVariantList origins READ origins NOTIFY changed)
    Q_PROPERTY(QVariantList tools READ tools NOTIFY changed)
    Q_PROPERTY(QVariantList magazineTools READ magazineTools NOTIFY changed)
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
    int rearLeftOrigin()const{return rearLeft;} int rearRightOrigin()const{return rearRight;}
    int frontLeftOrigin()const{return frontLeft;} int frontRightOrigin()const{return frontRight;}
    double axisMin(int i)const{return i>=0&&i<mins.size()?mins[i]:0;}
    double axisMax(int i)const{return i>=0&&i<maxs.size()?maxs[i]:1;}
    void setRoot(const QString& value){base=QDir::cleanPath(value);refresh();}
    Q_INVOKABLE void refresh(){
        axisRows.clear();originRows.clear();toolRows.clear();magazineRows.clear();mins.clear();maxs.clear();
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
            while(mins.size()<=index){mins.append(0);maxs.append(1);}mins[index]=lo;maxs[index]=hi;
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
        QHash<int,int> pocketMagazine;QSettings mags(magFile,QSettings::IniFormat);
        for(const QString& g:mags.childGroups()) if(g.startsWith("CMB_")){mags.beginGroup(g);pocketMagazine.insert(mags.value("PMAG").toInt(),mags.value("NMAG").toInt());mags.endGroup();}
        QSettings tl(toolFile,QSettings::IniFormat);
        for(const QString& g:tl.childGroups()) if(g.startsWith("PANT_")){
            tl.beginGroup(g);int pocket=tl.value("PMAG").toInt();QVariantMap row{{"id",g.mid(5).toInt()},
                {"name",tl.value("NOME").toString()},{"diameter",tl.value("DIAM").toDouble()},
                {"length",tl.value("LUNG").toDouble()},{"pocket",pocket},{"magazine",pocketMagazine.value(pocket,0)},
                {"maxRpm",tl.value("VMAX").toDouble()},{"workRpm",tl.value("VROT").toDouble()}};
            toolRows.append(row);if(pocket>0)magazineRows.append(row);tl.endGroup();
        }
        message=QString("%1 eksen · %2 orijin · %3 takım · magazinde %4 takım").arg(axisRows.size()).arg(originRows.size()).arg(toolRows.size()).arg(magazineRows.size());
        signature=fileSignature();
        emit changed();
    }
signals:void changed();
private:
    QString base="C:/CNI/Ncone/MachineData/POYRAZ_VIGOR2136_ETH",message;
    QVariantList axisRows,originRows,toolRows,magazineRows;QList<double> mins,maxs;
    int rearLeft=0,rearRight=0,frontLeft=0,frontRight=0;
    QTimer poll;QString signature;
    QString fileSignature()const{
        QString s;for(const QString& name:QStringList{"datassi_01_dat.ini","datvari_dat.ini","fametec_dat.ini","datpunt_dat.ini","datmag_01_dat.ini"}){
            QFileInfo f(base+"/Dati/"+name);s+=name+":"+QString::number(f.size())+":"+QString::number(f.lastModified().toMSecsSinceEpoch())+";";
        }return s;
    }
};
