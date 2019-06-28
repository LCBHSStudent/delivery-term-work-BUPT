import QtQuick 2.12
import QtQuick.Controls 2.5
//import QtGraphicalEffects 1.12
import QtQuick.Particles 2.12

Rectangle {
    id: proBar;
    width: 256;
    height: 30;
    color: ui.colorClouds;
    radius: 5;
    property var value: 0;
    property var maxValue: 0;
    
    onValueChanged: {
        if(value === maxValue){
            partEmt.enabled = false;
        }
        else{
            partEmt.enabled = true;
        }
    }
    
    onMaxValueChanged: {
        if(value !== maxValue){
            partEmt.enabled = true;
        }
    }

    Rectangle{
        id: bar;
        color: Qt.rgba(Math.random()*2, Math.random()*2, Math.random()*2, 0.8);
        height: parent.height /// 2;Qt.rgba(Math.random(), Math.random(), Math.random(), 1);
        anchors.left: parent.left;
        width: 0;
        radius: 4;
        /*Timer{
            interval: 3000;
            running: true;
            repeat: true;
            onTriggered: ColorAnimation{
                id: colorDur;
                target: bar;
                duration: 600;
                easing.type: Easing.InQuart;
                to: Qt.rgba(Math.random()*0.8, Math.random()*0.8, Math.random()*0.8, 1);
            }
        }*///原本想实现定时变色功能
    }
    Rectangle{
        color: parent.color;
        height: parent.height /// 2;
        anchors.right: parent.right;
        width: parent.width - partEff.width - bar.width;
        radius: 4;
    }
    
    ParticleSystem {
        id: partEff;
        clip: false;
        height: parent.height;
        anchors.left: bar.right;
        anchors.leftMargin: -3;
        width: 60;
        ImageParticle {
            id: imgPart;
            alpha: 0.95;
            groups: ["S"];
            anchors.fill: parent;
            source: "qrc:/Components/Resource/Image/atom.png";
            color: bar.color;
            //greenVariation: 0.8
            //color: Qt.rgba(Math.random()*0.8, Math.random()*0.8, Math.random()*0.8, 1);
            colorVariation: 0.7;
        }
        Emitter {
            id: partEmt;
            anchors.verticalCenter: parent.verticalCenter;
            group: "S";
            emitRate: 100;
            lifeSpan: 600;
            size: 6;
            sizeVariation: -5;
            velocity: PointDirection{ x: 100; xVariation: 60; yVariation: 40}
            width: 5;
            height: bar.height * 0.98;
        }
    }
    
    PropertyAnimation{
        target: bar;
        property: "width";
        to: proBar.value / maxValue * (parent.width - partEff.width);
        duration: 500;
        easing.type: Easing.InQuart;
        onToChanged: start();
    }
}