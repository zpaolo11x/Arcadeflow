#version 120
uniform sampler2D texture;
uniform float pixelheight;

void main()
{   

vec2 uv = gl_TexCoord[0].xy;
vec4 t0 = texture2D(texture, uv);
float localalpha = clamp ((uv.y - pixelheight * 0.5) / pixelheight, 0.0, 1.0) * clamp ((1.0 - uv.y - pixelheight * 0.5) / pixelheight, 0.0, 1.0);

gl_FragColor = vec4(t0.xyz, localalpha);

//gl_FragColor *= gl_FragColor.a;
}