import QtQuick 2.12
import QtQuick.Controls 2.5
import QtPurchasing 1.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12

ApplicationWindow {
    id: absWindow;
    flags: Qt.FramelessWindowHint | Qt.WindowSystemMenuHint| Qt.WindowMinimizeButtonHint| Qt.absWindow
    width: 300;
    height: 200;
    minimumHeight: 50;
    minimumWidth: 100;
    visible: true;
    opacity: 0;
    color: ui.colorMidnightBlue;
    
    property ActiveColor type: ui.typeDefault;
    readonly property color beforePressColor: type.inactiveColor;
    readonly property color afterPressColor: type.activeColor;
    
    Rectangle {
        id: absWindowR;
        anchors.centerIn: parent;
        width: parent.width - 1.6;
        height: parent.height - 1.6;
        color: beforePressColor;
        //radius: ui.radius;
        states: [
            State {
                name: "npressed"; PropertyChanges {
                    target: absWindowR;
                    color: beforePressColor;
                }
            },
            State {
                name: "pressed"; PropertyChanges {
                    target: absWindowR;
                    color: afterPressColor;
                }
            }
        ]
        state: "npressed";
        transitions: Transition {
            PropertyAnimation{
                property: "color"; duration: 114; easing.type: Easing.InQuad;
            }
        }
    }
    
    //Loader{}//用于加载内部组件
    property color windowBorderColor : "#ccc";

    //    -1,0,1,2,3,4
    //    close, show, showNormal, showFullScreen, showMaxmized, showMinmized;
    //    readonly property int close:-1;
    //    readonly property int showMinmized : 1;
    //    readonly property int showNormal : 2;
    //    readonly property int showMaxmized : 3;
    //    readonly property int showFullScreen : 4;
    
    property int showState: 0;
    onShowStateChanged: {
        if(showState == -1){
            //var err;
            absWindow.close();
            try{
                absWindow.destroy(10);
            }
            catch(err){
                console.debug(absWindow, "destroy has some error", err);
            }
        }
        if(showState === ui.showNormal)
            absWindow.showNormal();
        if(showState === ui.showMinmized)
            absWindow.showMinimized();
        if(showState === ui.showMaxmized)
            absWindow.showMaximized();
        if(showState === ui.showFullScreen)
            absWindow.showFullScreen();
    }

    /*
 Qt::WindowNoState       0x00000000	The absWindow has no state set (in normal state).
 Qt::WindowMinimized     0x00000001	The absWindow is minimized (i.e. iconified).
 Qt::WindowMaximized     0x00000002	The absWindow is maximized with a frame around it.
 Qt::WindowFullScreen	0x00000004	The absWindow fills the entire screen without any frame around it.
 Qt::WindowActive        0x00000008	The absWindow is the active absWindow, i.e. it has keyboard focus.
 */
    // to fix showState
    onWindowStateChanged: {
        switch(windowState)
        {
        case 0x00000000:
            showState = 0;
            break;
        case 0x00000001:
            showState = ui.showMinmized;
            break;
        case 0x00000002:
            showState = ui.showMaxmized;
            break;
        case 0x00000004:
            showState = ui.showFullScreen;
        }
    }

    // to loader title bar icons
    property alias titleBarIcons: __iconloader.sourceComponent;

    // to set content item
    // note content is a component* type
    // may meet some error
    // Error: Cannot assign QObject* to QQmlComponent*
    property alias content: __content.sourceComponent;
    property alias contentControl: __content
    Loader { id: __content; anchors.fill: parent; anchors.margins: 10 }


    readonly property alias titleBarArea: __titlebarArea;

    header: Rectangle {
        id: titleBar;
        width: absWindow.width;
        height: ui.sizeExtraHuge;

        Separator{ orientation: Qt.Horizontal; length: titleBar.width;color:"#ccc"; }
        Separator{ orientation: Qt.Vertical; length: titleBar.height; color:"#ccc"; anchors.right: titleBar.right; }
        Separator{ orientation: Qt.Vertical; length: titleBar.height; color:"#ccc"; anchors.left: titleBar.left; }

        Text {
            id: textTitle;
            anchors.left: titleBar.left;
            anchors.verticalCenter: titleBar.verticalCenter;
            anchors.leftMargin: 10;
            text: absWindow.title;
            font.pixelSize: ui.sizeDefault;
            font.family: ui.font.family;
            color: "black";
        }

        // to loader title bar icons
        
        MouseArea {
            // 鼠标拖拽窗口移动
            id: __titlebarArea;
            anchors.fill: titleBar;
            property point previousPosition;
            onPressed:  {
                //if(absWindow.x > absWindow.x && absWindow.x < absWindow.x + absWindow.width - absWindow.width
                //        && absWindow.y > absWindow.y && absWindow.y < absWindow.y + absWindow.height - absWindow.height)
                previousPosition = Qt.point(mouseX, mouseY);
                absWindowR.state = "pressed";
            }
            onPositionChanged: {
                if (pressedButtons == Qt.LeftButton) {
                    var dx = mouseX - previousPosition.x;
                    var dy = mouseY - previousPosition.y;
                    //设为小于(或者不加else)等于则可以粘贴！
                    //if(absWindow.x > absWindow.x && absWindow.x < absWindow.x + absWindow.width - absWindow.width
                    //        && absWindow.y > absWindow.y && absWindow.y < absWindow.y + absWindow.height - absWindow.height){
                    //锁定至边框内
                        absWindow.x = absWindow.x + dx;
                        absWindow.y = absWindow.y + dy;
                    //}
                }
            }
            onReleased: {
                absWindowR.state = "npressed";
                /*if(absWindow.y <= absWindow.y)
                    absWindow.y = absWindow.y + 1;
                else if(absWindow.y >= absWindow.y + absWindow.height - absWindow.height - 1)
                    absWindow.y = absWindow.y + absWindow.height - absWindow.height - 1;
                
                if(absWindow.x <= absWindow.x)
                    absWindow.x = absWindow.x + 1;
                else if(absWindow.x >= absWindow.x + absWindow.width - absWindow.width - 1)
                    absWindow.x = absWindow.x + absWindow.width - absWindow.width - 1;
                */
            }
        }
        Loader {
            id: __iconloader;
            anchors.right: titleBar.right;
            anchors.rightMargin: ui.sizeExtraSmall;
            anchors.verticalCenter: titleBar.verticalCenter;
            // at begin of absWindow load, the key focus was in absWindow
            focus: true;
            sourceComponent: icos;
        }
    }
    Component.onCompleted: ParallelAnimation{
        /*PropertyAnimation{
            target: absWindow;
            property: "height";
            from: 20;
            to: 200;
            duration: 1500;
            easing.type: Easing.InQuart;
        }
        PropertyAnimation{
            target: absWindow;
            property: "width";
            from: 30;
            to: 300;
            duration: 1500;
            easing.type: Easing.InQuart;
        }*/
        PropertyAnimation{
            target: absWindow;
            property: "opacity";
            from: 0;
            to: 1;
            duration: 300;
            easing.type: Easing.InQuart;
        }
    }
    Component{
        id: icos;
        GridLayout {
            id: windowButtonSystem;
            columns: 3;
    
            IcoButton {
                id: minimizeButton;
                icon: ui.iconTypeShowMin;
                onClicked: absWindow.showState = ui.showMinmized;
            }
    
            IcoButton {
                id: maxButton;
                icon: (absWindow.showState > ui.showNormal) ?
                          ui.iconTypeShowMax : ui.iconTypeShowRestore;
                onClicked: {
                    switch(absWindow.showState){
                    case ui.showMaxmized:
                        absWindow.showState = ui.showNormal;
                        maxButton.icon = ui.iconTypeShowRestore;
                        break;
                    case ui.showFullScreen:
                        absWindow.showState = ui.showNormal;
                        maxButton.icon = ui.iconTypeShowRestore;
                        break;
                    case ui.showNormal:
                        absWindow.showState = ui.showMaxmized;
                        maxButton.icon = ui.iconTypeShowMax;
                        break;
                    default:
                        absWindow.showState = ui.showMaxmized;
                        maxButton.icon = ui.iconTypeShowMax;
                        break;
                    }
                }
            }
    
            IcoButton {
                id: colseButton;
                icon: ui.iconTypeClose;
                onClicked: {
                    absWindow.showState = ui.close;
                }
            }
            focus: true;
            Keys.onPressed: {
                if(event.key === Qt.Key_F11){
                    event.accepted = true;
                    absWindow.showState = ui.showFullScreen;
                }
                if(event.key === Qt.Key_Escape){
                    event.accepted = true;
                    absWindow.showState = ui.showNormal;
                }
            }
        }
    }
    
    //Component.onCompleted: console.debug("absWindow was create :",absWindow);
    //Component.onDestruction: console.debug("absWindow was destroy :",absWindow);
}