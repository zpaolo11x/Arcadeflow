
fe.do_nut( "textboard_GOOD.nut" )
local bg = fe.add_rectangle(0,0,fe.layout.width,fe.layout.height )
bg.set_rgb(0,100,100)
bg.alpha = 255
local tboard = fe.add_textboard("TEST\ntest",0,0,fe.layout.width,fe.layout.height)

tboard.align = Align.TopLeft
tboard.char_size = 20
tboard.scroll_speed = 2
tboard.margin = 20
tboard.natural_scroll = false
tboard.enable_signals = true
tboard.signal_block = false

//tboard.set_bg_rgb(200,0,0)
tboard.msg = "START\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque lobortis euismod nunc id accumsan. In vitae ultrices neque. Morbi vestibulum nibh et velit euismod eleifend. Curabitur at sodales ligula. Aliquam dapibus ipsum purus, non sollicitudin arcu gravida non. Etiam eleifend eleifend nibh. Nullam a nisi quam. Sed at dui nulla. Curabitur euismod ut nisl non dignissim. Integer semper condimentum ipsum ac dapibus. Donec vulputate, magna eu dignissim suscipit, ante sapien commodo libero, vel lobortis ante justo sit amet neque. Morbi vitae viverra est. Proin nulla elit, dapibus id sapien in, rutrum congue quam. Sed id sapien congue, faucibus libero eu, varius orci. Cras vestibulum erat sed semper luctus.\nPhasellus efficitur et quam non congue. Duis ornare vestibulum massa, id eleifend metus feugiat vitae. Donec convallis est justo, quis tempus lectus hendrerit sit amet.\nSTOP"
tboard.set_bg_rgb(200,0,0)
tboard.set_rgb(255,255,255)

local overlay = fe.add_rectangle (tboard.x + tboard.margin, tboard.y+tboard.margin,tboard.width - 2 * tboard.margin, tboard.height-2*tboard.margin)
overlay.set_rgb(0,0,200)
overlay.alpha = 128
//tboard.alpha = 255


local pic0 = fe.add_image("metapics/category10/action.png",fe.layout.width-200,0,200,200)
/*
local bwtoalpha = fe.add_shader(Shader.Fragment, "glsl/bwtoalpha.glsl")
local textboard = fe.add_shader(Shader.Fragment, "textboard.glsl")

pic0.shader = bwtoalpha

pic0.set_rgb(0,0,0)
pic0.alpha = 255

tboard.shader = textboard

tboard.set_rgb(0,0,0)
tboard.alpha = 255
*/