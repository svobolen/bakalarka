import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

Page {
    id: item

    footer: TabBar {
        id: bar
        width: parent.width
        TabButton { text: qsTr("Electrodes") }
        TabButton { text: qsTr("Grids") }
    }

    StackLayout {
        id: stack
        width: parent.width
        height: parent.height
        currentIndex: bar.currentIndex
        Item {
            id: electrodeTab
            height: parent.height
            Column {
                id: electrodeColumn
                spacing: 10
                padding: 5

                Repeater {
                    model: 8
                    delegate: DragItem {columnCount: index + 4; rowCount:1}
                }
            }

        }
        Item {
            id: gridTab
            Flickable {
                Column {
                    id: gridColumn
                    spacing: 10
                    padding: 5

                    Repeater {
                        model: 8
                        delegate: DragItem {columnCount: index + 4; rowCount:10}
                    }
                }
            }
        }
    }




    Button {
        id: addButton
        text: "Add new type of electrode or grid"
        x: (parent.width - width) / 2
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        onClicked: addDialog.open()
    }

    Popup {
        id: addDialog
        modal: true
        focus: true
        x: (parent.width - width) / 2
        y: parent.height/6

        Grid {
            id: grid
            columns: 2
            spacing: 10
            verticalItemAlignment: Grid.AlignVCenter

            Label { text: qsTr("<b>Add new electrode/grid</b>") }
            Label { text: " " }
            Label { text: qsTr("Rows (for electrode rows = 1)") }
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
                    var elec
                    var component = Qt.createComponent("qrc:/pages/DragItem.qml");
                    var columnCount = columnSpinBox.value
                    var rowCount = rowSpinBox.value
                    if (columnCount === 1 && rowCount !== 1) {
                        warningDialog.open()
                    } else {if (rowCount === 1) {
                            elec = component.createObject(electrodeColumn, {"columnCount": columnCount, "rowCount": rowCount});
                            bar.currentIndex = 0
                        } else {
                            elec = component.createObject(gridColumn, {"columnCount": columnCount.value, "rowCount": rowCount});
                            bar.currentIndex = 1
                        }
                        console.log("New electrode/grid " + rowCount + "x" + columnCount + " was added.")
                        addDialog.close()
                    }
                }
            }
            Button {
                id: closeButton
                text: qsTr("Cancel")
                onClicked: addDialog.close()
            }
        }
    }
    Popup {
        id: warningDialog
        modal: true
        focus: true
        x: (parent.width - width) / 2
        y: parent.height/6
        Column {
            spacing: 10
            Label { text: qsTr("<b>Warning</b>") }
            Label {
                horizontalAlignment: Qt.AlignHCenter
                text: qsTr("Invalid input. Please switch numbers of rows and columns.")
            }
            Label { text: qsTr("For electrode: rows = 1.") }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "OK"
                onClicked: warningDialog.close()
            }
        }
    }
}
