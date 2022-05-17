#version 120

uniform sampler2D texture;

float rampzero(float x, float edge0, float edge1)
{
   return ((-edge0 + clamp(x,edge0,edge1))/(edge1-edge0));
}

void main()
{
   vec2 uv = vec2(0.0);
   vec2 uv2 = vec2(0,0);

   vec2 center = vec2 ((504.0 - 35.0 * 2.0)/640.0,(336.0 - 35.0 * 2.0)/640.0);
   float border = (100.0 + 35.0)/640.0;
   vec2 offset = (1.0 - center - border*2.0) * 0.5;

   uv = gl_TexCoord[0].xy;
   uv2 = vec2(
      rampzero(uv.x,offset.x,offset.x + border) * (100.0 + 35.0)/640.0 + rampzero(uv.x,offset.x + border,1.0-offset.x-border) * (440.0 - 2.0*35.0)/640.0  + rampzero(uv.x,1.0 - offset.x - border,1.0 - offset.x) * (100.0 + 35.0)/640.0,
      rampzero(uv.y,offset.y,offset.y + border) * (100.0 + 35.0)/640.0 + rampzero(uv.y,offset.y + border,1.0-offset.y-border) * (440.0 - 2.0*35.0)/640.0 + rampzero(uv.y,1.0 - offset.y - border,1.0 - offset.y) * (100.0 + 35.0)/640.0 
      ); 

   vec4 tc = texture2D(texture, uv2);

   gl_FragColor = tc;
}
