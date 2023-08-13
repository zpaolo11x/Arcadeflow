#version 120
uniform sampler2D texture;
uniform float pixelheight;

void main()
{   

vec2 uv = gl_TexCoord[0].xy;
vec4 t0 = texture2D(texture, uv);

gl_FragColor = vec4(t0.xyz, step(pixelheight, uv.y) * (step(pixelheight, 1.0 - uv.y)));

}