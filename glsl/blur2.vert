#version 120

uniform float blur;

void main()
{
    gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
    gl_TexCoord[0] = gl_TextureMatrix[0] * gl_MultiTexCoord0; // xy - normal uv
    gl_TexCoord[0].zw = gl_Position.xy * 0.5 + 0.5; // zw - screen space uv
    gl_FrontColor = gl_Color;

    // Screen Size
    vec2 ss = gl_Vertex.xy / vec2( gl_TexCoord[0].z, 1.0 - gl_TexCoord[0].w );

    // UV scaler
    float s = pow( 2.0, blur - 1.0 ) + 2.0;
    s *= min( blur, 1.0 );

      // Rotated sparse grid coefficients
    float c1 = 0.6;
    float c2 = 0.2;

    // Precomputed UVs
    vec2 uv = gl_TexCoord[0].zw;
    gl_TexCoord[1].xy = uv + vec2( s *  c1 / ss.x, s *  c2 / ss.y );
    gl_TexCoord[1].zw = uv + vec2( s *  c2 / ss.x, s * -c1 / ss.y );
    gl_TexCoord[2].xy = uv + vec2( s * -c1 / ss.x, s * -c2 / ss.y );
    gl_TexCoord[2].zw = uv + vec2( s * -c2 / ss.x, s *  c1 / ss.y );
}