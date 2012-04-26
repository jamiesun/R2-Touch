import QtQuick 1.0
Rectangle {
    width: parent.width
    height: 65
    gradient: Gradient {
        GradientStop {
            position: 0
            color: "#e6e6e6"
        }

        GradientStop {
            position: 0.98
            color: "#c0c0c0"
        }
    }
    property string ikey: ""
    property alias iname: iname_.text
    property alias ivalue: ivalue_.text
    property alias eachMode: ivalue_.echoMode
    property alias iheight: ivalue_.height

    MouseArea{
        anchors.fill: parent
        onClicked: ivalue_.forceActiveFocus()
    }


    Rectangle {
        id: rectangle1
        color: ivalue_.activeFocus?"#f9f9f9":"#ffffff"
        radius: 10
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.bottomMargin: 10
        anchors.topMargin: 10
        anchors.fill: parent

        Text {
            id: iname_
            y: 0
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize:main.std_font
        }

        TextInput {
            id: ivalue_
            text: ""
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.left: iname_.right
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize:main.std_font
            cursorVisible: true
            activeFocusOnPress: true
        }
    }

}
