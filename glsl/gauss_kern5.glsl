uniform sampler2D texture;
uniform vec2 w0;
uniform vec2 u0;
uniform vec2 offsetfactor;

void main(void) {

   vec2 uv = gl_TexCoord[0].xy;

   vec4 colorout = texture2D(texture, uv) *w0.x;
   colorout += texture2D(texture, (uv + u0.y * offsetfactor)) * w0.y;
   colorout += texture2D(texture, (uv - u0.y * offsetfactor)) * w0.y;

   //gl_FragColor = gl_Color*colorout;
    gl_FragColor = vec4(gl_Color.rgb*colorout.rgb,gl_Color.a*colorout.a);

}