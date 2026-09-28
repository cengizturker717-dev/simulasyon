import QtQuick
import QtQuick3D

Node {
    id: machine
    property real axisX: 1050
    property real axisY: 1830
    property real axisZ: 150
    property bool surroundings: true
    PrincipledMaterial { id: white; baseColor: "#e4e5e7"; roughness: 0.62 }
    PrincipledMaterial { id: dark; baseColor: "#252729"; roughness: 0.65 }
    PrincipledMaterial { id: orange; baseColor: "#ec6625"; roughness: 0.5 }
    PrincipledMaterial { id: metal; baseColor: "#a3a8ab"; metalness: 0.5; roughness: 0.42 }
    PrincipledMaterial { id: table; baseColor: "#b6b7b8"; roughness: 0.9 }
    PrincipledMaterial { id: yellow; baseColor: "#d5b82d"; roughness: 0.7 }
    PrincipledMaterial { id: wire; baseColor: "#585b58"; roughness: 0.8 }
    PrincipledMaterial { id: belt; baseColor: "#414345"; roughness: 0.95 }
    PrincipledMaterial { id: brass; baseColor: "#ac8950"; metalness: 0.35; roughness: 0.45 }
    component Box: Model {
        property vector3d size: Qt.vector3d(100,100,100)
        source: "#Cube"; scale: Qt.vector3d(size.x/100,size.y/100,size.z/100); materials: white
    }
    component Cylinder: Model {
        property real diameter: 100
        property real length: 100
        source: "#Cylinder"; scale: Qt.vector3d(diameter/100,length/100,diameter/100); materials: metal
    }
    component Feet: Node {
        Cylinder { y: 90; diameter: 38; length: 150 }
        Cylinder { y: 24; diameter: 120; length: 35; materials: dark }
        Box { y: 190; size: Qt.vector3d(120,170,130); materials: dark }
    }
    component Stripe: Node {
        property real span: 1000
        Box { size: Qt.vector3d(5,18,span); materials: orange }
        Box { y: -36; size: Qt.vector3d(5,8,span); materials: orange }
    }
    // Photo-based reconstruction, not an original CAD model. Units are millimetres.
    // Machine X -> scene X, Y -> -scene Z, Z -> scene Y.
    Box { y: 380; size: Qt.vector3d(2240,280,3980); materials: dark }
    Box { y: 670; size: Qt.vector3d(2390,130,4030) }
    Box { position: Qt.vector3d(-1190,485,0); size: Qt.vector3d(85,320,4020) }
    Box { position: Qt.vector3d(1190,485,0); size: Qt.vector3d(85,320,4020) }
    Stripe { position: Qt.vector3d(-1236,382,0); span: 3900 }
    Stripe { position: Qt.vector3d(1236,382,0); span: 3900 }
    Repeater3D { model: 6; Feet { required property int index; position: Qt.vector3d(index%2===0?-1040:1040,0,-1700+Math.floor(index/2)*1700) } }
    // Bordered vacuum panels and repeated suction ports.
    Box { y: 754; size: Qt.vector3d(2140,28,3700); materials: dark }
    Model { source: "#Cube"; materials: table; instancing: GridInstances { columns: 3; rows: 4; start: Qt.vector3d(-704,775,-1370); columnStep: Qt.vector3d(704,0,0); rowStep: Qt.vector3d(0,0,913); dimensions: Qt.vector3d(679,14,886) } }
    Model { source: "#Cylinder"; materials: dark; instancing: GridInstances { columns: 12; rows: 20; start: Qt.vector3d(-952,785,-1650); columnStep: Qt.vector3d(173,0,0); rowStep: Qt.vector3d(0,0,173); dimensions: Qt.vector3d(27,3,27) } }
    Model { source: "#Cube"; materials: dark; instancing: GridInstances { columns: 3; rows: 4; start: Qt.vector3d(-704,785,-1370); columnStep: Qt.vector3d(704,0,0); rowStep: Qt.vector3d(0,0,913); dimensions: Qt.vector3d(530,2,7) } }
    Box { position: Qt.vector3d(-1100,810,0); size: Qt.vector3d(52,48,3950); materials: metal }
    Box { position: Qt.vector3d(1100,810,0); size: Qt.vector3d(52,48,3950); materials: metal }
    Model { source: "#Cube"; materials: dark; instancing: GridInstances { columns: 46; rows: 2; start: Qt.vector3d(-1140,799,-1850); columnStep: Qt.vector3d(0,0,82); rowStep: Qt.vector3d(2280,0,0); dimensions: Qt.vector3d(22,12,12) } }
    Node {
        id: bridge; objectName: "demoBridge"; z: 1510-machine.axisY
        Box { position: Qt.vector3d(-1270,910,0); size: Qt.vector3d(310,800,650) }
        Box { position: Qt.vector3d(1270,1050,0); size: Qt.vector3d(210,710,440) }
        Box { position: Qt.vector3d(0,1330,0); size: Qt.vector3d(2700,450,300) }
        Box { position: Qt.vector3d(0,1540,-170); size: Qt.vector3d(2740,70,75); materials: metal }
        Box { position: Qt.vector3d(0,1250,182); size: Qt.vector3d(2490,60,65); materials: metal }
        Box { position: Qt.vector3d(0,1440,182); size: Qt.vector3d(2490,45,65); materials: metal }
        Box { position: Qt.vector3d(0,1370,157); size: Qt.vector3d(2470,90,20); materials: dark }
        Box { position: Qt.vector3d(0,1168,167); size: Qt.vector3d(2550,20,10); materials: orange }
        Box { position: Qt.vector3d(0,1200,167); size: Qt.vector3d(2550,10,10); materials: orange }
        // Side service enclosure and amber viewing window.
        Box { position: Qt.vector3d(-1432,950,0); size: Qt.vector3d(14,665,570); materials: dark }
        Box { position: Qt.vector3d(-1443,950,-80); size: Qt.vector3d(10,600,365) }
        Box { position: Qt.vector3d(-1450,962,-80); size: Qt.vector3d(7,470,260); materials: brass }
        Box { position: Qt.vector3d(-1458,963,-83); size: Qt.vector3d(5,365,190); materials: dark }
        Box { position: Qt.vector3d(-1451,970,147); size: Qt.vector3d(17,125,20); materials: metal }
        Stripe { position: Qt.vector3d(-1450,627,0); span: 560 }
        Box { position: Qt.vector3d(1270,1110,310); size: Qt.vector3d(270,210,250) }
        Model { source: "#Cube"; materials: dark; instancing: GridInstances { columns: 30; start: Qt.vector3d(-1180,1595,-80); columnStep: Qt.vector3d(79,0,0); dimensions: Qt.vector3d(58,45,72) } }
        Node {
            objectName: "demoCarriage"; x: machine.axisX-1050
            Box { position: Qt.vector3d(0,1470,285); size: Qt.vector3d(430,640,260); materials: dark }
            Box { position: Qt.vector3d(0,1770,230); size: Qt.vector3d(390,90,330); materials: dark }
            Cylinder { position: Qt.vector3d(120,1800,390); diameter: 170; length: 250; materials: dark }
            Box { position: Qt.vector3d(-130,1510,444); size: Qt.vector3d(45,480,35); materials: metal }
            Box { position: Qt.vector3d(130,1510,444); size: Qt.vector3d(45,480,35); materials: metal }
            Node {
                objectName: "demoSpindle"; y: machine.axisZ
                Box { position: Qt.vector3d(0,1220,380); size: Qt.vector3d(210,430,170); materials: metal }
                Cylinder { position: Qt.vector3d(0,1200,410); diameter: 190; length: 390 }
                Cylinder { position: Qt.vector3d(0,1450,410); diameter: 165; length: 130; materials: dark }
                Cylinder { position: Qt.vector3d(0,963,410); diameter: 125; length: 85; materials: dark }
                Cylinder { position: Qt.vector3d(0,884,410); diameter: 33; length: 80 }
                Box { position: Qt.vector3d(-170,997,430); size: Qt.vector3d(120,150,200); materials: dark }
                Cylinder { position: Qt.vector3d(-170,1170,400); diameter: 90; length: 220; materials: dark }
            }
        }
    }
    Node {
        visible: machine.surroundings
        // Open loading bed, lifting gantry and longitudinal pickup arm.
        Box { position: Qt.vector3d(-1110,440,-3520); size: Qt.vector3d(100,160,2770); materials: dark }
        Box { position: Qt.vector3d(1110,440,-3520); size: Qt.vector3d(100,160,2770); materials: dark }
        Model { source: "#Cube"; materials: dark; instancing: GridInstances { columns: 10; start: Qt.vector3d(0,610,-4700); columnStep: Qt.vector3d(0,0,270); dimensions: Qt.vector3d(2230,150,110) } }
        Model { source: "#Cube"; materials: dark; instancing: GridInstances { columns: 6; start: Qt.vector3d(-1000,711,-3500); columnStep: Qt.vector3d(400,0,0); dimensions: Qt.vector3d(55,35,2700) } }
        Repeater3D { model: 4; Feet { required property int index; position: Qt.vector3d(index%2===0?-1000:1000,0,index<2?-4570:-2310) } }
        Box { position: Qt.vector3d(0,720,-2130); size: Qt.vector3d(2400,90,100) }
        Box { position: Qt.vector3d(0,720,-4800); size: Qt.vector3d(2400,90,100) }
        Repeater3D { model: 4; Box { required property int index; position: Qt.vector3d(index%2===0?-1160:1160,930,index<2?-4550:-2330); size: Qt.vector3d(85,600,85) } }
        Box { position: Qt.vector3d(-1140,1220,-3420); size: Qt.vector3d(120,110,2470) }
        Box { position: Qt.vector3d(1140,1220,-3420); size: Qt.vector3d(120,110,2470) }
        Box { position: Qt.vector3d(0,1220,-3780); size: Qt.vector3d(2350,160,125) }
        Box { position: Qt.vector3d(0,1305,-3780); size: Qt.vector3d(2220,20,80); materials: metal }
        Box { position: Qt.vector3d(0,1020,-3510); size: Qt.vector3d(150,90,2300); materials: metal }
        Box { position: Qt.vector3d(0,1210,-2510); size: Qt.vector3d(350,230,360); materials: dark }
        Model { source: "#Cylinder"; materials: dark; instancing: GridInstances { columns: 4; rows: 2; start: Qt.vector3d(-670,865,-3000); columnStep: Qt.vector3d(445,0,0); rowStep: Qt.vector3d(0,0,-770); dimensions: Qt.vector3d(120,40,120) } }
        // Fourteen-place fixed tool magazine.
        Box { position: Qt.vector3d(0,975,-1990); size: Qt.vector3d(1990,90,140); materials: metal }
        Model { source: "#Cylinder"; materials: dark; instancing: GridInstances { columns: 14; start: Qt.vector3d(-920,1050,-1990); columnStep: Qt.vector3d(140,0,0); dimensions: Qt.vector3d(65,140,65) } }
        Model { source: "#Cylinder"; materials: metal; instancing: GridInstances { columns: 14; start: Qt.vector3d(-920,1150,-1990); columnStep: Qt.vector3d(140,0,0); dimensions: Qt.vector3d(28,65,28) } }
        // Flat unloading conveyor and sweeper.
        Box { position: Qt.vector3d(0,645,3250); size: Qt.vector3d(2350,210,2390) }
        Box { position: Qt.vector3d(0,766,3250); size: Qt.vector3d(2190,40,2410); materials: belt }
        Box { position: Qt.vector3d(-1190,520,3250); size: Qt.vector3d(95,370,2450) }
        Box { position: Qt.vector3d(1190,520,3250); size: Qt.vector3d(95,370,2450) }
        Stripe { position: Qt.vector3d(-1240,392,3250); span: 2370 }
        Stripe { position: Qt.vector3d(1240,392,3250); span: 2370 }
        Cylinder { position: Qt.vector3d(0,744,4435); diameter: 130; length: 2280; eulerRotation.z: 90 }
        Box { position: Qt.vector3d(0,858,3290); size: Qt.vector3d(2230,140,105); materials: dark }
        Box { position: Qt.vector3d(-1150,877,3290); size: Qt.vector3d(85,280,180); materials: dark }
        Box { position: Qt.vector3d(1150,877,3290); size: Qt.vector3d(85,280,180); materials: dark }
        Repeater3D { model: 4; Feet { required property int index; position: Qt.vector3d(index%2===0?-1060:1060,0,index<2?2220:4290) } }
        // Operator pedestal at the front-left.
        Node {
            position: Qt.vector3d(-2110,0,-1170)
            Box { y: 100; size: Qt.vector3d(630,90,490) }
            Box { y: 450; size: Qt.vector3d(410,650,260) }
            Node {
                position: Qt.vector3d(0,1010,10); eulerRotation.z: -12
                Box { size: Qt.vector3d(135,470,540) }
                Box { position: Qt.vector3d(-72,30,0); size: Qt.vector3d(12,315,400); materials: dark }
                Box { position: Qt.vector3d(-155,-200,0); size: Qt.vector3d(240,30,550) }
                Box { position: Qt.vector3d(-175,-181,0); size: Qt.vector3d(175,8,355); materials: dark }
            }
            Box { position: Qt.vector3d(170,310,290); size: Qt.vector3d(70,510,70) }
            Cylinder { position: Qt.vector3d(170,615,290); diameter: 65; length: 65; materials: orange }
        }
        Box { position: Qt.vector3d(1580,1140,-1460); size: Qt.vector3d(570,2060,670) }
        Box { position: Qt.vector3d(1288,1150,-1460); size: Qt.vector3d(7,1930,610); materials: metal }
        Box { position: Qt.vector3d(1278,1030,-1230); size: Qt.vector3d(14,120,18); materials: dark }
        // Two vacuum racks with paired pump bodies.
        Repeater3D {
            model: 2
            Node {
                required property int index; position: Qt.vector3d(1830,0,2100+index*1320)
                Model { source: "#Cube"; materials: dark; instancing: GridInstances { columns: 2; rows: 2; start: Qt.vector3d(-300,550,-440); columnStep: Qt.vector3d(600,0,0); rowStep: Qt.vector3d(0,0,880); dimensions: Qt.vector3d(45,1030,45) } }
                Box { y: 185; size: Qt.vector3d(660,60,970); materials: dark }
                Box { y: 1010; size: Qt.vector3d(660,45,970); materials: dark }
                Box { position: Qt.vector3d(0,1075,-440); size: Qt.vector3d(660,90,35); materials: dark }
                Box { position: Qt.vector3d(0,1075,440); size: Qt.vector3d(660,90,35); materials: dark }
                Repeater3D {
                    model: 2
                    Node {
                        required property int index; y: 420+index*815
                        Box { position: Qt.vector3d(0,0,-140); size: Qt.vector3d(380,280,480); materials: wire }
                        Cylinder { position: Qt.vector3d(0,40,230); diameter: 295; length: 410; eulerRotation.x: 90; materials: wire }
                        Cylinder { position: Qt.vector3d(0,40,450); diameter: 300; length: 35; eulerRotation.x: 90; materials: dark }
                        Box { position: Qt.vector3d(0,220,-140); size: Qt.vector3d(170,180,160); materials: dark }
                        Model { source: "#Cube"; materials: dark; instancing: GridInstances { columns: 9; start: Qt.vector3d(-200,0,-350); columnStep: Qt.vector3d(0,0,50); dimensions: Qt.vector3d(15,255,9) } }
                    }
                }
            }
        }
        // U-shaped fence. Fine wires use instanced geometry to limit draw calls.
        Model { source: "#Cube"; materials: yellow; instancing: GridInstances { columns: 11; start: Qt.vector3d(2550,970,-5050); columnStep: Qt.vector3d(0,0,960); dimensions: Qt.vector3d(55,1940,55) } }
        Model { source: "#Cube"; materials: yellow; instancing: GridInstances { columns: 11; start: Qt.vector3d(2550,20,-5050); columnStep: Qt.vector3d(0,0,960); dimensions: Qt.vector3d(190,30,145) } }
        Model { source: "#Cube"; materials: yellow; instancing: GridInstances { rows: 3; start: Qt.vector3d(2550,220,-250); rowStep: Qt.vector3d(0,840,0); dimensions: Qt.vector3d(35,30,9600) } }
        Model { source: "#Cube"; materials: wire; instancing: GridInstances { columns: 192; start: Qt.vector3d(2550,1050,-5025); columnStep: Qt.vector3d(0,0,50); dimensions: Qt.vector3d(4,1680,4) } }
        Model { source: "#Cube"; materials: wire; instancing: GridInstances { rows: 34; start: Qt.vector3d(2550,230,-250); rowStep: Qt.vector3d(0,50,0); dimensions: Qt.vector3d(4,4,9600) } }
        Repeater3D {
            model: 2
            Node {
                required property int index; z: index===0?-5050:4550
                Model { source: "#Cube"; materials: yellow; instancing: GridInstances { columns: 5; start: Qt.vector3d(-1290,970,0); columnStep: Qt.vector3d(960,0,0); dimensions: Qt.vector3d(55,1940,55) } }
                Model { source: "#Cube"; materials: yellow; instancing: GridInstances { columns: 5; start: Qt.vector3d(-1290,20,0); columnStep: Qt.vector3d(960,0,0); dimensions: Qt.vector3d(140,30,190) } }
                Model { source: "#Cube"; materials: yellow; instancing: GridInstances { rows: 3; start: Qt.vector3d(630,220,0); rowStep: Qt.vector3d(0,840,0); dimensions: Qt.vector3d(3840,30,35) } }
                Model { source: "#Cube"; materials: wire; instancing: GridInstances { columns: 77; start: Qt.vector3d(-1265,1050,0); columnStep: Qt.vector3d(50,0,0); dimensions: Qt.vector3d(4,1680,4) } }
                Model { source: "#Cube"; materials: wire; instancing: GridInstances { rows: 34; start: Qt.vector3d(630,230,0); rowStep: Qt.vector3d(0,50,0); dimensions: Qt.vector3d(3840,4,4) } }
            }
        }
        Repeater3D {
            model: 3
            Node {
                required property int index; position: Qt.vector3d(-1570,0,-2220+index*2250)
                Box { y: 220; size: Qt.vector3d(65,440,65); materials: yellow }
                Box { position: Qt.vector3d(160,390,0); size: Qt.vector3d(330,60,65); materials: yellow }
            }
        }
    }
}
