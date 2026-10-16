"""Apply the reviewed visual drill rig without changing machine-axis anchors."""
from pathlib import Path
import re
import sys

source, target = map(Path, sys.argv[1:3])
s = source.read_text(encoding="utf-8")
if "drillRigVersion" in s:
    raise SystemExit("The scene already contains the reviewed drill rig")
s = s.replace("import QtQuick3D", "import QtQuick3D\nimport Poyraz.Native 1.0", 1)
properties = '''
    readonly property int drillRigVersion: 1
    readonly property var selectedDrills: machining.liveJob ? machining.activeDrills : motion.activeDrills
    readonly property var registeredDrills: machineData.verticalDrills.length ? machineData.verticalDrills : selectedDrills
    readonly property real routerTipHeight: .704551 + node.axisZ + sceneFrame.routerY + .57505423
    // Retracted drill tips clear the cutter by 15 mm and always clear the
    // loaded stock. The bank body stays another 30 mm above these tool tips.
    readonly property real drillRestTip: Math.max(routerTipHeight + .015,
        machining.visible ? machining.stockY + stock.thickness/1000 + .015 : routerTipHeight + .015)
    readonly property real drillBodyLift: drillRestTip - (.704551 + node.axisZ + .6737665)
    readonly property bool pistonEngaged: node.drilling && machining.depth > 0 && !machining.error &&
        (machining.liveJob ? machining.status.indexOf("Canlı işleme") === 0 : motion.cutting)
'''
s = s.replace("    // Resources", properties+"\n    // Resources", 1)
old = '''        Model {
            id: sim_CARRIAGE
            objectName: "SIM_CARRIAGE"
            position: Qt.vector3d(node.axisX, 0.704551 + node.axisZ, node.axisY)
            source: "meshes/sim_CARRIAGE_mesh.mesh"
            materials: [
                famSilverMaterial,
                famWhiteMaterial,
                paint__0__0__0__255__material
            ]
        }'''
new = '''        Node {
            id: sim_CARRIAGE
            objectName: "SIM_CARRIAGE"
            // The unmodified machine Z pivot remains the calibration reference.
            position: Qt.vector3d(node.axisX, 0.704551 + node.axisZ, node.axisY)
            Model {
                objectName: "SIM_DRILL_BANK_BODY"
                y: node.drillBodyLift
                source: "meshes/sim_CARRIAGE_mesh.mesh"
                materials: [famSilverMaterial, famWhiteMaterial, paint__0__0__0__255__material]
            }
        }'''
assert s.count(old) == 1
s = s.replace(old, new, 1)
s, changed = re.subn(r'(id: sim_FAM_YELLOW\s+objectName: "SIM_FAM_YELLOW"\s+position: Qt.vector3d\(node.axisX, 0.704551 \+ node.axisZ), node.axisY\)',r'\1 + node.drillBodyLift, node.axisY)',s)
assert changed == 1
start = s.index('    Model {\n        objectName: "SIM_CLOSED_REAR_CAGE_DOOR_PANEL"')
end = s.index('\n    }',start)+len('\n    }')
s = s[:start]+s[end:]
instances = '''
    Model {
        objectName: "SIM_DRILL_PISTONS"
        visible: node.registeredDrills.length > 0
        source: "#Cylinder"
        instancing: DrillInstances {
            objectName: "drillInstances"
            tools: node.registeredDrills
            selected: node.selectedDrills
            origin: Qt.vector3d(node.axisX + .048644,0,node.axisY + .073707)
            restTip: node.drillRestTip
            cutTip: machining.stockY + (stock.thickness - machining.depth)/1000
            engaged: node.pistonEngaged
        }
        materials: PrincipledMaterial { baseColor: "#c4c8cc"; metalness: .55; roughness: .32 }
    }
'''
head, tail = s.rsplit('\n}',1)
target.parent.mkdir(parents=True,exist_ok=True)
target.write_text(head+instances+'\n}'+tail,encoding="utf-8")
print("rear_yellow_panel_removed=1 drill_rig=1 axis_anchors_unchanged=1")
