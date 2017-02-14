import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2

Image {

    property string sourceImg
    property bool checkboxVisible: false

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
            if (brainImage.source == "qrc:/images/plus.png") {
                var component = Qt.createComponent("qrc:/pages/BrainTemplate.qml");
                var elec = component.createObject(parent, {sourceImg: "qrc:/images/plus.png"});
            }
            brainImage.source = fileDialog.fileUrl
            checkbox.visible = true
            checkbox.checked = false
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
                checkbox.checked = (checkbox.checked) ? false : true
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
                    brainImage.source = "qrc:/images/plus.png";
                    checkbox.visible = false
                    checkbox.checked = false
                }
            }
        }
    }

    CheckBox {
        visible: checkboxVisible
        id: checkbox
        anchors.fill: parent
        indicator: Rectangle {
            implicitWidth: 26
            implicitHeight: 26
            x: checkbox.x + checkbox.width - 2*width
            y: checkbox.y + checkbox.height - 2*height
            radius: 3
            border.color: "black"

            Rectangle {
                width: 14
                height: 14
                x: 6
                y: 6
                radius: 2
                color: checkbox.checked ? "green" : "black"
                visible: checkbox.checked
            }
        }
        onCheckStateChanged: brainImage.opacity = checkbox.checked ? 0.5 : 1
        onPressAndHold: menu.open()
    }
}
