// V cutter profile checks for StockGeometry::cutProfile (no controller, no UI).
#include <QGuiApplication>
#include <QTextStream>
#include <cmath>
#include "../StockGeometry.h"
#include "../Pcni.h"

// VCutChecks <machine root> <program> <tool> <x> <y0> <y1>: cut that tool's
// moves of a real PCNI program and print the groove section along x=<x>.
static int programSection(const QStringList& a){
    QTextStream out(stdout);
    Pcni pcni;pcni.setRoot(a[1]);
    if(!pcni.load(a[2])){out<<"load failed: "<<pcni.property("status").toString()<<"\n";return 2;}
    StockGeometry stock;stock.configure(pcni.property("width").toDouble(),pcni.property("height").toDouble(),pcni.property("thickness").toDouble(),8);
    const auto points=pcni.property("points").toList();int segments=0;double angle=0,diameter=0;
    for(int i=1;i<points.size();++i){
        const auto p=points[i-1].toMap(),q=points[i].toMap();
        if(q["travel"].toBool()||q["tool"].toString()!=a[3])continue;
        angle=q["angle"].toDouble();diameter=q["diameter"].toDouble();++segments;
        stock.cutProfile(p["x"].toDouble(),p["y"].toDouble(),p["depth"].toDouble(),q["x"].toDouble(),q["y"].toDouble(),q["depth"].toDouble(),diameter,false,angle);
    }
    stock.flush();
    out<<a[3]<<" segments="<<segments<<" diameter="<<diameter<<" angle="<<angle<<" removed_cm3="<<stock.removed()<<"\n";
    const double x=a[4].toDouble(),thick=pcni.property("thickness").toDouble();double width=0;
    for(double y=a[5].toDouble();y<=a[6].toDouble()+1e-9;y+=2){const double d=thick-stock.heightAt(x,y);if(d>0.01)width+=2;out<<"  y="<<y<<" depth="<<d<<"\n";}
    out<<"groove_width_mm~"<<width<<"\n";
    return 0;
}

int main(int argc,char** argv){
    QGuiApplication app(argc,argv);
    if(argc==7)return programSection(app.arguments());
    QTextStream out(stdout);int failed=0;
    auto check=[&](bool ok,const QString& what){out<<(ok?"ok   ":"FAIL ")<<what<<"\n";if(!ok)++failed;};
    // 18 mm board (2 mm grid, cell centres on odd mm), line along X at y=51, 3 mm deep.
    StockGeometry flat;flat.configure(200,100,18,8);flat.cutProfile(20,51,3,180,51,3,8,false);flat.flush();
    StockGeometry vee;vee.configure(200,100,18,8);vee.cutProfile(20,51,3,180,51,3,8,false,90);vee.flush();
    auto depthAt=[](StockGeometry& s,double x,double y){return 18.0-s.heightAt(x,y);};
    // Flat 8 mm cutter: full 3 mm depth everywhere within 4 mm of the line.
    check(std::abs(depthAt(flat,100,51)-3)<.2,"flat centre depth 3");
    check(std::abs(depthAt(flat,100,54)-3)<.2,"flat 3 mm off-centre still 3 deep");
    // 90 degree V: depth = 3 - offset; groove half width 3 mm (< 4 mm radius).
    check(std::abs(depthAt(vee,100,51)-3)<.05,"V centre depth ~3");
    check(std::abs(depthAt(vee,100,53)-1)<.05,"V 2 mm off-centre depth ~1");
    check(depthAt(vee,100,55)<.05,"V 4 mm off-centre untouched");
    check(vee.removed()<flat.removed()*0.6,"V removes less material than flat");
    // Deep V: width capped at the tool diameter (8 mm), 10 mm deep 60 degree.
    StockGeometry deep;deep.configure(200,100,18,8);deep.cutProfile(20,51,10,180,51,10,8,false,60);deep.flush();
    check(depthAt(deep,100,57)<.05,"V never wider than its diameter");
    out<<"failed="<<failed<<"\n";
    return failed?1:0;
}
