import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2

Pane {
    id: pane

    SwipeView {
        id: swipe
        currentIndex: 0
        anchors {fill: parent; bottom: indicator.top}

        Pane {
            id: firstPage
            width: swipe.width
            height: swipe.height

            Label {
                id: label
                text: qsTr("Choose one or more images. You can upload your own photos or pictures.")
                font {pixelSize: 13; italic: true}
                width: parent.width
                anchors {margins: 5; left: parent.left; right: parent.right}
                horizontalAlignment: Qt.AlignHCenter
                wrapMode: Label.Wrap
            }
            Grid {
                id: grid
                columns: 2
                columnSpacing: 10
                width: parent.width
                height: parent.height
                anchors.top: label.bottom

                Repeater {
                    model:
                        ["qrc:/images/brains/brain1.png",
                        "qrc:/images/brains/brain3.png",
                        "qrc:/images/brains/brain4.png",
                        "qrc:/images/brains/brain2.jpg"]
                    Image {
                        id: brain1
                        source: modelData
                        fillMode: Image.PreserveAspectFit
                        width: parent.width/2
                        height: parent.height/2

                        MouseArea {
                            anchors.fill: parent
                            onClicked: brain1.opacity = (brain1.opacity == 0.5) ? 1 : 0.5
                        }
                    }
                }
            }
            PinchArea {
                anchors.fill: parent
                pinch.target: firstPage
                pinch.minimumScale: 1
                pinch.maximumScale: 10
                pinch.dragAxis: Pinch.XAndYAxis
                onSmartZoom: {
                    if (pinch.scale > 0) {
                       firstPage.scale = pinch.scale
                    } else {
                        firstPage.scale = pinch.previousScale
                    }
                }
                onPinchFinished: {
                    firstPage.scale = 1
                    firstPage.x = 0
                    firstPage.y = 0
                }
            }
        }
        Pane {
            id: secondPage
            width: swipe.width
            height: swipe.height

            Grid {
                id: grid2
                columns: 2
                columnSpacing: 10
                width: parent.width
                height: parent.height

                Repeater {
                    model: 2

                    Image {
                        id: brain2
                        source: "qrc:/images/plus.png"
                        fillMode: Image.PreserveAspectFit
                        width: parent.width/2
                        height: parent.height/2

                        FileDialog {
                            id: fileDialog
                            title: qsTr("Please choose a file")
                            nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]
                            folder: shortcuts.pictures
                            onAccepted: {
                                brain2.source = fileDialog.fileUrl
                                brain2.opacity = 1
                                console.log("You chose: " + fileDialog.fileUrls)
                            }
                            onRejected: {
                                console.log("Canceled")
                            }
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            onClicked: {
                                if (brain2.source == "qrc:/images/plus.png")
                                    fileDialog.open()
                                else
                                    brain2.opacity = (brain2.opacity == 0.5) ? 1 : 0.5
                            }

                            onPressAndHold: menu.open()
                            Menu {
                                id: menu
                                x: mouseArea.mouseX
                                y: mouseArea.mouseY

                                MenuItem {
                                    text: qsTr("Change")
                                    onClicked: fileDialog.open()
                                }
                                MenuItem {
                                    text: qsTr("Delete")
                                    onClicked: {
                                        brain2.source = "qrc:/images/plus.png";
                                        brain2.opacity = 1;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            Button {
                id: okButton
                text: qsTr("OK")
                anchors {margins: 10; bottomMargin: 50; bottom: parent.bottom; horizontalCenter: parent.horizontalCenter}
                //            onClicked:
            }
            PinchArea {
                anchors.fill: parent
                pinch.target: secondPage
                pinch.minimumScale: 1
                pinch.maximumScale: 10
                pinch.dragAxis: Pinch.XAndYAxis
                onSmartZoom: {
                    if (pinch.scale > 0) {
                       secondPage.scale = pinch.scale
                    } else {
                        secondPage.scale = pinch.previousScale
                    }
                }
                onPinchFinished: {
                    secondPage.scale = 1
                    secondPage.x = swipe.width
                    secondPage.y = 0
                }
            }
        }
    }
    PageIndicator {
        id: indicator
        count: swipe.count
        currentIndex: swipe.currentIndex
        anchors {bottom: parent.bottom; horizontalCenter: parent.horizontalCenter}
    }
}
