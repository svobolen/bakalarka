import QtQuick 2.6
import QtQuick.Dialogs 1.0
import QtQuick.Window 2.1
import Qt.labs.folderlistmodel 1.0

Item {
    id: root
    property int highestZ: 0            //posledni obrazek je nahore

    Flickable {
        id: flick
        anchors.fill: parent

        Rectangle {
            id: electrode
            width: 10*20; height: 20; radius: 10
            border.color: "black"
            Behavior on scale { NumberAnimation { duration: 200 } }
            Behavior on x { NumberAnimation { duration: 200 } }
            Behavior on y { NumberAnimation { duration: 200 } }
            Row {
                Repeater {
                    model: 10
                    Rectangle {
                        width: 20; height: 20; radius: 10
                        border.color: "black"
                        Text {
                            text: modelData + 1
                            anchors.fill: parent
                            horizontalAlignment:Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
                Rectangle {
                    width: 30; height: 6; radius: 3
                    y: 7
                    border.color: "black" }
            }

            PinchArea {
                anchors.fill: parent
                pinch.target: electrode
                pinch.minimumRotation: -360
                pinch.maximumRotation: 360
                pinch.minimumScale: 0.1
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
                }
            }
        }
    }
}

