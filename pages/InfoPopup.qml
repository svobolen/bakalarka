import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Window 2.2

Popup {
    property string msg

    id: info
    modal: true
    focus: true
    x: (window.width - width) / 2
    y: (window.height - height) / 6
    Column {
        spacing: 10
        Label { text: qsTr("<b>Information</b>") }
        Label { text: qsTr(msg) }
        Button {
            text: qsTr("OK")
            onClicked: {
                info.close()
            }
        }
    }
}
