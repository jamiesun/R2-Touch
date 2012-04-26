import QtQuick 1.0
Item {
    id: header
    width: 360
    height: 58
    property alias title: title_.text
    property bool isBuzy: false
    property alias rightable: rightButton.visible
    property alias leftable: leftButton.visible
    property alias lefticon: leftButton.icon
    property alias righticon: rightButton.icon
    signal doLeft
    signal doRight

    Rectangle {
        id: bg
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#292929"
            }

            GradientStop {
                position: 0.15
                color: "#3e3e3e"
            }

            GradientStop {
                position: 0.79
                color: "#2b2b2b"
            }

            GradientStop {
                position: 0.82
                color: "#090909"
            }

            GradientStop {
                position: 0.99
                color: "#313131"
            }
        }
        anchors.fill: parent



    }


    AnimatedImage {
        id: bimg
        anchors.left: title_.right
        anchors.leftMargin: 10
        visible: isBuzy
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/qml/R2-Touch/res/loading.gif"
    }

    Text {
        id:title_
        color: "#ffffff"
        text: "Title"
        verticalAlignment: Text.AlignVCenter
        anchors.left: leftButton.right
        anchors.leftMargin: 10
        anchors.right: rightButton.left
        anchors.rightMargin: 36
        horizontalAlignment: Text.AlignHCenter
        elide:Text.ElideRight
        anchors.verticalCenter: bg.verticalCenter
        font.pointSize: main.std_font
    }

    HeadButton {
        id: leftButton
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        icon: "qrc:/qml/R2-Touch/res/32/home.png"
        onClick: doLeft()
    }

    HeadButton {
        id: rightButton
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        icon: "qrc:/qml/R2-Touch/res/32/undo.png"
        onClick: doRight()
    }




}
