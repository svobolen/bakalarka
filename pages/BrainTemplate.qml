import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2

Image {

    property string sourceImg
    property bool checkboxVisible: false
    property alias imgChecked: checkbox.checked
    readonly property string plusImgSource: "qrc:/images/plus.png"
//    property alias manager: ImageManager.imageModel


    id: brainImage
    source: sourceImg
    fillMode: Image.PreserveAspectFit
    width: parent.width/2
    height: parent.height/2

    Component {
        id: fileDialogComponent
        FileDialog {
            id: fileDialog
            title: qsTr("Please choose a file")
            nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]
            folder: shortcuts.pictures
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
                var fileExtension = source.substring(source.length-4,source.length)
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
            Component.onCompleted: {
                console.log("Opening file dialog.")
                fileDialog.open()
            }
        }
    }

    Loader {
        id: loader
    }
    InfoPopup {
        id: info
        msg: "Please choose a image file (*.jpg, *.png)"
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
                loader.sourceComponent = fileDialogComponent
      //          fileDialog.open()
            } else {
                checkbox.checked = (checkbox.checked) ? false : true
            }
        }
        onPressAndHold: menu.open()
        Menu {
            id: menu
            x: mouseArea.mouseX
            y: mouseArea.mouseY

            MenuItem {
                text: qsTr("Change")
                onClicked: loader.sourceComponent = fileDialogComponent
                //                onClicked: fileDialog.open()
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
