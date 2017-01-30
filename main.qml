import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0


ApplicationWindow {
    id: window
    width: 660
    height: 1020
    visible: true
    title: "My Application"

    header: ToolBar {

        RowLayout {
            spacing: 20
            anchors.fill: parent

            ToolButton {
                contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "qrc:/images/drawer.png"
                }
                onClicked: drawer.open()
            }

            Label {
                id: titleLabel
                text: "My Application"
                font.pixelSize: 20
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            ToolButton {
                contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "qrc:/images/menu.png"
                }
                onClicked: optionsMenu.open()

                Menu {
                    id: optionsMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight

                    MenuItem {
                        text: "About"
                        onTriggered: aboutDialog.open()
                    }
                }
            }
        }
    }

    Drawer {
        id: drawer
        width: Math.min(window.width, window.height) / 3 * 2
        height: window.height

        ListView {
            id: listView
            currentIndex: -1
            anchors.fill: parent

            delegate: ItemDelegate {
                width: parent.width
                text: model.title
                highlighted: ListView.isCurrentItem
                onClicked: {
                    if (listView.currentIndex != index) {
                        listView.currentIndex = index
                        titleLabel.text = model.title
                        stackView.replace(model.source)
                    }
                    drawer.close()
                }
            }

            model: ListModel {
                ListElement { title: "Load file"; source: "qrc:/pages/LoadFile.qml" }
                ListElement { title: "EEG visualization"; source: "qrc:/pages/EegVisualization.qml" }
                ListElement { title: "Brains"; source: "qrc:/pages/Brains.qml" }
                ListElement { title: "Statistics"; source: "qrc:/pages/Statistics.qml" }
            }
            ScrollIndicator.vertical: ScrollIndicator { }
        }
    }

    StackView {     //inicializace stacku, uvodni stranka
        id: stackView
        anchors.fill: parent

        initialItem: Pane {
            id: pane

        }
    }

    Popup {
        id: aboutDialog
        modal: true
        focus: true
        x: (window.width - width) / 2
        y: window.height / 6
        width: Math.min(window.width, window.height) / 3
        height: aboutColumn.implicitHeight + topPadding + bottomPadding

        Column {

            id: aboutColumn
            spacing: 20

            Label {
                text: "About"
                font.bold: true
            }

            Label {
                width: aboutDialog.availableWidth
                text: "Author: Lenka Svobodová "
                wrapMode: Label.Wrap
                font.pixelSize: 12
            }

            Label {
                width: aboutDialog.availableWidth
                text: "Year: 2017"
                wrapMode: Label.Wrap
                font.pixelSize: 12
            }

            Button {
                id: okButton
                text: "Ok"
                onClicked: aboutDialog.close()
            }
        }
    }
}