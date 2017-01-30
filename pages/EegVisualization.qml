
import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2

Pane {
    id: pane

    SwipeView {
        id: view
        currentIndex: 0
        anchors.fill: parent

        Pane {
            id: firstPage
            width: view.width
            height: view.height

            Label {
                text: "Vyberte jedno nebo více schémat. Můžete nahrát i vlastní fotografie a obrázky."
                font.pixelSize: 13
                font.italic: true
                anchors.margins: 5
                anchors.bottom: grid.top
                anchors.left: parent.left
                anchors.right: parent.right
                horizontalAlignment: Label.AlignHCenter
                wrapMode: Label.Wrap
            }

            Grid {
                id: grid
                columns: 2
                columnSpacing: 10
                width: parent.width
                height: parent.height

                Repeater {
                    model:
                        ["qrc:/images/brains/brain1.png",
                        "qrc:/images/brains/brain2.jpg",
                        "qrc:/images/brains/brain3.png",
                        "qrc:/images/brains/brain4.png"]
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
        }
        Pane {
            id: secondPage
            width: view.width
            height: view.height

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
                            title: "Please choose a file"
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
                                    text: "Change"
                                    onClicked: fileDialog.open()
                                }
                                MenuItem {
                                    text: "Delete"
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
                text: "Potvrdit výběr"
                anchors.margins: 10
                anchors.bottomMargin: 50
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
//            onClicked:

            }
        }
    }

    PageIndicator {
        id: indicator
        count: view.count
        currentIndex: view.currentIndex
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
