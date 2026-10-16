// Offline, lossless optimization of the final Qt mesh buffers. Never changes
// vertex attributes, material subsets, winding or any non-degenerate surface.
#include <QtQuick3DUtils/private/qssgmesh_p.h>
#include <QCoreApplication>
#include <QFile>
#include <QTextStream>
#include <QRegularExpression>
#include <QDir>
#include <unordered_map>
#include <set>
#include <array>
#include <cstring>
#include <string>

int main(int argc,char** argv) {
    QCoreApplication app(argc,argv);
    if(argc!=2)return 1;
    QFile scene(app.arguments()[1]);if(!scene.open(QIODevice::ReadOnly))return 2;
    const auto text=QString::fromUtf8(scene.readAll());
    const auto base=QFileInfo(scene).absoluteDir();
    QRegularExpression re("source: \\\"([^\\\"]+\\.mesh)\\\"");
    auto matches=re.globalMatch(text);quint64 before=0,after=0,verticesBefore=0,verticesAfter=0,triBefore=0,triAfter=0;
    while(matches.hasNext()) {
        auto name=matches.next().captured(1);QFile file(base.filePath(name));
        if(!file.open(QIODevice::ReadOnly))return 3;
        before+=file.size();auto all=QSSGMesh::Mesh::loadAll(&file);file.close();
        if(all.size()!=1)return 4;
        const auto& mesh=all.first();const auto vb=mesh.vertexBuffer();const auto ib=mesh.indexBuffer();
        if(mesh.drawMode()!=QSSGRenderDrawMode::Triangles||mesh.winding()!=QSSGRenderWinding::CounterClockwise)return 5;
        const int indexSize=ib.componentType==QSSGRenderComponentType::UnsignedInt16?2:4;
        if(indexSize==4&&ib.componentType!=QSSGRenderComponentType::UnsignedInt32)return 6;
        auto index=[&](quint32 i)->quint32 {quint32 v=0;std::memcpy(&v,ib.data.constData()+qsizetype(i)*indexSize,indexSize);return v;};
        int positionEntry=-1;for(int i=0;i<vb.entries.size();++i)if(vb.entries[i].name=="attr_pos")positionEntry=i;
        if(positionEntry<0)return 7;
        // Record all attribute bytes, excluding alignment padding. Distinct
        // normals or UVs prevent welding across a visible edge or texture seam.
        auto record=[&](quint32 v) {
            std::string row;
            for(const auto& e:vb.entries) {
                if(e.componentType!=QSSGRenderComponentType::Float32)throw std::runtime_error("Non-float vertex attribute");
                row.append(vb.data.constData()+qsizetype(v)*vb.stride+e.offset,e.componentCount*4);
            }
            return row;
        };
        std::unordered_map<std::string,quint32> unique;
        QVector<quint32> first;QByteArray outputIndices;
        QVector<QSSGMesh::AssetMeshSubset> subsets;
        auto mapVertex=[&](quint32 v) {
            auto row=record(v);auto found=unique.find(row);if(found!=unique.end())return found->second;
            quint32 next=first.size();unique.emplace(std::move(row),next);first.append(v);return next;
        };
        auto point=[&](quint32 v) {
            float xyz[3];std::memcpy(xyz,vb.data.constData()+qsizetype(v)*vb.stride+vb.entries[positionEntry].offset,12);
            return QVector3D(xyz[0],xyz[1],xyz[2]);
        };
        for(const auto& subset:mesh.subsets()) {
            if(!subset.lods.isEmpty())return 8;
            QSSGMesh::AssetMeshSubset out;out.name=subset.name;out.offset=outputIndices.size()/4;
            out.boundsPositionEntryIndex=positionEntry;out.lightmapWidth=subset.lightmapSizeHint.width();out.lightmapHeight=subset.lightmapSizeHint.height();
            std::set<std::array<quint32,3>> seen;
            for(quint32 i=0;i+2<subset.count;i+=3) {
                std::array<quint32,3> source={index(subset.offset+i),index(subset.offset+i+1),index(subset.offset+i+2)};
                ++triBefore;
                auto a=point(source[0]),b=point(source[1]),c=point(source[2]);
                if(QVector3D::crossProduct(b-a,c-a).lengthSquared()==0)continue;
                std::array<quint32,3> ids={mapVertex(source[0]),mapVertex(source[1]),mapVertex(source[2])};
                auto canonical=ids;auto start=std::min_element(canonical.begin(),canonical.end());std::rotate(canonical.begin(),start,canonical.end());
                if(!seen.insert(canonical).second)continue;
                outputIndices.append(reinterpret_cast<const char*>(ids.data()),12);++triAfter;
            }
            out.count=outputIndices.size()/4-out.offset;
            if(!out.count)return 9; // Preserve the original material slot ordering.
            subsets.append(out);
        }
        QVector<QSSGMesh::AssetVertexEntry> attributes;
        for(const auto& e:vb.entries) {
            QSSGMesh::AssetVertexEntry entry;entry.name=e.name;entry.componentType=e.componentType;entry.componentCount=e.componentCount;
            entry.data.reserve(first.size()*e.componentCount*4);
            for(auto v:first)entry.data.append(vb.data.constData()+qsizetype(v)*vb.stride+e.offset,e.componentCount*4);
            attributes.append(entry);
        }
        auto optimized=QSSGMesh::Mesh::fromAssetData(attributes,outputIndices,QSSGRenderComponentType::UnsignedInt32,subsets);
        if(!optimized.isValid())return 10;
        verticesBefore+=vb.data.size()/vb.stride;verticesAfter+=first.size();
        if(!file.open(QIODevice::WriteOnly|QIODevice::Truncate))return 11;
        optimized.save(&file,all.firstKey());after+=file.size();file.close();
        QTextStream(stdout)<<name<<" vertices="<<vb.data.size()/vb.stride<<" -> "<<first.size()<<"\n";
    }
    QTextStream(stdout)<<"bytes_before="<<before<<"\nbytes_after="<<after
                       <<"\nvertices_before="<<verticesBefore<<"\nvertices_after="<<verticesAfter
                       <<"\ntriangles_before="<<triBefore<<"\ntriangles_after="<<triAfter<<"\n";
}
