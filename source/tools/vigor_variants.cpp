#include <QtQuick3DUtils/private/qssgmesh_p.h>
#include <QCoreApplication>
#include <QFile>
#include <QDir>
#include <QTextStream>
#include <map>
#include <array>
#include <vector>
#include <numeric>
#include <cstring>
#include <cmath>
#include <algorithm>

// Offline variants: retain materials, Y/Z coordinates and rigid part dimensions.
// Crop surplus rack teeth instead of changing their pitch.
int main(int argc,char** argv) {
    QCoreApplication app(argc,argv);
    if(argc<3)return 1;
    QFile input(app.arguments()[1]);if(!input.open(QIODevice::ReadOnly))return 2;
    auto all=QSSGMesh::Mesh::loadAll(&input);if(all.size()!=1)return 3;
    const auto mesh=all.first();const auto vb=mesh.vertexBuffer();const auto ib=mesh.indexBuffer();
    int pos=-1,norm=-1;for(int i=0;i<vb.entries.size();++i){if(vb.entries[i].name=="attr_pos")pos=i;if(vb.entries[i].name=="attr_norm")norm=i;}
    if(pos<0)return 4;
    const int count=vb.data.size()/vb.stride,isize=ib.componentType==QSSGRenderComponentType::UnsignedInt16?2:4;
    auto index=[&](int i){quint32 n=0;std::memcpy(&n,ib.data.constData()+i*isize,isize);return n;};
    std::vector<int> parent(count);std::iota(parent.begin(),parent.end(),0);
    std::function<int(int)> root=[&](int n){return parent[n]==n?n:parent[n]=root(parent[n]);};
    auto join=[&](int a,int b){parent[root(a)]=root(b);};
    std::vector<QVector3D> points;points.reserve(count);
    std::map<std::array<long long,3>,int> welded;
    for(int i=0;i<count;++i){float p[3];std::memcpy(p,vb.data.constData()+i*vb.stride+vb.entries[pos].offset,12);points.emplace_back(p[0],p[1],p[2]);
        std::array<long long,3> key{llround(p[0]*100000),llround(p[1]*100000),llround(p[2]*100000)};
        auto [it,newPoint]=welded.emplace(key,i);if(!newPoint)join(i,it->second);}
    for(int i=0;i+2<ib.data.size()/isize;i+=3){join(index(i),index(i+1));join(index(i),index(i+2));}
    struct Bounds{QVector3D lo{1e9,1e9,1e9},hi{-1e9,-1e9,-1e9};int vertices=0;};
    std::map<int,Bounds> bounds;
    for(int i=0;i<count;++i){auto& b=bounds[root(i)];++b.vertices;for(int j=0;j<3;++j){b.lo[j]=std::min(b.lo[j],points[i][j]);b.hi[j]=std::max(b.hi[j],points[i][j]);}}
    if(app.arguments()[2]=="--orange") {QTextStream out(stdout);int slot=0;for(const auto& s:mesh.subsets()){if(slot++!=3)continue;for(quint32 i=0;i<s.count;i+=3){Bounds b;for(int j=0;j<3;++j){auto p=points[index(s.offset+i+j)];for(int k=0;k<3;++k){b.lo[k]=std::min(b.lo[k],p[k]);b.hi[k]=std::max(b.hi[k],p[k]);}}out<<b.lo.x()<<","<<b.hi.x()<<","<<b.lo.y()<<","<<b.hi.y()<<","<<b.lo.z()<<","<<b.hi.z()<<"\n";}}return 0;}
    if(app.arguments()[2]=="--inspect"){
        QTextStream out(stdout);for(const auto& [id,b]:bounds)out<<id<<","<<b.vertices<<","<<b.lo.x()<<","<<b.hi.x()<<","<<b.lo.y()<<","<<b.hi.y()<<","<<b.lo.z()<<","<<b.hi.z()<<"\n";
        int slot=0;for(const auto& s:mesh.subsets()){QTextStream(stderr)<<"slot "<<slot++<<" "<<s.name<<" faces "<<s.count/3<<"\n";}return 0;}
    const bool removeRouterBase=app.arguments().value(3)=="--remove-router-base";
    const double delta=removeRouterBase?0:app.arguments().value(3).toDouble()/1000;
    auto routerBase=[&](const Bounds& b){return b.lo.x()>-.31&&b.hi.x()<-.18&&b.lo.y()>.62&&b.hi.y()<1.24&&b.lo.z()>-.32&&b.hi.z()<.11;};
    if(removeRouterBase){int selected=0;for(const auto& [id,b]:bounds)if(routerBase(b))++selected;if(selected!=8)return 12;}
    auto rack=[&](const Bounds& b){return b.hi.x()-b.lo.x()>.5&&b.lo.y()>.035&&b.hi.y()<.075&&(b.lo.z()>.85||b.hi.z()<-1.16);};
    std::vector<bool> brand(count,false);int slot=0;
    for(const auto& s:mesh.subsets()){if(slot++!=3)continue;for(quint32 i=0;i<s.count;++i){auto v=index(s.offset+i);if(points[v].x()>2.8&&points[v].z()>.80&&points[v].y()<.02)brand[v]=true;}}
    // Preserve the complete branded rear cover and its cut-out lettering.
    auto mapX=[&](double x){return x+delta*std::clamp((x+1.017)/3.717,0.0,1.0);};
    QVector<QSSGMesh::AssetVertexEntry> attributes;
    for(int e=0;e<vb.entries.size();++e){const auto& src=vb.entries[e];QSSGMesh::AssetVertexEntry dst;dst.name=src.name;dst.componentType=src.componentType;dst.componentCount=src.componentCount;
        if(src.componentType!=QSSGRenderComponentType::Float32)return 5;
        for(int i=0;i<count;++i){QByteArray row(vb.data.constData()+i*vb.stride+src.offset,src.componentCount*4);const auto& b=bounds[root(i)];bool stretch=b.hi.x()-b.lo.x()>1.2;
            if(!removeRouterBase&&e==pos&&!rack(b)){float p[3];std::memcpy(p,row.data(),12);p[0]=brand[i]?p[0]+delta:stretch?mapX(p[0]):p[0]+mapX((b.lo.x()+b.hi.x())/2)-(b.lo.x()+b.hi.x())/2;std::memcpy(row.data(),p,12);}
            if(!removeRouterBase&&e==norm&&stretch&&!rack(b)&&points[i].x()>-1.017&&points[i].x()<2.7){float p[3];std::memcpy(p,row.data(),12);QVector3D n(p[0]/(1+delta/3.717),p[1],p[2]);n.normalize();p[0]=n.x();p[1]=n.y();p[2]=n.z();std::memcpy(row.data(),p,12);}
            dst.data.append(row);}
        attributes.append(dst);}
    QVector<QSSGMesh::AssetMeshSubset> subsets;
    QByteArray indices;int cropped=0;
    for(const auto& s:mesh.subsets()){if(!s.lods.isEmpty())return 6;QSSGMesh::AssetMeshSubset d;d.name=s.name;d.offset=indices.size()/isize;d.boundsPositionEntryIndex=pos;d.lightmapWidth=s.lightmapSizeHint.width();d.lightmapHeight=s.lightmapSizeHint.height();
        for(quint32 i=0;i<s.count;i+=3){bool beyond=false;for(int j=0;j<3;++j){const int v=index(s.offset+i+j);if(removeRouterBase?routerBase(bounds[root(v)]):(rack(bounds[root(v)])&&points[v].x()>3.382+delta))beyond=true;}if(beyond){++cropped;continue;}indices.append(ib.data.constData()+(s.offset+i)*isize,3*isize);}
        d.count=indices.size()/isize-d.offset;if(!d.count)return 9;subsets.append(d);}
    auto output=QSSGMesh::Mesh::fromAssetData(attributes,indices,ib.componentType,subsets);if(!output.isValid())return 7;
    QFile file(app.arguments()[2]);QDir().mkpath(QFileInfo(file).absolutePath());if(!file.open(QIODevice::WriteOnly))return 8;output.save(&file,all.firstKey());
    QTextStream(stdout)<<"vertices="<<count<<" components="<<bounds.size()<<" delta_mm="<<delta*1000<<" cropped_rack_faces="<<cropped<<" materials_preserved=1\n";
}
