uniform sampler2D texture;
uniform vec2 offsetFactor;
uniform int lobes;
uniform vec2 offstep;
uniform vec2 sizer;

uniform vec2 o01;
uniform vec2 o02;
uniform vec2 o03;
uniform vec2 o04;
uniform vec2 o05;
uniform vec2 o06;
uniform vec2 o07;
uniform vec2 o08;
uniform vec2 o09;
uniform vec2 o10;
uniform vec2 o11;
uniform vec2 o12;
uniform vec2 o13;
uniform vec2 o14;
uniform vec2 o15;

uniform float w01;
uniform float w02;
uniform float w03;
uniform float w04;
uniform float w05;
uniform float w06;
uniform float w07;
uniform float w08;
uniform float w09;
uniform float w10;
uniform float w11;
uniform float w12;
uniform float w13;
uniform float w14;
uniform float w15;

void main(void) {
   vec2 offset[15];
   offset [0] = o01;
   offset [1] = o02;
   offset [2] = o03;
   offset [3] = o04;
   offset [4] = o05;
   offset [5] = o06;
   offset [6] = o07;
   offset [7] = o08;
   offset [8] = o09;
   offset [9] = o10;
   offset [10] = o11;
   offset [11] = o12;
   offset [12] = o13;
   offset [13] = o14;
   offset [14] = o15;

   float weight[15];
   weight [0] = w01;
   weight [1] = w02;
   weight [2] = w03;
   weight [3] = w04;
   weight [4] = w05;
   weight [5] = w06;
   weight [6] = w07;
   weight [7] = w08;
   weight [8] = w09;
   weight [9] = w10;
   weight [10] = w11;
   weight [11] = w12;
   weight [12] = w13;
   weight [13] = w14;
   weight [14] = w15;

   vec2 uv = gl_TexCoord[0].xy;

   vec4 colorout = texture2D(texture, uv) * weight[0];

   for (int i=1; i<15; i++) {
        colorout += texture2D(texture, (uv + offset[i])) * weight[i];
        colorout += texture2D(texture, (uv - offset[i])) * weight[i];
    }
   //gl_FragColor = gl_Color*colorout;
   gl_FragColor = vec4(gl_Color.rgb*colorout.rgb,gl_Color.a*colorout.a);

}