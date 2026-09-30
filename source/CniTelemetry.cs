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
                    int centerCount=0,originIndex=-1,toolReference=0;
                    double originX=0,originY=0,originZ=0;
                    shared.ShAxGetNumCen(out centerCount);
                    if(centerCount>0) {
                        shared.ShAxReadParmCen(SharedAx.eIdShaxParmCenI.SHAX_ORIGINI,0,ref originIndex);
                        shared.ShAxReadParmCen(SharedAx.eIdShaxParmCenR.SHAX_ORX,0,ref originX);
                        shared.ShAxReadParmCen(SharedAx.eIdShaxParmCenR.SHAX_ORY,0,ref originY);
                        shared.ShAxReadParmCen(SharedAx.eIdShaxParmCenR.SHAX_ORZ,0,ref originZ);
                    }
                    shared.ShAxReadParmAss(SharedAx.eIdShaxParmAssI.SHAX_UtenRifAx,2,ref toolReference);
                    Console.WriteLine("{\"x\":"+values[0]+",\"y\":"+values[1]+",\"z\":"+values[2]
                        +",\"center\":0,\"originIndex\":"+originIndex+",\"originX\":"+Number(originX)
                        +",\"originY\":"+Number(originY)+",\"originZ\":"+Number(originZ)
                        +",\"toolReference\":"+toolReference+"}");
                    Console.Out.Flush();
                    Thread.Sleep(100);
                }
            } finally { shared.Detach(); }
        } catch(Exception e) { Console.Error.WriteLine(e.GetType().Name);return 4; }
    }
}
