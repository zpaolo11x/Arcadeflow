#version 120
uniform sampler2D texture;
uniform vec2 limits;
void main()
{   
   vec2 uv = gl_TexCoord[0].xy;
    // lookup the pixel in the texture
    vec4 pixel = texture2D(texture, uv);

    float alpha = smoothstep(0.0, limits.x, 1.0 - uv.y) * smoothstep(0.0, limits.y, uv.y);
    
	 // multiply it by the color
    gl_FragColor = gl_Color * (pixel.rgb , pixel.a*(alpha));
}
