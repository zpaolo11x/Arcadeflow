#version 120
//uniform sampler2D texture;

void main()
{
   vec4 correct = vec4(0.25,0.25,0.25,0.25);
   // transform the vertex position
   gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
   gl_TexCoord[0] = (gl_TextureMatrix[0] * gl_MultiTexCoord0);

   vec2 uvOFFSET = vec2(-1.0*correct.x, -1.0*correct.y);
   vec2 uvSCALE = vec2(1.0 / correct.z , 1.0 / correct.w);

   gl_TexCoord[0].xy = uvSCALE*(uvOFFSET + gl_TexCoord[0].xy );

   // forward the vertex color
   gl_FrontColor = gl_Color;
}
