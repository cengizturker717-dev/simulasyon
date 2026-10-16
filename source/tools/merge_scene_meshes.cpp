// Offline material batching. Preserves retained vertex positions/normals;
// removes only duplicate faces and triangles strictly inside opaque covers.
#include <QtQuick3DUtils/private/qssgmesh_p.h>
#include <QCoreApplication>
#include <QFile>
#include <QFileInfo>
#include <QDir>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QTextStream>
#include <array>
#include <map>
#include <set>
#include <string>
#include <cstring>

int main(int argc,char** argv) {
    QCoreApplication app(argc,argv);if(argc!=2)return 1;
    QFile specification(app.arguments()[1]);if(!specification.open(QIODevice::ReadOnly))return 2;
    const auto spec=QJsonDocument::fromJson(specification.readAll()).object();
    auto vector=[](const QJsonArray& a){return QVector3D(a[0].toDouble(),a[1].toDouble(),a[2].toDouble());};
    struct Vertex{float p[3],n[3];};
    struct Box{QVector3D lo,hi;};QVector<Box> covers;
    for(const auto& value:spec["covers"].toArray()){const auto o=value.toObject();covers.append({vector(o["min"].toArray()),vector(o["max"].toArray())});}
    QVector<Vertex> vertices;QHash<QString,int> materialIds;QStringList materials;
    QVector<QVector<quint32>> groups;QVector<std::set<std::array<quint32,3>>> seen;
    std::map<std::string,quint32> vertexMap;
    quint64 facesIn=0,hidden=0,duplicates=0;
    auto addVertex=[&](const Vertex& v){std::string key(reinterpret_cast<const char*>(&v),sizeof(v));auto it=vertexMap.find(key);if(it!=vertexMap.end())return it->second;quint32 id=vertices.size();vertices.append(v);vertexMap.emplace(std::move(key),id);return id;};
    auto addFace=[&](const QString& material,const std::array<Vertex,3>& face,bool trim){
        ++facesIn;
        if(trim)for(const auto& box:covers){bool inside=true;for(const auto& v:face)for(int k=0;k<3;++k)inside &= v.p[k]>box.lo[k]+1e-6&&v.p[k]<box.hi[k]-1e-6;if(inside){++hidden;return;}}
        int slot=materialIds.value(material,-1);if(slot<0){slot=materials.size();materialIds.insert(material,slot);materials.append(material);groups.append(QVector<quint32>{});seen.append(std::set<std::array<quint32,3>>{});}
        std::array<quint32,3> ids{addVertex(face[0]),addVertex(face[1]),addVertex(face[2])};
        auto canonical=ids;auto start=std::min_element(canonical.begin(),canonical.end());std::rotate(canonical.begin(),start,canonical.end());
        if(!seen[slot].insert(canonical).second){++duplicates;return;}
        for(auto id:ids)groups[slot].append(id);
    };
    for(const auto& value:spec["inputs"].toArray()){
        const auto input=value.toObject();QFile file(input["path"].toString());if(!file.open(QIODevice::ReadOnly))return 3;
        const auto all=QSSGMesh::Mesh::loadAll(&file);if(all.size()!=1)return 4;
        const auto mesh=all.first();const auto vb=mesh.vertexBuffer();const auto ib=mesh.indexBuffer();
        if(mesh.drawMode()!=QSSGRenderDrawMode::Triangles||mesh.winding()!=QSSGRenderWinding::CounterClockwise)return 5;
        int pos=-1,norm=-1;for(int i=0;i<vb.entries.size();++i){if(vb.entries[i].name=="attr_pos")pos=i;if(vb.entries[i].name=="attr_norm")norm=i;}
        if(pos<0||norm<0)return 6;
        for(int i:{pos,norm})if(vb.entries[i].componentType!=QSSGRenderComponentType::Float32||vb.entries[i].componentCount!=3)return 7;
        const int size=ib.componentType==QSSGRenderComponentType::UnsignedInt16?2:4;
        if(size==4&&ib.componentType!=QSSGRenderComponentType::UnsignedInt32)return 8;
        const auto offset=vector(input["translation"].toArray());const auto names=input["materials"].toArray();
        if(names.size()<mesh.subsets().size())return 9; // QML ignores surplus material slots.
        int slot=0;for(const auto& subset:mesh.subsets()){
            if(!subset.lods.isEmpty()||subset.count%3)return 10;
            const auto material=names[slot++].toString();
            for(quint32 i=0;i<subset.count;i+=3){std::array<Vertex,3> face{};
                for(int corner=0;corner<3;++corner){quint32 index=0;std::memcpy(&index,ib.data.constData()+qsizetype(subset.offset+i+corner)*size,size);
                    std::memcpy(face[corner].p,vb.data.constData()+qsizetype(index)*vb.stride+vb.entries[pos].offset,12);
                    std::memcpy(face[corner].n,vb.data.constData()+qsizetype(index)*vb.stride+vb.entries[norm].offset,12);
                    for(int k=0;k<3;++k)face[corner].p[k]+=offset[k];}
                addFace(material,face,true);
            }
        }
    }
    // Qt's #Cube spans -50..50. Generate its six flat-shaded sides exactly.
    for(const auto& value:spec["cubes"].toArray()){
        const auto cube=value.toObject();const auto center=vector(cube["position"].toArray()),extent=vector(cube["scale"].toArray())*50;
        for(int axis=0;axis<3;++axis)for(int sign:{-1,1}){
            const int u=(axis+1)%3,v=(axis+2)%3;std::array<Vertex,4> corners{};
            const std::array<std::array<int,2>,4> xy{{{-1,-1},{1,-1},{1,1},{-1,1}}};
            for(int i=0;i<4;++i){for(int k=0;k<3;++k)corners[i].p[k]=center[k];corners[i].p[axis]+=sign*extent[axis];corners[i].p[u]+=xy[i][0]*extent[u];corners[i].p[v]+=xy[i][1]*extent[v];corners[i].n[axis]=sign;}
            if(sign>0){addFace(cube["material"].toString(),{corners[0],corners[1],corners[2]},false);addFace(cube["material"].toString(),{corners[0],corners[2],corners[3]},false);}
            else{addFace(cube["material"].toString(),{corners[0],corners[2],corners[1]},false);addFace(cube["material"].toString(),{corners[0],corners[3],corners[2]},false);}
        }
    }
    QVector<QSSGMesh::AssetVertexEntry> attributes;
    for(int kind=0;kind<2;++kind){QSSGMesh::AssetVertexEntry e;e.name=kind==0?"attr_pos":"attr_norm";e.componentType=QSSGRenderComponentType::Float32;e.componentCount=3;for(const auto& vertex:vertices)e.data.append(reinterpret_cast<const char*>(kind==0?vertex.p:vertex.n),12);attributes.append(e);}
    QByteArray indices;QVector<QSSGMesh::AssetMeshSubset> subsets;
    for(int i=0;i<materials.size();++i){if(groups[i].isEmpty())return 11;QSSGMesh::AssetMeshSubset subset;subset.name=materials[i];subset.offset=indices.size()/4;subset.count=groups[i].size();subset.boundsPositionEntryIndex=0;subsets.append(subset);indices.append(reinterpret_cast<const char*>(groups[i].constData()),groups[i].size()*4);}
    const auto merged=QSSGMesh::Mesh::fromAssetData(attributes,indices,QSSGRenderComponentType::UnsignedInt32,subsets);if(!merged.isValid())return 12;
    const auto output=spec["output"].toString();QDir().mkpath(QFileInfo(output).absolutePath());QFile file(output);if(!file.open(QIODevice::WriteOnly))return 13;merged.save(&file,1);file.close();
    QJsonArray names;for(const auto& name:materials)names.append(name);
    const QJsonObject report{{"facesIn",qint64(facesIn)},{"facesOut",indices.size()/12},{"hiddenFacesRemoved",qint64(hidden)},{"duplicateFacesRemoved",qint64(duplicates)},{"vertices",vertices.size()},{"materials",names},{"bytes",QFileInfo(file).size()},{"retainedPositionsAndNormalsPreserved",true}};
    QFile result(output+".json");if(!result.open(QIODevice::WriteOnly))return 14;result.write(QJsonDocument(report).toJson());
    QTextStream(stdout)<<output<<" faces="<<facesIn<<" -> "<<indices.size()/12<<" hidden="<<hidden<<" duplicates="<<duplicates<<" draw_groups="<<materials.size()<<"\n";
    return 0;
}
