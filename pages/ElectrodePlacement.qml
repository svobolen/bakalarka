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
    }

    Column {
        id: source
        anchors {left: parent.left; top: parent.top; bottom: parent.bottom; margins: 5}
        spacing: 5

        // tady budou elektrody
        Repeater {
            model: 5
            delegate: DragItem {}
        }
    }
}




