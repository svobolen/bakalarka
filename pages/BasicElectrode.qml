import QtQuick 2.6
import QtQuick.Controls 2.0

Item {
    id: root
    property int columnCount
    property int rowCount
    property int size: 20
    property bool droppingEnabled: false
    property ListModel links: ListModel {
        //        ListElement {electrodeNumber: 1; wave: "C3"}
        //        ListElement {electrodeNumber: 3; wave: "C4"}
        //        ListElement {electrodeNumber: 4; wave: "F3"}
    }
    width: columnCount*size; height: rowCount*size;


    Rectangle {
        id: electrode
        width: columnCount*size; height: rowCount*size; radius: size/2
        opacity: 0.8
        border.color: "grey"

        Column {
            id: column
            Repeater {
                model: rowCount
                Row {
                    id: row
                    Repeater {
                        model: columnCount

                        DropArea {
                            id: dragTarget
                            property bool alreadyContainsDrag: false
                            property var signalData
                            property string waveName: ""
                            readonly property int defaultName: columnCount * ( rowCount - row.getIndex() ) + ( modelData + 1 )
                            property alias name: electrodeText.text
                            property int index

                            width: size; height: size
                            enabled: droppingEnabled

                            Rectangle {
                                id: dropRectangle
                                opacity: 0.8
                                width: size; height: size; radius: size/2
                                border.color: "grey"

                                states: [
                                    State {
                                        when: dragTarget.containsDrag && dragTarget.alreadyContainsDrag === false
                                        PropertyChanges {
                                            target: dropRectangle
                                            color: "green"
                                        }
                                    },
                                    State {
                                        when: dragTarget.containsDrag && dragTarget.alreadyContainsDrag === true
                                        PropertyChanges {
                                            target: dropRectangle
                                            color: "red"
                                        }
                                    }
                                ]
                                Text {
                                    id: electrodeText
                                    text: dragTarget.defaultName
                                    anchors.fill: parent
                                    horizontalAlignment:Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            onWaveNameChanged: {
                                if (waveName === "") {
                                    links.remove(index - 1)
                                } else {
                                    links.append( { electrodeNumber: defaultName, wave: name})
                                    index = links.count
                                }
                            }

                            Component.onCompleted: {
                                if (links !== null) {
                                    for (var i = 0; i < links.count; i++) {
                                        if (links.get(i).electrodeNumber === defaultName) {
                                            name = links.get(i).wave
                                            waveName = links.get(i).wave
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Rectangle {
                        opacity: 0.8
                        width: size + 5; height: 6; radius: 3
                        y: size / 2 - height / 2
                        border.color: "grey"
                    }
                    function getIndex() {
                        return index + 1
                    }
                }
            }
        }
    }
}

