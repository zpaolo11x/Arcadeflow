#version 120
uniform sampler2D texture;
uniform float bias;

uniform vec2 size;

void main()
{   

   vec4 t0 = 0.1*texture2D(texture, gl_TexCoord[1].xy,bias);
       t0 += 0.1*texture2D(texture, gl_TexCoord[1].zw,bias);
       t0 += 0.1*texture2D(texture, gl_TexCoord[2].xy,bias);
       t0 += 0.1*texture2D(texture, gl_TexCoord[2].zw,bias);
       t0 += 0.15*texture2D(texture, gl_TexCoord[3].xy,bias);
       t0 += 0.15*texture2D(texture, gl_TexCoord[3].zw,bias);
       t0 += 0.15*texture2D(texture, gl_TexCoord[4].xy,bias);
       t0 += 0.15*texture2D(texture, gl_TexCoord[4].zw,bias);

   gl_FragColor = gl_Color*t0;

}