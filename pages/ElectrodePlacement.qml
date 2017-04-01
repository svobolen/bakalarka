import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import QtQuick.XmlListModel 2.0

SplitView {
    id: electrodePlacement
    property var name
    property int zHighest: 1
    property int currListIndex: -1
    property bool zoomEnabled: false
    property var images: []
    property ListModel electrodes: ListModel {
        //        ListElement {columns: 5; rows: 2}
        //        ListElement {columns: 5; rows: 3}
        //        ListElement {columns: 5; rows: 4}
    }
    orientation: Qt.Horizontal

    DropArea {
        id: imageArea
        width: 3/4*parent.width
        height: parent.height
        Layout.minimumWidth: 100
        Rectangle {
            anchors.fill: parent
            color: "white"

            XmlParser {id: xml}

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
    }

    ListView {
        id: elecList
        spacing: 10
        Layout.minimumWidth: 100
        boundsBehavior: Flickable.OvershootBounds
        model: electrodes

        delegate: Row {
            id: elRow
            property alias elec: electrode
            padding: 5
            spacing: 5

            Label {
                text: rows + "x" + columns
                anchors.verticalCenter: parent.verticalCenter
            }

            Button {
                id: plusButton
                text: "+"
                background: Rectangle {
                    implicitWidth: 20
                    implicitHeight: 20
                    color: plusButton.down ? "#d6d6d6" : "#f6f6f6"
                    border.color: "black"
                    border.width: 1
                    radius: 20
                }

                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    //                    var newObject = Qt.createQmlObject('import QtQuick 2.7; Electrode {id: ahoj; columnCount: columns; rowCount: rows; linksList: links}', elecList);
                    //electrodes.append(electrodes.get(index))
                    electrodes.insert(index + 1, { columns: columns, rows: rows, links: links})
                }
            }

            Electrode {
                id: electrode
                columnCount: columns
                rowCount: rows
                indexNumber: index
                linksList: links
//                draggable: true
            }

        }

        ScrollIndicator.vertical: ScrollIndicator { }

        header: Rectangle {
            id: rect
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
                    onCheckedChanged: { zoomEnabled = checked }
                }
                Switch {
                    id: fixButton
                    text: qsTr("Fix positions")
                    checked: false
                    onCheckedChanged: { setDraggable(!checked) }

                    function setDraggable(boolDrag) {
                        for (var i = 0; i < elecList.count; i++) {
                            elecList.currentIndex = i
                            elecList.currentItem.elec.draggable = boolDrag
                            elecList.currentItem.elec.mouseArea.drag.target = null
                        }
                    }

                    //                    Popup {
                    //                        id: confirmDialog
                    //                        focus: true
                    //                        modal: true
                    //                        closePolicy: Popup.NoAutoClose
                    //                        x: (window.width - width)/2 - imageArea.width
                    //                        y: window.height/6
                    //                        Column {
                    //                            spacing: 10
                    //                            Label { text: qsTr("<b>Confirm</b>") }
                    //                            Label { text: qsTr("Are you sure?") }
                    //                            Row {
                    //                                spacing: 10
                    //                                Button {
                    //                                    id: okButton
                    //                                    text: qsTr("OK")
                    //                                    onClicked: {
                    //                                        fixButton.setFlickable(false)
                    //                                        confirmDialog.close()
                    //                                    }
                    //                                }
                    //                                Button {
                    //                                    text: qsTr("Cancel")
                    //                                    onClicked: confirmDialog.close()
                    //                                }
                    //                            }
                    //                        }

                    //                    }
                    //                    Popup {
                    //                        id: info
                    //                        x: (window.width - width)/2 - imageArea.width
                    //                        y: (window.height - height) / 6
                    //                        modal: true
                    //                        focus: true
                    //                        Column {
                    //                            spacing: 10
                    //                            Label { text: qsTr("<b>Information</b>") }
                    //                            Label { text: qsTr("Positions of electrodes are fixed.") }
                    //                            Button {
                    //                                text: qsTr("OK")
                    //                                onClicked: {
                    //                                    info.close()
                    //                                }
                    //                            }
                    //                        }
                    //                    }
                }
                ComboBox {
                    model: ["indexes", "wave names", "indexes + waves"]
                    currentIndex: 2
                    displayText: "Display: " + currentText

                    onCurrentIndexChanged: {
                        for (var i = 0; i < elecList.count; i++) {
                            elecList.currentIndex = i
                            elecList.currentItem.elec.basicE.changeNames(currentIndex)
                        }
                        elecList.currentIndex = 0
                    }
                }
                Button {
                    id: resetButton
                    text: qsTr("Reset positions")
                    onClicked: {

                    }
                }
                Button {
                    id: exportButton
                    text: qsTr("Export image")
                    onClicked: {
                        fileDialog.open()
                    }
                }
                FileDialog {
                    id: fileDialog
                    folder: shortcuts.documents
                    selectExisting: false
                    nameFilters: [ "JPEG Image (*.jpg)", "PNG Image (*.png)", "Bitmap Image (*.bmp)", "All files (*)" ]
                    onAccepted: {
                        var filePath = ( fileUrl + "").replace('file:///', '');
                        electrodePlacement.grabToImage(function(result) {
                            if (!result.saveToFile(filePath)){
                                console.error('Unknown error saving to ',filePath);
                            }
                        });
                        console.log("Screenshot has been saved to " + filePath)
                    }
                    onRejected: {
                        console.log("Saving file canceled.")
                    }
                }
            }
        }
        headerPositioning: ListView.OverlayHeader
    }

    onCurrListIndexChanged: {
        elecList.currentIndex = currListIndex
        elecList.currentItem.z = ++zHighest
    }






}









