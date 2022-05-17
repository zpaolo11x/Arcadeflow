uniform sampler2D texture;
uniform vec2 offsetFactor;

void main(void) {
   // 0.0, 1.3846153846, 3.2307692308
   // 0.2270270270, 0.3162162162, 0.0702702703)
   vec2 uv = gl_TexCoord[0].xy;

   vec4 colorout = texture2D(texture, uv) * 0.2270270270;
   colorout += texture2D(texture, (uv + 1.3846153846 * offsetFactor)) * 0.3162162162;
   colorout += texture2D(texture, (uv - 1.3846153846 * offsetFactor)) * 0.3162162162;
   colorout += texture2D(texture, (uv + 3.2307692308 * offsetFactor)) * 0.0702702703;
   colorout += texture2D(texture, (uv - 3.2307692308 * offsetFactor)) * 0.0702702703;
   //gl_FragColor = gl_Color*colorout;
    gl_FragColor = vec4(gl_Color.rgb*colorout.rgb,gl_Color.a*colorout.a);

}