#version 120
uniform sampler2D texture;
uniform sampler2D texturecolor;
uniform vec2 limits;

void main()
{   

   vec2 uv = gl_TexCoord[0].xy;
   uv.y = 1.0 - uv.y;
   vec4 tc = texture2D(texturecolor, uv);

   float scaler1 = smoothstep(limits.y,limits.x,uv.y);

   // vec4 tcOUT = vec4(mix(t0.rgb , tc.rgb , (enabled ? scaler1 : 0.0 )), 1.0);
	vec4 tcOUT = vec4(tc.rgb, 1.0-scaler1);


   gl_FragColor = gl_Color*tcOUT;

   //gl_FragColor.xyz *= gl_FragColor.w;
  //gl_FragColor = vec4(tc.r,0.0,0.0 , 0.0);

}