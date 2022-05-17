#version 120
uniform sampler2D texture;
uniform sampler2D textureglow;
uniform vec2 limits;
uniform float orient;
uniform bool cropsnap;
uniform bool enabled;

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

   vec2 uv = vec2(0.0);
   vec2 uv2 = vec2(0,0);
   vec2 uv3 = vec2(0,0);

   uv2 = gl_TexCoord[0].xy;

   if (enabled) {

//TEST62

         if (orient == 1.0){
            uv = uv2.yx;   
            uv3 = vec2(0.0 , 1.0 + 0.115384615384615) + vec2(1.0 , -1.23076923076923) * uv2; 

         } 
         else if (orient == -1.0){
            uv = uv2.xy;   
            uv3 = vec2(-0.115384615384615 , 1.0) + vec2(1.23076923076923 , -1.0) * uv2; 
         }
         else {
            uv = uv2.xy;   
            uv3 =  vec2(0.0 , 1.0) + vec2(1.0 , -1.0) * uv2;; 
         }
            //uv = uv2.xy;
            //uv3 = vec2(0.0 , 1.0) + vec2(1.0 , -1.0) * uv2;
/*
      if (!cropsnap) {
         if (vertical){
            uv = uv2.xy;
            uv3 = vec2(-0.5/6.0 , 1.0) + vec2(4.0/3.5 , -1.0) * uv2;
         }
         else {
            uv = uv2.yx;   
            uv3 = vec2(0.0 , +0.5/6.0 +1.0) + vec2(1.0 , -4.0/3.5) * uv2; 
         }
      }

      else {
         if (vertical){
            uv = uv2.xy;
            uv3 = vec2 (0.0,1.0/8.0+3.0/4.0) + vec2(1.0,-3.0/4.0)*uv2;

         }
         else {
            uv = uv2.yx;      
            uv3 = vec2 (1.0/8.0,1.0) + vec2(3.0/4.0,-1.0)*uv2;

         }
      }

*/
      vec4 t0 = texture2D(textureglow, uv);

      vec4 tc = texture2D(texture, uv3);

      vec3 hue = rgb2hsv (tc.rgb);

      vec3 hue1 = vec3(1.0) - hue;

      vec3 tch5 = hsv2rgb (vec3(hue.x , (1.0 - hue1.z*hue1.z*hue1.z)*(1.0 - hue1.y*hue1.y) * (1.0 - t0.r) , 1.0));

      gl_FragColor = vec4(tch5 , gl_Color.a*(t0.r));
      
      //   gl_FragColor = tc;
      
   }
   else {
      gl_FragColor = (gl_Color.rgba);
   }

}