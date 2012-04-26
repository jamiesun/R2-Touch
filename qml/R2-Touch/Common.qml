import QtQuick 1.0

QtObject {
    id:cobj
    signal noSetting()
    signal initDone()
    signal msg(string msg)


    function getDB(){return openDatabaseSync("R2DB", "1.0", "R2 database!", 1000000)}

    function  initDatabase(){
        var db = getDB()
        db.transaction(
            function(tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS settings(name TEXT, value TEXT)')
                tx.executeSql('CREATE TABLE IF NOT EXISTS cache(name TEXT, value TEXT)')
            }
        )
    }


    function initSettings(){
        var db = getDB()
        db.transaction(
            function(tx) {

                var rs = tx.executeSql('SELECT * FROM settings');
                if(rs.rows.length<=0){
                    noSetting()
                    return
                }


                for(var i = 0; i < rs.rows.length; i++) {
                    var name = rs.rows.item(i).name
                    var value = rs.rows.item(i).value
                    if(name=="email")email = value
                    else if(name=="passwd")passwd = value
                    else if(name=="autoRefresh")autoRefresh = value
                }

                if(!email||!passwd){
                    noSetting()
                    return
                }
                initDone()
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





}
