#version 120
uniform sampler2D texture;
uniform sampler2D texture2;
uniform vec2 limits;
uniform bool enabled;
uniform bool remap;
uniform vec3 color1;
uniform vec3 color2;

void main()
{   

   vec2 uv = gl_TexCoord[0].xy;

   vec2 uv2 = vec2(uv.x,1.0-uv.y);

   vec4 tc = texture2D(texture2, uv2);
   vec4 t0 = texture2D(texture, uv);


   float scaler1 = 1.0 - smoothstep(limits.x,limits.y,uv.y);
   scaler1 = 1.0 - smoothstep(0.5,0.5,uv.x); //TEST87

   vec4 tcOUT = vec4(mix(t0.rgb , tc.rgb , (enabled ? scaler1 : 0.0 )), 1.0);

   

   if (remap) {
      tcOUT.rgb = vec3(mix(color1.rgb,color2.rgb,tcOUT.x));
   }
   
   gl_FragColor = tcOUT;

 //  gl_FragColor = vec4(tc.rgb , 1.0;

}