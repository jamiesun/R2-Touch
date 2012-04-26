import QtQuick 1.0

Rectangle {
    id: rectangle1
    width: 360
    height: 120
    gradient: Gradient {
        GradientStop {
            position: 0
            color: "#e6e6e6"
        }

        GradientStop {
            position: 0.97
            color: "#cccccc"
        }
    }
    property alias ititle: title_.text
    property alias icontent: ctx.text
    property string iurl


    Text {
        id: title_
        color: "#0842e2"
        text: "text"
        anchors.right: parent.right
        anchors.rightMargin: 60
        anchors.left: parent.left
        anchors.leftMargin: 15
        anchors.top: parent.top
        anchors.topMargin: 15
        font.bold: true
        font.pointSize: main.std_font
    }

    Text {
        id: ctx
        text: "text"
        anchors.right: parent.right
        anchors.rightMargin: 60
        anchors.left: parent.left
        anchors.leftMargin: 15
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        anchors.top: title_.bottom
        anchors.topMargin: 5
        font.pointSize: main.tiny_font
        wrapMode: Text.WrapAnywhere
        elide: Text.ElideRight
        MouseArea{
            anchors.fill: parent
            onClicked: {
                if(ctx.elide==Text.ElideRight){
                    ctx.elide=Text.ElideNone
                    rectangle1.height = 360
                }else{
                    ctx.elide=Text.ElideRight
                    rectangle1.height = 120
                }

            }
        }
    }

    Image {
        id: image1
        anchors.right: parent.right
        anchors.rightMargin: 15
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/qml/R2-Touch/res/32b/download.png"
        MouseArea{
            anchors.fill: parent
            scale: 1.3
            onClicked: Qt.openUrlExternally(iurl)
        }
    }
}
