import QtQuick 1.0
Rectangle {
    width: parent.width
    height:180
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

    property alias ivalue: ivalue_.text

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


        TextEdit {
            id: ivalue_
            text: ""
            activeFocusOnPress: true
            cursorVisible: true
            clip: true
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            font.pointSize:main.std_font
            wrapMode: TextEdit.WrapAnywhere
            selectByMouse:true
        }
    }

}
