import QtQuick 1.0
Item{
    id: button
    property alias text: name_.text
    property alias icon: icon_.source
    property alias radius: bg.radius
    width: 115
    height: 60
    signal click()

    Rectangle {
        id: bg
        radius: 0
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#000000"
            }

            GradientStop {
                position: 0.19
                color: "#161616"
            }

            GradientStop {
                position: 0.76
                color: "#272727"
            }

            GradientStop {
                position: 0.99
                color: "#202020"
            }
        }
        anchors.fill: parent
    }

    Image {
        id: icon_
        anchors.centerIn: parent
        Behavior on opacity{NumberAnimation{duration: 50}}
        source: ""
    }
    Image {
        id: bgPressed
        width: 58
        height: 58
        anchors.centerIn: parent
        scale: 1.2
        opacity: 0
        source: "qrc:/qml/R2-Touch/res/mh.png"
        Behavior on opacity{NumberAnimation{duration: 50}}
    }

    Text {
        id: name_
        color: "#fdffffff"
        text: ""
        anchors.centerIn: parent
        font.weight:Font.Bold
        style: Text.Raised
        styleColor: "#2f2f2f"
        font.pointSize: main.std_font
        opacity: icon_.source == ""?1:0
    }

    MouseArea {
        id: mouse_area
        anchors.rightMargin: 1
        anchors.leftMargin: 1
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            if(name_.text!=""||icon_.source!=""){
                button.click()
            }
        }
    }


    states: [
        State {
            name: "Pressed"
            when: mouse_area.pressed == true && (name_.text!=""||icon_.source!="")
            PropertyChanges { target: icon_; opacity:0.5}
            PropertyChanges { target: bgPressed; opacity:1}
            PropertyChanges { target: bgPressed; smooth:true }
        }
    ]


}
