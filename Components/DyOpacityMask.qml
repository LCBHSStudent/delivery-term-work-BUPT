import QtQuick.Controls 2.5
import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
    property alias source: source.source
    property alias mask: mask.source
    property real windowWidht
    property real windowHeight
    property real maskWidth
    property real maskHeight
    property real maskX
    property real maskY
    property alias angle: animation.angle
    property alias originX:animation.origin.x
    property alias originY:animation.origin.y
    
    Image {
        id: source
        visible: false
    }
    
    Image {
        id: mask
        visible: false
    }
    
    ShaderEffect {
        id: shader
        width: parent.width
        height: parent.height
        blending: true
    
        property variant src: source
        property variant mask: mask
        property real widthScale: windowWidht/(maskWidth*1.0) //1920/760.0
        property real heightScale: windowHeight/(maskHeight*1.0) //720/570.0
        property real xOffset: maskX/(maskWidth*1.0) //95/760.0
        property real yOffset: maskY/(maskHeight*1.0) //88/570.0
        vertexShader: "
        uniform highp mat4 qt_Matrix;
        attribute highp vec4 qt_Vertex;
        attribute highp vec2 qt_MultiTexCoord0;
        varying highp vec2 coord;
        varying highp vec2 maskCoord;
        uniform float widthScale;
        uniform float heightScale;
        uniform float xOffset;
        uniform float yOffset;
        void main() {
            coord = qt_MultiTexCoord0;
            gl_Position = qt_Matrix * qt_Vertex;
            maskCoord.x = (gl_Position[0] + 1.0)/2.0*widthScale - xOffset;
            maskCoord.y = (1.0 - gl_Position[1])/2.0*heightScale - yOffset;
        }"
        fragmentShader: "
        varying highp vec2 coord;
        varying highp vec2 maskCoord;
        uniform sampler2D src;
        uniform sampler2D mask;
        void main() {
            lowp float alpha = texture2D(mask, maskCoord).a;
            lowp vec4 tex = vec4(0, 0, 0, 0);
            if(alpha > 0.00)
                tex = texture2D(src, coord);
            gl_FragColor = tex;
        }"
        transform: Rotation {
            id: animation
            angle: 0
        }
    }

}