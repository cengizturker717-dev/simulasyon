#include <QGuiApplication>
#include <QTemporaryDir>
#include <QTextStream>
#include "../VigorProfile.h"
#include "../Machining.h"
#include "../SceneFrame.h"

int main(int argc,char** argv){
    QGuiApplication app(argc,argv);QTemporaryDir temp;const QString root=temp.path();
    QDir().mkpath(root+"/Dati");QDir().mkpath(root+"/User/Prog");
    auto write=[&](QString file,QByteArray bytes){QFile f(root+"/"+file);if(!f.open(QIODevice::WriteOnly))qFatal("fixture write failed");f.write(bytes);};
    write("Dati/datassi_01_dat.ini","[AX_0]\nFINUP=5235\n");
    write("Dati/datpunt_dat.ini","[PANT_000]\nNOME=TEST6\nDIAM=6\n");
    Motion motion;Pcni pcni;pcni.setRoot(root);StockGeometry stock;Machining machining(motion,pcni,stock);
    int checks=0;QString failures;auto check=[&](bool ok,QString label){++checks;if(!ok)failures+=label+"\n";};
    const QString config=root+"/profiles.ini";
    for(const QString id:{QString("2142"),QString("2136"),QString("2128")}){
        VigorProfile profile(true,config);profile.select(id);const int length=id=="2142"?4200:id=="2136"?3660:2800;
        check(profile.length()==length&&profile.width()==2100,"correct dimensions "+id);
        profile.assignData(root);check(profile.dataAssigned(),"separate data assigned "+id);
        {VigorProfile restored(true,config);check(restored.model()==id&&restored.dataRoot()==root,"persistent model/data "+id);}
        motion.clearPath();motion.setWorkLength(length);pcni.setWorkLength(length);motion.setAxis(0,9000);check(motion.x()==length,"manual limit "+id);
        const QByteArray program="[PARAMETRI01]\nN1 LX="+QByteArray::number(length)+" LY=2100 LZ=18 G71\nN2 ST1=\"TEST6\" L=PATC\nN3 X"+QByteArray::number(length-5)+" Y10 PRF=6 QVD=3 QVF=3 L=PON\nN4 X"+QByteArray::number(length-1)+" Y10 PRF=6 QVF=3 G1\nN5 L=PUP\n";
        write("User/Prog/test.pcni",program);check(pcni.load("test.pcni")&&machining.load(),"full length program accepted "+id);
        check(stock.stockWidth()==length&&stock.stockHeight()==2100&&machining.stockX()==-1.017&&machining.stockZ()==-1.2046434,"fixed stock corner "+id);
        stock.cutProfile(length-5,10,6,length-1,10,6,6,false);check(stock.heightAt(length-3,10)==12,"material removal at far end "+id);
        machining.clearPreview();check(!machining.visible()&&!motion.programMode()&&!motion.running(),"switch clears previous preview "+id);
        write("User/Prog/large.pcni",QByteArray(program).replace("LX="+QByteArray::number(length),"LX="+QByteArray::number(length+1)));
        check(!pcni.load("large.pcni"),"oversized panel rejected "+id);
        check(!motion.loadPath({QVariantMap{{"x",0},{"y",0}},QVariantMap{{"x",length+1},{"y",0}}}),"oversized route rejected "+id);
    }
    VigorProfile profile(true,config);profile.select("9999");check(profile.model()=="2128","unknown profile rejected");
    profile.assignData(root+"/invalid");check(profile.dataRoot()==root,"invalid data association rejected");
    // Router-only machine data from the actual controller: T1 has no tool and
    // a disabled placeholder offset. TP1 remains a valid independent reference.
    write("Dati/fametec_dat.ini","[GENERAL000]\nORIG_SX=5\nCSag=60\n");
    write("Dati/datvari_dat.ini","[DATORIG_004]\nNOME=ORIG5\nOFFX=522.75\nOFFY=132.30\nOFFZ=-25\n");
    write("Dati/protmand_dat.ini","[MAND_000]\nname=T1\ntype=VERT\n[MAND_016]\nname=TP1\ntype=PANT\n");
    write("Dati/datmand_01_dat.ini","[MAND_000]\nOFFX=999\nOFFY=0\nOFFZ=0\nDISABLE=1\n[MAND_016]\nOFFX=0\nOFFY=0\nOFFZ=-156.30\nDISABLE=0\n");
    write("Dati/datconf_01_dat.ini","[MAND_000]\nUTE00=\n[MAND_016]\nUTE00=11MM\n");
    write("Dati/datpunt_dat.ini","[PANT_001]\nNOME=11MM\nLUNG=87.10\nDIAM=11\n");
    auto routerFrame=machineSceneFrame(root,0,0,-280);
    check(routerFrame["calibrated"].toBool()&&routerFrame["reference"]=="TP1"&&routerFrame["routerCalibrated"].toBool()&&!routerFrame["drillCalibrated"].toBool(),"unassigned drill does not invalidate registered router");
    check(std::abs(routerFrame["bridgeHome"].toDouble()+1.56492972)<1e-9&&std::abs(routerFrame["carriageHome"].toDouble()+1.12584154)<1e-9&&std::abs(routerFrame["zHome"].toDouble()-.06709959)<1e-9,"real controller setup anchors TP1 without disabled T1 placeholder");
    // Check the tool tip at unrelated measured positions, rather than merely
    // repeating setup formulas: X=100/Y=200/depth=6 and X=800/Y=500/depth=18.
    for(const auto& p:QList<QVector3D>{{622.75f,332.30f,-27.8f},{1322.75f,632.30f,-15.8f}}){
        const double tx=routerFrame["bridgeHome"].toDouble()+p.x()/1000+.02517972;
        const double ty=.704551+routerFrame["zHome"].toDouble()-(p.z()+280)/1000+.57505423;
        const double tz=routerFrame["carriageHome"].toDouble()+p.y()/1000-.21110186;
        const double expectedX=p.x()<1000?-.917:-.217,expectedZ=p.x()<1000?-1.0046434:-.7046434,expectedY=p.x()<1000?1.0945051:1.0825051;
        check(std::abs(tx-expectedX)<1e-6&&std::abs(ty-expectedY)<1e-6&&std::abs(tz-expectedZ)<1e-6,"router-only physical tip agrees with fixed stock coordinates");
    }
    write("Dati/datconf_01_dat.ini","[MAND_000]\nUTE00=UNKNOWN\n[MAND_016]\nUTE00=11MM\n");
    check(machineSceneFrame(root,0,0,-280)==routerFrame,"unknown drill name never invents a length or shifts TP1");
    write("Dati/datconf_01_dat.ini","[MAND_000]\nUTE00=\n[MAND_016]\nUTE00=UNKNOWN\n");
    check(!machineSceneFrame(root,0,0,-280)["calibrated"].toBool(),"no registered reference stays explicitly uncalibrated");
    QFile report(app.arguments().value(1));if(!report.open(QIODevice::WriteOnly))return 2;QTextStream out(&report);out<<"checks="<<checks<<"\npassed="<<failures.isEmpty()<<"\n"<<failures;return failures.isEmpty()?0:1;
}
