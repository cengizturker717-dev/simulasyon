from pathlib import Path
import re,json
src=Path('outputs/SolidSimNative/assets/catalog/VigorCatalog.qml')
s=src.read_text(encoding='utf8')
keep={'VİGOR FT_2136.001','VİGOR FT_2136','BARALI1','BARALI2','SUPURMEBOSALTMA.001','ROTARYMAG','CLAMPONU','CLAMP','BASKIRULOSU','9KW.001','10LUMAG.014','makine3-parça.001','Plane.001','2136','SIM_BRIDGE','SIM_CARRIAGE'}
removed=[]
def filterblock(m):
 b=m[0];n=re.search(r'objectName: "([^"]+)"',b);name=n[1] if n else '(unnamed)'
 if name in keep:return b
 removed.append(name);return ''
s=re.sub(r'^        (?:Node|Model) \{\n.*?^        \}',filterblock,s,flags=re.M|re.S)
s=re.sub(r'^    property real (?:liftHeight|liftPosition):.*\n','',s,flags=re.M)
s=s.replace('    id: node','    id: node\n    readonly property bool simplified: true',1)
s=s.replace('source: "meshes/l_o_altma1_009_mesh.mesh"', 'source: "cleanedstatic/meshes/l_o_altma1_009_mesh.mesh"')
src.with_name('VigorLite.qml').write_text(s,encoding='utf8')
report={'removed':removed,'full_models':src.read_text(encoding='utf8').count('Model {'),'lite_models':s.count('Model {')}
Path('work/lite-report.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf8')
print(json.dumps(report,ensure_ascii=True))
