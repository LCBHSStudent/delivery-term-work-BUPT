import QtQuick.Controls 2.5
import QtQuick 2.12
CheckBox {
    id: cbx;
    
    property alias txt: cbxt.text;
    property ActiveColor type : ui.typePrimary;
    property int size: ui.sizeDefault;
    indicator: Rectangle {
        implicitWidth: size*2;
        implicitHeight: size*2;
        radius: ui.radius;
        border.color:  checked? type.activeColor: type.disableColor;
        border.width: size / 8;
        Rectangle {
            anchors.fill: parent;
            color: (hovered && !checked)?
                       type.disableColor:
                       ( checked ? type.activeColor: "white");
            anchors.margins: size * 0.4;
        }
    }
    background: Rectangle{
        color: "transparent";
    }
    
    Label {
        anchors.left: cbx.right;
        anchors.leftMargin: -8;
        Text {
            id: cbxt;
            text: "Check Box";
            font.family: ui.font.family;
            font.pointSize: size;
        }    
    }
}
