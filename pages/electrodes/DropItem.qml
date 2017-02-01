import QtQuick 2.0

//! [0]
DropArea {
    id: dragTarget

    property alias dropProxy: dragTarget

    width: 64; height: 64

    Rectangle {
        id: dropRectangle

        anchors.fill: parent

        states: [
            State {
                when: dragTarget.containsDrag
                PropertyChanges {
                    target: dropRectangle
                    color: "green"
                }
            }
        ]
    }
}
