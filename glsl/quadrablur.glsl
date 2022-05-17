#version 120
uniform sampler2D texture;

uniform vec2 size;

void main()
{   

   vec2 uv = gl_TexCoord[0].xy;
   //uv+=vec2(0.5/size.x,0.5/size.y);
   vec2 o1 = 0.5/size;

   vec4 t0 = 0.26*texture2D(texture, uv);
   t0 += 0.185*texture2D(texture, (uv + vec2(o1.x,o1.y)));
   t0 += 0.185*texture2D(texture, (uv + vec2(o1.x,-o1.y)));
   t0 += 0.185*texture2D(texture, (uv + vec2(-o1.x,o1.y)));
   t0 += 0.185*texture2D(texture, (uv + vec2(-o1.x,-o1.y)));


   //float scaler1 = smoothstep(0.2,0.75,uv.y);

   //ALPHA GRAD 
 //  t0.a = 0.5+0.5*uv.y;
   //gl_FragColor = gl_Color*t0;
   //gl_FragColor = gl_Color*t0;

   //gl_FragColor.xyz *= gl_FragColor.w;

   	//vec4 tcOUT = vec4(t0.rgb, scaler1);


   gl_FragColor = gl_Color*t0;

   //gl_FragColor.xyz *= gl_FragColor.w;
}