local mypic = fe.add_artwork("snap",0,0,fe.layout.width,fe.layout.height)
mypic.video_flags = Vid.ImagesOnly
mypic.mipmap = true
local fragshader = fe.add_shader(Shader.Fragment, "glsl/mipblurx.frag")
mypic.shader = fragshader
