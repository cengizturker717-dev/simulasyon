#pragma once
#include <QObject>
#include <QSettings>
#include <QFileInfo>
#include <QCoreApplication>
#include <QHash>

class VigorProfile : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString model READ model NOTIFY changed)
    Q_PROPERTY(int length READ length NOTIFY changed)
    Q_PROPERTY(int width READ width CONSTANT)
    Q_PROPERTY(QString dataRoot READ dataRoot NOTIFY changed)
    Q_PROPERTY(bool dataAssigned READ dataAssigned NOTIFY changed)
public:
    explicit VigorProfile(bool persist=true,const QString& file={}):saved(persist),settings(file.isEmpty()?QCoreApplication::applicationDirPath()+"/../vigor-settings.ini":file,QSettings::IniFormat) {
        selected=settings.value("machine/model","2142").toString();if(!known(selected))selected="2142";
        if(!saved)selected="2142";
    }
    QString model()const{return selected;}
    int length()const{return selected=="2142"?4200:selected=="2136"?3660:2800;}
    int width()const{return 2100;}
    QString dataRoot()const{return overrides.value(selected,settings.value("data/"+selected,defaultRoot).toString());}
    bool dataAssigned()const{return (selected=="2142"||overrides.contains(selected)||settings.contains("data/"+selected))&&QFileInfo::exists(dataRoot()+"/Dati/datassi_01_dat.ini");}
    Q_INVOKABLE void select(const QString& value){if(!known(value)||value==selected)return;selected=value;if(saved)settings.setValue("machine/model",selected);emit changed();}
    Q_INVOKABLE void assignData(const QString& path){if(!QFileInfo::exists(path+"/Dati/datassi_01_dat.ini"))return;if(saved)settings.setValue("data/"+selected,path);else overrides.insert(selected,path);emit changed();}
signals:void changed();
private:
    static bool known(const QString& id){return id=="2142"||id=="2136"||id=="2128";}
    QString selected;bool saved;QSettings settings;
    QHash<QString,QString> overrides;
    const QString defaultRoot="C:/CNI/Ncone/MachineData/POYRAZ_VIGOR2136_ETH";
};
