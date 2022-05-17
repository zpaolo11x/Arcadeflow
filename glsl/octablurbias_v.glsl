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

   vec2 o1 = 1.5/size;
   vec2 o2 = 0.5/size;

   gl_TexCoord[1].xy = uv + vec2(o1.x,0.0);
   gl_TexCoord[1].zw = uv + vec2(-o1.x,0.0);
   gl_TexCoord[2].xy = uv + vec2(0.0,o1.y);
   gl_TexCoord[2].zw = uv + vec2(0.0,-o1.y);
   gl_TexCoord[3].xy = uv + vec2(o2.x,-o2.y);
   gl_TexCoord[3].zw = uv + vec2(o2.x,o2.y);
   gl_TexCoord[4].xy = uv + vec2(-o2.x,o2.y);
   gl_TexCoord[4].zw = uv + vec2(-o2.x,-o2.y);


}