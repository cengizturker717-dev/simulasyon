"""Batch reviewed rigid groups without crossing any machine motion boundary."""
from pathlib import Path
import ast
import json
import re
import shutil
import subprocess
import sys

helper, source_root, target_root = map(Path,sys.argv[1:4])
seed=source_root / "catalog/VigorUnbatched.qml"
scene = (seed if seed.exists() else source_root / "catalog/VigorLite.qml").read_text(encoding="utf-8")
target_catalog = target_root / "catalog"
target_catalog.mkdir(parents=True,exist_ok=True)
work = target_root.parent / "batch-specifications"
work.mkdir(parents=True,exist_ok=True)
cube_blocks = {re.search(r'objectName: "([^"]+)"',m[0])[1]:m[0]
               for m in re.finditer(r'^    Model \{\n.*?^    \}',scene,re.M|re.S)}
static_cubes = ["SIM_BASE_BRAND_STRIPE_TOP","SIM_BASE_BRAND_STRIPE_BOTTOM","SIM_TABLE_LEFT_EXTENSION","SIM_TABLE_FLAT_SURFACE","SIM_INPUT_BAY_TOP_COVER","SIM_INPUT_TABLE_STEP_COVER","SIM_VACUUM_INLET_COVER"]
bridge_cubes = ["SIM_BRIDGE_BRAND_STRIPE_TOP","SIM_BRIDGE_BRAND_STRIPE_BOTTOM","SIM_BRIDGE_SIDE_COVER","SIM_BRIDGE_OPPOSITE_SIDE_COVER","SIM_BRIDGE_FLAT_INNER_PANEL","SIM_CLOSED_CAGE_DOOR_FRAME","SIM_CLOSED_CAGE_DOOR_PANEL"]

def expression(text,delta):
    text=text.strip().replace('node.chassisDelta','delta').replace('sim_BRIDGE.x','0')
    tree=ast.parse(text,mode='eval')
    if any(not isinstance(n,(ast.Expression,ast.Constant,ast.Name,ast.Load,ast.BinOp,ast.UnaryOp,ast.Add,ast.Sub,ast.Mult,ast.Div,ast.USub,ast.UAdd)) for n in ast.walk(tree)):
        raise ValueError(text)
    if any(n.id!='delta' for n in ast.walk(tree) if isinstance(n,ast.Name)):
        raise ValueError(text)
    return eval(compile(tree,'<CAD transform>','eval'),{'__builtins__':{}},{'delta':delta})

def cube(name,delta):
    block=cube_blocks[name]
    def vector(key):
        return [expression(v,delta) for v in re.search(key+r': Qt.vector3d\(([^)]+)\)',block)[1].split(',')]
    material=re.search(r'materials: \[([^\]]+)\]',block)[1].strip()
    return dict(position=vector('position'),scale=vector('scale'),material=material)

def input_mesh(name,translation,materials):
    return dict(path=str((source_root/'catalog'/name).resolve()),translation=translation,materials=materials)

def merge(name,inputs,cubes):
    covers=[dict(min=[p-50*s for p,s in zip(c['position'],c['scale'])],max=[p+50*s for p,s in zip(c['position'],c['scale'])]) for c in cubes]
    destination=(target_catalog/'merged'/name).resolve()
    spec=dict(output=str(destination),inputs=inputs,cubes=cubes,covers=covers)
    spec_file=work/(name+'.json')
    spec_file.write_text(json.dumps(spec,indent=2),encoding='utf-8')
    subprocess.run([str(helper.resolve()),str(spec_file.resolve())],check=True)
    return json.loads(Path(str(destination)+'.json').read_text())

white='paint__234__232__240__255__material'
black='paint__0__0__0__255__material'
silver='paint__185__188__191__255__material'
orange='paint__231__88__7__255__material'
gray='paint__175__178__181__255__material'
static_materials=[white,black,silver,orange,black,gray,'paint__231__16__0__255__material','paint__0__231__9__255__material']
reports={}
for profile,length in [('2142',4200),('2136',3660),('2128',2800)]:
    original='cleanedstatic/meshes/l_o_altma1_009_mesh.mesh' if profile=='2142' else f'variants/{profile}/static.mesh'
    inputs=[input_mesh(original,[0,.704551,0],static_materials),input_mesh('meshes/node10LUMAG_014_mesh.mesh',[.391593,.491951,0],[white,black])]
    reports[profile]=merge(f'static_{profile}.mesh',inputs,[cube(n,(length-4200)/1000) for n in static_cubes])
assert reports['2142']['materials']==reports['2136']['materials']==reports['2128']['materials']
bridge_inputs=[input_mesh('meshes/sim_BRIDGE_mesh.mesh',[0,.704551,0],[silver,white,black,orange,'paint__231__231__231__95__material',gray]),
               input_mesh('meshes/rotarymag_mesh.mesh',[0,.704551,0],['paint__55__55__55__255__material',silver]),
               input_mesh('meshes/baskirulosu_mesh.mesh',[0,.704551,0],['paint__55__55__55__255__material',silver,'paint__137__84__10__255__material']),
               input_mesh('meshes/sim_GUARD_CONTROLLER_mesh.mesh',[0,.704551,0],[silver])]
reports['bridge']=merge('bridge.mesh',bridge_inputs,[cube(n,0) for n in bridge_cubes])

for name in static_cubes+bridge_cubes:
    assert scene.count(cube_blocks[name])==1
    scene=scene.replace(cube_blocks[name],'',1)
for name in ['10LUMAG.014','ROTARYMAG','BASKIRULOSU','SIM_GUARD']:
    pattern=r'^        Model \{\n(?:(?!^        \}).)*?objectName: "'+re.escape(name)+r'".*?^        \}'
    scene,count=re.subn(pattern,'',scene,count=1,flags=re.M|re.S)
    assert count==1,name
scene,count=re.subn(r'(id: v_GOR_FT_2136\s+objectName: "[^"\n]+"\s+position:) Qt.vector3d\(0, 0.704551, 0\)',r'\1 Qt.vector3d(0,0,0)',scene,count=1)
assert count==1
scene,count=re.subn(r'(id: l_o_altma1_009\s+objectName: "[^"\n]+"\s+)source: [^\n]+\s+materials: \[.*?\]',lambda m:m[1]+'source: "merged/static_" + vigorProfile.model + ".mesh"\n                                materials: ['+', '.join(reports['2142']['materials'])+']',scene,count=1,flags=re.S)
assert count==1
scene,count=re.subn(r'(id: sim_BRIDGE\s+objectName: "SIM_BRIDGE"\s+)position: [^\n]+\s+source: [^\n]+\s+materials: \[.*?\]',lambda m:m[1]+'position: Qt.vector3d(node.axisX,0,0)\n            source: "merged/bridge.mesh"\n            materials: ['+', '.join(reports['bridge']['materials'])+']',scene,count=1,flags=re.S)
assert count==1
for name in ['node9KW_001_CONTROLLER_mesh.mesh','sim_CARRIAGE_mesh.mesh','sim_FAM_YELLOW_CONTROLLER_mesh.mesh']:
    destination=target_catalog/'meshes'/name
    destination.parent.mkdir(parents=True,exist_ok=True)
    shutil.copy2(source_root/'catalog/meshes'/name,destination)
(target_catalog/'VigorLite.qml').write_text(scene,encoding='utf-8')
(work/'summary.json').write_text(json.dumps(reports,indent=2),encoding='utf-8')
print('rigid_groups_batched=2 motion_boundaries_preserved=1')
