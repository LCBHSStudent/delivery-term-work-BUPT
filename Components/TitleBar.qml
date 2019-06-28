import QtQuick 2.12
import QtQuick.Layouts 1.12

Rectangle {
    id: titleBar;
    width: root.width;
    height: ui.sizeExtraHuge;
    Separator{ orientation: Qt.Horizontal; length: titleBar.width;color:"#ccc"; }
    Separator{ orientation: Qt.Vertical; length: titleBar.height; color:"#ccc"; anchors.right: titleBar.right; }
    Separator{ orientation: Qt.Vertical; length: titleBar.height; color:"#ccc"; anchors.left: titleBar.left; }

    Text {
        id: textTitle;
        anchors.left: titleBar.left;
        anchors.verticalCenter: titleBar.verticalCenter;
        anchors.leftMargin: 10;
        text: root.title;
        font.pixelSize: ui.sizeDefault;
        font.family: ui.font.family;
        color: "black";
    }

    // to loader title bar icons
    MouseArea {
        id: __titlebarArea;
        anchors.fill: titleBar;
        property point previousPosition;
        onPressed: previousPosition = Qt.point(mouseX, mouseY);
        
        onPositionChanged: {
            if (pressedButtons == Qt.LeftButton) {
                var dx = mouseX - previousPosition.x;
                var dy = mouseY - previousPosition.y;
                root.x = root.x + dx;
                root.y = root.y + dy;
            }
        }
        
    }
    Loader {
        id: __iconloader;
        anchors.right: titleBar.right;
        anchors.rightMargin: ui.sizeExtraSmall;
        anchors.verticalCenter: titleBar.verticalCenter;
        // at begin of root load, the key focus was in root
        sourceComponent: icos;
        focus: true;
    }
    Component{
        id: icos;
        GridLayout {
            id: windowButtonSystem;
            columns: 3;
    
            IcoButton {
                id: minimizeButton;
                icon: ui.iconTypeShowMin;
                onClicked: {
                    root.showState = ui.showMinmized;
                }
            }
    
            IcoButton {
                id: maxButton;
                icon: (root.showState > ui.showNormal) ?
                          ui.iconTypeShowMax : ui.iconTypeShowRestore;
                onClicked: {
                    switch(root.showState){
                    case ui.showMaxmized:
                        root.showState = ui.showNormal;
                        maxButton.icon = ui.iconTypeShowRestore;
                        break;
                    case ui.showFullScreen:
                        root.showState = ui.showNormal;
                        maxButton.icon = ui.iconTypeShowRestore;
                        break;
                    case ui.showNormal:
                        root.showState = ui.showMaxmized;
                        maxButton.icon = ui.iconTypeShowMax;
                        break;
                    default:
                        root.showState = ui.showMaxmized;
                        maxButton.icon = ui.iconTypeShowMax;
                        break;
                    }
                }
            }
    
            IcoButton {
                id: colseButton;
                icon: ui.iconTypeClose;
                onClicked: {
                    root.showState = ui.close;
                }
            }
            focus: true;
            Keys.onPressed: {
                if(event.key === Qt.Key_F11){
                    event.accepted = true;
                    root.showState = ui.showFullScreen;
                }
                if(event.key === Qt.Key_Escape){
                    event.accepted = true;
                    root.showState = ui.showNormal;
                }
            }
        }
    }
}            