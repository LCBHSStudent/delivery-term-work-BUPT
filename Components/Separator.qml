import QtQuick 2.12

Rectangle {
    id:separator;
    property int orientation : Qt.Vertical // Qt.Horizontal
    property int length : 100;
    property int separatorWidth : 1

    onOrientationChanged: __fix();
    onLengthChanged: __fix();
    onSeparatorWidthChanged: __fix();

    // private function
    function __fix(){
        switch(orientation){
        case Qt.Vertical:  // 垂直的
            height = length;
            width = separatorWidth;
            break;
        case Qt.Horizontal: // 水平的
            width = length;
            height = separatorWidth;
            break;
        default:
            height = length;
            width = separatorWidth;
            break;
        }
    }
    Component.onCompleted: __fix();
}