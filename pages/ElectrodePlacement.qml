import QtQuick 2.0

Item {

//    Grid {
//        id: destination

//        anchors {left: parent.left; top: parent.top; margins: 5}
//        width: parent.width
//        height: parent.height
//        opacity: 0.5
//        columns: 9
//        spacing: 5

//        Repeater {
//            model: 81;
//            delegate: DropItem {}
//        }
//    }


    DropArea {
        width: parent.width
        height: parent.height

        Image {
            id: brain
            source: "qrc:/images/brains/brain1.png"
            fillMode: Image.PreserveAspectFit
            width: parent.width
            height: parent.height
        }

        Rectangle {
            id: electrode
            width: 10*20; height: 20; radius: 10
            border.color: "black"
            Row {
                Repeater {
                    model: 10
                    Rectangle {
                        width: 20; height: 20; radius: 10
                        border.color: "black"
                        Text {
                            text: modelData + 1
                            anchors.fill: parent
                            horizontalAlignment:Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
                Rectangle {
                    width: 30; height: 6; radius: 3
                    y: 7
                    border.color: "black" }
            }
            Drag.active: dragArea.drag.active
            Drag.hotSpot.x: 10
            Drag.hotSpot.y: 10

            MouseArea {
                id: dragArea
                anchors.fill: parent
                drag.target: parent
            }
        }
    }

//    Column {
//        id: source
//        anchors {right: parent.right; top: parent.top; bottom: parent.bottom; margins: 5}
//        width: 64
//        spacing: 5

//        // tady budou elektrody
//        Repeater {
//            model: 12
//            delegate: DragItem {}
//        }
//    }
}




