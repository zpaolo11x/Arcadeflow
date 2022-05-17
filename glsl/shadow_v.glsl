#version 120

uniform vec3 shadow;

vec2 rampzero(vec2 x, vec2 edge0, vec2 edge1)
{
   return ((-edge0 + clamp(x,edge0,edge1))/(edge1-edge0));
}

void main()
{
   // Standard vertex shader stuff
   gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
   gl_TexCoord[0] = gl_TextureMatrix[0] * gl_MultiTexCoord0;
   gl_FrontColor = gl_Color;

   // Read current coordinates
   vec2 uv_0 = gl_TexCoord[0].xy;

   // Transform coordinates according to parameters
   vec2 uv_shadowshape =  rampzero(uv_0,shadow.xy,shadow.xy + shadow.z) * 0.25 
                  + rampzero(uv_0,shadow.xy + shadow.z,1.0 - shadow.xy - shadow.z) * 0.5 
                  + rampzero(uv_0,1.0 - shadow.xy - shadow.z,1.0 - shadow.xy) * 0.25 ;

   gl_TexCoord[1].xy = uv_shadowshape;
}
