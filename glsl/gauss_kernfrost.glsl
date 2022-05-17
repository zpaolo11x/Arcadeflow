uniform sampler2D texture;

uniform vec2 offsetfactor;
/*

0 0.0330369
1.4976 0.065548
3.4944 0.063487
5.4912 0.0599391
7.488 0.0551615
9.48481 0.0494836
11.4816 0.0432701
13.4784 0.0368819
15.4752 0.0306436
17.472 0.024818
19.4688 0.0195926
21.4657 0.0150772
23.4625 0.0113096
25.4593 0.00826938

*/

void main(void) {

   vec2 uv = gl_TexCoord[0].xy;

   vec4 colorout = texture2D(texture, uv) * 0.0330369;
   colorout += texture2D(texture, (uv + 1.4976 * offsetfactor)) * 0.065548;
   colorout += texture2D(texture, (uv - 1.4976 * offsetfactor)) * 0.065548;

   colorout += texture2D(texture, (uv + 3.4944 * offsetfactor)) * 0.063487;
   colorout += texture2D(texture, (uv - 3.4944 * offsetfactor)) * 0.063487;
   
   colorout += texture2D(texture, (uv + 5.4912 * offsetfactor)) * 0.0599391;
   colorout += texture2D(texture, (uv - 5.4912 * offsetfactor)) * 0.0599391;
   
   colorout += texture2D(texture, (uv + 7.488 * offsetfactor)) * 0.0551615;
   colorout += texture2D(texture, (uv - 7.488 * offsetfactor)) * 0.0551615;

   colorout += texture2D(texture, (uv + 9.48481 * offsetfactor)) * 0.0494836;
   colorout += texture2D(texture, (uv - 9.48481 * offsetfactor)) * 0.0494836;
   
   colorout += texture2D(texture, (uv + 11.4816 * offsetfactor)) * 0.0432701;
   colorout += texture2D(texture, (uv - 11.4816 * offsetfactor)) * 0.0432701;
      
   colorout += texture2D(texture, (uv + 13.4784 * offsetfactor)) * 0.0368819;
   colorout += texture2D(texture, (uv - 13.4784 * offsetfactor)) * 0.0368819;

   colorout += texture2D(texture, (uv + 15.4752 * offsetfactor)) * 0.0306436;
   colorout += texture2D(texture, (uv - 15.4752 * offsetfactor)) * 0.0306436;

   colorout += texture2D(texture, (uv + 17.472 * offsetfactor)) * 0.024818;
   colorout += texture2D(texture, (uv - 17.472 * offsetfactor)) * 0.024818;

   colorout += texture2D(texture, (uv + 19.4688 * offsetfactor)) * 0.0195926;
   colorout += texture2D(texture, (uv - 19.4688 * offsetfactor)) * 0.0195926;
      
   colorout += texture2D(texture, (uv + 21.4657 * offsetfactor)) * 0.0150772;
   colorout += texture2D(texture, (uv - 21.4657 * offsetfactor)) * 0.0150772;
      
   colorout += texture2D(texture, (uv + 23.4625 * offsetfactor)) * 0.0113096;
   colorout += texture2D(texture, (uv - 23.4625 * offsetfactor)) * 0.0113096;

   colorout += texture2D(texture, (uv + 25.4593 * offsetfactor)) * 0.00826938;
   colorout += texture2D(texture, (uv - 25.4593 * offsetfactor)) * 0.00826938;

   //gl_FragColor = gl_Color*colorout;
    gl_FragColor = vec4(gl_Color.rgb*colorout.rgb,gl_Color.a*colorout.a);

}