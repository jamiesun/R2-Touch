import QtQuick 1.0

Item {
    id: item1
    width: 360
    height: 280
    property alias title: text1.text

    Rectangle {
        id: bg
        radius: 10
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#252525"
            }

            GradientStop {
                position: 0.91
                color: "#1c1c1c"
            }

            GradientStop {
                position: 0.22
                color: "#272727"
            }

            GradientStop {
                position: 0.16
                color: "#1a1a1a"
            }

            GradientStop {
                position: 0.1
                color: "#3a3a3a"
            }

            GradientStop {
                position: 1
                color: "#0f0f0f"
            }
        }
        border.color: "#000000"
        opacity: 0.9
        anchors.rightMargin: 2
        anchors.leftMargin: 2
        anchors.bottomMargin: 2
        anchors.topMargin: 2
        anchors.fill: parent
    }

    Image {
        id: image1
        anchors.top: parent.top
        anchors.topMargin: 42
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 5
        source: "res/line.png"
    }

    Text {
        id: text1
        color: "#ffffff"
        text: "Google Reader"
        anchors.horizontalCenter: parent.horizontalCenter
        font.bold: false
        style: Text.Raised
        anchors.bottom: image1.top
        anchors.bottomMargin: 9
    }

}
