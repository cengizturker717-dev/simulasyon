#include "../LiveCni.h"
#include <QThread>
#include <cstdio>
#include <functional>

static bool until(const std::function<bool()>& condition,int milliseconds){
    QElapsedTimer timer;timer.start();
    while(!condition()&&timer.elapsed()<milliseconds){QCoreApplication::processEvents();QThread::msleep(5);}
    return condition();
}
static void sample(){
    std::puts("{\"x\":12,\"y\":34,\"z\":56,\"workValid\":true,\"panelFrameValid\":true,\"workX\":2,\"workY\":3,\"workZ\":-8,\"spoilboard\":18}");std::fflush(stdout);
}
int main(int argc,char** argv){
    QCoreApplication app(argc,argv);app.setApplicationName("VigorCniChecks");app.setOrganizationName("PoyrazTests");
    const auto args=app.arguments();
    if(args.contains("--live-read-only-probe")){
        LiveCni reader;int samples=0,frames=0;QJsonObject latest;
        QObject::connect(&reader,&LiveCni::snapshot,[&](const QJsonObject& o){++samples;frames+=o["metadataValid"].toBool()&&o["panelFrameValid"].toBool();latest=o;});
        reader.start();QTimer::singleShot(4000,&app,[&]{
            QJsonObject result{{"samples",samples},{"validFrames",frames},{"fresh",reader.fresh()},{"workFresh",reader.workFresh()},{"status",reader.status()},{"snapshot",latest}};
            std::puts(QJsonDocument(result).toJson(QJsonDocument::Compact).constData());std::fflush(stdout);
            const bool ok=reader.fresh()&&reader.workFresh()&&samples>=20&&frames>=20;reader.stop();app.exit(ok?0:1);
        });return app.exec();
    }
    if(args.contains("--fake-error")){std::fputs("CNI_ERROR: SharedAx.Attach kod=-77\n",stderr);std::fflush(stderr);return 2;}
    if(args.contains("--fake-delay")){QTimer::singleShot(3600,&app,sample);return app.exec();}
    if(args.contains("--fake-gap")){sample();return app.exec();}
    if(args.contains("--fake-invalid")){std::puts("{\"x\":\"invalid\",\"y\":34,\"z\":56}");std::fflush(stdout);return app.exec();}
    if(args.contains("--fake-stream")){QTimer timer;QObject::connect(&timer,&QTimer::timeout,sample);timer.start(50);sample();return app.exec();}
    if(args.contains("--fake-stage-hang")){std::fputs("CNI_STAGE: Canlı eksen paylaşımına bağlanılıyor (SharedAx.Attach)\n",stderr);std::fflush(stderr);return app.exec();}
    if(args.contains("--fake-metadata-hang")){std::fputs("CNI_STAGE: Program servisine bağlanılıyor (ServDtm.Attach)\n",stderr);std::fflush(stderr);return app.exec();}
    auto metadataSample=[](){std::puts("{\"metadataValid\":true,\"executing\":true,\"program\":\"test.pcni\",\"panelFrameValid\":true,\"spoilboard\":18,\"x\":999}");std::fflush(stdout);};
    if(args.contains("--fake-metadata-gap")){metadataSample();return app.exec();}
    if(args.contains("--fake-metadata-stream")){QTimer timer;QObject::connect(&timer,&QTimer::timeout,metadataSample);timer.start(50);metadataSample();return app.exec();}
    if(args.contains("--fake-metadata-invalid")){std::puts("{\"metadataValid\":true,\"executing\":true,\"program\":\"test.pcni\",\"panelFrameValid\":true,\"spoilboard\":\"bad\"}");std::fflush(stdout);return app.exec();}
    int checks=0,failures=0;
    auto check=[&](bool passed,const char* name){++checks;if(!passed){++failures;std::fprintf(stderr,"FAILED: %s\n",name);}};
    const QString exe=QCoreApplication::applicationFilePath();
    {
        LiveCni reader(nullptr,exe,{"--fake-error"});reader.start();
        check(until([&]{return !reader.active();},3000),"failed reader stops");
        check(reader.status().contains("SharedAx.Attach kod=-77"),"actual SDK error reaches UI");
        check(!reader.fresh()&&!reader.workFresh(),"failed reader does not claim live data");
        QElapsedTimer timer;timer.start();until([&]{return timer.elapsed()>3300;},3500);
        check(reader.status().contains("kod=-77"),"watchdog does not replace specific error");
    }
    {
        LiveCni reader(nullptr,exe,{"--fake-delay"});int snapshots=0;
        QObject::connect(&reader,&LiveCni::snapshot,[&](const QJsonObject&){++snapshots;});reader.start();
        check(until([&]{return reader.fresh();},6000),"startup longer than three seconds succeeds");
        check(snapshots==1&&reader.property("x").toDouble()==12,"real sample remains unchanged");
        check(reader.workFresh()&&reader.workZ()==10,"corrected stock depth remains unchanged");
        reader.stop();check(!reader.active()&&!reader.fresh()&&!reader.workFresh(),"stop invalidates corrected data");
    }
    {
        LiveCni reader(nullptr,exe,{"--fake-gap"});reader.start();
        check(until([&]{return reader.fresh();},3000),"live sample received");
        check(until([&]{return !reader.active();},2500),"live outage still stops within existing freshness limit");
        check(reader.status().contains("son makine konumu korunuyor"),"outage explains preserved position");
    }
    {
        LiveCni reader(nullptr,exe,{"--fake-invalid"});reader.start();
        check(until([&]{return !reader.active();},3000)&&reader.status().contains("Geçersiz eksen verisi"),"malformed data rejected");
    }
    {
        LiveCni reader(nullptr,exe,{"--fake-gap"});reader.setStartAllowed(false);reader.start();
        check(!reader.active()&&reader.status().contains("makine datası"),"profile data gate retained");
    }
    {
        LiveCni reader(nullptr,exe,{"--fake-stream"},{"--fake-metadata-hang"});int snapshots=0;bool forged=false;
        QObject::connect(&reader,&LiveCni::snapshot,[&](const QJsonObject& o){++snapshots;forged|=o["metadataValid"].toBool()||o.contains("executing")||o.contains("spoilboard");});reader.start();
        QElapsedTimer timer;timer.start();until([&]{return timer.elapsed()>6100;},6500);
        check(reader.active()&&reader.fresh()&&snapshots>80,"hung program service never blocks axes");
        check(!reader.workFresh()&&!forged,"missing metadata cannot authorize material removal");
        check(reader.status().contains("ServDtm.Attach"),"metadata timeout names blocked service");
        reader.stop();const int stopped=snapshots;timer.restart();until([&]{return timer.elapsed()>300;},500);
        check(snapshots==stopped&&!reader.fresh()&&!reader.workFresh(),"stop terminates isolated readers");
    }
    {
        LiveCni reader(nullptr,exe,{"--fake-stream"},{"--fake-metadata-stream"});QJsonObject latest;
        QObject::connect(&reader,&LiveCni::snapshot,[&](const QJsonObject& o){latest=o;});reader.start();
        check(until([&]{return reader.workFresh();},2500),"isolated metadata restores corrected coordinates");
        check(reader.property("x").toDouble()==12&&reader.workZ()==10&&latest["executing"].toBool()&&latest["program"].toString()=="test.pcni","metadata merges only allowed fields without moving axes");
        reader.stop();
    }
    {
        LiveCni reader(nullptr,exe,{"--fake-stream"},{"--fake-metadata-gap"});QJsonObject latest;
        QObject::connect(&reader,&LiveCni::snapshot,[&](const QJsonObject& o){latest=o;});reader.start();
        check(until([&]{return reader.workFresh();},2500),"initial metadata received");
        check(until([&]{return !reader.workFresh()&&!latest["metadataValid"].toBool();},2500),"stale metadata invalidates machining within one second");
        check(reader.active()&&reader.fresh()&&!latest.contains("executing")&&!latest.contains("spoilboard"),"stale execution and stock frame removed while axes continue");reader.stop();
    }
    {
        LiveCni reader(nullptr,exe,{"--fake-stream"},{"--fake-metadata-invalid"});reader.start();
        check(until([&]{return reader.fresh()&&reader.status().contains("Geçersiz program");},2500)&&!reader.workFresh(),"invalid stock frame cannot authorize cutting or disconnect axes");reader.stop();
    }
    {
        LiveCni reader(nullptr,exe,{"--fake-stage-hang"});reader.start();
        check(until([&]{return !reader.active();},16500)&&reader.status().contains("son adım:")&&reader.status().contains("SharedAx.Attach"),"axis startup timeout identifies exact blocked step");
    }
    std::printf("checks=%d\npassed=%s\n",checks,failures?"false":"true");return failures?1:0;
}
