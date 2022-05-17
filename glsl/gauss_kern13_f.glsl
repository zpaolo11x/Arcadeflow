#version 120

uniform sampler2D texture;
uniform vec4 w0;
uniform vec4 u0;
uniform vec2 offsetfactor;

void main(void) {

   vec4 colorout = texture2D(texture, gl_TexCoord[0].xy)* w0.x;
   colorout += texture2D(texture, gl_TexCoord[1].xy) * w0.y;
   colorout += texture2D(texture, gl_TexCoord[1].zw) * w0.y;
   colorout += texture2D(texture, gl_TexCoord[2].xy) * w0.z;
   colorout += texture2D(texture, gl_TexCoord[2].zw) * w0.z;
   colorout += texture2D(texture, gl_TexCoord[3].xy) * w0.w;
   colorout += texture2D(texture, gl_TexCoord[3].zw) * w0.w;


   //gl_FragColor = gl_Color*colorout;
   gl_FragColor = vec4(gl_Color.rgb*colorout.rgb,gl_Color.a*colorout.a);

}