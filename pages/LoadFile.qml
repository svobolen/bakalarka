import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.0

Pane {

    Column {

        FileDialog {
            id: fileDialog
            title: qsTr("Please choose a file")
            nameFilters: [ "CSV files (*.csv)", "All files (*)" ]
            folder: shortcuts.home
            onAccepted: {
                console.log("You chose: " + fileDialog.fileUrls)
            }
            onRejected: {
                console.log("Canceled")
            }
            //Component.onCompleted: visible = true

        }
        Button {
            id: openButton
            text: qsTr("Open file")
            onClicked: fileDialog.open()
        }
    }
}

