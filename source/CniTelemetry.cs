using System;
using System.Globalization;
using System.Threading;
using cni.sharedax;

// Read-only adapter. No CNC commands, axis writes or PLC writes.
class CniTelemetry {
    static string Number(double value) {
        if(Double.IsNaN(value)||Double.IsInfinity(value)) throw new Exception("Non-finite axis data");
        return value.ToString("R",CultureInfo.InvariantCulture);
    }
    static int Main() {
        try {
            var shared=new SharedAx();
            if(shared.Attach()!=0||!shared.IsValid()) return 2;
            try {
                while(true) {
                    int count=0;
                    if(shared.ShAxGetNumAx(out count)!=0)return 5;
                    if(count<3||!shared.IsValid())return 3;
                    string[] values=new string[3];
                    for(int axis=0;axis<3;axis++) {
                        double value=Double.NaN;
                        if(shared.ShAxReadParmAss(SharedAx.eIdShaxParmAssR.SHAX_QuotaRealeCartesiana,axis,ref value)!=0)return 6;
                        values[axis]=Number(value);
                    }
                    Console.WriteLine("{\"x\":"+values[0]+",\"y\":"+values[1]+",\"z\":"+values[2]+"}");
                    Console.Out.Flush();
                    Thread.Sleep(100);
                }
            } finally { shared.Detach(); }
        } catch(Exception e) { Console.Error.WriteLine(e.GetType().Name);return 4; }
    }
}
