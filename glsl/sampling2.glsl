uniform sampler2D texture;
uniform vec2 size;
uniform vec2 offset;

void main(){

   vec2 uv = gl_TexCoord[0].xy;
   vec4 color1 = texture2D(texture, (vec2(uv.x+offset.x/size.x,uv.y+offset.y/size.y)));
   gl_FragColor = color1;
}