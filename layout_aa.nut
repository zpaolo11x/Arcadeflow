local scale = 20

local srf0 = fe.add_surface(16, 16)
srf0.smooth = false
srf0.width = 16 * scale
srf0.height = 16 * scale
local pic0 = srf0.add_image("16.png",0,0,16,16)

local srf1 = fe.add_surface(16, 16)
srf1.set_pos(16 * scale, 0)
srf1.smooth = false
srf1.width = 16 * scale
srf1.height = 16 * scale
local pic1 = srf1.add_image("16b.png",-1,-1,18,18)

local srf2 = fe.add_surface(16, 16)
srf2.set_pos(16 * 2 * scale, 0)
srf2.smooth = false
srf2.width = 16 * scale
srf2.height = 16 * scale
local pic2 = srf2.add_image("16.png",0,0,16,16)


local selectedbarshader = fe.add_shader (Shader.Fragment, "glsl/aapixel.glsl")
selectedbarshader.set_texture_param("texture")
selectedbarshader.set_param ("pixelheight", 1.0 / 16.0)
pic2.shader = selectedbarshader

fe.add_ticks_callback(this, "tick")

local increment = 0.005

function tick(ttime){
	pic0.y += increment
	pic1.y += increment
	pic2.y += increment

}