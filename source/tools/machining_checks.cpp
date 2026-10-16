#include "machining_checks.h"
#include <QJsonDocument>

// Exercise the complete real program, including neighbouring closed contours.
// This is offline diagnostic input, never a machine command or inferred history.
static int sweep(const QString& program,const QString& reportPath) {
    Motion motion;Pcni pcni;pcni.setWorkLength(4200);StockGeometry stock;Machining machining(motion,pcni,stock);
    if(!pcni.load(program))return 2;const auto path=pcni.property("points").toList();
    QJsonObject frame{{"metadataValid",true},{"workValid",true},{"panelFrameValid",true},{"spoilboard",18.0},{"executing",true},{"program",program},{"targetValid",true}};
    QFile report(reportPath);if(!report.open(QIODevice::WriteOnly))return 2;QTextStream out(&report);
    int checked=0,missed=0;const double thickness=pcni.property("thickness").toDouble();
    for(qsizetype i=1;i<path.size();++i){const auto a=path[i-1].toMap(),b=path[i].toMap();
        const double ax=a["x"].toDouble(),ay=a["y"].toDouble(),ad=a["depth"].toDouble(),bx=b["x"].toDouble(),by=b["y"].toDouble(),bd=b["depth"].toDouble();
        const int steps=std::max(1,int(std::ceil(std::max(std::hypot(bx-ax,by-ay)/25,std::abs(bd-ad)/2))));
        frame["targetX"]=bx;frame["targetY"]=by;frame["targetZ"]=bd-thickness-18;
        for(int n=1;n<=steps;++n){const double t=double(n)/steps,x=ax+(bx-ax)*t,y=ay+(by-ay)*t,d=ad+(bd-ad)*t;
            frame["workX"]=x;frame["workY"]=y;frame["workZ"]=d-thickness-18;machining.snapshot(frame);
            if(b["kind"]=="router"&&!b["travel"].toBool()&&d>0){++checked;if(!machining.status().startsWith("Canlı işleme")){++missed;out<<"N"<<b["line"].toInt()<<" x="<<x<<" y="<<y<<" depth="<<d<<" "<<machining.status()<<"\n";}}
        }
    }
    stock.flush();out<<"checkedCuttingSamples="<<checked<<"\nmissedCuttingSamples="<<missed<<"\nremovedCm3="<<stock.removed()<<"\n";return missed?1:0;
}

// Replay recorded read-only telemetry without connecting to or commanding CNI.
static int replay(const QString& tracePath,const QString& reportPath,bool diagnose=false) {
    QFile trace(tracePath);if(!trace.open(QIODevice::ReadOnly))return 2;
    Motion motion;Pcni pcni;StockGeometry stock;Machining machining(motion,pcni,stock);
    int samples=0,targets=0;QString previousStatus;
    QFile diagnostics(reportPath+".csv");if(diagnose)diagnostics.open(QIODevice::WriteOnly);
    QTextStream detail(&diagnostics);
    if(diagnose)detail<<"sample,status,x,y,depth,targetX,targetY,targetDepth,nearestLine,nearestDistance\n";
    while(!trace.atEnd()) {
        const auto document=QJsonDocument::fromJson(trace.readLine());
        if(!document.isObject())continue;
        const auto frame=document.object();++samples;
        if(frame["targetValid"].toBool())++targets;
        machining.snapshot(frame);
        if(diagnose&&machining.status()!=previousStatus) {
            previousStatus=machining.status();
            const double x=frame["workX"].toDouble(),y=frame["workY"].toDouble();
            const double depth=stock.thickness()+frame["workZ"].toDouble()+frame["spoilboard"].toDouble();
            double nearest=1e9;int line=-1;const auto path=pcni.property("points").toList();
            for(qsizetype i=1;i<path.size();++i){const auto a=path[i-1].toMap(),b=path[i].toMap();if(b["travel"].toBool())continue;
                if(depth<std::min(a["depth"].toDouble(),b["depth"].toDouble())-1||depth>std::max(a["depth"].toDouble(),b["depth"].toDouble())+1)continue;
                const double vx=b["x"].toDouble()-a["x"].toDouble(),vy=b["y"].toDouble()-a["y"].toDouble(),len=vx*vx+vy*vy;
                const double t=len>0?std::clamp(((x-a["x"].toDouble())*vx+(y-a["y"].toDouble())*vy)/len,0.0,1.0):0;
                const double distance=std::hypot(x-a["x"].toDouble()-t*vx,y-a["y"].toDouble()-t*vy);
                if(distance<nearest){nearest=distance;line=b["line"].toInt();}
            }
            detail<<samples<<",\""<<previousStatus<<"\","<<x<<","<<y<<","<<depth<<","<<frame["targetX"].toDouble()<<","<<frame["targetY"].toDouble()<<","<<stock.thickness()+frame["targetZ"].toDouble()+frame["spoilboard"].toDouble()<<","<<line<<","<<nearest<<"\n";
        }
    }
    stock.flush();
    int full=0,partial=0,untouched=0;
    for(const auto& value:pcni.property("points").toList()) {
        const auto point=value.toMap();
        if(point["travel"].toBool()||point["kind"]!="drill"||point["depth"].toDouble()<=0)continue;
        for(const auto& drill:point["holes"].toList()) {
            const auto hole=drill.toMap();
            const double h=stock.heightAt(point["x"].toDouble()+hole["dx"].toDouble(),point["y"].toDouble()+hole["dy"].toDouble());
            const double expected=std::max(0.0,stock.thickness()-point["depth"].toDouble());
            if(h<=expected+.01)++full;
            else if(h<stock.thickness()-.01)++partial;
            else ++untouched;
        }
    }
    QFile report(reportPath);if(!report.open(QIODevice::WriteOnly))return 2;
    QTextStream out(&report);
    out<<"samples="<<samples<<"\ntargetSamples="<<targets<<"\nready="<<pcni.property("ready").toBool()
       <<"\nblocked="<<machining.error()<<"\ncompletedHoles="<<machining.completedHoles()
       <<"\nfullDepthHoleCenters="<<full<<"\npartialHoleCenters="<<partial<<"\nuntouchedHoleCenters="<<untouched
       <<"\nremovedCm3="<<stock.removed()<<"\nstatus="<<machining.status()<<"\n";
    return samples>0&&pcni.property("ready").toBool()&&!machining.error()?0:1;
}
int main(int argc,char** argv) {
    QGuiApplication app(argc,argv);
    if(argc==4&&QString::fromLocal8Bit(argv[1])=="--program-sweep")return sweep(QString::fromLocal8Bit(argv[2]),QString::fromLocal8Bit(argv[3]));
    if(argc==4&&(QString::fromLocal8Bit(argv[1])=="--replay"||QString::fromLocal8Bit(argv[1])=="--diagnose"))return replay(QString::fromLocal8Bit(argv[2]),QString::fromLocal8Bit(argv[3]),QString::fromLocal8Bit(argv[1])=="--diagnose");
    return runMachiningChecks(argc>1?QString::fromLocal8Bit(argv[1]):"machining-checks.txt");
}
