#version 120

uniform sampler2D texture;
uniform vec2 screen_size;
uniform float blur;


void main()
{
	vec4 pixel = texture2D( texture, gl_TexCoord[0].xy, blur );
	gl_FragColor = gl_Color * pixel;
}