using System;using System.IO;
class CniEndpointChecks {
 static int checks;
 static void Check(bool condition,string name){if(!condition)throw new Exception(name);Console.WriteLine("PASS "+name);checks++;}
 static int Main(string[] args){string root=Path.GetFullPath(args[0]);Directory.CreateDirectory(root);string runtime=Path.Combine(root,@"CnData\Bin");Directory.CreateDirectory(runtime);string conf=Path.Combine(root,@"CnData\CnConf");Directory.CreateDirectory(conf);string config=Path.Combine(conf,"NcRc.ini");string machine=Path.Combine(root,"Machine");Directory.CreateDirectory(Path.Combine(machine,"Etc"));string local=Path.Combine(machine,@"Etc\NcRc.ini");
  File.WriteAllText(config,"[Conf]\nIpNc=\n");Check(!CniEndpoint.Load(runtime).Remote,"simulator retains local SharedAx path");
  File.WriteAllText(config,"[Conf]\nIpNc=2.2.2.1\nPwdNc=DO_NOT_LOG\n");var remote=CniEndpoint.Load(runtime);Check(remote.Remote&&remote.Host=="2.2.2.1","controller uses configured remote address");Check(remote.Config==config,"records configuration source");
  File.WriteAllText(config,"[conf]\nIPNC = cnc-host\n");Check(CniEndpoint.Load(runtime).Host=="cnc-host","case-insensitive keys and hostnames");
  File.WriteAllText(config,"[Conf]\nIpNc=2.2.2.1\n[Direttori]\nMachinePath={InstallPath}\\Machine\\\nInstallPath={Root}\\\nRoot="+root+"\n");File.WriteAllText(local,"[Direttori]\nOther=anything\n");Check(CniEndpoint.Load(runtime).Host=="2.2.2.1","machine directory override preserves base endpoint");
  File.WriteAllText(local,"[Conf]\nIpNc=2.2.2.7\n");remote=CniEndpoint.Load(runtime);Check(remote.Host=="2.2.2.7"&&remote.Config==local,"active machine endpoint takes precedence");
  File.WriteAllText(local,"[Conf]\nIpNc=\n");Check(!CniEndpoint.Load(runtime).Remote,"explicit local override respected");
  File.WriteAllText(local,"[Conf]\nIpNc=bad host --sim\n");bool invalid=false;try{CniEndpoint.Load(runtime);}catch(Exception){invalid=true;}Check(invalid,"invalid endpoint rejected rather than guessed");
  File.Delete(local);File.WriteAllText(config,"[Conf]\nIpNc=2.2.2.1\n[Direttori]\nMachinePath={Cycle}\nCycle={MachinePath}\n");Check(CniEndpoint.Load(runtime).Host=="2.2.2.1","cyclic directory macros cannot hang reader");
  File.Delete(config);bool missing=false;try{CniEndpoint.Load(runtime);}catch(FileNotFoundException){missing=true;}Check(missing,"missing configuration fails explicitly");
  Console.WriteLine(checks+" endpoint checks passed");return 0;
 }
}
