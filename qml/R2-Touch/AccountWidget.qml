import QtQuick 1.0

Item {
    width: 342
    height: 326
    signal save
    signal cancel
    property alias title: title_.text
    property alias account: account_.ivalue
    property alias passwd: passwd_.ivalue

    function clear(){
        account_.ivalue = ""
        passwd_.ivalue = ""
    }


    Image {
        id: image1
        x: 7
        y: 8
        source: "res/wrt.png"
        smooth: opacity>0
        Input {
            id: account_
            x: 3
            y: 46
            height: 65
            radius: 10
            anchors.top: parent.top
            anchors.topMargin: 72
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 15
            iname: "Account:"
        }

        Input {
            id: passwd_
            height: 65
            radius: 10
            eachMode: TextInput.Password
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: account_.bottom
            iname: "Passwd:"
            anchors.topMargin: 10
            anchors.rightMargin: 20
            anchors.leftMargin: 15
        }

        HeadButton {
            id: headbutton1
            y: 227
            icon: "qrc:/qml/R2-Touch/res/32/checkmark.png"
            anchors.left: parent.left
            anchors.leftMargin: 30
            onClick: {
                if(!account_.ivalue||!passwd_.ivalue)
                    return
                save()
            }
        }

        HeadButton {
            id: headbutton2
            y: 227
            icon: "qrc:/qml/R2-Touch/res/32/cancel.png"
            anchors.right: parent.right
            anchors.rightMargin: 35
            onClick: cancel()
        }

        Text {
            id: title_
            color: "#ffffff"
            text: "Account Setting"
            font.bold: true
            style: Text.Raised
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 25
        }
    }
}
