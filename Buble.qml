import QtQuick 2.12

Image {
    id: buble;
    source: "image/getR.png";
    anchors.bottom: parent.top;
    anchors.bottomMargin: -3;
    anchors.left: parent.left;
    anchors.leftMargin: 2;
    width: 0;
    height: 0;
    z: 5;
    visible: true;
    ParallelAnimation{
        id: spread;
        PropertyAnimation{
            target: buble;
            property: "width";
            from: 0;
            to: 97;
            duration: 300;
            easing.type: Easing.InOutQuart;
        }
        PropertyAnimation{
            target: buble;
            property: "height";
            from: 0;
            to: 97;
            duration: 300;
            easing.type: Easing.InOutQuart;
        }
    }
    ParallelAnimation{
        id: close;
        PropertyAnimation{
            target: buble;
            property: "width";
            from: 97;
            to: 0;
            duration: 300;
            easing.type: Easing.InOutQuart;
        }
        PropertyAnimation{
            target: buble;
            property: "height";
            from: 97;
            to: 0;
            duration: 300;
            easing.type: Easing.InOutQuart;
        }
    }
    function spreadAni(){ spread.start() }
    function closeAni(){ close.start() }
}
