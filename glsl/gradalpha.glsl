#version 120
uniform sampler2D texture;
uniform vec2 limits;
uniform float enabled;
uniform float remap;
uniform vec3 color1;
uniform vec3 color2;
uniform float lcdcolor;

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

void main()
{   

   vec2 uv = gl_TexCoord[0].xy;

   vec4 tc = texture2D(texture, uv);

	//TEST97 if (lcdcolor) tc = gbacolor(tc);
	tc = mix (tc, gbacolor(tc), lcdcolor);

   float scaler1 = smoothstep(limits.x,limits.y,uv.y);
   //scaler1 = smoothstep(0.5,0.5,uv.x); //TEST87

   // vec4 tcOUT = vec4(mix(t0.rgb , tc.rgb , (enabled ? scaler1 : 0.0 )), 1.0);
	//TEST97    vec4 tcOUT = vec4(tc.rgb, (enabled ? scaler1 : 1.0 ));
	vec4 tcOUT = vec4(tc.rgb, mix(1.0, scaler1, enabled ));

   //TEST97 if (remap) tcOUT.rgb = remap * vec3(mix(color1.rgb,color2.rgb,tcOUT.x))
	tcOUT.rgb = mix (tcOUT.rgb, vec3(mix(color1.rgb,color2.rgb,tcOUT.x)), remap);
   gl_FragColor = gl_Color*tcOUT;

 //  gl_FragColor = vec4(tc.rgb , 1.0;

}