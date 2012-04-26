import QtQuick 1.0

Item {
    id: item1
    width: 360
    height: 72
    property alias name: text1.text
    signal going(bool login)
    signal edit


    Rectangle {
        id: bg
        radius: 10
        anchors.rightMargin: 2
        anchors.leftMargin: 2
        anchors.bottomMargin: 2
        anchors.topMargin: 2
        anchors.fill: parent
        opacity: 0.6
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#181818"
            }

            GradientStop {
                position: 0.17
                color: "#202020"
            }

            GradientStop {
                position: 0.96
                color: "#000000"
            }
        }
    }

    Text {
        id: text1
        color: "#ffffff"
        text: "Add Account"
        anchors.centerIn: parent
        style: Text.Raised
    }

    Image {
        id: imagel
        anchors.left: parent.left
        anchors.leftMargin: 15
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 0
        source: "qrc:/qml/R2-Touch/res/32/key.png"
    }
    Image {
        id: bgPressedl
        scale: 1.3
        opacity: 0
        anchors.fill: imagel
        source: "res/mh.png"
    }

    Image {
        id: imager
        anchors.right: parent.right
        anchors.rightMargin: 15
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 0
        source: "qrc:/qml/R2-Touch/res/32/round_arrow_right.png"
    }
    Image {
        id: bgPressedr
        scale: 1.3
        opacity: 0
        anchors.fill: imager
        source: "res/mh.png"
    }

    MouseArea {
        id: mouse_areal
        width: 73
        height: 72
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        onClicked: edit()
    }

    MouseArea {
        id: mouse_arear
        x: 291
        y: 0
        width: 69
        height: 72
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        onClicked: going(true)
    }

    MouseArea {
        id: mouse_aream
        x: 96;y: 0;width: 173;height: 70
        onClicked: going(false)
    }

    Image {
        id: image1
        y: 67
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        source: "qrc:/qml/R2-Touch/res/line.png"
    }
    states: [
        State {
            name: "Pressedl"
            when: mouse_areal.pressed == true
            PropertyChanges { target: bg; opacity:0.4}
            PropertyChanges { target: imagel; opacity:0.5}
            PropertyChanges { target: bgPressedl; opacity:1}
            PropertyChanges { target: bgPressedl; smooth:true }
        },
        State {
            name: "Pressedr"
            when: mouse_arear.pressed == true
            PropertyChanges { target: bg; opacity:0.4}
            PropertyChanges { target: imager; opacity:0.5}
            PropertyChanges { target: bgPressedr; opacity:1}
            PropertyChanges { target: bgPressedr; smooth:true }
        },
        State {
            name: "Pressedm"
            when:  mouse_aream.pressed == true
            PropertyChanges { target: bg; opacity:0.4}
        }
    ]
    transitions: Transition {
        PropertyAnimation { properties: "opacity"; duration: 50 }
    }
}
