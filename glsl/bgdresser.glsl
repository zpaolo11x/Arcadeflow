#version 120
uniform sampler2D texture;
uniform float bgmix;
uniform float bgcol;


void main()
{   

   vec2 uv = gl_TexCoord[0].xy;
   vec4 tc = texture2D(texture, uv);

   gl_FragColor = vec4(mix(tc.rgb,vec3(bgcol),bgmix), gl_Color.a*tc.a);
 

}