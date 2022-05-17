uniform sampler2D texture;
uniform vec2 size;

void main(){

   vec2 uv = gl_FragCoord.xy;
   vec4 color1 = texture2D(texture, (vec2(uv.x+0.5,uv.y))/size);
   
   gl_FragColor = color1;
}