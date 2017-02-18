import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4

Page {
    id: item

    footer: TabBar {
        id: bar
        width: parent.width
        TabButton { text: qsTr("Strips") }
        TabButton { text: qsTr("Grids") }
    }

    StackLayout {
        id: stack
        width: parent.width
        height: parent.height
        currentIndex: bar.currentIndex
        Flickable {
            contentHeight: stripTab.height
            contentWidth: stripTab.width
            Item {
                id: stripTab
                width: stripColumn.width * 1.1
                height: stripColumn.height * 1.1
                Column {
                    id: stripColumn
                    spacing: 10
                    padding: 10

                    Repeater {
                        id: stripRep
                        model: 8
                        Row {
                            spacing: 10
                            property alias count: stripSpin.value
                            property alias stripColumns: strip.columnCount
                            SpinBox {
                                id: stripSpin
                                value: 0
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Label {
                                text: strip.rowCount + "x" + strip.columnCount
                                font.pixelSize: 12
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Electrode {
                                id: strip
                                columnCount: index + 4
                                rowCount: 1
                                flickable: false
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }
            }
            ScrollIndicator.vertical: ScrollIndicator { }
            ScrollIndicator.horizontal: ScrollIndicator { }
        }

        Flickable {
            contentHeight: gridTab.height
            contentWidth: gridTab.width

            Item {
                id: gridTab
                width: gridColumn.width * 1.1
                height: gridColumn.height * 1.1

                Column {
                    id: gridColumn
                    spacing: 10
                    padding: 10

                    Repeater {
                        id: gridRep
                        model: 2
                        Row {
                            spacing: 10
                            property alias count: gridSpin.value
                            property alias gridRows: grid.rowCount
                            property alias gridColumns: grid.columnCount
                            SpinBox {
                                id: gridSpin
                                value: 0
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Label {
                                text: grid.rowCount + "x" + grid.columnCount
                                font.pixelSize: 12
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Electrode {
                                id: grid
                                columnCount: index + 4
                                rowCount: 5
                                flickable: false
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }
            }
            ScrollIndicator.vertical: ScrollIndicator { }
            ScrollIndicator.horizontal: ScrollIndicator { }
        }
    }

    Button {
        id: addButton
        text: "Add new type of strip or grid"
        x: (parent.width - width) / 2
        anchors.bottom: parent.bottom
        anchors.right: confirmButton.left
        anchors.margins: 15
        onClicked: addDialog.open()
    }
    Button {
        id: confirmButton
        text: qsTr("Confirm")
        anchors.bottom: parent.bottom
        anchors.left: addButton.right
        anchors.margins: 15
        onClicked: getElectrodes()
    }
    Popup {
        id: addDialog
        modal: true
        focus: true
        x: (parent.width - width) / 2
        y: parent.height/6

        Grid {
            columns: 2
            spacing: 10
            verticalItemAlignment: Grid.AlignVCenter

            Label { text: qsTr("<b>Add new strip/grid</b>") }
            Label { text: " " }
            Label { text: qsTr("Rows") }
            SpinBox {
                id: rowSpinBox
                from: 1
                value: 1
            }
            Label { text: qsTr("Columns") }
            SpinBox {
                id: columnSpinBox
                from: 1
                value: 5
            }
            //            CheckBox {
            //                id: checkBox
            //                text: qsTr("set different indexing")
            //            }
            //            Label { text: " " }
            Button {
                id: okButton
                text: qsTr("Add")
                onClicked: {
                    addDialog.addElectrode(columnSpinBox.value, rowSpinBox.value)
                    addDialog.close()
                }
            }
            Button {
                id: closeButton
                text: qsTr("Cancel")
                onClicked: addDialog.close()
            }

        }
        function addElectrode(columnCount, rowCount) {
            //                    if (checkBox.checked) { indexingDialog.open() }
            var newElectrode
            var component = Qt.createComponent("qrc:/pages/Electrode.qml");

            //for strips rows = 1
            if (columnCount === 1 && rowCount !== 1) {
                columnCount = rowCount
                rowCount = 1
            }
            if (rowCount === 1) {
                newElectrode = component.createObject(stripColumn, {"columnCount": columnCount, "rowCount": rowCount, "flickable": false});
                bar.currentIndex = 0
            } else {
                newElectrode = component.createObject(gridColumn, {"columnCount": columnCount, "rowCount": rowCount, "flickable": false});
                bar.currentIndex = 1
            }
            console.log("New electrode " + rowCount + "x" + columnCount + " was added.")
        }
    }

    function getElectrodes() {
        var sourceArray = []
        console.log(" ")
        for (var i = 0; i < stripRep.count; i++) {
            if (stripRep.itemAt(i).count !== 0) {
                console.log(stripRep.itemAt(i).count)
                console.log(stripRep.itemAt(i).stripColumns + "x1")
            }
        }
        for (var j = 0; j < gridRep.count; j++) {
            if (gridRep.itemAt(j).count !== 0) {
                console.log(gridRep.itemAt(j).count)
                console.log( gridRep.itemAt(j).gridRows + "x" + gridRep.itemAt(j).gridColumns)
            }
        }
        return sourceArray
    }
}
