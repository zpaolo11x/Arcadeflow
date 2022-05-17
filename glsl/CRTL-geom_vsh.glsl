#version 120
/** Shader **/

varying vec2 texCoord;
varying float U;
varying float W;
varying vec3 YUVr;
varying vec3 YUVg;
varying vec3 YUVb;
uniform float saturation;
uniform float tint;


const float PI = 3.1415926535;


void main()
{
    U = cos(tint*PI/180.0);
    W = sin(tint*PI/180.0);
    YUVr=vec3( 0.701 * saturation * U + 0.16774 * saturation * W + 0.299,0.587 - 0.32931 * saturation * W - 0.587 * saturation * U, -0.497 * saturation * W - 0.114 * saturation * U + 0.114);
    YUVg=vec3(-0.3281* saturation * W - 0.299 * saturation * U + 0.299,0.413 * saturation * U + 0.03547 * saturation * W + 0.587, 0.114 + 0.29265 * saturation * W - 0.114 * saturation * U);
    YUVb=vec3( 0.299 + 1.24955 * saturation * W - 0.299 * saturation * U, -1.04634 * saturation * W - 0.587 * saturation * U + 0.587, 0.886 * saturation * U - 0.20321 * saturation * W + 0.114);


    // transform the texture coordinates
    gl_TexCoord[0] = gl_TextureMatrix[0] * gl_MultiTexCoord0;
    // Do the standard vertex processing.
    gl_Position     = gl_ModelViewProjectionMatrix * gl_Vertex;
    // Texture coords.
    texCoord = gl_TexCoord[0].xy;
}
