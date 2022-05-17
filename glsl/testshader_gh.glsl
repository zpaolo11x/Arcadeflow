uniform sampler2D texture;
uniform float size;

void main(void) {
   float offset[5];
   offset [0] = 0.0;
   offset [1] = 1.0;
   offset [2] = 2.0;
   offset [3] = 3.0;
   offset [4] = 4.0;

   float weight[5];
   weight [0] = 0.294118;
   weight [1] = 0.235294;
   weight [2] = 0.117647; 
   weight [3] = 0.0540540541; 
   weight [4] = 0.0162162162;

   vec4 FragmentColor = texture2D(texture, vec2(gl_FragCoord) / size) * weight[0];

   for (int i=1; i<3; i++) {
        FragmentColor += texture2D(texture, (vec2(gl_FragCoord) + vec2(offset[i], 0.0)) / size)* weight[i];
        FragmentColor += texture2D(texture, (vec2(gl_FragCoord) - vec2(offset[i], 0.0)) / size)* weight[i];
    }
   gl_FragColor = gl_Color*FragmentColor;

}