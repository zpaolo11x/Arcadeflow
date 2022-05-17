#version 120
uniform sampler2D texture;

float luminosity( in vec3 c ){
	float s = 0.0;
	float l = 0.0;

	float cMin = min( c.r, min( c.g, c.b ) );
	float cMax = max( c.r, max( c.g, c.b ) );
	l = ( cMax + cMin ) / 2.0;

	if ( cMax > cMin ) {
		float cDelta = cMax - cMin;
       
        //s = l < .05 ? cDelta / ( cMax + cMin ) : cDelta / ( 2.0 - ( cMax + cMin ) ); 
		s = l < .0 ? cDelta / ( cMax + cMin ) : cDelta / ( 2.0 - ( cMax + cMin ) );
        
	}
	return float( l );
}


void main()
{   

vec2 uv = gl_TexCoord[0].xy;
vec4 t0 = texture2D(texture, uv);
float hsl0 = luminosity (t0.rgb);

gl_FragColor = vec4(vec3(hsl0) , gl_Color.a*t0.a);

}