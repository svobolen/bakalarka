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
                    padding: 5

                    Repeater {
                        model: 8
                        delegate: Electrode {columnCount: index + 4; rowCount:1}
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
                    padding: 5

                    Repeater {
                        model: 2
                        delegate: Electrode {columnCount: index + 4; rowCount:10}
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

            CheckBox {
                id: checkBox
                text: qsTr("set different indexing")
            }
            Label { text: " " }

            Button {
                id: okButton
                text: qsTr("Add")
                onClicked: {
                    if (checkBox.checked) { indexingDialog.open() }
                    var elec
                    var component = Qt.createComponent("qrc:/pages/Electrode.qml");
                    var columnCount = columnSpinBox.value
                    var rowCount = rowSpinBox.value

                    //for strips rows = 1
                    if (columnCount === 1 && rowCount !== 1) {
                        columnCount = rowCount
                        rowCount = 1
                    }
                    if (rowCount === 1) {
                        elec = component.createObject(stripColumn, {"columnCount": columnCount, "rowCount": rowCount});
                        bar.currentIndex = 0
                    } else {
                        elec = component.createObject(gridColumn, {"columnCount": columnCount, "rowCount": rowCount});
                        bar.currentIndex = 1
                    }
                    console.log("New electrode " + rowCount + "x" + columnCount + " was added.")
                    addDialog.close()

                }
            }
            Button {
                id: closeButton
                text: qsTr("Cancel")
                onClicked: addDialog.close()
            }
        }
    }

    //    Popup {
    //        id: indexingDialog
    //        property var indexing: []
    //        modal: true
    //        focus: true
    //        x: (parent.width - width) / 2
    //        y: parent.height/6
    //        Column {
    //            spacing: 10
    //            Label { text: qsTr("<b>Indexing</b>") }
    //            Grid {
    //                id: gridPopup
    //                columns: columnSpinBox.value
    //                rows: rowSpinBox.value
    //                Repeater {
    //                    id: rep
    //                    model: gridPopup.columns * gridPopup.rows
    //                    TextField {
    //                        id: textfield
    //                        placeholderText: qsTr("0")
    //                        background: Rectangle {
    //                            width: 20; height: 20; radius: 10
    //                            border.color: "black"
    //                        }
    //                    }
    //                }
    //            }

    //            Button {
    //                anchors.horizontalCenter: parent.horizontalCenter
    //                text: "OK"
    //                onClicked: {

    //                    indexingDialog.close()
    //                }
    //            }
    //        }
    //    }
}
