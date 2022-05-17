#version 120
//uniform sampler2D texture;
float rampage(float x)
{
   float edge0 = 0.3;
   float edge1 = 0.6;
   return (clamp(x,edge0,edge1));
}

void main()
{
   vec4 correct = vec4(0.25,0.25,0.25,0.25);
   // transform the vertex position
   gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
   gl_TexCoord[0] = (gl_TextureMatrix[0] * gl_MultiTexCoord0);

   gl_TexCoord[0].xy = vec2(gl_TexCoord[0].x, -0.5+rampage (gl_TexCoord[0].y) );

   // forward the vertex color
   gl_FrontColor = gl_Color;
}
