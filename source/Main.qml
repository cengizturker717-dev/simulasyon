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
    onVisibilityChanged: { if (root.visibility === Window.Minimized) motion.pause() }
    visible: true
    title: "POYRAZ | SolidSim Native — 3D HMI Prototipi"
    color: "#11161e"
    palette.window: "#1b2430"
    palette.windowText: "#e5edf7"
    palette.base: "#111a25"
    palette.alternateBase: "#253247"
    palette.text: "#e5edf7"
    palette.button: "#2b394d"
    palette.buttonText: "#e5edf7"
    palette.highlight: "#245ee8"
    palette.highlightedText: "#ffffff"
    palette.mid: "#405067"
    palette.light: "#405067"
    palette.dark: "#11161e"
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
    function showPcni() { programDialog.open() }
    function inspectionView() {
        orbit.position=Qt.vector3d(540,780,0)
        orbit.eulerRotation=Qt.vector3d(-25,25,0)
        navigation.setDistance(2800)
    }
    component ActionButton: Button {
        id: control
        property bool primary: false
        implicitHeight: 42
        font.pixelSize: 13
        background: Rectangle {
            radius: 7
            color: control.primary ? (control.down ? "#1846bd" : "#245ee8") : (control.hovered ? "#303f54" : "#1b2430")
            border.color: control.primary ? "#245ee8" : "#405067"
        }
        contentItem: Text { text: control.text; font: control.font; color: control.primary ? "white" : "#e5edf7"; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
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
            Label { text: axis.axisName; color: "#82afff"; font.pixelSize: 17; font.bold: true }
            Item { Layout.fillWidth: true }
            Label { text: axis.currentValue.toFixed(1); color: "#eef4fb"; font.pixelSize: 23; font.family: "Consolas" }
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
    FolderDialog {
        id: machineFolder
        title: "User klasörünü içeren makine data klasörünü seçin"
        onAccepted: { motion.clearPath(); pcni.root=decodeURIComponent(selectedFolder.toString().replace(/^file:\/\/\//, "")) }
    }
    Dialog {
        id: cniDialog
        title: "CNI / NcOne simülatörü — canlı konum okuma"
        anchors.centerIn: parent; width: 620; modal: true
        standardButtons: Dialog.Close
        onOpened: motion.pause()
        contentItem: ColumnLayout {
            spacing: 18
            Label { Layout.fillWidth: true; text: cni.status; wrapMode: Text.Wrap; color: cni.fresh ? "#9ee1b7" : "#edbe75" }
            Label { text: "X: " + (cni.fresh ? cni.x.toFixed(3)+" mm" : "—"); font.pixelSize: 23 }
            Label { text: "Y: " + (cni.fresh ? cni.y.toFixed(3)+" mm" : "—"); font.pixelSize: 23 }
            Label { text: "Z: " + (cni.fresh ? cni.z.toFixed(3)+" mm" : "—"); font.pixelSize: 23 }
            Label { Layout.fillWidth: true; text: "Ham değerleri NcOne eksen ekranıyla karşılaştırın. 3D model, makine datasındaki eksen limitlerine göre ölçeklenir. NcOne'a komut gönderilmez."; wrapMode: Text.Wrap }
            RowLayout {
                Button { text: "CNI verisini oku"; enabled: !cni.active; onClicked: cni.start() }
                Button { text: "Bağlantıyı kes"; enabled: cni.active; onClicked: cni.stop() }
            }
        }
    }
    Dialog {
        id: programDialog
        title: "PCNI programları ve etiketler — çevrimdışı X/Y önizleme"
        width: Math.min(root.width-50,1040); height: Math.min(root.height-50,760)
        anchors.centerIn: parent; modal: true
        standardButtons: Dialog.Close
        onOpened: motion.pause()
        contentItem: ColumnLayout {
            RowLayout {
                Layout.fillWidth: true
                ComboBox { id: programChoice; Layout.fillWidth: true; model: pcni.programs }
                Button { text: "Programı oku"; enabled: programChoice.currentIndex>=0; onClicked: {motion.clearPath();pcni.load(programChoice.currentText)} }
                Button { text: "Yenile"; onClicked: {motion.clearPath();pcni.refresh()} }
                Button { text: "Klasör seç"; onClicked: machineFolder.open() }
            }
            Label { Layout.fillWidth: true; text: pcni.root; elide: Text.ElideMiddle; color: "#b6c4d6" }
            Label { Layout.fillWidth: true; text: pcni.name + "\n" + pcni.status; wrapMode: Text.Wrap }
            RowLayout {
                Layout.fillWidth: true; Layout.fillHeight: true
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; color: "#202833"
                    Canvas {
                        id: pathCanvas; anchors.fill: parent; anchors.margins: 15
                        onWidthChanged: requestPaint()
                        onHeightChanged: requestPaint()
                        Connections { target: pcni; function onChanged() { pathCanvas.requestPaint() } }
                        onPaint: {
                            let c=getContext("2d"); c.clearRect(0,0,width,height)
                            if(pcni.width<=0 || pcni.height<=0) return
                            let scale=Math.min((width-20)/pcni.width,(height-20)/pcni.height)
                            let ox=10, oy=height-10
                            c.fillStyle="#dac59e"; c.fillRect(ox,oy-pcni.height*scale,pcni.width*scale,pcni.height*scale)
                            let pts=pcni.points
                            for(let i=1;i<pts.length;i++) {
                                c.beginPath(); c.strokeStyle=pts[i].travel?"#a5abb1":"#245ee8"; c.lineWidth=pts[i].travel?0.7:1.5
                                c.moveTo(ox+pts[i-1].x*scale,oy-pts[i-1].y*scale)
                                c.lineTo(ox+pts[i].x*scale,oy-pts[i].y*scale); c.stroke()
                            }
                            c.font="12px sans-serif"; c.fillStyle="#80330f"
                            for(let tag of pcni.labels) c.fillText(String(tag.index),ox+tag.x*scale,oy-tag.y*scale)
                        }
                    }
                }
                ListView {
                    id: labelList; Layout.preferredWidth: 250; Layout.fillHeight: true; clip: true
                    spacing: 8; model: pcni.labels
                    delegate: Column {
                        required property var modelData
                        width: 235; spacing: 4
                        Label { text: "Etiket " + modelData.index + " · X " + modelData.x + " / Y " + modelData.y }
                        Image { width: 225; height: 155; source: modelData.image; fillMode: Image.PreserveAspectFit; asynchronous: true; sourceSize.width: 450 }
                        Label { visible: modelData.image.length===0; text: "Etiket görseli bulunamadı"; color: "#b34a32" }
                    }
                }
            }
            Label { Layout.fillWidth: true; text: "Mavi: kesim yolu · Gri: geçiş · Numaralar: etiket konumları\nTablada kesim düz freze ve sabit derinlik kullanır; CNI Z çevrimleri uygulanmaz."; wrapMode: Text.Wrap }
            Button {
                text: "Plakayı makine tablasına yükle"; enabled: pcni.ready && pcni.thickness>0
                onClicked: {
                    if(motion.loadPath(pcni.points)) {
                        stock.configure(pcni.width,pcni.height,pcni.thickness,pcni.toolDiameter)
                        root.homeView();programDialog.close()
                    }
                }
            }
        }
    }
    ColumnLayout {
        anchors.fill: parent; spacing: 0
        Rectangle {
            Layout.fillWidth: true; Layout.preferredHeight: 84
            color: "#1b2430"
            RowLayout {
                anchors.fill: parent; anchors.leftMargin: 28; anchors.rightMargin: 28; spacing: 22
                Rectangle { width: 5; height: 35; radius: 2; color: "#f47927" }
                ColumnLayout {
                    spacing: 0
                    Label { text: "POYRAZ"; color: "#eef4fb"; font.pixelSize: 28; font.bold: true; font.letterSpacing: 3 }
                    Label { text: "MAKİNA  /  SOLIDSIM NATIVE"; color: "#aab9ce"; font.pixelSize: 10; font.letterSpacing: 1.5 }
                }
                Rectangle { width: 1; height: 34; color: "#344154" }
                ColumnLayout {
                    spacing: 3
                    Label { text: "VIGOR 2136"; color: "#e5edf7"; font.bold: true; font.pixelSize: 17 }
                    Label { text: "3D makine ve eksen hareketi prototipi"; color: "#aab9ce"; font.pixelSize: 12 }
                }
                Item { Layout.fillWidth: true }
                Rectangle {
                    implicitWidth: 210; implicitHeight: 33; radius: 16; color: "#253c35"
                    Label { anchors.centerIn: parent; text: root.externalModel ? (root.motionBound ? "VIGOR · SİMÜLASYON" : "VIGOR · GERÇEK MODEL") : "DEMO · MAKİNE BAĞLI DEĞİL"; color: root.externalModel ? "#9ee1b7" : "#edbe75"; font.bold: true; font.pixelSize: 11 }
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
                        clearColor: "#202833"
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
                        Node {
                            visible: motion.programMode && root.convertedModel
                            // Model coordinates are metres; stock mesh coordinates are mm.
                            position: Qt.vector3d(-0.3099066,1.0825051,-1.2046434)
                            scale: Qt.vector3d(0.001,0.001,0.001)
                            Model {
                                objectName: "stockOnTable"
                                geometry: stock
                                materials: PrincipledMaterial { baseColor: "white"; vertexColorsEnabled: true; roughness: 0.9; cullMode: Material.NoCulling }
                            }
                        }
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
                    Label { text: "VIGOR 2136 / TABLADA İŞLEME"; color: "#e5edf7"; font.pixelSize: 14; font.bold: true; font.letterSpacing: 1 }
                    Label { text: motion.programMode ? stock.stockWidth+" × "+stock.stockHeight+" × "+stock.thickness+" mm · 2 mm hücre" : "3660 × 2100 × 120 mm · sade görünüm"; color: "#b6c4d6"; font.pixelSize: 12 }
                }
                Rectangle {
                    anchors.right: parent.right; anchors.top: parent.top; anchors.margins: 18
                    width: 105; height: 50; radius: 9; color: "#1b2430"
                    Column { anchors.centerIn: parent; spacing: 2
                        Label { anchors.horizontalCenter: parent.horizontalCenter; text: root.measuredFps.toFixed(0)+" FPS"; color: "#82afff"; font.bold: true; font.pixelSize: 18 }
                        Label { text: motion.running ? "HAREKETLİ SAHNE" : "ANLIK ÇİZİM"; color: "#8190a2"; font.pixelSize: 9 }
                    }
                }
                Rectangle {
                    anchors.centerIn: parent; visible: root.modelState==="error"
                    width: Math.min(parent.width-60,480); height: errorLabel.implicitHeight+40; radius: 10; color: "#482b2b"
                    Label { id: errorLabel; anchors.centerIn: parent; width: parent.width-40; wrapMode: Text.Wrap; text: "Model yüklenemedi.\n" + (root.convertedModel && root.convertedComponent ? root.convertedComponent.errorString() : loader.errorString); color: "#ffb09e" }
                }
                RowLayout {
                    anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; anchors.margins: 18
                    ActionButton { text: "İzometrik"; onClicked: root.homeView() }
                    ActionButton { text: "Üst"; onClicked: { orbit.position=Qt.vector3d(0,root.externalModel ? root.modelHeight/2 : 650,0); orbit.eulerRotation=Qt.vector3d(-89.9,-90,0); navigation.setDistance(8500) } }
                    ActionButton { text: "Ön"; onClicked: { orbit.position=Qt.vector3d(0,root.externalModel ? root.modelHeight/2 : 750,0); orbit.eulerRotation=Qt.vector3d(0,-90,0); navigation.setDistance(8500) } }
                    Item { Layout.fillWidth: true }
                    Label { text: "Sürükle: döndür\nTekerlek: yakınlaştır"; color: "#9aacc0"; font.pixelSize: 11 }
                }
            }
            Rectangle {
                Layout.preferredWidth: 310; Layout.fillHeight: true
                color: "#1b2430"; radius: 12
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 18; spacing: 8
                    Label { text: "EKSENLER"; color: "#e5edf7"; font.pixelSize: 15; font.bold: true; font.letterSpacing: 1 }
                    Label { Layout.fillWidth: true; text: motion.liveMode ? "CNI canlı izleme · salt okunur" : root.externalModel ? (root.motionBound ? "Ana makine · X/Y/Z hareket simülasyonu." : "Gerçek Vigor modeli yüklendi; eksen eşlemesi bekleniyor.") : "Sürgüleri hareket ettirin veya otomatik demoyu başlatın."; wrapMode: Text.Wrap; color: motion.liveMode ? "#9ee1b7" : "#aab9ce"; font.pixelSize: 12 }
                    ColumnLayout {
                        Layout.fillWidth: true; spacing: 8; enabled: !motion.programMode && !motion.liveMode; opacity: 1
                        AxisControl { Layout.fillWidth: true; axisName: "X"; axisIndex: 0; limit: 3660; currentValue: motion.x }
                        AxisControl { Layout.fillWidth: true; axisName: "Y"; axisIndex: 1; limit: 2100; currentValue: motion.y }
                        AxisControl { Layout.fillWidth: true; visible: !motion.programMode; axisName: "Z"; axisIndex: 2; limit: 120; currentValue: motion.z }
                    }
                    Rectangle { Layout.fillWidth: true; height: 1; color: "#344154" }
                    RowLayout {
                        Layout.fillWidth: true
                        Label { text: "Önizleme hızı"; color: "#b6c4d6"; font.pixelSize: 12 }
                        Item { Layout.fillWidth: true }
                        Label { text: motion.speed.toFixed(2)+"×"; color: "#82afff"; font.bold: true }
                    }
                    Slider { Layout.fillWidth: true; from: 0.25; to: 3; value: motion.speed; onMoved: motion.speed=value; enabled: !motion.liveMode }
                    RowLayout {
                        Layout.fillWidth: true
                        ActionButton { Layout.fillWidth: true; primary: true; enabled: !motion.liveMode; text: motion.liveMode ? "CNI canlı izleme" : motion.running ? "Hareketi duraklat" : "Hareketi başlat"; onClicked: motion.running?motion.pause():motion.play() }
                        ActionButton { text: "Sıfırla"; enabled: !motion.liveMode; onClicked: motion.reset() }
                    }

                    Label { Layout.fillWidth: true; visible: motion.programMode; text: pcni.name + "\nSabit derinlikli malzeme simülasyonu"; wrapMode: Text.Wrap; color: "#edbe75" }
                    RowLayout {
                        visible: motion.programMode
                        Label { text: "Takım çapı (mm)" }
                        SpinBox { from: 4; to: 50; value: stock.diameter; enabled: !motion.running; onValueModified: {motion.reset();stock.diameter=value} }
                    }
                    RowLayout {
                        visible: motion.programMode
                        Label { text: "Kesim derinliği" }
                        SpinBox { from: 0; to: stock.thickness; value: stock.depth; enabled: !motion.running; onValueModified: {motion.reset();stock.depth=value} }
                    }
                    Label { visible: motion.programMode; text: "Kaldırılan: "+stock.removed.toFixed(1)+" cm³"; color: "#245ee8" }
                    ActionButton { Layout.fillWidth: true; text: "PCNI programları / etiketler"; onClicked: programDialog.open() }
                    ActionButton { Layout.fillWidth: true; visible: motion.programMode; text: "PCNI önizlemeyi kapat"; onClicked: {motion.clearPath()} }
                    Item { Layout.fillHeight: true }
                    ActionButton { Layout.fillWidth: true; text: "CNI simülatörüne bağlan"; onClicked: cniDialog.open() }
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
                Label { text: "Çevrimdışı simülasyon · Düz freze / sabit derinlik · Makine bağlı değil"; color: "#d0dbe7"; font.pixelSize: 10 }
            }
        }
    }
}




