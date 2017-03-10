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
        ListElement {columns: 5; rows: 3}
        ListElement {columns: 5; rows: 4}
    }
    orientation: Qt.Horizontal

    Item {
        id: imageArea
        width: 3/4*parent.width
        height: parent.height
        Layout.minimumWidth: 100

        Grid {
            id: imagesGrid
            rows: images == null ? 0 : Math.round(images.length/2)
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

    ListView {
        id: elecList
        spacing: 10
        Layout.minimumWidth: 100
        model: electrodes

        delegate: Electrode {
            columnCount: columns
            rowCount: rows
        }
        ScrollIndicator.vertical: ScrollIndicator { }
        ScrollIndicator.horizontal: ScrollIndicator { }

        header: Rectangle {
            height: buttonsColumn.height
            width: parent.width
            z: 2
            color: "white"

            Column {
                id: buttonsColumn
                spacing: 10
                padding: 5

                Switch {
                    id: zoomSwitch
                    text: qsTr("Image zoom")
                    checked: false
                    onCheckedChanged: { zoomEnabled = checked ? true : false }
                }
                Button {
                    id: fixButton
                    text: qsTr("Fix positions")
                    onClicked: {
                        confirmDialog.open()
                    }
                    function setFlickable (flickable) {
                        for (var i = 0; i < elecList.count; i++) {
                            elecList.currentIndex = i
                            elecList.currentItem.flickable = flickable
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
                                        fixButton.setFlickable(false)
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
                    Popup {
                        id: info
                        x: (window.width - width)/2 - imageArea.width
                        y: (window.height - height) / 6
                        modal: true
                        focus: true
                        Column {
                            spacing: 10
                            Label { text: qsTr("<b>Information</b>") }
                            Label { text: qsTr("Positions of electrodes are fixed.") }
                            Button {
                                text: qsTr("OK")
                                onClicked: {
                                    info.close()
                                }
                            }
                        }
                    }
                }
                Button {
                    id: exportButton
                    text: qsTr("Export image")
                }
            }
        }
        headerPositioning: ListView.OverlayHeader


    }
}







