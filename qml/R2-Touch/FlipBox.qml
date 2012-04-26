import QtQuick 1.0

Flipable {
     id: container
     property bool flipped: false
     property int xAxis: 0
     property int yAxis: 1
     property int angle: 180

     function flip(){
         container.flipped = !container.flipped
     }

     transform: Rotation {
         id: rotation; origin.x: container.width / 2; origin.y: container.height / 2
         axis.x: container.xAxis; axis.y: container.yAxis; axis.z: 0
     }

     states: State {
         name: "back"; when: container.flipped
         PropertyChanges { target: rotation; angle: container.angle }
     }

     transitions: Transition {
         ParallelAnimation {
             NumberAnimation { target: rotation; properties: "angle"; duration: 600 }
             SequentialAnimation {
                 NumberAnimation { target: container; property: "scale"; to: 0.75; duration: 300 }
                 NumberAnimation { target: container; property: "scale"; to: 1.0; duration: 300 }
             }
         }
     }
 }
