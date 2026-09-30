#pragma once
#include <QObject>
#include <QDir>
#include <QFile>
#include <QUrl>
#include <QRegularExpression>
#include <QVariantList>
#include <cmath>

// Offline XY preview only. Never executes CNI macros or writes machine data.
class Pcni : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString root READ root WRITE setRoot NOTIFY changed)
    Q_PROPERTY(QStringList programs READ programs NOTIFY changed)
    Q_PROPERTY(QString name MEMBER selected NOTIFY changed)
    Q_PROPERTY(QString status MEMBER message NOTIFY changed)
    Q_PROPERTY(QVariantList points MEMBER path NOTIFY changed)
    Q_PROPERTY(QVariantList labels MEMBER tags NOTIFY changed)
    Q_PROPERTY(double width MEMBER sx NOTIFY changed)
    Q_PROPERTY(double height MEMBER sy NOTIFY changed)
    Q_PROPERTY(double thickness MEMBER sz NOTIFY changed)
    Q_PROPERTY(double toolDiameter MEMBER toolDia NOTIFY changed)
    Q_PROPERTY(bool ready MEMBER valid NOTIFY changed)
public:
    explicit Pcni(QObject* parent=nullptr):QObject(parent) { refresh(); }
    QString root() const { return directory; }
    QStringList programs() const { return files; }
    void setRoot(const QString& value) { directory=value; refresh(); }
    Q_INVOKABLE void refresh() {
        files=QDir(directory+"/User/Prog").entryList({"*.pcni"}, QDir::Files, QDir::Name);
        valid=false; path.clear(); tags.clear(); selected.clear();
        message=QString::number(files.size())+" PCNI programı"; emit changed();
    }
    Q_INVOKABLE bool load(const QString& file) {
        valid=false; path.clear(); tags.clear(); selected=file;
        if (!files.contains(file)) { message="Program listede bulunamadı"; emit changed(); return false; }
        QFile input(directory+"/User/Prog/"+file);
        if (!input.open(QIODevice::ReadOnly) || input.size()>10*1024*1024) {
            message="Program okunamadı veya çok büyük"; emit changed(); return false;
        }
        const QString content=QString::fromUtf8(input.readAll());
        auto number=[](const QString& line,const QString& key, double fallback) {
            auto m=QRegularExpression("(?:^|\\s)"+QRegularExpression::escape(key)+"=?([+-]?[0-9]+(?:\\.[0-9]+)?)(?=\\s|$)").match(line);
            return m.hasMatch()?m.captured(1).toDouble():fallback;
        };
        sx=sy=sz=0;toolDia=0; double x=0,y=0; bool active=false; int expected=-1,missing=0; QString problem;
        for (QString line:content.split('\n')) {
            auto tool=QRegularExpression("DIAMETER=([0-9.]+)").match(line);
            if(tool.hasMatch()) toolDia=tool.captured(1).toDouble();
            line=line.section(';',0,0).trimmed();
            if(line.contains("LX=")) { sx=number(line,"LX",0); sy=number(line,"LY",0);sz=number(line,"LZ",0); }
            if(line.contains("P_LBL_N=")) expected=int(number(line,"P_LBL_N",-1));
            auto label=QRegularExpression("PLABELX\\((\\d+)\\)=([0-9.]+)\\s+PLABELY\\(\\1\\)=([0-9.]+)\\s+PLABELR\\(\\1\\)=([+-]?[0-9.]+)\\s+PLABEL_PNG\\(\\1\\)=(\\d+)").match(line);
            if(label.hasMatch()) {
                QString base=QFileInfo(file).completeBaseName()+"_"+QString::number(label.captured(5).toInt()).rightJustified(2,'0');
                QString image;
                for(const QString& ext:QStringList{"bmp","png","jpg"}) {
                    QString candidate=directory+"/User/Import/"+base+"."+ext;
                    if(QFileInfo::exists(candidate)) { image=QUrl::fromLocalFile(candidate).toString(); break; }
                }
                if(image.isEmpty()) ++missing;
                tags.append(QVariantMap{{"index",label.captured(1).toInt()},{"x",label.captured(2).toDouble()},{"y",label.captured(3).toDouble()},{"rotation",label.captured(4).toDouble()},{"image",image}});
            }
            auto gs=QRegularExpression("(?:^|\\s)G(\\d+)(?=\\s|$)").globalMatch(line);
            while(gs.hasNext()) { int g=gs.next().captured(1).toInt(); if(g!=1 && g!=40 && g!=71) problem="Desteklenmeyen G kodu: "+QString::number(g); }
            auto macro=QRegularExpression("(?:^|\\s)L=([^\\s]+)").match(line);
            if(macro.hasMatch() && !QStringList{"P_INIT_LBL_PAR.pcni","PRIMO","PATC","PON","PUP","POFF","PMOFF"}.contains(macro.captured(1))) problem="Desteklenmeyen çevrim: "+macro.captured(1);
            bool start=line.contains(QRegularExpression("\\bL=PON(?:\\s|$)"));
            bool linear=line.contains(QRegularExpression("\\bG1(?:\\s|$)"));
            if(start) active=true;
            if(start || (active && linear)) {
                for(const auto& token:line.split(QRegularExpression("\\s+"),Qt::SkipEmptyParts)) {
                    if((token.startsWith('X') || token.startsWith('Y')) && !QRegularExpression("^[XY]=?[+-]?[0-9]+(?:\\.[0-9]+)?$").match(token).hasMatch()) problem="Desteklenmeyen X/Y ifadesi: "+token;
                }
                double nx=number(line,"X",start?NAN:x), ny=number(line,"Y",start?NAN:y);
                if(!std::isfinite(nx)||!std::isfinite(ny)) {problem="Sayısal olmayan X/Y koordinatı"; continue;}
                x=nx; y=ny;
                if(x<0||x>3660||y<0||y>2100) problem="X/Y yolu prototipin görüntüleme alanı dışında";
                path.append(QVariantMap{{"x",x},{"y",y},{"travel",start}});
            }
            if(line.contains(QRegularExpression("\\bL=(PUP|POFF|PMOFF)(?:\\s|$)"))) active=false;
        }
        if(sx<=0||sy<=0||sx>3660||sy>2100) problem="Plaka ölçüsü eksik veya görüntüleme alanı dışında";
        if(sz<=0||sz>120) problem="Plaka kalınlığı eksik veya 0–120 mm aralığı dışında";
        if(path.size()<2) problem="Görüntülenecek X/Y yolu bulunamadı";
        if(expected<0 || expected!=tags.size()) problem="Etiket sayısı program başlığıyla uyuşmuyor";
        valid=problem.isEmpty();
        message=valid?QString("%1 yol noktası · %2 etiket · %3 eksik görsel\nX/Y önizleme; Z, takım çevrimleri ve gerçek işlem süresi uygulanmaz.").arg(path.size()).arg(tags.size()).arg(missing):problem;
        emit changed(); return valid;
    }
signals:
    void changed();
private:
    QString directory="C:/CNI/Ncone/MachineData/POYRAZ_VIGOR2136_ETH";
    QStringList files;
    QString selected,message;
    QVariantList path,tags;
    double sx=0,sy=0,sz=0,toolDia=0;
    bool valid=false;
};
