#include <QGuiApplication>
#include <QTemporaryDir>
#include <QTextStream>
#include <random>
#include "../Machining.h"
#include "reference_machining.h"

int main(int argc,char** argv){
    QGuiApplication app(argc,argv);
    QTemporaryDir temporary;const auto root=temporary.path();
    QDir().mkpath(root+"/User/Prog");QDir().mkpath(root+"/Dati");
    auto write=[&](const QString& path,const QByteArray& data){QFile f(root+path);if(!f.open(QIODevice::WriteOnly))qFatal("fixture write failed");f.write(data);};
    write("/Dati/datpunt_dat.ini","[PANT_000]\nNOME=TEST6\nDIAM=6\n");
    QByteArray program="[PARAMETRI01]\nN1 LX=300 LY=280 LZ=18 G71\nN2 ST1=\"TEST6\" L=PATC\n";
    // Many short lines, overlapping passes, reversed X/Y, ramps and air moves.
    for(int i=0;i<300;++i){
        const int x=11+(i%12)*22,y=11+((i/12)%12)*22,line=10+i*4;
        program+=QString("N%1 X%2 Y%3 PRF=6 QVD=600 QVF=600 L=PON\nN%4 G1 X%5 Y%6\nN%7 G1 X%2 Y%8 ZI%9\nN%10 L=PUP\n")
            .arg(line).arg(x).arg(y).arg(line+1).arg(x+10).arg(y).arg(line+2).arg(y+10).arg(i%2?12:18).arg(line+3).toUtf8();
    }
    write("/User/Prog/test.pcni",program);
    Motion motion,oldMotion;Pcni pcni;ReferencePcni oldPcni;pcni.setRoot(root);oldPcni.setRoot(root);
    StockGeometry stock,oldStock;Machining current(motion,pcni,stock);ReferenceMachining reference(oldMotion,oldPcni,oldStock);
    int comparisons=0,failures=0,notifications=0;
    QObject::connect(&current,&Machining::changed,[&]{++notifications;});
    QJsonObject frame{{"metadataValid",true},{"workValid",true},{"panelFrameValid",true},{"spoilboard",18.0},{"executing",true},{"program",root+"/User/Prog/test.pcni"}};
    double currentNs=0,referenceNs=0;
    auto compare=[&](double x,double y,double depth){
        frame["workX"]=x;frame["workY"]=y;frame["workZ"]=depth-36;
        QElapsedTimer clock;clock.start();reference.snapshot(frame);referenceNs+=clock.nsecsElapsed();
        clock.restart();current.snapshot(frame);currentNs+=clock.nsecsElapsed();
        ++comparisons;
        if(current.status()!=reference.status()||current.error()!=reference.error()||current.tool()!=reference.tool()
            ||current.depth()!=reference.depth()||current.drilling()!=reference.drilling()||current.activeDrills()!=reference.activeDrills()
            ||stock.removed()!=oldStock.removed())++failures;
        if(comparisons%25==0){stock.flush();oldStock.flush();if(stock.vertexData()!=oldStock.vertexData())++failures;}
    };
    compare(11,11,6);
    const int firstNotifications=notifications;
    const double referenceBeforeRepeat=referenceNs,currentBeforeRepeat=currentNs;
    const bool pathsEqual=pcni.property("points").toList()==oldPcni.property("points").toList();if(!pathsEqual)++failures;
    for(int i=0;i<500;++i)compare(11,11,6);
    const int repeatedNotifications=notifications-firstNotifications;
    const double referenceRepeat=referenceNs-referenceBeforeRepeat,currentRepeat=currentNs-currentBeforeRepeat;
    if(repeatedNotifications!=0)++failures;
    std::mt19937 random(2142);
    for(int i=0;i<300;++i){
        if(i%120==0){frame["executing"]=false;compare(11,11,0);frame["executing"]=true;}
        const double epsilon=(i%3-1)*1e-10;
        compare(11+(random()%280)+epsilon,11+(random()%260),i%9-1);
    }
    frame["metadataValid"]=false;compare(20,20,6);
    frame["metadataValid"]=true;frame["panelFrameValid"]=false;compare(20,20,6);
    frame["panelFrameValid"]=true;frame["workValid"]=false;compare(20,20,6);
    stock.flush();oldStock.flush();if(stock.vertexData()!=oldStock.vertexData())++failures;
    QFile report(app.arguments().value(1));if(!report.open(QIODevice::WriteOnly))return 2;
    QTextStream out(&report);out<<"comparisons="<<comparisons<<"\nfailures="<<failures
        <<"\nunchanged_samples=500\nunchanged_ui_notifications="<<repeatedNotifications
        <<"\nreference_snapshot_ms="<<referenceNs/1e6<<"\noptimized_snapshot_ms="<<currentNs/1e6
        <<"\nreference_repeated_ms="<<referenceRepeat/1e6<<"\noptimized_repeated_ms="<<currentRepeat/1e6<<"\nparser_points_equal="<<pathsEqual
        <<"\nexact_geometry_equal="<<(stock.vertexData()==oldStock.vertexData())<<"\n";
    return failures?1:0;
}
