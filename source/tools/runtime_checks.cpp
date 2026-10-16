#include <QGuiApplication>
#include <QElapsedTimer>
#include <QTextStream>
#include <QFile>
#include <random>
#include "../StockGeometry.h"
#include "../Motion.h"
#include "reference_stock_geometry.h"

// Compare against the frozen pre-optimization algorithm, including every
// rendered vertex, normal and colour. This checks more than surface area alone.
int main(int argc,char** argv) {
    QGuiApplication app(argc,argv);
    StockGeometry current;
    ReferenceStockGeometry reference;
    int comparisons=0;
    auto equal=[&] {
        ++comparisons;
        return current.vertexData()==reference.vertexData()
            && current.removed()==reference.removed()
            && current.attributeCount()==reference.attributeCount()
            && current.stride()==reference.stride();
    };
    std::mt19937 random(2136);
    for(double width:{300.0,299.0})for(double depth:{6.0,18.0})for(double diameter:{4.0,8.0,50.0}) {
        current.configure(width,277,18,diameter);reference.configure(width,277,18,diameter);
        current.setDepth(depth);reference.setDepth(depth);
        if(!equal())return 1;
        for(int i=0;i<80;++i) {
            const double ax=int(random()%340)-20,ay=int(random()%320)-20;
            double bx=int(random()%340)-20,by=int(random()%320)-20;
            if(i%10==0){bx=ax;by=ay;}
            if(i%10==1)by=ay;
            if(i%10==2)bx=ax;
            const bool travel=i%13==0;
            current.cut(ax,ay,bx,by,travel);reference.cut(ax,ay,bx,by,travel);
            current.flush();reference.flush();
            if(!equal()){qCritical("Cut mismatch: case %d",i);return 2;}
        }
        current.reset();reference.reset();if(!equal())return 3;
    }
    // Full-size plate, long diagonals, reversed paths and grazing tile edges.
    current.configure(3660,2100,18,8);reference.configure(3660,2100,18,8);
    const double paths[][4]={{0,0,3660,2100},{3660,0,0,2100},
        {3660,2100,0,0},{128,0,128,2100},{0,128,3660,128},
        {-4,0,-4,2100},{0,-4,3660,-4},{3664,0,3664,2100},
        {0,2104,3660,2104},{0,0,3660,0},{0,2100,3660,2100}};
    for(const auto& p:paths) {
        current.cut(p[0],p[1],p[2],p[3],false);reference.cut(p[0],p[1],p[2],p[3],false);
        current.flush();reference.flush();if(!equal())return 4;
    }
    // Non-integral paths close to the cutter boundary retain the original
    // hypot-based decision; row bounds must never skip an eligible cell.
    for(int i=0;i<80;++i) {
        current.reset();reference.reset();
        const double offset=(i-40)*1e-10;
        current.cut(0,127+offset,3660,128+offset,false);
        reference.cut(0,127+offset,3660,128+offset,false);
        current.flush();reference.flush();if(!equal())return 5;
    }
    double beforeMs=0,afterMs=0;
    for(int i=0;i<10;++i) {
        reference.reset();current.reset();QElapsedTimer clock;clock.start();
        reference.cut(0,0,3660,2100,false);beforeMs+=clock.nsecsElapsed()/1e6;
        clock.restart();current.cut(0,0,3660,2100,false);afterMs+=clock.nsecsElapsed()/1e6;
        reference.flush();current.flush();if(!equal())return 6;
    }
    Motion motion;int x=0,y=0,z=0,state=0,speed=0;
    int stockNotifications=0;
    QObject::connect(&current,&StockGeometry::changed,&app,[&]{++stockNotifications;});
    const QByteArray finishedBuffer=current.vertexData();const double finishedVolume=current.removed();
    QElapsedTimer idleClock;idleClock.start();
    for(int i=0;i<1000;++i)current.flush();
    const double idleFlushMs=idleClock.nsecsElapsed()/1e6;
    if(stockNotifications!=0||current.rebuiltTileCount()!=0||current.vertexData()!=finishedBuffer||current.removed()!=finishedVolume)return 11;
    current.reset();if(stockNotifications!=1||current.removed()!=0)return 12;
    current.cut(20,20,100,20,false);current.flush();
    if(stockNotifications!=2||current.removed()<=0)return 13;
    QObject::connect(&motion,&Motion::xChanged,&app,[&]{++x;});
    QObject::connect(&motion,&Motion::yChanged,&app,[&]{++y;});
    QObject::connect(&motion,&Motion::zChanged,&app,[&]{++z;});
    QObject::connect(&motion,&Motion::runningChanged,&app,[&]{++state;});
    QObject::connect(&motion,&Motion::speedChanged,&app,[&]{++speed;});
    motion.setAxis(0,100);motion.setAxis(0,100);
    if(x!=1||y||z||state||speed)return 7;
    motion.setSpeed(2);motion.setSpeed(2);motion.play();motion.pause();motion.pause();
    if(x!=1||y||z||state!=2||speed!=1)return 8;
    motion.setLiveAxes(0,0,-280);motion.setLiveAxes(0,0,-280);
    if(x!=2||y||z||state!=2||speed!=1||motion.y()!=0)return 9;
    const QString output=app.arguments().value(1);
    QFile file(output);if(!file.open(QIODevice::WriteOnly))return 10;
    QTextStream report(&file);
    report<<"identical_geometry_checks="<<comparisons<<"\n"
          <<"motion_notifications_passed=1\n"
          <<"unchanged_flush_checks=1000\nunchanged_flush_ms="<<idleFlushMs<<"\n"
          <<"long_diagonal_before_ms="<<beforeMs/10<<"\n"
          <<"long_diagonal_after_ms="<<afterMs/10<<"\n";
    return 0;
}
