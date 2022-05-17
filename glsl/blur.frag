#version 120

uniform sampler2D texture;
uniform vec2 screen_size;
uniform float blur;

float noise( vec2 p )
{
	return fract( sin( dot( p, vec2( 1024.0, 1054.01 ))) * 43758.5453 );
}

void main()
{
	vec4 pixel = texture2D( texture, gl_TexCoord[0].xy, blur );
	pixel += texture2D( texture, gl_TexCoord[1].xy, blur );
	pixel += texture2D( texture, gl_TexCoord[1].zw, blur );
	pixel += texture2D( texture, gl_TexCoord[2].xy, blur );
	pixel += texture2D( texture, gl_TexCoord[2].zw, blur );
	pixel *= 0.2;

	float n = noise( gl_TexCoord[0].xy ) / 128.0;
	pixel.xyz += vec3( n ) - 1.0 / 256.0;
	gl_FragColor = gl_Color * pixel;
}