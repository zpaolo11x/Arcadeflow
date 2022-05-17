#version 120
uniform sampler2D texture;

void main()
{   

vec2 uv = gl_TexCoord[0].xy;
vec4 t0 = texture2D(texture, uv);

// BW gl_FragColor = vec4(vec3(gl_Color.x) , gl_Color.a*(1.0 - t0.x));
// TX gl_FragColor = vec4(gl_Color.rgb * vec3(t0.x),t0.x);

gl_FragColor = vec4(vec3(t0.r),t0.x);

}