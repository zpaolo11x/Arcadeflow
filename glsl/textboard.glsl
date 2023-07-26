#version 120
uniform sampler2D texture;
uniform vec3 textcolor;
uniform vec3 panelcolor;
uniform float textalpha;
uniform float panelalpha;
uniform float wholealpha;
uniform vec2 blanktop;
uniform vec2 blankbot;
uniform float alphatop;
uniform float alphabot;

void main()
{   

vec2 uv = gl_TexCoord[0].xy;
vec4 pixel = texture2D(texture, uv);

float textalpha2 = textalpha;
float bw = pixel.x;
textalpha2 *= bw;
textalpha2 *= (1.0 - alphabot) + alphabot * smoothstep(blankbot.x, blankbot.y, uv.y);
textalpha2 *= (1.0 - alphatop) + alphatop * smoothstep(blanktop.x, blanktop.y, 1.0 - uv.y);
textalpha2 *= step(blankbot.x, uv.y);
textalpha2 *= step(blanktop.x, 1.0 - uv.y);

float alphafull = textalpha2 + panelalpha * (1.0 - textalpha2);
vec3 colorfull = (textcolor * textalpha2 + panelcolor * panelalpha * (1.0 - textalpha2));

gl_FragColor = vec4(colorfull * wholealpha, alphafull * wholealpha);
}