from pathlib import Path
import re
p=Path('outputs/SolidSimNative/assets/catalog/VigorCatalog.qml');s=p.read_text(encoding='utf8')
if 'machineBridgeHome' in s:
 raise RuntimeError('VigorCatalog.qml is already bound; regenerate it with balsam first')
s=s.replace('    id: node','''    id: node
    readonly property real machineBridgeHome: -1.91008632
    readonly property real workBridgeOrigin: -0.33508632
    readonly property bool workMode: machining.liveJob || motion.programMode
    readonly property bool drilling: machining.liveJob ? machining.drilling : motion.programMode && motion.toolKind === "drill"
    readonly property real workX: machining.liveJob ? machining.workX : motion.x
    readonly property real workY: machining.liveJob ? machining.workY : motion.y
    property real axisX: workMode ? workX/1000+workBridgeOrigin-(drilling ? 0.02346428 : 0) : motion.x/1000+machineBridgeHome
    property real axisY: workMode ? workY/1000-0.99354154-(drilling ? 0.28480886 : 0) : motion.y/1000-1.05
    property real axisZ: workMode ? 1.0825051+(stock.thickness-machining.depth)/1000-(drilling ? 1.3783175 : 1.27960551) : (motion.z-60)/1000
    readonly property real routerZ: drilling ? 1.0825051+(stock.thickness+50)/1000-1.27960551 : axisZ
    property real liftHeight: motion.lift / 1000
''',1)
props={'SIM_BRIDGE':'x: node.axisX','SIM_GUARD':'x: node.axisX','SIM_CARRIAGE':'x: node.axisX; z: node.axisY; y: 0.704551 + node.axisZ','SIM_FAM_YELLOW':'x: node.axisX; z: node.axisY; y: 0.704551 + node.axisZ','9KW.001':'x: node.axisX; z: node.axisY; y: 0.704551 + node.routerZ','SIM_LIFT':'y: 0.704551 + node.liftHeight','SUPURMEBOSALTMA.001':'x: node.axisX','CLAMPONU':'x: node.axisX','CLAMP':'x: node.axisX','BASKIRULOSU':'x: node.axisX','ROTARYMAG':'x: node.axisX','VİGOR FT_2136.001':'x: -0.64955 + node.axisX'}
for name,prop in props.items():
 pat=r'(objectName: "'+re.escape(name)+r'"\n\s*position: [^\n]+)';s,n=re.subn(pat,lambda m:m[0]+'\n            '+prop,s,count=1)
 assert n==1,name
for name,prop,axis in [('SIM_BRIDGE','bridgePosition','x'),('9KW.001','spindlePosition','z'),('9KW.001','spindleHeight','y'),('SIM_LIFT','liftPosition','y')]:
 ident=re.search(r'id: (\w+)\n\s*objectName: "'+re.escape(name)+'"',s)[1]
 expr='drilling ? sim_CARRIAGE.y : '+ident+'.'+axis if prop=='spindleHeight' else ident+'.'+axis
 s=s.replace('    // Resources','    property real '+prop+': '+expr+'\n    // Resources',1)
p.write_text(s,encoding='utf8')
