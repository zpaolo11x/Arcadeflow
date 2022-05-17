#version 120
uniform sampler2D texture;
uniform float bias;

uniform vec2 size;

float uvinpic(vec2 uvin)
{
    if ((uvin.x < 0.0) || (uvin.x > 1.0) || (uvin.y<0.0) || (uvin.y>1.0)) return (0.0);
    return 1.0;
}

void main()
{   
    vec4 tr = vec4(0.0);
    vec2 uv = gl_TexCoord[0].xy;
    vec4 t0 = uvinpic(uv) * texture2D(texture, uv) + (1.0-uvinpic(uv))*tr;
   /*
   vec4 t0 = 0.1*texture2D(texture, gl_TexCoord[1].xy,bias);
       t0 += 0.1*texture2D(texture, gl_TexCoord[1].zw,bias);
       t0 += 0.1*texture2D(texture, gl_TexCoord[2].xy,bias);
       t0 += 0.1*texture2D(texture, gl_TexCoord[2].zw,bias);
       t0 += 0.15*texture2D(texture, gl_TexCoord[3].xy,bias);
       t0 += 0.15*texture2D(texture, gl_TexCoord[3].zw,bias);
       t0 += 0.15*texture2D(texture, gl_TexCoord[4].xy,bias);
       t0 += 0.15*texture2D(texture, gl_TexCoord[4].zw,bias);
*/
   gl_FragColor = gl_Color*t0;

}