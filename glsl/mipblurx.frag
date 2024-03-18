#version 120

uniform sampler2D texture;
uniform sampler2D source;
uniform vec2 blur = vec2(0.0, 6.0);

void main() {
    vec2 uv = gl_TexCoord[0].xy;
    //uv.y = 1.0 - uv.y;
    gl_FragColor = gl_Color * texture2D(source, uv, mix(blur.s, blur.t, uv.y));
}