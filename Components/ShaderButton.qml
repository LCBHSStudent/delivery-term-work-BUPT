import QtQuick 2.6
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.12

Item {
    id : mybutton
    width: 100
    height: 50
 
    signal clicked();
 
    Rectangle {
        id : bgrect;
        y : 20
        x : 1
        color: "#5CB85C";
        width: mybutton.width-2;
        height: mybutton.height-25
        radius: height/2
    }
 
    DropShadow {
        id : shadow
        anchors.fill: bgrect
        horizontalOffset: 2
        verticalOffset: 12
        radius: 8.0
        samples: 17
        color: "#999999"
        source: bgrect
    }
 
 
    Rectangle{
        id : toprect
        color: "#5CB85C"
        width: mybutton.width;
        height: mybutton.height-2
        radius: height/3
 
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled : true
            onClicked: {
               animation.start();
               mybutton.clicked();
            }
            onEntered: {
                toprect.color = "#3e8e41";
                bgrect.color = "#3e8e41";
            }
            onExited: {
                toprect.color = "#5CB85C";
                bgrect.color = "#5CB85C";
            }
 
        }
 
    }
 
    Text {
        id: mytext
        anchors.centerIn: toprect
        text: qsTr("text")
        color: "#ffffff"
        font.pixelSize : toprect.height/2
    }
 
 
    SequentialAnimation {
 
              id : animation
              NumberAnimation { target: toprect; property: "y"; to: toprect.x+2; duration: 100 }
              NumberAnimation { target: toprect; property: "y"; to: toprect.x-2; duration: 100 }
          }
 
}