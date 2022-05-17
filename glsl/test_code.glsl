#ifdef GL_ES
precision lowp float;
#endif

uniform vec2 u_resolution;

void main() {
    vec2 coord = gl_FragCoord.xy / u_resolution;
    vec2 offset = vec2(0.5, 0.0);
    float dist = distance(coord, offset);
    vec3 color = vec3(dist, 0.0, 0.0);

    gl_FragColor = vec4(color, 1.0);
}