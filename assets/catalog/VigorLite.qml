import QtQuick
import QtQuick3D

Node {
    id: node
    readonly property bool simplified: true
    property real axisX: motion.x / 1000
    property real axisY: (motion.y - 1050) / 1000
    property real axisZ: (motion.z - 60) / 1000


    property real bridgePosition: sim_BRIDGE.x
    property real spindlePosition: node9KW_001.z
    property real spindleHeight: node9KW_001.y
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

    // Nodes:
    Node {
        id: root
        objectName: "ROOT"


        Node {
            id: v_GOR_FT_2136_001
            objectName: "VİGOR FT_2136.001"
            position: Qt.vector3d(-0.64955, 0.704551, -3.72402)
            x: -0.64955 + node.axisX
            rotation: Qt.quaternion(0.981005, 0, 0.19398, 0)
            Node {
                id: v_GOR_FT_2136_BR_2_MONTAJ_001
                objectName: "VÝGOR FT_2136_BR_2_MONTAJ.001"
                Node {
                    id: node2100_KAFES_MONTAJLI_001
                    objectName: "2100_KAFES_MONTAJLI.001"
                    Node {
                        id: node2100_KAFES__N_MONTAJLI_001
                        objectName: "2100_KAFES_ÖN MONTAJLI.001"
                        Node {
                            id: node2100_KAFES__N_KAPAK_MONTAJLI_001
                            objectName: "2100_KAFES_ÖN KAPAK_MONTAJLI.001"
                            Node {
                                id: node2100_KAFES__N_KAFES_CAM_001
                                objectName: "2100_KAFES_ÖN KAFES_CAM.001"
                                Model {
                                    id: y_kseklik_Ekstr_zyon1_032
                                    objectName: "Yükseklik-Ekstrüzyon1.032"
                                    position: Qt.vector3d(0.0826084, 0.631354, 1.59806)
                                    rotation: Qt.quaternion(0.998936, 0, -0.04612, 0)
                                    scale: Qt.vector3d(1.41907, 1.26754, 1.07218)
                                    source: "meshes/mesh_1114_001_mesh.mesh"
                                    materials: [
                                        paint__231__175__6__86__material
                                    ]
                                }
                            }
                        }
                    }
                }
            }
        }
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
                                source: "cleanedstatic/meshes/l_o_altma1_009_mesh.mesh"
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

        Node {
            id: barali2
            objectName: "BARALI2"
            position: Qt.vector3d(0, 0.704551, 0)
            Node {
                id: v_GOR_FT__BARALI_36_2_SA__DAYAMA_S_STEM__001
                objectName: "VÝGOR FT _BARALI 36_2_SAÐ_DAYAMA SÝSTEMÝ.001"
                Node {
                    id: v_GOR_FT_BARALI_36_2_DAYAMA_MONTAJLI_004
                    objectName: "VÝGOR FT_BARALI 36_2_DAYAMA_MONTAJLI.004"
                    Node {
                        id: node60__LIK_POYRAZ_DAYAMA_MONTAJLI_005
                        objectName: "60''LIK POYRAZ_DAYAMA_MONTAJLI.005"
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_ALM_G_VDE_005
                            objectName: "60''LIK POYRAZ_DAYAMA_ALM GÖVDE.005"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_089
                                objectName: "Yükseklik-Ekstrüzyon1.089"
                                source: "meshes/mesh_4_010_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_Kastas_Seals_KO_36X2_005
                            objectName: "60''LIK POYRAZ_DAYAMA_Kastas Seals-KO-36X2.005"
                            Model {
                                id: al_nm__1_052
                                objectName: "Alýnmýþ1.052"
                                source: "meshes/mesh_8_010_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_KASTAS_K52_20X25X4_5_2_005
                            objectName: "60''LIK POYRAZ_DAYAMA_KASTAS-K52-20X25X4-5_2.005"
                            Model {
                                id: al_nm__1_054
                                objectName: "Alýnmýþ1.054"
                                source: "meshes/mesh_12_010_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_KASTAS_K62_32X40X3_2_005
                            objectName: "60''LIK POYRAZ_DAYAMA_KASTAS-K62-32X40X3_2.005"
                            Model {
                                id: al_nm__1_053
                                objectName: "Alýnmýþ1.053"
                                source: "meshes/mesh_9_010_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_MIGNATIS_005
                            objectName: "60''LIK POYRAZ_DAYAMA_MIGNATIS.005"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_088
                                objectName: "Yükseklik-Ekstrüzyon1.088"
                                source: "meshes/mesh_0_010_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_ORTA_P_STON_005
                            objectName: "60''LIK POYRAZ_DAYAMA_ORTA PÝSTON.005"
                            Model {
                                id: m10_Di_li_Delik1_010
                                objectName: "M10 Diþli Delik1.010"
                                source: "meshes/mesh_7_010_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_POP_BUR__005
                            objectName: "60''LIK POYRAZ_DAYAMA_POP BURÇ.005"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_090
                                objectName: "Yükseklik-Ekstrüzyon1.090"
                                source: "meshes/mesh_5_010_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_P_STON_M_L__005
                            objectName: "60''LIK POYRAZ_DAYAMA_PÝSTON MÝLÝ.005"
                            Model {
                                id: pah1_014
                                objectName: "Pah1.014"
                                source: "meshes/mesh_13_010_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_S_L_ND_R_P_STONU_005
                            objectName: "60''LIK POYRAZ_DAYAMA_SÝLÝNDÝR PÝSTONU.005"
                            Model {
                                id: m10_Di_li_Delik1_011
                                objectName: "M10 Diþli Delik1.011"
                                source: "meshes/mesh_11_010_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_YATAKLAMA_BANDI_005
                            objectName: "60''LIK POYRAZ_DAYAMA_YATAKLAMA BANDI.005"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_091
                                objectName: "Yükseklik-Ekstrüzyon1.091"
                                source: "meshes/mesh_10_010_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA_20_MM_EK_027
                            objectName: "POYRAZ_DAYAMA_20 MM EK.027"
                            Model {
                                id: d_nd_r1_005
                                objectName: "Döndür1.005"
                                source: "meshes/mesh_2_010_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA_ALT_FLAN__030
                            objectName: "POYRAZ_DAYAMA_ALT FLANÞ.030"
                            Model {
                                id: _2_5__2_5___ap_Delik2_005
                                objectName: "Ø2.5 (2.5) Çap Delik2.005"
                                source: "meshes/mesh_1_009_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA_SAB_TLEME_AYAK_009
                            objectName: "POYRAZ_DAYAMA_SABÝTLEME AYAK.009"
                            Model {
                                id: kes_Ekstr_zyon4_010
                                objectName: "Kes-Ekstrüzyon4.010"
                                source: "meshes/mesh_3_013_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA__ST_FLAN__030
                            objectName: "POYRAZ_DAYAMA_ÜST FLANÞ.030"
                            Model {
                                id: pah1_015
                                objectName: "Pah1.015"
                                source: "meshes/mesh_14_010_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                    }
                    Node {
                        id: v_GOR_FT_BARALI_DAYAMA_DESTEK_SACI_004
                        objectName: "VÝGOR FT_BARALI_DAYAMA DESTEK SACI.004"
                        Model {
                            id: _8_5__8_5___ap_Delik1_008
                            objectName: "Ø8.5 (8.5) Çap Delik1.008"
                            source: "meshes/mesh_394_007_mesh.mesh"
                            materials: [
                                paint__185__188__191__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: v_GOR_FT_BARALI_36_2_DAYAMA_MONTAJLI_005
                    objectName: "VÝGOR FT_BARALI 36_2_DAYAMA_MONTAJLI.005"
                    Node {
                        id: node60__LIK_POYRAZ_DAYAMA_MONTAJLI_006
                        objectName: "60''LIK POYRAZ_DAYAMA_MONTAJLI.006"
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_ALM_G_VDE_006
                            objectName: "60''LIK POYRAZ_DAYAMA_ALM GÖVDE.006"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_093
                                objectName: "Yükseklik-Ekstrüzyon1.093"
                                source: "meshes/mesh_4_011_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_Kastas_Seals_KO_36X2_006
                            objectName: "60''LIK POYRAZ_DAYAMA_Kastas Seals-KO-36X2.006"
                            Model {
                                id: al_nm__1_055
                                objectName: "Alýnmýþ1.055"
                                source: "meshes/mesh_8_011_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_KASTAS_K52_20X25X4_5_2_006
                            objectName: "60''LIK POYRAZ_DAYAMA_KASTAS-K52-20X25X4-5_2.006"
                            Model {
                                id: al_nm__1_057
                                objectName: "Alýnmýþ1.057"
                                source: "meshes/mesh_12_011_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_KASTAS_K62_32X40X3_2_006
                            objectName: "60''LIK POYRAZ_DAYAMA_KASTAS-K62-32X40X3_2.006"
                            Model {
                                id: al_nm__1_056
                                objectName: "Alýnmýþ1.056"
                                source: "meshes/mesh_9_011_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_MIGNATIS_006
                            objectName: "60''LIK POYRAZ_DAYAMA_MIGNATIS.006"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_092
                                objectName: "Yükseklik-Ekstrüzyon1.092"
                                source: "meshes/mesh_0_011_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_ORTA_P_STON_006
                            objectName: "60''LIK POYRAZ_DAYAMA_ORTA PÝSTON.006"
                            Model {
                                id: m10_Di_li_Delik1_012
                                objectName: "M10 Diþli Delik1.012"
                                source: "meshes/mesh_7_011_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_POP_BUR__006
                            objectName: "60''LIK POYRAZ_DAYAMA_POP BURÇ.006"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_094
                                objectName: "Yükseklik-Ekstrüzyon1.094"
                                source: "meshes/mesh_5_011_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_P_STON_M_L__006
                            objectName: "60''LIK POYRAZ_DAYAMA_PÝSTON MÝLÝ.006"
                            Model {
                                id: pah1_016
                                objectName: "Pah1.016"
                                source: "meshes/mesh_13_011_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_S_L_ND_R_P_STONU_006
                            objectName: "60''LIK POYRAZ_DAYAMA_SÝLÝNDÝR PÝSTONU.006"
                            Model {
                                id: m10_Di_li_Delik1_013
                                objectName: "M10 Diþli Delik1.013"
                                source: "meshes/mesh_11_011_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_YATAKLAMA_BANDI_006
                            objectName: "60''LIK POYRAZ_DAYAMA_YATAKLAMA BANDI.006"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_095
                                objectName: "Yükseklik-Ekstrüzyon1.095"
                                source: "meshes/mesh_10_011_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA_20_MM_EK_028
                            objectName: "POYRAZ_DAYAMA_20 MM EK.028"
                            Model {
                                id: d_nd_r1_006
                                objectName: "Döndür1.006"
                                source: "meshes/mesh_2_011_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA_ALT_FLAN__031
                            objectName: "POYRAZ_DAYAMA_ALT FLANÞ.031"
                            Model {
                                id: _2_5__2_5___ap_Delik2_006
                                objectName: "Ø2.5 (2.5) Çap Delik2.006"
                                source: "meshes/mesh_1_010_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA_SAB_TLEME_AYAK_011
                            objectName: "POYRAZ_DAYAMA_SABÝTLEME AYAK.011"
                            Model {
                                id: kes_Ekstr_zyon4_011
                                objectName: "Kes-Ekstrüzyon4.011"
                                source: "meshes/mesh_3_014_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA__ST_FLAN__031
                            objectName: "POYRAZ_DAYAMA_ÜST FLANÞ.031"
                            Model {
                                id: pah1_017
                                objectName: "Pah1.017"
                                source: "meshes/mesh_14_011_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                    }
                    Node {
                        id: v_GOR_FT_BARALI_DAYAMA_DESTEK_SACI_005
                        objectName: "VÝGOR FT_BARALI_DAYAMA DESTEK SACI.005"
                        Model {
                            id: _8_5__8_5___ap_Delik1_009
                            objectName: "Ø8.5 (8.5) Çap Delik1.009"
                            source: "meshes/mesh_394_008_mesh.mesh"
                            materials: [
                                paint__185__188__191__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: v_GOR_FT_BARALI_36_2_SA__DAYAMA_001
                    objectName: "VÝGOR FT_BARALI 36_2_SAÐ_DAYAMA.001"
                    Model {
                        id: kes_Ekstr_zyon3_014
                        objectName: "Kes-Ekstrüzyon3.014"
                        source: "meshes/mesh_393_002_mesh.mesh"
                        materials: [
                            paint__175__178__181__255__material
                        ]
                    }
                }
            }
            Node {
                id: v_GOR_FT_BARALI_36_2_ORTA_DAYAMA_001
                objectName: "VÝGOR FT BARALI 36_2_ORTA_DAYAMA.001"
                Model {
                    id: radyus1_035
                    objectName: "Radyus1.035"
                    source: "meshes/mesh_395_002_mesh.mesh"
                    materials: [
                        paint__175__178__181__255__material
                    ]
                }
            }
            Node {
                id: v_GOR_FT_BARALI_36_2_SOL_DAYAMA_S_STEM__001
                objectName: "VÝGOR FT_BARALI 36_2_SOL_DAYAMA SÝSTEMÝ.001"
                Node {
                    id: v_GOR_FT_BARALI_36_2_DAYAMA_MONTAJLI_006
                    objectName: "VÝGOR FT_BARALI 36_2_DAYAMA_MONTAJLI.006"
                    Node {
                        id: node60__LIK_POYRAZ_DAYAMA_MONTAJLI_007
                        objectName: "60''LIK POYRAZ_DAYAMA_MONTAJLI.007"
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_ALM_G_VDE_007
                            objectName: "60''LIK POYRAZ_DAYAMA_ALM GÖVDE.007"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_097
                                objectName: "Yükseklik-Ekstrüzyon1.097"
                                source: "meshes/mesh_4_012_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_Kastas_Seals_KO_36X2_007
                            objectName: "60''LIK POYRAZ_DAYAMA_Kastas Seals-KO-36X2.007"
                            Model {
                                id: al_nm__1_058
                                objectName: "Alýnmýþ1.058"
                                source: "meshes/mesh_8_012_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_KASTAS_K52_20X25X4_5_2_007
                            objectName: "60''LIK POYRAZ_DAYAMA_KASTAS-K52-20X25X4-5_2.007"
                            Model {
                                id: al_nm__1_060
                                objectName: "Alýnmýþ1.060"
                                source: "meshes/mesh_12_012_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_KASTAS_K62_32X40X3_2_007
                            objectName: "60''LIK POYRAZ_DAYAMA_KASTAS-K62-32X40X3_2.007"
                            Model {
                                id: al_nm__1_059
                                objectName: "Alýnmýþ1.059"
                                source: "meshes/mesh_9_012_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_MIGNATIS_007
                            objectName: "60''LIK POYRAZ_DAYAMA_MIGNATIS.007"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_096
                                objectName: "Yükseklik-Ekstrüzyon1.096"
                                source: "meshes/mesh_0_012_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_ORTA_P_STON_007
                            objectName: "60''LIK POYRAZ_DAYAMA_ORTA PÝSTON.007"
                            Model {
                                id: m10_Di_li_Delik1_014
                                objectName: "M10 Diþli Delik1.014"
                                source: "meshes/mesh_7_012_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_POP_BUR__007
                            objectName: "60''LIK POYRAZ_DAYAMA_POP BURÇ.007"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_098
                                objectName: "Yükseklik-Ekstrüzyon1.098"
                                source: "meshes/mesh_5_012_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_P_STON_M_L__007
                            objectName: "60''LIK POYRAZ_DAYAMA_PÝSTON MÝLÝ.007"
                            Model {
                                id: pah1_018
                                objectName: "Pah1.018"
                                source: "meshes/mesh_13_012_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_S_L_ND_R_P_STONU_007
                            objectName: "60''LIK POYRAZ_DAYAMA_SÝLÝNDÝR PÝSTONU.007"
                            Model {
                                id: m10_Di_li_Delik1_015
                                objectName: "M10 Diþli Delik1.015"
                                source: "meshes/mesh_11_012_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_YATAKLAMA_BANDI_007
                            objectName: "60''LIK POYRAZ_DAYAMA_YATAKLAMA BANDI.007"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_099
                                objectName: "Yükseklik-Ekstrüzyon1.099"
                                source: "meshes/mesh_10_012_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA_20_MM_EK_029
                            objectName: "POYRAZ_DAYAMA_20 MM EK.029"
                            Model {
                                id: d_nd_r1_007
                                objectName: "Döndür1.007"
                                source: "meshes/mesh_2_012_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA_ALT_FLAN__032
                            objectName: "POYRAZ_DAYAMA_ALT FLANÞ.032"
                            Model {
                                id: _2_5__2_5___ap_Delik2_007
                                objectName: "Ø2.5 (2.5) Çap Delik2.007"
                                source: "meshes/mesh_1_011_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA_SAB_TLEME_AYAK_013
                            objectName: "POYRAZ_DAYAMA_SABÝTLEME AYAK.013"
                            Model {
                                id: kes_Ekstr_zyon4_012
                                objectName: "Kes-Ekstrüzyon4.012"
                                source: "meshes/mesh_3_015_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA__ST_FLAN__032
                            objectName: "POYRAZ_DAYAMA_ÜST FLANÞ.032"
                            Model {
                                id: pah1_019
                                objectName: "Pah1.019"
                                source: "meshes/mesh_14_012_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                    }
                    Node {
                        id: v_GOR_FT_BARALI_DAYAMA_DESTEK_SACI_006
                        objectName: "VÝGOR FT_BARALI_DAYAMA DESTEK SACI.006"
                        Model {
                            id: _8_5__8_5___ap_Delik1_010
                            objectName: "Ø8.5 (8.5) Çap Delik1.010"
                            source: "meshes/mesh_394_009_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: v_GOR_FT_BARALI_36_2_DAYAMA_MONTAJLI_007
                    objectName: "VÝGOR FT_BARALI 36_2_DAYAMA_MONTAJLI.007"
                    Node {
                        id: node60__LIK_POYRAZ_DAYAMA_MONTAJLI_008
                        objectName: "60''LIK POYRAZ_DAYAMA_MONTAJLI.008"
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_ALM_G_VDE_008
                            objectName: "60''LIK POYRAZ_DAYAMA_ALM GÖVDE.008"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_101
                                objectName: "Yükseklik-Ekstrüzyon1.101"
                                source: "meshes/mesh_4_013_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_Kastas_Seals_KO_36X2_008
                            objectName: "60''LIK POYRAZ_DAYAMA_Kastas Seals-KO-36X2.008"
                            Model {
                                id: al_nm__1_061
                                objectName: "Alýnmýþ1.061"
                                source: "meshes/mesh_8_013_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_KASTAS_K52_20X25X4_5_2_008
                            objectName: "60''LIK POYRAZ_DAYAMA_KASTAS-K52-20X25X4-5_2.008"
                            Model {
                                id: al_nm__1_063
                                objectName: "Alýnmýþ1.063"
                                source: "meshes/mesh_12_013_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_KASTAS_K62_32X40X3_2_008
                            objectName: "60''LIK POYRAZ_DAYAMA_KASTAS-K62-32X40X3_2.008"
                            Model {
                                id: al_nm__1_062
                                objectName: "Alýnmýþ1.062"
                                source: "meshes/mesh_9_013_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_MIGNATIS_008
                            objectName: "60''LIK POYRAZ_DAYAMA_MIGNATIS.008"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_100
                                objectName: "Yükseklik-Ekstrüzyon1.100"
                                source: "meshes/mesh_0_013_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_ORTA_P_STON_008
                            objectName: "60''LIK POYRAZ_DAYAMA_ORTA PÝSTON.008"
                            Model {
                                id: m10_Di_li_Delik1_016
                                objectName: "M10 Diþli Delik1.016"
                                source: "meshes/mesh_7_013_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_POP_BUR__008
                            objectName: "60''LIK POYRAZ_DAYAMA_POP BURÇ.008"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_102
                                objectName: "Yükseklik-Ekstrüzyon1.102"
                                source: "meshes/mesh_5_013_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_P_STON_M_L__008
                            objectName: "60''LIK POYRAZ_DAYAMA_PÝSTON MÝLÝ.008"
                            Model {
                                id: pah1_020
                                objectName: "Pah1.020"
                                source: "meshes/mesh_13_013_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_S_L_ND_R_P_STONU_008
                            objectName: "60''LIK POYRAZ_DAYAMA_SÝLÝNDÝR PÝSTONU.008"
                            Model {
                                id: m10_Di_li_Delik1_017
                                objectName: "M10 Diþli Delik1.017"
                                source: "meshes/mesh_11_013_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_YATAKLAMA_BANDI_008
                            objectName: "60''LIK POYRAZ_DAYAMA_YATAKLAMA BANDI.008"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_103
                                objectName: "Yükseklik-Ekstrüzyon1.103"
                                source: "meshes/mesh_10_013_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA_20_MM_EK_030
                            objectName: "POYRAZ_DAYAMA_20 MM EK.030"
                            Model {
                                id: d_nd_r1_008
                                objectName: "Döndür1.008"
                                source: "meshes/mesh_2_013_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA_ALT_FLAN__033
                            objectName: "POYRAZ_DAYAMA_ALT FLANÞ.033"
                            Model {
                                id: _2_5__2_5___ap_Delik2_008
                                objectName: "Ø2.5 (2.5) Çap Delik2.008"
                                source: "meshes/mesh_1_012_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA_SAB_TLEME_AYAK_015
                            objectName: "POYRAZ_DAYAMA_SABÝTLEME AYAK.015"
                            Model {
                                id: kes_Ekstr_zyon4_013
                                objectName: "Kes-Ekstrüzyon4.013"
                                source: "meshes/mesh_3_016_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA_SAB_TLEME_AYAK_KISA_025
                            objectName: "POYRAZ_DAYAMA_SABÝTLEME AYAK_KISA.025"
                            Model {
                                id: kes_Ekstr_zyon3_018
                                objectName: "Kes-Ekstrüzyon3.018"
                                source: "meshes/mesh_6_013_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA__ST_FLAN__033
                            objectName: "POYRAZ_DAYAMA_ÜST FLANÞ.033"
                            Model {
                                id: pah1_021
                                objectName: "Pah1.021"
                                source: "meshes/mesh_14_013_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                    }
                    Node {
                        id: v_GOR_FT_BARALI_DAYAMA_DESTEK_SACI_007
                        objectName: "VÝGOR FT_BARALI_DAYAMA DESTEK SACI.007"
                        Model {
                            id: _8_5__8_5___ap_Delik1_011
                            objectName: "Ø8.5 (8.5) Çap Delik1.011"
                            source: "meshes/mesh_394_002_mesh.mesh"
                            materials: [
                                paint__185__188__191__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: v_GOR_FT_BARALI_36_2_SOL_DAYAMA_001
                    objectName: "VÝGOR FT_BARALI 36_2_SOL_DAYAMA.001"
                    Model {
                        id: kes_Ekstr_zyon3_019
                        objectName: "Kes-Ekstrüzyon3.019"
                        source: "meshes/mesh_396_002_mesh.mesh"
                        materials: [
                            paint__175__178__181__255__material
                        ]
                    }
                }
            }
        }
        Node {
            id: barali1
            objectName: "BARALI1"
            position: Qt.vector3d(0, 0.704551, 0)
            Node {
                id: v_GOR_FT__BARALI_36_2_SA__DAYAMA_S_STEM_
                objectName: "VÝGOR FT _BARALI 36_2_SAÐ_DAYAMA SÝSTEMÝ"
                Node {
                    id: v_GOR_FT_BARALI_36_2_DAYAMA_MONTAJLI
                    objectName: "VÝGOR FT_BARALI 36_2_DAYAMA_MONTAJLI"
                    Node {
                        id: node60__LIK_POYRAZ_DAYAMA_MONTAJLI_001
                        objectName: "60''LIK POYRAZ_DAYAMA_MONTAJLI.001"
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_ALM_G_VDE_001
                            objectName: "60''LIK POYRAZ_DAYAMA_ALM GÖVDE.001"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_072
                                objectName: "Yükseklik-Ekstrüzyon1.072"
                                source: "meshes/mesh_4_006_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_Kastas_Seals_KO_36X2_001
                            objectName: "60''LIK POYRAZ_DAYAMA_Kastas Seals-KO-36X2.001"
                            Model {
                                id: al_nm__1_040
                                objectName: "Alýnmýþ1.040"
                                source: "meshes/mesh_8_006_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_KASTAS_K52_20X25X4_5_2_001
                            objectName: "60''LIK POYRAZ_DAYAMA_KASTAS-K52-20X25X4-5_2.001"
                            Model {
                                id: al_nm__1_042
                                objectName: "Alýnmýþ1.042"
                                source: "meshes/mesh_12_006_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_KASTAS_K62_32X40X3_2_001
                            objectName: "60''LIK POYRAZ_DAYAMA_KASTAS-K62-32X40X3_2.001"
                            Model {
                                id: al_nm__1_041
                                objectName: "Alýnmýþ1.041"
                                source: "meshes/mesh_9_006_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_MIGNATIS_001
                            objectName: "60''LIK POYRAZ_DAYAMA_MIGNATIS.001"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_071
                                objectName: "Yükseklik-Ekstrüzyon1.071"
                                source: "meshes/mesh_0_006_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_ORTA_P_STON_001
                            objectName: "60''LIK POYRAZ_DAYAMA_ORTA PÝSTON.001"
                            Model {
                                id: m10_Di_li_Delik1_002
                                objectName: "M10 Diþli Delik1.002"
                                source: "meshes/mesh_7_006_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_POP_BUR__001
                            objectName: "60''LIK POYRAZ_DAYAMA_POP BURÇ.001"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_073
                                objectName: "Yükseklik-Ekstrüzyon1.073"
                                source: "meshes/mesh_5_006_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_P_STON_M_L__001
                            objectName: "60''LIK POYRAZ_DAYAMA_PÝSTON MÝLÝ.001"
                            Model {
                                id: pah1_006
                                objectName: "Pah1.006"
                                source: "meshes/mesh_13_006_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_S_L_ND_R_P_STONU_001
                            objectName: "60''LIK POYRAZ_DAYAMA_SÝLÝNDÝR PÝSTONU.001"
                            Model {
                                id: m10_Di_li_Delik1_003
                                objectName: "M10 Diþli Delik1.003"
                                source: "meshes/mesh_11_006_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_YATAKLAMA_BANDI_001
                            objectName: "60''LIK POYRAZ_DAYAMA_YATAKLAMA BANDI.001"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_074
                                objectName: "Yükseklik-Ekstrüzyon1.074"
                                source: "meshes/mesh_10_006_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA_20_MM_EK_023
                            objectName: "POYRAZ_DAYAMA_20 MM EK.023"
                            Model {
                                id: d_nd_r1_001
                                objectName: "Döndür1.001"
                                source: "meshes/mesh_2_006_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA_ALT_FLAN__026
                            objectName: "POYRAZ_DAYAMA_ALT FLANÞ.026"
                            Model {
                                id: _2_5__2_5___ap_Delik2_001
                                objectName: "Ø2.5 (2.5) Çap Delik2.001"
                                source: "meshes/mesh_1_005_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA_SAB_TLEME_AYAK_001
                            objectName: "POYRAZ_DAYAMA_SABÝTLEME AYAK.001"
                            Model {
                                id: kes_Ekstr_zyon4_002
                                objectName: "Kes-Ekstrüzyon4.002"
                                source: "meshes/mesh_3_005_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA__ST_FLAN__026
                            objectName: "POYRAZ_DAYAMA_ÜST FLANÞ.026"
                            Model {
                                id: pah1_007
                                objectName: "Pah1.007"
                                source: "meshes/mesh_14_006_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                    }
                    Node {
                        id: poyraz_DAYAMA_SAB_TLEME_AYAK_002
                        objectName: "POYRAZ_DAYAMA_SABÝTLEME AYAK.002"
                        Model {
                            id: kes_Ekstr_zyon4_003
                            objectName: "Kes-Ekstrüzyon4.003"
                            source: "meshes/mesh_3_006_mesh.mesh"
                            materials: [
                                paint__185__188__191__255__material
                            ]
                        }
                    }
                    Node {
                        id: v_GOR_FT_BARALI_DAYAMA_DESTEK_SACI
                        objectName: "VÝGOR FT_BARALI_DAYAMA DESTEK SACI"
                        Model {
                            id: _8_5__8_5___ap_Delik1_004
                            objectName: "Ø8.5 (8.5) Çap Delik1.004"
                            source: "meshes/mesh_394_003_mesh.mesh"
                            materials: [
                                paint__185__188__191__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: v_GOR_FT_BARALI_36_2_DAYAMA_MONTAJLI_001
                    objectName: "VÝGOR FT_BARALI 36_2_DAYAMA_MONTAJLI.001"
                    Node {
                        id: node60__LIK_POYRAZ_DAYAMA_MONTAJLI_002
                        objectName: "60''LIK POYRAZ_DAYAMA_MONTAJLI.002"
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_ALM_G_VDE_002
                            objectName: "60''LIK POYRAZ_DAYAMA_ALM GÖVDE.002"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_076
                                objectName: "Yükseklik-Ekstrüzyon1.076"
                                source: "meshes/mesh_4_007_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_Kastas_Seals_KO_36X2_002
                            objectName: "60''LIK POYRAZ_DAYAMA_Kastas Seals-KO-36X2.002"
                            Model {
                                id: al_nm__1_043
                                objectName: "Alýnmýþ1.043"
                                source: "meshes/mesh_8_007_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_KASTAS_K52_20X25X4_5_2_002
                            objectName: "60''LIK POYRAZ_DAYAMA_KASTAS-K52-20X25X4-5_2.002"
                            Model {
                                id: al_nm__1_045
                                objectName: "Alýnmýþ1.045"
                                source: "meshes/mesh_12_007_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_KASTAS_K62_32X40X3_2_002
                            objectName: "60''LIK POYRAZ_DAYAMA_KASTAS-K62-32X40X3_2.002"
                            Model {
                                id: al_nm__1_044
                                objectName: "Alýnmýþ1.044"
                                source: "meshes/mesh_9_007_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_MIGNATIS_002
                            objectName: "60''LIK POYRAZ_DAYAMA_MIGNATIS.002"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_075
                                objectName: "Yükseklik-Ekstrüzyon1.075"
                                source: "meshes/mesh_0_007_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_ORTA_P_STON_002
                            objectName: "60''LIK POYRAZ_DAYAMA_ORTA PÝSTON.002"
                            Model {
                                id: m10_Di_li_Delik1_004
                                objectName: "M10 Diþli Delik1.004"
                                source: "meshes/mesh_7_007_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_POP_BUR__002
                            objectName: "60''LIK POYRAZ_DAYAMA_POP BURÇ.002"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_077
                                objectName: "Yükseklik-Ekstrüzyon1.077"
                                source: "meshes/mesh_5_007_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_P_STON_M_L__002
                            objectName: "60''LIK POYRAZ_DAYAMA_PÝSTON MÝLÝ.002"
                            Model {
                                id: pah1_008
                                objectName: "Pah1.008"
                                source: "meshes/mesh_13_007_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_S_L_ND_R_P_STONU_002
                            objectName: "60''LIK POYRAZ_DAYAMA_SÝLÝNDÝR PÝSTONU.002"
                            Model {
                                id: m10_Di_li_Delik1_005
                                objectName: "M10 Diþli Delik1.005"
                                source: "meshes/mesh_11_007_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_YATAKLAMA_BANDI_002
                            objectName: "60''LIK POYRAZ_DAYAMA_YATAKLAMA BANDI.002"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_078
                                objectName: "Yükseklik-Ekstrüzyon1.078"
                                source: "meshes/mesh_10_007_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA_20_MM_EK_024
                            objectName: "POYRAZ_DAYAMA_20 MM EK.024"
                            Model {
                                id: d_nd_r1_002
                                objectName: "Döndür1.002"
                                source: "meshes/mesh_2_007_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA_ALT_FLAN__027
                            objectName: "POYRAZ_DAYAMA_ALT FLANÞ.027"
                            Model {
                                id: _2_5__2_5___ap_Delik2_002
                                objectName: "Ø2.5 (2.5) Çap Delik2.002"
                                source: "meshes/mesh_1_006_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA_SAB_TLEME_AYAK_003
                            objectName: "POYRAZ_DAYAMA_SABÝTLEME AYAK.003"
                            Model {
                                id: kes_Ekstr_zyon4_004
                                objectName: "Kes-Ekstrüzyon4.004"
                                source: "meshes/mesh_3_007_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA__ST_FLAN__027
                            objectName: "POYRAZ_DAYAMA_ÜST FLANÞ.027"
                            Model {
                                id: pah1_009
                                objectName: "Pah1.009"
                                source: "meshes/mesh_14_007_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                    }
                    Node {
                        id: poyraz_DAYAMA_SAB_TLEME_AYAK_004
                        objectName: "POYRAZ_DAYAMA_SABÝTLEME AYAK.004"
                        Model {
                            id: kes_Ekstr_zyon4_005
                            objectName: "Kes-Ekstrüzyon4.005"
                            source: "meshes/mesh_3_008_mesh.mesh"
                            materials: [
                                paint__185__188__191__255__material
                            ]
                        }
                    }
                    Node {
                        id: v_GOR_FT_BARALI_DAYAMA_DESTEK_SACI_001
                        objectName: "VÝGOR FT_BARALI_DAYAMA DESTEK SACI.001"
                        Model {
                            id: _8_5__8_5___ap_Delik1_005
                            objectName: "Ø8.5 (8.5) Çap Delik1.005"
                            source: "meshes/mesh_394_004_mesh.mesh"
                            materials: [
                                paint__185__188__191__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: v_GOR_FT_BARALI_36_2_SA__DAYAMA
                    objectName: "VÝGOR FT_BARALI 36_2_SAÐ_DAYAMA"
                    Model {
                        id: kes_Ekstr_zyon3_008
                        objectName: "Kes-Ekstrüzyon3.008"
                        source: "meshes/mesh_393_003_mesh.mesh"
                        materials: [
                            paint__175__178__181__255__material
                        ]
                    }
                }
            }
            Node {
                id: v_GOR_FT_BARALI_36_2_ORTA_DAYAMA
                objectName: "VÝGOR FT BARALI 36_2_ORTA_DAYAMA"
                Model {
                    id: radyus1_034
                    objectName: "Radyus1.034"
                    source: "meshes/mesh_395_003_mesh.mesh"
                    materials: [
                        paint__175__178__181__255__material
                    ]
                }
            }
            Node {
                id: v_GOR_FT_BARALI_36_2_SOL_DAYAMA_S_STEM_
                objectName: "VÝGOR FT_BARALI 36_2_SOL_DAYAMA SÝSTEMÝ"
                Node {
                    id: v_GOR_FT_BARALI_36_2_DAYAMA_MONTAJLI_002
                    objectName: "VÝGOR FT_BARALI 36_2_DAYAMA_MONTAJLI.002"
                    Node {
                        id: node60__LIK_POYRAZ_DAYAMA_MONTAJLI_003
                        objectName: "60''LIK POYRAZ_DAYAMA_MONTAJLI.003"
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_ALM_G_VDE_003
                            objectName: "60''LIK POYRAZ_DAYAMA_ALM GÖVDE.003"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_080
                                objectName: "Yükseklik-Ekstrüzyon1.080"
                                source: "meshes/mesh_4_008_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_Kastas_Seals_KO_36X2_003
                            objectName: "60''LIK POYRAZ_DAYAMA_Kastas Seals-KO-36X2.003"
                            Model {
                                id: al_nm__1_046
                                objectName: "Alýnmýþ1.046"
                                source: "meshes/mesh_8_008_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_KASTAS_K52_20X25X4_5_2_003
                            objectName: "60''LIK POYRAZ_DAYAMA_KASTAS-K52-20X25X4-5_2.003"
                            Model {
                                id: al_nm__1_048
                                objectName: "Alýnmýþ1.048"
                                source: "meshes/mesh_12_008_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_KASTAS_K62_32X40X3_2_003
                            objectName: "60''LIK POYRAZ_DAYAMA_KASTAS-K62-32X40X3_2.003"
                            Model {
                                id: al_nm__1_047
                                objectName: "Alýnmýþ1.047"
                                source: "meshes/mesh_9_008_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_MIGNATIS_003
                            objectName: "60''LIK POYRAZ_DAYAMA_MIGNATIS.003"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_079
                                objectName: "Yükseklik-Ekstrüzyon1.079"
                                source: "meshes/mesh_0_008_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_ORTA_P_STON_003
                            objectName: "60''LIK POYRAZ_DAYAMA_ORTA PÝSTON.003"
                            Model {
                                id: m10_Di_li_Delik1_006
                                objectName: "M10 Diþli Delik1.006"
                                source: "meshes/mesh_7_008_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_POP_BUR__003
                            objectName: "60''LIK POYRAZ_DAYAMA_POP BURÇ.003"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_081
                                objectName: "Yükseklik-Ekstrüzyon1.081"
                                source: "meshes/mesh_5_008_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_P_STON_M_L__003
                            objectName: "60''LIK POYRAZ_DAYAMA_PÝSTON MÝLÝ.003"
                            Model {
                                id: pah1_010
                                objectName: "Pah1.010"
                                source: "meshes/mesh_13_008_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_S_L_ND_R_P_STONU_003
                            objectName: "60''LIK POYRAZ_DAYAMA_SÝLÝNDÝR PÝSTONU.003"
                            Model {
                                id: m10_Di_li_Delik1_007
                                objectName: "M10 Diþli Delik1.007"
                                source: "meshes/mesh_11_008_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_YATAKLAMA_BANDI_003
                            objectName: "60''LIK POYRAZ_DAYAMA_YATAKLAMA BANDI.003"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_082
                                objectName: "Yükseklik-Ekstrüzyon1.082"
                                source: "meshes/mesh_10_008_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA_20_MM_EK_025
                            objectName: "POYRAZ_DAYAMA_20 MM EK.025"
                            Model {
                                id: d_nd_r1_003
                                objectName: "Döndür1.003"
                                source: "meshes/mesh_2_008_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA_ALT_FLAN__028
                            objectName: "POYRAZ_DAYAMA_ALT FLANÞ.028"
                            Model {
                                id: _2_5__2_5___ap_Delik2_003
                                objectName: "Ø2.5 (2.5) Çap Delik2.003"
                                source: "meshes/mesh_1_007_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA__ST_FLAN__028
                            objectName: "POYRAZ_DAYAMA_ÜST FLANÞ.028"
                            Model {
                                id: pah1_011
                                objectName: "Pah1.011"
                                source: "meshes/mesh_14_008_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                    }
                    Node {
                        id: poyraz_DAYAMA_SAB_TLEME_AYAK_006
                        objectName: "POYRAZ_DAYAMA_SABÝTLEME AYAK.006"
                        Model {
                            id: kes_Ekstr_zyon4_007
                            objectName: "Kes-Ekstrüzyon4.007"
                            source: "meshes/mesh_3_010_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: v_GOR_FT_BARALI_DAYAMA_DESTEK_SACI_002
                        objectName: "VÝGOR FT_BARALI_DAYAMA DESTEK SACI.002"
                        Model {
                            id: _8_5__8_5___ap_Delik1_006
                            objectName: "Ø8.5 (8.5) Çap Delik1.006"
                            source: "meshes/mesh_394_005_mesh.mesh"
                            materials: [
                                paint__185__188__191__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: v_GOR_FT_BARALI_36_2_DAYAMA_MONTAJLI_003
                    objectName: "VÝGOR FT_BARALI 36_2_DAYAMA_MONTAJLI.003"
                    Node {
                        id: node60__LIK_POYRAZ_DAYAMA_MONTAJLI_004
                        objectName: "60''LIK POYRAZ_DAYAMA_MONTAJLI.004"
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_ALM_G_VDE_004
                            objectName: "60''LIK POYRAZ_DAYAMA_ALM GÖVDE.004"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_084
                                objectName: "Yükseklik-Ekstrüzyon1.084"
                                source: "meshes/mesh_4_009_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_Kastas_Seals_KO_36X2_004
                            objectName: "60''LIK POYRAZ_DAYAMA_Kastas Seals-KO-36X2.004"
                            Model {
                                id: al_nm__1_049
                                objectName: "Alýnmýþ1.049"
                                source: "meshes/mesh_8_009_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_KASTAS_K52_20X25X4_5_2_004
                            objectName: "60''LIK POYRAZ_DAYAMA_KASTAS-K52-20X25X4-5_2.004"
                            Model {
                                id: al_nm__1_051
                                objectName: "Alýnmýþ1.051"
                                source: "meshes/mesh_12_009_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_KASTAS_K62_32X40X3_2_004
                            objectName: "60''LIK POYRAZ_DAYAMA_KASTAS-K62-32X40X3_2.004"
                            Model {
                                id: al_nm__1_050
                                objectName: "Alýnmýþ1.050"
                                source: "meshes/mesh_9_009_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_MIGNATIS_004
                            objectName: "60''LIK POYRAZ_DAYAMA_MIGNATIS.004"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_083
                                objectName: "Yükseklik-Ekstrüzyon1.083"
                                source: "meshes/mesh_0_009_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_ORTA_P_STON_004
                            objectName: "60''LIK POYRAZ_DAYAMA_ORTA PÝSTON.004"
                            Model {
                                id: m10_Di_li_Delik1_008
                                objectName: "M10 Diþli Delik1.008"
                                source: "meshes/mesh_7_009_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_POP_BUR__004
                            objectName: "60''LIK POYRAZ_DAYAMA_POP BURÇ.004"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_085
                                objectName: "Yükseklik-Ekstrüzyon1.085"
                                source: "meshes/mesh_5_009_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_P_STON_M_L__004
                            objectName: "60''LIK POYRAZ_DAYAMA_PÝSTON MÝLÝ.004"
                            Model {
                                id: pah1_012
                                objectName: "Pah1.012"
                                source: "meshes/mesh_13_009_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_S_L_ND_R_P_STONU_004
                            objectName: "60''LIK POYRAZ_DAYAMA_SÝLÝNDÝR PÝSTONU.004"
                            Model {
                                id: m10_Di_li_Delik1_009
                                objectName: "M10 Diþli Delik1.009"
                                source: "meshes/mesh_11_009_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node60__LIK_POYRAZ_DAYAMA_YATAKLAMA_BANDI_004
                            objectName: "60''LIK POYRAZ_DAYAMA_YATAKLAMA BANDI.004"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_086
                                objectName: "Yükseklik-Ekstrüzyon1.086"
                                source: "meshes/mesh_10_009_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA_20_MM_EK_026
                            objectName: "POYRAZ_DAYAMA_20 MM EK.026"
                            Model {
                                id: d_nd_r1_004
                                objectName: "Döndür1.004"
                                source: "meshes/mesh_2_009_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA_ALT_FLAN__029
                            objectName: "POYRAZ_DAYAMA_ALT FLANÞ.029"
                            Model {
                                id: _2_5__2_5___ap_Delik2_004
                                objectName: "Ø2.5 (2.5) Çap Delik2.004"
                                source: "meshes/mesh_1_008_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA_SAB_TLEME_AYAK_007
                            objectName: "POYRAZ_DAYAMA_SABÝTLEME AYAK.007"
                            Model {
                                id: kes_Ekstr_zyon4_008
                                objectName: "Kes-Ekstrüzyon4.008"
                                source: "meshes/mesh_3_011_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                        Node {
                            id: poyraz_DAYAMA__ST_FLAN__029
                            objectName: "POYRAZ_DAYAMA_ÜST FLANÞ.029"
                            Model {
                                id: pah1_013
                                objectName: "Pah1.013"
                                source: "meshes/mesh_14_009_mesh.mesh"
                                materials: [
                                    paint__175__178__181__255__material
                                ]
                            }
                        }
                    }
                    Node {
                        id: poyraz_DAYAMA_SAB_TLEME_AYAK_008
                        objectName: "POYRAZ_DAYAMA_SABÝTLEME AYAK.008"
                        Model {
                            id: kes_Ekstr_zyon4_009
                            objectName: "Kes-Ekstrüzyon4.009"
                            source: "meshes/mesh_3_012_mesh.mesh"
                            materials: [
                                paint__185__188__191__255__material
                            ]
                        }
                    }
                    Node {
                        id: v_GOR_FT_BARALI_DAYAMA_DESTEK_SACI_003
                        objectName: "VÝGOR FT_BARALI_DAYAMA DESTEK SACI.003"
                        Model {
                            id: _8_5__8_5___ap_Delik1_007
                            objectName: "Ø8.5 (8.5) Çap Delik1.007"
                            source: "meshes/mesh_394_006_mesh.mesh"
                            materials: [
                                paint__185__188__191__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: v_GOR_FT_BARALI_36_2_SOL_DAYAMA
                    objectName: "VÝGOR FT_BARALI 36_2_SOL_DAYAMA"
                    Model {
                        id: kes_Ekstr_zyon3_013
                        objectName: "Kes-Ekstrüzyon3.013"
                        source: "meshes/mesh_396_003_mesh.mesh"
                        materials: [
                            paint__175__178__181__255__material
                        ]
                    }
                }
            }
        }

        Node {
            id: supurmebosaltma_001
            objectName: "SUPURMEBOSALTMA.001"
            position: Qt.vector3d(0, 0.704551, 0)
            x: node.axisX
            Node {
                id: node2100_BO_ALTMA_KA_ARA_DAVLUMBAZ_MONTAJI
                objectName: "2100_BOÞALTMA_KA_ARA DAVLUMBAZ_MONTAJI"
                Node {
                    id: node2100_BO_ALTMA_KA_ARA_DAVLUMBAZ_ALT_SAC
                    objectName: "2100_BOÞALTMA_KA_ARA DAVLUMBAZ_ALT SAC"
                    Model {
                        id: _8_0__8___ap_Delik1_002
                        objectName: "Ø8.0 (8) Çap Delik1.002"
                        source: "meshes/mesh_34_003_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_ARA_DAVLUMBAZ_Q12_M_L
                    objectName: "2100_BOÞALTMA_KA_ARA DAVLUMBAZ_Q12 MÝL"
                    Model {
                        id: kes_Ekstr_zyon1_258
                        objectName: "Kes-Ekstrüzyon1.258"
                        source: "meshes/mesh_36_003_mesh.mesh"
                        materials: [
                            paint__185__188__191__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_ARA_DAVLUMBAZ__ST_SAC
                    objectName: "2100_BOÞALTMA_KA_ARA DAVLUMBAZ_ÜST SAC"
                    Model {
                        id: _12_5__12_5___ap_Delik1
                        objectName: "Ø12.5 (12.5) Çap Delik1"
                        source: "meshes/mesh_37_003_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_DAVLUMBAZ_Q_95_BORU_002
                    objectName: "2100_BOÞALTMA_KA_DAVLUMBAZ_Q 95 BORU.002"
                    Model {
                        id: y_kseklik_Ekstr_zyon1_395
                        objectName: "Yükseklik-Ekstrüzyon1.395"
                        source: "meshes/mesh_30_007_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_DAVLUMBAZ_Q_95_BORU_003
                    objectName: "2100_BOÞALTMA_KA_DAVLUMBAZ_Q 95 BORU.003"
                    Model {
                        id: y_kseklik_Ekstr_zyon1_396
                        objectName: "Yükseklik-Ekstrüzyon1.396"
                        source: "meshes/mesh_30_003_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: ara_DAVLUMBAZ_Q140_LIK_KLEPE
                    objectName: "ARA DAVLUMBAZ_Q140 LIK KLEPE"
                    Model {
                        id: taban_Flan_1_186
                        objectName: "Taban-Flanþ1.186"
                        source: "meshes/mesh_38_003_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: ara_DAVLUMBAZ_Q145_BORU
                    objectName: "ARA DAVLUMBAZ_Q145 BORU"
                    Model {
                        id: boss_Extrude1_124
                        objectName: "Boss-Extrude1.124"
                        source: "meshes/mesh_35_003_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: toz_EM___ORTAK_MALZ__P_STON_APARATI_005
                    objectName: "TOZ EMÝÞ_ORTAK MALZ._PÝSTON APARATI.005"
                    Model {
                        id: fillet2_006
                        objectName: "Fillet2.006"
                        source: "meshes/mesh_33_003_mesh.mesh"
                        materials: [
                            paint__185__188__191__255__material
                        ]
                    }
                }
            }
            Node {
                id: node2100_BO_ALTMA_KA_ARKA_P_STON_SACI_KAYNAK
                objectName: "2100_BOÞALTMA_KA_ARKA PÝSTON SACI KAYNAK"
                Node {
                    id: node2100_BO_ALTMA_KA_D_KME_SA__4_001
                    objectName: "2100_BOÞALTMA_KA_DÝKME SAÇ 4.001"
                    Model {
                        id: radyus1_191
                        objectName: "Radyus1.191"
                        source: "meshes/mesh_13_004_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_YATAY_SAC_001
                    objectName: "2100_BOÞALTMA_KA_YATAY SAC.001"
                    Model {
                        id: radyus1_192
                        objectName: "Radyus1.192"
                        source: "meshes/mesh_12_004_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
            }
            Node {
                id: node2100_BO_ALTMA_KA_ARKA_YATAK_KAYNAK
                objectName: "2100_BOÞALTMA_KA_ARKA YATAK_KAYNAK"
                Node {
                    id: node2100_BO_ALTMA_KA_ALT_FLAN_I
                    objectName: "2100_BOÞALTMA_KA_ALT FLANÞI"
                    Model {
                        id: kes_Ekstr_zyon1_250
                        objectName: "Kes-Ekstrüzyon1.250"
                        source: "meshes/mesh_6_014_mesh.mesh"
                        materials: [
                            paint__185__188__191__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_ARKA_YATAK_D_KME_SA__2
                    objectName: "2100_BOÞALTMA_KA_ARKA YATAK_DÝKME SAÇ 2"
                    Model {
                        id: kes_Ekstr_zyon2_088
                        objectName: "Kes-Ekstrüzyon2.088"
                        source: "meshes/mesh_10_004_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_D_KME_SA__1
                    objectName: "2100_BOÞALTMA_KA_DÝKME SAÇ 1"
                    Model {
                        id: kes_Ekstr_zyon1_251
                        objectName: "Kes-Ekstrüzyon1.251"
                        source: "meshes/mesh_8_014_mesh.mesh"
                        materials: [
                            paint__185__188__191__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_D_KME_SA__3
                    objectName: "2100_BOÞALTMA_KA_DÝKME SAÇ 3"
                    Model {
                        id: _5_0__5___ap_Delik1_015
                        objectName: "Ø5.0 (5) Çap Delik1.015"
                        source: "meshes/mesh_7_014_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_FEDER
                    objectName: "2100_BOÞALTMA_KA_FEDER"
                    Model {
                        id: taban_Flan_1_171
                        objectName: "Taban-Flanþ1.171"
                        source: "meshes/mesh_11_014_mesh.mesh"
                        materials: [
                            paint__185__188__191__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA__ST_FLAN_
                    objectName: "2100_BOÞALTMA_KA_ÜST FLANÞ"
                    Model {
                        id: dairesel_Kaplama1_006
                        objectName: "Dairesel Kaplama1.006"
                        source: "meshes/mesh_9_014_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
            }
            Node {
                id: node2100_BO_ALTMA_KA_ARKA_YATAK_P_STONU_MONTAJLI
                objectName: "2100_BOÞALTMA_KA_ARKA YATAK_PÝSTONU MONTAJLI"
                Node {
                    id: node2100_BO_ALTMA_KA_ARKA_YATAK_139x_40_0200_01_001
                    objectName: "2100_BOÞALTMA_KA_ARKA YATAK_139x_40_0200_01.001"
                    Node {
                        id: node2100_BO_ALTMA_KA_ARKA_YATAK_1320_40_18F_1_001
                        objectName: "2100_BOÞALTMA_KA_ARKA YATAK_1320_40_18F_1.001"
                        Model {
                            id: imported1_177
                            objectName: "Imported1.177"
                            source: "meshes/mesh_20_004_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BO_ALTMA_KA_ARKA_YATAK_CPL040_001_01_1_001
                        objectName: "2100_BOÞALTMA_KA_ARKA YATAK_CPL040-001-01_1.001"
                        Model {
                            id: imported1_180
                            objectName: "Imported1.180"
                            source: "meshes/mesh_23_004_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BO_ALTMA_KA_ARKA_YATAK_CPL040_002_01_1_001
                        objectName: "2100_BOÞALTMA_KA_ARKA YATAK_CPL040-002-01_1.001"
                        Model {
                            id: imported1_179
                            objectName: "Imported1.179"
                            source: "meshes/mesh_22_004_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BO_ALTMA_KA_ARKA_YATAK_CPL040_004_200_001
                        objectName: "2100_BOÞALTMA_KA_ARKA YATAK_CPL040_004-200.001"
                        Model {
                            id: imported1_178
                            objectName: "Imported1.178"
                            source: "meshes/mesh_21_004_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BO_ALTMA_KA_ARKA_YATAK_CPL_40_0200_001
                        objectName: "2100_BOÞALTMA_KA_ARKA YATAK_CPL_40_0200.001"
                        Model {
                            id: imported1_176
                            objectName: "Imported1.176"
                            source: "meshes/mesh_19_004_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_ARKA_YATAK_30_LUK_M_L
                    objectName: "2100_BOÞALTMA_KA_ARKA YATAK_30 LUK MÝL"
                    Model {
                        id: pah1_156
                        objectName: "Pah1.156"
                        source: "meshes/mesh_27_003_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_ARKA_YATAK_LMEK_30_RULMANI
                    objectName: "2100_BOÞALTMA_KA_ARKA YATAK_LMEK 30 RULMANI"
                    Model {
                        id: y_kseklik_Ekstr_zyon2_019
                        objectName: "Yükseklik-Ekstrüzyon2.019"
                        source: "meshes/mesh_26_003_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_ARKA_YATAK_Q_30_L_AYAK_MONTAJLI
                    objectName: "2100_BOÞALTMA_KA_ARKA YATAK_Q 30 L AYAK_MONTAJLI"
                    Node {
                        id: node2100_BO_ALTMA_KA_Q_30_L_AYAK_2_001
                        objectName: "2100_BOÞALTMA_KA_Q 30 L AYAK 2.001"
                        Model {
                            id: kes_Ekstr_zyon1_257
                            objectName: "Kes-Ekstrüzyon1.257"
                            source: "meshes/mesh_16_004_mesh.mesh"
                            materials: [
                                paint__0__0__0__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BO_ALTMA_KA_Q_30_L_AYAK_001
                        objectName: "2100_BOÞALTMA_KA_Q 30 L AYAK.001"
                        Model {
                            id: kes_Ekstr_zyon1_256
                            objectName: "Kes-Ekstrüzyon1.256"
                            source: "meshes/mesh_15_004_mesh.mesh"
                            materials: [
                                paint__0__0__0__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_YATAK_Q_30_L_K___K_AYAK_MONTAJLI_001
                    objectName: "2100_BOÞALTMA_KA_YATAK_Q 30 L KÜÇÜK AYAK MONTAJLI.001"
                    Node {
                        id: node2100_BO_ALTMA_KA_YATAK_Q_30_L_K___K_AYAK_1_001
                        objectName: "2100_BOÞALTMA_KA_YATAK_Q 30 L KÜÇÜK AYAK 1.001"
                        Model {
                            id: _9_0__9___ap_Delik1_036
                            objectName: "Ø9.0 (9) Çap Delik1.036"
                            source: "meshes/mesh_17_004_mesh.mesh"
                            materials: [
                                paint__0__0__0__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BO_ALTMA_KA_YATAK_Q_30_L_K___K_AYAK_2_001
                        objectName: "2100_BOÞALTMA_KA_YATAK_Q 30 L KÜÇÜK AYAK 2.001"
                        Model {
                            id: radyus1_190
                            objectName: "Radyus1.190"
                            source: "meshes/mesh_18_004_mesh.mesh"
                            materials: [
                                paint__0__0__0__255__material
                            ]
                        }
                    }
                }
            }
            Node {
                id: node2100_BO_ALTMA_KA_DAVLUMBAZ_KAYNAK
                objectName: "2100_BOÞALTMA_KA_DAVLUMBAZ KAYNAK"
                Node {
                    id: node2100_BO_ALTMA_KA_DAVLUMBAZ_ARKA_SA_
                    objectName: "2100_BOÞALTMA_KA_DAVLUMBAZ_ARKA SAÇ"
                    Model {
                        id: kes_Ekstr_zyon8_003
                        objectName: "Kes-Ekstrüzyon8.003"
                        source: "meshes/mesh_32_003_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_DAVLUMBAZ_FEDER
                    objectName: "2100_BOÞALTMA_KA_DAVLUMBAZ_FEDER"
                    Model {
                        id: taban_Flan_1_173
                        objectName: "Taban-Flanþ1.173"
                        source: "meshes/mesh_28_004_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_DAVLUMBAZ_FEDER_2
                    objectName: "2100_BOÞALTMA_KA_DAVLUMBAZ_FEDER 2"
                    Model {
                        id: radyus2_066
                        objectName: "Radyus2.066"
                        source: "meshes/mesh_31_004_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_DAVLUMBAZ_FEDER_2_001
                    objectName: "2100_BOÞALTMA_KA_DAVLUMBAZ_FEDER 2.001"
                    Model {
                        id: radyus2_067
                        objectName: "Radyus2.067"
                        source: "meshes/mesh_31_003_mesh.mesh"
                        materials: [
                            paint__185__188__191__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_DAVLUMBAZ_FEDER_001
                    objectName: "2100_BOÞALTMA_KA_DAVLUMBAZ_FEDER.001"
                    Model {
                        id: taban_Flan_1_174
                        objectName: "Taban-Flanþ1.174"
                        source: "meshes/mesh_28_005_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_DAVLUMBAZ_FEDER_002
                    objectName: "2100_BOÞALTMA_KA_DAVLUMBAZ_FEDER.002"
                    Model {
                        id: taban_Flan_1_175
                        objectName: "Taban-Flanþ1.175"
                        source: "meshes/mesh_28_006_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_DAVLUMBAZ_FEDER_003
                    objectName: "2100_BOÞALTMA_KA_DAVLUMBAZ_FEDER.003"
                    Model {
                        id: taban_Flan_1_176
                        objectName: "Taban-Flanþ1.176"
                        source: "meshes/mesh_28_007_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_DAVLUMBAZ_FEDER_004
                    objectName: "2100_BOÞALTMA_KA_DAVLUMBAZ_FEDER.004"
                    Model {
                        id: taban_Flan_1_177
                        objectName: "Taban-Flanþ1.177"
                        source: "meshes/mesh_28_008_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_DAVLUMBAZ_FEDER_005
                    objectName: "2100_BOÞALTMA_KA_DAVLUMBAZ_FEDER.005"
                    Model {
                        id: taban_Flan_1_178
                        objectName: "Taban-Flanþ1.178"
                        source: "meshes/mesh_28_009_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_DAVLUMBAZ_FEDER_006
                    objectName: "2100_BOÞALTMA_KA_DAVLUMBAZ_FEDER.006"
                    Model {
                        id: taban_Flan_1_179
                        objectName: "Taban-Flanþ1.179"
                        source: "meshes/mesh_28_010_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_DAVLUMBAZ_FEDER_007
                    objectName: "2100_BOÞALTMA_KA_DAVLUMBAZ_FEDER.007"
                    Model {
                        id: taban_Flan_1_180
                        objectName: "Taban-Flanþ1.180"
                        source: "meshes/mesh_28_011_mesh.mesh"
                        materials: [
                            paint__185__188__191__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_DAVLUMBAZ_FEDER_008
                    objectName: "2100_BOÞALTMA_KA_DAVLUMBAZ_FEDER.008"
                    Model {
                        id: taban_Flan_1_181
                        objectName: "Taban-Flanþ1.181"
                        source: "meshes/mesh_28_012_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_DAVLUMBAZ_FEDER_009
                    objectName: "2100_BOÞALTMA_KA_DAVLUMBAZ_FEDER.009"
                    Model {
                        id: taban_Flan_1_182
                        objectName: "Taban-Flanþ1.182"
                        source: "meshes/mesh_28_013_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_DAVLUMBAZ_FEDER_010
                    objectName: "2100_BOÞALTMA_KA_DAVLUMBAZ_FEDER.010"
                    Model {
                        id: taban_Flan_1_183
                        objectName: "Taban-Flanþ1.183"
                        source: "meshes/mesh_28_014_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_DAVLUMBAZ_FEDER_011
                    objectName: "2100_BOÞALTMA_KA_DAVLUMBAZ_FEDER.011"
                    Model {
                        id: taban_Flan_1_184
                        objectName: "Taban-Flanþ1.184"
                        source: "meshes/mesh_28_015_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_DAVLUMBAZ_FEDER_012
                    objectName: "2100_BOÞALTMA_KA_DAVLUMBAZ_FEDER.012"
                    Model {
                        id: taban_Flan_1_185
                        objectName: "Taban-Flanþ1.185"
                        source: "meshes/mesh_28_003_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_DAVLUMBAZ_Q_95_BORU
                    objectName: "2100_BOÞALTMA_KA_DAVLUMBAZ_Q 95 BORU"
                    Model {
                        id: y_kseklik_Ekstr_zyon1_393
                        objectName: "Yükseklik-Ekstrüzyon1.393"
                        source: "meshes/mesh_30_005_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_DAVLUMBAZ_Q_95_BORU_001
                    objectName: "2100_BOÞALTMA_KA_DAVLUMBAZ_Q 95 BORU.001"
                    Model {
                        id: y_kseklik_Ekstr_zyon1_394
                        objectName: "Yükseklik-Ekstrüzyon1.394"
                        source: "meshes/mesh_30_006_mesh.mesh"
                        materials: [
                            paint__185__188__191__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_DAVLUMBAZ__N_SA_
                    objectName: "2100_BOÞALTMA_KA_DAVLUMBAZ_ÖN SAÇ"
                    Model {
                        id: l_o_altma1_036
                        objectName: "LÇoðaltma1.036"
                        source: "meshes/mesh_29_003_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
            }
            Node {
                id: node2100_BO_ALTMA_KA__N_P_STON_SACI_KAYNAK
                objectName: "2100_BOÞALTMA_KA_ÖN PÝSTON SACI KAYNAK"
                Node {
                    id: node2100_BO_ALTMA_KA_D_KME_SA__4
                    objectName: "2100_BOÞALTMA_KA_DÝKME SAÇ 4"
                    Model {
                        id: radyus1_188
                        objectName: "Radyus1.188"
                        source: "meshes/mesh_13_014_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_YATAY_SAC
                    objectName: "2100_BOÞALTMA_KA_YATAY SAC"
                    Model {
                        id: radyus1_187
                        objectName: "Radyus1.187"
                        source: "meshes/mesh_12_014_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
            }
            Node {
                id: node2100_BO_ALTMA_KA__N_YATAK_KAYNAK
                objectName: "2100_BOÞALTMA_KA_ÖN YATAK_KAYNAK"
                Node {
                    id: node2100_BO_ALTMA_KA_ALT_FLAN_I_001
                    objectName: "2100_BOÞALTMA_KA_ALT FLANÞI.001"
                    Model {
                        id: kes_Ekstr_zyon1_253
                        objectName: "Kes-Ekstrüzyon1.253"
                        source: "meshes/mesh_6_004_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_D_KME_SA__1_001
                    objectName: "2100_BOÞALTMA_KA_DÝKME SAÇ 1.001"
                    Model {
                        id: kes_Ekstr_zyon1_252
                        objectName: "Kes-Ekstrüzyon1.252"
                        source: "meshes/mesh_8_004_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_D_KME_SA__3_001
                    objectName: "2100_BOÞALTMA_KA_DÝKME SAÇ 3.001"
                    Model {
                        id: _5_0__5___ap_Delik1_016
                        objectName: "Ø5.0 (5) Çap Delik1.016"
                        source: "meshes/mesh_7_004_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_FEDER_001
                    objectName: "2100_BOÞALTMA_KA_FEDER.001"
                    Model {
                        id: taban_Flan_1_172
                        objectName: "Taban-Flanþ1.172"
                        source: "meshes/mesh_11_004_mesh.mesh"
                        materials: [
                            paint__185__188__191__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA__N_YATAK_D_KME_SA__2
                    objectName: "2100_BOÞALTMA_KA_ÖN YATAK_DÝKME SAÇ 2"
                    Model {
                        id: kes_Ekstr_zyon2_089
                        objectName: "Kes-Ekstrüzyon2.089"
                        source: "meshes/mesh_14_004_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA__ST_FLAN__001
                    objectName: "2100_BOÞALTMA_KA_ÜST FLANÞ.001"
                    Model {
                        id: dairesel_Kaplama1_007
                        objectName: "Dairesel Kaplama1.007"
                        source: "meshes/mesh_9_004_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
            }
            Node {
                id: node2100_BO_ALTMA_KA__N_YATAK_P_STONU_MONTAJLI
                objectName: "2100_BOÞALTMA_KA_ÖN YATAK_PÝSTONU MONTAJLI"
                Node {
                    id: node2100_BO_ALTMA_KA_ARKA_YATAK_139x_40_0200_01
                    objectName: "2100_BOÞALTMA_KA_ARKA YATAK_139x_40_0200_01"
                    Node {
                        id: node2100_BO_ALTMA_KA_ARKA_YATAK_1320_40_18F_1
                        objectName: "2100_BOÞALTMA_KA_ARKA YATAK_1320_40_18F_1"
                        Model {
                            id: imported1_172
                            objectName: "Imported1.172"
                            source: "meshes/mesh_20_001_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BO_ALTMA_KA_ARKA_YATAK_CPL040_001_01_1
                        objectName: "2100_BOÞALTMA_KA_ARKA YATAK_CPL040-001-01_1"
                        Model {
                            id: imported1_175
                            objectName: "Imported1.175"
                            source: "meshes/mesh_23_005_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BO_ALTMA_KA_ARKA_YATAK_CPL040_002_01_1
                        objectName: "2100_BOÞALTMA_KA_ARKA YATAK_CPL040-002-01_1"
                        Model {
                            id: imported1_174
                            objectName: "Imported1.174"
                            source: "meshes/mesh_22_001_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BO_ALTMA_KA_ARKA_YATAK_CPL040_004_200
                        objectName: "2100_BOÞALTMA_KA_ARKA YATAK_CPL040_004-200"
                        Model {
                            id: imported1_173
                            objectName: "Imported1.173"
                            source: "meshes/mesh_21_001_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BO_ALTMA_KA_ARKA_YATAK_CPL_40_0200
                        objectName: "2100_BOÞALTMA_KA_ARKA YATAK_CPL_40_0200"
                        Model {
                            id: imported1_171
                            objectName: "Imported1.171"
                            source: "meshes/mesh_19_005_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA_YATAK_Q_30_L_K___K_AYAK_MONTAJLI
                    objectName: "2100_BOÞALTMA_KA_YATAK_Q 30 L KÜÇÜK AYAK MONTAJLI"
                    Node {
                        id: node2100_BO_ALTMA_KA_YATAK_Q_30_L_K___K_AYAK_1
                        objectName: "2100_BOÞALTMA_KA_YATAK_Q 30 L KÜÇÜK AYAK 1"
                        Model {
                            id: _9_0__9___ap_Delik1_035
                            objectName: "Ø9.0 (9) Çap Delik1.035"
                            source: "meshes/mesh_17_006_mesh.mesh"
                            materials: [
                                paint__0__0__0__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BO_ALTMA_KA_YATAK_Q_30_L_K___K_AYAK_2
                        objectName: "2100_BOÞALTMA_KA_YATAK_Q 30 L KÜÇÜK AYAK 2"
                        Model {
                            id: radyus1_189
                            objectName: "Radyus1.189"
                            source: "meshes/mesh_18_005_mesh.mesh"
                            materials: [
                                paint__0__0__0__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA__N_YATAK_30_LUK_M_L
                    objectName: "2100_BOÞALTMA_KA_ÖN YATAK_30 LUK MÝL"
                    Model {
                        id: pah1_155
                        objectName: "Pah1.155"
                        source: "meshes/mesh_24_004_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA__N_YATAK_LMEK_30_RULMANI
                    objectName: "2100_BOÞALTMA_KA_ÖN YATAK_LMEK 30 RULMANI"
                    Model {
                        id: y_kseklik_Ekstr_zyon2_018
                        objectName: "Yükseklik-Ekstrüzyon2.018"
                        source: "meshes/mesh_25_003_mesh.mesh"
                        materials: [
                            paint__0__0__0__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BO_ALTMA_KA__N_YATAK_Q_30_L_AYAK_MONTAJLI
                    objectName: "2100_BOÞALTMA_KA_ÖN YATAK_Q 30 L AYAK_MONTAJLI"
                    Node {
                        id: node2100_BO_ALTMA_KA_Q_30_L_AYAK
                        objectName: "2100_BOÞALTMA_KA_Q 30 L AYAK"
                        Model {
                            id: kes_Ekstr_zyon1_254
                            objectName: "Kes-Ekstrüzyon1.254"
                            source: "meshes/mesh_15_006_mesh.mesh"
                            materials: [
                                paint__0__0__0__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BO_ALTMA_KA_Q_30_L_AYAK_2
                        objectName: "2100_BOÞALTMA_KA_Q 30 L AYAK 2"
                        Model {
                            id: kes_Ekstr_zyon1_255
                            objectName: "Kes-Ekstrüzyon1.255"
                            source: "meshes/mesh_16_005_mesh.mesh"
                            materials: [
                                paint__0__0__0__255__material
                            ]
                        }
                    }
                }
            }
            Model {
                id: makine3_par_a_007
                objectName: "makine3-parça.007"
                position: Qt.vector3d(0.503327, 0.959116, -0.0164951)
                rotation: Qt.quaternion(5.96046e-08, 0, 0.707107, -0.707107)
                scale: Qt.vector3d(0.00615084, 0.00615084, 0.00615084)
                source: "meshes/shape_020_mesh.mesh"
                materials: [
                    paint__190__190__168__102__material
                ]
            }
        }
        Node {
            id: rotarymag
            objectName: "ROTARYMAG"
            position: Qt.vector3d(0, 0.704551, 0)
            x: node.axisX
            Node {
                id: node2100_ROTARY_10_LU_D_SK_MONTAJLI
                objectName: "2100_ROTARY_10 LU DÝSK_MONTAJLI"
                Node {
                    id: hsk_F63_ADAPT_R_TUTUCU_004
                    objectName: "HSK F63 ADAPTÖR+TUTUCU.004"
                    Node {
                        id: hsk_F63_ADAPT_R_004
                        objectName: "HSK F63 ADAPTÖR.004"
                        Model {
                            id: y_kseklik_Ekstr_zyon1_214
                            objectName: "Yükseklik-Ekstrüzyon1.214"
                            source: "meshes/mesh_1345_002_mesh.mesh"
                            materials: [
                                paint__185__188__191__255__material
                            ]
                        }
                    }
                }
            }
            Node {
                id: node2100_ROTARY_12_L__D_SK_MONTAJLI
                objectName: "2100_ROTARY_12 LÝ DÝSK_MONTAJLI"
                Node {
                    id: node2100_ROTARY_12_L__D_SK
                    objectName: "2100_ROTARY_12 LÝ_DÝSK"
                    Model {
                        id: kes_Ekstr_zyon2_039
                        objectName: "Kes-Ekstrüzyon2.039"
                        source: "meshes/mesh_1340_mesh.mesh"
                        materials: [
                            paint__55__55__55__255__material
                        ]
                    }
                }
                Node {
                    id: agrega_YUVA_P_M
                    objectName: "AGREGA YUVA+PÝM"
                    Node {
                        id: agrega_P_M_
                        objectName: "AGREGA PÝMÝ"
                        Model {
                            id: pah2_002
                            objectName: "Pah2.002"
                            source: "meshes/mesh_1344_mesh.mesh"
                            materials: [
                                paint__185__188__191__255__material
                            ]
                        }
                    }
                    Node {
                        id: agrega_YUVASI
                        objectName: "AGREGA YUVASI"
                        Model {
                            id: kes_Ekstr_zyon4_022
                            objectName: "Kes-Ekstrüzyon4.022"
                            source: "meshes/mesh_1343_mesh.mesh"
                            materials: [
                                paint__185__188__191__255__material
                            ]
                        }
                    }
                }
            }
            Node {
                id: node2100_ROTARY_BR_MAG_ALT_LAMA
                objectName: "2100_ROTARY_BR_MAG_ALT LAMA"
                Model {
                    id: _3_0__3___ap_Delik1
                    objectName: "Ø3.0 (3) Çap Delik1"
                    source: "meshes/mesh_1355_mesh.mesh"
                    materials: [
                        paint__185__188__191__255__material
                    ]
                }
            }
            Node {
                id: node2100_ROTARY_BR_MAG_DI__KAYIT
                objectName: "2100_ROTARY_BR_MAG_DIÞ KAYIT"
                Model {
                    id: kes_Ekstr_zyon1_128
                    objectName: "Kes-Ekstrüzyon1.128"
                    source: "meshes/mesh_1354_mesh.mesh"
                    materials: [
                        paint__185__188__191__255__material
                    ]
                }
            }
            Node {
                id: node2100_ROTARY_BR_MAG_D_KME
                objectName: "2100_ROTARY_BR_MAG_DÝKME"
                Model {
                    id: radyus1_098
                    objectName: "Radyus1.098"
                    source: "meshes/mesh_1356_mesh.mesh"
                    materials: [
                        paint__185__188__191__255__material
                    ]
                }
            }
            Node {
                id: node2100_ROTARY_BR_MAG_MOTOR_FLAN_I
                objectName: "2100_ROTARY_BR_MAG_MOTOR FLANÞI"
                Model {
                    id: cut_Extrude2_750
                    objectName: "Cut-Extrude2.750"
                    source: "meshes/mesh_1358_mesh.mesh"
                    materials: [
                        paint__55__55__55__255__material
                    ]
                }
            }
            Node {
                id: node2100_ROTARY_BR_MAG_PLAKASI
                objectName: "2100_ROTARY_BR_MAG_PLAKASI"
                Model {
                    id: _5_0__5___ap_Delik2_004
                    objectName: "Ø5.0 (5) Çap Delik2.004"
                    source: "meshes/mesh_1335_mesh.mesh"
                    materials: [
                        paint__185__188__191__255__material
                    ]
                }
            }
            Node {
                id: node2100_ROTARY_BR_MAG_SENS_R_L_AYAK_2_001
                objectName: "2100_ROTARY_BR_MAG_SENSÖR L AYAK 2.001"
                Model {
                    id: cut_Extrude2_748
                    objectName: "Cut-Extrude2.748"
                    source: "meshes/mesh_1260_mesh.mesh"
                    materials: [
                        paint__185__188__191__255__material
                    ]
                }
            }
            Node {
                id: node2100_ROTARY_BR_MAG_SENS_R_SACI
                objectName: "2100_ROTARY_BR_MAG_SENSÖR SACI"
                Model {
                    id: kes_Ekstr_zyon4_021
                    objectName: "Kes-Ekstrüzyon4.021"
                    source: "meshes/mesh_1336_mesh.mesh"
                    materials: [
                        paint__185__188__191__255__material
                    ]
                }
            }
            Node {
                id: node2100_ROTARY_BR_MAG__N_FLAN_
                objectName: "2100_ROTARY_BR_MAG_ÖN FLANÞ"
                Model {
                    id: boss_Extrude1_100
                    objectName: "Boss-Extrude1.100"
                    source: "meshes/mesh_1353_mesh.mesh"
                    materials: [
                        paint__185__188__191__255__material
                    ]
                }
            }
            Node {
                id: node2100_ROTARY_BR_MAG__N_FLAN__2
                objectName: "2100_ROTARY_BR_MAG_ÖN FLANÞ 2"
                Model {
                    id: _5_0__5___ap_Delik1_013
                    objectName: "Ø5.0 (5) Çap Delik1.013"
                    source: "meshes/mesh_1339_mesh.mesh"
                    materials: [
                        paint__185__188__191__255__material
                    ]
                }
            }
            Node {
                id: node2100_ROTARY_BR_MAG__ST_LAMA
                objectName: "2100_ROTARY_BR_MAG_ÜST LAMA"
                Model {
                    id: fillet1_021
                    objectName: "Fillet1.021"
                    source: "meshes/mesh_1337_mesh.mesh"
                    materials: [
                        paint__185__188__191__255__material
                    ]
                }
            }
            Node {
                id: node2100_ROTARY_BR_MAG____KAYIT
                objectName: "2100_ROTARY_BR_MAG_ÝÇ KAYIT"
                Model {
                    id: cut_Extrude2_746
                    objectName: "Cut-Extrude2.746"
                    source: "meshes/mesh_1338_mesh.mesh"
                    materials: [
                        paint__185__188__191__255__material
                    ]
                }
            }
            Node {
                id: rotarymag_001
                objectName: "ROTARYMAG.001"
                Node {
                    id: node2100_ROTARY_12_L__D_SK_MONTAJLI_001
                    objectName: "2100_ROTARY_12 LÝ DÝSK_MONTAJLI.001"
                    Node {
                        id: _SO_30_ADAPT_R_TUTUCU_002
                        objectName: "ÝSO 30 ADAPTÖR+TUTUCU.002"
                        Node {
                            id: _SO_30_TUTUCU_002
                            objectName: "ÝSO 30 TUTUCU.002"
                            Model {
                                id: cut_Extrude6_006
                                objectName: "Cut-Extrude6.006"
                                position: Qt.vector3d(0.0504786, 0.489007, -1.94553)
                                source: "meshes/mesh_1341_002_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                    }
                }
                Model {
                    id: cut_Extrude5_027
                    objectName: "Cut-Extrude5.027"
                    position: Qt.vector3d(0.0253759, 0.506887, -1.5884)
                    rotation: Qt.quaternion(0.91352, 0, 0.406793, 0)
                    source: "meshes/mesh_1304_mesh.mesh"
                    materials: [
                        paint__55__55__55__255__material
                    ]
                }
                Model {
                    id: cut_Extrude5_028
                    objectName: "Cut-Extrude5.028"
                    position: Qt.vector3d(-0.0963258, 0.486623, -1.72376)
                    rotation: Qt.quaternion(0.9989, 0, -0.0468855, 0)
                    source: "meshes/mesh_1304_027_mesh.mesh"
                    materials: [
                        paint__55__55__55__255__material
                    ]
                }
                Model {
                    id: cut_Extrude5_029
                    objectName: "Cut-Extrude5.029"
                    position: Qt.vector3d(0.12233, 0.489285, -1.58102)
                    source: "meshes/mesh_1304_026_mesh.mesh"
                    materials: [
                        paint__55__55__55__255__material
                    ]
                }
                Model {
                    id: cut_Extrude5_030
                    objectName: "Cut-Extrude5.030"
                    position: Qt.vector3d(0.208121, 0.489285, -1.61944)
                    rotation: Qt.quaternion(0.977961, 0, 0.20879, 0)
                    source: "meshes/mesh_1304_028_mesh.mesh"
                    materials: [
                        paint__55__55__55__255__material
                    ]
                }
                Model {
                    id: cut_Extrude5_031
                    objectName: "Cut-Extrude5.031"
                    position: Qt.vector3d(-0.0532493, 0.506887, -1.64126)
                    rotation: Qt.quaternion(0.983521, 0, 0.180795, 0)
                    source: "meshes/mesh_1304_mesh.mesh"
                    materials: [
                        paint__55__55__55__255__material
                    ]
                }
                Model {
                    id: cut_Extrude6_001
                    objectName: "Cut-Extrude6.001"
                    source: "meshes/mesh_1341_001_mesh.mesh"
                    materials: [
                        paint__55__55__55__255__material
                    ]
                }
                Model {
                    id: cut_Extrude6_002
                    objectName: "Cut-Extrude6.002"
                    position: Qt.vector3d(0.147692, 0.489007, -1.93915)
                    rotation: Qt.quaternion(0.914027, 0, 0.405653, 0)
                    source: "meshes/mesh_1341_mesh.mesh"
                    materials: [
                        paint__55__55__55__255__material
                    ]
                }
                Model {
                    id: cut_Extrude6_005
                    objectName: "Cut-Extrude6.005"
                    position: Qt.vector3d(0.231017, 0.489007, -1.8822)
                    rotation: Qt.quaternion(0.995737, 0, 0.0922348, 0)
                    source: "meshes/mesh_1341_003_mesh.mesh"
                    materials: [
                        paint__55__55__55__255__material
                    ]
                }
                Model {
                    id: cut_Extrude6_007
                    objectName: "Cut-Extrude6.007"
                    position: Qt.vector3d(0.272523, 0.485491, -1.80126)
                    rotation: Qt.quaternion(0.994828, -0.0157743, -0.0927087, -0.038384)
                    source: "meshes/mesh_1341_004_mesh.mesh"
                    materials: [
                        paint__55__55__55__255__material
                    ]
                }
                Model {
                    id: cut_Extrude6_008
                    objectName: "Cut-Extrude6.008"
                    position: Qt.vector3d(0.26454, 0.486287, -1.70345)
                    rotation: Qt.quaternion(0.943797, -0.00613793, -0.327911, -0.0410424)
                    source: "meshes/mesh_1341_004_mesh.mesh"
                    materials: [
                        paint__55__55__55__255__material
                    ]
                }
                Model {
                    id: cut_Extrude6_009
                    objectName: "Cut-Extrude6.009"
                    position: Qt.vector3d(-0.0359071, 0.489007, -1.90913)
                    rotation: Qt.quaternion(0.981477, 0, 0.191582, 0)
                    source: "meshes/mesh_1341_006_mesh.mesh"
                    materials: [
                        paint__55__55__55__255__material
                    ]
                }
                Model {
                    id: cut_Extrude6_010
                    objectName: "Cut-Extrude6.010"
                    position: Qt.vector3d(-0.0885991, 0.489007, -1.82021)
                    rotation: Qt.quaternion(0.85774, 0, 0.514084, 0)
                    source: "meshes/mesh_1341_002_mesh.mesh"
                    materials: [
                        paint__55__55__55__255__material
                    ]
                }
            }
            Node {
                id: sgmjv_04a_a61_001
                objectName: "sgmjv_04a_a61.001"
                Node {
                    id: sgmjv_04a_a61_base_001
                    objectName: "sgmjv_04a_a61_base.001"
                    Model {
                        id: imported1_102
                        objectName: "Imported1.102"
                        source: "meshes/mesh_1351_mesh.mesh"
                        materials: [
                            paint__55__55__55__255__material
                        ]
                    }
                }
                Node {
                    id: sgmjv_04a_a61_key
                    objectName: "sgmjv_04a_a61_key"
                    Model {
                        id: imported1_103
                        objectName: "Imported1.103"
                        source: "meshes/mesh_1352_mesh.mesh"
                        materials: [
                            paint__185__188__191__255__material
                        ]
                    }
                }
                Node {
                    id: spirit_CI_ST_064_010_50_70_14_001
                    objectName: "SPIRIT-CI-ST-064-010-50-70-14.001"
                    Node {
                        id: ring_19_14_001
                        objectName: "RING 19_14.001"
                        Model {
                            id: al_nm__1_1800
                            objectName: "Alýnmýþ1.1800"
                            source: "meshes/mesh_1349_mesh.mesh"
                            materials: [
                                paint__185__188__191__255__material
                            ]
                        }
                        Model {
                            id: al_nm__2_005
                            objectName: "Alýnmýþ2.005"
                            source: "meshes/mesh_1350_mesh.mesh"
                            materials: [
                                paint__185__188__191__255__material
                            ]
                        }
                    }
                    Node {
                        id: spirit_CI_ST_064_010_05SB_G1_Turkey_001
                        objectName: "SPIRIT-CI-ST-064-010-05SB-G1-Turkey.001"
                        Model {
                            id: al_nm__1_1798
                            objectName: "Alýnmýþ1.1798"
                            source: "meshes/mesh_1347_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: wiser_CI_ST_060_5070M4_Flans_001
                        objectName: "WISER-CI-ST-060_5070M4 Flans.001"
                        Model {
                            id: al_nm__1_1799
                            objectName: "Alýnmýþ1.1799"
                            source: "meshes/mesh_1348_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                }
            }
        }












        Model {
            id: clamponu
            objectName: "CLAMPONU"
            position: Qt.vector3d(-0.554288, 1.16446, -1.41139)
            x: node.axisX
            rotation: Qt.quaternion(-5.96047e-08, 0, 1, 0)
            scale: Qt.vector3d(0.001, 0.001, 0.001)
            source: "meshes/mesh_4_004_mesh.mesh"
            materials: [
                paint__231__231__231__95__material
            ]
            Model {
                id: cut_Extrude1_042
                objectName: "Cut-Extrude1.042"
                position: Qt.vector3d(470, 0, -1208.5)
                rotation: Qt.quaternion(0.707107, 0, 0.707107, 0)
                scale: Qt.vector3d(1, 1, 1)
                source: "meshes/mesh_1_013_mesh.mesh"
                materials: [
                    paint__231__231__231__95__material
                ]
            }
            Model {
                id: cut_Extrude1_044
                objectName: "Cut-Extrude1.044"
                position: Qt.vector3d(474.5, 203, -2421.5)
                rotation: Qt.quaternion(0, 0, 1, 0)
                source: "meshes/mesh_5_014_mesh.mesh"
                materials: [
                    paint__231__88__7__255__material
                ]
            }
            Model {
                id: cut_Extrude1_045
                objectName: "Cut-Extrude1.045"
                position: Qt.vector3d(474.5, 203, 4.50024)
                rotation: Qt.quaternion(0.707107, 0, 0.707107, 0)
                scale: Qt.vector3d(1, 1, 1)
                source: "meshes/mesh_6_015_mesh.mesh"
                materials: [
                    paint__231__88__7__255__material
                ]
            }
            Model {
                id: cut_Extrude1_046
                objectName: "Cut-Extrude1.046"
                position: Qt.vector3d(474.5, 283, -2421.5)
                rotation: Qt.quaternion(-4.7503e-08, 0.707107, 2.51215e-15, 0.707107)
                scale: Qt.vector3d(1, 1, 1)
                source: "meshes/mesh_6_015_mesh.mesh"
                materials: [
                    paint__231__88__7__255__material
                ]
            }
            Model {
                id: cut_Extrude1_047
                objectName: "Cut-Extrude1.047"
                position: Qt.vector3d(470, 0, 4.00012)
                rotation: Qt.quaternion(0.707107, 0, 0.707107, 0)
                scale: Qt.vector3d(1, 1, 1)
                source: "meshes/mesh_1_013_mesh.mesh"
                materials: [
                    paint__231__231__231__95__material
                ]
            }
            Model {
                id: cut_Extrude1_048
                objectName: "Cut-Extrude1.048"
                position: Qt.vector3d(468.5, 0, -2417)
                rotation: Qt.quaternion(0, 0, 1, 0)
                source: "meshes/mesh_4_004_mesh.mesh"
                materials: [
                    paint__231__231__231__95__material
                ]
            }
            Model {
                id: cut_Extrude3_234
                objectName: "Cut-Extrude3.234"
                position: Qt.vector3d(7.53533e-05, 178, 4.50019)
                source: "meshes/mesh_3_004_mesh.mesh"
                materials: [
                    paint__185__188__191__255__material
                ]
            }
            Model {
                id: cut_Extrude3_235
                objectName: "Cut-Extrude3.235"
                position: Qt.vector3d(468.5, 178, -2421.5)
                rotation: Qt.quaternion(0, 0, 1, 0)
                source: "meshes/mesh_3_004_mesh.mesh"
                materials: [
                    paint__185__188__191__255__material
                ]
            }
            Model {
                id: kes_Ekstr_zyon2_030
                objectName: "Kes-Ekstrüzyon2.030"
                position: Qt.vector3d(474.5, 283, -18.9999)
                rotation: Qt.quaternion(0.707107, 0, 0.707107, 0)
                scale: Qt.vector3d(1, 1, 1)
                source: "meshes/mesh_7_015_mesh.mesh"
                materials: [
                    paint__234__232__240__255__material
                ]
            }
            Model {
                id: kes_Ekstr_zyon2_090
                objectName: "Kes-Ekstrüzyon2.090"
                position: Qt.vector3d(474.5, 283, -1208.5)
                rotation: Qt.quaternion(0.707107, 0, 0.707107, 0)
                scale: Qt.vector3d(1, 1, 1)
                source: "meshes/mesh_7_015_mesh.mesh"
                materials: [
                    paint__234__232__240__255__material
                ]
            }
            Model {
                id: lpattern3
                objectName: "LPattern3"
                position: Qt.vector3d(474.5, 178, -1208.5)
                rotation: Qt.quaternion(0.707107, 0, 0.707107, 0)
                scale: Qt.vector3d(1, 1, 1)
                source: "meshes/mesh_2_014_mesh.mesh"
                materials: [
                    paint__185__188__191__255__material
                ]
            }
            Model {
                id: lpattern3_001
                objectName: "LPattern3.001"
                position: Qt.vector3d(474.5, 178, 4.00012)
                rotation: Qt.quaternion(0.707107, 0, 0.707107, 0)
                scale: Qt.vector3d(1, 1, 1)
                source: "meshes/mesh_2_014_mesh.mesh"
                materials: [
                    paint__185__188__191__255__material
                ]
            }
            Model {
                id: _9_2__9_2___ap_Delik1_003
                objectName: "Ø9.2 (9.2) Çap Delik1.003"
                position: Qt.vector3d(-32.4999, 283, 1.50018)
                source: "meshes/mesh_0_014_mesh.mesh"
                materials: [
                    paint__234__232__240__255__material
                ]
            }
            Model {
                id: _9_2__9_2___ap_Delik1_004
                objectName: "Ø9.2 (9.2) Çap Delik1.004"
                position: Qt.vector3d(-32.4999, 283, -2417)
                source: "meshes/mesh_8_015_mesh.mesh"
                materials: [
                    paint__234__232__240__255__material
                ]
            }
        }
        Node {
            id: clamp
            objectName: "CLAMP"
            position: Qt.vector3d(0, 0.704551, 0)
            x: node.axisX
            Node {
                id: node2100_CLAMP_Y_KLEME_CLAMP_MONTAJLI
                objectName: "2100_CLAMP YÜKLEME_CLAMP_MONTAJLI"
                Node {
                    id: node2100_CLAMP_Y_KLEME_CLAMP_1550_50_072_02___02_
                    objectName: "2100_CLAMP YÜKLEME_CLAMP_1550_50_072_02_#-02_"
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_1540_503_50_0100
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_1540_503_50_0100"
                        Model {
                            id: kes_Ekstr_zyon1_244
                            objectName: "Kes-Ekstrüzyon1.244"
                            source: "meshes/mesh_1983_001_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_1540_531_50_0100_2
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_1540_531_50_0100_2"
                        Model {
                            id: m10_Di_li_Delik1_020
                            objectName: "M10 Diþli Delik1.020"
                            source: "meshes/mesh_1982_001_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_1550_501_3
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_1550_501_3"
                        Model {
                            id: al_nm__1_2183
                            objectName: "Alýnmýþ1.2183"
                            source: "meshes/mesh_1981_001_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_1550_502_3
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_1550_502_3"
                        Model {
                            id: al_nm__1_2184
                            objectName: "Alýnmýþ1.2184"
                            source: "meshes/mesh_1984_001_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: node2100_CLAMP_Y_KLEME_CLAMP_ALT_PLAST_K
                    objectName: "2100_CLAMP YÜKLEME_CLAMP_ALT PLASTÝK"
                    Model {
                        id: _3_5__3_5___ap_Delik1_003
                        objectName: "Ø3.5 (3.5) Çap Delik1.003"
                        source: "meshes/mesh_1988_001_mesh.mesh"
                        materials: [
                            paint__175__178__181__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_CLAMP_Y_KLEME_CLAMP_ALT__ENE_1
                    objectName: "2100_CLAMP YÜKLEME_CLAMP_ALT ÇENE 1"
                    Model {
                        id: m12x1_25_Di_li_Delik1
                        objectName: "M12x1.25 Diþli Delik1"
                        source: "meshes/mesh_1980_001_mesh.mesh"
                        materials: [
                            paint__175__178__181__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_CLAMP_Y_KLEME_CLAMP_Q_20_YATAKLAMA_MONTAJLI
                    objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 20 YATAKLAMA_MONTAJLI"
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_Q_20_RULMAN_G_VDE___FTL_
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 20 RULMAN_GÖVDE ÇÝFTLÝ"
                        Model {
                            id: m6_Di_li_Delik11
                            objectName: "M6 Diþli Delik11"
                            source: "meshes/mesh_1978_001_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_Q_25_RULMAN
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 25 RULMAN"
                        Model {
                            id: y_kseklik_Ekstr_zyon1_373
                            objectName: "Yükseklik-Ekstrüzyon1.373"
                            source: "meshes/mesh_1977_001_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_Q_25_RULMAN_001
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 25 RULMAN.001"
                        Model {
                            id: y_kseklik_Ekstr_zyon1_374
                            objectName: "Yükseklik-Ekstrüzyon1.374"
                            source: "meshes/mesh_1977_002_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_Q_25_RULMAN_002
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 25 RULMAN.002"
                        Model {
                            id: y_kseklik_Ekstr_zyon1_375
                            objectName: "Yükseklik-Ekstrüzyon1.375"
                            source: "meshes/mesh_1977_003_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_Q_25_RULMAN_003
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 25 RULMAN.003"
                        Model {
                            id: y_kseklik_Ekstr_zyon1_376
                            objectName: "Yükseklik-Ekstrüzyon1.376"
                            source: "meshes/mesh_1977_004_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_Q_25_X_220_M_L
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 25 X 220 MÝL"
                        Model {
                            id: kes_Ekstr_zyon1_240
                            objectName: "Kes-Ekstrüzyon1.240"
                            source: "meshes/mesh_1979_001_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_Q_25_X_220_M_L_001
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 25 X 220 MÝL.001"
                        Model {
                            id: kes_Ekstr_zyon1_241
                            objectName: "Kes-Ekstrüzyon1.241"
                            source: "meshes/mesh_1979_002_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: node2100_CLAMP_Y_KLEME_CLAMP_Q_20_YATAKLAMA_MONTAJLI_001
                    objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 20 YATAKLAMA_MONTAJLI.001"
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_Q_20_RULMAN_G_VDE___FTL__001
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 20 RULMAN_GÖVDE ÇÝFTLÝ.001"
                        Model {
                            id: m6_Di_li_Delik11_001
                            objectName: "M6 Diþli Delik11.001"
                            source: "meshes/mesh_1978_002_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_Q_25_RULMAN_004
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 25 RULMAN.004"
                        Model {
                            id: y_kseklik_Ekstr_zyon1_377
                            objectName: "Yükseklik-Ekstrüzyon1.377"
                            source: "meshes/mesh_1977_005_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_Q_25_RULMAN_005
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 25 RULMAN.005"
                        Model {
                            id: y_kseklik_Ekstr_zyon1_378
                            objectName: "Yükseklik-Ekstrüzyon1.378"
                            source: "meshes/mesh_1977_006_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_Q_25_RULMAN_006
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 25 RULMAN.006"
                        Model {
                            id: y_kseklik_Ekstr_zyon1_379
                            objectName: "Yükseklik-Ekstrüzyon1.379"
                            source: "meshes/mesh_1977_007_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_Q_25_RULMAN_007
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 25 RULMAN.007"
                        Model {
                            id: y_kseklik_Ekstr_zyon1_380
                            objectName: "Yükseklik-Ekstrüzyon1.380"
                            source: "meshes/mesh_1977_008_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_Q_25_X_220_M_L_002
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 25 X 220 MÝL.002"
                        Model {
                            id: kes_Ekstr_zyon1_242
                            objectName: "Kes-Ekstrüzyon1.242"
                            source: "meshes/mesh_1979_003_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_Q_25_X_220_M_L_003
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 25 X 220 MÝL.003"
                        Model {
                            id: kes_Ekstr_zyon1_243
                            objectName: "Kes-Ekstrüzyon1.243"
                            source: "meshes/mesh_1979_004_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: node2100_CLAMP_Y_KLEME_CLAMP_TIRNAK
                    objectName: "2100_CLAMP YÜKLEME_CLAMP_TIRNAK"
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_5_MM_SAC
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_5 MM SAC"
                        Model {
                            id: _3_5__3_5___ap_Delik1_002
                            objectName: "Ø3.5 (3.5) Çap Delik1.002"
                            source: "meshes/mesh_1986_001_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_5_MM_SA__KAU_UK
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_5 MM SAÇ_KAUÇUK"
                        Model {
                            id: y_kseklik_Ekstr_zyon1_381
                            objectName: "Yükseklik-Ekstrüzyon1.381"
                            source: "meshes/mesh_1987_001_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: node2100_CLAMP_Y_KLEME_CLAMP__ST__ENE_1
                    objectName: "2100_CLAMP YÜKLEME_CLAMP_ÜST ÇENE 1"
                    Model {
                        id: kes_Ekstr_zyon4_031
                        objectName: "Kes-Ekstrüzyon4.031"
                        source: "meshes/mesh_1989_001_mesh.mesh"
                        materials: [
                            paint__175__178__181__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_CLAMP_Y_KLEME_CLAMP__ST__ENE_2
                    objectName: "2100_CLAMP YÜKLEME_CLAMP_ÜST ÇENE 2"
                    Model {
                        id: m6_Alt_gen_Alyan_Ba_l__K_r_Vida___in_Hav_a1_003
                        objectName: "M6 Altýgen Alyan Baþlý Kör Vida Ýçin Havþa1.003"
                        source: "meshes/mesh_1985_001_mesh.mesh"
                        materials: [
                            paint__175__178__181__255__material
                        ]
                    }
                }
            }
            Node {
                id: node2100_CLAMP_Y_KLEME_CLAMP_MONTAJLI_001
                objectName: "2100_CLAMP YÜKLEME_CLAMP_MONTAJLI.001"
                Node {
                    id: node2100_CLAMP_Y_KLEME_CLAMP_1550_50_072_02___02__001
                    objectName: "2100_CLAMP YÜKLEME_CLAMP_1550_50_072_02_#-02_.001"
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_1540_503_50_0100_001
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_1540_503_50_0100.001"
                        Model {
                            id: kes_Ekstr_zyon1_249
                            objectName: "Kes-Ekstrüzyon1.249"
                            source: "meshes/mesh_1983_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_1540_531_50_0100_2_001
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_1540_531_50_0100_2.001"
                        Model {
                            id: m10_Di_li_Delik1_021
                            objectName: "M10 Diþli Delik1.021"
                            source: "meshes/mesh_1982_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_1550_501_3_001
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_1550_501_3.001"
                        Model {
                            id: al_nm__1_2185
                            objectName: "Alýnmýþ1.2185"
                            source: "meshes/mesh_1981_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_1550_502_3_001
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_1550_502_3.001"
                        Model {
                            id: al_nm__1_2186
                            objectName: "Alýnmýþ1.2186"
                            source: "meshes/mesh_1984_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: node2100_CLAMP_Y_KLEME_CLAMP_ALT_PLAST_K_001
                    objectName: "2100_CLAMP YÜKLEME_CLAMP_ALT PLASTÝK.001"
                    Model {
                        id: _3_5__3_5___ap_Delik1_005
                        objectName: "Ø3.5 (3.5) Çap Delik1.005"
                        source: "meshes/mesh_1988_mesh.mesh"
                        materials: [
                            paint__175__178__181__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_CLAMP_Y_KLEME_CLAMP_ALT__ENE_1_001
                    objectName: "2100_CLAMP YÜKLEME_CLAMP_ALT ÇENE 1.001"
                    Model {
                        id: m12x1_25_Di_li_Delik1_001
                        objectName: "M12x1.25 Diþli Delik1.001"
                        source: "meshes/mesh_1980_mesh.mesh"
                        materials: [
                            paint__175__178__181__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_CLAMP_Y_KLEME_CLAMP_Q_20_YATAKLAMA_MONTAJLI_002
                    objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 20 YATAKLAMA_MONTAJLI.002"
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_Q_20_RULMAN_G_VDE___FTL__002
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 20 RULMAN_GÖVDE ÇÝFTLÝ.002"
                        Model {
                            id: m6_Di_li_Delik11_002
                            objectName: "M6 Diþli Delik11.002"
                            source: "meshes/mesh_1978_003_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_Q_25_RULMAN_008
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 25 RULMAN.008"
                        Model {
                            id: y_kseklik_Ekstr_zyon1_382
                            objectName: "Yükseklik-Ekstrüzyon1.382"
                            source: "meshes/mesh_1977_009_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_Q_25_RULMAN_009
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 25 RULMAN.009"
                        Model {
                            id: y_kseklik_Ekstr_zyon1_383
                            objectName: "Yükseklik-Ekstrüzyon1.383"
                            source: "meshes/mesh_1977_010_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_Q_25_RULMAN_010
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 25 RULMAN.010"
                        Model {
                            id: y_kseklik_Ekstr_zyon1_384
                            objectName: "Yükseklik-Ekstrüzyon1.384"
                            source: "meshes/mesh_1977_011_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_Q_25_RULMAN_011
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 25 RULMAN.011"
                        Model {
                            id: y_kseklik_Ekstr_zyon1_385
                            objectName: "Yükseklik-Ekstrüzyon1.385"
                            source: "meshes/mesh_1977_012_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_Q_25_X_220_M_L_004
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 25 X 220 MÝL.004"
                        Model {
                            id: kes_Ekstr_zyon1_245
                            objectName: "Kes-Ekstrüzyon1.245"
                            source: "meshes/mesh_1979_005_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_Q_25_X_220_M_L_005
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 25 X 220 MÝL.005"
                        Model {
                            id: kes_Ekstr_zyon1_246
                            objectName: "Kes-Ekstrüzyon1.246"
                            source: "meshes/mesh_1979_006_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: node2100_CLAMP_Y_KLEME_CLAMP_Q_20_YATAKLAMA_MONTAJLI_003
                    objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 20 YATAKLAMA_MONTAJLI.003"
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_Q_20_RULMAN_G_VDE___FTL__003
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 20 RULMAN_GÖVDE ÇÝFTLÝ.003"
                        Model {
                            id: m6_Di_li_Delik11_003
                            objectName: "M6 Diþli Delik11.003"
                            source: "meshes/mesh_1978_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_Q_25_RULMAN_012
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 25 RULMAN.012"
                        Model {
                            id: y_kseklik_Ekstr_zyon1_386
                            objectName: "Yükseklik-Ekstrüzyon1.386"
                            source: "meshes/mesh_1977_013_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_Q_25_RULMAN_013
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 25 RULMAN.013"
                        Model {
                            id: y_kseklik_Ekstr_zyon1_387
                            objectName: "Yükseklik-Ekstrüzyon1.387"
                            source: "meshes/mesh_1977_014_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_Q_25_RULMAN_014
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 25 RULMAN.014"
                        Model {
                            id: y_kseklik_Ekstr_zyon1_388
                            objectName: "Yükseklik-Ekstrüzyon1.388"
                            source: "meshes/mesh_1977_015_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_Q_25_RULMAN_015
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 25 RULMAN.015"
                        Model {
                            id: y_kseklik_Ekstr_zyon1_389
                            objectName: "Yükseklik-Ekstrüzyon1.389"
                            source: "meshes/mesh_1977_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_Q_25_X_220_M_L_006
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 25 X 220 MÝL.006"
                        Model {
                            id: kes_Ekstr_zyon1_247
                            objectName: "Kes-Ekstrüzyon1.247"
                            source: "meshes/mesh_1979_007_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_Q_25_X_220_M_L_007
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_Q 25 X 220 MÝL.007"
                        Model {
                            id: kes_Ekstr_zyon1_248
                            objectName: "Kes-Ekstrüzyon1.248"
                            source: "meshes/mesh_1979_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: node2100_CLAMP_Y_KLEME_CLAMP_TIRNAK_001
                    objectName: "2100_CLAMP YÜKLEME_CLAMP_TIRNAK.001"
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_5_MM_SAC_001
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_5 MM SAC.001"
                        Model {
                            id: _3_5__3_5___ap_Delik1_004
                            objectName: "Ø3.5 (3.5) Çap Delik1.004"
                            source: "meshes/mesh_1986_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_CLAMP_Y_KLEME_CLAMP_5_MM_SA__KAU_UK_001
                        objectName: "2100_CLAMP YÜKLEME_CLAMP_5 MM SAÇ_KAUÇUK.001"
                        Model {
                            id: y_kseklik_Ekstr_zyon1_390
                            objectName: "Yükseklik-Ekstrüzyon1.390"
                            source: "meshes/mesh_1987_mesh.mesh"
                            materials: [
                                paint__175__178__181__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: node2100_CLAMP_Y_KLEME_CLAMP__ST__ENE_1_001
                    objectName: "2100_CLAMP YÜKLEME_CLAMP_ÜST ÇENE 1.001"
                    Model {
                        id: kes_Ekstr_zyon4_032
                        objectName: "Kes-Ekstrüzyon4.032"
                        source: "meshes/mesh_1989_mesh.mesh"
                        materials: [
                            paint__175__178__181__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_CLAMP_Y_KLEME_CLAMP__ST__ENE_2_001
                    objectName: "2100_CLAMP YÜKLEME_CLAMP_ÜST ÇENE 2.001"
                    Model {
                        id: m6_Alt_gen_Alyan_Ba_l__K_r_Vida___in_Hav_a1_004
                        objectName: "M6 Altýgen Alyan Baþlý Kör Vida Ýçin Havþa1.004"
                        source: "meshes/mesh_1985_mesh.mesh"
                        materials: [
                            paint__175__178__181__255__material
                        ]
                    }
                }
            }
            Node {
                id: node2100_CLAMP_Y_KLEME_ELT_GH25R_001
                objectName: "2100_CLAMP YÜKLEME_ELT_GH25R.001"
                Model {
                    id: kes_Ekstr_zyon1_238
                    objectName: "Kes-Ekstrüzyon1.238"
                    source: "meshes/mesh_1970_mesh.mesh"
                    materials: [
                        paint__55__55__55__255__material
                    ]
                }
            }
            Node {
                id: node2100_CLAMP_Y_KLEME_ELT_GH25R_240
                objectName: "2100_CLAMP YÜKLEME_ELT_GH25R.240"
                Model {
                    id: kes_Ekstr_zyon2_087
                    objectName: "Kes-Ekstrüzyon2.087"
                    source: "meshes/mesh_1976_mesh.mesh"
                    materials: [
                        paint__55__55__55__255__material
                    ]
                }
            }
            Node {
                id: node2100_CLAMP_Y_KLEME_ELT_GH25R_330
                objectName: "2100_CLAMP YÜKLEME_ELT_GH25R.330"
                Model {
                    id: kes_Ekstr_zyon1_237
                    objectName: "Kes-Ekstrüzyon1.237"
                    source: "meshes/mesh_1970_001_mesh.mesh"
                    materials: [
                        paint__55__55__55__255__material
                    ]
                }
            }
            Node {
                id: node2100_CLAMP_Y_KLEME_KAYDE
                objectName: "2100_CLAMP YÜKLEME_KAYDE"
                Model {
                    id: m4_Di_li_Delik1
                    objectName: "M4 Diþli Delik1"
                    source: "meshes/mesh_1961_mesh.mesh"
                    materials: [
                        paint__234__232__240__255__material
                    ]
                }
            }
            Node {
                id: node2100_CLAMP_Y_KLEME_PUL
                objectName: "2100_CLAMP YÜKLEME_PUL"
                Model {
                    id: radyus1_185
                    objectName: "Radyus1.185"
                    source: "meshes/mesh_1969_001_mesh.mesh"
                    materials: [
                        paint__234__232__240__255__material
                    ]
                }
            }
            Node {
                id: node2100_CLAMP_Y_KLEME_PUL_001
                objectName: "2100_CLAMP YÜKLEME_PUL.001"
                Model {
                    id: radyus1_186
                    objectName: "Radyus1.186"
                    source: "meshes/mesh_1969_mesh.mesh"
                    materials: [
                        paint__234__232__240__255__material
                    ]
                }
            }
            Node {
                id: node2100_CLAMP_Y_KLEME_P_STON_ALT_FLAN__KAYNAK
                objectName: "2100_CLAMP YÜKLEME_PÝSTON_ALT FLANÞ_KAYNAK"
                Node {
                    id: node2100_CLAMP_Y_KLEME_P_STON_ALT_FLAN_
                    objectName: "2100_CLAMP YÜKLEME_PÝSTON_ALT FLANÞ"
                    Model {
                        id: radyus1_184
                        objectName: "Radyus1.184"
                        source: "meshes/mesh_1965_mesh.mesh"
                        materials: [
                            paint__234__232__240__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_CLAMP_Y_KLEME_P_STON_ALT_FLAN__D_KME
                    objectName: "2100_CLAMP YÜKLEME_PÝSTON_ALT FLANÞ_DÝKME"
                    Model {
                        id: kes_Ekstr_zyon1_234
                        objectName: "Kes-Ekstrüzyon1.234"
                        source: "meshes/mesh_1963_mesh.mesh"
                        materials: [
                            paint__234__232__240__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_CLAMP_Y_KLEME_P_STON_ALT_FLAN__FEDER
                    objectName: "2100_CLAMP YÜKLEME_PÝSTON_ALT FLANÞ_FEDER"
                    Model {
                        id: radyus3_006
                        objectName: "Radyus3.006"
                        source: "meshes/mesh_1964_001_mesh.mesh"
                        materials: [
                            paint__234__232__240__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_CLAMP_Y_KLEME_P_STON_ALT_FLAN__FEDER_001
                    objectName: "2100_CLAMP YÜKLEME_PÝSTON_ALT FLANÞ_FEDER.001"
                    Model {
                        id: radyus3_007
                        objectName: "Radyus3.007"
                        source: "meshes/mesh_1964_mesh.mesh"
                        materials: [
                            paint__234__232__240__255__material
                        ]
                    }
                }
            }
            Node {
                id: node2100_CLAMP_Y_KLEME_P_STON__ST_FLAN__KAYNAK
                objectName: "2100_CLAMP YÜKLEME_PÝSTON_ÜST FLANÞ_KAYNAK"
                Node {
                    id: node2100_CLAMP_Y_KLEME_P_STON__ST_FLAN_
                    objectName: "2100_CLAMP YÜKLEME_PÝSTON_ÜST FLANÞ"
                    Model {
                        id: kes_Ekstr_zyon1_235
                        objectName: "Kes-Ekstrüzyon1.235"
                        source: "meshes/mesh_1967_mesh.mesh"
                        materials: [
                            paint__234__232__240__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_CLAMP_Y_KLEME_P_STON__ST_FLAN__D_KME
                    objectName: "2100_CLAMP YÜKLEME_PÝSTON_ÜST FLANÞ_DÝKME"
                    Model {
                        id: kes_Ekstr_zyon1_236
                        objectName: "Kes-Ekstrüzyon1.236"
                        source: "meshes/mesh_1968_mesh.mesh"
                        materials: [
                            paint__234__232__240__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_CLAMP_Y_KLEME_P_STON__ST_FLAN__FEDER
                    objectName: "2100_CLAMP YÜKLEME_PÝSTON_ÜST FLANÞ_FEDER"
                    Model {
                        id: radyus3_008
                        objectName: "Radyus3.008"
                        source: "meshes/mesh_1966_001_mesh.mesh"
                        materials: [
                            paint__234__232__240__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_CLAMP_Y_KLEME_P_STON__ST_FLAN__FEDER_001
                    objectName: "2100_CLAMP YÜKLEME_PÝSTON_ÜST FLANÞ_FEDER.001"
                    Model {
                        id: radyus3_009
                        objectName: "Radyus3.009"
                        source: "meshes/mesh_1966_mesh.mesh"
                        materials: [
                            paint__234__232__240__255__material
                        ]
                    }
                }
            }
            Node {
                id: node2100_CLAMP_Y_KLEME_TAN_P_S_20_135_MONTAJLI
                objectName: "2100_CLAMP YÜKLEME_TAN PÝS_20+135_MONTAJLI"
                Node {
                    id: node2100_CLAMP_Y_KLEME_TAN_P_S_25_135_1320_40_18F
                    objectName: "2100_CLAMP YÜKLEME_TAN PÝS_25+135_1320_40_18F"
                    Model {
                        id: al_nm__1_2178
                        objectName: "Alýnmýþ1.2178"
                        source: "meshes/mesh_1488_005_mesh.mesh"
                        materials: [
                            paint__55__55__55__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_CLAMP_Y_KLEME_TAN_P_S_25_135_1320_40_18F_001
                    objectName: "2100_CLAMP YÜKLEME_TAN PÝS_25+135_1320_40_18F.001"
                    Model {
                        id: al_nm__1_2182
                        objectName: "Alýnmýþ1.2182"
                        source: "meshes/mesh_1488_mesh.mesh"
                        materials: [
                            paint__175__178__181__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_CLAMP_Y_KLEME_TAN_P_S_25_135_1540_503_63_0135
                    objectName: "2100_CLAMP YÜKLEME_TAN PÝS_25+135_1540_503_63_0135"
                    Model {
                        id: y_kseklik_Ekstr_zyon1_372
                        objectName: "Yükseklik-Ekstrüzyon1.372"
                        source: "meshes/mesh_1973_mesh.mesh"
                        materials: [
                            paint__175__178__181__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_CLAMP_Y_KLEME_TAN_P_S_25_135_1540_503_63_025
                    objectName: "2100_CLAMP YÜKLEME_TAN PÝS_25+135_1540_503_63_025"
                    Model {
                        id: kes_Ekstr_zyon1_239
                        objectName: "Kes-Ekstrüzyon1.239"
                        source: "meshes/mesh_1974_mesh.mesh"
                        materials: [
                            paint__175__178__181__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_CLAMP_Y_KLEME_TAN_P_S_25_135_1540_531_63_0135
                    objectName: "2100_CLAMP YÜKLEME_TAN PÝS_25+135_1540_531_63_0135"
                    Model {
                        id: y_kseklik_Ekstr_zyon1_370
                        objectName: "Yükseklik-Ekstrüzyon1.370"
                        source: "meshes/mesh_1971_mesh.mesh"
                        materials: [
                            paint__175__178__181__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_CLAMP_Y_KLEME_TAN_P_S_25_135_1540_531_63_025
                    objectName: "2100_CLAMP YÜKLEME_TAN PÝS_25+135_1540_531_63_025"
                    Model {
                        id: y_kseklik_Ekstr_zyon1_371
                        objectName: "Yükseklik-Ekstrüzyon1.371"
                        source: "meshes/mesh_1972_mesh.mesh"
                        materials: [
                            paint__55__55__55__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_CLAMP_Y_KLEME_TAN_P_S_25_135_1563_501
                    objectName: "2100_CLAMP YÜKLEME_TAN PÝS_25+135_1563_501"
                    Model {
                        id: al_nm__1_2177
                        objectName: "Alýnmýþ1.2177"
                        source: "meshes/mesh_1490_005_mesh.mesh"
                        materials: [
                            paint__175__178__181__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_CLAMP_Y_KLEME_TAN_P_S_25_135_1563_501_001
                    objectName: "2100_CLAMP YÜKLEME_TAN PÝS_25+135_1563_501.001"
                    Model {
                        id: al_nm__1_2180
                        objectName: "Alýnmýþ1.2180"
                        source: "meshes/mesh_1490_mesh.mesh"
                        materials: [
                            paint__175__178__181__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_CLAMP_Y_KLEME_TAN_P_S_25_135_1563_502
                    objectName: "2100_CLAMP YÜKLEME_TAN PÝS_25+135_1563_502"
                    Model {
                        id: al_nm__1_2179
                        objectName: "Alýnmýþ1.2179"
                        source: "meshes/mesh_1491_005_mesh.mesh"
                        materials: [
                            paint__175__178__181__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_CLAMP_Y_KLEME_TAN_P_S_25_135_1563_502_001
                    objectName: "2100_CLAMP YÜKLEME_TAN PÝS_25+135_1563_502.001"
                    Model {
                        id: al_nm__1_2181
                        objectName: "Alýnmýþ1.2181"
                        source: "meshes/mesh_1491_mesh.mesh"
                        materials: [
                            paint__175__178__181__255__material
                        ]
                    }
                }
            }
            Node {
                id: node2100_KULE__ST_BR_2_20_x_80_x_180_LAMA
                objectName: "2100_KULE ÜST_BR 2_20 x 80 x 180 LAMA"
                Model {
                    id: y_kseklik_Ekstr_zyon1_392
                    objectName: "Yükseklik-Ekstrüzyon1.392"
                    source: "meshes/mesh_1992_mesh.mesh"
                    materials: [
                        paint__55__55__55__255__material
                    ]
                }
            }
            Model {
                id: elt_ELT_25B_008
                objectName: "ELT_ELT 25B.008"
                source: "meshes/mesh_1962_001_mesh.mesh"
                materials: [
                    paint__55__55__55__255__material
                ]
            }
            Model {
                id: elt_ELT_25B_009
                objectName: "ELT_ELT 25B.009"
                source: "meshes/mesh_1962_002_mesh.mesh"
                materials: [
                    paint__55__55__55__255__material
                ]
            }
            Model {
                id: elt_ELT_25B_010
                objectName: "ELT_ELT 25B.010"
                source: "meshes/mesh_1975_mesh.mesh"
                materials: [
                    paint__55__55__55__255__material
                ]
            }
            Model {
                id: elt_ELT_25B_011
                objectName: "ELT_ELT 25B.011"
                source: "meshes/mesh_1962_mesh.mesh"
                materials: [
                    paint__55__55__55__255__material
                ]
            }
            Model {
                id: elt_ELT_25B_012
                objectName: "ELT_ELT 25B.012"
                source: "meshes/mesh_1990_mesh.mesh"
                materials: [
                    paint__55__55__55__255__material
                ]
            }
            Model {
                id: y_kseklik_Ekstr_zyon1_391
                objectName: "Yükseklik-Ekstrüzyon1.391"
                source: "meshes/mesh_1991_mesh.mesh"
                materials: [
                    paint__55__55__55__255__material
                ]
            }
        }
        Node {
            id: baskirulosu
            objectName: "BASKIRULOSU"
            position: Qt.vector3d(0, 0.704551, 0)
            x: node.axisX
            Node {
                id: node2100_BASKI_RULO_TAKIM_MONTAJLI
                objectName: "2100_BASKI RULO_TAKIM_MONTAJLI"
                Node {
                    id: node2100_BASKI_RULO_Q_63_P_STON_SA__MONTAJLI
                    objectName: "2100_BASKI RULO_Q 63 PÝSTON_SAÐ_MONTAJLI"
                    Node {
                        id: node2100_BASKI_RULO_150818_002
                        objectName: "2100_BASKI RULO_150818.002"
                        Model {
                            id: imported1_121
                            objectName: "Imported1.121"
                            source: "meshes/mesh_1486_003_mesh.mesh"
                            materials: [
                                paint__185__188__191__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_150818_003
                        objectName: "2100_BASKI RULO_150818.003"
                        Model {
                            id: imported1_122
                            objectName: "Imported1.122"
                            source: "meshes/mesh_1486_004_mesh.mesh"
                            materials: [
                                paint__185__188__191__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_155__63_0075_02___02_001
                        objectName: "2100_BASKI RULO_155#_63_0075_02_#-02.001"
                        Node {
                            id: node2100_BASKI_RULO_1320_40_18F_001
                            objectName: "2100_BASKI RULO_1320_40_18F.001"
                            Model {
                                id: al_nm__1_1842
                                objectName: "Alýnmýþ1.1842"
                                source: "meshes/mesh_1488_002_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_1540_503_63_0075_001
                            objectName: "2100_BASKI RULO_1540_503_63_0075.001"
                            Model {
                                id: kes_Ekstr_zyon1_146
                                objectName: "Kes-Ekstrüzyon1.146"
                                source: "meshes/mesh_1487_002_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_1540_531_63_0075_001
                            objectName: "2100_BASKI RULO_1540_531_63_0075.001"
                            Model {
                                id: kes_Ekstr_zyon3_054
                                objectName: "Kes-Ekstrüzyon3.054"
                                source: "meshes/mesh_1489_002_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_1563_501_001
                            objectName: "2100_BASKI RULO_1563_501.001"
                            Model {
                                id: al_nm__1_1843
                                objectName: "Alýnmýþ1.1843"
                                source: "meshes/mesh_1490_002_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_1563_502_001
                            objectName: "2100_BASKI RULO_1563_502.001"
                            Model {
                                id: al_nm__1_1844
                                objectName: "Alýnmýþ1.1844"
                                source: "meshes/mesh_1491_002_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_P_STON_FLAN__001
                        objectName: "2100_BASKI RULO_PÝSTON FLANÞ.001"
                        Model {
                            id: _6_5__6_5___ap_Delik1_010
                            objectName: "Ø6.5 (6.5) Çap Delik1.010"
                            source: "meshes/mesh_1485_002_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_P_STON_U__PLAKA_001
                        objectName: "2100_BASKI RULO_PÝSTON UÇ PLAKA.001"
                        Model {
                            id: kes_Ekstr_zyon2_049
                            objectName: "Kes-Ekstrüzyon2.049"
                            source: "meshes/mesh_1484_002_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_YATAKLAMA_RULMAN_MONTAJLI_001
                        objectName: "2100_BASKI RULO_YATAKLAMA_RULMAN_MONTAJLI.001"
                        Node {
                            id: node2100_BASKI_RULO_YATAKLAMA_3_MM_PUL_001
                            objectName: "2100_BASKI RULO_YATAKLAMA_3 MM PUL.001"
                            Model {
                                id: boss_Extrude1_120
                                objectName: "Boss-Extrude1.120"
                                source: "meshes/mesh_1481_002_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_YATAKLAMA_Q_16_X_145_M_L_001
                            objectName: "2100_BASKI RULO_YATAKLAMA_Q 16 X 145_MÝL.001"
                            Model {
                                id: m10_Di_li_Delik2_001
                                objectName: "M10 Diþli Delik2.001"
                                source: "meshes/mesh_1482_002_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_YATAKLAMA_RULMAN_001
                            objectName: "2100_BASKI RULO_YATAKLAMA_RULMAN.001"
                            Model {
                                id: m6_Di_li_Delik2_005
                                objectName: "M6 Diþli Delik2.005"
                                source: "meshes/mesh_1483_002_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_YATAKLAMA_RULMANI_16_002
                            objectName: "2100_BASKI RULO_YATAKLAMA_RULMANI 16.002"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_233
                                objectName: "Yükseklik-Ekstrüzyon1.233"
                                source: "meshes/mesh_1480_003_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_YATAKLAMA_RULMANI_16_003
                            objectName: "2100_BASKI RULO_YATAKLAMA_RULMANI 16.003"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_234
                                objectName: "Yükseklik-Ekstrüzyon1.234"
                                source: "meshes/mesh_1480_004_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                    }
                    Node {
                        id: socket_head_cap_screw_am_PreviewCfg_001
                        objectName: "socket head cap screw_am_PreviewCfg.001"
                        Model {
                            id: hex_019
                            objectName: "Hex.019"
                            source: "meshes/mesh_1494_001_mesh.mesh"
                            materials: [
                                paint__185__188__191__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: node2100_BASKI_RULO_Q_63_P_STON_SOL_MONTAJLI
                    objectName: "2100_BASKI RULO_Q 63 PÝSTON_SOL_MONTAJLI"
                    Node {
                        id: node2100_BASKI_RULO_150818
                        objectName: "2100_BASKI RULO_150818"
                        Model {
                            id: imported1_119
                            objectName: "Imported1.119"
                            source: "meshes/mesh_1486_001_mesh.mesh"
                            materials: [
                                paint__185__188__191__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_150818_001
                        objectName: "2100_BASKI RULO_150818.001"
                        Model {
                            id: imported1_120
                            objectName: "Imported1.120"
                            source: "meshes/mesh_1486_002_mesh.mesh"
                            materials: [
                                paint__185__188__191__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_155__63_0075_02___02
                        objectName: "2100_BASKI RULO_155#_63_0075_02_#-02"
                        Node {
                            id: node2100_BASKI_RULO_1320_40_18F
                            objectName: "2100_BASKI RULO_1320_40_18F"
                            Model {
                                id: al_nm__1_1826
                                objectName: "Alýnmýþ1.1826"
                                source: "meshes/mesh_1488_001_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_1540_503_63_0075
                            objectName: "2100_BASKI RULO_1540_503_63_0075"
                            Model {
                                id: kes_Ekstr_zyon1_145
                                objectName: "Kes-Ekstrüzyon1.145"
                                source: "meshes/mesh_1487_001_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_1540_531_63_0075
                            objectName: "2100_BASKI RULO_1540_531_63_0075"
                            Model {
                                id: kes_Ekstr_zyon3_053
                                objectName: "Kes-Ekstrüzyon3.053"
                                source: "meshes/mesh_1489_001_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_1563_501
                            objectName: "2100_BASKI RULO_1563_501"
                            Model {
                                id: al_nm__1_1827
                                objectName: "Alýnmýþ1.1827"
                                source: "meshes/mesh_1490_001_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_1563_502
                            objectName: "2100_BASKI RULO_1563_502"
                            Model {
                                id: al_nm__1_1828
                                objectName: "Alýnmýþ1.1828"
                                source: "meshes/mesh_1491_001_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_P_STON_FLAN_
                        objectName: "2100_BASKI RULO_PÝSTON FLANÞ"
                        Model {
                            id: _6_5__6_5___ap_Delik1_009
                            objectName: "Ø6.5 (6.5) Çap Delik1.009"
                            source: "meshes/mesh_1485_001_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_P_STON_U__PLAKA
                        objectName: "2100_BASKI RULO_PÝSTON UÇ PLAKA"
                        Model {
                            id: kes_Ekstr_zyon2_047
                            objectName: "Kes-Ekstrüzyon2.047"
                            source: "meshes/mesh_1484_001_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_YATAKLAMA_RULMAN_MONTAJLI
                        objectName: "2100_BASKI RULO_YATAKLAMA_RULMAN_MONTAJLI"
                        Node {
                            id: node2100_BASKI_RULO_YATAKLAMA_3_MM_PUL
                            objectName: "2100_BASKI RULO_YATAKLAMA_3 MM PUL"
                            Model {
                                id: boss_Extrude1_119
                                objectName: "Boss-Extrude1.119"
                                source: "meshes/mesh_1481_001_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_YATAKLAMA_Q_16_X_145_M_L
                            objectName: "2100_BASKI RULO_YATAKLAMA_Q 16 X 145_MÝL"
                            Model {
                                id: m10_Di_li_Delik2
                                objectName: "M10 Diþli Delik2"
                                source: "meshes/mesh_1482_001_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_YATAKLAMA_RULMAN
                            objectName: "2100_BASKI RULO_YATAKLAMA_RULMAN"
                            Model {
                                id: m6_Di_li_Delik2_004
                                objectName: "M6 Diþli Delik2.004"
                                source: "meshes/mesh_1483_001_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_YATAKLAMA_RULMANI_16
                            objectName: "2100_BASKI RULO_YATAKLAMA_RULMANI 16"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_230
                                objectName: "Yükseklik-Ekstrüzyon1.230"
                                source: "meshes/mesh_1480_001_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_YATAKLAMA_RULMANI_16_001
                            objectName: "2100_BASKI RULO_YATAKLAMA_RULMANI 16.001"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_231
                                objectName: "Yükseklik-Ekstrüzyon1.231"
                                source: "meshes/mesh_1480_002_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                    }
                }
                Node {
                    id: node2100_BASKI_RULO_RULO_MONTAJI
                    objectName: "2100_BASKI RULO_RULO MONTAJI"
                    Node {
                        id: node2100_BASKI_RULO_RULO_DOLU_M_L_Q_45
                        objectName: "2100_BASKI RULO_RULO_DOLU MÝL Q 45"
                        Model {
                            id: m8_Tapped_Hole1
                            objectName: "M8 Tapped Hole1"
                            source: "meshes/mesh_1462_001_mesh.mesh"
                            materials: [
                                paint__137__84__10__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: node2100_BASKI_RULO_RULO_PUL
                    objectName: "2100_BASKI RULO_RULO_PUL"
                    Model {
                        id: taban_Flan_1_126
                        objectName: "Taban-Flanþ1.126"
                        source: "meshes/mesh_1493_001_mesh.mesh"
                        materials: [
                            paint__185__188__191__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BASKI_RULO_RULO_PUL_001
                    objectName: "2100_BASKI RULO_RULO_PUL.001"
                    Model {
                        id: taban_Flan_1_127
                        objectName: "Taban-Flanþ1.127"
                        source: "meshes/mesh_1493_002_mesh.mesh"
                        materials: [
                            paint__185__188__191__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BASKI_RULO_UC_205_RULMAN_YATAK_SA__MONTAJLI
                    objectName: "2100_BASKI RULO_UC 205_RULMAN_YATAK_SAÐ MONTAJLI"
                    Node {
                        id: node2100_BASKI_RULO_UC_205_HALKA__ABLON
                        objectName: "2100_BASKI RULO_UC 205_HALKA_ÞABLON"
                        Model {
                            id: y_kseklik_Ekstr_zyon1_229
                            objectName: "Yükseklik-Ekstrüzyon1.229"
                            source: "meshes/mesh_1466_001_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_UC_205_RULMAN_KAPAK
                        objectName: "2100_BASKI RULO_UC 205_RULMAN_KAPAK"
                        Model {
                            id: kes_Ekstr_zyon2_046
                            objectName: "Kes-Ekstrüzyon2.046"
                            source: "meshes/mesh_1465_001_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_UC_205_RULMAN_YATAK_SA__
                        objectName: "2100_BASKI RULO_UC 205_RULMAN_YATAK SAÐ_"
                        Model {
                            id: kes_Ekstr_zyon8_001
                            objectName: "Kes-Ekstrüzyon8.001"
                            source: "meshes/mesh_1464_001_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: node2100_BASKI_RULO_UC_205_RULMAN_YATAK_SOL_MONTAJLI
                    objectName: "2100_BASKI RULO_UC 205_RULMAN_YATAK_SOL MONTAJLI"
                    Node {
                        id: node2100_BASKI_RULO_UC_205_HALKA__ABLON_001
                        objectName: "2100_BASKI RULO_UC 205_HALKA_ÞABLON.001"
                        Model {
                            id: y_kseklik_Ekstr_zyon1_232
                            objectName: "Yükseklik-Ekstrüzyon1.232"
                            source: "meshes/mesh_1466_002_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_UC_205_RULMAN_KAPAK_001
                        objectName: "2100_BASKI RULO_UC 205_RULMAN_KAPAK.001"
                        Model {
                            id: kes_Ekstr_zyon2_048
                            objectName: "Kes-Ekstrüzyon2.048"
                            source: "meshes/mesh_1465_002_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_UC_205_RULMAN_MON_001
                        objectName: "2100_BASKI RULO_UC 205_RULMAN_MON.001"
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_001
                            objectName: "2100_BASKI RULO_UC 205_1.001"
                            Model {
                                id: al_nm__1_1834
                                objectName: "Alýnmýþ1.1834"
                                source: "meshes/mesh_1472_002_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_10_001
                            objectName: "2100_BASKI RULO_UC 205_1_10.001"
                            Model {
                                id: al_nm__1_1840
                                objectName: "Alýnmýþ1.1840"
                                source: "meshes/mesh_1478_002_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_11_001
                            objectName: "2100_BASKI RULO_UC 205_1_11.001"
                            Model {
                                id: al_nm__1_1841
                                objectName: "Alýnmýþ1.1841"
                                source: "meshes/mesh_1479_002_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_12_001
                            objectName: "2100_BASKI RULO_UC 205_1_12.001"
                            Model {
                                id: al_nm__1_1831
                                objectName: "Alýnmýþ1.1831"
                                source: "meshes/mesh_1469_002_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_13_001
                            objectName: "2100_BASKI RULO_UC 205_1_13.001"
                            Model {
                                id: al_nm__1_1832
                                objectName: "Alýnmýþ1.1832"
                                source: "meshes/mesh_1470_002_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_14_001
                            objectName: "2100_BASKI RULO_UC 205_1_14.001"
                            Model {
                                id: al_nm__1_1835
                                objectName: "Alýnmýþ1.1835"
                                source: "meshes/mesh_1473_002_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_3_001
                            objectName: "2100_BASKI RULO_UC 205_1_3.001"
                            Model {
                                id: al_nm__1_1839
                                objectName: "Alýnmýþ1.1839"
                                source: "meshes/mesh_1477_002_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_4_001
                            objectName: "2100_BASKI RULO_UC 205_1_4.001"
                            Model {
                                id: al_nm__1_1837
                                objectName: "Alýnmýþ1.1837"
                                source: "meshes/mesh_1475_002_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_5_001
                            objectName: "2100_BASKI RULO_UC 205_1_5.001"
                            Model {
                                id: al_nm__1_1833
                                objectName: "Alýnmýþ1.1833"
                                source: "meshes/mesh_1471_002_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_6_001
                            objectName: "2100_BASKI RULO_UC 205_1_6.001"
                            Model {
                                id: al_nm__1_1830
                                objectName: "Alýnmýþ1.1830"
                                source: "meshes/mesh_1468_002_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_8_001
                            objectName: "2100_BASKI RULO_UC 205_1_8.001"
                            Model {
                                id: al_nm__1_1838
                                objectName: "Alýnmýþ1.1838"
                                source: "meshes/mesh_1476_002_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_9_001
                            objectName: "2100_BASKI RULO_UC 205_1_9.001"
                            Model {
                                id: al_nm__1_1836
                                objectName: "Alýnmýþ1.1836"
                                source: "meshes/mesh_1474_002_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_UC_205_RULMAN_YATAK_SOL_
                        objectName: "2100_BASKI RULO_UC 205_RULMAN_YATAK SOL_"
                        Model {
                            id: kes_Ekstr_zyon5_003
                            objectName: "Kes-Ekstrüzyon5.003"
                            source: "meshes/mesh_1492_001_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                }
            }
            Node {
                id: node2100_BASKI_RULO_TAKIM_MONTAJLI_001
                objectName: "2100_BASKI RULO_TAKIM_MONTAJLI.001"
                Node {
                    id: node2100_BASKI_RULO_Q_63_P_STON_SA__MONTAJLI_001
                    objectName: "2100_BASKI RULO_Q 63 PÝSTON_SAÐ_MONTAJLI.001"
                    Node {
                        id: node2100_BASKI_RULO_150818_006
                        objectName: "2100_BASKI RULO_150818.006"
                        Model {
                            id: imported1_125
                            objectName: "Imported1.125"
                            source: "meshes/mesh_1486_007_mesh.mesh"
                            materials: [
                                paint__185__188__191__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_150818_007
                        objectName: "2100_BASKI RULO_150818.007"
                        Model {
                            id: imported1_126
                            objectName: "Imported1.126"
                            source: "meshes/mesh_1486_mesh.mesh"
                            materials: [
                                paint__185__188__191__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_155__63_0075_02___02_003
                        objectName: "2100_BASKI RULO_155#_63_0075_02_#-02.003"
                        Node {
                            id: node2100_BASKI_RULO_1320_40_18F_003
                            objectName: "2100_BASKI RULO_1320_40_18F.003"
                            Model {
                                id: al_nm__1_1874
                                objectName: "Alýnmýþ1.1874"
                                source: "meshes/mesh_1488_004_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_1540_503_63_0075_003
                            objectName: "2100_BASKI RULO_1540_503_63_0075.003"
                            Model {
                                id: kes_Ekstr_zyon1_148
                                objectName: "Kes-Ekstrüzyon1.148"
                                source: "meshes/mesh_1487_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_1540_531_63_0075_003
                            objectName: "2100_BASKI RULO_1540_531_63_0075.003"
                            Model {
                                id: kes_Ekstr_zyon3_056
                                objectName: "Kes-Ekstrüzyon3.056"
                                source: "meshes/mesh_1489_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_1563_501_003
                            objectName: "2100_BASKI RULO_1563_501.003"
                            Model {
                                id: al_nm__1_1875
                                objectName: "Alýnmýþ1.1875"
                                source: "meshes/mesh_1490_004_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_1563_502_003
                            objectName: "2100_BASKI RULO_1563_502.003"
                            Model {
                                id: al_nm__1_1876
                                objectName: "Alýnmýþ1.1876"
                                source: "meshes/mesh_1491_004_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_P_STON_FLAN__003
                        objectName: "2100_BASKI RULO_PÝSTON FLANÞ.003"
                        Model {
                            id: _6_5__6_5___ap_Delik1_012
                            objectName: "Ø6.5 (6.5) Çap Delik1.012"
                            source: "meshes/mesh_1485_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_P_STON_U__PLAKA_003
                        objectName: "2100_BASKI RULO_PÝSTON UÇ PLAKA.003"
                        Model {
                            id: kes_Ekstr_zyon2_053
                            objectName: "Kes-Ekstrüzyon2.053"
                            source: "meshes/mesh_1484_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_YATAKLAMA_RULMAN_MONTAJLI_003
                        objectName: "2100_BASKI RULO_YATAKLAMA_RULMAN_MONTAJLI.003"
                        Node {
                            id: node2100_BASKI_RULO_YATAKLAMA_3_MM_PUL_003
                            objectName: "2100_BASKI RULO_YATAKLAMA_3 MM PUL.003"
                            Model {
                                id: boss_Extrude1_122
                                objectName: "Boss-Extrude1.122"
                                source: "meshes/mesh_1481_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_YATAKLAMA_Q_16_X_145_M_L_003
                            objectName: "2100_BASKI RULO_YATAKLAMA_Q 16 X 145_MÝL.003"
                            Model {
                                id: m10_Di_li_Delik2_003
                                objectName: "M10 Diþli Delik2.003"
                                source: "meshes/mesh_1482_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_YATAKLAMA_RULMAN_003
                            objectName: "2100_BASKI RULO_YATAKLAMA_RULMAN.003"
                            Model {
                                id: m6_Di_li_Delik2_007
                                objectName: "M6 Diþli Delik2.007"
                                source: "meshes/mesh_1483_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_YATAKLAMA_RULMANI_16_006
                            objectName: "2100_BASKI RULO_YATAKLAMA_RULMANI 16.006"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_240
                                objectName: "Yükseklik-Ekstrüzyon1.240"
                                source: "meshes/mesh_1480_007_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_YATAKLAMA_RULMANI_16_007
                            objectName: "2100_BASKI RULO_YATAKLAMA_RULMANI 16.007"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_241
                                objectName: "Yükseklik-Ekstrüzyon1.241"
                                source: "meshes/mesh_1480_008_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                    }
                    Node {
                        id: socket_head_cap_screw_am_PreviewCfg_002
                        objectName: "socket head cap screw_am_PreviewCfg.002"
                        Model {
                            id: hex_020
                            objectName: "Hex.020"
                            source: "meshes/mesh_1494_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: node2100_BASKI_RULO_Q_63_P_STON_SOL_MONTAJLI_001
                    objectName: "2100_BASKI RULO_Q 63 PÝSTON_SOL_MONTAJLI.001"
                    Node {
                        id: node2100_BASKI_RULO_150818_004
                        objectName: "2100_BASKI RULO_150818.004"
                        Model {
                            id: imported1_123
                            objectName: "Imported1.123"
                            source: "meshes/mesh_1486_005_mesh.mesh"
                            materials: [
                                paint__185__188__191__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_150818_005
                        objectName: "2100_BASKI RULO_150818.005"
                        Model {
                            id: imported1_124
                            objectName: "Imported1.124"
                            source: "meshes/mesh_1486_006_mesh.mesh"
                            materials: [
                                paint__185__188__191__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_155__63_0075_02___02_002
                        objectName: "2100_BASKI RULO_155#_63_0075_02_#-02.002"
                        Node {
                            id: node2100_BASKI_RULO_1320_40_18F_002
                            objectName: "2100_BASKI RULO_1320_40_18F.002"
                            Model {
                                id: al_nm__1_1858
                                objectName: "Alýnmýþ1.1858"
                                source: "meshes/mesh_1488_003_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_1540_503_63_0075_002
                            objectName: "2100_BASKI RULO_1540_503_63_0075.002"
                            Model {
                                id: kes_Ekstr_zyon1_147
                                objectName: "Kes-Ekstrüzyon1.147"
                                source: "meshes/mesh_1487_003_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_1540_531_63_0075_002
                            objectName: "2100_BASKI RULO_1540_531_63_0075.002"
                            Model {
                                id: kes_Ekstr_zyon3_055
                                objectName: "Kes-Ekstrüzyon3.055"
                                source: "meshes/mesh_1489_003_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_1563_501_002
                            objectName: "2100_BASKI RULO_1563_501.002"
                            Model {
                                id: al_nm__1_1859
                                objectName: "Alýnmýþ1.1859"
                                source: "meshes/mesh_1490_003_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_1563_502_002
                            objectName: "2100_BASKI RULO_1563_502.002"
                            Model {
                                id: al_nm__1_1860
                                objectName: "Alýnmýþ1.1860"
                                source: "meshes/mesh_1491_003_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_P_STON_FLAN__002
                        objectName: "2100_BASKI RULO_PÝSTON FLANÞ.002"
                        Model {
                            id: _6_5__6_5___ap_Delik1_011
                            objectName: "Ø6.5 (6.5) Çap Delik1.011"
                            source: "meshes/mesh_1485_003_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_P_STON_U__PLAKA_002
                        objectName: "2100_BASKI RULO_PÝSTON UÇ PLAKA.002"
                        Model {
                            id: kes_Ekstr_zyon2_051
                            objectName: "Kes-Ekstrüzyon2.051"
                            source: "meshes/mesh_1484_003_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_YATAKLAMA_RULMAN_MONTAJLI_002
                        objectName: "2100_BASKI RULO_YATAKLAMA_RULMAN_MONTAJLI.002"
                        Node {
                            id: node2100_BASKI_RULO_YATAKLAMA_3_MM_PUL_002
                            objectName: "2100_BASKI RULO_YATAKLAMA_3 MM PUL.002"
                            Model {
                                id: boss_Extrude1_121
                                objectName: "Boss-Extrude1.121"
                                source: "meshes/mesh_1481_003_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_YATAKLAMA_Q_16_X_145_M_L_002
                            objectName: "2100_BASKI RULO_YATAKLAMA_Q 16 X 145_MÝL.002"
                            Model {
                                id: m10_Di_li_Delik2_002
                                objectName: "M10 Diþli Delik2.002"
                                source: "meshes/mesh_1482_003_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_YATAKLAMA_RULMAN_002
                            objectName: "2100_BASKI RULO_YATAKLAMA_RULMAN.002"
                            Model {
                                id: m6_Di_li_Delik2_006
                                objectName: "M6 Diþli Delik2.006"
                                source: "meshes/mesh_1483_003_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_YATAKLAMA_RULMANI_16_004
                            objectName: "2100_BASKI RULO_YATAKLAMA_RULMANI 16.004"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_237
                                objectName: "Yükseklik-Ekstrüzyon1.237"
                                source: "meshes/mesh_1480_005_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_YATAKLAMA_RULMANI_16_005
                            objectName: "2100_BASKI RULO_YATAKLAMA_RULMANI 16.005"
                            Model {
                                id: y_kseklik_Ekstr_zyon1_238
                                objectName: "Yükseklik-Ekstrüzyon1.238"
                                source: "meshes/mesh_1480_006_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                    }
                }
                Node {
                    id: node2100_BASKI_RULO_RULO_PUL_002
                    objectName: "2100_BASKI RULO_RULO_PUL.002"
                    Model {
                        id: taban_Flan_1_128
                        objectName: "Taban-Flanþ1.128"
                        source: "meshes/mesh_1493_003_mesh.mesh"
                        materials: [
                            paint__185__188__191__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BASKI_RULO_RULO_PUL_003
                    objectName: "2100_BASKI RULO_RULO_PUL.003"
                    Model {
                        id: taban_Flan_1_129
                        objectName: "Taban-Flanþ1.129"
                        source: "meshes/mesh_1493_mesh.mesh"
                        materials: [
                            paint__185__188__191__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_BASKI_RULO_UC_205_RULMAN_YATAK_SA__MONTAJLI_001
                    objectName: "2100_BASKI RULO_UC 205_RULMAN_YATAK_SAÐ MONTAJLI.001"
                    Node {
                        id: node2100_BASKI_RULO_UC_205_RULMAN_KAPAK_002
                        objectName: "2100_BASKI RULO_UC 205_RULMAN_KAPAK.002"
                        Model {
                            id: kes_Ekstr_zyon2_050
                            objectName: "Kes-Ekstrüzyon2.050"
                            source: "meshes/mesh_1465_003_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_UC_205_RULMAN_MON_002
                        objectName: "2100_BASKI RULO_UC 205_RULMAN_MON.002"
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_002
                            objectName: "2100_BASKI RULO_UC 205_1.002"
                            Model {
                                id: al_nm__1_1850
                                objectName: "Alýnmýþ1.1850"
                                source: "meshes/mesh_1472_003_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_10_002
                            objectName: "2100_BASKI RULO_UC 205_1_10.002"
                            Model {
                                id: al_nm__1_1856
                                objectName: "Alýnmýþ1.1856"
                                source: "meshes/mesh_1478_003_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_11_002
                            objectName: "2100_BASKI RULO_UC 205_1_11.002"
                            Model {
                                id: al_nm__1_1857
                                objectName: "Alýnmýþ1.1857"
                                source: "meshes/mesh_1479_003_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_12_002
                            objectName: "2100_BASKI RULO_UC 205_1_12.002"
                            Model {
                                id: al_nm__1_1847
                                objectName: "Alýnmýþ1.1847"
                                source: "meshes/mesh_1469_003_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_13_002
                            objectName: "2100_BASKI RULO_UC 205_1_13.002"
                            Model {
                                id: al_nm__1_1848
                                objectName: "Alýnmýþ1.1848"
                                source: "meshes/mesh_1470_003_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_14_002
                            objectName: "2100_BASKI RULO_UC 205_1_14.002"
                            Model {
                                id: al_nm__1_1851
                                objectName: "Alýnmýþ1.1851"
                                source: "meshes/mesh_1473_003_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_3_002
                            objectName: "2100_BASKI RULO_UC 205_1_3.002"
                            Model {
                                id: al_nm__1_1855
                                objectName: "Alýnmýþ1.1855"
                                source: "meshes/mesh_1477_003_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_4_002
                            objectName: "2100_BASKI RULO_UC 205_1_4.002"
                            Model {
                                id: al_nm__1_1853
                                objectName: "Alýnmýþ1.1853"
                                source: "meshes/mesh_1475_003_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_5_002
                            objectName: "2100_BASKI RULO_UC 205_1_5.002"
                            Model {
                                id: al_nm__1_1849
                                objectName: "Alýnmýþ1.1849"
                                source: "meshes/mesh_1471_003_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_6_002
                            objectName: "2100_BASKI RULO_UC 205_1_6.002"
                            Model {
                                id: al_nm__1_1846
                                objectName: "Alýnmýþ1.1846"
                                source: "meshes/mesh_1468_003_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_7_002
                            objectName: "2100_BASKI RULO_UC 205_1_7.002"
                            Model {
                                id: al_nm__1_1845
                                objectName: "Alýnmýþ1.1845"
                                source: "meshes/mesh_1467_003_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_8_002
                            objectName: "2100_BASKI RULO_UC 205_1_8.002"
                            Model {
                                id: al_nm__1_1854
                                objectName: "Alýnmýþ1.1854"
                                source: "meshes/mesh_1476_003_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_9_002
                            objectName: "2100_BASKI RULO_UC 205_1_9.002"
                            Model {
                                id: al_nm__1_1852
                                objectName: "Alýnmýþ1.1852"
                                source: "meshes/mesh_1474_003_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_UC_205_RULMAN_YATAK_SA___001
                        objectName: "2100_BASKI RULO_UC 205_RULMAN_YATAK SAÐ_.001"
                        Model {
                            id: kes_Ekstr_zyon8_002
                            objectName: "Kes-Ekstrüzyon8.002"
                            source: "meshes/mesh_1464_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: node2100_BASKI_RULO_UC_205_RULMAN_YATAK_SOL_MONTAJLI_001
                    objectName: "2100_BASKI RULO_UC 205_RULMAN_YATAK_SOL MONTAJLI.001"
                    Node {
                        id: node2100_BASKI_RULO_UC_205_HALKA__ABLON_003
                        objectName: "2100_BASKI RULO_UC 205_HALKA_ÞABLON.003"
                        Model {
                            id: y_kseklik_Ekstr_zyon1_239
                            objectName: "Yükseklik-Ekstrüzyon1.239"
                            source: "meshes/mesh_1466_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_UC_205_RULMAN_KAPAK_003
                        objectName: "2100_BASKI RULO_UC 205_RULMAN_KAPAK.003"
                        Model {
                            id: kes_Ekstr_zyon2_052
                            objectName: "Kes-Ekstrüzyon2.052"
                            source: "meshes/mesh_1465_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_UC_205_RULMAN_MON_003
                        objectName: "2100_BASKI RULO_UC 205_RULMAN_MON.003"
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_003
                            objectName: "2100_BASKI RULO_UC 205_1.003"
                            Model {
                                id: al_nm__1_1866
                                objectName: "Alýnmýþ1.1866"
                                source: "meshes/mesh_1472_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_10_003
                            objectName: "2100_BASKI RULO_UC 205_1_10.003"
                            Model {
                                id: al_nm__1_1872
                                objectName: "Alýnmýþ1.1872"
                                source: "meshes/mesh_1478_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_11_003
                            objectName: "2100_BASKI RULO_UC 205_1_11.003"
                            Model {
                                id: al_nm__1_1873
                                objectName: "Alýnmýþ1.1873"
                                source: "meshes/mesh_1479_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_12_003
                            objectName: "2100_BASKI RULO_UC 205_1_12.003"
                            Model {
                                id: al_nm__1_1863
                                objectName: "Alýnmýþ1.1863"
                                source: "meshes/mesh_1469_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_13_003
                            objectName: "2100_BASKI RULO_UC 205_1_13.003"
                            Model {
                                id: al_nm__1_1864
                                objectName: "Alýnmýþ1.1864"
                                source: "meshes/mesh_1470_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_14_003
                            objectName: "2100_BASKI RULO_UC 205_1_14.003"
                            Model {
                                id: al_nm__1_1867
                                objectName: "Alýnmýþ1.1867"
                                source: "meshes/mesh_1473_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_3_003
                            objectName: "2100_BASKI RULO_UC 205_1_3.003"
                            Model {
                                id: al_nm__1_1871
                                objectName: "Alýnmýþ1.1871"
                                source: "meshes/mesh_1477_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_4_003
                            objectName: "2100_BASKI RULO_UC 205_1_4.003"
                            Model {
                                id: al_nm__1_1869
                                objectName: "Alýnmýþ1.1869"
                                source: "meshes/mesh_1475_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_5_003
                            objectName: "2100_BASKI RULO_UC 205_1_5.003"
                            Model {
                                id: al_nm__1_1865
                                objectName: "Alýnmýþ1.1865"
                                source: "meshes/mesh_1471_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_6_003
                            objectName: "2100_BASKI RULO_UC 205_1_6.003"
                            Model {
                                id: al_nm__1_1862
                                objectName: "Alýnmýþ1.1862"
                                source: "meshes/mesh_1468_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_8_003
                            objectName: "2100_BASKI RULO_UC 205_1_8.003"
                            Model {
                                id: al_nm__1_1870
                                objectName: "Alýnmýþ1.1870"
                                source: "meshes/mesh_1476_mesh.mesh"
                                materials: [
                                    paint__185__188__191__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_BASKI_RULO_UC_205_1_9_003
                            objectName: "2100_BASKI RULO_UC 205_1_9.003"
                            Model {
                                id: al_nm__1_1868
                                objectName: "Alýnmýþ1.1868"
                                source: "meshes/mesh_1474_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                    }
                    Node {
                        id: node2100_BASKI_RULO_UC_205_RULMAN_YATAK_SOL__001
                        objectName: "2100_BASKI RULO_UC 205_RULMAN_YATAK SOL_.001"
                        Model {
                            id: kes_Ekstr_zyon5_004
                            objectName: "Kes-Ekstrüzyon5.004"
                            source: "meshes/mesh_1492_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                }
            }
            Model {
                id: makine3_par_a_005
                objectName: "makine3-parça.005"
                position: Qt.vector3d(0.283861, 0.959116, -0.309747)
                rotation: Qt.quaternion(5.96047e-08, 0, 0.707107, -0.707107)
                scale: Qt.vector3d(0.00615084, 0.00615084, 0.00615084)
                source: "meshes/shape_021_mesh.mesh"
                materials: [
                    paint__190__190__168__102__material
                ]
            }
        }



        Node {
            id: node9KW_001
            objectName: "9KW.001"
            position: Qt.vector3d(0, 0.704551, 0)
            x: node.axisX; z: node.axisY; y: 0.704551 + node.axisZ
            Node {
                id: node2100_FREZE_MOT_HSD_2_BR_MOTOR_KAMA
                objectName: "2100_FREZE MOT_HSD 2_BR_MOTOR KAMA"
                Model {
                    id: boss_Extrude1_123
                    objectName: "Boss-Extrude1.123"
                    source: "meshes/mesh_1832_mesh.mesh"
                    materials: [
                        paint__55__55__55__255__material
                    ]
                }
            }
            Node {
                id: node2100_FREZE_MOT_HSD_2_BR__ASE_001
                objectName: "2100_FREZE MOT_HSD 2_BR_ÞASE.001"
                Model {
                    id: _8_0__8___ap_Delik2_001
                    objectName: "Ø8.0 (8) Çap Delik2.001"
                    source: "meshes/mesh_1792_mesh.mesh"
                    materials: [
                        paint__55__55__55__255__material
                    ]
                }
            }
            Node {
                id: node2100_FREZE_MOT_HSD_2_K_R_K_MONTAJLI
                objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_MONTAJLI"
                Node {
                    id: node2100_FREZE_MOT_HSD_2_BR_K_R_K_YATAKLAMA_MONTAJLI_001
                    objectName: "2100_FREZE MOT_HSD 2_BR_KÖRÜK_YATAKLAMA_MONTAJLI.001"
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_BR_Q_16_M_L_001
                        objectName: "2100_FREZE MOT_HSD 2_BR_Q 16 MÝL.001"
                        Model {
                            id: m8_Di_li_Delik1_050
                            objectName: "M8 Diþli Delik1.050"
                            source: "meshes/mesh_1790_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: k_R_K_RUL__YAT__1_007
                        objectName: "KÖRÜK RUL. YAT._1.007"
                        Model {
                            id: m6_Di_li_Delik3_001
                            objectName: "M6 Diþli Delik3.001"
                            source: "meshes/mesh_1791_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: yataklama_RULMAN_Q16_002
                        objectName: "YATAKLAMA RULMAN Q16.002"
                        Model {
                            id: y_kseklik_Ekstr_zyon1_302
                            objectName: "Yükseklik-Ekstrüzyon1.302"
                            source: "meshes/mesh_1639_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: node2100_FREZE_MOT_HSD_2_BR_YATAK_K_L_T_FREN_GURUBU_001
                    objectName: "2100_FREZE MOT_HSD 2_BR_YATAK_KÝLÝT_FREN GURUBU.001"
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_BR_YATAK_K_L_T_ARABA_K_L_T_YAYI_004
                        objectName: "2100_FREZE MOT_HSD 2_BR_YATAK_KÝLÝT_ARABA KÝLÝT YAYI.004"
                        Model {
                            id: y_zeyKesimi2_004
                            objectName: "YüzeyKesimi2.004"
                            source: "meshes/mesh_1783_005_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_BR_YATAK_K_L_T_ARABA_K_L_T_YAYI_005
                        objectName: "2100_FREZE MOT_HSD 2_BR_YATAK_KÝLÝT_ARABA KÝLÝT YAYI.005"
                        Model {
                            id: y_zeyKesimi2_005
                            objectName: "YüzeyKesimi2.005"
                            source: "meshes/mesh_1783_006_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_BR_YATAK_K_L_T_ARABA_K_L_T_YAYI_006
                        objectName: "2100_FREZE MOT_HSD 2_BR_YATAK_KÝLÝT_ARABA KÝLÝT YAYI.006"
                        Model {
                            id: y_zeyKesimi2_006
                            objectName: "YüzeyKesimi2.006"
                            source: "meshes/mesh_1783_007_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_BR_YATAK_K_L_T_ARABA_K_L_T_YAYI_007
                        objectName: "2100_FREZE MOT_HSD 2_BR_YATAK_KÝLÝT_ARABA KÝLÝT YAYI.007"
                        Model {
                            id: y_zeyKesimi2_007
                            objectName: "YüzeyKesimi2.007"
                            source: "meshes/mesh_1783_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_BR_YATAK_K_L_T_ARABA_OR_NG_50_X_1_002
                        objectName: "2100_FREZE MOT_HSD 2_BR_YATAK_KÝLÝT_ARABA ORÝNG 50 X 1.002"
                        Model {
                            id: s_p_r1_003
                            objectName: "Süpür1.003"
                            source: "meshes/mesh_1785_003_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_BR_YATAK_K_L_T_ARABA_OR_NG_50_X_1_003
                        objectName: "2100_FREZE MOT_HSD 2_BR_YATAK_KÝLÝT_ARABA ORÝNG 50 X 1.003"
                        Model {
                            id: s_p_r1_004
                            objectName: "Süpür1.004"
                            source: "meshes/mesh_1785_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_BR_YATAK_K_L_T_KAPAK_002
                        objectName: "2100_FREZE MOT_HSD 2_BR_YATAK_KÝLÝT_KAPAK.002"
                        Model {
                            id: m5_Di_li_Delik2_002
                            objectName: "M5 Diþli Delik2.002"
                            source: "meshes/mesh_1788_003_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_BR_YATAK_K_L_T_KAPAK_003
                        objectName: "2100_FREZE MOT_HSD 2_BR_YATAK_KÝLÝT_KAPAK.003"
                        Model {
                            id: m5_Di_li_Delik2_003
                            objectName: "M5 Diþli Delik2.003"
                            source: "meshes/mesh_1788_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_BR_YATAK_K_L_T_KE_E_K54_050_50X41X3_002
                        objectName: "2100_FREZE MOT_HSD 2_BR_YATAK_KÝLÝT_KEÇE_K54-050-50X41X3.002"
                        Model {
                            id: radyus1_158
                            objectName: "Radyus1.158"
                            source: "meshes/mesh_1782_003_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_BR_YATAK_K_L_T_KE_E_K54_050_50X41X3_003
                        objectName: "2100_FREZE MOT_HSD 2_BR_YATAK_KÝLÝT_KEÇE_K54-050-50X41X3.003"
                        Model {
                            id: radyus1_159
                            objectName: "Radyus1.159"
                            source: "meshes/mesh_1782_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_BR_YATAK_K_L_T_K_L_T_G_VDE_001
                        objectName: "2100_FREZE MOT_HSD 2_BR_YATAK_KÝLÝT_KÝLÝT GÖVDE.001"
                        Model {
                            id: m3_Di_li_Delik1_001
                            objectName: "M3 Diþli Delik1.001"
                            source: "meshes/mesh_1789_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_BR_YATAK_K_L_T_M_L_ARA_TAKOZ_1_002
                        objectName: "2100_FREZE MOT_HSD 2_BR_YATAK_KÝLÝT_MÝL ARA TAKOZ_1.002"
                        Model {
                            id: _4_5__4_5___ap_Delik1_004
                            objectName: "Ø4.5 (4.5) Çap Delik1.004"
                            source: "meshes/mesh_1779_003_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_BR_YATAK_K_L_T_M_L_ARA_TAKOZ_1_003
                        objectName: "2100_FREZE MOT_HSD 2_BR_YATAK_KÝLÝT_MÝL ARA TAKOZ_1.003"
                        Model {
                            id: _4_5__4_5___ap_Delik1_005
                            objectName: "Ø4.5 (4.5) Çap Delik1.005"
                            source: "meshes/mesh_1779_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_BR_YATAK_K_L_T_Q_16_M_L_001
                        objectName: "2100_FREZE MOT_HSD 2_BR_YATAK_KÝLÝT_Q 16 MÝL.001"
                        Model {
                            id: y_kseklik_Ekstr_zyon1_305
                            objectName: "Yükseklik-Ekstrüzyon1.305"
                            source: "meshes/mesh_1787_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_BR_YATAK_K_L_T_Q50_P_STON_M_L__002
                        objectName: "2100_FREZE MOT_HSD 2_BR_YATAK_KÝLÝT_Q50 PÝSTON MÝLÝ.002"
                        Model {
                            id: kes_Ekstr_zyon2_063
                            objectName: "Kes-Ekstrüzyon2.063"
                            source: "meshes/mesh_1786_003_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_BR_YATAK_K_L_T_Q50_P_STON_M_L__003
                        objectName: "2100_FREZE MOT_HSD 2_BR_YATAK_KÝLÝT_Q50 PÝSTON MÝLÝ.003"
                        Model {
                            id: kes_Ekstr_zyon2_064
                            objectName: "Kes-Ekstrüzyon2.064"
                            source: "meshes/mesh_1786_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_BR_YATAK_K_L_T_RGR540_LIBR_002
                        objectName: "2100_FREZE MOT_HSD 2_BR_YATAK_KÝLÝT_RGR540_LIBR.002"
                        Model {
                            id: solido1_002
                            objectName: "Solido1.002"
                            source: "meshes/mesh_1784_003_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_BR_YATAK_K_L_T_RGR540_LIBR_003
                        objectName: "2100_FREZE MOT_HSD 2_BR_YATAK_KÝLÝT_RGR540_LIBR.003"
                        Model {
                            id: solido1_003
                            objectName: "Solido1.003"
                            source: "meshes/mesh_1784_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_BR_YATAK_K_L_T_SENS_R_KAM_SAC_001
                        objectName: "2100_FREZE MOT_HSD 2_BR_YATAK_KÝLÝT_SENSÖR KAM SAC.001"
                        Model {
                            id: l_o_altma2_015
                            objectName: "LÇoðaltma2.015"
                            source: "meshes/mesh_1780_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_BR_YATAK_K_L_T_YATAKLAMA_RULMANI_16_001
                        objectName: "2100_FREZE MOT_HSD 2_BR_YATAK_KÝLÝT_YATAKLAMA RULMANI 16.001"
                        Model {
                            id: y_kseklik_Ekstr_zyon1_304
                            objectName: "Yükseklik-Ekstrüzyon1.304"
                            source: "meshes/mesh_1480_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: sens_R_pm_r45_002
                        objectName: "SENSÖR_pm-r45.002"
                        Model {
                            id: al_nm__1_2111
                            objectName: "Alýnmýþ1.2111"
                            source: "meshes/mesh_1781_003_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: sens_R_pm_r45_003
                        objectName: "SENSÖR_pm-r45.003"
                        Model {
                            id: al_nm__1_2112
                            objectName: "Alýnmýþ1.2112"
                            source: "meshes/mesh_1781_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: node2100_FREZE_MOT_HSD_2_KORUK_ALT_SA__KAYNAK
                    objectName: "2100_FREZE MOT_HSD 2_KORUK_ALT SAÇ KAYNAK"
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_K_R_K_ALT_FIR_A_SACI
                        objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_ALT FIRÇA SACI"
                        Model {
                            id: taban_Flan_1_148
                            objectName: "Taban-Flanþ1.148"
                            source: "meshes/mesh_1775_003_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_K_R_K_ALT_FIR_A_SACI_2
                        objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_ALT FIRÇA SACI 2"
                        Model {
                            id: taban_Flan_1_147
                            objectName: "Taban-Flanþ1.147"
                            source: "meshes/mesh_1777_003_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_K_R_K_ALT_FIR_A_SACI_2_001
                        objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_ALT FIRÇA SACI 2.001"
                        Model {
                            id: taban_Flan_1_149
                            objectName: "Taban-Flanþ1.149"
                            source: "meshes/mesh_1777_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_K_R_K_ALT_FIR_A_SACI_001
                        objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_ALT FIRÇA SACI.001"
                        Model {
                            id: taban_Flan_1_150
                            objectName: "Taban-Flanþ1.150"
                            source: "meshes/mesh_1775_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_K_R_K_ALT_PLAKA_2
                        objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_ALT PLAKA 2"
                        Model {
                            id: kes_Ekstr_zyon1_193
                            objectName: "Kes-Ekstrüzyon1.193"
                            source: "meshes/mesh_1778_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_K_R_K_FIR_A
                        objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_FIRÇA"
                        Model {
                            id: y_kseklik_Ekstr_zyon2_017
                            objectName: "Yükseklik-Ekstrüzyon2.017"
                            source: "meshes/mesh_1842_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_K_R_K_SAC
                        objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_SAC"
                        Model {
                            id: y_kseklik_Ekstr_zyon1_307
                            objectName: "Yükseklik-Ekstrüzyon1.307"
                            source: "meshes/mesh_1843_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: node2100_FREZE_MOT_HSD_2_K_R_K_ALT_PLAKA_KAPAK
                    objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_ALT PLAKA_KAPAK"
                    Model {
                        id: _6_5__6_5___ap_Delik1_015
                        objectName: "Ø6.5 (6.5) Çap Delik1.015"
                        source: "meshes/mesh_1767_mesh.mesh"
                        materials: [
                            paint__55__55__55__255__material
                        ]
                    }
                }
                Node {
                    id: node2100_FREZE_MOT_HSD_2_K_R_K__ST_PLAKA_KAYNAK
                    objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_ÜST PLAKA_KAYNAK"
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_KAPAK_2
                        objectName: "2100_FREZE MOT_HSD 2_KAPAK 2"
                        Model {
                            id: taban_Flan_1_146
                            objectName: "Taban-Flanþ1.146"
                            source: "meshes/mesh_1757_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_KAPAK_3
                        objectName: "2100_FREZE MOT_HSD 2_KAPAK 3"
                        Model {
                            id: kenar_Flan_1_012
                            objectName: "Kenar-Flanþ1.012"
                            source: "meshes/mesh_1835_001_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_KAPAK_3_001
                        objectName: "2100_FREZE MOT_HSD 2_KAPAK 3.001"
                        Model {
                            id: kenar_Flan_1_014
                            objectName: "Kenar-Flanþ1.014"
                            source: "meshes/mesh_1835_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_KAPAK_4_SA_
                        objectName: "2100_FREZE MOT_HSD 2_KAPAK 4_SAÐ"
                        Model {
                            id: kes_Ekstr_zyon1_191
                            objectName: "Kes-Ekstrüzyon1.191"
                            source: "meshes/mesh_1837_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_KAPAK_4_SOL
                        objectName: "2100_FREZE MOT_HSD 2_KAPAK 4_SOL"
                        Model {
                            id: radyus1_157
                            objectName: "Radyus1.157"
                            source: "meshes/mesh_1841_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_KAPAK_5
                        objectName: "2100_FREZE MOT_HSD 2_KAPAK 5"
                        Model {
                            id: kenar_Flan_1_013
                            objectName: "Kenar-Flanþ1.013"
                            source: "meshes/mesh_1765_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_K_R_K_ALT_PLAKA
                        objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_ALT PLAKA"
                        Model {
                            id: kes_Ekstr_zyon7_002
                            objectName: "Kes-Ekstrüzyon7.002"
                            source: "meshes/mesh_1839_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_K_R_K_L_MONTAJ_AYAK
                        objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_L MONTAJ AYAK"
                        Model {
                            id: kes_Ekstr_zyon2_062
                            objectName: "Kes-Ekstrüzyon2.062"
                            source: "meshes/mesh_1840_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_K_R_K__ST_PLAKA_
                        objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_ÜST PLAKA_"
                        Model {
                            id: radyus3_005
                            objectName: "Radyus3.005"
                            source: "meshes/mesh_1834_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_TOZ_EM___145_MM_BORU
                        objectName: "2100_FREZE MOT_HSD 2_TOZ EMÝÞ_145 MM BORU"
                        Model {
                            id: y_kseklik_Ekstr_zyon1_301
                            objectName: "Yükseklik-Ekstrüzyon1.301"
                            source: "meshes/mesh_1766_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2__ST_PLAKA_2
                        objectName: "2100_FREZE MOT_HSD 2_ÜST PLAKA 2"
                        Model {
                            id: kes_Ekstr_zyon1_192
                            objectName: "Kes-Ekstrüzyon1.192"
                            source: "meshes/mesh_1838_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2____D_KEY_SA__SA_
                        objectName: "2100_FREZE MOT_HSD 2_ÝÇ DÝKEY_SAÐ_SAÇ"
                        Model {
                            id: radyus1_156
                            objectName: "Radyus1.156"
                            source: "meshes/mesh_1836_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2____D_KEY_SOL_SA_
                        objectName: "2100_FREZE MOT_HSD 2_ÝÇ DÝKEY_SOL_SAÇ"
                        Model {
                            id: radyus1_155
                            objectName: "Radyus1.155"
                            source: "meshes/mesh_1833_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: node2100_FREZE_MOT_HSD_2_K_R_K__MALAT
                    objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_ÝMALAT"
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_K_R_K_SA_
                        objectName: "2100_FREZE MOT_HSD 2_KÖRÜK SAÇ"
                        Model {
                            id: _5_5__5_5___ap_Delik9_002
                            objectName: "Ø5.5 (5.5) Çap Delik9.002"
                            source: "meshes/mesh_1770_003_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_K_R_K_SA__001
                        objectName: "2100_FREZE MOT_HSD 2_KÖRÜK SAÇ.001"
                        Model {
                            id: _5_5__5_5___ap_Delik9_003
                            objectName: "Ø5.5 (5.5) Çap Delik9.003"
                            source: "meshes/mesh_1770_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_K_R_K_KALIP_130_MONTAJLI
                        objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_KALIP 130_MONTAJLI"
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_KALIP_132
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM KALIP 132"
                            Model {
                                id: fillet1_090
                                objectName: "Fillet1.090"
                                source: "meshes/mesh_1772_005_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_KALIP_132_001
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM KALIP 132.001"
                            Model {
                                id: fillet1_094
                                objectName: "Fillet1.094"
                                source: "meshes/mesh_1772_006_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_132
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 132"
                            Model {
                                id: fillet1_086
                                objectName: "Fillet1.086"
                                source: "meshes/mesh_1771_029_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_132_001
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 132.001"
                            Model {
                                id: fillet1_087
                                objectName: "Fillet1.087"
                                source: "meshes/mesh_1771_030_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_132_002
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 132.002"
                            Model {
                                id: fillet1_088
                                objectName: "Fillet1.088"
                                source: "meshes/mesh_1771_031_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_132_003
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 132.003"
                            Model {
                                id: fillet1_089
                                objectName: "Fillet1.089"
                                source: "meshes/mesh_1771_032_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_132_004
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 132.004"
                            Model {
                                id: fillet1_091
                                objectName: "Fillet1.091"
                                source: "meshes/mesh_1771_033_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_132_005
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 132.005"
                            Model {
                                id: fillet1_092
                                objectName: "Fillet1.092"
                                source: "meshes/mesh_1771_034_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_132_006
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 132.006"
                            Model {
                                id: fillet1_093
                                objectName: "Fillet1.093"
                                source: "meshes/mesh_1771_035_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_132_007
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 132.007"
                            Model {
                                id: fillet1_095
                                objectName: "Fillet1.095"
                                source: "meshes/mesh_1771_036_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_132_008
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 132.008"
                            Model {
                                id: fillet1_096
                                objectName: "Fillet1.096"
                                source: "meshes/mesh_1771_037_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_132_009
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 132.009"
                            Model {
                                id: fillet1_097
                                objectName: "Fillet1.097"
                                source: "meshes/mesh_1771_038_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_132_010
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 132.010"
                            Model {
                                id: fillet1_098
                                objectName: "Fillet1.098"
                                source: "meshes/mesh_1771_039_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_132_011
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 132.011"
                            Model {
                                id: fillet1_099
                                objectName: "Fillet1.099"
                                source: "meshes/mesh_1771_040_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_132_012
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 132.012"
                            Model {
                                id: fillet1_100
                                objectName: "Fillet1.100"
                                source: "meshes/mesh_1771_041_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_132_013
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 132.013"
                            Model {
                                id: fillet1_101
                                objectName: "Fillet1.101"
                                source: "meshes/mesh_1771_042_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_K_R_K_KALIP_130_MONTAJLI_001
                        objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_KALIP 130_MONTAJLI.001"
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_KALIP_132_002
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM KALIP 132.002"
                            Model {
                                id: fillet1_122
                                objectName: "Fillet1.122"
                                source: "meshes/mesh_1772_007_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_KALIP_132_003
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM KALIP 132.003"
                            Model {
                                id: fillet1_126
                                objectName: "Fillet1.126"
                                source: "meshes/mesh_1772_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_132_014
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 132.014"
                            Model {
                                id: fillet1_118
                                objectName: "Fillet1.118"
                                source: "meshes/mesh_1771_043_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_132_015
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 132.015"
                            Model {
                                id: fillet1_119
                                objectName: "Fillet1.119"
                                source: "meshes/mesh_1771_044_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_132_016
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 132.016"
                            Model {
                                id: fillet1_120
                                objectName: "Fillet1.120"
                                source: "meshes/mesh_1771_045_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_132_017
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 132.017"
                            Model {
                                id: fillet1_121
                                objectName: "Fillet1.121"
                                source: "meshes/mesh_1771_046_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_132_018
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 132.018"
                            Model {
                                id: fillet1_123
                                objectName: "Fillet1.123"
                                source: "meshes/mesh_1771_047_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_132_019
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 132.019"
                            Model {
                                id: fillet1_124
                                objectName: "Fillet1.124"
                                source: "meshes/mesh_1771_048_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_132_020
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 132.020"
                            Model {
                                id: fillet1_125
                                objectName: "Fillet1.125"
                                source: "meshes/mesh_1771_049_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_132_021
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 132.021"
                            Model {
                                id: fillet1_127
                                objectName: "Fillet1.127"
                                source: "meshes/mesh_1771_050_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_132_022
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 132.022"
                            Model {
                                id: fillet1_128
                                objectName: "Fillet1.128"
                                source: "meshes/mesh_1771_051_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_132_023
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 132.023"
                            Model {
                                id: fillet1_129
                                objectName: "Fillet1.129"
                                source: "meshes/mesh_1771_052_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_132_024
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 132.024"
                            Model {
                                id: fillet1_130
                                objectName: "Fillet1.130"
                                source: "meshes/mesh_1771_053_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_132_025
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 132.025"
                            Model {
                                id: fillet1_131
                                objectName: "Fillet1.131"
                                source: "meshes/mesh_1771_054_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_132_026
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 132.026"
                            Model {
                                id: fillet1_132
                                objectName: "Fillet1.132"
                                source: "meshes/mesh_1771_055_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_132_027
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 132.027"
                            Model {
                                id: fillet1_133
                                objectName: "Fillet1.133"
                                source: "meshes/mesh_1771_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_K_R_K_KALIP_260_MONTAJLI
                        objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_KALIP 260_MONTAJLI"
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_KALIP_260
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM KALIP 260"
                            Model {
                                id: fillet1_106
                                objectName: "Fillet1.106"
                                source: "meshes/mesh_1774_005_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_KALIP_260_001
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM KALIP 260.001"
                            Model {
                                id: fillet1_116
                                objectName: "Fillet1.116"
                                source: "meshes/mesh_1774_006_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_260
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 260"
                            Model {
                                id: fillet1_102
                                objectName: "Fillet1.102"
                                source: "meshes/mesh_1773_029_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_260_001
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 260.001"
                            Model {
                                id: fillet1_103
                                objectName: "Fillet1.103"
                                source: "meshes/mesh_1773_030_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_260_002
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 260.002"
                            Model {
                                id: fillet1_104
                                objectName: "Fillet1.104"
                                source: "meshes/mesh_1773_031_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_260_003
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 260.003"
                            Model {
                                id: fillet1_105
                                objectName: "Fillet1.105"
                                source: "meshes/mesh_1773_032_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_260_004
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 260.004"
                            Model {
                                id: fillet1_107
                                objectName: "Fillet1.107"
                                source: "meshes/mesh_1773_033_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_260_005
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 260.005"
                            Model {
                                id: fillet1_108
                                objectName: "Fillet1.108"
                                source: "meshes/mesh_1773_034_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_260_006
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 260.006"
                            Model {
                                id: fillet1_109
                                objectName: "Fillet1.109"
                                source: "meshes/mesh_1773_035_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_260_007
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 260.007"
                            Model {
                                id: fillet1_110
                                objectName: "Fillet1.110"
                                source: "meshes/mesh_1773_036_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_260_008
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 260.008"
                            Model {
                                id: fillet1_111
                                objectName: "Fillet1.111"
                                source: "meshes/mesh_1773_037_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_260_009
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 260.009"
                            Model {
                                id: fillet1_112
                                objectName: "Fillet1.112"
                                source: "meshes/mesh_1773_038_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_260_010
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 260.010"
                            Model {
                                id: fillet1_113
                                objectName: "Fillet1.113"
                                source: "meshes/mesh_1773_039_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_260_011
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 260.011"
                            Model {
                                id: fillet1_114
                                objectName: "Fillet1.114"
                                source: "meshes/mesh_1773_040_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_260_012
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 260.012"
                            Model {
                                id: fillet1_115
                                objectName: "Fillet1.115"
                                source: "meshes/mesh_1773_041_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_260_013
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 260.013"
                            Model {
                                id: fillet1_117
                                objectName: "Fillet1.117"
                                source: "meshes/mesh_1773_042_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_HSD_2_K_R_K_KALIP_260_MONTAJLI_001
                        objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_KALIP 260_MONTAJLI.001"
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_KALIP_260_002
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM KALIP 260.002"
                            Model {
                                id: fillet1_137
                                objectName: "Fillet1.137"
                                source: "meshes/mesh_1774_007_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_KALIP_260_003
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM KALIP 260.003"
                            Model {
                                id: fillet1_147
                                objectName: "Fillet1.147"
                                source: "meshes/mesh_1774_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_260_014
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 260.014"
                            Model {
                                id: fillet1_134
                                objectName: "Fillet1.134"
                                source: "meshes/mesh_1773_043_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_260_016
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 260.016"
                            Model {
                                id: fillet1_135
                                objectName: "Fillet1.135"
                                source: "meshes/mesh_1773_044_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_260_017
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 260.017"
                            Model {
                                id: fillet1_136
                                objectName: "Fillet1.136"
                                source: "meshes/mesh_1773_045_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_260_018
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 260.018"
                            Model {
                                id: fillet1_138
                                objectName: "Fillet1.138"
                                source: "meshes/mesh_1773_046_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_260_019
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 260.019"
                            Model {
                                id: fillet1_139
                                objectName: "Fillet1.139"
                                source: "meshes/mesh_1773_047_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_260_020
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 260.020"
                            Model {
                                id: fillet1_140
                                objectName: "Fillet1.140"
                                source: "meshes/mesh_1773_048_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_260_021
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 260.021"
                            Model {
                                id: fillet1_141
                                objectName: "Fillet1.141"
                                source: "meshes/mesh_1773_049_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_260_022
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 260.022"
                            Model {
                                id: fillet1_142
                                objectName: "Fillet1.142"
                                source: "meshes/mesh_1773_050_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_260_023
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 260.023"
                            Model {
                                id: fillet1_143
                                objectName: "Fillet1.143"
                                source: "meshes/mesh_1773_051_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_260_024
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 260.024"
                            Model {
                                id: fillet1_144
                                objectName: "Fillet1.144"
                                source: "meshes/mesh_1773_052_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_260_025
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 260.025"
                            Model {
                                id: fillet1_145
                                objectName: "Fillet1.145"
                                source: "meshes/mesh_1773_053_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_260_026
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 260.026"
                            Model {
                                id: fillet1_146
                                objectName: "Fillet1.146"
                                source: "meshes/mesh_1773_054_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: node2100_FREZE_MOT_HSD_2_K_R_K_15_MM_LAMA_260_027
                            objectName: "2100_FREZE MOT_HSD 2_KÖRÜK_15 MM LAMA 260.027"
                            Model {
                                id: fillet1_148
                                objectName: "Fillet1.148"
                                source: "meshes/mesh_1773_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                    }
                }
                Node {
                    id: node2100_FREZE_MOT_K_R_K_1280_20_0130_002
                    objectName: "2100_FREZE MOT_KÖRÜK_1280_20_0130.002"
                    Node {
                        id: node2100_FREZE_MOT_K_R_K_1200_20_05_002
                        objectName: "2100_FREZE MOT_KÖRÜK_1200_20_05.002"
                        Model {
                            id: imported1_155
                            objectName: "Imported1.155"
                            source: "meshes/mesh_435_014_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_K_R_K_1200_20_06_004
                        objectName: "2100_FREZE MOT_KÖRÜK_1200_20_06.004"
                        Model {
                            id: imported1_156
                            objectName: "Imported1.156"
                            source: "meshes/mesh_434_023_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_K_R_K_1200_20_06_005
                        objectName: "2100_FREZE MOT_KÖRÜK_1200_20_06.005"
                        Model {
                            id: imported1_157
                            objectName: "Imported1.157"
                            source: "meshes/mesh_434_024_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_K_R_K_C1280_20_130_002
                        objectName: "2100_FREZE MOT_KÖRÜK_C1280_20_130.002"
                        Model {
                            id: imported1_158
                            objectName: "Imported1.158"
                            source: "meshes/mesh_1769_003_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_K_R_K_S1280_20_130_002
                        objectName: "2100_FREZE MOT_KÖRÜK_S1280_20_130.002"
                        Model {
                            id: y_kseklik_Ekstr_zyon1_303
                            objectName: "Yükseklik-Ekstrüzyon1.303"
                            source: "meshes/mesh_1768_003_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: node2100_FREZE_MOT_K_R_K_1280_20_0130_003
                    objectName: "2100_FREZE MOT_KÖRÜK_1280_20_0130.003"
                    Node {
                        id: node2100_FREZE_MOT_K_R_K_1200_20_05_003
                        objectName: "2100_FREZE MOT_KÖRÜK_1200_20_05.003"
                        Model {
                            id: imported1_159
                            objectName: "Imported1.159"
                            source: "meshes/mesh_435_002_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_K_R_K_1200_20_06_006
                        objectName: "2100_FREZE MOT_KÖRÜK_1200_20_06.006"
                        Model {
                            id: imported1_160
                            objectName: "Imported1.160"
                            source: "meshes/mesh_434_025_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_K_R_K_1200_20_06_007
                        objectName: "2100_FREZE MOT_KÖRÜK_1200_20_06.007"
                        Model {
                            id: imported1_161
                            objectName: "Imported1.161"
                            source: "meshes/mesh_434_002_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_K_R_K_C1280_20_130_003
                        objectName: "2100_FREZE MOT_KÖRÜK_C1280_20_130.003"
                        Model {
                            id: imported1_162
                            objectName: "Imported1.162"
                            source: "meshes/mesh_1769_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: node2100_FREZE_MOT_K_R_K_S1280_20_130_003
                        objectName: "2100_FREZE MOT_KÖRÜK_S1280_20_130.003"
                        Model {
                            id: y_kseklik_Ekstr_zyon1_306
                            objectName: "Yükseklik-Ekstrüzyon1.306"
                            source: "meshes/mesh_1768_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                }
            }
            Node {
                id: h6161H2130_002
                objectName: "H6161H2130.002"
                Node {
                    id: node1423h0341_002
                    objectName: "1423h0341.002"
                    Model {
                        id: al_nm__1_2116
                        objectName: "Alýnmýþ1.2116"
                        source: "meshes/mesh_1856_mesh.mesh"
                        materials: [
                            paint__55__55__55__255__material
                        ]
                    }
                }
                Node {
                    id: node245100900_H_004
                    objectName: "245100900_H.004"
                    Model {
                        id: al_nm__1_2114
                        objectName: "Alýnmýþ1.2114"
                        source: "meshes/mesh_1851_001_mesh.mesh"
                        materials: [
                            paint__55__55__55__255__material
                        ]
                    }
                }
                Node {
                    id: node245100900_H_005
                    objectName: "245100900_H.005"
                    Model {
                        id: al_nm__1_2128
                        objectName: "Alýnmýþ1.2128"
                        source: "meshes/mesh_1851_mesh.mesh"
                        materials: [
                            paint__55__55__55__255__material
                        ]
                    }
                }
                Node {
                    id: node3407h0060_002
                    objectName: "3407h0060.002"
                    Model {
                        id: al_nm__1_2127
                        objectName: "Alýnmýþ1.2127"
                        source: "meshes/mesh_1868_mesh.mesh"
                        materials: [
                            paint__55__55__55__255__material
                        ]
                    }
                }
                Node {
                    id: node6200H0110_3D_002
                    objectName: "6200H0110_3D.002"
                    Node {
                        id: node2403A0339_002
                        objectName: "2403A0339.002"
                        Model {
                            id: al_nm__1_2120
                            objectName: "Alýnmýþ1.2120"
                            source: "meshes/mesh_1862_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: fnan500006_002
                        objectName: "FNAN500006.002"
                        Model {
                            id: al_nm__1_2119
                            objectName: "Alýnmýþ1.2119"
                            source: "meshes/mesh_1861_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: fnan500007_asm_002
                        objectName: "fnan500007_asm.002"
                        Node {
                            id: fnan500007_002
                            objectName: "FNAN500007.002"
                            Model {
                                id: al_nm__1_2123
                                objectName: "Alýnmýþ1.2123"
                                source: "meshes/mesh_1865_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: h_0000136_004
                            objectName: "H-0000136.004"
                            Model {
                                id: al_nm__1_2124
                                objectName: "Alýnmýþ1.2124"
                                source: "meshes/mesh_1866_001_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                        Node {
                            id: h_0000136_005
                            objectName: "H-0000136.005"
                            Model {
                                id: al_nm__1_2125
                                objectName: "Alýnmýþ1.2125"
                                source: "meshes/mesh_1866_mesh.mesh"
                                materials: [
                                    paint__55__55__55__255__material
                                ]
                            }
                        }
                    }
                    Node {
                        id: fnan500008_002
                        objectName: "FNAN500008.002"
                        Model {
                            id: al_nm__1_2122
                            objectName: "Alýnmýþ1.2122"
                            source: "meshes/mesh_1864_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: h2147H0015_002
                        objectName: "H2147H0015.002"
                        Model {
                            id: al_nm__1_2118
                            objectName: "Alýnmýþ1.2118"
                            source: "meshes/mesh_1860_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                    Node {
                        id: sp00013369_002
                        objectName: "SP00013369.002"
                        Model {
                            id: al_nm__1_2121
                            objectName: "Alýnmýþ1.2121"
                            source: "meshes/mesh_1863_mesh.mesh"
                            materials: [
                                paint__55__55__55__255__material
                            ]
                        }
                    }
                }
                Node {
                    id: fnaa150599_oa_1_002
                    objectName: "FNAA150599_oa_1.002"
                    Model {
                        id: y_kseklik_Ekstr_zyon1_308
                        objectName: "Yükseklik-Ekstrüzyon1.308"
                        source: "meshes/mesh_1853_mesh.mesh"
                        materials: [
                            paint__55__55__55__255__material
                        ]
                    }
                }
                Node {
                    id: fnae051473_oa_0_1_002
                    objectName: "fnae051473_oa_0_1.002"
                    Model {
                        id: none_131
                        objectName: "NONE.131"
                        source: "meshes/mesh_1844_mesh.mesh"
                        materials: [
                            paint__55__55__55__255__material
                        ]
                    }
                }
                Node {
                    id: fnag050328_002
                    objectName: "FNAG050328.002"
                    Model {
                        id: al_nm__1_2113
                        objectName: "Alýnmýþ1.2113"
                        source: "meshes/mesh_1850_mesh.mesh"
                        materials: [
                            paint__55__55__55__255__material
                        ]
                    }
                }
                Node {
                    id: fnan500003_002
                    objectName: "FNAN500003.002"
                    Model {
                        id: al_nm__1_2115
                        objectName: "Alýnmýþ1.2115"
                        source: "meshes/mesh_1854_mesh.mesh"
                        materials: [
                            paint__55__55__55__255__material
                        ]
                    }
                }
                Node {
                    id: fnt8100025_002
                    objectName: "FNT8100025.002"
                    Model {
                        id: al_nm__1_2117
                        objectName: "Alýnmýþ1.2117"
                        source: "meshes/mesh_1858_mesh.mesh"
                        materials: [
                            paint__55__55__55__255__material
                        ]
                    }
                }
                Node {
                    id: fny8100711_002
                    objectName: "FNY8100711.002"
                    Model {
                        id: m8_Di_li_Delik1_051
                        objectName: "M8 Diþli Delik1.051"
                        source: "meshes/mesh_1855_mesh.mesh"
                        materials: [
                            paint__55__55__55__255__material
                        ]
                    }
                }
                Node {
                    id: mm00256948_002
                    objectName: "MM00256948.002"
                    Model {
                        id: al_nm__1_2126
                        objectName: "Alýnmýþ1.2126"
                        source: "meshes/mesh_1867_mesh.mesh"
                        materials: [
                            paint__55__55__55__255__material
                        ]
                    }
                }
                Node {
                    id: x245128600_H_002
                    objectName: "X245128600_H.002"
                    Model {
                        id: al_nm__3_029
                        objectName: "Alýnmýþ3.029"
                        source: "meshes/mesh_1859_mesh.mesh"
                        materials: [
                            paint__55__55__55__255__material
                        ]
                    }
                }
                Node {
                    id: xfnan500022_002
                    objectName: "Xfnan500022.002"
                    Model {
                        id: alynmy_1
                        objectName: "Alynmy?1"
                        source: "meshes/mesh_1852_mesh.mesh"
                        materials: [
                            paint__55__55__55__255__material
                        ]
                    }
                }
                Node {
                    id: xmm00256799_004
                    objectName: "XMM00256799.004"
                    Model {
                        id: kes_Ekstr_zyon2_1__002
                        objectName: "Kes-Ekstrüzyon2[1].002"
                        source: "meshes/mesh_1845_001_mesh.mesh"
                        materials: [
                            paint__55__55__55__255__material
                        ]
                    }
                    Model {
                        id: kes_Ekstr_zyon2_2__002
                        objectName: "Kes-Ekstrüzyon2[2].002"
                        source: "meshes/mesh_1846_001_mesh.mesh"
                        materials: [
                            paint__55__55__55__255__material
                        ]
                    }
                    Model {
                        id: kes_Ekstr_zyon2_3__002
                        objectName: "Kes-Ekstrüzyon2[3].002"
                        source: "meshes/mesh_1847_001_mesh.mesh"
                        materials: [
                            paint__55__55__55__255__material
                        ]
                    }
                }
                Node {
                    id: xmm00256799_005
                    objectName: "XMM00256799.005"
                    Model {
                        id: kes_Ekstr_zyon2_1__003
                        objectName: "Kes-Ekstrüzyon2[1].003"
                        source: "meshes/mesh_1845_mesh.mesh"
                        materials: [
                            paint__55__55__55__255__material
                        ]
                    }
                    Model {
                        id: kes_Ekstr_zyon2_2__003
                        objectName: "Kes-Ekstrüzyon2[2].003"
                        source: "meshes/mesh_1846_mesh.mesh"
                        materials: [
                            paint__55__55__55__255__material
                        ]
                    }
                    Model {
                        id: kes_Ekstr_zyon2_3__003
                        objectName: "Kes-Ekstrüzyon2[3].003"
                        source: "meshes/mesh_1847_mesh.mesh"
                        materials: [
                            paint__55__55__55__255__material
                        ]
                    }
                }
                Node {
                    id: _ST_PLAST_K_002
                    objectName: "ÜST PLASTÝK.002"
                    Model {
                        id: kes_Ekstr_zyon4_1_
                        objectName: "Kes-Ekstrüzyon4[1]"
                        source: "meshes/mesh_1848_mesh.mesh"
                        materials: [
                            paint__55__55__55__255__material
                        ]
                    }
                    Model {
                        id: kes_Ekstr_zyon4_2_
                        objectName: "Kes-Ekstrüzyon4[2]"
                        source: "meshes/mesh_1849_mesh.mesh"
                        materials: [
                            paint__55__55__55__255__material
                        ]
                    }
                }
                Node {
                    id: _ST_002
                    objectName: "ÜST.002"
                    Model {
                        id: _8_5__8_5___ap_Delik1_021
                        objectName: "Ø8.5 (8.5) Çap Delik1.021"
                        source: "meshes/mesh_1857_mesh.mesh"
                        materials: [
                            paint__55__55__55__255__material
                        ]
                    }
                }
            }
            Node {
                id: _SO_30_ADAPT_R_016
                objectName: "ÝSO 30 ADAPTÖR.016"
                Model {
                    id: cut_Extrude2_751
                    objectName: "Cut-Extrude2.751"
                    source: "meshes/mesh_1342_mesh.mesh"
                    materials: [
                        paint__55__55__55__255__material
                    ]
                }
            }
        }
        Node {
            id: node10LUMAG_014
            objectName: "10LUMAG.014"
            position: Qt.vector3d(0.391593, 0.491951, 0)
            Node {
                id: node2100_SAB_T_10_LU_MAGAZ_N_SA_
                objectName: "2100_SABÝT_10 LU MAGAZÝN_SAÇ"
                Model {
                    id: lpattern2
                    objectName: "LPattern2"
                    source: "meshes/lpattern2_mesh.mesh"
                    materials: [
                        paint__234__232__240__255__material,
                        paint__0__0__0__255__material,
                        paint__0__0__0__255__material,
                        paint__0__0__0__255__material,
                        paint__0__0__0__255__material,
                        paint__0__0__0__255__material,
                        paint__0__0__0__255__material,
                        paint__0__0__0__255__material,
                        paint__0__0__0__255__material,
                        paint__0__0__0__255__material,
                        paint__234__232__240__255__material,
                        paint__234__232__240__255__material,
                        paint__234__232__240__255__material,
                        paint__234__232__240__255__material,
                        paint__234__232__240__255__material,
                        paint__234__232__240__255__material,
                        paint__234__232__240__255__material,
                        paint__234__232__240__255__material,
                        paint__234__232__240__255__material,
                        paint__0__0__0__255__material
                    ]
                }
            }
        }
        Model {
            id: makine3_par_a_001
            objectName: "makine3-parça.001"
            position: Qt.vector3d(0.547805, 1.45553, 0.0725629)
            rotation: Qt.quaternion(0.707107, 0, 0, -0.707107)
            scale: Qt.vector3d(0.01, 0.01, 0.0111202)
            source: "meshes/shape_069_mesh.mesh"
            materials: [
                paint__218__95__44__255__material
            ]
        }
        Model {
            id: plane_001
            objectName: "Plane.001"
            position: Qt.vector3d(3.45673, 0.314592, 0.846803)
            rotation: Qt.quaternion(0.707107, 0.707107, 0, 0)
            scale: Qt.vector3d(0.0785684, 0.101991, 0.0261699)
            source: "meshes/plane_mesh.mesh"
            materials: [
                paint__234__232__240__255__material
            ]
        }
        Model {
            id: node2136
            objectName: "2136"
            position: Qt.vector3d(3.45343, 0.315838, 0.849582)
            rotation: Qt.quaternion(0.707107, 0.707107, 0, 0)
            scale: Qt.vector3d(0.0747292, 0.0747292, 0.0747292)
            source: "meshes/node2136_mesh.mesh"
            materials: [
                paint__185__188__191__255__material
            ]
        }

        Model {
            id: sim_BRIDGE
            objectName: "SIM_BRIDGE"
            position: Qt.vector3d(0, 0.704551, 0)
            x: node.axisX
            source: "meshes/sim_BRIDGE_mesh.mesh"
            materials: [
                paint__234__232__240__255__material,
                paint__0__0__0__255__material,
                paint__185__188__191__255__material,
                paint__231__88__7__255__material,
                paint__231__231__231__95__material,
                paint__0__0__0__255__material,
                paint__231__175__6__86__material,
                paint__175__178__181__255__material
            ]
        }
        Model {
            id: sim_CARRIAGE
            objectName: "SIM_CARRIAGE"
            position: Qt.vector3d(0, 0.704551, 0)
            x: node.axisX; z: node.axisY; y: 0.704551 + node.axisZ
            source: "meshes/sim_CARRIAGE_mesh.mesh"
            materials: [
                paint__185__188__191__255__material,
                paint__55__55__55__255__material,
                paint__0__0__0__255__material
            ]
        }

    }

    // Animations:
}
