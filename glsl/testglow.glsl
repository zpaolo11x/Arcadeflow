#version 120
uniform sampler2D texture;


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

   vec2 uv = gl_TexCoord[0].xy;
   vec4 tc = texture2D(texture, uv);

   /* HISTORY BOOST FOR ADD BLEND
   vec4 tcOUT = vec4(tc.rgb, 1.0-(1.0-tc.a)*(1.0-tc.a)*(1.0-tc.a)*(1.0-tc.a)*(1.0-tc.a)*(1.0-tc.a)*(1.0-tc.a));

   gl_FragColor = vec4(tcOUT.rgb,gl_Color.a*tcOUT.a);
   */

   /* THUMBNAIL GLOW
   vec3 hue = rgb2hsv (tc.rgb);

   vec3 hue1 = vec3(1.0) - hue;

   vec3 tch5 = hsv2rgb (vec3(hue.x , (1.0 - hue1.z)*(1.0 - hue1.y) * (1.0 - tc.a) , 1.0));

   gl_FragColor = vec4(tch5 , gl_Color.a*(tc.a));
   */


     vec3 hue = rgb2hsv (tc.rgb);
   vec3 hue1 = vec3(1.0) - hue;

   gl_FragColor = vec4(tc.rgb, gl_Color.a*tc.a*hue.z);
 

}