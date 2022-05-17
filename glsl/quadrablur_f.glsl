#version 120
uniform sampler2D texture;

uniform vec2 size;

void main()
{   

   vec4 t0 = 0.26*texture2D(texture, gl_TexCoord[0].xy);
   t0 += 0.185*texture2D(texture, gl_TexCoord[1].xy);
   t0 += 0.185*texture2D(texture, gl_TexCoord[1].zw);
   t0 += 0.185*texture2D(texture, gl_TexCoord[2].xy);
   t0 += 0.185*texture2D(texture, gl_TexCoord[2].zw);


   gl_FragColor = gl_Color*t0;

}