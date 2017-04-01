import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2

Image {

    property string sourceImg
    property bool checkboxVisible: false
    property alias imgChecked: checkbox.checked
    readonly property string plusImgSource: "qrc:/images/plus.png"

    id: brainImage
    source: sourceImg
    fillMode: Image.PreserveAspectFit
    width: parent.width/2
    height: parent.height/2

    FileDialog {
        id: fileDialog
        nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]
        folder: shortcuts.documents
        onAccepted: {
            var path = fileDialog.fileUrl
            if (fileDialog.checkIfImage(path.toString())) {
                fileDialog.addImage(path)
            } else {
                console.log("Chosen file is not an image.")
                info.open()
            }
        }
        onRejected: {
            console.log("Choosing file canceled.")
        }
        function checkIfImage(source) {
            var fileExtension = source.substring(source.length-4,source.length).toLowerCase()
            return ( (fileExtension === (".jpg")) || (fileExtension === ".png") )
        }
        function addImage(source) {
            //add new empty plus image when you add new image
            //                if (brainImage.source == plusImgSource) {
            //                    var component = Qt.createComponent("qrc:/pages/BrainTemplate.qml");
            //                    var elec = component.createObject(parent.parent, {sourceImg: plusImgSource});
            //                }
            brainImage.source = source
            sourceImg = source
            checkbox.visible = true
            checkbox.checked = false
            console.log("You chose: " + source)
        }
    }

    Popup {
        id: info
        modal: true
        focus: true
        x: (window.width - width) / 2
        y: (window.height - height) / 6
        Column {
            spacing: 10
            Label { text: qsTr("<b>Information</b>") }
            Label { text: qsTr("Please choose a image file (*.jpg, *.png)") }
            Button {
                text: qsTr("OK")
                onClicked: {
                    info.close()
                }
            }
        }
    }
    CheckBox {
        id: checkbox
        visible: checkboxVisible
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

        onCheckStateChanged: {
            brainImage.opacity = checkbox.checked ? 0.5 : 1
        }
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            if (brainImage.source == plusImgSource) {
                fileDialog.open()
            } else {
                checkbox.checked = !checkbox.checked
            }
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
                    brainImage.source = plusImgSource;
                    checkbox.visible = false
                    checkbox.checked = false
                    console.log("Image has been deleted.")
                }
            }
        }
    }

}
