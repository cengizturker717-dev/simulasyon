// V cutter profile checks for StockGeometry::cutProfile (no controller, no UI).
#include <QGuiApplication>
#include <QTextStream>
#include <cmath>
#include "../StockGeometry.h"

int main(int argc,char** argv){
    QGuiApplication app(argc,argv);
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
