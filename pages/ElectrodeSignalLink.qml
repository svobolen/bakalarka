import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls 2.0

Rectangle {
    property var name
    property var electrodes
//    color: "black"

    Column {
        id: destination

        anchors {left: parent.left; top: parent.top; margins: 5}
        width: parent.width
        spacing: 5
        padding: 5

        Repeater {
            model: electrodes;
            delegate: Electrode {
                size: 40
                columnCount: columns
                rowCount: rows
                flickable: false
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
