import QtQuick 2.6
import QtQuick.Controls 2.0

Item {
    id: root
    property int columnCount
    property int rowCount
    property int highestZ: 0            //posledni obrazek je nahore
    property bool draggable: false
    property bool flickable: true
    property int size: 20
    width: columnCount*size; height: rowCount*size;

    Flickable {
        id: flick
        enabled: flickable

        Rectangle {
            id: electrode
            width: columnCount*size; height: rowCount*size; radius: size/2
            opacity: 0.8
            border.color: "grey"

            Behavior on scale { NumberAnimation { duration: 200 } }
            Behavior on x { NumberAnimation { duration: 200 } }
            Behavior on y { NumberAnimation { duration: 200 } }

            Column {
                id: column
                Repeater {
                    model: rowCount
                    Row {
                        id: row
                        Repeater {
                            model: columnCount

                            DropArea {
                                id: dragTarget
                                property alias dropProxy: dragTarget
                                width: size; height: size

                                Rectangle {
                                    id: dropRectangle
                                    opacity: 0.8
                                    width: size; height: size; radius: size/2
                                    color: "red"
                                    border.color: "grey"
                                    states: [
                                        State {
                                            when: dragTarget.containsDrag
                                            PropertyChanges {
                                                target: dropRectangle
                                                color: "green"
                                            }
                                        }
                                    ]
                                    Text {
                                        text: columnCount*(rowCount-row.getIndex()) + (modelData+1)
                                        anchors.fill: parent
                                        horizontalAlignment:Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }
                            }
                        }
                        Rectangle {
                            opacity: 0.8
                            width: size + 5; height: 6; radius: 3
                            y: size / 2 - height / 2
                            border.color: "grey"
                        }
                        function getIndex() {
                            return index + 1
                        }
                    }
                }
            }

            PinchArea {
                enabled: draggable
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
                    id: mouseArea
                    hoverEnabled: true
                    anchors.fill: parent
                    drag.target: electrode
                    scrollGestureEnabled: false  // 2-finger-flick gesture should pass through to the Flickable
                    onPressAndHold: { menu.open() }
                    onPressed: { electrode.z = ++root.highestZ }
                    onWheel: {
                        if (draggable) {
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

            Menu {
                id: menu
                x: mouseArea.mouseX
                y: mouseArea.mouseY

                MenuItem {
                    text: qsTr("Fix position")
                    onClicked: {
                        draggable = false
                        mouseArea.drag.target = null
                    }
                }
                MenuItem {
                    text: qsTr("Change position")
                    onClicked: {
                        draggable = true
                        mouseArea.drag.target = electrode
                    }
                }
            }
        }
    }
}
