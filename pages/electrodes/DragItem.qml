import QtQuick 2.0

Item {
    id: root

    width: 64; height: 64

    MouseArea {
        id: mouseArea

        width: parent.width; height: parent.height
        anchors.centerIn: parent

        drag.target: tile

        onReleased: parent = (tile.Drag.target !== null) ? tile.Drag.target : root

        Rectangle {
            id: tile

            width: 64; height: 64
            //aby se to chytalo na stred
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            Drag.active: mouseArea.drag.active
            Drag.hotSpot.x: 32
            Drag.hotSpot.y: 32

            states: State {
                when: mouseArea.drag.active
                ParentChange { target: tile; parent: root }
                AnchorChanges { target: tile; anchors.verticalCenter: undefined; anchors.horizontalCenter: undefined }
            }

        }
    }
}
