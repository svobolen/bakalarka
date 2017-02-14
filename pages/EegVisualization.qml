import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2

Pane {
    id: pane

    SwipeView {
        id: swipe
        currentIndex: 0
        anchors {fill: parent; bottom: indicator.top}

        Pane {
            id: firstPage
            width: swipe.width
            height: swipe.height

            Label {
                id: label
                text: qsTr("Choose one or more images. You can upload your own photos or pictures.")
                font {pixelSize: 13; italic: true}
                width: parent.width
                anchors {margins: 5; left: parent.left; right: parent.right}
                horizontalAlignment: Qt.AlignHCenter
                wrapMode: Label.Wrap
            }
            Grid {
                id: grid
                columns: 2
                columnSpacing: 10
                width: parent.width
                height: parent.height
                anchors.top: label.bottom

                Repeater {
                    id: rep
                    model:
                        ["qrc:/images/brains/brain1.png",
                        "qrc:/images/brains/brain3.png",
                        "qrc:/images/brains/brain4.png",
                        "qrc:/images/brains/brain2.jpg"]

                    BrainTemplate {
                        id: brain
                        sourceImg: modelData
                        checkboxVisible: true
                    }
                }
            }
            PinchArea {
                anchors.fill: parent
                pinch.target: firstPage
                pinch.minimumScale: 1
                pinch.maximumScale: 10
                pinch.dragAxis: Pinch.XAndYAxis
                onSmartZoom: { firstPage.scale = pinch.scale }
                onPinchFinished: {
                    firstPage.scale = 1
                    firstPage.x = 0
                    firstPage.y = 0
                }
            }
        }
        Component.onCompleted: swipe.addItem(newPage.createObject(swipe))
    }

    Component {
        id: newPage
        Pane {
            id: secondPage
            width: swipe.width
            height: swipe.height

            Grid {
                id: grid2
                columns: 2
                spacing: 10
                width: parent.width
                height: parent.height

                Repeater {
                    id: rep
                    model: 1
                    BrainTemplate { sourceImg: "qrc:/images/plus.png" }
                }
            }
            Button {
                id: confirmButton
                text: qsTr("OK")
                anchors {margins: 10; bottomMargin: 50; bottom: parent.bottom; horizontalCenter: parent.horizontalCenter}
                onClicked: {
                    countChecked()
                    console.log("User chose " + countChecked() + " image(s).")
                    info.open()
                }
            }
            InfoPopup {
                id: info
                msg: "You chose " + countChecked() + " image(s)."
            }
            PinchArea {
                anchors.fill: parent
                pinch.target: secondPage
                pinch.minimumScale: 1
                pinch.maximumScale: 10
                pinch.dragAxis: Pinch.XAndYAxis
                onSmartZoom: { secondPage.scale = pinch.scale }
                onPinchFinished: {
                    secondPage.scale = 1
                    secondPage.x = swipe.width
                    secondPage.y = 0
                }
            }
            Button {
                id: addButton
                text: "new page"
                rotation: -90
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    swipe.addItem(newPage.createObject(swipe))
                    swipe.currentIndex++
                }
            }
        }
    }

    PageIndicator {
        id: indicator
        count: swipe.count
        currentIndex: swipe.currentIndex
        anchors {bottom: parent.bottom; horizontalCenter: parent.horizontalCenter}
    }

    function countChecked() {
        var checkedCount = 0
        for (var i = 0; i < swipe.count; i++) {
            for (var j = 0; j < rep.count; j++) {
                console.log(rep.itemAt(j).imgChecked)
                if(rep.itemAt(j).imgChecked) {
                    checkedCount++
                }
            }
        }
        return checkedCount
    }
}
