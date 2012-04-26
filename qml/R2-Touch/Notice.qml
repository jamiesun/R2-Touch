import QtQuick 1.0
Item{
    id: notice
    width: 360//parent.width
    height: 60
    Behavior on opacity{NumberAnimation{duration: 200}}
    property bool isBuzy: false
    function show(msg){
        isBuzy = false
        msg_.text = msg
        tmr.start()
        opacity = 1
    }

    function showBuzy(msg){
        isBuzy = true
        msg_.text = msg
        tmr.start()
        opacity = 1
    }
    function stop(msg){
        msg_.text = msg
        isBuzy = false
        opacity = 0
    }
    Timer{
        id:tmr
        interval: 3000;running: false;repeat: false;triggeredOnStart: false
        onTriggered: {
            tmout.start()
            if(isBuzy){
                start()
            }else{
                notice.opacity = 0
            }

        }
    }
    Timer{
        id:tmout
        interval: 10*1000;running: false;repeat: false;triggeredOnStart: false
        onTriggered: {
            notice.stop("time out!")
        }
    }

    Rectangle {
        id: rectangle1
        radius: 0
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#272727"
            }

            GradientStop {
                position: 0.99
                color: "#111111"
            }
        }
        opacity: 1
        smooth: true
        anchors.fill: parent

        Behavior on opacity{NumberAnimation{duration: 500}}





        Text {
            id: msg_
            text: "..."
            anchors.right: image1.left
            anchors.rightMargin: 10
            anchors.left: image2.right
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            color: "#ffffff"
            font.pointSize:main.std_font
        }

        AnimatedImage {
            id: image1
            visible: isBuzy
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/qml/R2-Touch/res/loading.gif"
        }

        Image {
            id: image2
            anchors.verticalCenter: parent.verticalCenter

            anchors.left: parent.left
            anchors.leftMargin: 10
            source: "qrc:/qml/R2-Touch/res/32/cog.png"
        }
    }
}


