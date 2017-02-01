import QtQuick 2.0

Rectangle {
    id: root
    color: "black"

    Grid {
        id: destination

        anchors {left: parent.left; top: parent.top; margins: 5}
        width: parent.width
        height: parent.height
        opacity: 0.5
        columns: 9
        spacing: 5

        Repeater {
            model: 81;
            delegate: DropItem {}
        }
    }

    Column {
        id: source
        anchors {right: parent.right; top: parent.top; bottom: parent.bottom; margins: 5}
        width: 64
        spacing: 5

        // tady budou elektrody
        Repeater {
            model: 12
            delegate: DragItem {}
        }

    }
}

