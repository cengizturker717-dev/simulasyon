#pragma once
#include <QGuiApplication>
#include <QTemporaryDir>
#include <QEventLoop>
#include <QTimer>
#include <QTextStream>
#include "../Machining.h"

inline int runMachiningChecks(const QString& reportPath) {
    int checks=0;QString error;
    auto check=[&](bool ok,const QString& name){++checks;if(!ok){error+=name+"\n";qCritical()<<name;}};
    QTemporaryDir temporary;QString root=temporary.path();QDir().mkpath(root+"/User/Prog");QDir().mkpath(root+"/Dati");
    auto write=[&](const QString& name,const QByteArray& bytes){QFile f(root+"/"+name);f.open(QIODevice::WriteOnly);f.write(bytes);};
    write("Dati/datpunt_dat.ini","[PANT_000]\nNOME=DRILL3\nDIAM=3\n[PANT_001]\nNOME=DRILL5\nDIAM=5\n[PANT_002]\nNOME=TEST6\nDIAM=6\n");
    write("Dati/protmand_dat.ini","[MAND_000]\nname=T1\ntype=VERT\n[MAND_001]\nname=T2\ntype=VERT\n");
    write("Dati/datconf_01_dat.ini","[MAND_000]\nUTE00=DRILL3\n[MAND_001]\nUTE00=DRILL5\n");
    write("Dati/datmand_01_dat.ini","[MAND_000]\nOFFX=0\nOFFY=0\n[MAND_001]\nOFFX=32\nOFFY=0\n");
    const QByteArray program="[PARAMETRI01]\nN10 LX=100 LY=80 LZ=18 G71\n;TOOL=1, NAME=\"TEST6\", DIAMETER=6\nN20 ST1=\"TEST6\" L=PATC\nN30 X11 Y11 PRF=-10 QVD=600 QVF=600 L=PON\nN40 G1 X51 Y11 ZI16 F600\nN50 G1 X71 Y11 Z-6\nN60 G0 X71 Y21\nN70 L=PUP\nN80 X31 Y51 PRF=5 T=1,2 QVF=600 L=G99\nN90 L=PMOFF\n";
    write("User/Prog/test.pcni",program);
    Motion motion;Pcni pcni;pcni.setRoot(root);StockGeometry stock;Machining machining(motion,pcni,stock);
    QObject::connect(&motion,&Motion::routeReset,&stock,&StockGeometry::reset);
    check(pcni.load("test.pcni"),"parse vertical cycles");
    check(pcni.property("width").toDouble()==100&&pcni.property("height").toDouble()==80&&pcni.property("thickness").toDouble()==18,"panel parameters");
    check(pcni.property("holeCount").toInt()==2,"simultaneous drills");
    auto path=pcni.property("points").toList();bool ramp=false,absolute=false,rapid=false;
    for(const auto& v:path){auto p=v.toMap();if(p["line"].toInt()==40)ramp=p["depth"].toDouble()==6;if(p["line"].toInt()==50)absolute=p["depth"].toDouble()==12;if(p["line"].toInt()==60)rapid=p["travel"].toBool();}
    check(ramp&&absolute&&rapid,"PRF negative / ZI ramp / absolute Z / rapid");
    check(machining.load(),"load stock and motion");
    QEventLoop loop;QObject::connect(&motion,&Motion::finished,&loop,&QEventLoop::quit);QTimer::singleShot(3000,&loop,&QEventLoop::quit);motion.setSpeed(3);motion.play();loop.exec();stock.flush();
    check(!motion.running(),"motion reaches completion");
    check(stock.heightAt(11,11)==18,"air entry preserves stock");
    check(stock.heightAt(43,11)>12&&stock.heightAt(43,11)<18,"ramp removes partial depth");
    check(stock.heightAt(71,11)==6,"absolute Z produces 12 mm depth");
    check(stock.heightAt(71,19)==18,"G0 never cuts");
    check(stock.heightAt(31,51)==13&&stock.heightAt(63,51)==13,"3 and 5 mm drill bank creates 5 mm blind holes");
    check(stock.heightAt(47,51)==18,"no cut between simultaneous drill positions");
    double volume=stock.removed();stock.cutProfile(11,31,-20,71,31,-1,6,false);check(stock.removed()==volume,"negative depth never cuts");
    stock.cutProfile(11,31,30,71,31,30,6,false);check(stock.heightAt(31,31)==0,"through depth clamps at panel bottom");
    write("User/Prog/bad.pcni",QByteArray(program).replace("ZI16","ZIVAR"));check(!pcni.load("bad.pcni"),"unresolved expression rejected");
    write("User/Prog/bad.pcni",QByteArray(program).replace("G1 X51","G2 X51"));check(!pcni.load("bad.pcni"),"unsupported arc rejected");
    write("User/Prog/bad.pcni",QByteArray(program).replace("TEST6\" L=PATC","UNKNOWN\" L=PATC"));check(!pcni.load("bad.pcni"),"unknown tool diameter rejected");
    write("User/Prog/bad.pcni",QByteArray(program).replace("PRF=-10","PRF=BAD"));check(!pcni.load("bad.pcni"),"invalid plunge rejected");
    check(!pcni.load(root+"/Dati/datpunt_dat.ini"),"active program outside program directory rejected");
    check(pcni.load("\""+root+"/User/Prog/test.pcni\""),"quoted active program path accepted");
    write("User/Prog/bad.pcni",QByteArray(program).replace("T=1,2","T=99"));check(!pcni.load("bad.pcni")&&pcni.property("status").toString().contains("T99"),"unknown drill reports its name without crashing");
    QJsonObject snapshot{{"metadataValid",true},{"workValid",true},{"panelFrameValid",true},{"spoilboard",99.0},{"workX",31.0},{"workY",51.0},{"workZ",-119.0},{"executing",true},{"program",root+"/User/Prog/test.pcni"},{"originX",100.0},{"originY",200.0},{"originZ",-100.0},{"x",131.0},{"y",251.0},{"z",-120.0}};
    const double beforeUnnamed=stock.removed();auto unnamed=snapshot;unnamed["program"]="";
    machining.snapshot(unnamed);machining.snapshot(unnamed);
    check(!machining.error()&&!machining.liveJob()&&machining.status().contains("program adı bekleniyor")&&stock.removed()==beforeUnnamed,"empty startup program waits without error or material removal");
    machining.snapshot(snapshot);check(machining.liveJob()&&stock.removed()==0,"live Start loads fresh panel without air cuts");
    snapshot["workZ"]=-112.0;machining.snapshot(snapshot);stock.flush();check(stock.heightAt(31,51)==13&&stock.heightAt(63,51)==13,"live drill uses corrected coordinates and 99 mm spoilboard datum");
    volume=stock.removed();unnamed=snapshot;unnamed["program"]="";unnamed["workZ"]=-109.0;machining.snapshot(unnamed);
    check(!machining.error()&&machining.liveJob()&&stock.removed()==volume,"temporary missing program preserves processed stock without cutting");
    machining.snapshot(snapshot);check(stock.removed()==volume&&machining.liveJob(),"same named program resumes without resetting processed stock");
    volume=stock.removed();snapshot["workValid"]=false;snapshot["workZ"]=-109.0;machining.snapshot(snapshot);check(stock.removed()==volume,"missing tool correction freezes material removal");snapshot["workValid"]=true;
    snapshot["panelFrameValid"]=false;machining.snapshot(snapshot);check(stock.removed()==volume,"missing spoilboard datum freezes material removal");snapshot["panelFrameValid"]=true;
    volume=stock.removed();snapshot["executing"]=false;snapshot["z"]=-108.0;machining.snapshot(snapshot);check(stock.removed()==volume,"stop prevents material removal");
    snapshot["metadataValid"]=false;machining.snapshot(snapshot);check(stock.removed()==volume,"stale program metadata prevents material removal");
    machining.disconnectLive();check(stock.removed()==volume,"disconnect preserves processed stock");
    write("User/Prog/missing.pcni",QByteArray(program).replace("TEST6","6MMZ3"));snapshot["metadataValid"]=true;snapshot["executing"]=true;snapshot["program"]=root+"/User/Prog/missing.pcni";machining.snapshot(snapshot);
    check(machining.error()&&machining.status().contains("6MMZ3 takımı takım kütüphanesinde tanımlı değil"),"Start exposes unknown tool error on simulation page");
    unnamed=snapshot;unnamed["program"]="";machining.snapshot(unnamed);
    check(machining.error()&&machining.status().contains("6MMZ3 takımı takım kütüphanesinde tanımlı değil")&&stock.removed()==0,"missing program never clears a genuine unknown tool error");
    snapshot["z"]=-108.0;machining.snapshot(snapshot);check(stock.removed()==0,"unknown tool blocks all material removal");
    // Actual CNC polling may miss the short bottom-to-retract transition.
    write("User/Prog/drill.pcni","[PARAMETRI01]\nN1 LX=100 LY=80 LZ=18 G71\nN10 X31 Y51 PRF=5 T=1,2 QVF=3 L=G99\n");
    Motion drillMotion;Pcni drillPcni;drillPcni.setRoot(root);StockGeometry drillStock;Machining drillJob(drillMotion,drillPcni,drillStock);
    int drillGroupNotifications=0;
    QObject::connect(&drillJob,&Machining::activeDrillsChanged,&drillJob,[&]{++drillGroupNotifications;});
    QJsonObject drillSnapshot{{"metadataValid",true},{"workValid",true},{"panelFrameValid",true},{"spoilboard",99.0},{"workX",31.0},{"workY",51.0},{"workZ",-113.0},{"targetValid",true},{"targetX",31.0},{"targetY",51.0},{"targetZ",-112.0},{"executing",true},{"program",root+"/User/Prog/drill.pcni"}};
    drillJob.snapshot(drillSnapshot);check(drillStock.heightAt(31,51)==14&&drillJob.completedHoles()==0,"bottom target alone does not finish a hole");
    const int initialDrillNotifications=drillGroupNotifications;
    for(int i=0;i<30;++i)drillJob.snapshot(drillSnapshot);
    check(initialDrillNotifications==1&&drillGroupNotifications==1&&drillJob.activeDrills().size()==2,"unchanged drill group retains its 3D instances across depth samples");
    drillSnapshot["targetZ"]=-137.0;drillSnapshot["workZ"]=-115.0;drillJob.snapshot(drillSnapshot);
    check(drillStock.heightAt(31,51)==13&&drillStock.heightAt(63,51)==13&&drillJob.completedHoles()==2,"confirmed retract completes both programmed blind holes when bottom sample is missed");
    drillJob.snapshot(drillSnapshot);check(drillJob.completedHoles()==2&&drillStock.heightAt(47,51)==18,"retract neither repeats holes nor cuts between them");
    auto startDrill=[&](double d){drillSnapshot["executing"]=false;drillJob.snapshot(drillSnapshot);drillSnapshot["executing"]=true;drillSnapshot["metadataValid"]=true;drillSnapshot["targetValid"]=true;drillSnapshot["workX"]=31.0;drillSnapshot["targetZ"]=-112.0;drillSnapshot["workZ"]=d-117;drillJob.snapshot(drillSnapshot);};
    startDrill(4);drillSnapshot["executing"]=false;drillSnapshot["targetZ"]=-137.0;drillSnapshot["workZ"]=-115.0;drillJob.snapshot(drillSnapshot);check(drillStock.heightAt(31,51)==14&&drillJob.completedHoles()==0,"Stop never finishes a pending hole");
    startDrill(4);drillSnapshot["metadataValid"]=false;drillJob.snapshot(drillSnapshot);drillSnapshot["metadataValid"]=true;drillSnapshot["targetZ"]=-137.0;drillSnapshot["workZ"]=-115.0;drillJob.snapshot(drillSnapshot);check(drillStock.heightAt(31,51)==14&&drillJob.completedHoles()==0,"metadata gap discards pending hole completion");
    startDrill(4);drillSnapshot["targetValid"]=false;drillJob.snapshot(drillSnapshot);drillSnapshot["targetValid"]=true;drillSnapshot["targetZ"]=-137.0;drillSnapshot["workZ"]=-115.0;drillJob.snapshot(drillSnapshot);check(drillStock.heightAt(31,51)==14&&drillJob.completedHoles()==0,"target data gap discards pending hole completion");
    startDrill(4);drillSnapshot["workX"]=41.0;drillSnapshot["targetZ"]=-137.0;drillSnapshot["workZ"]=-115.0;drillJob.snapshot(drillSnapshot);check(drillStock.heightAt(31,51)==14&&drillJob.completedHoles()==0,"XY jump cannot finish pending hole");
    startDrill(1);drillSnapshot["targetZ"]=-137.0;drillSnapshot["workZ"]=-117.0;drillJob.snapshot(drillSnapshot);check(drillStock.heightAt(31,51)==17&&drillJob.completedHoles()==0,"early retract far above bottom cannot finish a hole");
    startDrill(2);drillSnapshot["targetZ"]=-137.0;drillSnapshot["workZ"]=-113.0;drillJob.snapshot(drillSnapshot);drillSnapshot["workZ"]=-115.0;drillJob.snapshot(drillSnapshot);check(drillStock.heightAt(31,51)==13&&drillJob.completedHoles()==2,"actual descent may continue after the retract target becomes visible");
    write("User/Prog/drill.pcni","[PARAMETRI01]\nN1 LX=100 LY=80 LZ=18 G71\nN10 X31 Y51 PRF=18 T=1 QVF=3 L=G99\n");
    drillSnapshot["executing"]=false;drillJob.snapshot(drillSnapshot);drillSnapshot["executing"]=true;drillSnapshot["targetZ"]=-99.0;drillSnapshot["workZ"]=-100.2;drillJob.snapshot(drillSnapshot);drillSnapshot["targetZ"]=-137.0;drillSnapshot["workZ"]=-103.0;drillJob.snapshot(drillSnapshot);check(drillStock.heightAt(31,51)==0&&drillJob.completedHoles()==1,"missed bottom of through drilling still opens programmed hole after confirmed retract");
    // A raised tool may cross the XY projection of a much later ramp. That
    // air move must not consume the future operation and skip intervening cuts.
    write("User/Prog/air-crossing.pcni","[PARAMETRI01]\nN1 LX=100 LY=80 LZ=18 G71\nN20 ST1=\"TEST6\" L=PATC\nN30 X11 Y11 PRF=6 QVD=3 QVF=3 L=PON\nN40 G1 X51 Y11\nN50 L=PUP\nN60 X11 Y31 PRF=6 QVD=3 QVF=3 L=PON\nN70 G1 X51 Y31\nN80 L=PUP\nN90 X31 Y21 PRF=-10 QVD=3 QVF=3 L=PON\nN100 G1 X41 Y21 ZI16\nN110 G1 X61 Y21\nN120 L=PUP\n");
    Motion airMotion;Pcni airPcni;airPcni.setRoot(root);StockGeometry airStock;Machining airJob(airMotion,airPcni,airStock);
    QJsonObject airFrame{{"metadataValid",true},{"workValid",true},{"panelFrameValid",true},{"spoilboard",18.0},{"executing",true},{"program",root+"/User/Prog/air-crossing.pcni"}};
    auto airSample=[&](double x,double y,double d){airFrame["workX"]=x;airFrame["workY"]=y;airFrame["workZ"]=d-36;airJob.snapshot(airFrame);};
    airSample(11,11,6);airSample(51,11,6);const double beforeAir=airStock.removed();
    airSample(35,21,-10);check(airStock.removed()==beforeAir,"air crossing a later ramp never removes material");
    airSample(11,31,6);airSample(31,31,6);airSample(51,31,6);
    check(airStock.heightAt(31,31)==12&&airJob.status().startsWith("Canlı işleme · N70"),"air crossing a later ramp cannot skip the next actual contour");
    QFile report(reportPath);report.open(QIODevice::WriteOnly);QTextStream out(&report);out<<"checks="<<checks<<"\npassed="<<(error.isEmpty()?"true":"false")<<"\n"<<error;
    return error.isEmpty()?0:1;
}
