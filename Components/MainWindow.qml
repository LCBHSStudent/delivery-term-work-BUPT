import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtPurchasing 1.12

ApplicationWindow {
    id: root;
    visible: true;
    width: 1280;
    height: 760;
    color: ui.colorClouds;
    title: qsTr("Self Designed Components");
    flags: Qt.FramelessWindowHint | Qt.WindowSystemMenuHint| Qt.WindowMinimizeButtonHint| Qt.Window;
    
    property int showState: 0;
    
    header: TitleBar{}
    
    onWindowStateChanged: {
        switch(windowState){
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
    
    onShowStateChanged: {
        if(showState === -1){
            root.close();
            try{
                root.destroy(10);
            }
            catch(err){
                //console.debug(root, "destroy has some error", err);
            }
        }
        if(showState === ui.showNormal)
            root.showNormal();
        if(showState === ui.showMinmized)
            root.showMinimized();
        if(showState === ui.showMaxmized)
            root.showMaximized();
        if(showState === ui.showFullScreen)
            root.showFullScreen();
    }
}