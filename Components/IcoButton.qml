import QtQuick 2.12
import QtQuick.Controls 2.5
Image {
    id: iconButton;
    property int size: ui.sizeDefault;
    property FlatIconName icon;
    property alias enable: btMarea.enabled;
    height: size;
    width: size;
    
    signal clicked();
    
    MouseArea{
        id: btMarea;
        anchors.fill: parent;
        hoverEnabled: true;
        onClicked: {
            iconButton.clicked();
        }
        onEntered: iconButton.source =
                   Qt.binding(function(){return  icon.hoverIcon;});
        onExited: iconButton.source =
                  Qt.binding(function(){return  icon.defaultIcon;});
    }
    
    Component.onCompleted: source = icon.defaultIcon;
}
