import QtQuick
import QtQuick3D

Node {
    id: node

    // Resources
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
        id: paint__185__188__191__255__material
        objectName: "paint_(185, 188, 191, 255)"
        baseColor: "#ffb9bcbf"
        roughness: 0.75
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: paint__55__55__55__255__material
        objectName: "paint_(55, 55, 55, 255)"
        baseColor: "#ff373737"
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

    // Nodes:
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
                            source: "meshes/l_o_altma1_009_mesh.mesh"
                            materials: [
                                paint__234__232__240__255__material,
                                paint__0__0__0__255__material,
                                paint__185__188__191__255__material,
                                paint__55__55__55__255__material,
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

    // Animations:
}
