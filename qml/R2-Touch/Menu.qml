import QtQuick 1.0

Item {
    id:imenu
    width: 360
    property int hval: menulist.model.count * 48 + 80
    height: Math.min(hval,parent.height)
    property int buttonWidth: width/2
    property int menuWidth: menulist.width
    Behavior on opacity{NumberAnimation{duration: 200}}
    opacity: 0
    signal cancel()

    function show(){
        imenu.opacity = 1
    }

    function hide(){
        imenu.opacity = 0
        cancel()
    }

    function setModel(model1){
        menulist.model = model1
    }

    Rectangle {
        id: bg
        smooth: true
        radius: 15
        gradient: Gradient {
            GradientStop {
                position: 0.1
                color: "#070707"
            }

            GradientStop {
                position: 0
                color: "#4d4d4d"
            }

            GradientStop {
                position: 0.2
                color: "#000000"
            }
        }
        opacity: 0.8
        border.width: 1
        border.color: "#000000"
        anchors.rightMargin: 8
        anchors.leftMargin: 8
        anchors.bottomMargin: 8
        anchors.topMargin: 8
        anchors.fill: parent


    }



    VisualItemModel{
        id:menumodel
    }

    ListView {
        id: menulist
        anchors.rightMargin: 36
        anchors.leftMargin: 36
        anchors.bottomMargin: 36
        anchors.topMargin: 36
        anchors.fill: parent
        clip: true
        spacing: 2
        model: menumodel
    }

    Image {
        id: cancelImg
        scale: 0.8
        opacity: 1
        anchors.right: parent.right
        anchors.rightMargin: 1
        anchors.top: parent.top
        anchors.topMargin: 1
        source: "qrc:/qml/R2-Touch/res/round_delete.png"
        MouseArea{
            scale: 1.5
            anchors.fill: parent
            onClicked: imenu.hide()
        }
    }
}
