uniform sampler2D texture;
uniform vec2 offsetFactor;
uniform int lobes;
uniform float size;

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

void main(void) {
   vec2 offset[10];
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

   float weight[10];
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

   vec4 FragmentColor = texture2D(texture, vec2(gl_FragCoord) / size) * weight[0];

   for (int i=1; i<10; i++) {
        FragmentColor += texture2D(texture, (vec2(gl_FragCoord) + offset[i])/size) * weight[i];
        FragmentColor += texture2D(texture, (vec2(gl_FragCoord) - offset[i])/size) * weight[i];
    }
   gl_FragColor = gl_Color*FragmentColor;

}