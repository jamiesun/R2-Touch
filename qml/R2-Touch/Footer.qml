import QtQuick 1.0

Item {
    id:footer
    width: 640
    height: 60
    property int buttonWidth: footer.width/3
    property alias leftText: button1.text
    property alias middleText: button2.text
    property alias rightText: button3.text
    property alias leftIcon: button1.icon
    property alias middleIcon: button2.icon
    property alias rightIcon: button3.icon
    signal click(string sign)

    Rectangle {
        id: bg
        opacity: 0.8
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#292929"
            }

            GradientStop {
                position: 0.95
                color: "#000000"
            }
        }
        anchors.fill: parent
    }

    Button {
        id: button1
        width: buttonWidth
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.verticalCenter: parent.verticalCenter
        onClick: footer.click("L")
    }

    Button {
        id: button2
        width: buttonWidth
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        onClick: footer.click("M")
    }

    Button {
        id: button3
        width: buttonWidth
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.verticalCenter: parent.verticalCenter
        onClick: footer.click("R")
    }




}
