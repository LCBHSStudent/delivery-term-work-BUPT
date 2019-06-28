import QtQuick 2.12

AnimatedImage {
    id: ridImg;
    property var curX: 8;
    property var curY: 9;
    property var riderNum: 0;
    property alias model: mod;
    ListModel{
        id: mod;
        ListElement{ index: 0; time: 0; resx: 0; resy: 0; detx: 0; dety: 0;}
    }
    
    x: -514;
    y: -114;
    z: 3;
    source: "image/stand.gif";
    enabled: false;
    Timer{
        id: rtm;
        running: false;
        interval: 1002;
        repeat: false;
        onTriggered: {
            runAnima2.star();
        }
    }
    function showBuble(){
        bub.spreadAni();
        bubtim.start();
    }
    function changeBubleType(str){
        bub.source = str;
        return;
    }
    Buble {id: bub;}
    Timer{
        id: bubtim;
        interval: 2000;
        running: false;
        repeat: false;
        onTriggered: bub.closeAni();
    }
    
    SequentialAnimation{
        id: runAnimaSE;
        onStarted: {
            runAnima.star();
            rtm.start();
        }
        onFinished: {
            fin();
        }
        ParallelAnimation{
            id :runAnima;
            running: false;
            
            PropertyAnimation{
                id :runAnimaX;
                target: ridImg;
                property: "x";
                duration: 1000;
                to: 0;
                running: false;
            }
            PropertyAnimation{
                id :runAnimaY;
                target: ridImg;
                property: "y";
                duration: 1000;
                to: 0;
                running: false;
            }
            
            function star() {
                var px = runAnimaX.to > ridImg.x;
                var py = runAnimaY.to > ridImg.y;
                if(px){
                    if(py){
                        ridImg.source = "image/run_.gif";
                    }
                    else{
                        ridImg.source = "image/run_90_.gif";
                    }
                }
                else{
                    if(py){
                        ridImg.source = "image/run.gif";
                    }
                    else{
                        ridImg.source = "image/run_90.gif";
                    }
                }
            }
        }
        ParallelAnimation{
            id :runAnima2;
            running: false;
            PropertyAnimation{
                id :runAnimaX2;
                target: ridImg;
                property: "x";
                duration: 1000;
                to: 0;
                running: false;
            }
            PropertyAnimation{
                id :runAnimaY2;
                target: ridImg;
                property: "y";
                duration: 1000;
                to: 0;
                running: false;
                onRunningChanged: running? runAnima2.star(): runAnima2.fin();
            }
            
            function star() {
                var px = runAnimaX2.to > ridImg.x;
                var py = runAnimaY2.to > ridImg.y;
                if(px){
                    if(py){
                        ridImg.source = "image/run_.gif";
                    }
                    else{
                        ridImg.source = "image/run_90_.gif";
                    }
                }
                else{
                    if(py){
                        ridImg.source = "image/run.gif";
                    }
                    else{
                        ridImg.source = "image/run_90.gif";
                    }
                }
            }
        }
    }
    function fin() {
        if(source == "qrc:/image/run.gif"){
            source = "image/stand.gif";
            return;
        }
        if(source == "qrc:/image/run_90.gif"){
            source = "image/stand_90.gif";
            return;
        }
        if(source == "qrc:/image/run_.gif"){
            source = "image/stand_.gif";
            return;
        }
        if(source == "qrc:/image/run_90_.gif"){
            source = "image/stand_90_.gif";
            return;
        }
    }
    Component.onCompleted: {
        x = mainWind.getPosRx(curX, curY);
        y = mainWind.getPosRy(curX, curY);
        mod.remove(0);
    }
    //onXChanged: {
    //    console.log(x);
    //    console.log(y);
    //}
    function riderMove(x, y) {
        if(x - curX === 2) {
            runAnimaX.to = getPosRx(x - 1, y);
            runAnimaY.to = getPosRy(x - 1, y);
            runAnimaX2.to = getPosRx(x, y);
            runAnimaY2.to = getPosRy(x, y);
            runAnimaSE.start();
            curX = x;
            curY = y;
            
        }
        if(x - curX === -2) {
            runAnimaX.to = getPosRx(x + 1, y);
            runAnimaY.to = getPosRy(x + 1, y);
            runAnimaX2.to = getPosRx(x, y);
            runAnimaY2.to = getPosRy(x, y);
            runAnimaSE.start();
            curX = x;
            curY = y;
        }
        if(Math.abs(x - curX) === 1) {
            if(x % 2 === 0){
                runAnimaX.to = getPosRx(curX, y);
                runAnimaY.to = getPosRy(curX, y);
                runAnimaX2.to = getPosRx(x, y);
                runAnimaY2.to = getPosRy(x, y);
                runAnimaSE.start();
                curX = x;
                curY = y;
            }
            else{
                runAnimaX.to = getPosRx(x, curY);
                runAnimaY.to = getPosRy(x, curY);
                runAnimaX2.to = getPosRx(x, y);
                runAnimaY2.to = getPosRy(x, y);
                runAnimaSE.start();
                curX = x;
                curY = y;
            }    
        }
        if(x - curX === 0) {
            if(y - curY === 2) {
                runAnimaX.to = getPosRx(x, y - 1);
                runAnimaY.to = getPosRy(x, y - 1);
                runAnimaX2.to = getPosRx(x, y);
                runAnimaY2.to = getPosRy(x, y);
                runAnimaSE.start();
                curX = x;
                curY = y;
            }
            if(y - curY === -2) {
                runAnimaX.to = getPosRx(x, y + 1);
                runAnimaY.to = getPosRy(x, y + 1);
                runAnimaX2.to = getPosRx(x, y);
                runAnimaY2.to = getPosRy(x, y);
                runAnimaSE.start();
                curX = x;
                curY = y;
            }
        }
    }
    Image{
        id: countLabel;
        source: "image/count.png";
        anchors{
            right: ridImg.left;
            top: parent.top;
            rightMargin: -60;
            topMargin: -22;
        }
        scale: 0.4;
    }
    Text {
        text: ridImg.riderNum;
        anchors{
            top: countLabel.top;
            topMargin: 32;
            leftMargin: 63.5;
            left: countLabel.left;
        }
        color: ui.colorBelizeHole;
        font{
            family: ui.font;
            pixelSize: 20;
        }
    }
}