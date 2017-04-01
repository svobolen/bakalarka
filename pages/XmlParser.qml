import QtQuick 2.0
import QtQuick.XmlListModel 2.0

Item {
    property alias trackModel: xmlModel

    XmlListModel {
        id: xmlModel
        source: "qrc:/xmls/sample.gdf.mont"
        query: "/document/montageTable/montage/trackTable/track"

        XmlRole { name: "label"; query: "@label/string()" }
        XmlRole { name: "code"; query: "code/string()" }
    }

//    ListView {
//        width: 180; height: 300
//        model: xmlModel
//        delegate: Text { text: label.replace(/\s+/g, '') + ": " + code}
//    }
}
