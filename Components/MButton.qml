import QtQuick 2.12
import QtQuick.Controls 2.5

Rectangle{
    id: button;
    radius: ui.radius;
    color: button.pressed? afterPressColor: beforePressColor;
    
    property string text: "Flat Button";
    property int size : ui.sizeDefault;
    property ActiveColor type: ui.typePrimary;
    readonly property color beforePressColor: type.inactiveColor;
    readonly property color afterPressColor: type.activeColor;
    property bool iconOnLeft: true;
    property url iconSource: "";
    property bool pressed: false;
    
    width: row.implicitWidth + size;
    height: row.implicitHeight + 3;
    
    Label {
        Item {
            implicitWidth: row.implicitWidth;
            implicitHeight: row.implicitHeight;
            baselineOffset: row.y + buttonText.y + buttonText.baselineOffset;
            Row {
                id:row;
                //spacing: 5;
                anchors.centerIn: parent;
                Image {
                    width: button.iconSource === ""? 0: size;
                    height: width;
                    source: button.iconSource;
                    visible: iconOnLeft ? ((button.iconSource === "") ? false : true ):false
                    anchors.verticalCenter: parent.verticalCenter;
                }
                Text {
                    id: buttonText
                    text: button.text;
                    font.pointSize: button.size;
                    font.family: ui.font.family;
                    horizontalAlignment: Text.AlignHCenter;
                    color: "white";
                    anchors.verticalCenter: parent.verticalCenter;
                }
                Image {
                    width: button.iconSource === ""? 0: size;
                    height: width;
                    source: button.iconSource;
                    visible: !iconOnLeft ? ((button.iconSource === "") ? false : true ):false;
                    anchors.verticalCenter: parent.verticalCenter;
                }
            }
        }    
    }
    signal clicked();
    MouseArea{
        anchors.fill: parent;
        onClicked: button.clicked();
        onPressed: button.pressed = true;
        onReleased: button.pressed = false;
        
    }
}