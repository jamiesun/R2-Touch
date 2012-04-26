import QtQuick 1.0
import QtWebKit 1.0
import "dbutils.js" as Dbm
Rectangle {
    id:feedview
    width: 360
    height: 640
    color: "#e6e6e6"

    property bool isRead: false
    property bool isShare: false
    property bool isLike: false
    property bool isStar: false
    property string clink
    property string ctext

    signal doNext()
    signal doPrevious()

    signal doRead()
    signal doBack()
    signal doHome()
    signal doShare()
    signal doLike()
    signal doStar()
    signal sendmail()
    signal doComment()

    signal message(string msg)


    function update(mobj){
         if(!mobj)return

         Dbm.log_info("read content:"+mobj.title+" "+mobj.url)

         header1.title = mobj.title
         feedview.isLike = mobj.isLike
         feedview.isRead = mobj.isRead
         feedview.isShare = mobj.isShare
         feedview.isStar = mobj.isStar


         var title_ = "<a href=\""+mobj.url+"\"><h2>"+mobj.title+"</h2></a>"
         if(mobj.content.length>256){
             web_view.html =  title_ + "<b>loading......</b>"
             ctext = title_ + mobj.content
             loadText.start()
         }else{
             web_view.html = title_ + mobj.content
         }



         clink = mobj.url
         flickable.contentX = 0
         flickable.contentY = 0
     }



    Timer{
        id:loadText
        interval: 50
        repeat: false
        running: false
        triggeredOnStart: false
        onTriggered: web_view.html = ctext
    }


    Header {
        id: header1
        height: feedview.height>feedview.width?58:0
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        isBuzy: web_view.progress<1
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
        leftIcon: "qrc:/qml/R2-Touch/res/32/arrow_left.png"
        middleIcon: "qrc:/qml/R2-Touch/res/32/align_just.png"
        rightIcon: "qrc:/qml/R2-Touch/res/32/arrow_right.png"

        onClick: {
            if(sign=="L"){
                feedview.doPrevious()
            }else if(sign=="R"){
                feedview.doNext()
            }else{
                menu.setModel(mainModel)
                menu.show()
            }
        }
    }




    Flickable {
        id: flickable
        Behavior on opacity{NumberAnimation{duration: 200}}
        opacity: parent.opacity
        clip: true
        contentWidth: Math.max(parent.width,web_view.width)
        contentHeight: Math.max(parent.height-header1.height-footer1.height,web_view.height)
        anchors.bottomMargin: 0
        anchors.top: header1.bottom
        anchors.right: parent.right
        anchors.bottom: footer1.top
        anchors.left: parent.left
        anchors.topMargin: 0
        pressDelay: 400
        smooth: false
        boundsBehavior: "StopAtBounds"



        WebView {
            id: web_view
            property bool scaled: false
            property bool autoLoadImages:false
            x: 0;y: 0
            clip: true;smooth:false
            preferredWidth: feedview.width
            preferredHeight: feedview.height
            settings.autoLoadImages:autoLoadImages
            html: "loading......"

            Behavior on opacity{NumberAnimation{duration:200}}

            onDoubleClick: {
                if(web_view.scaled){
                    web_view.scaled = false
                    web_view.contentsScale -= 0.4
                }else{
                    web_view.scaled = true
                    web_view.contentsScale += 0.4
                }
            }
            onLoadStarted: header1.isBuzy = true
            onLoadFinished: header1.isBuzy = false
            onLoadFailed: header1.isBuzy = false


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
            id:malimg
            width:menu.menuWidth
            text: qsTr("Show images")
            icon: "qrc:/qml/R2-Touch/res/32/picture.png"
            checked: web_view.autoLoadImages
            onClick:{
                menu.hide();
                web_view.autoLoadImages = !web_view.autoLoadImages
                reloadHtml.start()
            }
            Timer{
                id:reloadHtml
                interval: 200
                repeat: false
                running: false
                triggeredOnStart: false
                onTriggered: web_view.html = web_view.html
            }
        }

        MenuItem{
            id:mlike;
            width:menu.menuWidth;
            icon: "qrc:/qml/R2-Touch/res/32/heart_empty.png"
            text: qsTr("Like")
            checked: feedview.isLike
            onClick:{menu.hide();doLike()}
        }
        MenuItem{
            id:mstar;
            width:menu.menuWidth;
            icon: "qrc:/qml/R2-Touch/res/32/star_fav_empty.png"
            text: qsTr("Star")
            checked: feedview.isStar
            onClick:{menu.hide();doStar()}
        }
        MenuItem{
            id:mshare;
            width:menu.menuWidth;
            icon: "qrc:/qml/R2-Touch/res/32/share.png"
            text: qsTr("Share")
            checked: feedview.isShare
            onClick:{menu.hide();doShare()}
        }
        MenuItem{
            id:mlink;
            width:menu.menuWidth;
            icon: "qrc:/qml/R2-Touch/res/32/globe_3.png"
            text: qsTr("Open browser")
            onClick:{menu.hide();Qt.openUrlExternally(clink)}
        }
//        MenuItem{id:msendmail;
//            width:menu.width;
//            text: qsTr("SendMail");
//            onClick:{menu.hide();sendmail()}
//        }
//        MenuItem{id:mcomment;
//            width:menu.width;
//            text: qsTr("Comment");
//            onClick:{menu.hide();doComment()}
//        }

    }


}
