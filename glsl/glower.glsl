#version 120
uniform sampler2D texture;

void main()
{   

   vec2 uv = gl_TexCoord[0].xy;
   vec4 tc = texture2D(texture, uv);

   //vec3 scaler1 = smoothstep(0.0,0.5,vec3(1.0)-tc.rgb);

	vec4 tcOUT = vec4(tc.rgb, 1.0-(1.0-tc.a)*(1.0-tc.a)*(1.0-tc.a)*(1.0-tc.a)*(1.0-tc.a)*(1.0-tc.a)*(1.0-tc.a));


   //gl_FragColor = tcOUT;

   //gl_FragColor.xyz *= gl_FragColor.w;
  gl_FragColor = vec4(tcOUT.rgb,gl_Color.a*tcOUT.a);

}