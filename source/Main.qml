import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick3D
import QtQuick3D.Helpers
import QtQuick3D.AssetUtils

ApplicationWindow {
    id: root
    width: 1440; height: 900
    minimumWidth: 1100; minimumHeight: 740
    visible: true
    title: "POYRAZ | SolidSim Native — 3D HMI Prototipi"
    color: "#eef2f6"
    font.family: "Segoe UI"
    property real measuredFps: 0
    property url modelUrl: startupModel
    property bool externalModel: modelUrl.toString().length > 0
    property bool convertedModel: modelUrl.toString().toLowerCase().endsWith(".qml")
    property var convertedComponent: null
    property var convertedObject: null
    property string modelState: !externalModel ? "demo" : convertedModel ? (convertedObject ? "loaded" : (convertedComponent && convertedComponent.status === Component.Error ? "error" : "loading")) : loader.status === RuntimeLoader.Success ? "loaded" : loader.status === RuntimeLoader.Error ? "error" : "loading"
    property bool benchmarkMode: false
    property real homeDistance: benchmarkMode ? 6000 : (convertedObject && convertedObject.simplified === true ? 6000 : (externalModel ? 11500 : 12500))
    property bool showExtras: true
    property real modelScale: 1
    property real modelHeight: 1250
    property vector3d modelCenter: Qt.vector3d(0,0,0)
    property bool motionBound: convertedModel && convertedObject !== null
    property real testBridge: convertedObject ? convertedObject.bridgePosition : -999
    property real testSpindle: convertedObject ? convertedObject.spindlePosition : -999
    property real testZ: convertedObject ? convertedObject.spindleHeight : -999
    property real testLift: convertedObject && convertedObject.liftPosition !== undefined ? convertedObject.liftPosition : 0
    function createConverted() {
        if (!convertedModel || convertedObject) return
        convertedComponent = Qt.createComponent(modelUrl, Component.PreferSynchronous)
        if (convertedComponent.status === Component.Ready) {
            convertedObject = convertedComponent.createObject(machineModel)
            if (convertedObject) homeView()
        } else console.warn(convertedComponent.errorString())
    }
    onModelUrlChanged: { if (convertedObject) { convertedObject.destroy(); convertedObject=null } Qt.callLater(root.createConverted) }
    Component.onCompleted: Qt.callLater(root.createConverted)
    function homeView() {
        orbit.position=Qt.vector3d(0,root.externalModel ? root.modelHeight/2 : 800,-150)
        orbit.eulerRotation=Qt.vector3d(-25,25,0)
        navigation.setDistance(root.homeDistance)
    }
    component ActionButton: Button {
        id: control
        property bool primary: false
        implicitHeight: 42
        font.pixelSize: 13
        background: Rectangle {
            radius: 7
            color: control.primary ? (control.down ? "#1846bd" : "#245ee8") : (control.hovered ? "#edf3ff" : "#ffffff")
            border.color: control.primary ? "#245ee8" : "#dbe3ed"
        }
        contentItem: Text { text: control.text; font: control.font; color: control.primary ? "white" : "#23374c"; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
    }
    component AxisControl: ColumnLayout {
        id: axis
        property string axisName
        property int axisIndex
        property real limit
        property real currentValue
        spacing: 7
        RowLayout {
            Layout.fillWidth: true
            Label { text: axis.axisName; color: "#245ee8"; font.pixelSize: 17; font.bold: true }
            Item { Layout.fillWidth: true }
            Label { text: axis.currentValue.toFixed(1); color: "#203246"; font.pixelSize: 23; font.family: "Consolas" }
            Label { text: "mm"; color: "#8492a4" }
        }
        Slider {
            objectName: "axisSlider" + axis.axisIndex
            Layout.fillWidth: true
            from: 0; to: axis.limit
            value: axis.currentValue
            onMoved: motion.setAxis(axis.axisIndex,value)
        }
        RowLayout {
            Label { text: "0"; color: "#8c99a9"; font.pixelSize: 11 }
            Item { Layout.fillWidth: true }
            Label { text: axis.limit.toFixed(0) + " mm"; color: "#8c99a9"; font.pixelSize: 11 }
        }
    }
    FileDialog {
        id: modelDialog
        title: "3D model seç — GLB, glTF veya OBJ"
        nameFilters: ["3D modeller (*.glb *.gltf *.obj)"]
        onAccepted: { motion.pause(); root.modelUrl=selectedFile; root.homeView() }
    }
    ColumnLayout {
        anchors.fill: parent; spacing: 0
        Rectangle {
            Layout.fillWidth: true; Layout.preferredHeight: 84
            color: "#ffffff"
            RowLayout {
                anchors.fill: parent; anchors.leftMargin: 28; anchors.rightMargin: 28; spacing: 22
                Rectangle { width: 5; height: 35; radius: 2; color: "#f47927" }
                ColumnLayout {
                    spacing: 0
                    Label { text: "POYRAZ"; color: "#183351"; font.pixelSize: 28; font.bold: true; font.letterSpacing: 3 }
                    Label { text: "MAKİNA  /  SOLIDSIM NATIVE"; color: "#7b8a9c"; font.pixelSize: 10; font.letterSpacing: 1.5 }
                }
                Rectangle { width: 1; height: 34; color: "#e3e8ef" }
                ColumnLayout {
                    spacing: 3
                    Label { text: "VIGOR 2136"; color: "#24394f"; font.bold: true; font.pixelSize: 17 }
                    Label { text: "3D makine ve eksen hareketi prototipi"; color: "#78889a"; font.pixelSize: 12 }
                }
                Item { Layout.fillWidth: true }
                Rectangle {
                    implicitWidth: 210; implicitHeight: 33; radius: 16; color: "#fff3df"
                    Label { anchors.centerIn: parent; text: root.externalModel ? (root.motionBound ? "VIGOR · SİMÜLASYON" : "VIGOR · GERÇEK MODEL") : "DEMO · MAKİNE BAĞLI DEĞİL"; color: root.externalModel ? "#1c6b49" : "#97601b"; font.bold: true; font.pixelSize: 11 }
                }
            }
        }
        RowLayout {
            Layout.fillWidth: true; Layout.fillHeight: true
            Layout.margins: 18; spacing: 16
            Rectangle {
                Layout.fillWidth: true; Layout.fillHeight: true
                color: "#191d22"; radius: 12; clip: true
                View3D {
                    id: view
                    objectName: "machineViewport"
                    anchors.fill: parent
                    camera: camera
                    environment: SceneEnvironment {
                        clearColor: "#dfe6ed"
                        backgroundMode: SceneEnvironment.Color
                        antialiasingMode: SceneEnvironment.MSAA
                        antialiasingQuality: SceneEnvironment.Medium
                    }
                    DirectionalLight { eulerRotation: Qt.vector3d(-45,-35,0); brightness: 1.0; ambientColor: "#777777" }
                    DirectionalLight { eulerRotation: Qt.vector3d(-30,140,0); brightness: 0.5; ambientColor: "#202020" }
                    DirectionalLight { eulerRotation: Qt.vector3d(35,25,0); brightness: 0.25; ambientColor: "#202020" }
                    Node {
                        id: orbit
                        position: Qt.vector3d(0,800,-150)
                        eulerRotation: Qt.vector3d(-26,-65,0)
                        PerspectiveCamera { id: camera; objectName: "machineCamera"; z: 12500; clipNear: 20; clipFar: 60000; fieldOfView: 40 }
                    }
                    Model {
                        visible: false
                        source: "#Cube"
                        position: Qt.vector3d(0,-40,0)
                        scale: Qt.vector3d(110,0.5,130)
                        materials: PrincipledMaterial { baseColor: "#dbe3eb"; roughness: 1; lighting: PrincipledMaterial.NoLighting }
                    }
                    Vigor { visible: !root.externalModel; axisX: motion.x; axisY: motion.y; axisZ: motion.z; surroundings: root.showExtras }
                    Node {
                        id: machineModel
                        objectName: "machineModel"
                        scale: root.convertedModel ? Qt.vector3d(540,540,540) : Qt.vector3d(root.modelScale,root.modelScale,root.modelScale)
                        RuntimeLoader {
                            id: loader
                            objectName: "runtimeLoader"
                            source: root.convertedModel ? "" : root.modelUrl
                            position: Qt.vector3d(-root.modelCenter.x,-root.modelCenter.y,-root.modelCenter.z)
                            onBoundsChanged: {
                                const lo=bounds.minimum, hi=bounds.maximum
                                const extent=Math.max(hi.x-lo.x,hi.y-lo.y,hi.z-lo.z)
                                if(extent>0) {
                                    root.modelScale=5500/extent
                                    root.modelCenter=Qt.vector3d((lo.x+hi.x)/2,lo.y,(lo.z+hi.z)/2)
                                    root.modelHeight=(hi.y-lo.y)*root.modelScale
                                    root.homeView()
                                }
                            }
                            
                        }

                    }
                    CameraNavigation { id: navigation; objectName: "cameraNavigation"; anchors.fill: parent; origin: orbit; camera: camera }
                }
                Column {
                    anchors.left: parent.left; anchors.top: parent.top; anchors.margins: 22; spacing: 7
                    Label { text: root.externalModel ? "VIGOR 2136" : "VIGOR · DÜZ TABLA CNC"; color: "#23374c"; font.pixelSize: 14; font.bold: true; font.letterSpacing: 1 }
                    Label { text: root.externalModel ? "3660 × 2100 × 120 mm · sade görünüm" : "Görsel referanstan oluşturulan model · 2100 × 3660 mm"; color: "#526779"; font.pixelSize: 12 }
                }
                Rectangle {
                    anchors.right: parent.right; anchors.top: parent.top; anchors.margins: 18
                    width: 105; height: 50; radius: 9; color: "#f9fcff"
                    Column { anchors.centerIn: parent; spacing: 2
                        Label { anchors.horizontalCenter: parent.horizontalCenter; text: root.measuredFps.toFixed(0)+" FPS"; color: "#245ee8"; font.bold: true; font.pixelSize: 18 }
                        Label { text: motion.running ? "HAREKETLİ SAHNE" : "ANLIK ÇİZİM"; color: "#8190a2"; font.pixelSize: 9 }
                    }
                }
                Rectangle {
                    anchors.centerIn: parent; visible: root.modelState==="error"
                    width: Math.min(parent.width-60,480); height: errorLabel.implicitHeight+40; radius: 10; color: "#fff0ec"
                    Label { id: errorLabel; anchors.centerIn: parent; width: parent.width-40; wrapMode: Text.Wrap; text: "Model yüklenemedi.\n" + (root.convertedModel && root.convertedComponent ? root.convertedComponent.errorString() : loader.errorString); color: "#a14633" }
                }
                RowLayout {
                    anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; anchors.margins: 18
                    ActionButton { text: "İzometrik"; onClicked: root.homeView() }
                    ActionButton { text: "Üst"; onClicked: { orbit.position=Qt.vector3d(0,root.externalModel ? root.modelHeight/2 : 650,0); orbit.eulerRotation=Qt.vector3d(-89.9,-90,0); navigation.setDistance(14500) } }
                    ActionButton { text: "Ön"; onClicked: { orbit.position=Qt.vector3d(0,root.externalModel ? root.modelHeight/2 : 750,0); orbit.eulerRotation=Qt.vector3d(0,-90,0); navigation.setDistance(14500) } }
                    Item { Layout.fillWidth: true }
                    Label { text: "Sürükle: döndür\nTekerlek: yakınlaştır"; color: "#9aacc0"; font.pixelSize: 11 }
                }
            }
            Rectangle {
                Layout.preferredWidth: 310; Layout.fillHeight: true
                color: "white"; radius: 12
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 18; spacing: 8
                    Label { text: "EKSENLER"; color: "#253b52"; font.pixelSize: 15; font.bold: true; font.letterSpacing: 1 }
                    Label { Layout.fillWidth: true; text: root.externalModel ? (root.motionBound ? "Ana makine · X/Y/Z hareket simülasyonu." : "Gerçek Vigor modeli yüklendi; eksen eşlemesi bekleniyor.") : "Sürgüleri hareket ettirin veya otomatik demoyu başlatın."; wrapMode: Text.Wrap; color: "#7a8b9e"; font.pixelSize: 12 }
                    ColumnLayout {
                        Layout.fillWidth: true; spacing: 8; enabled: true; opacity: 1
                        AxisControl { Layout.fillWidth: true; axisName: "X"; axisIndex: 0; limit: 3660; currentValue: motion.x }
                        AxisControl { Layout.fillWidth: true; axisName: "Y"; axisIndex: 1; limit: 2100; currentValue: motion.y }
                        AxisControl { Layout.fillWidth: true; axisName: "Z"; axisIndex: 2; limit: 120; currentValue: motion.z }
                    }
                    Rectangle { Layout.fillWidth: true; height: 1; color: "#e8edf3" }
                    RowLayout {
                        Layout.fillWidth: true
                        Label { text: "Demo hızı"; color: "#566b81"; font.pixelSize: 12 }
                        Item { Layout.fillWidth: true }
                        Label { text: motion.speed.toFixed(2)+"×"; color: "#245ee8"; font.bold: true }
                    }
                    Slider { Layout.fillWidth: true; from: 0.25; to: 3; value: motion.speed; onMoved: motion.speed=value; enabled: true }
                    RowLayout {
                        Layout.fillWidth: true
                        ActionButton { Layout.fillWidth: true; primary: true; enabled: true; text: motion.running ? "Hareketi duraklat" : "Hareketi başlat"; onClicked: motion.running?motion.pause():motion.play() }
                        ActionButton { text: "Sıfırla"; enabled: true; onClicked: motion.reset() }
                    }

                    Item { Layout.fillHeight: true }
                    ActionButton { Layout.fillWidth: true; text: "3D model aç…"; onClicked: modelDialog.open() }
                    ActionButton { Layout.fillWidth: true; visible: false; text: "Temsili modele dön"; onClicked: { root.modelUrl=""; motion.reset(); root.homeView() } }
                    Label { Layout.fillWidth: true; visible: !root.externalModel; text: "GLB / glTF / OBJ\nVigor görselleri esas alındı; CAD modeli değildir."; color: "#8695a6"; font.pixelSize: 11; wrapMode: Text.Wrap }
                }
            }
        }
        Rectangle {
            Layout.fillWidth: true; Layout.preferredHeight: 34; color: "#17324f"
            RowLayout {
                anchors.fill: parent; anchors.leftMargin: 24; anchors.rightMargin: 24
                Label { text: "●  YEREL MASAÜSTÜ"; color: "#99d9c0"; font.pixelSize: 10; font.bold: true }
                Label { text: "   C++ / Qt Quick 3D"; color: "#a8bcd1"; font.pixelSize: 10 }
                Item { Layout.fillWidth: true }
                Label { text: "VIGOR 0.4  ·  Eksenler simüle edilir  ·  Talaş kaldırma yok"; color: "#d0dbe7"; font.pixelSize: 10 }
            }
        }
    }
}




