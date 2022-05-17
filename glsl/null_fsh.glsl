#version 120
uniform sampler2D texture;

void main()
{   

   vec2 uv = gl_TexCoord[0].xy;
   vec4 col = texture2D(texture, uv.xy);
  
   gl_FragColor = vec4(col.rgb , gl_Color.a*col.a);

}