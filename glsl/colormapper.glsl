#version 120
uniform sampler2D texture;
uniform vec3 color1;
uniform vec3 color2;
uniform float lcdcolor;
uniform float remap;
uniform vec3 hsv;


const float target_gamma = 2.2;
const float display_gamma = 2.5;
const float sat = 1.0;
const float lum = 0.99;
const float contrast = 1.0;
const vec3 bl = vec3(0.0, 0.0, 0.0);
const vec3 r = vec3(0.84, 0.09, 0.15);
const vec3 g = vec3(0.18, 0.67, 0.10);
const vec3 b = vec3(0.0, 0.26, 0.73);
const float darken_screen = 0.9;

vec4 gbacolor (in vec4 tc){
	vec4 screen = pow(tc, vec4(target_gamma + darken_screen)).rgba;
	vec4 avglum = vec4(0.5);
	screen = mix(screen, avglum, (1.0 - contrast));

	mat4 color = mat4(	r.r,	r.g,	r.b,	0.0,
								g.r,	g.g,	g.b,	0.0,
								b.r,	b.g,	b.b,	0.0,
								bl.r,	bl.g,	bl.b,	1.0);

	mat4 adjust = mat4(	(1.0 - sat) * 0.3086 + sat,	(1.0 - sat) * 0.3086,		(1.0 - sat) * 0.3086,		1.0,
								(1.0 - sat) * 0.6094,		(1.0 - sat) * 0.6094 + sat,	(1.0 - sat) * 0.6094,		1.0,
								(1.0 - sat) * 0.0820,		(1.0 - sat) * 0.0820,		(1.0 - sat) * 0.0820 + sat,	1.0,
								0.0,				0.0,				0.0,				1.0);
	color *= adjust;
	screen = clamp(screen * lum, 0.0, 1.0);
	screen = color * screen;
	return( pow(screen, vec4(1.0 / display_gamma + (darken_screen * 0.125))) );
}

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main()
{

vec2 uv = gl_TexCoord[0].xy;

vec4 t0 = texture2D(texture, uv);

vec3 hsv0 = rgb2hsv (t0.rgb);
vec3 hsv1 = clamp(hsv0+hsv,vec3(0.0),vec3(1.0));

t0.rgb = hsv2rgb (hsv1);

//TEST97 if (lcdcolor==1.0) t0 = gbacolor(t0);
t0 = mix (t0, gbacolor(t0),lcdcolor);

//TEST97 if (remap==1.0) t0.rgb = vec3(mix(color1.rgb,color2.rgb,t0.x));
t0.rgb = mix (t0.rgb, vec3(mix(color1.rgb,color2.rgb,t0.x)), remap);

gl_FragColor = vec4(gl_Color.rgb*t0.rgb , gl_Color.a*t0.a);

}