import QtQuick 1.0
import "dbutils.js" as Dbm
Rectangle {
    id:index
    width: 360
    height: 640

    property bool online: false

    signal goGreader
    signal goSina
    signal doOnline
    signal doAbout
    signal doLogs

    function editGAccount(){
        accountwidget.title = "Google Account"
        index.state = "showAccountWrt"
        accountwidget.clear()
        accountwidget.account = utils.getConfig("googleacc")
        accountwidget.passwd = utils.decrypt(utils.getConfig("gpassword"))

    }

    function editSAccount(){
        accountwidget.title = "Sina Account"
        index.state = "showAccountWrt"
        accountwidget.clear()
        accountwidget.account = utils.getConfig("sinaacc")||""
        accountwidget.passwd = utils.decrypt(utils.getConfig("spassword")||"")
    }

    function saveAccount(){
        index.state = ""
        if(accountwidget.title == "Google Account"){
            utils.setConfig("googleacc",accountwidget.account)
            utils.setConfig("gpassword",utils.encrypt(accountwidget.passwd))
            utils.syncConfig()
        }else  if(accountwidget.title == "Sina Account"){
            utils.setConfig("sinaacc",accountwidget.account)
            utils.setConfig("spassword",utils.encrypt(accountwidget.passwd))
            utils.syncConfig()
        }
    }


    gradient: Gradient {
        GradientStop {
            position: 0
            color: "#292929"
        }

        GradientStop {
            position: 0.27
            color: "#363636"
        }

        GradientStop {
            position: 1
            color: "#000000"
        }
    }

    Rectangle {
        id: head
        height: 60
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#292929"
            }

            GradientStop {
                position: 0.14
                color: "#3e3e3e"
            }

            GradientStop {
                position: 0.78
                color: "#2b2b2b"
            }

            GradientStop {
                position: 0.81
                color: "#161616"
            }

            GradientStop {
                position: 0.97
                color: "#313131"
            }
        }
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top

        Text {
            id: tt
            color: "#ffffff"
            text: "R2 - Read and write"
            anchors.verticalCenterOffset: -4
            font.pointSize: 9
            anchors.centerIn: parent
            style: Text.Raised
        }

    }
    Image {
        id: image1
        opacity: 0.2
        fillMode: Image.PreserveAspectFit
        anchors.fill: parent
        source: "qrc:/qml/R2-Touch/res/bg.png"
    }

    Footer {
        id: footer1
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        leftIcon: "qrc:/qml/R2-Touch/res/32/info.png"
        middleIcon: utils.getConfig("googleacc")=="jamiesun.net@gmail.com"?"qrc:/qml/R2-Touch/res/32/cog.png":""
        rightIcon: "qrc:/qml/R2-Touch/res/32/on-off.png"
        onClick: {
            if(sign=="L"){
                doAbout()
            }else if(sign=="R"){
                Dbm.log_info("exit")
                Qt.quit()
            }else{
                doLogs()
            }
        }
    }


    ListView {
        id: list_view
        anchors.bottom: footer1.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: head.bottom
        anchors.bottomMargin: 5
        anchors.topMargin: 5
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        Behavior on opacity{NumberAnimation{duration: 200}}
        opacity: parent.opacity
        boundsBehavior:ListView.StopAtBounds
        clip: true
        spacing: 5
        model: indexModel

    }




    VisualItemModel{
        id:indexModel

        AAccountButton {
            id: aaccountgoogle
            width: list_view.width
            name: "Google Reader"
            onGoing:{
                if(!utils.getConfig("googleacc"))
                    editGAccount()
                else{
                    goGreader()
                    if(login) doOnline()
                }
            }

            onEdit: editGAccount()
        }

        AAccountButton {
            id: aaccountsina
            width: list_view.width
            name: "Sina Weibo"
            onEdit: editSAccount()
            onGoing:{
                if(!utils.getConfig("sinaacc"))
                    editSAccount()
                else
                    goSina()
            }
        }





    }

    AccountWidget {
        id: accountwidget
        opacity: 0
        width: 342
        height: 326
        anchors.centerIn: parent
        onSave:saveAccount()
        onCancel: index.state = ""
        Behavior on opacity{NumberAnimation{duration: 200}}
    }

    states: [
        State {
            name: "showAccountWrt"
            PropertyChanges { target: accountwidget; opacity:1}
        }
    ]

}
