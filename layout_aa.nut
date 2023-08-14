local scale = 15

local bg = fe.add_rectangle (0, 0, fe.layout.width, fe.layout.height)
bg.set_rgb(200,0,0)

local srf1 = fe.add_surface(16, 16)
srf1.set_pos(0, 0)
srf1.smooth = false
srf1.width = 16 * scale
srf1.height = 16 * scale
local pic1 = srf1.add_image("16b2.png",0,0,16,16)

local srf2 = fe.add_surface(16, 16)
srf2.set_pos(16 * scale, 0)
srf2.smooth = false
srf2.width = 16 * scale
srf2.height = 16 * scale
local pic2 = srf2.add_image("16.png",0,0,16,16)

local selectedbarshader = fe.add_shader (Shader.Fragment, "glsl/aapixel.glsl")
selectedbarshader.set_texture_param("texture")
selectedbarshader.set_param ("pixelheight", 1.0 / 16.0)
pic2.shader = selectedbarshader

local txt = fe.add_text("",16 * 2 * scale,0, 6 * scale, 2 * scale)

fe.add_signal_handler(this, "on_signal")
fe.add_ticks_callback(this, "tick")

local increment = 0.25

function on_signal(sig){
	if (sig == "down"){
		pic1.y += increment
		pic2.y += increment
		txt.msg = pic1.y
		return true		
	}
	if (sig == "up"){
		pic1.y -= increment
		pic2.y -= increment
		txt.msg = pic1.y
		return true		
	}
}
