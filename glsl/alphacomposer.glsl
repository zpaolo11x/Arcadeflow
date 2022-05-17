#version 120
uniform sampler2D texture;
uniform sampler2D texturecolor;
uniform float ydelta;
uniform float yscale;

void main()
{   

   vec2 uv = gl_TexCoord[0].xy;

   vec2 uv2 = vec2(uv.x,1.0-(uv.y*yscale + ydelta));

   vec4 ta = texture2D(texture, uv);
   vec4 tc = texture2D(texturecolor, uv2);
   
   vec4 tcOUT = vec4(tc.rgb , gl_Color.a*(0.35+0.65*ta.a));

   gl_FragColor = tcOUT;

   //gl_FragColor = vec4(tc.rgb ,  1.0);

}