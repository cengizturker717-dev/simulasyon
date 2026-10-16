using System;
using System.IO;
using System.Collections.Generic;
using Microsoft.Win32;

// Read existing CNI configuration only. Never persist registry or INI changes.
class CniEndpoint {
    public readonly string Runtime, Host, Config;
    public bool Remote {get{return !String.IsNullOrEmpty(Host);}}
    CniEndpoint(string runtime,string host,string config){Runtime=runtime;Host=host;Config=config;}
    public static string FindRuntime(){
        foreach(RegistryView view in new[]{RegistryView.Registry32,RegistryView.Registry64}){
            try{using(var root=RegistryKey.OpenBaseKey(RegistryHive.CurrentUser,view))using(var key=root.OpenSubKey(@"Software\CNI\NcOne",false)){
                string path=key==null?null:key.GetValue("Path") as string;
                if(!String.IsNullOrWhiteSpace(path))foreach(string suffix in new[]{@"NcOne\CnData\Bin",@"CnData\Bin"}){
                    string candidate=Path.Combine(path,suffix);if(Directory.Exists(candidate))return candidate;
                }
            }}catch(System.Security.SecurityException){}catch(UnauthorizedAccessException){}
        }
        return @"C:\CNI\Ncone\CnData\Bin";
    }
    public static CniEndpoint Load(string runtime){
        string config=Path.GetFullPath(Path.Combine(runtime,@"..\CnConf\NcRc.ini"));
        var dirs=new Dictionary<string,string>(StringComparer.OrdinalIgnoreCase);string host="";
        Read(config,dirs,ref host);
        string machine;
        if(dirs.TryGetValue("MachinePath",out machine)){
            for(int pass=0;pass<20&&machine.IndexOf('{')>=0;pass++){
                string previous=machine;foreach(var item in dirs)machine=machine.Replace("{"+item.Key+"}",item.Value);if(machine==previous)break;
            }
            if(machine.IndexOf('{')<0&&Path.IsPathRooted(machine)){
                string local=Path.GetFullPath(Path.Combine(machine,@"Etc\NcRc.ini"));if(File.Exists(local)){Read(local,dirs,ref host);config=local;}
            }
        }
        host=host.Trim();
        if(host.Length>0&&(Uri.CheckHostName(host)==UriHostNameType.Unknown||host.IndexOfAny(new[]{' ','\t','\r','\n'})>=0))throw new Exception("NcRc.ini içinde geçersiz IpNc adresi");
        return new CniEndpoint(runtime,host,config);
    }
    static void Read(string path,Dictionary<string,string> dirs,ref string host){
        if(!File.Exists(path))throw new FileNotFoundException("CNI bağlantı ayarı bulunamadı",path);
        string section="";
        foreach(string source in File.ReadAllLines(path)){
            string line=source.Trim();if(line.Length==0||line[0]==';'||line[0]=='#')continue;
            if(line.StartsWith("[")&&line.EndsWith("]")){section=line.Substring(1,line.Length-2).Trim();continue;}
            int split=line.IndexOf('=');if(split<1)continue;string key=line.Substring(0,split).Trim(),value=line.Substring(split+1).Trim();
            if(section.Equals("Conf",StringComparison.OrdinalIgnoreCase)&&key.Equals("IpNc",StringComparison.OrdinalIgnoreCase))host=value;
            if(section.Equals("Direttori",StringComparison.OrdinalIgnoreCase))dirs[key]=value;
        }
    }
}
