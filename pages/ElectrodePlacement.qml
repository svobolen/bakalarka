import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls 2.0

SplitView {
    property var name
    property bool zoomEnabled: false
    property var images: []
    property ListModel electrodes: ListModel {
        ListElement {columns: 5; rows: 2}
    }
//    property list<Electrode> electrodes
    orientation: Qt.Horizontal

    Item {
        id: imageArea
        width: 3/4*parent.width
        height: parent.height
        Layout.minimumWidth: 100

        Grid {
            id: imagesGrid
            rows: Math.round(images.length/2)
            spacing: 10
            padding: 5
            Repeater {
                model: images
                Image {
                    source: modelData
                    fillMode: Image.PreserveAspectFit
                    width: (imagesGrid.rows == 1 && images.length !== 1) ? (imageArea.width-20)/(imagesGrid.rows+1) : imageArea.width/imagesGrid.rows
                    height: (imageArea.height-20)/imagesGrid.rows
                }
            }
        }
        PinchArea {
            enabled: zoomEnabled
            anchors.fill: parent
            pinch.target: imageArea
            pinch.minimumScale: 1
            pinch.maximumScale: 10
            pinch.dragAxis: Pinch.XAndYAxis
            onSmartZoom: imageArea.scale = pinch.scale
            onPinchFinished: {
                imageArea.scale = 1
                imageArea.x = 0
                imageArea.y = 0
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
                id: exportButton
                text: qsTr("Export image")
            }
            Button {
                id: fixButton
                text: qsTr("Fix positions")
                onClicked: { confirmDialog.open() }
                function setFlickable () {
                    for (var i = 0; i < elecRep.count; i++) {
                        elecRep.itemAt(i).flickable = false
                    }
                    info.open()
                }
                function disableButton () {
                    fixButton.enabled = false
                }

                Popup {
                    id: confirmDialog
                    focus: true
                    modal: true
                    closePolicy: Popup.NoAutoClose
                    x: (window.width - width)/2 - imageArea.width
                    y: window.height/6
                    Column {
                        spacing: 10
                        Label { text: qsTr("<b>Confirm</b>") }
                        Label { text: qsTr("Are you sure?") }
                        Row {
                            spacing: 10
                            Button {
                                id: okButton
                                text: qsTr("OK")
                                onClicked: {
                                    fixButton.setFlickable()
                                    fixButton.disableButton()
                                    confirmDialog.close()
                                }
                            }
                            Button {
                                text: qsTr("Cancel")
                                onClicked: confirmDialog.close()
                            }
                        }
                    }

                }
                InfoPopup {
                    id: info
                    msg: "Positions of electrodes are fixed."
                    x: (window.width - width)/2 - imageArea.width
                }
            }
            Switch {
                id: zoomSwitch
                text: qsTr("Image zoom")
                checked: false
                onCheckedChanged: { zoomEnabled = checked ? true : false }
            }
            Repeater {
                id: elecRep
                model: electrodes
                Electrode {
                    columnCount: columns
                    rowCount: rows
                    draggable: true
                }
            }
        }
    }
}






