// Offline mesh exchange for review scripts.
//   MeshIO dump in.mesh out.tri   -> per subset: name + unindexed triangles (pos,norm per corner)
//   MeshIO pack in.tri out.mesh   -> indexed Qt mesh, identical vertices welded exactly
// .tri layout (little endian): u32 subsets; per subset: u32 nameBytes, utf8 name,
// u32 triangles, float32[triangles*3*6].
#include <QtQuick3DUtils/private/qssgmesh_p.h>
#include <QCoreApplication>
#include <QFile>
#include <QFileInfo>
#include <QDir>
#include <QTextStream>
#include <map>
#include <string>
#include <cstring>

struct Vertex{float p[3],n[3];};

static int dump(const QString& in,const QString& out){
    QFile file(in);if(!file.open(QIODevice::ReadOnly))return 3;
    const auto all=QSSGMesh::Mesh::loadAll(&file);if(all.size()!=1)return 4;
    const auto mesh=all.first();const auto vb=mesh.vertexBuffer();const auto ib=mesh.indexBuffer();
    if(mesh.drawMode()!=QSSGRenderDrawMode::Triangles)return 5;
    int pos=-1,norm=-1;for(int i=0;i<vb.entries.size();++i){if(vb.entries[i].name=="attr_pos")pos=i;if(vb.entries[i].name=="attr_norm")norm=i;}
    if(pos<0||norm<0)return 6;
    const int size=ib.componentType==QSSGRenderComponentType::UnsignedInt16?2:4;
    QFile o(out);if(!o.open(QIODevice::WriteOnly))return 7;
    auto u32=[&](quint32 v){o.write(reinterpret_cast<const char*>(&v),4);};
    u32(mesh.subsets().size());
    for(const auto& subset:mesh.subsets()){
        const QByteArray name=subset.name.toUtf8();u32(name.size());o.write(name);u32(subset.count/3);
        for(quint32 i=0;i<subset.count;++i){quint32 index=0;std::memcpy(&index,ib.data.constData()+qsizetype(subset.offset+i)*size,size);
            o.write(vb.data.constData()+qsizetype(index)*vb.stride+vb.entries[pos].offset,12);
            o.write(vb.data.constData()+qsizetype(index)*vb.stride+vb.entries[norm].offset,12);}
    }
    QTextStream(stdout)<<"subsets="<<mesh.subsets().size()<<"\n";
    return 0;
}

static int pack(const QString& in,const QString& out){
    QFile file(in);if(!file.open(QIODevice::ReadOnly))return 3;const QByteArray data=file.readAll();qsizetype at=0;
    auto u32=[&]{quint32 v=0;std::memcpy(&v,data.constData()+at,4);at+=4;return v;};
    QVector<Vertex> vertices;std::map<std::string,quint32> ids;QByteArray indices;QVector<QSSGMesh::AssetMeshSubset> subsets;
    const quint32 count=u32();
    for(quint32 s=0;s<count;++s){
        const quint32 bytes=u32();const QString name=QString::fromUtf8(data.constData()+at,bytes);at+=bytes;const quint32 triangles=u32();
        if(!triangles)return 11; // QML binds materials by subset order; never shift slots.
        QSSGMesh::AssetMeshSubset subset;subset.name=name;subset.offset=indices.size()/4;subset.count=triangles*3;subset.boundsPositionEntryIndex=0;
        for(quint32 i=0;i<triangles*3;++i){Vertex v;std::memcpy(&v,data.constData()+at,24);at+=24;
            std::string key(reinterpret_cast<const char*>(&v),sizeof(v));auto it=ids.find(key);quint32 id;
            if(it==ids.end()){id=vertices.size();vertices.append(v);ids.emplace(std::move(key),id);}else id=it->second;
            indices.append(reinterpret_cast<const char*>(&id),4);}
        subsets.append(subset);
    }
    if(at!=data.size())return 8;
    QVector<QSSGMesh::AssetVertexEntry> attributes;
    for(int kind=0;kind<2;++kind){QSSGMesh::AssetVertexEntry e;e.name=kind==0?"attr_pos":"attr_norm";e.componentType=QSSGRenderComponentType::Float32;e.componentCount=3;
        for(const auto& v:vertices)e.data.append(reinterpret_cast<const char*>(kind==0?v.p:v.n),12);attributes.append(e);}
    const auto mesh=QSSGMesh::Mesh::fromAssetData(attributes,indices,QSSGRenderComponentType::UnsignedInt32,subsets);if(!mesh.isValid())return 9;
    QDir().mkpath(QFileInfo(out).absolutePath());QFile o(out);if(!o.open(QIODevice::WriteOnly))return 10;mesh.save(&o,1);
    QTextStream(stdout)<<"vertices="<<vertices.size()<<" triangles="<<indices.size()/12<<" subsets="<<subsets.size()<<"\n";
    return 0;
}

int main(int argc,char** argv){
    QCoreApplication app(argc,argv);const auto a=app.arguments();if(a.size()!=4)return 1;
    if(a[1]=="dump")return dump(a[2],a[3]);
    if(a[1]=="pack")return pack(a[2],a[3]);
    return 2;
}
