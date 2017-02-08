import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls 2.0

SplitView {
    property bool zoomEnabled: false

    orientation: Qt.Horizontal

    DropArea {
        id: dropArea
        width: 3/4*parent.width
        height: parent.height
        Layout.minimumWidth: 100

        Image {
            id: brain
            source: "qrc:/images/brains/brain1.png"
            fillMode: Image.PreserveAspectFit
            width: parent.width - 10
            height: parent.height
        }
        PinchArea {
            enabled: zoomEnabled
            anchors.fill: parent
            pinch.target: dropArea
            pinch.minimumScale: 1
            pinch.maximumScale: 10
            pinch.dragAxis: Pinch.XAndYAxis
            onSmartZoom: dropArea.scale = pinch.scale
            onPinchFinished: {
                dropArea.scale = 1
                dropArea.x = 0
                dropArea.y = 0
            }
        }
    }

    Item {
        id: electrodeTab
        height: parent.height
        Column {
            spacing: 10
            padding: 5

            Button {
                text: qsTr("Export image")
            }
            Switch {
                text: qsTr("Image zoom")
                checked: false
                onCheckedChanged: { zoomEnabled = checked ? true : false }
            }
            Repeater {
                model: 8
                Electrode {columnCount: index + 4; rowCount:1; draggable: true}
            }
        }
    }
}






