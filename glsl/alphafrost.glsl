#version 120
uniform sampler2D texture;
uniform float alpha;

void main()
{   

   vec2 uv = gl_TexCoord[0].xy;
   vec4 tc = texture2D(texture, uv);
   
   vec4 tcOUT = vec4(tc.rgb , mix(gl_Color.a , gl_Color.a*(0.35+0.65*(smoothstep(0.8,1.0,uv.x)+(1.0-smoothstep(0.2,0.6,uv.x)))) , alpha));

   gl_FragColor = tcOUT;

   gl_FragColor.rgb *= gl_FragColor.a;
    
}