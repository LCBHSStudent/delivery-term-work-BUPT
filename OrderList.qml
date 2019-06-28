import QtQuick 2.12
import "Components"

AnimatedImage{
    id: orderBack;
    opacity: 0.8;
    source: "image/11.gif";
    anchors.centerIn: parent;
    width: 600;
    height: 600;
    z: 5;
    property alias model: ordView.model;
    
    ListView{
        id: ordView;
        clip: true;
        width: parent.width * 0.7;
        spacing: 4;
        
        anchors{
            horizontalCenter: parent.horizontalCenter;
            top: parent.top;
            bottom: parent.bottom;
            bottomMargin: 180;
            topMargin: 190;
        }
        
        delegate: Rectangle{
            radius: 4;
            width: parent.width * 0.9;
            anchors.horizontalCenter: parent.horizontalCenter;
            height: 0.08 * orderBack.height;
            color: ui.colorPeterRiver;
            opacity: 0.97;
            
            Text {
                id: delTxt;
                text: "【订单信息】编号：" +
                  JSON.stringify(index) + " 时间：" + JSON.stringify(time) + "\n餐馆坐标：" +
                  JSON.stringify(resx) + " " + JSON.stringify(resy) + " 食客坐标：" +
                  JSON.stringify(detx) + " " + JSON.stringify(dety);
                anchors.centerIn: parent;
                font.family: ui.font;
                font.bold: true;
                color: ui.colorClouds;
            }
        }
        
        Component.onCompleted: {
            ordView.positionViewAtEnd();
        }
    }
    Component.onCompleted: ParallelAnimation{
        PropertyAnimation{
            target: orderBack;
            property: "width";
            from: 0;
            to: 600;
            easing.type: Easing.OutQuint;
            duration: 300;
        }
        PropertyAnimation{
            target: orderBack;
            property: "height";
            from: 0;
            to: 600;
            easing.type: Easing.InQuart;
            duration: 300;
        }
    }
    
    ParallelAnimation{
        id: closeAni;
        PropertyAnimation{
            target: orderBack;
            property: "width";
            from: 600;
            to: 0;
            easing.type: Easing.InQuart;
            duration: 300;
        }
        PropertyAnimation{
            target: orderBack;
            property: "height";
            from: 600;
            to: 0;
            easing.type: Easing.OutQuart;
            duration: 300;
        }
        onFinished: orderBack.destroy();
    }
    function close(){
        closeAni.start();
    }
}