#version 120

uniform vec2 size;
uniform float bias;

void main()
{   
   // Standard vertex shader stuff
   gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
   gl_TexCoord[0] = gl_TextureMatrix[0] * gl_MultiTexCoord0;
   gl_FrontColor = gl_Color;

  vec2 uv = gl_TexCoord[0].xy;

  vec2 o1 = 1.0/size;

  gl_TexCoord[1].xy = uv + vec2(o1.x,o1.y);
  gl_TexCoord[1].zw = uv + vec2(o1.x,-o1.y);
  gl_TexCoord[2].xy = uv + vec2(-o1.x,o1.y);
  gl_TexCoord[2].zw = uv + vec2(-o1.x,-o1.y);

}