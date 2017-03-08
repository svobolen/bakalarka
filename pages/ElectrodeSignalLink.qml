import QtQuick.Controls 2.0
import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls 2.0

SplitView {
    property var name
    property var electrodes

    Flickable {
        contentHeight: destItem.height
        contentWidth: destItem.width
        width: 4/5 * parent.width
        Layout.minimumWidth: 1/2 * parent.width + confirmButton.width / 2

        Item {
            id: destItem
            width: destination.width * 1.1
            height: destination.height * 1.1
            Column {
                id: destination
                spacing: 10
                padding: 10
                width: parent.parent.width

                Repeater {
                    model: electrodes
                    Row {
                        spacing: 10
                        Label {
                            text: rows + "x" + columns
                            font.pixelSize: 12
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        BasicElectrode {
                            size: 40
                            columnCount: columns
                            rowCount: rows
                        }
                    }
                }
            }
            Button {
                id: confirmButton
                text: qsTr("Confirm")
                x: (window.width - width)/2 - destItem.width
                anchors.top: destination.bottom
                anchors.margins: 20
                onClicked: {
//                    window.changePage("Electrode Placement", "qrc:/pages/ElectrodePlacement.qml", 4)
                    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    window.electrodes = electrodes
                    listView.currentIndex = 4   //index v listview
                    titleLabel.text = "Electrode Placement"
                    stackView.push( "qrc:/pages/ElectrodePlacement.qml", {"electrodes": electrodes, "images": window.images,"name": "Electrode Placement"} )
                    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                }
            }
        }
        ScrollIndicator.vertical: ScrollIndicator { }
    }
    Flickable {
        contentHeight: source.height
        contentWidth: source.width
        Layout.minimumWidth: 50
        Layout.maximumWidth: 1/2 * parent.width - confirmButton.width / 2

        Item {
            id: sourceItem
            width: source.width * 1.1
            height: source.height * 1.1
            Column {
                id: source
                width: 50
                Layout.minimumWidth: 50
                spacing: 10
                padding: 10
                Repeater {
                    model: 12
                    DragItem {
                        size: 40
                    }
                }
            }
        }
        ScrollIndicator.vertical: ScrollIndicator { }
    }
}
