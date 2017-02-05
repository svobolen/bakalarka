import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2

Image {

    property string sourceImg

    id: brainImage
    source: sourceImg
    fillMode: Image.PreserveAspectFit
    width: parent.width/2
    height: parent.height/2

    FileDialog {
        id: fileDialog
        title: qsTr("Please choose a file")
        nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]
        folder: shortcuts.pictures
        onAccepted: {
            brainImage.source = fileDialog.fileUrl
            brainImage.opacity = 1
            var component = Qt.createComponent("qrc:/pages/BrainTemplate.qml");
            var elec = component.createObject(parent, {sourceImg: "qrc:/images/plus.png"});
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
            if (brainImage.source == "qrc:/images/plus.png")
                fileDialog.open()
            else
                brainImage.opacity = (brainImage.opacity == 0.5) ? 1 : 0.5
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
                    console.log("Component destroyed.")
                    brainImage.destroy()
                    //                    brainImage.source = "qrc:/images/plus.png";
                    //                    brainImage.opacity = 1;
                }
            }
        }
    }
}
