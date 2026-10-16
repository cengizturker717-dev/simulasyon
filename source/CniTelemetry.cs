using System;
using System.Globalization;
using System.Threading;
using cni.sharedax;
using System.Runtime.InteropServices;
using System.Runtime.CompilerServices;
using System.Reflection;
using System.IO;
using System.ComponentModel;
using cni.servdtm;
using cni.plc;
using cni.cnaccess;

// Read-only adapter. No CNC commands, axis writes or PLC writes.
class CniTelemetry {
    [DllImport("kernel32.dll",CharSet=CharSet.Unicode)] static extern bool SetDllDirectory(string path);
    [DllImport("kernel32.dll",CharSet=CharSet.Unicode,SetLastError=true)] static extern IntPtr LoadLibraryEx(string file,IntPtr reserved,uint flags);
    static string runtime;
    static int Error(int exitCode,string description){Console.Error.WriteLine("CNI_ERROR: "+description.Replace('\r',' ').Replace('\n',' '));return exitCode;}
    static void Stage(string description){Console.Error.WriteLine("CNI_STAGE: "+description);Console.Error.Flush();}
    class ProgramReader {
        readonly SdmLib data=new SdmLib();readonly ScambioPlc plc=new ScambioPlc();
        public ProgramReader(){Stage("Program servisine bağlanılıyor (ServDtm.Attach)");int code=data.Attach();if(code!=0)throw new Exception("ServDtm.Attach kod="+code);Stage("PLC okuma servisine bağlanılıyor (PlcAttachClient)");code=plc.PlcAttachClient();if(code!=0)throw new Exception("PlcAttachClient kod="+code);}
        public string Read(bool first){int executing;string program;
            if(first)Stage("Program çalışma durumu okunuyor (EXE[0])");
            if(plc.PlcSigGetInteger("EXE[0]",out executing)!=0)return ",\"metadataValid\":false";
            if(first)Stage("Çalışan program adı okunuyor (PrgStart)");
            int code=data.GetGenericDataString("PrgStart",1,"PrgStrt",out program);
            if(code!=0||String.IsNullOrWhiteSpace(program))code=data.GetGenericDataString("PrgStart",1,"liv0",out program);
            if(code!=0)return ",\"metadataValid\":false";
            if(first)Stage("Tabla sıfırı okunuyor (GENERAL/CSag)");
            double spoilboard=0;bool panelFrame=data.GetGenericDataDouble("GENERAL",1,"CSag",out spoilboard)==0&&!Double.IsNaN(spoilboard)&&!Double.IsInfinity(spoilboard)&&spoilboard>=0&&spoilboard<=1000;
            return ",\"metadataValid\":true,\"panelFrameValid\":"+(panelFrame?"true":"false")+",\"spoilboard\":"+Number(spoilboard)+",\"executing\":"+(executing!=0?"true":"false")+",\"program\":\""+Escape(program??"")+"\"";
        }
    }
    static string Escape(string value){return value.Replace("\\","\\\\").Replace("\"","\\\"").Replace("\r","\\r").Replace("\n","\\n").Replace("\t","\\t");}
    // Optional services run in a separate, supervised process. A native call
    // that blocks here must never stop SharedAx position updates.
    [MethodImpl(MethodImplOptions.NoInlining)] static int ReadProgram(){
        Stage("Program okuyucusu hazırlanıyor");var reader=new ProgramReader();bool first=true;
        while(true){string fields=reader.Read(first);Console.WriteLine("{"+fields.Substring(1)+"}");Console.Out.Flush();if(first)Stage("Program bilgisi akışı başladı");first=false;Thread.Sleep(100);}
    }
    static string Number(double value) {
        if(Double.IsNaN(value)||Double.IsInfinity(value)) throw new Exception("Non-finite axis data");
        return value.ToString("R",CultureInfo.InvariantCulture);
    }
    static int Main(string[] args) {
        try {
            Console.OutputEncoding=new System.Text.UTF8Encoding(false);
            bool metadata=Array.IndexOf(args,"--metadata")>=0;
            runtime=CniEndpoint.FindRuntime();
            if(!Directory.Exists(runtime))return Error(10,"CNI kurulum klasörü bulunamadı: "+runtime);
            var endpoint=CniEndpoint.Load(runtime);
            AppDomain.CurrentDomain.AssemblyResolve+=(s,e)=>Assembly.LoadFrom(Path.Combine(runtime,new AssemblyName(e.Name).Name+".dll"));
            SetDllDirectory(runtime);
            Environment.CurrentDirectory=Directory.GetParent(runtime).FullName;
            var native=endpoint.Remote?new[]{"ServDtmLib.dll","CnAccess.dll"}:metadata?new[]{"ServDtmLib.dll","ScambioPlc.dll"}:new[]{"SharedAx.dll"};
            var managed=endpoint.Remote?new[]{"ServDtmCs.dll","CnAccessCs.dll"}:metadata?new[]{"ServDtmCs.dll","ScambioPlcCs.dll"}:new[]{"SharedAxCs.dll"};
            foreach(string name in native)if(!File.Exists(Path.Combine(runtime,name)))return Error(11,"CNI dosyası bulunamadı: "+Path.Combine(runtime,name));
            foreach(string name in managed)if(!File.Exists(Path.Combine(runtime,name)))return Error(11,"CNI dosyası bulunamadı: "+Path.Combine(runtime,name));
            // Bind to the installed controller libraries before the typed read
            // loop is JIT compiled. Never replace files in the CNI installation.
            foreach(string name in native)
                if(LoadLibraryEx(Path.Combine(runtime,name),IntPtr.Zero,8)==IntPtr.Zero)return Error(12,name+" yüklenemedi: "+new Win32Exception(Marshal.GetLastWin32Error()).Message);
            foreach(string name in managed)Assembly.LoadFrom(Path.Combine(runtime,name));
            Console.Error.WriteLine("CNI_INFO: CNI4 x86 "+(metadata?"program okuyucusu":"eksen okuyucusu")+"; kurulu CNI");
            Console.Error.WriteLine("CNI_INFO: bağlantı="+(endpoint.Remote?"ağ "+endpoint.Host:"yerel")+"; SDK="+runtime+"; ayar="+endpoint.Config);
            if(endpoint.Remote)return ReadRemote(endpoint.Host,metadata);
            return metadata?ReadProgram():ReadAxes();
        } catch(Exception e) {while(e.InnerException!=null)e=e.InnerException;return Error(4,e.GetType().Name+": "+e.Message);}
    }
    // The real controller runs NC services on Linux. SharedAx/ScambioPlc local
    // shared memory exists in the PC simulator, not in its Windows HMI VM.
    // CnAccess is CNI's remote display client; only read methods are called.
    [MethodImpl(MethodImplOptions.NoInlining)] static int ReadRemote(string host,bool metadata){
        var client=new CnAccess();
        Stage("Ağdaki CNI izleme servisine bağlanılıyor (CnAccess.Attach, "+host+")");
        int code=client.Attach(host,CnAccess.eIdCnaUserType.CNA_USER_TYPE_CLIENT_VIS,CnAccess.eIdCnaTypeAttach.CNA_ATTACH_WAIT);
        if(code!=0)return Error(20,"CnAccess.Attach kod="+code+"; adres="+host);
        try{
            bool first=true;
            while(true){
                if(!client.IsValid())return Error(21,"Ağdaki CNI izleme bağlantısı geçerli değil");
                if(metadata)ReadRemoteProgram(client,first);else ReadRemoteAxes(client,first);
                Console.Out.Flush();if(first)Stage(metadata?"Ağdan program bilgisi akışı başladı":"Ağdan canlı eksen akışı başladı");first=false;
                if(Environment.GetEnvironmentVariable("VIGOR_CNI_PROBE_ONCE")=="1")return 0;
                Thread.Sleep(100);
            }
        }finally{client.Detach();}
    }
    static void ReadRemoteAxes(CnAccess client,bool first){
        if(first)Stage("Ağdan gerçek eksenler ve iş sıfırı okunuyor");
        var raw=new double[3];var work=new double[3];var goal=new double[3];var origins=new double[3];bool workValid=true,targetValid=true;
        for(int axis=0;axis<3;axis++){
            int code=client.CnAccessReadQuoAssD(axis,CnAccess.eIdCnaQuoAss.CNA_QUO_CARTES_REAL,out raw[axis]);
            if(code!=0)throw new Exception("Ağdan gerçek eksen okunamadı; eksen="+axis+", kod="+code);
            double correction;
            bool corrected=client.CnAccessReadQuoAssD(axis,CnAccess.eIdCnaQuoAss.CNA_QUO_CORRTOT,out correction)==0&&Finite(correction);
            workValid&=corrected;work[axis]=corrected?raw[axis]-correction:0;
            bool targeted=client.CnAccessReadQuoAssD(axis,CnAccess.eIdCnaQuoAss.CNA_QUO_OBIETTIVO,out goal[axis])==0&&Finite(goal[axis])&&corrected;
            targetValid&=targeted;goal[axis]=targeted?goal[axis]-correction:0;
            if(client.CnAccessReadQuoAssD(axis,CnAccess.eIdCnaQuoAss.CNA_QUO_CORRORIG,out origins[axis])!=0||!Finite(origins[axis]))origins[axis]=0;
        }
        int origin=-1,tool=0;if(client.CnAccessReadInfCenI(0,CnAccess.eIdCnaInfCenI.CNA_CEN_ORIGINI,out origin)!=0)origin=-1;
        // CNA_ASS_MAND_RIF is a spindle number, not SharedAx.UtenRifAx.
        // Keep the optional legacy reference unset rather than mislabel it.
        Console.WriteLine("{\"x\":"+Number(raw[0])+",\"y\":"+Number(raw[1])+",\"z\":"+Number(raw[2])
            +",\"center\":0,\"originIndex\":"+origin+",\"originX\":"+Number(origins[0])+",\"originY\":"+Number(origins[1])+",\"originZ\":"+Number(origins[2])+",\"toolReference\":"+tool
            +",\"workValid\":"+Bool(workValid)+",\"workX\":"+Number(work[0])+",\"workY\":"+Number(work[1])+",\"workZ\":"+Number(work[2])
            +",\"targetValid\":"+Bool(targetValid)+",\"targetX\":"+Number(goal[0])+",\"targetY\":"+Number(goal[1])+",\"targetZ\":"+Number(goal[2])+",\"metadataValid\":false}");
    }
    static void ReadRemoteProgram(CnAccess client,bool first){
        if(first)Stage("Ağdan çalışan program ve tabla sıfırı okunuyor");
        var data=client.SdmLib;string program;
        int code=data.GetGenericDataString("PrgStart",1,"PrgStrt",out program);
        if(code!=0||String.IsNullOrWhiteSpace(program))code=data.GetGenericDataString("PrgStart",1,"liv0",out program);
        double spoilboard;bool panelFrame=data.GetGenericDataDouble("GENERAL",1,"CSag",out spoilboard)==0&&Finite(spoilboard)&&spoilboard>=0&&spoilboard<=1000;
        CnAccess.eIdCnaDbState state;
        if(code!=0||client.CnAccessGetStateDb(out state)!=0||state==CnAccess.eIdCnaDbState.CNA_DB_STATE_NOCONNECT||state==CnAccess.eIdCnaDbState.CNA_DB_STATE_NONE){Console.WriteLine("{\"metadataValid\":false}");return;}
        bool executing=(client.CnAccessGetStCentro(0,CnAccess.eIdStcStateNc.STC_PLC_EXE)&CnAccess.eIdStcStateNc.STC_PLC_EXE)!=0;
        Console.WriteLine("{\"metadataValid\":true,\"panelFrameValid\":"+Bool(panelFrame)+",\"spoilboard\":"+Number(panelFrame?spoilboard:0)+",\"executing\":"+Bool(executing)+",\"program\":\""+Escape(program??"")+"\"}");
    }
    static bool Finite(double value){return !Double.IsNaN(value)&&!Double.IsInfinity(value);}
    static string Bool(bool value){return value?"true":"false";}
    [MethodImpl(MethodImplOptions.NoInlining)] static int ReadAxes() {
            Stage("Eksen okuyucusu hazırlanıyor (SharedAx)");var shared=new SharedAx();
            Stage("Canlı eksen paylaşımına bağlanılıyor (SharedAx.Attach)");
            int attached=shared.Attach();
            if(attached!=0)return Error(2,"SharedAx.Attach kod="+attached+". Açık CNI ile canlı eksen bağlantısı kurulamadı.");
            try {
                Stage("Eksen paylaşımı doğrulanıyor (SharedAx.IsValid)");
                if(!shared.IsValid())return Error(3,"SharedAx bağlantısı açıldı ancak eksen paylaşımı geçerli değil.");
                bool first=true;
                while(true) {
                    if(first)Stage("Eksen sayısı okunuyor (ShAxGetNumAx)");
                    int count=0;
                    int axisCode=shared.ShAxGetNumAx(out count);
                    if(axisCode!=0)return Error(5,"Eksen sayısı okunamadı; kod="+axisCode);
                    if(count<3||!shared.IsValid())return Error(3,"Canlı eksen paylaşımı hazır değil; eksen sayısı="+count);
                    string[] values=new string[3],work=new string[3],target=new string[3];bool workValid=true,targetValid=true;
                    for(int axis=0;axis<3;axis++) {
                        if(first)Stage("Gerçek eksen okunuyor: "+"XYZ"[axis]);
                        double value=Double.NaN;
                        int readCode=shared.ShAxReadParmAss(SharedAx.eIdShaxParmAssR.SHAX_QuotaRealeCartesiana,axis,ref value);
                        if(readCode!=0)return Error(6,"Gerçek eksen koordinatı okunamadı; eksen="+axis+", kod="+readCode);
                        values[axis]=Number(value);
                        // CorrTotale includes active origin AND spindle/tool correction.
                        double correction=Double.NaN;
                        if(first)Stage("Eksen düzeltmesi okunuyor: "+"XYZ"[axis]);
                        if(shared.ShAxReadParmAss(SharedAx.eIdShaxParmAssR.SHAX_CorrTotale,axis,ref correction)!=0||Double.IsNaN(correction)||Double.IsInfinity(correction)){workValid=false;work[axis]="0";}
                        else work[axis]=Number(value-correction);
                        double goal=Double.NaN;
                        if(first)Stage("Eksen hedefi okunuyor: "+"XYZ"[axis]);
                        if(shared.ShAxReadParmAss(SharedAx.eIdShaxParmAssR.SHAX_QuotaObiettivo,axis,ref goal)!=0||Double.IsNaN(goal)||Double.IsInfinity(goal)||Double.IsNaN(correction)||Double.IsInfinity(correction)){targetValid=false;target[axis]="0";}
                        else target[axis]=Number(goal-correction);
                    }
                    int centerCount=0,originIndex=-1,toolReference=0;
                    double originX=0,originY=0,originZ=0;
                    if(first)Stage("Aktif merkez ve orijin okunuyor");
                    shared.ShAxGetNumCen(out centerCount);
                    if(centerCount>0) {
                        shared.ShAxReadParmCen(SharedAx.eIdShaxParmCenI.SHAX_ORIGINI,0,ref originIndex);
                        shared.ShAxReadParmCen(SharedAx.eIdShaxParmCenR.SHAX_ORX,0,ref originX);
                        shared.ShAxReadParmCen(SharedAx.eIdShaxParmCenR.SHAX_ORY,0,ref originY);
                        shared.ShAxReadParmCen(SharedAx.eIdShaxParmCenR.SHAX_ORZ,0,ref originZ);
                    }
                    if(first)Stage("Takım referansı okunuyor");shared.ShAxReadParmAss(SharedAx.eIdShaxParmAssI.SHAX_UtenRifAx,2,ref toolReference);
                    Console.WriteLine("{\"x\":"+values[0]+",\"y\":"+values[1]+",\"z\":"+values[2]
                        +",\"center\":0,\"originIndex\":"+originIndex+",\"originX\":"+Number(originX)
                        +",\"originY\":"+Number(originY)+",\"originZ\":"+Number(originZ)
                        +",\"toolReference\":"+toolReference+",\"workValid\":"+(workValid?"true":"false")+",\"workX\":"+work[0]+",\"workY\":"+work[1]+",\"workZ\":"+work[2]
                        +",\"targetValid\":"+(targetValid?"true":"false")+",\"targetX\":"+target[0]+",\"targetY\":"+target[1]+",\"targetZ\":"+target[2]+",\"metadataValid\":false}");
                    Console.Out.Flush();
                    if(first)Stage("Canlı eksen akışı başladı");first=false;
                    if(Environment.GetEnvironmentVariable("VIGOR_CNI_PROBE_ONCE")=="1")return 0;
                    Thread.Sleep(100);
                }
            } finally { shared.Detach(); }
    }
}
