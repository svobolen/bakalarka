import QtQuick 2.0

Item {
    id: root
    property int size: 20
    property string waveName: "X"
    property var signalData
    width: size; height: size

    MouseArea {
        id: mouseArea
        width: size; height: size
        anchors.centerIn: parent
        drag.target: tile

        onReleased: {
            parent = (tile.Drag.target === null || tile.Drag.target.alreadyContainsDrag) ?  root : tile.Drag.target
            if (tile.Drag.target !== null) {
                tile.Drag.target.alreadyContainsDrag = true
                tile.Drag.target.name = waveName
                tile.Drag.target.waveName = waveName
            }
        }
        onPressed: {
            if (parent !== root) {
                parent.alreadyContainsDrag = false
                parent.name = parent.defaultName
                parent.waveName = ""
            }
        }

        Rectangle {
            id: tile
            width: size; height: size; radius: size/2
            border.color: "black"
            //aby se to chytalo na stred
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            Drag.active: mouseArea.drag.active
            Drag.hotSpot.x: width/2
            Drag.hotSpot.y: height/2

            Text {
                text: waveName
                anchors.fill: parent
                horizontalAlignment:Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            states: State {
                when: mouseArea.drag.active
                ParentChange {
                    target: tile
                    parent: root
                }
                //aby se to pohybovalo s mysi
                AnchorChanges {
                    target: tile
                    anchors.verticalCenter: undefined
                    anchors.horizontalCenter: undefined
                }
            }
        }
    }
}
