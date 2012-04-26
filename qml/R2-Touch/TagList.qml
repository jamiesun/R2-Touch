import QtQuick 1.0

Rectangle {
    id:taglist
    width: 360
    height: 640
    color: "#e6e6e6"

    signal doSettings()
    signal doQuickNotes()
    signal doReload()
    signal doStatus()
    signal tagClick(string tag,string tagid)
    signal message(string msg)
    signal doSearch
    signal doFriends
    signal doHome
    signal doBack


    function updateTags(cache){
        if(cache){
            tagsModel.loadCache()
        }
    }



    Header {
        id: header1
        title: "R2-Touch"
        isBuzy: tagsModel.busy
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        onDoLeft: doHome()
        rightable: false
    }

    Footer {
        id: footer1
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        leftIcon: "qrc:/qml/R2-Touch/res/32/notepad_2.png"
        middleIcon: ""
        rightIcon: "qrc:/qml/R2-Touch/res/32/playback_reload.png"
        onClick: {
            if(sign=="L"){
                doQuickNotes()
            }else if(sign=="R"){
                //doFriends()
                tagsModel.update()
            }else{

            }
        }
    }



    TagsModel{
        id:tagsModel
        onMessage: taglist.message(msg)
    }

    ListView {
        id: list_view
        clip: true
        anchors.bottomMargin: 0
        anchors.top: header1.bottom
        anchors.right: parent.right
        anchors.bottom: footer1.top
        anchors.left: parent.left
        anchors.topMargin: 0
        spacing: 2
        model: tagsModel
        delegate: ListItem{
            text: tagname
            width: list_view.width
            onClick: tagClick(tagname,tagid)
        }
    }



    Menu{
        id:menu
        width: Math.min(parent.width,parent.height)-60
        anchors.centerIn: parent
    }

    VisualItemModel{
        id:mainModel
        MenuItem{
            id:mstatus;
            width:menu.menuWidth;
            icon: "qrc:/qml/R2-Touch/res/32/round_and_up.png"
            text: main.online?qsTr("Go offline"):qsTr("Go online")
            onClick: {menu.hide();doStatus()}
        }

        MenuItem{
            id:mqnotes;
            width:menu.menuWidth;
            icon: "qrc:/qml/R2-Touch/res/32/notepad_2.png"
            text: qsTr("Notes");
            onClick:{menu.hide();doQuickNotes()}
        }
    }
}
