#version 120

uniform sampler2D texture;

void main()
{   
   // Get texture color at modified coordinates
   vec4 tc = texture2D(texture, gl_TexCoord[1].xy);
   
   gl_FragColor = gl_Color*tc;      

}