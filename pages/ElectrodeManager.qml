import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4

Page {
    id: item
    property var name

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

                    ListModel {
                        id: stripModel
                        ListElement { columns: 4 }
                        ListElement { columns: 5 }
                        ListElement { columns: 6 }
                        ListElement { columns: 7 }
                        ListElement { columns: 8 }
                        ListElement { columns: 9 }
                        ListElement { columns: 10 }
                    }

                    Repeater {
                        id: stripRep
                        model: stripModel
                        delegate: Row {
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
                            BasicElectrode {
                                id: strip
                                columnCount: columns
                                rowCount: 1
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

                    ListModel {
                        id: gridModel
                        ListElement { columns: 4; rows: 4 }
                        ListElement { columns: 5; rows: 5 }
                        ListElement { columns: 6; rows: 5 }
                        ListElement { columns: 7; rows: 3 }
                        ListElement { columns: 8; rows: 5 }
                        ListElement { columns: 9; rows: 2 }
                        ListElement { columns: 10; rows: 3 }
                    }

                    Repeater {
                        id: gridRep
                        model: gridModel
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
                            BasicElectrode {
                                id: grid
                                columnCount: columns
                                rowCount: rows
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
        onClicked: {
            var chosenElecs = getChosenElectrodes()
            if (chosenElecs.count === 0) {
                console.log("User did not choose any electrode.")
            } else {
                //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                listView.currentIndex = 3   //index v listview
                titleLabel.text = "Link Signal with Electrode"
                stackView.push( "qrc:/pages/ElectrodeSignalLink.qml", {"electrodes": chosenElecs, "name": "Link Signal with Electrode"} )
                //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            }
        }
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

            //for strips rows = 1
            if (columnCount === 1 && rowCount !== 1) {
                columnCount = rowCount
                rowCount = 1
            }
            if (rowCount === 1) {
                //create strip
                stripModel.append({ columns: columnCount })
                bar.currentIndex = 0
            } else {
                //create grid
                gridModel.append({ columns: columnCount, rows: rowCount })
                bar.currentIndex = 1
            }
            console.log("New electrode " + rowCount + "x" + columnCount + " was added.")
        }
    }

    ListModel {
        id: chosenElectrodesList
        ListElement { count: 0; columns: 0; rows: 0}
    }

    function getChosenElectrodes() {
        console.log("User chose following electrodes: ")
        for (var i = 0; i < stripRep.count; i++) {
            if (stripRep.itemAt(i).count !== 0) {
                chosenElectrodesList.append({ count: stripRep.itemAt(i).count, columns: stripRep.itemAt(i).stripColumns, rows: 1 })
                console.log(stripRep.itemAt(i).count + "x strip 1x" + stripRep.itemAt(i).stripColumns)
            }
        }
        for (var j = 0; j < gridRep.count; j++) {
            if (gridRep.itemAt(j).count !== 0) {
                chosenElectrodesList.append({ count: gridRep.itemAt(j).count, columns: gridRep.itemAt(j).gridColumns, rows: gridRep.itemAt(j).gridRows })
                console.log(gridRep.itemAt(j).count + "x grid " + gridRep.itemAt(j).gridRows + "x" + gridRep.itemAt(j).gridColumns)
            }
        }
        return chosenElectrodesList
    }
}
