import QtQuick 2.12

QtObject{
    /* active color mean a object was pressed, clicked, focused ....*/
    property color activeColor;

    /* inactiveColor and defaultColor may be same */
    property color inactiveColor;
    property color defaultColor;

    readonly property color disableColor:"#bdc3c7";
    /* one active state may  have 4 levels... */
    /* other color .... */
}