from pathlib import Path
import re
p=Path('outputs/SolidSimNative/assets/catalog/VigorCatalog.qml');s=p.read_text(encoding='utf8')
s=s.replace('    id: node','''    id: node
    property real axisX: motion.x / 1000 + (motion.programMode ? -0.33508632 : -0.64955)
    property real axisY: motion.y / 1000 - (motion.programMode ? 0.99354154 : 1.05)
    property real axisZ: motion.programMode ? 1.0825051 + (motion.cutting ? stock.thickness-stock.depth : stock.thickness+30)/1000 - 1.27960551 : (motion.z - 60) / 1000
    property real liftHeight: motion.lift / 1000
''',1)
props={'SIM_BRIDGE':'x: node.axisX','SIM_CARRIAGE':'x: node.axisX; z: node.axisY; y: 0.704551 + node.axisZ','9KW.001':'x: node.axisX; z: node.axisY; y: 0.704551 + node.axisZ','SIM_LIFT':'y: 0.704551 + node.liftHeight','SUPURMEBOSALTMA.001':'x: node.axisX','CLAMPONU':'x: node.axisX','CLAMP':'x: node.axisX','BASKIRULOSU':'x: node.axisX','ROTARYMAG':'x: node.axisX','VİGOR FT_2136.001':'x: -0.64955 + node.axisX'}
for name,prop in props.items():
 pat=r'(objectName: "'+re.escape(name)+r'"\n\s*position: [^\n]+)';s,n=re.subn(pat,lambda m:m[0]+'\n            '+prop,s,count=1)
 assert n==1,name
for name,prop,axis in [('SIM_BRIDGE','bridgePosition','x'),('9KW.001','spindlePosition','z'),('9KW.001','spindleHeight','y'),('SIM_LIFT','liftPosition','y')]:
 ident=re.search(r'id: (\w+)\n\s*objectName: "'+re.escape(name)+'"',s)[1]
 s=s.replace('    // Resources','    property real '+prop+': '+ident+'.'+axis+'\n    // Resources',1)
p.write_text(s,encoding='utf8')
