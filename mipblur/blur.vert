#version 120

uniform vec2 screen_size;
uniform float blur;

void main()
{
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
	gl_TexCoord[0] = gl_TextureMatrix[0] * gl_MultiTexCoord0;
	gl_FrontColor = gl_Color;

	// UV scaler
	float s = pow( 2.0, blur - 1.0 ) + 2.0;
	s *= min( blur, 1.0 );

  	// Rotated sparse grid coefficients
	float c1 = 0.6;
	float c2 = 0.2;

	// Precomputed UVs
  	vec2 uv = gl_TexCoord[0].xy;
  	gl_TexCoord[1].xy = uv + vec2( s *  c1 / screen_size.x, s *  c2 / screen_size.y );
	gl_TexCoord[1].zw = uv + vec2( s *  c2 / screen_size.x, s * -c1 / screen_size.y );
	gl_TexCoord[2].xy = uv + vec2( s * -c1 / screen_size.x, s * -c2 / screen_size.y );
	gl_TexCoord[2].zw = uv + vec2( s * -c2 / screen_size.x, s *  c1 / screen_size.y );
}