#version 120

uniform vec4 w0;
uniform vec4 u0;
uniform vec2 offsetfactor;

void main(void) {
   // Standard vertex shader stuff
   gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
   gl_TexCoord[0] = gl_TextureMatrix[0] * gl_MultiTexCoord0;
   gl_FrontColor = gl_Color;

   vec2 uv = gl_TexCoord[0].xy;

   gl_TexCoord[1].xy = uv + u0.y * offsetfactor;
   gl_TexCoord[1].zw = uv - u0.y * offsetfactor;
   gl_TexCoord[2].xy = uv + u0.z * offsetfactor;
   gl_TexCoord[2].zw = uv - u0.z * offsetfactor;
   gl_TexCoord[3].xy = uv + u0.w * offsetfactor;
   gl_TexCoord[3].zw = uv - u0.w * offsetfactor;

}