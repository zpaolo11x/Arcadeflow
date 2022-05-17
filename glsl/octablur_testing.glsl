#version 120
uniform sampler2D texture;

uniform vec2 size;

void main()
{   

   vec2 uv = gl_TexCoord[0].xy;
   //uv+=vec2(0.5/size.x,0.5/size.y);
   float o1 = 1.5;
   float o2 = 0.5;

   float w0 = 0.0;
   float w1 = (1.0 - w0) * 0.4 / 4.0;
   float w2 = (1.0 - w0 - w1 * 4.0)/4.0;

   vec4 t0 = w0*texture2D(texture, uv);
   t0 += w1*texture2D(texture, (uv + vec2(o1/size.x,0.0)));
   t0 += w1*texture2D(texture, (uv + vec2(-o1/size.x,0.0)));
   t0 += w1*texture2D(texture, (uv + vec2(0.0,o1/size.y)));
   t0 += w1*texture2D(texture, (uv + vec2(0.0,-o1/size.y)));
   t0 += w2*texture2D(texture, (uv + vec2(o2/size.x,-o2/size.y)));
   t0 += w2*texture2D(texture, (uv + vec2(o2/size.x,o2/size.y)));
   t0 += w2*texture2D(texture, (uv + vec2(-o2/size.x,o2/size.y)));
   t0 += w2*texture2D(texture, (uv + vec2(-o2/size.x,-o2/size.y)));

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