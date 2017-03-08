import QtQuick 2.6
import QtQuick.Controls 2.0

Item {
    id: root
    property int columnCount
    property int rowCount
    property int size: 20
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
                            property alias dropProxy: dragTarget
                            width: size; height: size

                            Rectangle {
                                id: dropRectangle
                                opacity: 0.8
                                width: size; height: size; radius: size/2
                                border.color: "grey"
                                property var signal
                                states: [
                                    State {
                                        when: dragTarget.containsDrag
                                        PropertyChanges {
                                            target: dropRectangle
                                            color: "green"
//                                            signal:
                                        }
                                    }
                                ]
                                Text {
                                    text: columnCount*(rowCount-row.getIndex()) + (modelData+1)
                                    anchors.fill: parent
                                    horizontalAlignment:Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
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

