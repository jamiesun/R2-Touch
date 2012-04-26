import QtQuick 1.0

Item {
    id:hbutton
    width: 58
    height: 58
    property alias icon: image1.source
    signal click
    Image {
        id: image1
        opacity: 0.9
        anchors.centerIn: parent
        source: "qrc:/qml/R2-Touch/res/32/home.png"
        Behavior on opacity{NumberAnimation{duration: 50}}
    }

    Image {
        id: bgPressed
        opacity: 0
        anchors.fill: parent
        source: "qrc:/qml/R2-Touch/res/mh.png"
        Behavior on opacity{NumberAnimation{duration: 50}}
    }

    MouseArea {
        id: mouse_area
        anchors.fill: parent
        hoverEnabled: true
        onClicked: hbutton.click()
    }

    states: [
        State {
            name: "Pressed"
            when: mouse_area.pressed == true
            PropertyChanges { target: image1; opacity:0.5}
            PropertyChanges { target: bgPressed; opacity:1}
            PropertyChanges { target: bgPressed; smooth:true }
        }
    ]

}
