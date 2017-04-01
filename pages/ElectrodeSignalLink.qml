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
        boundsBehavior: Flickable.OvershootBounds

        Item {
            id: destItem
            width: destination.width * 1.1
            height: destination.height * 1.1

            Column {
                id: destination
                spacing: 10
                padding: 10

                Repeater {
                    id: elecRep
                    model: electrodes
                    Row {
                        property alias bElectrode: bElectrode
                        spacing: 10
                        Label {
                            text: rows + "x" + columns
                            font.pixelSize: 12
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        BasicElectrode {
                            id: bElectrode
                            size: 40
                            columnCount: columns
                            rowCount: rows
                            droppingEnabled: true
                        }
                    }
                }
            }
            Button {
                id: confirmButton
                text: qsTr("Confirm")
                x: (window.width - width)/2
                anchors.top: destination.bottom
                anchors.margins: 20
                onClicked: {
                    fillLinkedElectrodesList()
                    listView.currentIndex = 4   //index v listview
                    titleLabel.text = "Electrode Placement"
                    stackView.push( "qrc:/pages/ElectrodePlacement.qml", {"electrodes": linkedElectrodesList, "images": window.images,"name": "Electrode Placement"} )
                }
            }
        }
        ScrollIndicator.vertical: ScrollIndicator { }
        ScrollIndicator.horizontal: ScrollIndicator { }
    }
    Flickable {
        contentHeight: sourceItem.height
        contentWidth: sourceItem.width
        Layout.minimumWidth: 50
        Layout.maximumWidth: 1/2 * parent.width - confirmButton.width / 2
        boundsBehavior: Flickable.OvershootBounds

        Rectangle {
            color: "white"
            width: parent.parent.width
            height: sourceItem.height

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
                        model: xmlParser.trackModel
                        DragItem {
                            size: 40
                            waveName: label.replace(/\s+/g, '')
                        }
                    }
                }
            }
            XmlParser {id: xmlParser }
        }
        ScrollIndicator.vertical: ScrollIndicator { }
    }

    ListModel {
        id: linkedElectrodesList
        //        ListElement { electrode: bElectrode}
    }

    function fillLinkedElectrodesList() {
        linkedElectrodesList.clear()

        for (var i = 0; i < elecRep.count; i++) {
            linkedElectrodesList.append({ rows: elecRep.itemAt(i).bElectrode.rowCount, columns: elecRep.itemAt(i).bElectrode.columnCount, links: elecRep.itemAt(i).bElectrode.links})
        }
        return linkedElectrodesList
    }



}
