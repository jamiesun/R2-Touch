import QtQuick 1.0

Rectangle {
    id: settings
    width: 360
    height: 640
    color: "#e6e6e6"


    signal doHome()
    signal doBack()
    signal doLogin()

    function doSave(){
        if(emailIn.ivalue&&passwdIn.ivalue){
            utils.setConfig("email",emailIn.ivalue)
            utils.setConfig("password",utils.encrypt(passwdIn.ivalue))
            utils.syncConfig()
            doLogin()
        }
    }


    Header {
        id: header1
        title: "R2-Settings"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        onDoLeft: doHome()
        onDoRight: doBack()
    }

    Footer {
        id: footer1
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        leftIcon: "qrc:/qml/R2-Touch/res/32/save.png"
        middleIcon: "qrc:/qml/R2-Touch/res/32/home.png"
        rightIcon: "qrc:/qml/R2-Touch/res/32/undo.png"
        onClick: {
            if(sign=="L"){
                doSave()
            }else if(sign=="R"){
                doBack()
            }else{
                doHome()
            }
        }
    }



    VisualItemModel {
        id: itemModel
        Input{
            id:emailIn;iname: qsTr("Email:")
            ivalue: utils.getConfig("email")
        }
        Input{
            id:passwdIn;iname: qsTr("Password:")
            eachMode:TextInput.PasswordEchoOnEdit;
            ivalue: utils.decrypt(utils.getConfig("password"))
        }
    }

    ListView {
        id: list_view1
        Behavior on opacity{NumberAnimation{duration: 200}}
        opacity: parent.opacity
        clip: true
        anchors.bottomMargin: 0
        anchors.top: header1.bottom
        anchors.right: parent.right
        anchors.bottom: footer1.top
        anchors.left: parent.left
        anchors.topMargin: 0
        spacing: 2
        model: itemModel
    }





}
