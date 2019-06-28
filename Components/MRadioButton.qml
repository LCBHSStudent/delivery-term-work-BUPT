import QtQuick 2.0
import QtQuick.Controls 2.5

RadioButton {
    id: cbx;
    
    property alias txt: lab.text;
    property ActiveColor type : ui.typePrimary;
    property int size: ui.sizeDefault;
    indicator: Rectangle {
        implicitWidth: size*2;
        implicitHeight: size*2;
        radius: size;
        border.color:  checked ?type.activeColor: type.disableColor;
        border.width: size / 8;
        Rectangle {
            anchors.fill: parent;
            color: (hovered && !checked)
                   ? type.disableColor:
                     ( checked ? type.activeColor: "white");
            radius: size;
            anchors.margins: size * 0.4;
        }
    }
    background: Rectangle {
        color: "transparent";
    }
    Text{
        id: lab;
        anchors.left: cbx.right;
        anchors.leftMargin: -8;
        text: "Radio Button";
        font.family: ui.font.family;
        font.pointSize: size;
    }
    MouseArea{
        anchors.fill: parent;
        onClicked: cbx.checked = !cbx.checked;
    }
}
    