import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls 2.0

Flickable {
    property var name
    property var electrodes
    contentHeight: rect.height
    contentWidth: rect.width

    Rectangle {
        id: rect
        width: parent.width
        height: (destination.height + destination.height)* 1.1
        anchors.fill: parent

        Column {
            id: destination

            anchors {left: parent.left; top: parent.top; margins: 5}
            width: parent.width
            spacing: 10
            padding: 5

            Repeater {
                model: electrodes;
                delegate: BasicElectrode {
                    size: 40
                    columnCount: columns
                    rowCount: rows
                }
            }
        }
        Column {
            id: source
            anchors {right: parent.right; top: parent.top; bottom: parent.bottom; margins: 5}
            width: 64
            spacing: 5
            Repeater {
                model: 12
                delegate: DragItem {
                    size: 40
                }
            }
        }
    }
    Button {
        id: confirmButton
        text: "Confirm"
        x: (parent.width - width) / 2
        y: parent.height
        anchors.margins: 20
        onClicked: {}
    }
    ScrollIndicator.vertical: ScrollIndicator { }
}
