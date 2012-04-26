import QtQuick 1.0

Rectangle {
    id:root
    width: 360
    height: 280
    gradient: Gradient {
        GradientStop {
            position: 0
            color: "#1e1e1e"
        }

        GradientStop {
            position: 1
            color: "#313030"
        }
    }

    property alias msg: inputarea1.ivalue
    signal send(string msg)
    signal cancel





    InputArea {
        id: inputarea1
        x: 0
        y: 40
        width: root.width
        height: 180
    }

    Button {
        id: button1
        x: 0
        y: 220
        width: root.width/2
        height: 60
        radius: 0
        text: "Send"
        icon: ""
        onClick: send(inputarea1.ivalue)
    }

    Button {
        id: button2
        x: 180
        y: 220
        width: root.width/2
        height: 60
        radius: 0
        text: "Cancel"
        anchors.left: button1.right
        anchors.leftMargin: 0
        icon: ""
        onClick: cancel()
    }

    Text {
        id: text1
        x: 12
        y: 14
        width: 80
        height: 20
        color: "#ffffff"
        text: "@jamiesun    (limit 140)"
        style: Text.Raised
    }
}
