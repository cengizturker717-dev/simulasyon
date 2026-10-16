import QtQuick
import QtQuick3D

Item {
    id: navigation
    required property Node origin
    required property PerspectiveCamera camera
    property real minimumDistance: 1200
    property real maximumDistance: 10000
    property real targetDistance: 6000
    property real animatedDistance: targetDistance
    property bool smoothing: true
    property bool pendingDrag: false
    property bool pendingPan: false
    property vector3d pendingRotation
    property vector3d pendingPosition
    // Keep every input delta, but publish one camera pose per display interval.
    // A slow renderer cannot build a backlog of intermediate camera poses.
    function flushDrag() {
        dragRefresh.stop()
        if (!pendingDrag) return
        if (pendingPan) origin.position = pendingPosition
        else origin.eulerRotation = pendingRotation
        pendingDrag = false
    }
    function queueDrag(dx, dy, pan) {
        if (pendingDrag && pendingPan !== pan) flushDrag()
        if (!pendingDrag) {
            pendingRotation = origin.eulerRotation
            pendingPosition = origin.position
            pendingPan = pan
        }
        if (pan) {
            const unitsPerPixel = 2*camera.z*Math.tan(camera.fieldOfView*Math.PI/360)/Math.max(1,height)
            pendingPosition = pendingPosition.plus(origin.right.times(-dx*unitsPerPixel)).plus(origin.up.times(dy*unitsPerPixel))
        } else {
            pendingRotation = Qt.vector3d(Math.max(-89.9,Math.min(0,pendingRotation.x-dy*0.25)),pendingRotation.y-dx*0.25,0)
        }
        pendingDrag = true
        if (!dragRefresh.running) dragRefresh.start()
    }
    Timer { id: dragRefresh; interval: 16; repeat: false; onTriggered: navigation.flushDrag() }
    function setDistance(distance) {
        flushDrag()
        targetDistance = Math.max(minimumDistance, Math.min(maximumDistance, distance))
    }
    function zoomBy(delta) {
        // Exponential steps remain positive, even for high-resolution wheel input.
        setDistance(targetDistance * Math.exp(-Math.max(-600, Math.min(600, delta)) * 0.001))
    }
    Binding { target: navigation.camera; property: "z"; value: navigation.animatedDistance }
    Behavior on animatedDistance {
        enabled: navigation.smoothing
        SmoothedAnimation { duration: 120; velocity: -1 }
    }
    // Keep clipping planes in the camera, independent of navigation distance.
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
        property point previous
        onPressed: mouse => { previous=Qt.point(mouse.x, mouse.y) }
        onPositionChanged: mouse => {
            if(!pressed) return
            const dx=mouse.x-previous.x, dy=mouse.y-previous.y
            previous=Qt.point(mouse.x, mouse.y)
            navigation.queueDrag(dx,dy,Boolean((mouse.modifiers & Qt.ControlModifier) || (pressedButtons & (Qt.MiddleButton | Qt.RightButton))))
        }
        onReleased: navigation.flushDrag()
        onCanceled: navigation.flushDrag()
        onWheel: wheel => {
            navigation.zoomBy(wheel.pixelDelta.y !== 0 ? wheel.pixelDelta.y*2 : wheel.angleDelta.y)
            wheel.accepted=true
        }
    }
}
