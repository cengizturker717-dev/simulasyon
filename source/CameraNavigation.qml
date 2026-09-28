import QtQuick
import QtQuick3D

Item {
    id: navigation
    required property Node origin
    required property PerspectiveCamera camera
    property real minimumDistance: 6000
    property real maximumDistance: 35000
    property real targetDistance: 12500
    property real animatedDistance: targetDistance
    property bool smoothing: true
    function setDistance(distance) {
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
            if((mouse.modifiers & Qt.ControlModifier) || (pressedButtons & (Qt.MiddleButton | Qt.RightButton))) {
                const unitsPerPixel=2*navigation.camera.z*Math.tan(navigation.camera.fieldOfView*Math.PI/360)/Math.max(1,height)
                navigation.origin.position=navigation.origin.position.plus(navigation.origin.right.times(-dx*unitsPerPixel)).plus(navigation.origin.up.times(dy*unitsPerPixel))
            } else {
                const rotation=navigation.origin.eulerRotation
                navigation.origin.eulerRotation=Qt.vector3d(Math.max(-89.9,Math.min(0,rotation.x-dy*0.25)),rotation.y-dx*0.25,0)
            }
        }
        onWheel: wheel => {
            navigation.zoomBy(wheel.pixelDelta.y !== 0 ? wheel.pixelDelta.y*2 : wheel.angleDelta.y)
            wheel.accepted=true
        }
    }
}
