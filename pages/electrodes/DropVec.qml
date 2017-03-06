import QtQuick 2.6
import QtQuick.Controls 2.0


DropArea {
    id: dragTarget

    property alias dropProxy: dragTarget

    width: 64; height: 64

    Rectangle {
        id: dropRectangle
        color: "black"
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

