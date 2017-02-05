import QtQuick 2.6

Item {
    id: root
    property int columnCount
    property int rowCount
    property int highestZ: 0            //posledni obrazek je nahore
    width: columnCount*20; height: rowCount*20;

    Flickable {
        id: flick
//        anchors.fill: parent

        Rectangle {
            id: electrode
            width: columnCount*20; height: rowCount*20; radius: 10
            opacity: 0.8
            border.color: "grey"

            Behavior on scale { NumberAnimation { duration: 200 } }
            Behavior on x { NumberAnimation { duration: 200 } }
            Behavior on y { NumberAnimation { duration: 200 } }

            Column {
                Repeater {
                    model: rowCount
                    Row {
                        Repeater {
                            model: columnCount
                            Rectangle {
                                opacity: 0.8
                                width: 20; height: 20; radius: 10
                                border.color: "grey"
                                Text {
                                    text: modelData + 1
                                    anchors.fill: parent
                                    horizontalAlignment:Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                        }
                        Rectangle {
                            opacity: 0.8
                            width: 25; height: 6; radius: 3
                            y: 7
                            border.color: "grey" }
                    }
                }
            }
            PinchArea {
                anchors.fill: parent
                pinch.target: electrode
                pinch.minimumRotation: -360
                pinch.maximumRotation: 360
                pinch.minimumScale: 0.5
                pinch.maximumScale: 10
                pinch.dragAxis: Pinch.XAndYAxis
                property real zRestore: 0
                onSmartZoom: {
                    if (pinch.scale > 0) {
                        electrode.rotation = 0;
                        electrode.scale = Math.min(root.width, root.height) / Math.max(electrode.sourceSize.width, electrode.sourceSize.height) * 0.85
                        electrode.x = flick.contentX + (flick.width - electrode.width) / 2
                        electrode.y = flick.contentY + (flick.height - electrode.height) / 2
                        zRestore = electrode.z
                        electrode.z = ++root.highestZ;
                    } else {
                        electrode.rotation = pinch.previousAngle
                        electrode.scale = pinch.previousScale
                        electrode.x = pinch.previousCenter.x - electrode.width / 2
                        electrode.y = pinch.previousCenter.y - electrode.height / 2
                        electrode.z = zRestore
                        --root.highestZ
                    }
                }
                MouseArea {
                    hoverEnabled: true
                    anchors.fill: parent
                    drag.target: electrode
                    scrollGestureEnabled: false  // 2-finger-flick gesture should pass through to the Flickable
                    onPressed: {
                        electrode.z = ++root.highestZ;
                    }
                    onWheel: {
                        if (wheel.modifiers & Qt.ControlModifier) {
                            electrode.rotation += wheel.angleDelta.y / 120 * 5;
                            if (Math.abs(electrode.rotation) < 4)
                                electrode.rotation = 0;
                        } else {
                            electrode.rotation += wheel.angleDelta.x / 120;
                            if (Math.abs(electrode.rotation) < 0.6)
                                electrode.rotation = 0;
                            var scaleBefore = electrode.scale;
                            electrode.scale += electrode.scale * wheel.angleDelta.y / 120 / 10;
                        }
                    }
                }
            }
        }
    }
}

