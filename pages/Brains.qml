import QtQuick.Controls 2.0
import QtQuick 2.7
import QtQuick.Layouts 1.3

Pane {
    id: pane


    //    Label {
    //        id: label
    //        text: "K jednotlivým kanálům přiřaďte příslušné elektrody."
    //        font {pixelSize: 13; italic: true}
    //        width: parent.width
    //        wrapMode: Label.Wrap
    //        horizontalAlignment: Label.AlignHCenter
    //        anchors {bottom: column.top; margins: 10; fill: parent}
    //    }


    Column {
        id: column
        anchors.fill: parent

        Row {
            id: electrode1

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
                y: electrode1.height/2 - this.height/2
                border.color: "black" }
        }
    }
}
