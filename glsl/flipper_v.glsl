#version 120
//uniform sampler2D texture;
uniform float rotation;

void main()
{
   // transform the vertex position
   gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
   gl_TexCoord[0] = (gl_TextureMatrix[0] * gl_MultiTexCoord0);

   if (rotation == 1.0){
      gl_TexCoord[0].xy = vec2(1.0 - gl_TexCoord[0].y, gl_TexCoord[0].x) ;
   }

   else if (rotation == 2.0){
      gl_TexCoord[0].xy = vec2(1.0 - gl_TexCoord[0].x, 1.0 - gl_TexCoord[0].y) ;
   }

   else if (rotation == 3.0){
      gl_TexCoord[0].xy = vec2(gl_TexCoord[0].y, 1.0 - gl_TexCoord[0].x) ;
   }

   // forward the vertex color
   gl_FrontColor = gl_Color;
}
