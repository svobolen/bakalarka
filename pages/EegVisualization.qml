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
        }
        Component.onCompleted: swipe.addItem(newPage.createObject(swipe))
    }

    Component {
        id: newPage
        Pane {
            id: secondPage
            width: swipe.width
            height: swipe.height

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
            InfoPopup {
                id: info
                msg: "You chose " + getCheckedImages().length + " image(s)."
            }
            Button {
                id: confirmButton
                text: qsTr("OK")
                anchors {margins: 10; bottomMargin: 50 }
                anchors {bottom: parent.bottom; horizontalCenter: parent.horizontalCenter}
                onClicked: {
                    console.log("clicked")
                    getCheckedImages()
                    info.open()
                    console.log("User chose " + getCheckedImages().length + " image(s): " + getCheckedImages().toString())
                    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         //           listView.currentIndex = 2   //index v listview
         //           titleLabel.text = "Electrode placement"
         //           stackView.replace( "qrc:/pages/ElectrodePlacement.qml", {"images": getCheckedImages()} )
                    ElectrodePlacement.images = getCheckedImages()
                    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                }
            }
            Button {
                id: addButton
                text: "+"
                font.pixelSize: 21
                width: height
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    console.log("add button clicked")
                    swipe.addItem(newPage.createObject(swipe))
                    swipe.currentIndex++
                    console.log("Page " + swipe.currentIndex + " was added to swipe. (Counting from zero.)")

                }
            }
            Button {
                id: deleteButton
                text: "-"
                font.pixelSize: 21
                width: height
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    if(swipe.count !== 2) {
                        console.log("Page " + swipe.currentIndex + " was removed from swipe. (Counting from zero.)")
                        swipe.removeItem(swipe.currentIndex)
                    } else {
                        console.log("There have to be at least 2 pages in swipe.")
                    }

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

    //    Component {
    //        id: funcCaller
    //        Rectangle { Component.onCompleted: countChecked() }
    //    }

    function getCheckedImages() {
        // upravit abych to fungovalo na vsechny stranky !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        var sourceArray = []
        console.log(" ")
        //        for (var k = 0; k < swipe.count; k++) {
        for (var i = 0; i < rep.count; i++) {
            //            console.log(rep.itemAt(i).imgChecked)
            if (rep.itemAt(i).imgChecked) {
                sourceArray.push(rep.itemAt(i).sourceImg)
            }
        }
        //        }
        return sourceArray
    }
}
