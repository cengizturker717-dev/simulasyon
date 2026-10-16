#pragma once
#include <QObject>
#include <QDir>
#include <QFile>
#include <QUrl>
#include <QRegularExpression>
#include <QHash>
#include <QSettings>
#include <QVariantList>
#include <cmath>
#include <functional>

// Read-only interpreter of the installed vertical PON/PUP and G99 cycles.
// Depth is positive downwards from the panel top; CNI Z is LZ+Z.
class Pcni : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString root READ root WRITE setRoot NOTIFY changed)
    Q_PROPERTY(QStringList programs READ programs NOTIFY changed)
    Q_PROPERTY(QVariantList tree READ tree NOTIFY changed)
    Q_PROPERTY(QString path READ selectedPath NOTIFY changed)
    Q_PROPERTY(QString name MEMBER selected NOTIFY changed)
    Q_PROPERTY(QString status MEMBER message NOTIFY changed)
    Q_PROPERTY(QVariantList points MEMBER path NOTIFY changed)
    Q_PROPERTY(QVariantList labels MEMBER tags NOTIFY changed)
    Q_PROPERTY(double width MEMBER sx NOTIFY changed)
    Q_PROPERTY(double height MEMBER sy NOTIFY changed)
    Q_PROPERTY(double thickness MEMBER sz NOTIFY changed)
    Q_PROPERTY(double toolDiameter MEMBER toolDia NOTIFY changed)
    Q_PROPERTY(int holeCount MEMBER holesCount NOTIFY changed)
    Q_PROPERTY(bool ready MEMBER valid NOTIFY changed)
public:
    explicit Pcni(QObject* parent=nullptr):QObject(parent) { refresh(); }
    QString root() const { return directory; }
    double workLength()const{return panelLimit;}
    void setWorkLength(double length){if(length>=2800&&length<=4200&&length!=panelLimit){panelLimit=length;refresh();}}
    QStringList programs() const { return files; }
    QVariantList tree() const { return rows; }
    QString selectedPath() const { return selectedRelative; }
    void setRoot(const QString& value) { directory=value; refresh(); }
    Q_INVOKABLE void refresh() {
        // Programs may sit in sub-folders of User/Prog (as NcOne shows them).
        // `files` holds paths relative to User/Prog; `rows` is the folder tree,
        // folders before files at every level, like the controller's list.
        files.clear();rows.clear();
        const QDir base(directory+"/User/Prog");
        const QStringList filters{"*.pcni",QStringLiteral("*.pcnı")};
        std::function<void(const QString&,int)> walk=[&](const QString& relative,int depth){
            const QDir folder(relative.isEmpty()?base.path():base.filePath(relative));
            for(const QString& sub:folder.entryList(QDir::Dirs|QDir::NoDotAndDotDot,QDir::Name|QDir::IgnoreCase)) {
                const QString path=relative.isEmpty()?sub:relative+"/"+sub;
                const int before=rows.size();
                rows.append(QVariantMap{{"name",sub},{"path",path},{"folder",true},{"depth",depth},{"parent",relative}});
                walk(path,depth+1);
                if(rows.size()==before+1)rows.removeLast();   // hide folders without programs
            }
            for(const QString& name:folder.entryList(filters,QDir::Files,QDir::Name|QDir::IgnoreCase)) {
                const QString path=relative.isEmpty()?name:relative+"/"+name;
                files.append(path);
                rows.append(QVariantMap{{"name",name},{"path",path},{"folder",false},{"depth",depth},{"parent",relative}});
            }
        };
        if(base.exists())walk(QString(),0);
        valid=false;path.clear();tags.clear();selected.clear();selectedRelative.clear();
        message=QString::number(files.size())+" PCNI programı";emit changed();
    }
    Q_INVOKABLE bool load(const QString& file) {
        valid=false;path.clear();tags.clear();holesCount=0;sx=sy=sz=toolDia=0;
        QString normalized=file.trimmed();
        if(normalized.startsWith('"')&&normalized.endsWith('"'))normalized=normalized.mid(1,normalized.size()-2);
        // PrgStart sometimes exposes UTF-8 Turkish characters as ANSI pairs.
        normalized.replace(QStringLiteral("\u00C4\u00B1"),QStringLiteral("\u0131"));
        normalized.replace(QStringLiteral("\u00C4\u00B0"),QStringLiteral("\u0130"));
        selected=QFileInfo(normalized).fileName();
        const QString folder=QDir(directory+"/User/Prog").canonicalPath();
        QString actual=QFileInfo(QDir::isAbsolutePath(normalized)?normalized:folder+"/"+normalized).canonicalFilePath();
        // The controller reports a bare file name; prefer User/Prog itself, then
        // the first match in its sub-folders (tree order).
        if(actual.isEmpty()&&!folder.isEmpty()&&!normalized.contains('/')&&!normalized.contains('\\'))
            for(const QString& candidate:files)
                if(QFileInfo(candidate).fileName().compare(normalized,Qt::CaseInsensitive)==0){actual=QFileInfo(folder+"/"+candidate).canonicalFilePath();break;}
        // Only files inside User/Prog (any depth) are read.
        if(folder.isEmpty()||actual.isEmpty()||!actual.startsWith(folder+"/",Qt::CaseInsensitive)) return reject("Program klasöründe bulunamadı");
        selectedRelative=actual.mid(folder.size()+1);
        QFile input(actual);
        if(!input.open(QIODevice::ReadOnly)||input.size()>10*1024*1024) return reject("Program okunamadı veya çok büyük");
        QSettings tools(directory+"/Dati/datpunt_dat.ini",QSettings::IniFormat);
        QSettings mand(directory+"/Dati/protmand_dat.ini",QSettings::IniFormat);
        QSettings config(directory+"/Dati/datconf_01_dat.ini",QSettings::IniFormat);
        QSettings offsets(directory+"/Dati/datmand_01_dat.ini",QSettings::IniFormat);
        QMap<QString,double> diameters;
        for(const auto& group:tools.childGroups()) {
            const QString n=tools.value(group+"/NOME").toString();
            const double d=tools.value(group+"/DIAM").toDouble();if(d>0)diameters[n]=d;
        }
        auto drill=[&](int n)->QVariantMap {
            for(const auto& g:mand.childGroups()) if(mand.value(g+"/name").toString()=="T"+QString::number(n)) {
                if(mand.value(g+"/type").toString()!="VERT")return {};
                QString name=config.value(g+"/UTE00").toString();double d=diameters.value(name);
                if(d<=0)return {};
                return {{"tool",n},{"name",name},{"diameter",d},{"dx",offsets.value(g+"/OFFX").toDouble()},{"dy",offsets.value(g+"/OFFY").toDouble()}};
            }return {};
        };
        auto number=[](const QString& line,const QString& key,double fallback) {
            auto m=cachedRegex("(?:^|\\s)"+QRegularExpression::escape(key)+"=?([+-]?(?:[0-9]+(?:\\.[0-9]*)?|\\.[0-9]+))(?=\\s|$)").match(line);
            return m.hasMatch()?m.captured(1).toDouble():fallback;
        };
        double x=0,y=0,depth=-20,diam=0,feed=100,ox=0,oy=0;
        QString toolName,kind="router";QVariantList drills;
        bool active=false,modalRapid=false;int expected=-1,lineNumber=0;QString problem;
        auto append=[&](double nx,double ny,double nd,bool travel,double velocity) {
            if(!std::isfinite(nx)||!std::isfinite(ny)||!std::isfinite(nd)||!std::isfinite(velocity)||velocity<=0||nd<-500||nd>500||nx<0||nx>panelLimit||ny<0||ny>2100){problem="Geçersiz koordinat, derinlik veya ilerleme · seçili makine sınırı";return;}
            path.append(QVariantMap{{"x",nx},{"y",ny},{"depth",nd},{"travel",travel},{"diameter",diam},{"feed",velocity},{"kind",kind},{"tool",toolName},{"line",lineNumber},{"holes",drills}});
            x=nx;y=ny;depth=nd;
        };
        const QString content=QString::fromUtf8(input.readAll());
        for(QString raw:content.split('\n')) {
            auto td=cachedRegex("NAME=\"([^\"]+)\".*DIAMETER=([0-9.]+)").match(raw);
            // A program comment does not register a tool in the CNI library.
            // Tool diameter always comes from datpunt_dat.ini.
            if(td.hasMatch()&&diameters.contains(td.captured(1))&&std::abs(diameters.value(td.captured(1))-td.captured(2).toDouble())>.01)
                return reject(td.captured(1)+" takım çapı programla takım kütüphanesinde farklı");
            QString line=raw.section(';',0,0).trimmed();if(line.isEmpty()||line.startsWith('[')||line=="%")continue;
            lineNumber=int(number(line,"N",lineNumber));
            if(line.contains(cachedRegex("\\bLX=?"))) {sx=number(line,"LX",0);sy=number(line,"LY",0);sz=number(line,"LZ",0);}
            if(line.contains("P_LBL_N="))expected=int(number(line,"P_LBL_N",-1));
            auto label=cachedRegex("PLABELX\\((\\d+)\\)=([0-9.]+)\\s+PLABELY\\(\\1\\)=([0-9.]+)\\s+PLABELR\\(\\1\\)=([+-]?[0-9.]+)\\s+PLABEL_PNG\\(\\1\\)=(\\d+)").match(line);
            if(label.hasMatch()) {
                QString base=QFileInfo(actual).completeBaseName()+"_"+QString::number(label.captured(5).toInt()).rightJustified(2,'0'),image;
                for(const QString& ext:QStringList{"bmp","png","jpg"}){QString candidate=directory+"/User/Import/"+base+"."+ext;if(QFileInfo::exists(candidate)){image=QUrl::fromLocalFile(candidate).toString();break;}}
                tags.append(QVariantMap{{"index",label.captured(1).toInt()},{"x",label.captured(2).toDouble()},{"y",label.captured(3).toDouble()},{"rotation",label.captured(4).toDouble()},{"image",image}});
                continue;
            }
            auto gs=cachedRegex("(?:^|\\s)G(\\d+)(?=\\s|$)").globalMatch(line);
            bool linear=false,rapid=false;
            while(gs.hasNext()){int g=gs.next().captured(1).toInt();linear|=g==1;rapid|=g==0;if(g!=0&&g!=1&&g!=40&&g!=71)problem="Desteklenmeyen G kodu: G"+QString::number(g);}
            if(linear||rapid)modalRapid=rapid;
            const auto macro=cachedRegex("(?:^|\\s)L=([^\\s]+)").match(line);
            QString cycle=macro.captured(1);
            const bool coordinateLine=cachedRegex("(?:^|\\s)(?:X|Y|Z|XI|YI|ZI|PRF)=?[^\\s]+").match(line).hasMatch();
            if(active&&cycle.isEmpty()&&!linear&&!rapid&&coordinateLine){rapid=modalRapid;linear=!modalRapid;}
            if(!cycle.isEmpty()&&!QStringList{"P_INIT_LBL_PAR.pcni","PRIMO","PATC","PON","PUP","POFF","PMOFF","G99"}.contains(cycle))problem="Desteklenmeyen çevrim: "+cycle;
            if(cycle=="PATC") {
                if(active)append(x,y,-20,true,200);active=false;
                auto t=cachedRegex("ST1=\"([^\"]+)\"").match(line);
                toolName=t.captured(1);diam=diameters.value(toolName);kind="router";drills.clear();
            }
            ox=number(line,"XO",ox);oy=number(line,"YO",oy);
            if(cycle=="PON"||cycle=="G99"||(active&&(linear||rapid))) {
                for(const auto& token:line.split(cachedRegex("\\s+"),Qt::SkipEmptyParts)) {
                    if(cachedRegex("^(X|Y|Z|XI|YI|ZI|PRF|QVF|QVD|F)=?").match(token).hasMatch()&&!cachedRegex("^(X|Y|Z|XI|YI|ZI|PRF|QVF|QVD|F)=?[+-]?(?:[0-9]+(?:\\.[0-9]*)?|\\.[0-9]+)$").match(token).hasMatch())problem="Desteklenmeyen sayısal ifade: "+token;
                }
                double nx=number(line,"X",x-ox)+ox+number(line,"XI",0),ny=number(line,"Y",y-oy)+oy+number(line,"YI",0);
                if(cycle=="PON"||cycle=="G99") {
                    modalRapid=false;
                    double target=number(line,"PRF",NAN);feed=number(line,"QVF",NAN)*1000/60;
                    if(cycle=="G99"||int(number(line,"QTM",3))==1) {
                        kind="drill";drills.clear();auto ts=cachedRegex("(?:^|\\s)T=([0-9,]+)(?=\\s|$)").match(line);
                        for(const auto& t:ts.captured(1).split(',',Qt::SkipEmptyParts)){auto d=drill(t.toInt());if(d.isEmpty()){problem="T"+t+" matkabı veya atandığı takım takım kütüphanesinde tanımlı değil";break;}drills.append(d);}
                        if(drills.isEmpty()){if(problem.isEmpty())problem="Dikey matkap seçimi bulunamadı";}
                        else {auto first=drills.first().toMap();double dx=first["dx"].toDouble(),dy=first["dy"].toDouble();
                            for(auto& v:drills){auto d=v.toMap();d["mountX"]=d["dx"];d["mountY"]=d["dy"];d["dx"]=d["dx"].toDouble()-dx;d["dy"]=d["dy"].toDouble()-dy;v=d;}
                            diam=first["diameter"].toDouble();toolName="T"+QString::number(first["tool"].toInt());holesCount+=drills.size();}
                    } else if(int(number(line,"QTM",3))!=3||number(line,"QSD",0)!=0)problem="Yatay / açılı giriş çevrimi desteklenmiyor";
                    else {kind="router";drills.clear();diam=diameters.value(toolName);}
                    if(problem.isEmpty()&&diam<=0)problem=toolName+" takımı takım kütüphanesinde tanımlı değil";
                    else if(problem.isEmpty()&&diam>80)problem=toolName+" takım çapı simülasyon sınırının dışında";
                    if(toolDia==0)toolDia=diam;
                    // Never sweep between holes or profiles at cutting depth.
                    if(!path.isEmpty())append(x,y,-20,true,200);
                    append(nx,ny,-20,true,200);
                    append(nx,ny,target,false,number(line,"QVD",number(line,"QVF",NAN))*1000/60);
                    active=cycle!="G99";
                    if(cycle=="G99")append(nx,ny,-20,true,200);
                } else {
                    double nd=number(line,"PRF",depth);nd=number(line,"Z",nd-sz)+sz+number(line,"ZI",0);
                    feed=number(line,"F",feed*60/1000)*1000/60;
                    append(nx,ny,nd,rapid,rapid?200:feed);
                }
            }
            if(cycle=="PUP"||cycle=="POFF"||cycle=="PMOFF") {
                if(active)append(x,y,-std::abs(number(line,"QUP",20)),true,200);active=false;
            }
            if(!problem.isEmpty())return reject(QString("N%1 · %2").arg(lineNumber).arg(problem));
        }
        if(sx<=0||sy<=0||sx>panelLimit||sy>2100||sz<=0||sz>120)return reject("LX / LY / LZ plaka ölçüleri eksik veya seçili makine sınırı dışında");
        if(expected>=0&&expected!=tags.size())return reject("Etiket sayısı program başlığıyla uyuşmuyor");
        if(path.size()<2)return reject("İşlenecek yol bulunamadı");
        valid=true;message=QString("%1 × %2 × %3 mm · %4 yol adımı · %5 matkap deliği\nPRF / Z / ZI derinliği ve takım çapıyla malzeme işleme").arg(sx).arg(sy).arg(sz).arg(path.size()).arg(holesCount);emit changed();return true;
    }
signals: void changed();
private:
    // These patterns are fixed by the interpreter, never supplied by a program.
    // Reuse their compiled form across lines and loads without caching tool data.
    static const QRegularExpression& cachedRegex(const QString& pattern){
        static thread_local QHash<QString,QRegularExpression> patterns;
        auto it=patterns.find(pattern);
        if(it==patterns.end())it=patterns.insert(pattern,QRegularExpression(pattern));
        return it.value();
    }
    bool reject(const QString& reason){valid=false;path.clear();message=reason;emit changed();return false;}
    QString directory="C:/CNI/Ncone/MachineData/POYRAZ_VIGOR2136_ETH";
    QStringList files;QVariantList rows;QString selected,selectedRelative,message;QVariantList path,tags;
    double sx=0,sy=0,sz=0,toolDia=0;int holesCount=0;bool valid=false;
    double panelLimit=3660;
};
