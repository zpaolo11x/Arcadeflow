#version 120
uniform sampler2D texture;
uniform float bias;

uniform vec2 size;

void main()
{   

   vec4 t0 = 0.26*texture2D(texture, gl_TexCoord[0].xy,bias);
   t0 += 0.185*texture2D(texture, gl_TexCoord[1].xy,bias);
   t0 += 0.185*texture2D(texture, gl_TexCoord[1].zw,bias);
   t0 += 0.185*texture2D(texture, gl_TexCoord[2].xy,bias);
   t0 += 0.185*texture2D(texture, gl_TexCoord[2].zw,bias);


   gl_FragColor = gl_Color*t0;

}