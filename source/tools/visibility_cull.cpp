// Offline visibility survey. Renders every scene from every eye as a full cube
// map (six 90-degree faces) and marks each triangle that owns at least one
// front-most fragment. Pass 1 lays depth, pass 2 re-renders with LEQUAL and
// early fragment tests, so only the nearest surface (and exact ties) is marked.
// Faces are double sided, as in the scene materials (NoCulling).
//   VisibilityCull spec.json
// spec: {resolution, near, far,
//        meshes:[{tri, skip:[subset names that never occlude]}],
//        scenes:[{instances:[{mesh,t:[x,y,z]}], eyes:[[x,y,z],...]}],
//        masks:[path per mesh]}  -> byte per triangle (file order), skipped = 1
#include <QGuiApplication>
#include <QOffscreenSurface>
#include <QOpenGLContext>
#include <QOpenGLFunctions_4_3_Core>
#include <QOpenGLVersionFunctionsFactory>
#include <QMatrix4x4>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QElapsedTimer>
#include <QTextStream>
#include <cstring>

struct Range{quint32 first,count,base;};
struct MeshGpu{GLuint vao=0,vbo=0;QVector<Range> ranges;quint32 base=0,triangles=0;QVector<bool> skipped;};

static GLuint compile(QOpenGLFunctions_4_3_Core* f,const char* vs,const char* fs){
    auto stage=[&](GLenum type,const char* src){GLuint s=f->glCreateShader(type);f->glShaderSource(s,1,&src,nullptr);f->glCompileShader(s);
        GLint ok=0;f->glGetShaderiv(s,GL_COMPILE_STATUS,&ok);if(!ok){char log[2048];f->glGetShaderInfoLog(s,2048,nullptr,log);QTextStream(stderr)<<log;}return s;};
    GLuint p=f->glCreateProgram();f->glAttachShader(p,stage(GL_VERTEX_SHADER,vs));f->glAttachShader(p,stage(GL_FRAGMENT_SHADER,fs));f->glLinkProgram(p);
    GLint ok=0;f->glGetProgramiv(p,GL_LINK_STATUS,&ok);return ok?p:0;
}

int main(int argc,char** argv){
    QGuiApplication app(argc,argv);if(argc!=2)return 1;
    QFile specFile(app.arguments()[1]);if(!specFile.open(QIODevice::ReadOnly))return 2;
    const auto spec=QJsonDocument::fromJson(specFile.readAll()).object();
    QSurfaceFormat format;format.setVersion(4,3);format.setProfile(QSurfaceFormat::CoreProfile);
    QOpenGLContext context;context.setFormat(format);if(!context.create())return 3;
    QOffscreenSurface surface;surface.setFormat(context.format());surface.create();if(!context.makeCurrent(&surface))return 4;
    auto f=QOpenGLVersionFunctionsFactory::get<QOpenGLFunctions_4_3_Core>(&context);if(!f||!f->initializeOpenGLFunctions())return 5;
    QTextStream(stdout)<<"gl="<<reinterpret_cast<const char*>(f->glGetString(GL_RENDERER))<<"\n";

    // Triangle ids travel as a flat vertex attribute: gl_PrimitiveID proved
    // unreliable on the Intel driver (only the first quarter of ids arrived).
    const char* vs="#version 430 core\nlayout(location=0) in vec3 p;layout(location=1) in uint t;flat out uint id;uniform mat4 mvp;invariant gl_Position;void main(){id=t;gl_Position=mvp*vec4(p,1);}";
    const char* depthFs="#version 430 core\nflat in uint id;void main(){}";
    const char* markFs="#version 430 core\nlayout(early_fragment_tests) in;layout(std430,binding=0) buffer V{uint v[];};flat in uint id;void main(){v[id]=1u;}";
    const GLuint depthProgram=compile(f,vs,depthFs),markProgram=compile(f,vs,markFs);if(!depthProgram||!markProgram)return 6;

    QVector<MeshGpu> meshes;quint32 total=0;
    for(const auto& value:spec["meshes"].toArray()){
        const auto o=value.toObject();QStringList skip;for(const auto& s:o["skip"].toArray())skip<<s.toString();
        QFile file(o["tri"].toString());if(!file.open(QIODevice::ReadOnly))return 7;const QByteArray data=file.readAll();qsizetype at=0;
        auto u32=[&]{quint32 v=0;std::memcpy(&v,data.constData()+at,4);at+=4;return v;};
        MeshGpu mesh;mesh.base=total;QVector<float> positions;QVector<quint32> ids;quint32 local=0;
        const quint32 subsets=u32();
        for(quint32 s=0;s<subsets;++s){
            const quint32 bytes=u32();const QString name=QString::fromUtf8(data.constData()+at,bytes);at+=bytes;const quint32 triangles=u32();
            const bool skipped=skip.contains(name);
            if(!skipped){Range r{quint32(positions.size()/3),triangles*3,total+local};
                for(quint32 i=0;i<triangles*3;++i){float v[6];std::memcpy(v,data.constData()+at+qsizetype(i)*24,24);positions<<v[0]<<v[1]<<v[2];ids<<total+local+i/3;}
                mesh.ranges<<r;}
            for(quint32 i=0;i<triangles;++i)mesh.skipped<<skipped;
            at+=qsizetype(triangles)*72;local+=triangles;
        }
        mesh.triangles=local;total+=local;
        f->glGenVertexArrays(1,&mesh.vao);f->glBindVertexArray(mesh.vao);f->glGenBuffers(1,&mesh.vbo);f->glBindBuffer(GL_ARRAY_BUFFER,mesh.vbo);
        f->glBufferData(GL_ARRAY_BUFFER,positions.size()*4,positions.constData(),GL_STATIC_DRAW);f->glEnableVertexAttribArray(0);f->glVertexAttribPointer(0,3,GL_FLOAT,GL_FALSE,12,nullptr);
        GLuint idBuffer;f->glGenBuffers(1,&idBuffer);f->glBindBuffer(GL_ARRAY_BUFFER,idBuffer);
        f->glBufferData(GL_ARRAY_BUFFER,ids.size()*4,ids.constData(),GL_STATIC_DRAW);f->glEnableVertexAttribArray(1);f->glVertexAttribIPointer(1,1,GL_UNSIGNED_INT,4,nullptr);
        meshes<<mesh;
    }
    GLuint ssbo;f->glGenBuffers(1,&ssbo);f->glBindBuffer(GL_SHADER_STORAGE_BUFFER,ssbo);
    QVector<quint32> zeros(total,0);f->glBufferData(GL_SHADER_STORAGE_BUFFER,qsizetype(total)*4,zeros.constData(),GL_DYNAMIC_COPY);f->glBindBufferBase(GL_SHADER_STORAGE_BUFFER,0,ssbo);

    const int res=spec["resolution"].toInt(2048);
    GLuint fbo,depth;f->glGenFramebuffers(1,&fbo);f->glBindFramebuffer(GL_FRAMEBUFFER,fbo);
    f->glGenTextures(1,&depth);f->glBindTexture(GL_TEXTURE_2D,depth);f->glTexStorage2D(GL_TEXTURE_2D,1,GL_DEPTH_COMPONENT32F,res,res);
    f->glFramebufferTexture2D(GL_FRAMEBUFFER,GL_DEPTH_ATTACHMENT,GL_TEXTURE_2D,depth,0);f->glDrawBuffer(GL_NONE);f->glReadBuffer(GL_NONE);
    if(f->glCheckFramebufferStatus(GL_FRAMEBUFFER)!=GL_FRAMEBUFFER_COMPLETE)return 8;
    f->glViewport(0,0,res,res);f->glEnable(GL_DEPTH_TEST);f->glDisable(GL_CULL_FACE);f->glColorMask(GL_FALSE,GL_FALSE,GL_FALSE,GL_FALSE);

    QMatrix4x4 projection;projection.perspective(90,1,spec["near"].toDouble(0.02),spec["far"].toDouble(60));
    const QVector3D dirs[6]={{1,0,0},{-1,0,0},{0,1,0},{0,-1,0},{0,0,1},{0,0,-1}};
    const QVector3D ups[6]={{0,1,0},{0,1,0},{0,0,1},{0,0,1},{0,1,0},{0,1,0}};
    const GLint depthMvp=f->glGetUniformLocation(depthProgram,"mvp"),markMvp=f->glGetUniformLocation(markProgram,"mvp");
    QElapsedTimer timer;timer.start();quint64 renders=0;
    for(const auto& sceneValue:spec["scenes"].toArray()){
        const auto scene=sceneValue.toObject();
        struct Instance{int mesh;QVector3D t;};QVector<Instance> instances;
        for(const auto& i:scene["instances"].toArray()){const auto o=i.toObject();const auto t=o["t"].toArray();instances<<Instance{o["mesh"].toInt(),QVector3D(t[0].toDouble(),t[1].toDouble(),t[2].toDouble())};}
        for(const auto& eyeValue:scene["eyes"].toArray()){
            const auto e=eyeValue.toArray();const QVector3D eye(e[0].toDouble(),e[1].toDouble(),e[2].toDouble());
            for(int face=0;face<6;++face){
                QMatrix4x4 view;view.lookAt(eye,eye+dirs[face],ups[face]);const QMatrix4x4 vp=projection*view;
                f->glDepthMask(GL_TRUE);f->glDepthFunc(GL_LESS);f->glClear(GL_DEPTH_BUFFER_BIT);
                for(int pass=0;pass<2;++pass){
                    const GLuint program=pass?markProgram:depthProgram;f->glUseProgram(program);
                    if(pass){f->glDepthMask(GL_FALSE);f->glDepthFunc(GL_LEQUAL);}
                    for(const auto& instance:instances){
                        QMatrix4x4 model;model.translate(instance.t);const QMatrix4x4 mvp=vp*model;
                        f->glUniformMatrix4fv(pass?markMvp:depthMvp,1,GL_FALSE,mvp.constData());
                        const auto& mesh=meshes[instance.mesh];f->glBindVertexArray(mesh.vao);
                        for(const auto& r:mesh.ranges)f->glDrawArrays(GL_TRIANGLES,r.first,r.count);
                    }
                }
                ++renders;
            }
        }
        f->glFinish();
    }
    f->glMemoryBarrier(GL_BUFFER_UPDATE_BARRIER_BIT);
    QVector<quint32> visible(total);f->glBindBuffer(GL_SHADER_STORAGE_BUFFER,ssbo);f->glGetBufferSubData(GL_SHADER_STORAGE_BUFFER,0,qsizetype(total)*4,visible.data());
    const auto masks=spec["masks"].toArray();
    for(int m=0;m<meshes.size();++m){
        const auto& mesh=meshes[m];QByteArray bytes(mesh.triangles,0);quint64 count=0;
        for(quint32 i=0;i<mesh.triangles;++i){const bool v=mesh.skipped[i]||visible[mesh.base+i];bytes[i]=v;count+=v;}
        QFile out(masks[m].toString());if(!out.open(QIODevice::WriteOnly))return 9;out.write(bytes);
        QTextStream(stdout)<<masks[m].toString()<<" visible="<<count<<"/"<<mesh.triangles<<"\n";
    }
    QTextStream(stdout)<<"renders="<<renders<<" seconds="<<timer.elapsed()/1000.0<<"\n";
    return 0;
}
