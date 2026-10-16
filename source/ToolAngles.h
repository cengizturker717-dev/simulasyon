#pragma once
#include <QCoreApplication>
#include <QSettings>
#include <QString>
#include <cmath>

// Tip angles of V (angled) router tools. NcOne's datpunt has no field for it,
// so the simulator keeps its own table beside the program, keyed by tool name
// (NOME). Dati stays read-only. The value is the included tip angle in
// degrees (90 = 45 per flank); 0 or missing means a flat-bottom cutter.
inline QString toolAngleFile(){return QCoreApplication::applicationDirPath()+"/../tool-angles.ini";}
inline double toolAngle(const QString& name){
    if(name.isEmpty())return 0;
    QSettings s(toolAngleFile(),QSettings::IniFormat);
    const double a=s.value("angles/"+name.toUtf8().toHex()).toDouble();
    return std::isfinite(a)&&a>0&&a<180?a:0;
}
inline void setToolAngle(const QString& name,double angle){
    if(name.isEmpty())return;
    QSettings s(toolAngleFile(),QSettings::IniFormat);
    const QString key="angles/"+name.toUtf8().toHex();
    if(std::isfinite(angle)&&angle>0&&angle<180){s.setValue(key,angle);s.setValue("names/"+name.toUtf8().toHex(),name);}
    else {s.remove(key);s.remove("names/"+name.toUtf8().toHex());}
}
