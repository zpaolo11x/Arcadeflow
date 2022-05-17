#version 120
uniform sampler2D texture;
uniform vec2 limits;
uniform vec2 blanker;
void main()
{   
   vec2 uv = gl_TexCoord[0].xy;
    // lookup the pixel in the texture
    vec4 pixel = texture2D(texture, uv);

    float alpha = (0.2+0.8*smoothstep(blanker.y,blanker.y+limits.x,1.0-uv.y)) * smoothstep(0.0, limits.y,uv.y);
    alpha += 1.0 - step(blanker.y,1.0-uv.y);
    alpha = mix(1.0,alpha,step(blanker.x,uv.x));
    // multiply it by the color
    gl_FragColor = gl_Color * (pixel.rgb , pixel.a*(alpha));
}
