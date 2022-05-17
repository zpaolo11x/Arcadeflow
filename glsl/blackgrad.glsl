#version 120
//uniform sampler2D texture;
uniform float vert; 
void main()
{   

vec2 uv = gl_TexCoord[0].xy;

if (vert == 1.0) uv = uv.yx;

float alpha = smoothstep(0.0,0.7,1.0-uv.y)*smoothstep(0.0,0.7,uv.y);
alpha *=0.6;
alpha +=0.25;
gl_FragColor = vec4(vec3(0.0) , alpha);

}