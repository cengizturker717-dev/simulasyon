#pragma once
#include <QSettings>
#include <QVariantMap>
#include <cmath>

// One machine frame, established from setup files before live Start. Program
// dimensions, active work corrections and EXE never relocate the CAD assembly.
inline QVariantMap machineSceneFrame(const QString& root,double refX,double refY,double refZ) {
    QVariantMap frame{{"calibrated",false},{"reference",QString()},{"drillCalibrated",false},{"routerCalibrated",false},
        {"bridgeHome",-1.91008632},{"carriageHome",-1.05},{"zHome",0.0},
        {"routerX",0.0},{"routerY",0.0},{"routerZ",0.0}};
    const QString dir=root+"/Dati/";
    QSettings general(dir+"fametec_dat.ini",QSettings::IniFormat),origins(dir+"datvari_dat.ini",QSettings::IniFormat);
    QSettings mand(dir+"protmand_dat.ini",QSettings::IniFormat),offsets(dir+"datmand_01_dat.ini",QSettings::IniFormat);
    QSettings assigned(dir+"datconf_01_dat.ini",QSettings::IniFormat),tools(dir+"datpunt_dat.ini",QSettings::IniFormat);
    const int origin=general.value("GENERAL000/ORIG_SX").toInt();
    QString originGroup,famGroup,routerGroup;
    for(const auto& g:origins.childGroups())if(origins.value(g+"/NOME").toString()=="ORIG"+QString::number(origin))originGroup=g;
    for(const auto& g:mand.childGroups()) {
        if(mand.value(g+"/name").toString()=="T1"&&mand.value(g+"/type").toString()=="VERT")famGroup=g;
        if(mand.value(g+"/name").toString()=="TP1"&&mand.value(g+"/type").toString()=="PANT")routerGroup=g;
    }
    auto length=[&](const QString& group){const QString name=assigned.value(group+"/UTE00").toString();
        for(const auto& g:tools.childGroups())if(!name.isEmpty()&&tools.value(g+"/NOME").toString()==name)return tools.value(g+"/LUNG").toDouble();return 0.0;};
    auto read=[](const QSettings& ini,const QString& key){bool ok=false;const double n=ini.value(key).toDouble(&ok);return ok&&std::isfinite(n)?n:NAN;};
    const double fl=length(famGroup),rl=length(routerGroup);
    if(originGroup.isEmpty())return frame;
    const double ox=read(origins,originGroup+"/OFFX"),oy=read(origins,originGroup+"/OFFY"),oz=read(origins,originGroup+"/OFFZ");
    const double fx=read(offsets,famGroup+"/OFFX"),fy=read(offsets,famGroup+"/OFFY"),fz=read(offsets,famGroup+"/OFFZ");
    const double rx=read(offsets,routerGroup+"/OFFX"),ry=read(offsets,routerGroup+"/OFFY"),rz=read(offsets,routerGroup+"/OFFZ");
    const double spoil=read(general,"GENERAL000/CSag");
    for(double n:{ox,oy,oz,spoil,refX,refY,refZ})if(!std::isfinite(n))return frame;
    const bool famValid=!famGroup.isEmpty()&&std::isfinite(fl)&&fl>0&&std::isfinite(fx)&&std::isfinite(fy)&&std::isfinite(fz);
    const bool routerValid=!routerGroup.isEmpty()&&std::isfinite(rl)&&rl>0&&std::isfinite(rx)&&std::isfinite(ry)&&std::isfinite(rz);
    if(!famValid&&!routerValid)return frame;
    frame["calibrated"]=true;
    frame["drillCalibrated"]=famValid;frame["routerCalibrated"]=routerValid;
    // Real router-only configurations may leave T1 unassigned and its offsets
    // disabled/placeholder (e.g. OFFX=999). Do not let that invalidate TP1 or
    // borrow its unknown drill length. Anchor the unchanged CAD to TP1 itself.
    if(!famValid){
        frame["reference"]="TP1";
        frame["bridgeHome"]=-1.017-.02517972-(ox-rx-refX)/1000;
        frame["carriageHome"]=-1.2046434+.21110186-(oy-ry-refY)/1000;
        frame["zHome"]=1.0825051+(oz-rz-rl-spoil-refZ)/1000-1.27960551;
        return frame;
    }
    frame["reference"]="T1";
    frame["bridgeHome"]=-1.017-.048644-(ox-fx-refX)/1000;
    frame["carriageHome"]=-1.2046434-.073707-(oy-fy-refY)/1000;
    frame["zHome"]=1.0825051+(oz-fz-fl-spoil-refZ)/1000-1.3783175;
    // Constant mounting offsets reconcile the source CAD tip references with
    // the configured spindle/drill bank. They do not depend on tool selection.
    if(routerValid){
        frame["routerX"]=(rx-fx)/1000+.02346428;
        frame["routerZ"]=(ry-fy)/1000+.28480886;
        frame["routerY"]=(fz+fl-rz-rl)/1000+.09871199;
    }
    return frame;
}
