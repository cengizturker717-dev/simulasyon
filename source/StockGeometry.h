#pragma once
#include <QtQuick3D/QQuick3DGeometry>
#include <QTimer>
#include <vector>
#include <algorithm>
#include <cmath>

// 2.5D height field: flat end mill, vertical spindle. Coordinates in mm.
class StockGeometry : public QQuick3DGeometry {
    Q_OBJECT
    Q_PROPERTY(double stockWidth READ stockWidth NOTIFY changed)
    Q_PROPERTY(double stockHeight READ stockHeight NOTIFY changed)
    Q_PROPERTY(double thickness READ thickness NOTIFY changed)
    Q_PROPERTY(double diameter READ diameter WRITE setDiameter NOTIFY changed)
    Q_PROPERTY(double depth READ depth WRITE setDepth NOTIFY changed)
    Q_PROPERTY(double removed READ removed NOTIFY changed)
public:
    explicit StockGeometry(QQuick3DObject* parent=nullptr):QQuick3DGeometry(parent) {
        refresh.setSingleShot(true); refresh.setInterval(200);
        connect(&refresh,&QTimer::timeout,this,&StockGeometry::rebuild);
    }
    double stockWidth() const {return w;} double stockHeight() const {return h;}
    double thickness() const {return thick;} double diameter() const {return dia;}
    double depth() const {return dep;} double removed() const {return volume/1000;}
    void setDiameter(double v) {if(std::isfinite(v)&&v>=4&&v<=50){dia=v;reset();}}
    void setDepth(double v) {if(std::isfinite(v)&&v>=0&&v<=thick){dep=v;reset();}}
    Q_INVOKABLE void configure(double width,double height,double thickness,double cutter) {
        if(!std::isfinite(width)||!std::isfinite(height)||!std::isfinite(thickness)||width<=0||height<=0||width>3660||height>2100||thickness<=0||thickness>120) return;
        w=width;h=height;thick=thickness;dia=std::isfinite(cutter)&&cutter>=4&&cutter<=50?cutter:8;dep=thick;
        nx=int(std::ceil(w/2));ny=int(std::ceil(h/2));dx=w/nx;dy=h/ny; reset();
    }
    Q_INVOKABLE void reset() {refresh.stop();cells.assign(nx*ny,float(thick));volume=0;rebuild();emit changed();}
    void cut(double ax,double ay,double bx,double by,bool travel) {
        if(travel||cells.empty()||dep<=0) return;
        double radius=dia/2, vx=bx-ax,vy=by-ay,len=vx*vx+vy*vy;
        int x0=std::clamp(int(std::floor((std::min(ax,bx)-radius)/dx)),0,nx-1);
        int x1=std::clamp(int(std::floor((std::max(ax,bx)+radius)/dx)),0,nx-1);
        int y0=std::clamp(int(std::floor((std::min(ay,by)-radius)/dy)),0,ny-1);
        int y1=std::clamp(int(std::floor((std::max(ay,by)+radius)/dy)),0,ny-1);
        bool altered=false;
        for(int y=y0;y<=y1;++y) for(int x=x0;x<=x1;++x) {
            double cx=(x+.5)*dx,cy=(y+.5)*dy;
            double t=len>0?std::clamp(((cx-ax)*vx+(cy-ay)*vy)/len,0.0,1.0):0;
            if(std::hypot(cx-ax-t*vx,cy-ay-t*vy)>radius) continue;
            float& cell=cells[y*nx+x];float target=float(thick-dep);
            if(cell>target) {volume+=(cell-target)*dx*dy;cell=target;altered=true;}
        }
        if(altered&&!refresh.isActive())refresh.start();
    }
    float heightAt(double x,double y) const {
        if(cells.empty()||x<0||x>=w||y<0||y>=h)return 0;
        return cells[std::min(ny-1,int(y/dy))*nx+std::min(nx-1,int(x/dx))];
    }
    Q_INVOKABLE void flush() {refresh.stop();rebuild();}
signals:
    void changed();
private:
    struct Vertex {float x,y,z,nx,ny,nz,r,g,b,a;};
    void rebuild() {
        QByteArray bytes;
        auto quad=[&](QVector3D a,QVector3D b,QVector3D c,QVector3D d,QVector3D normal){
            for(auto p:{a,b,c,a,c,d}) {bool original=normal.y()>0.5 && p.y()>=thick-0.01; Vertex v{p.x(),p.y(),p.z(),normal.x(),normal.y(),normal.z(),original?0.86f:0.19f,original?0.66f:0.085f,original?0.39f:0.028f,1.0f};bytes.append(reinterpret_cast<const char*>(&v),sizeof v);}
        };
        auto height=[&](int x,int y)->float {return x<0||y<0||x>=nx||y>=ny?0:cells[y*nx+x];};
        for(int y=0;y<ny;++y) {
            for(int x=0;x<nx;) {
                float top=height(x,y);int end=x+1;while(end<nx&&height(end,y)==top)++end;
                if(top>0) {
                    float a=float(x*dx),b=float(end*dx),c=float(y*dy),d=float((y+1)*dy);
                    quad({a,top,c},{a,top,d},{b,top,d},{b,top,c},{0,1,0});
                    quad({a,0,c},{b,0,c},{b,0,d},{a,0,d},{0,-1,0});
                }
                else {
                    float a=float(x*dx),b=float(end*dx),c=float(y*dy),d=float((y+1)*dy);
                    quad({a,-0.1f,c},{a,-0.1f,d},{b,-0.1f,d},{b,-0.1f,c},{0,1,0});
                }
                x=end;
            }
            for(int x=0;x<nx;++x) {
                float top=height(x,y);if(top<=0)continue;
                float a=float(x*dx),b=float((x+1)*dx),c=float(y*dy),d=float((y+1)*dy),low;
                if((low=height(x-1,y))<top)quad({a,low,c},{a,low,d},{a,top,d},{a,top,c},{-1,0,0});
                if((low=height(x+1,y))<top)quad({b,low,d},{b,low,c},{b,top,c},{b,top,d},{1,0,0});
                if((low=height(x,y-1))<top)quad({b,low,c},{a,low,c},{a,top,c},{b,top,c},{0,0,-1});
                if((low=height(x,y+1))<top)quad({a,low,d},{b,low,d},{b,top,d},{a,top,d},{0,0,1});
            }
        }
        clear();setStride(sizeof(Vertex));setPrimitiveType(PrimitiveType::Triangles);
        addAttribute(Attribute::PositionSemantic,0,Attribute::F32Type);
        addAttribute(Attribute::NormalSemantic,3*sizeof(float),Attribute::F32Type);
        addAttribute(Attribute::ColorSemantic,6*sizeof(float),Attribute::F32Type);
        setVertexData(bytes);setBounds({0,0,0},{float(w),float(thick),float(h)});update();emit changed();
    }
    QTimer refresh;
    double w=0,h=0,thick=18,dia=8,dep=18,dx=2,dy=2,volume=0;
    int nx=0,ny=0;
    std::vector<float> cells;
};
