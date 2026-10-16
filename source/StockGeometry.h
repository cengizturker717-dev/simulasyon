#pragma once
#include <QtQuick3D/QQuick3DGeometry>
#include <QTimer>
#include <QElapsedTimer>
#include <QVector3D>
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
        setStride(sizeof(Vertex));setPrimitiveType(PrimitiveType::Triangles);
        addAttribute(Attribute::PositionSemantic,0,Attribute::F32Type);
        addAttribute(Attribute::NormalSemantic,3*sizeof(float),Attribute::F32Type);
        addAttribute(Attribute::ColorSemantic,6*sizeof(float),Attribute::F32Type);
        refresh.setSingleShot(true); refresh.setInterval(200);
        connect(&refresh,&QTimer::timeout,this,&StockGeometry::rebuild);
    }
    double stockWidth() const {return w;} double stockHeight() const {return h;}
    double thickness() const {return thick;} double diameter() const {return dia;}
    double depth() const {return dep;} double removed() const {return volume/1000;}
    void setDiameter(double v) {if(std::isfinite(v)&&v>=4&&v<=50){dia=v;reset();}}
    void setDepth(double v) {if(std::isfinite(v)&&v>=0&&v<=thick){dep=v;reset();}}
    Q_INVOKABLE void configure(double width,double height,double thickness,double cutter) {
        if(!std::isfinite(width)||!std::isfinite(height)||!std::isfinite(thickness)||width<=0||height<=0||width>4200||height>2100||thickness<=0||thickness>120) return;
        w=width;h=height;thick=thickness;dia=std::isfinite(cutter)&&cutter>=4&&cutter<=50?cutter:8;dep=thick;
        nx=int(std::ceil(w/2));ny=int(std::ceil(h/2));dx=w/nx;dy=h/ny; reset();
    }
    Q_INVOKABLE void reset() {refresh.stop();cells.assign(nx*ny,float(thick));volume=0;for(auto& tile:tiles)tile.dirty=true;rebuild();}
    void cut(double ax,double ay,double bx,double by,bool travel) {
        cutProfile(ax,ay,dep,bx,by,dep,dia,travel);
    }
    void cutProfile(double ax,double ay,double ad,double bx,double by,double bd,double diameter,bool travel) {
        if(travel||cells.empty()||!std::isfinite(ax)||!std::isfinite(ay)||!std::isfinite(bx)||!std::isfinite(by)||!std::isfinite(ad)||!std::isfinite(bd)||!std::isfinite(diameter)||diameter<=0||diameter>80||std::max(ad,bd)<=0) return;
        double radius=diameter/2, vx=bx-ax,vy=by-ay,len=vx*vx+vy*vy;
        int x0=std::clamp(int(std::floor((std::min(ax,bx)-radius)/dx)),0,nx-1);
        int x1=std::clamp(int(std::floor((std::max(ax,bx)+radius)/dx)),0,nx-1);
        int y0=std::clamp(int(std::floor((std::min(ay,by)-radius)/dy)),0,ny-1);
        int y1=std::clamp(int(std::floor((std::max(ay,by)+radius)/dy)),0,ny-1);
        bool altered=false;
        for(int y=y0;y<=y1;++y) {
          int rowFirst=x0,rowLast=x1;
          if(vy!=0) {
            // A cell can be inside the cutter capsule only if a segment point
            // is within radius in Y. Bound that portion's X range conservatively
            // and keep the original distance test below unchanged.
            const double cy=(y+.5)*dy;
            double ta=(cy-radius-ay)/vy,tb=(cy+radius-ay)/vy;
            if(ta>tb)std::swap(ta,tb);
            ta=std::clamp(ta,0.0,1.0);tb=std::clamp(tb,0.0,1.0);
            const double xa=ax+ta*vx,xb=ax+tb*vx;
            rowFirst=std::max(x0,int(std::floor((std::min(xa,xb)-radius)/dx))-1);
            rowLast=std::min(x1,int(std::floor((std::max(xa,xb)+radius)/dx))+1);
          }
          for(int x=rowFirst;x<=rowLast;++x) {
            double cx=(x+.5)*dx,cy=(y+.5)*dy;
            double t=len>0?std::clamp(((cx-ax)*vx+(cy-ay)*vy)/len,0.0,1.0):0;
            if(std::hypot(cx-ax-t*vx,cy-ay-t*vy)>radius) continue;
            double cuttingDepth=std::max(ad,bd);
            if(len>0&&ad!=bd) {
                const double projection=((cx-ax)*vx+(cy-ay)*vy)/len;
                const double perp2=std::max(0.0,(cx-ax)*(cx-ax)+(cy-ay)*(cy-ay)-projection*projection*len);
                const double reach=std::sqrt(std::max(0.0,radius*radius-perp2)/len);
                const double contact=std::clamp(projection+(bd>ad?reach:-reach),0.0,1.0);
                cuttingDepth=ad+(bd-ad)*contact;
            }
            float& cell=cells[y*nx+x];float target=float(thick-std::clamp(cuttingDepth,0.0,thick));
            if(cell>target) {volume+=(cell-target)*dx*dy;cell=target;altered=true;
                dirtyCell(x,y);
                if(x%tileSide==0)dirtyCell(x-1,y);
                if(x%tileSide==tileSide-1)dirtyCell(x+1,y);
                if(y%tileSide==0)dirtyCell(x,y-1);
                if(y%tileSide==tileSide-1)dirtyCell(x,y+1);}
          }
        }
        if(altered&&!refresh.isActive())refresh.start();
    }
    float heightAt(double x,double y) const {
        if(cells.empty()||x<0||x>=w||y<0||y>=h)return 0;
        return cells[std::min(ny-1,int(y/dy))*nx+std::min(nx-1,int(x/dx))];
    }
    Q_INVOKABLE void flush() {refresh.stop();rebuild();}
    int rebuiltTileCount() const {return lastTiles;}
    int triangleCount() const {return vertexData().size()/int(sizeof(Vertex))/3;}
    double rebuildMilliseconds() const {return lastMilliseconds;}
signals:
    void changed();
private:
    struct Vertex {float x,y,z,nx,ny,nz,r,g,b,a;};
    static constexpr int tileSide=64;
    struct Tile {QByteArray bytes; bool dirty=true;};
    std::vector<Tile> tiles;
    int tilesX=0,tilesY=0,lastTiles=0;
    double lastMilliseconds=0;
    void dirtyCell(int x,int y) {
        if(x>=0&&y>=0&&x<nx&&y<ny)tiles[(y/tileSide)*tilesX+x/tileSide].dirty=true;
    }
    void rebuild() {
        QElapsedTimer clock;clock.start();lastTiles=0;
        if(tilesX!=(nx+tileSide-1)/tileSide||tilesY!=(ny+tileSide-1)/tileSide) {
            tilesX=(nx+tileSide-1)/tileSide;tilesY=(ny+tileSide-1)/tileSide;
            tiles.assign(tilesX*tilesY,Tile{});
        }
        auto height=[&](int x,int y)->float {return x<0||y<0||x>=nx||y>=ny?0:cells[y*nx+x];};
        for(int ty=0;ty<tilesY;++ty)for(int tx=0;tx<tilesX;++tx) {
        auto& tile=tiles[ty*tilesX+tx];if(!tile.dirty)continue;
        tile.dirty=false;++lastTiles;QByteArray bytes;
        auto quad=[&](QVector3D a,QVector3D b,QVector3D c,QVector3D d,QVector3D normal){
            for(auto p:{a,b,c,a,c,d}) {bool original=normal.y()>0.5 && p.y()>=thick-0.01; Vertex v{p.x(),p.y(),p.z(),normal.x(),normal.y(),normal.z(),original?0.86f:0.19f,original?0.66f:0.085f,original?0.39f:0.028f,1.0f};bytes.append(reinterpret_cast<const char*>(&v),sizeof v);}
        };
        const int x0=tx*tileSide,x1=std::min(nx,x0+tileSide);
        const int y0=ty*tileSide,y1=std::min(ny,y0+tileSide);
        bool covered[tileSide*tileSide]={};
        auto visited=[&](int x,int y)->bool& {return covered[(y-y0)*tileSide+x-x0];};
        // Coalesce equal-height cells into exact rectangles. The 2 mm height
        // field and cutter calculations are unchanged; only tessellation changes.
        for(int y=y0;y<y1;++y) {
            for(int x=x0;x<x1;) {
                if(visited(x,y)){++x;continue;}
                float top=height(x,y);int end=x+1;
                while(end<x1&&!visited(end,y)&&height(end,y)==top)++end;
                int endY=y+1;
                while(endY<y1) {
                    bool same=true;
                    for(int cx=x;cx<end;++cx)if(visited(cx,endY)||height(cx,endY)!=top){same=false;break;}
                    if(!same)break;++endY;
                }
                for(int cy=y;cy<endY;++cy)for(int cx=x;cx<end;++cx)visited(cx,cy)=true;
                if(top>0) {
                    float a=float(x*dx),b=float(end*dx),c=float(y*dy),d=float(endY*dy);
                    quad({a,top,c},{a,top,d},{b,top,d},{b,top,c},{0,1,0});
                    quad({a,0,c},{b,0,c},{b,0,d},{a,0,d},{0,-1,0});
                }
                else {
                    float a=float(x*dx),b=float(end*dx),c=float(y*dy),d=float(endY*dy);
                    quad({a,-0.1f,c},{a,-0.1f,d},{b,-0.1f,d},{b,-0.1f,c},{0,1,0});
                }
                x=end;
            }
        }
        // Coalesce side walls along each straight run. Tile boundaries read
        // the global height field, so adjacent tiles never create internal walls.
        for(int side:{-1,1}) {
            for(int y=y0;y<y1;++y)for(int x=x0;x<x1;) {
                const float top=height(x,y),low=height(x,y+side);
                if(top<=0||low>=top){++x;continue;}
                int end=x+1;
                while(end<x1&&height(end,y)==top&&height(end,y+side)==low)++end;
                const float a=float(x*dx),b=float(end*dx),z=float((y+(side>0))*dy);
                if(side<0)quad({b,low,z},{a,low,z},{a,top,z},{b,top,z},{0,0,-1});
                else quad({a,low,z},{b,low,z},{b,top,z},{a,top,z},{0,0,1});
                x=end;
            }
            for(int x=x0;x<x1;++x)for(int y=y0;y<y1;) {
                const float top=height(x,y),low=height(x+side,y);
                if(top<=0||low>=top){++y;continue;}
                int end=y+1;
                while(end<y1&&height(x,end)==top&&height(x+side,end)==low)++end;
                const float z0=float(y*dy),z1=float(end*dy),a=float((x+(side>0))*dx);
                if(side<0)quad({a,low,z0},{a,low,z1},{a,top,z1},{a,top,z0},{-1,0,0});
                else quad({a,low,z1},{a,low,z0},{a,top,z0},{a,top,z1},{1,0,0});
                y=end;
            }
        }
        tile.bytes=std::move(bytes);
        }
        // Flush is also called on every stopped CNC sample. An unchanged
        // height field needs neither a buffer copy nor a GPU upload/redraw.
        if(lastTiles==0){lastMilliseconds=clock.nsecsElapsed()/1000000.0;return;}
        QByteArray bytes;qsizetype size=0;for(const auto& tile:tiles)size+=tile.bytes.size();
        bytes.reserve(size);for(const auto& tile:tiles)bytes.append(tile.bytes);
        // The vertex layout stays fixed; update its data without clearing and
        // recreating every attribute on each cut refresh.
        setVertexData(bytes);setBounds({0,-0.1f,0},{float(w),float(thick),float(h)});update();
        lastMilliseconds=clock.nsecsElapsed()/1000000.0;emit changed();
    }
    QTimer refresh;
    double w=0,h=0,thick=18,dia=8,dep=18,dx=2,dy=2,volume=0;
    int nx=0,ny=0;
    std::vector<float> cells;
};
