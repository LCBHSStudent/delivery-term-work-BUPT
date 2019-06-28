import QtQuick 2.12
import QtQuick.Controls 2.5

TextField {
    id: textField;
    placeholderText: "TextField_nonThread";
    property alias size: showText.font.pointSize;
    property ActiveColor type: ui.typePrimary;

    implicitWidth: 200;
    implicitHeight: showText.height+10;
    height: showText.height+10;
    
    background: Rectangle {
        radius: ui.radius;
        implicitWidth: 100;
        implicitHeight: 24;
        border.color: textField.focus?type.activeColor:type.inactiveColor
        border.width: textField.focus? 2: 1;
    }
    placeholderTextColor:"#ccc";
    font: showText.font;  
    color: showText.color;
          

    Text{
        id:showText;
        text:"hello world";
        opacity: 0;
        font.family: ui.font.family;
        font.pointSize: ui.sizeSmall;
        color: type.activeColor;
    }
}
