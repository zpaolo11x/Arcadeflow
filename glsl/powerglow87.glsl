#version 120

uniform sampler2D texture;
uniform sampler2D textureglow;
uniform vec2 limits;
//uniform bool cropsnap;
//uniform bool enabled;
uniform vec4 adapter;
uniform vec3 glow;

vec2 rampzero(vec2 x, vec2 edge0, vec2 edge1)
{
   return ((-edge0 + clamp(x,edge0,edge1))/(edge1-edge0));
}

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main()
{   

   vec2 uv_glowshape = vec2(0.0);
   vec2 uv_0 = vec2(0,0);
   vec2 uv_gradshape = vec2(0,0);

   uv_0 = gl_TexCoord[0].xy;

   //TEST97 if (enabled) {

/*
      uv_glowshape = vec2(
         rampzero(uv_0.x,glow.x,glow.x + glow.z) * (100.0 + 35.0)/640.0 + rampzero(uv_0.x,glow.x + glow.z,1.0-glow.x-glow.z) * (440.0 - 2.0*35.0)/640.0  + rampzero(uv_0.x,1.0 - glow.x - glow.z,1.0 - glow.x) * (100.0 + 35.0)/640.0,
         rampzero(uv_0.y,glow.y,glow.y + glow.z) * (100.0 + 35.0)/640.0 + rampzero(uv_0.y,glow.y + glow.z,1.0-glow.y-glow.z) * (440.0 - 2.0*35.0)/640.0 + rampzero(uv_0.y,1.0 - glow.y - glow.z,1.0 - glow.y) * (100.0 + 35.0)/640.0 
      ); 
*/
      uv_glowshape = rampzero(uv_0,glow.xy,glow.xy + glow.z) * 0.211 
                  + rampzero(uv_0,glow.xy + glow.z,1.0 - glow.xy - glow.z) * 0.578 
                  + rampzero(uv_0,1.0 - glow.xy - glow.z,1.0 - glow.xy) * 0.211 ;

      uv_gradshape = adapter.xy + adapter.zw * uv_0; 
      
      vec4 t0 = texture2D(textureglow, uv_glowshape);

      vec4 tc = texture2D(texture, uv_gradshape);

      vec3 hue = rgb2hsv (tc.rgb);

      vec3 hue1 = vec3(1.0) - hue;

      vec3 tch5 = hsv2rgb (vec3(hue.x , (1.0 - hue1.z*hue1.z*hue1.z)*(1.0 - hue1.y*hue1.y) * (1.0 - t0.r) , 1.0));

      gl_FragColor = vec4(tch5 , gl_Color.a*(t0.r));
      
      //REMOVE JUST FOR TEST
      //gl_FragColor = vec4(tc.rgb,1.0);
      
      //gl_FragColor = vec4(tc.rgb, t0.r > 0.0?1.0:0.0);
      
   //TEST97 }
   //TEST97 else {
   //TEST97    gl_FragColor = (gl_Color.rgba);
   //TEST97 }

}