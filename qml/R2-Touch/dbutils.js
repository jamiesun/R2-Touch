Qt.include("json2.js")
Date.prototype.format = function(format){
 /*
  * eg:format="YYYY-MM-dd hh:mm:ss";
  */
 var o = {
  "M+" :  this.getMonth()+1,  //month
  "d+" :  this.getDate(),     //day
  "h+" :  this.getHours(),    //hour
      "m+" :  this.getMinutes(),  //minute
      "s+" :  this.getSeconds(), //second
      "q+" :  Math.floor((this.getMonth()+3)/3),  //quarter
      "S"  :  this.getMilliseconds() //millisecond
   }

   if(/(y+)/.test(format)) {
    format = format.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
   }

   for(var k in o) {
    if(new RegExp("("+ k +")").test(format)) {
      format = format.replace(RegExp.$1, RegExp.$1.length==1 ? o[k] : ("00"+ o[k]).substr((""+ o[k]).length));
    }
   }
 return format;
}



function getDB(){return openDatabaseSync("R2DB", "1.0", "R2 database!", 1000000)}

function  initDatabase(){
    var db = getDB()
    db.transaction(
        function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS tags(id TEXT, name TEXT,unread INTEGER,sortid INTEGER)')
            tx.executeSql('CREATE TABLE IF NOT EXISTS subs(id TEXT, title TEXT,categories TEXT,sortid TEXT,firstitemmsec TEXT,htmlUrl TEXT,unread INTEGER)')
            tx.executeSql('CREATE TABLE IF NOT EXISTS prefs(id TEXT,value TEXT)')
            tx.executeSql('CREATE TABLE IF NOT EXISTS items(id TEXT,type TEXT,author TEXT,title TEXT,alternate TEXT, categories TEXT,comments TEXT,crawlTimeMsec TEXT,likingUsers TEXT,origin TEXT,published TEXT,summary TEXT,content TEXT,updated TEXT)')
            tx.executeSql('CREATE TABLE IF NOT EXISTS cache(name TEXT, value TEXT)')
            tx.executeSql('CREATE TABLE IF NOT EXISTS logs(id INTEGER,desc TEXT,datetime TEXT, PRIMARY KEY (id))')
        }
    )
}

function log_info(msg){
    if(!msg)return
    console.log("logging "+msg)
    var db = getDB()
    db.transaction(
        function(tx) {
             tx.executeSql("insert into logs (desc,datetime) values(?,?)",[msg,new Date().format("yyyy-MM-dd hh:mm:ss")])
        }
    )
}



function updateTags(tags){
    if(!tags)return
    var db = getDB()

    tags = [{name:"Broadcast",id:"user/-/state/com.google/broadcast",unread:0},
               {name:"Broadcast-friends",id:"user/-/state/com.google/broadcast-friends",unread:0},
               {name:"Starred",id:"user/-/state/com.google/starred",unread:0},
                {name:"Notes",id:"user/-/state/com.google/created",unread:0}].concat(tags)
    db.transaction(
        function(tx) {
            tx.executeSql('delete from tags')
            for(var idx in tags){
                var tag = tags[idx]
                tx.executeSql("insert into tags values(?,?,?,?)",[tag.id,tag.name,tag.unread,Number(new Date())])
            }
        }
    )
}

function updateSubs(subs){
    if(!subs)return
    var db = getDB()
    db.transaction(
        function(tx) {
            tx.executeSql('delete  FROM subs')
            for(var idx in subs){
                var sub = subs[idx]
                tx.executeSql("insert into subs values(?,?,?,?,?,?,?)",
                              [sub.id,
                               sub.title,
                               JSON.stringify(sub.categories),
                               sub.sortid,
                               sub.firstitemmsec,
                               sub.htmlUrl,
                               sub.unread])
            }

        }
    )

}

function updateItems(feedid,items){
    if(!items)return
    var db = getDB()
    for(var idx in items){
        var item = items[idx]
        item.categories = item.categories?item.categories:[]
        item.categories.push(feedid)
        db.transaction(
            function(tx) {
                var rs = tx.executeSql('SELECT count(*) as count FROM items where id=?',[item.id])
                if(rs.rows.item(0).count>0)return
                tx.executeSql("insert into items values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
                              [item.id,
                               item.type,
                               item.author,
                               item.title,
                               JSON.stringify(item.alternate),
                               JSON.stringify(item.categories),
                               JSON.stringify(item.comments),
                               item.crawlTimeMsec,
                               JSON.stringify(item.likingUsers),
                               JSON.stringify(item.origin),
                               item.published,
                               JSON.stringify(item.summary),
                               JSON.stringify(item.content),
                               item.updated])
            }
        )
    }
}

function updateTagUnread(tagid,count){
    if(!tagid)return
    var db = getDB()
    db.transaction(
        function(tx) {
            var rs = tx.executeSql('SELECT unread FROM tags where id=?',[tagid])
            var newcount = rs.rows.item(0).count+parseInt(count)
            tx.executeSql('update tags set unread = ?',[newcount])
        }
    )
}

function updateSubUnread(subid,count){
    if(!subid)return
    var db = getDB()
    db.transaction(
        function(tx) {
            var rs = tx.executeSql('SELECT unread FROM subs where id=?',[tagid])
            var newcount = rs.rows.item(0).count+parseInt(count)
            tx.executeSql('update subs set unread = ?',[newcount])
        }
    )
}

function queryTags(callback){

    var db = getDB()
    db.readTransaction(
        function(tx) {
            var rs = tx.executeSql("select * from tags order by sortid asc")
            var tags = []
            for(var i = 0; i < rs.rows.length; i++) {
                tags.push(rs.rows.item(i))
            }

            callback(tags)
        }
    )
}

function queryItems(rss,callback,page){

    var db = getDB()
    db.readTransaction(
        function(tx) {
            var crs = tx.executeSql("select count(*) as count from items  where origin like ? or categories like ? ",['%'+rss+'%','%'+rss+'%'])
            var rs = tx.executeSql("select * from items where origin like ? or categories like ? order by updated desc limit ?,20",['%'+rss+'%','%'+rss+'%',page*20])
            var items = []
            for(var i = 0; i < rs.rows.length; i++) {
                var item = rs.rows.item(i)
                item.categories = item.categories?JSON.parse(item.categories):[]
                item.comments = item.comments?JSON.parse(item.comments):[]
                item.likingUsers = item.likingUsers?JSON.parse(item.likingUsers):[]
                item.origin = JSON.parse(item.origin)
                item.alternate = item.alternate?JSON.parse(item.alternate):[]
                item.summary = item.summary?JSON.parse(item.summary):{}
                item.content = item.content?JSON.parse(item.content):{}
                items.push(item)
            }

            callback(items,crs.rows.item(0).count)
        }
    )
}

function querySubs(rssid,callback){
    var db = getDB()
    db.readTransaction(
        function(tx) {
            var rs = tx.executeSql("select * from subs where categories like ?",['%'+tag+'%'])
            var subs = []
            for(var i = 0; i < rs.rows.length; i++) {
                var sub = rs.rows.item(i)
                sub.categories = JSON.parse(sub.categories)
                subs.push(sub)
            }
            callback(subs)
        }
    )
}

function queryLogs(callback){
    var db = getDB()
    db.readTransaction(
        function(tx) {
            var rs = tx.executeSql("select * from logs limit 10")
            var logs = []
            for(var i = 0; i < rs.rows.length; i++) {
                var log = rs.rows.item(i)
                logs.push(log)
            }
            callback(logs)
        }
    )
}

function queryLogs2(callback){
    var db = getDB()
    db.readTransaction(
        function(tx) {
            var rs = tx.executeSql("select * from logs order by datetime desc limit 30 ")
            var logs = []
            for(var i = 0; i < rs.rows.length; i++) {
                var log = rs.rows.item(i)
                logs.push(log)
            }
            callback(logs)
        }
    )
}


function execute(sql,params){
    var db = getDB()
    db.transaction(
        function(tx) {
            tx.executeSql(sql,params);
        }
    )
}



function executeQuery(sql,params,callback){
    var db = getDB()
    db.readTransaction(
        function(tx) {
            var rs = tx.executeSql(sql,params);
            callback({result:rs.rows})
        }
    )
}

function fromCache(ckey,callback){
    if(!ckey)return
    var db = getDB()
    db.transaction(
        function(tx) {
            var rs = tx.executeSql('SELECT * FROM cache where name=?',[ckey]);
            if(rs.rows.length<=0){
                callback(null)
                return
            }
            callback(rs.rows.item(0).value)
        }
    )
}

function setCache(ckey,cdata){
    if(!ckey&&!cdata)return
    var db = getDB()
    db.transaction(
        function(tx) {
            tx.executeSql('delete FROM cache where name=?',[ckey])
            tx.executeSql('insert into cache values(?,?)',[ckey,cdata])
        }
    )
}
