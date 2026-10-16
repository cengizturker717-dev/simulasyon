import QtQuick
import QtQuick3D
import Poyraz.Native 1.0

Node {
    id: node
    readonly property bool simplified: true
    readonly property real chassisDelta: (vigorProfile.length - 4200) / 1000
    readonly property real machineBridgeHome: sceneFrame.bridgeHome
    readonly property bool workMode: motion.programMode && !motion.liveMode
    readonly property bool machineMode: motion.hasMachinePosition && !workMode
    readonly property bool drilling: machining.liveJob ? machining.drilling : motion.programMode && motion.toolKind === "drill"
    readonly property real drillReferenceX: motion.activeDrills.length ? (motion.activeDrills[0].mountX || 0) : 0
    readonly property real drillReferenceY: motion.activeDrills.length ? (motion.activeDrills[0].mountY || 0) : 0
    // Live CAD always follows physical axes in one setup frame. EXE, work
    // origins and plate dimensions affect the material, never the machine pose.
    property real axisX: machineMode ? machineBridgeHome+motion.machineX/1000 : workMode ? machining.stockX+motion.x/1000-(drilling ? .048644+drillReferenceX/1000 : .02517972+sceneFrame.routerX) : motion.x/1000+machineBridgeHome
    property real axisY: machineMode ? sceneFrame.carriageHome+motion.machineY/1000 : workMode ? machining.stockZ+motion.y/1000-(drilling ? .073707+drillReferenceY/1000 : -.21110186+sceneFrame.routerZ) : motion.y/1000+sceneFrame.carriageHome
    property real axisZ: machineMode ? sceneFrame.zHome-motion.machineZ/1000 : workMode ? machining.stockY+(stock.thickness-machining.depth)/1000-(drilling ? 1.3783175 : 1.27960551+sceneFrame.routerY) : sceneFrame.zHome+(motion.z-60)/1000
    readonly property real routerZ: axisZ
    property real bridgePosition: sim_BRIDGE.x
    property real spindlePosition: drilling ? sim_CARRIAGE.z : node9KW_001.z
    property real spindleHeight: drilling ? sim_CARRIAGE.y : node9KW_001.y
    property real carriagePosition: sim_CARRIAGE.z
    property real carriageHeight: sim_CARRIAGE.y
    property vector3d carriagePose: sim_CARRIAGE.position
    property vector3d routerPose: node9KW_001.position

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

    // Resources
    PrincipledMaterial {
        id: paint__55__55__55__255__material
        objectName: "paint_(55, 55, 55, 255)"
        baseColor: "#ff373737"
        roughness: 0.75
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: paint__185__188__191__255__material
        objectName: "paint_(185, 188, 191, 255)"
        baseColor: "#ffb9bcbf"
        roughness: 0.75
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: paint__234__232__240__255__material
        objectName: "paint_(234, 232, 240, 255)"
        baseColor: "#ffeae8f0"
        roughness: 0.75
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: paint__0__0__0__255__material
        objectName: "paint_(0, 0, 0, 255)"
        baseColor: "#ff000000"
        roughness: 0.75
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: paint__231__175__6__86__material
        objectName: "paint_(231, 175, 6, 86)"
        baseColor: "#ffe7af06"
        roughness: 0.75
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: paint__231__88__7__255__material
        objectName: "paint_(231, 88, 7, 255)"
        baseColor: "#ffe75807"
        roughness: 0.75
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: paint__175__178__181__255__material
        objectName: "paint_(175, 178, 181, 255)"
        baseColor: "#ffafb2b5"
        roughness: 0.75
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: paint__231__16__0__255__material
        objectName: "paint_(231, 16, 0, 255)"
        baseColor: "#ffe71000"
        roughness: 0.75
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: paint__0__231__9__255__material
        objectName: "paint_(0, 231, 9, 255)"
        baseColor: "#ff00e709"
        roughness: 0.75
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: paint__190__190__168__102__material
        objectName: "paint_(190, 190, 168, 102)"
        baseColor: "#ffbebea8"
        roughness: 0.75
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: paint__177__157__0__255__material
        objectName: "paint_(177, 157, 0, 255)"
        baseColor: "#ffb19d00"
        roughness: 0.75
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: paint__231__203__67__255__material
        objectName: "paint_(231, 203, 67, 255)"
        baseColor: "#ffe7cb43"
        roughness: 0.75
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: paint__231__231__231__95__material
        objectName: "paint_(231, 231, 231, 95)"
        baseColor: "#ffe7e7e7"
        roughness: 0.75
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: paint__137__84__10__255__material
        objectName: "paint_(137, 84, 10, 255)"
        baseColor: "#ff89540a"
        roughness: 0.75
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: paint__218__95__44__255__material
        objectName: "paint_(218, 95, 44, 255)"
        baseColor: "#ffda5f2c"
        roughness: 0.75
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }

    PrincipledMaterial {
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

    // Nodes:
    Node {
        id: root
        objectName: "ROOT"



        Node {
            id: v_GOR_FT_2136
            objectName: "VİGOR FT_2136"
            position: Qt.vector3d(0, 0.704551, 0)
            Node {
                id: v_GOR_FT_2136_BR_2_MONTAJ
                objectName: "VÝGOR FT_2136_BR_2_MONTAJ"
                Node {
                    id: v_GOR_FT_2136_SOL__ASE_2_MONTAJ_
                    objectName: "VÝGOR FT_2136_SOL_ÞASE 2_MONTAJ_"
                    Node {
                        id: v_GOR_FT_2136_SOL__ASE_2_KAPAK__N_ORTA_002
                        objectName: "VÝGOR FT_2136_SOL_ÞASE 2_KAPAK ÖN-ORTA.002"
                        Node {
                            id: v_GOR_FT_2136_SOL__ASE_2_KAPAK__N_ORTA_003
                            objectName: "VÝGOR FT_2136_SOL_ÞASE 2_KAPAK ÖN-ORTA.003"
                            Model {
                                id: l_o_altma1_009
                                objectName: "LÇoðaltma1.009"
                                source: vigorProfile.model === "2142" ? "cleanedstatic/meshes/l_o_altma1_009_mesh.mesh" : "variants/" + vigorProfile.model + "/static.mesh"
                                materials: [
                                    paint__234__232__240__255__material,
                                    paint__0__0__0__255__material,
                                    paint__185__188__191__255__material,
                                    paint__231__88__7__255__material,
                                    paint__0__0__0__255__material,
                                    paint__175__178__181__255__material,
                                    paint__231__16__0__255__material,
                                    paint__0__231__9__255__material
                                ]
                            }
                        }
                    }
                }
            }
        }





        Model {
            id: rotarymag
            objectName: "ROTARYMAG"
            position: Qt.vector3d(node.axisX, 0.704551, 0)
            source: "meshes/rotarymag_mesh.mesh"
            materials: [
                paint__55__55__55__255__material,
                paint__185__188__191__255__material
            ]
        }














        Model {
            id: baskirulosu
            objectName: "BASKIRULOSU"
            position: Qt.vector3d(node.axisX, 0.704551, 0)
            source: "meshes/baskirulosu_mesh.mesh"
            materials: [
                paint__55__55__55__255__material,
                paint__185__188__191__255__material,
                paint__137__84__10__255__material
            ]
        }



        Model {
            id: node9KW_001
            objectName: "9KW.001"
            position: Qt.vector3d(node.axisX+sceneFrame.routerX, 0.704551 + node.routerZ+sceneFrame.routerY, node.axisY+sceneFrame.routerZ)
            source: "meshes/node9KW_001_CONTROLLER_mesh.mesh"
            materials: [
                hsdAluminumMaterial
            ]
        }
        Model {
            id: node10LUMAG_014
            objectName: "10LUMAG.014"
            position: Qt.vector3d(0.391593, 0.491951, 0)
            source: "meshes/node10LUMAG_014_mesh.mesh"
            materials: [
                paint__234__232__240__255__material,
                paint__0__0__0__255__material
            ]
        }


        Model {
            id: sim_BRIDGE
            objectName: "SIM_BRIDGE"
            position: Qt.vector3d(node.axisX, 0.704551, 0)
            source: "meshes/sim_BRIDGE_mesh.mesh"
            materials: [
                paint__185__188__191__255__material,
                paint__234__232__240__255__material,
                paint__0__0__0__255__material,
                paint__231__88__7__255__material,
                paint__231__231__231__95__material,
                paint__175__178__181__255__material
            ]
        }
        Node {
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
        }
        Model {
            id: sim_GUARD
            objectName: "SIM_GUARD"
            position: Qt.vector3d(node.axisX, 0.704551, 0)
            source: "meshes/sim_GUARD_CONTROLLER_mesh.mesh"
            materials: [
                paint__185__188__191__255__material
            ]
        }
        Model {
            id: sim_FAM_YELLOW
            objectName: "SIM_FAM_YELLOW"
            position: Qt.vector3d(node.axisX, 0.704551 + node.axisZ + node.drillBodyLift, node.axisY)
            source: "meshes/sim_FAM_YELLOW_CONTROLLER_mesh.mesh"
            materials: [
                famGrayMaterial
            ]
        }

    }

    // Animations:
    Model {
        objectName: "SIM_VARIANT_NUMBER"
        visible: vigorProfile.model !== "2142"
        source: "#Rectangle"
        position: Qt.vector3d(3.495 + node.chassisDelta, 0.315, 0.847)
        scale: Qt.vector3d(0.0019, 0.00065, 1)
        materials: PrincipledMaterial {
            roughness: 0.75
            cullMode: Material.NoCulling
            baseColorMap: Texture {
                sourceItem: Rectangle {
                    width: 228; height: 78; color: "#eae8f0"
                    Text { anchors.centerIn: parent; text: vigorProfile.model; color: "#e75807"; font.family: "Segoe UI"; font.bold: true; font.pixelSize: 55 }
                }
            }
        }
        castsShadows: false; receivesShadows: false
    }

    Model {
        objectName: "SIM_BASE_BRAND_STRIPE_TOP"
        source: "#Cube"
        position: Qt.vector3d(0.925 + node.chassisDelta / 2, 0.384, 0.847)
        scale: Qt.vector3d(0.0385 + node.chassisDelta / 100, 0.00012, 0.000035)
        materials: [paint__231__88__7__255__material]
        castsShadows: false
        receivesShadows: false
    }
    Model {
        objectName: "SIM_BASE_BRAND_STRIPE_BOTTOM"
        source: "#Cube"
        position: Qt.vector3d(0.925 + node.chassisDelta / 2, 0.330, 0.847)
        scale: Qt.vector3d(0.0385 + node.chassisDelta / 100, 0.00012, 0.000035)
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
        position: Qt.vector3d(1.17755 + node.chassisDelta / 2, 1.0830, -0.15475)
        scale: Qt.vector3d(0.043891 + node.chassisDelta / 100, 0.000015, 0.021003)
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
        position: Qt.vector3d(3.338 + node.chassisDelta, 0.642, -0.15475)
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

}
