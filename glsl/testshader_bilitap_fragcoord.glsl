#version 120
uniform sampler2D texture;

uniform float size;

void main()
{   



vec2 uv = vec2(gl_FragCoord.x,size-gl_FragCoord.y);

float o1 = 1.33;
float o2 = 1.25;
float w0 = 0.201663;
float w1 = 0.12474;
float w2 = 0.074844;

vec4 t0 = w0*texture2D(texture, uv/size);
t0 += w1*texture2D(texture, (uv + vec2(0.0,o1))/size);
t0 += w1*texture2D(texture, (uv + vec2(0.0,-o1))/size);
t0 += w1*texture2D(texture, (uv + vec2(o1,0.0))/size);
t0 += w1*texture2D(texture, (uv + vec2(-o1,0.0))/size);
t0 += w2*texture2D(texture, (uv + vec2(o2,-o2))/size);
t0 += w2*texture2D(texture, (uv + vec2(o2,o2))/size);
t0 += w2*texture2D(texture, (uv + vec2(-o2,o2))/size);
t0 += w2*texture2D(texture, (uv + vec2(-o2,-o2))/size);


gl_FragColor = gl_Color*t0;

}