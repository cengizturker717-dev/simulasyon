from pathlib import Path
import re,json
src=Path('outputs/SolidSimNative/assets/catalog/VigorCatalog.qml')
s=src.read_text(encoding='utf8')
# The legacy Plane.001 / 2136 nameplate renders as a grey block over the Vigor mark.
keep={'VİGOR FT_2136','ROTARYMAG','BASKIRULOSU','9KW.001','10LUMAG.014','SIM_BRIDGE','SIM_GUARD','SIM_CARRIAGE','SIM_FAM_YELLOW'}
removed=[]
def filterblock(m):
 b=m[0];n=re.search(r'objectName: "([^"]+)"',b);name=n[1] if n else '(unnamed)'
 if name in keep:return b
 removed.append(name);return ''
s=re.sub(r'^        (?:Node|Model) \{\n.*?^        \}',filterblock,s,flags=re.M|re.S)
# Keep one binding for the whole position. A constant position plus separate
# x/y/z bindings can overwrite initial coordinates when live data arrives first.
s=s.replace('position: Qt.vector3d(0, 0.704551, 0)\n            x: node.axisX; z: node.axisY; y: 0.704551 + node.axisZ',
            'position: Qt.vector3d(node.axisX, 0.704551 + node.axisZ, node.axisY)')
s=s.replace('position: Qt.vector3d(0, 0.704551, 0)\n            x: node.axisX',
            'position: Qt.vector3d(node.axisX, 0.704551, 0)')
s=re.sub(r'^    property real (?:liftHeight|liftPosition):.*\n','',s,flags=re.M)
s=s.replace('    id: node','    id: node\n    readonly property bool simplified: true',1)
s=s.replace('    // Nodes:','''    PrincipledMaterial {
        id: hsdAluminumMaterial
        objectName: "HSD ES929-A aluminum"
        baseColor: "#ffc5c9cc"
        metalness: 0.62
        roughness: 0.30
        cullMode: PrincipledMaterial.NoCulling
    }
    PrincipledMaterial {
        id: famWhiteMaterial
        objectName: "FAM housing white"
        baseColor: "#fff2f2f0"
        metalness: 0.10
        roughness: 0.42
        cullMode: PrincipledMaterial.NoCulling
    }
    PrincipledMaterial {
        id: famSilverMaterial
        objectName: "FAM machined aluminum"
        baseColor: "#ff9da3a7"
        metalness: 0.68
        roughness: 0.28
        cullMode: PrincipledMaterial.NoCulling
    }
    PrincipledMaterial {
        id: famGrayMaterial
        objectName: "FAM guide gray"
        baseColor: "#ff8f969b"
        metalness: 0.55
        roughness: 0.32
        cullMode: PrincipledMaterial.NoCulling
    }

    // Nodes:''',1)

def set_model_materials(name,materials):
 global s
 pattern=(r'(objectName: "'+re.escape(name)+r'".*?materials:\s*\[)'
          r'.*?(\])')
 replacement=lambda m:m.group(1)+'\n                '+',\n                '.join(materials)+'\n            '+m.group(2)
 s,count=re.subn(pattern,replacement,s,count=1,flags=re.S)
 assert count==1,name

set_model_materials('9KW.001',['hsdAluminumMaterial'])
set_model_materials('SIM_CARRIAGE',['famSilverMaterial','famWhiteMaterial','paint__0__0__0__255__material'])
set_model_materials('SIM_FAM_YELLOW',['famGrayMaterial'])
s=s.replace('source: "meshes/l_o_altma1_009_mesh.mesh"', 'source: "cleanedstatic/meshes/l_o_altma1_009_mesh.mesh"')
# Hide only the corrugated 145 mm dust hose inside the spindle assembly.  Its
# parent spindle, motor, plates and protective covers remain visible and bound
# to the machine axes.
s=s.replace('objectName: "2100_FREZE MOT_HSD 2_TOZ EMÝÞ_145 MM BORU"',
            'objectName: "2100_FREZE MOT_HSD 2_TOZ EMÝÞ_145 MM BORU"\n                        visible: false', 1)
# Cream corrugated hose between the pressure-roll assembly and the black bed.
s=s.replace('objectName: "makine3-parça.005"',
            'objectName: "makine3-parça.005"\n                visible: false', 1)
# Lightweight orange double stripes that lead into the two existing Vigor
# marks.  Primitive cubes keep the decoration cheap on the controller GPU.
brand_stripes='''

    Model {
        objectName: "SIM_BASE_BRAND_STRIPE_TOP"
        source: "#Cube"
        position: Qt.vector3d(0.925, 0.384, 0.847)
        scale: Qt.vector3d(0.0385, 0.00012, 0.000035)
        materials: [paint__231__88__7__255__material]
        castsShadows: false
        receivesShadows: false
    }
    Model {
        objectName: "SIM_BASE_BRAND_STRIPE_BOTTOM"
        source: "#Cube"
        position: Qt.vector3d(0.925, 0.330, 0.847)
        scale: Qt.vector3d(0.0385, 0.00012, 0.000035)
        materials: [paint__231__88__7__255__material]
        castsShadows: false
        receivesShadows: false
    }
    Model {
        objectName: "SIM_BRIDGE_BRAND_STRIPE_TOP"
        source: "#Cube"
        position: Qt.vector3d(sim_BRIDGE.x + 0.5505, 1.490, 0.020)
        scale: Qt.vector3d(0.000035, 0.00012, 0.0140)
        materials: [paint__231__88__7__255__material]
        castsShadows: false
        receivesShadows: false
    }
    Model {
        objectName: "SIM_BRIDGE_BRAND_STRIPE_BOTTOM"
        source: "#Cube"
        position: Qt.vector3d(sim_BRIDGE.x + 0.5505, 1.436, 0.020)
        scale: Qt.vector3d(0.000035, 0.00012, 0.0140)
        materials: [paint__231__88__7__255__material]
        castsShadows: false
        receivesShadows: false
    }
    Model {
        objectName: "SIM_TABLE_LEFT_EXTENSION"
        source: "#Cube"
        // Restore the source table panel at its exact original bounds:
        // X -1.0170..-0.0339 m, Z -1.2046..0.8951 m.
        position: Qt.vector3d(-0.52545, 1.0716, -0.15475)
        scale: Qt.vector3d(0.009831, 0.000209, 0.020998)
        materials: [paint__175__178__181__255__material]
        castsShadows: false
        receivesShadows: true
    }
    Model {
        objectName: "SIM_TABLE_FLAT_SURFACE"
        source: "#Cube"
        // One continuous plain top skin over the exact source-table bounds.
        // It hides vacuum holes, fixing holes and cosmetic panel markings.
        position: Qt.vector3d(1.17755, 1.0830, -0.15475)
        scale: Qt.vector3d(0.043891, 0.000015, 0.021003)
        materials: [paint__175__178__181__255__material]
        castsShadows: false
        receivesShadows: true
    }
    Model {
        objectName: "SIM_BRIDGE_SIDE_COVER"
        source: "#Cube"
        position: Qt.vector3d(sim_BRIDGE.x + 0.5505, 1.338, 1.217)
        scale: Qt.vector3d(0.00004, 0.00843, 0.00278)
        materials: [paint__185__188__191__255__material]
        castsShadows: false
        receivesShadows: false
    }
    Model {
        objectName: "SIM_BRIDGE_OPPOSITE_SIDE_COVER"
        source: "#Cube"
        position: Qt.vector3d(sim_BRIDGE.x + 0.5505, 1.135, -1.850)
        scale: Qt.vector3d(0.00004, 0.00265, 0.00630)
        materials: [paint__234__232__240__255__material]
        castsShadows: false
        receivesShadows: false
    }
    Model {
        objectName: "SIM_CLOSED_WHITE_CABINET"
        source: "#Cube"
        // Closed replacement for the open black electrical cabinet. It stays
        // on the bridge, while the servo motors and head keep their own Y/Z
        // movement bindings.
        position: Qt.vector3d(sim_BRIDGE.x - 0.4772, 1.9231, node.axisY - 0.0748)
        scale: Qt.vector3d(0.00405, 0.00290, 0.00510)
        materials: [paint__234__232__240__255__material]
        castsShadows: false
        receivesShadows: false
    }
    Model {
        objectName: "SIM_INPUT_BAY_TOP_COVER"
        source: "#Cube"
        // Seal the exposed input bay at its existing lower frame height.
        // The tool-holder row remains above this thin deck.
        position: Qt.vector3d(-1.664, 0.895, -0.15475)
        scale: Qt.vector3d(0.01302, 0.00004, 0.020998)
        materials: [paint__234__232__240__255__material]
        castsShadows: false
        receivesShadows: false
    }
    Model {
        objectName: "SIM_INPUT_TABLE_STEP_COVER"
        source: "#Cube"
        // Close the vertical step beneath the raised main table edge.
        position: Qt.vector3d(-1.014, 0.986, -0.15475)
        scale: Qt.vector3d(0.00006, 0.00198, 0.020998)
        materials: [paint__234__232__240__255__material]
        castsShadows: false
        receivesShadows: false
    }
    Model {
        objectName: "SIM_BRIDGE_FLAT_INNER_PANEL"
        source: "#Cube"
        // Flat skin on the inner side of the rear wall, ahead of its divider.
        // Keep the surrounding frame and the reviewed panel's height/width.
        position: Qt.vector3d(sim_BRIDGE.x + 0.5025, 1.54432, -0.97227)
        scale: Qt.vector3d(0.00003, 0.003775, 0.004962)
        materials: [paint__234__232__240__255__material]
        castsShadows: false
        receivesShadows: false
    }
    Model {
        objectName: "SIM_VACUUM_INLET_COVER"
        source: "#Cube"
        // Close the output-end lower opening after removing the three vacuum
        // inlet collars. Keep the edges inside the end posts so the cover
        // cannot protrude through the branded side skins.
        position: Qt.vector3d(3.338, 0.642, -0.15475)
        scale: Qt.vector3d(0.00006, 0.00868, 0.01800)
        materials: [paint__234__232__240__255__material]
        castsShadows: false
        receivesShadows: false
    }
    Model {
        objectName: "SIM_CLOSED_CAGE_DOOR_FRAME"
        source: "#Cube"
        position: Qt.vector3d(sim_BRIDGE.x + 0.019, 1.336, 1.518)
        scale: Qt.vector3d(0.00620, 0.00703, 0.00005)
        materials: [paint__234__232__240__255__material]
        castsShadows: false
        receivesShadows: false
    }
    Model {
        objectName: "SIM_CLOSED_CAGE_DOOR_PANEL"
        source: "#Cube"
        position: Qt.vector3d(sim_BRIDGE.x + 0.019, 1.336, 1.524)
        scale: Qt.vector3d(0.00514, 0.00605, 0.00003)
        materials: [paint__231__175__6__86__material]
        castsShadows: false
        receivesShadows: false
    }
    Model {
        objectName: "SIM_CLOSED_REAR_CAGE_DOOR_PANEL"
        source: "#Cube"
        position: Qt.vector3d(sim_BRIDGE.x + 0.055, 1.334, -2.302)
        scale: Qt.vector3d(0.00680, 0.00700, 0.00003)
        materials: [paint__231__175__6__86__material]
        castsShadows: false
        receivesShadows: false
    }
'''
head,tail=s.rsplit('\n}',1)
s=head+brand_stripes+'\n}'+tail
src.with_name('VigorLite.qml').write_text(s,encoding='utf8')
report={'removed':removed,'full_models':src.read_text(encoding='utf8').count('Model {'),'lite_models':s.count('Model {')}
Path('work/lite-report.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf8')
print(json.dumps(report,ensure_ascii=True))
