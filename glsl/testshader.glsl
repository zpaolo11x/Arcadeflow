uniform sampler2D image;

void main(void) {
   float offset[5];
   offset [0] = 0.0;
   offset [1] = 1.0;
   offset [2] = 2.0;
   offset [3] = 3.0;
   offset [4] = 4.0;

   float weight[5];
   weight [0] = 0.2270270270;
   weight [1] = 0.1945945946;
   weight [2] = 0.1216216216; 
   weight [3] = 0.0540540541; 
   weight [4] = 0.0162162162;

   vec4 FragmentColor = texture2D(image, vec2(gl_FragCoord) / 10.0) * weight[0];

   for (int i=1; i<5; i++) {
        FragmentColor += texture2D(image, (vec2(gl_FragCoord) + vec2(0.0, offset[i])) / 10.0)* weight[i];
        FragmentColor += texture2D(image, (vec2(gl_FragCoord) - vec2(0.0, offset[i])) / 10.0)* weight[i];
    }
   gl_FragColor = FragmentColor;

}