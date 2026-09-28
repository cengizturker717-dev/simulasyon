import QtQuick
import QtQuick3D

Node {
    id: machine
    property real axisX: 1050
    property real axisY: 1830
    property real axisZ: 150
    property bool surroundings: true
    PrincipledMaterial { id: white; baseColor: "#e9edf2"; roughness: 0.65 }
    PrincipledMaterial { id: dark; baseColor: "#263442"; roughness: 0.65 }
    PrincipledMaterial { id: orange; baseColor: "#f47927"; roughness: 0.5 }
    PrincipledMaterial { id: metal; baseColor: "#8396a6"; metalness: 0.55; roughness: 0.4 }
    PrincipledMaterial { id: table; baseColor: "#566571"; roughness: 0.85 }
    PrincipledMaterial { id: yellow; baseColor: "#d1b553"; roughness: 0.7 }
    PrincipledMaterial { id: wood; baseColor: "#cdb48c"; roughness: 0.95 }
    component Box: Model {
        property vector3d size: Qt.vector3d(100,100,100)
        source: "#Cube"
        scale: Qt.vector3d(size.x/100,size.y/100,size.z/100)
    }
    // Prototype scene units are millimetres. Machine X -> scene X, Y -> -Z, Z -> Y.
    Box { position: Qt.vector3d(0,390,0); size: Qt.vector3d(2480,620,4020); materials: white }
    Box { position: Qt.vector3d(0,710,0); size: Qt.vector3d(2180,70,3740); materials: dark }
    Box { position: Qt.vector3d(0,752,0); size: Qt.vector3d(2100,15,3660); materials: table }
    Repeater3D {
        model: 9
        Box { required property int index; position: Qt.vector3d(-1050+index*262.5,763,0); size: Qt.vector3d(5,3,3660); materials: metal }
    }
    Repeater3D {
        model: 15
        Box { required property int index; position: Qt.vector3d(0,763,-1830+index*261.4); size: Qt.vector3d(2100,3,5); materials: metal }
    }
    Repeater3D {
        model: 4
        Box { required property int index; position: Qt.vector3d(index%2===0?-1000:1000,55,index<2?-1560:1560); size: Qt.vector3d(260,110,260); materials: dark }
    }
    Box { position: Qt.vector3d(-1250,610,0); size: Qt.vector3d(25,90,3900); materials: orange }
    Box { position: Qt.vector3d(1250,610,0); size: Qt.vector3d(25,90,3900); materials: orange }
    Box { position: Qt.vector3d(0,775,0); size: Qt.vector3d(1500,20,2500); materials: wood }
    Box { position: Qt.vector3d(-1180,800,0); size: Qt.vector3d(65,70,3900); materials: metal }
    Box { position: Qt.vector3d(1180,800,0); size: Qt.vector3d(65,70,3900); materials: metal }
    Node {
        id: bridge
        objectName: "demoBridge"
        z: 1830-machine.axisY
        Box { position: Qt.vector3d(-1300,1020,0); size: Qt.vector3d(240,760,460); materials: white }
        Box { position: Qt.vector3d(1300,1020,0); size: Qt.vector3d(240,760,460); materials: white }
        Box { position: Qt.vector3d(0,1440,0); size: Qt.vector3d(2820,400,420); materials: white }
        Box { position: Qt.vector3d(0,1450,217); size: Qt.vector3d(2780,52,12); materials: orange }
        Box { position: Qt.vector3d(0,1260,225); size: Qt.vector3d(2390,55,70); materials: metal }
        Node {
            objectName: "demoCarriage"
            x: machine.axisX-1050
            Box { position: Qt.vector3d(0,1390,280); size: Qt.vector3d(390,620,260); materials: dark }
            Node {
                objectName: "demoSpindle"
                y: machine.axisZ
                Box { position: Qt.vector3d(0,1190,420); size: Qt.vector3d(270,520,250); materials: white }
                Box { position: Qt.vector3d(0,1190,551); size: Qt.vector3d(230,290,12); materials: orange }
                Model { source: "#Cylinder"; position: Qt.vector3d(0,920,420); scale: Qt.vector3d(1.6,1.8,1.6); materials: metal }
                Model { source: "#Cylinder"; position: Qt.vector3d(0,803,420); scale: Qt.vector3d(0.22,0.6,0.22); materials: dark }
            }
        }
    }
    Node {
        visible: machine.surroundings
        Box { position: Qt.vector3d(0,560,-2990); size: Qt.vector3d(2400,300,1800); materials: white }
        Box { position: Qt.vector3d(0,730,-2990); size: Qt.vector3d(2220,40,1800); materials: dark }
        Box { position: Qt.vector3d(0,700,2730); size: Qt.vector3d(2350,120,1550); materials: dark }
        Repeater3D {
            model: 9
            Model { required property int index; source: "#Cylinder"; position: Qt.vector3d(0,780,2100+index*160); eulerRotation.z: 90; scale: Qt.vector3d(.55,22,.55); materials: metal }
        }
        Box { position: Qt.vector3d(-1910,590,1070); size: Qt.vector3d(120,1180,160); materials: white }
        Box { position: Qt.vector3d(-1910,1200,1070); size: Qt.vector3d(580,410,180); materials: white }
        Box { position: Qt.vector3d(-1910,1225,1170); size: Qt.vector3d(460,280,18); materials: dark }
        Repeater3D {
            model: 9
            Node {
                required property int index
                position: Qt.vector3d(1800,0,-3900+index*950)
                Box { position: Qt.vector3d(0,750,0); size: Qt.vector3d(38,1500,38); materials: yellow }
                Box { position: Qt.vector3d(0,1450,460); size: Qt.vector3d(25,25,910); materials: yellow }
                Box { position: Qt.vector3d(0,250,460); size: Qt.vector3d(25,25,910); materials: yellow }
                Repeater3D {
                    model: 6
                    Box { required property int index; position: Qt.vector3d(0,850,index*150); size: Qt.vector3d(10,1200,10); materials: yellow }
                }
            }
        }
    }
}
