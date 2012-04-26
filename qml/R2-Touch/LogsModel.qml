import QtQuick 1.0
import "dbutils.js" as Dbm
ListModel{
    id:logsModel
    property bool busy: false
    signal message(string msg)

    function onError(err){
        message(err)
        busy = false
    }

    function onData(result){
        busy = false
        logsModel.clear()
        for(var idx in result){
            var _logdesc = result[idx].desc+"  "+result[idx].datetime
            logsModel.append({logdesc:_logdesc})
        }
    }

    function loadData(){
        Dbm.queryLogs2(onData)
    }

}
