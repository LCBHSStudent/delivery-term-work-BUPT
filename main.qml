import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.LocalStorage 2.12
import QtGraphicalEffects 1.12
import QtMultimedia 5.12
import "Components"

MainWindow {
    id: mainWind;
    visible: true;
    width: 1530;
    height: 750;
    title: qsTr("WorkBeta");
    color: "black";
    
    UIGlobal{id: ui;}
    
    property var mButtons: [];
    property int curTime: 0;//当前时间
    property var riders: [];
    property var myDB;
    property int polledOrd: 0;
    property int totalOrd: 0;
    property int exOrd: 0;
    
    property bool appending: appendSwitch.checked;
    property int rIndex: -1;
    property int dIndex: -1;
    onDIndexChanged: {
        if(rIndex != -1 && dIndex != -1){
            sys.appendOrder(houses.itemAt(rIndex).ax * 2, houses.itemAt(rIndex).ay * 2,
                            houses.itemAt(dIndex).ax * 2, houses.itemAt(dIndex).ay * 2);
            houses.itemAt(dIndex).unSelect();
            houses.itemAt(rIndex).unSelect();
            rIndex = -1;
            dIndex = -1;
            //console.log("order has appended to sys!");
        }
    }
    Component{
        id: rider;
        Rider{ z: 3 }
    }
    //改为修改Property & OnChanged & transaction（changeXY）的模式
    
    Connections{
        target: sys;
        onNewRider: {
            var id = riders.length;
            riders.push(rider.createObject(mainWind, {}));
            riders[id].riderNum = id;
            btGroup.model = btGroup.model + 1;
        }
        onRiderMoved: {
            riders[id].riderMove(x, y);
            var i = id, px = x, py = y;
            //console.log(i, px, py);
        }

        onChangeToRes: {
            var X = x, Y = y;
            //console.log(X,Y,"设定为餐馆");
        }
        onQuit: {
            Qt.quit();
        }
        onBalanceChange: {
            balanceBt.text = "当前余额：" + value;
        }
        onOrderAppend: {
            ordMod.append({index: index, time: time, resx: rx, resy: ry, detx: dx, dety: dy});
            var rY = ry, rX = rx, dY = dy, dX = dx;
            houses.itemAt(Math.floor(((rY*9) + rX)/2)).arrVis = true;
            houses.itemAt(Math.floor(((dY*9) + dX)/2)).arrVis = true;
            ordLst.positionViewAtEnd();
            
            var test = ordSnd.createObject(mainWind, {});
        }
        onOrdLoad :{
            totalOrd = cnt;
        }
        onRidGetOrd: {
            var i = id, j = index_;
            var rowCount = ordMod.count;
            for(var z = 0; z < rowCount; z++) {
                var data = ordMod.get(z);
                if(data.index === j) {
                    riders[i].model.append(data);
                    break;
                }
            }
            //特效
        }
        onOrdEx: {
            //var i = id, j = index_;
            exOrd = exOrd + 1;
        }
        onCurTP: {
            curTime = cur;
        }
        onOrdPop: {
            var t = timers.createObject(this, {});
            t.index = ordIndex;
            t.rid = id;
            t.start();
        }
        onRiderArrivedRes: {
            riders[id].changeBubleType("image/getR.png");
            riders[id].showBuble();
        }
        onRiderArrivedDet: {
            riders[id].changeBubleType("image/getD.png");
            riders[id].showBuble();
        }

        //onOrdPP: polledOrd = polledOrd + 1;
    }
    Component {
        id: timers;
        Timer {
            property int index: -1;
            property int rid: -1;
            interval: 1989;
            id: tim;
            repeat: false;
            running: false;
            onTriggered: {
                polledOrd = polledOrd + 1;
                var rowCount = ordMod.count;
                for(var i = 0; i < rowCount; i++) {
                    var data = ordMod.get(i);
                    if(data.index === index) {
                        var indexR = (data.resy * 9 + data.resx) / 2;
                        var indexD = (data.dety * 9 + data.detx) / 2;
                        houses.itemAt(indexR).arrVis = false;
                        houses.itemAt(indexD).arrVis = false;
                        ordMod.remove(i);
                        break;
                    }
                }
                var rowCount2 = riders[rid].model.count;
                for(var x = 0; x < rowCount2; x++) {
                    var dat = riders[rid].model.get(x);
                    if(dat.index === index) {
                        riders[rid].model.remove(x);
                        break;
                    }
                }
                
                tim.destroy();
            }
        }
    }

    Image {
        id: background;
        source: "image/Background.png";
        height: parent.height;
        width: height * 1.68;
        anchors.left: parent.left;
        anchors.top: parent.top;
        fillMode: Image.PreserveAspectFit;
        z: 1;
        //MouseArea{ anchors.fill: parent; onClicked: { console.log(mouseX,mouseY); } }
        
        Repeater{
            id: houses;
            model: 81;
            Image{
                property bool selected: false;
                property bool arrVis: false;
                id: house;
                source: selected? "image/H5S.png": "image/H5.png";
                x: 0;
                y: 0;
                property var ax : index % 9;
                property var ay : Math.floor(index / 9);
                scale: 0.6;
                //Drag.active: true;
                MouseArea{
                    enabled: mainWind.appending;
                    anchors.fill: parent;
                    //drag.target: parent;
                    //onReleased: console.log(parent.x, parent.y);
                    onClicked: {
                        selected = !selected;
                        if(selected){
                            if(rIndex == -1)
                                rIndex = index;
                            else
                                dIndex = index;
                        }
                        else{
                            if(dIndex != -1)
                                dIndex = -1;
                            else if(rIndex != -1 && rIndex != index)
                                dIndex = index;
                        }
                    }
                }
                Component.onCompleted: {
                    x = getPosBx(index);
                    y = getPosBy(index);
                }
                z: 4;
                Text{
                    anchors.centerIn: parent;
                    font.family: ui.font;
                    font.pixelSize: 21;
                    font.bold: true;
                    text: "(" + ax + "," + ay + ")";
                }
                Image{
                    id: houseArrow;
                    x: 7.5;
                    y: -37;
                    width: 30;
                    visible: house.arrVis;
                    fillMode: Image.PreserveAspectFit;
                    source: house.arrVis? "image/arrow.png": "";
                    /*MouseArea{
                        anchors.fill: parent;
                        onClicked: console.log(houseArrow.x, houseArrow.y)
                    }*/
                    SequentialAnimation{
                        id: arrAni;
                        loops: 999;
                        PropertyAnimation{
                            target: houseArrow;
                            duration: 700;
                            property: "y";
                            from: -37;
                            to: -51;
                            easing.type: Easing.InQuart;
                        }
                        PropertyAnimation{
                            target: houseArrow;
                            duration: 700;
                            property: "y";
                            from: -51;
                            to: -37;
                            easing.type: Easing.InQuart;
                        }
                    }
                    Component.onCompleted: arrAni.start();
                }
                
                function unSelect() {selected = false;}
            }
        }
        MTextFiled{
            id: filed1;
            text: "当前时间：" + curTime;
            anchors{
                bottom: parent.bottom;
                left: parent.left;
                margins: 20;
            }
        }
        MTextFiled{
            id: filed2;
            text: "已处完成单数：" + polledOrd;
            anchors{
                horizontalCenter: filed1.horizontalCenter;
                bottom: filed1.top;
                margins: 10;
            }
        }
        MTextFiled{
            text: "超时订单数：" + exOrd;
            id: filed3;
            anchors{
                horizontalCenter: filed1.horizontalCenter;
                bottom: filed2.top;
                margins: 10;
            }
        }
        Column{
            spacing: 5;
            anchors.right: parent.right;
            anchors.bottom: parent.bottom;
            anchors.margins: 10;
            Repeater{
                id: btGroup;
                model: 0;
                MButton{
                    id: bt;
                    property var list;
                    property bool created: false;
                    text: " Rider" + index + " ";
                    onClicked: {
                        if(!created){
                            list = view.createObject(mainWind, {});
                            list.model = riders[index].model;
                            created = true;
                        }
                        else{
                            list.close();
                            created = false;
                        }
                    }
                }
            }
        }
    }
    
    Rectangle{
        z: 1;
        anchors{
            left: background.right;
            right: parent.right;
        }
        height: parent.height;
        color: "lightblue";
        ListView {
            id: ordLst;
            anchors.top: parent.top;
            anchors.topMargin: 2;
            anchors.horizontalCenter: parent.horizontalCenter;
            width: parent.width * 0.95;
            height: parent.height * 0.6;
            clip: true;
            spacing: 10;
            model: ListModel{
                id: ordMod;
                ListElement{ index: 0; time: 0; resx: 0; resy: 0; detx: 0; dety: 0;}
            }
            delegate: Rectangle{
                color: ui.colorCarrot;
                height: 51.4;
                width: parent.width * 0.95;
                radius: 5;
                anchors.horizontalCenter: parent.horizontalCenter;
                Text {
                    id: delegateTxt;
                    text: "【订单信息】编号：" +
                          JSON.stringify(index) + " 时间：" + JSON.stringify(time) + "\n餐馆坐标：" +
                          JSON.stringify(resx) + " " + JSON.stringify(resy) + " 食客坐标：" +
                          JSON.stringify(detx) + " " + JSON.stringify(dety);  
                    anchors.centerIn: parent;
                    font.pixelSize: 15;
                    color: "black";
                }
                MouseArea {
                    anchors.fill: parent;
                }
            }
            add: Transition {
              ParallelAnimation {
                NumberAnimation { property: "opacity"; from: 0; to: 0.9; duration: 200 }
                NumberAnimation { property: "x"; from: -width; duration: 600; easing.type: Easing.OutBack }
              }
            }
            addDisplaced: Transition {
              NumberAnimation { properties: "x,y"; duration: 100 }
            }
            remove: Transition {
              id: removeTransition;
              property real targetY: 0
              ParallelAnimation {
                NumberAnimation { property: "opacity"; to: 0; duration: 400 }//easing: Easing.OutQuint}
                NumberAnimation { properties: "scale"; to: 0; duration: 400 }
                NumberAnimation { id: yAnim; property: "y"; to: removeTransition.targetY; duration: 400 }
              }
            }
            removeDisplaced: Transition {
              NumberAnimation { properties: "x,y"; duration: 400 }
            }
            Component.onCompleted: {
                ordMod.remove(0);
            }
        }
        
        MButton {
            id: balanceBt;
            text: "NULL_ThreadHavntStart";
            anchors{
                horizontalCenter: parent.horizontalCenter;
                top: ordLst.bottom;
                topMargin: 20;
            }
        }
        MProcessBar {
            id: ordProgress;
            //width: parent.width * 0.7;
            anchors{
                top: balanceBt.bottom;
                topMargin: 60;
                left: parent.left;
                leftMargin: 20;
            }
            value: mainWind.polledOrd;
            maxValue: mainWind.totalOrd;
            color: parent.color;
        }
        Text{
            id: progTxt;
            text: "当前进度：" + polledOrd + "/" + totalOrd + "  "
                  + Math.floor((polledOrd / totalOrd) * 100) + "%";
            anchors.top: ordProgress.bottom;
            anchors.topMargin: 10;
            anchors.horizontalCenter: parent.horizontalCenter;
            font: ui.font;
            
        }
        Rectangle{
            width: parent.width * 0.85;
            height: appendSwitch.height;
            radius: 10;
            anchors{
                topMargin: 20;
                top: progTxt.bottom;
                left: parent.left;
                leftMargin: 20;
            }
            color: ui.colorPeterRiver;
            MCheckBox{
                id: appendSwitch;
                x: parent.width * 0.12;
                anchors.top: parent.top;
                anchors.topMargin: 6;
                txt: "点击进入下单模式";
            }
        }
    }
    
    Component{
        id: view;
        OrderList{ }
    }
    MediaPlayer{
        id: bgm;
        loops: Audio.Infinite;
        source: "sound/LetGo.mp3";
        Component.onCompleted: bgm.play();
    }
    Component{
        id: ordSnd;
        Item{
            id: ordSound;
            MediaPlayer{
                source: "sound/order.mp3";
                autoPlay: true;
            }
            Timer{
                id: sndTim;
                interval: 4000;
                repeat: false;
                onTriggered: {
                    delete ordSound;
                }
            }
            Component.onCompleted: sndTim.start();
        }
    }
    
    function getPosRx(x, y){
        return 602 - (y - x) * 35.2;
    }
    function getPosRy(x, y){
        return 7 + 20.8 * (x + y);
    }

    function changeBalance(value){
        balanceText = qsTr(value);
    }
    
    function getPosBx(index){
        var x = index % 9;
        var y = Math.floor(index / 9);
        return 577 + ((x - y) * 70.5);
    }
    function getPosBy(index){
        var x = index % 9;
        var y = Math.floor(index / 9);
        return -15 + ((y + x) * 40.5);
    }
    /*
    function init(){
        myDB = LocalStorage.openDatabaseSync("Pos", "1.0", "RiderPos", 100000);
        myDB.transaction(function(tx){
            tx.executeSql('CREATE TABLE IF NOT EXISTS RiderPos(x, y)');
        })
    }
    function setPot(x, y){
        myDB.transaction(function(tx){
            tx.executeSql('INSERT INTO RiderPos VALUES(?,?)', [x, y])
        })
    }*/
}