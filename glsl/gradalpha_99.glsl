#version 120
uniform sampler2D texture;
uniform vec2 limits;

void main()
{   

   vec2 uv = gl_TexCoord[0].xy;

   vec4 tc = texture2D(texture, uv);

   float scaler1 = smoothstep(limits.x,limits.y,uv.y);

   // vec4 tcOUT = vec4(mix(t0.rgb , tc.rgb , (enabled ? scaler1 : 0.0 )), 1.0);
	vec4 tcOUT = vec4(tc.rgb, scaler1);


   gl_FragColor = gl_Color*tcOUT;

   gl_FragColor.xyz *= gl_FragColor.w;
  //gl_FragColor = vec4(tc.r,0.0,0.0 , 0.0);

}