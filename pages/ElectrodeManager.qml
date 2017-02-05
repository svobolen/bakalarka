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
                    spacing: 10
                    padding: 5

                    Repeater {
                        model: 8
                        SpinBox { value: 50 }
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
        //        x: (dropArea.width + page.width - width)/2 - dropArea.width
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
            }
            Button {
                id: closeButton
                text: qsTr("Cancel")
                onClicked: addDialog.close()
            }
        }
    }
}
