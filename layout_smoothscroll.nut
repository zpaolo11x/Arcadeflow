
local flw = fe.layout.width
local flh = fe.layout.height

fe.do_nut( "textboard.nut" )
local bg = fe.add_rectangle(0,0,flw,flh )
bg.set_rgb(0,100,100)
bg.alpha = 255
local tboard = fe.add_textboard("TEST\ntest",0,0,flw * 0.5,flh * 0.6)

tboard.align = Align.TopLeft
tboard.char_size = 15
tboard.scroll_speed = 0.2
tboard.margin = 20
tboard.natural_scroll = true
tboard.enable_signals = true
tboard.signal_block = false



//tboard.set_bg_rgb(200,0,0)
tboard.msg = "START\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque lobortis euismod nunc id accumsan. In vitae ultrices neque. Morbi vestibulum nibh et velit euismod eleifend. Curabitur at sodales ligula. Aliquam dapibus ipsum purus, non sollicitudin arcu gravida non. Etiam eleifend eleifend nibh. Nullam a nisi quam. Sed at dui nulla. \nSTOP\n"//Curabitur euismod ut nisl non dignissim. Integer semper condimentum ipsum ac dapibus. Donec vulputate, magna eu dignissim suscipit, ante sapien commodo libero, vel lobortis ante justo sit amet neque. Morbi vitae viverra est. Proin nulla elit, dapibus id sapien in, rutrum congue quam. Sed id sapien congue, faucibus libero eu, varius orci. Cras vestibulum erat sed semper luctus.\nPhasellus efficitur et quam non congue. Duis ornare vestibulum massa, id eleifend metus feugiat vitae. Donec convallis est justo, quis tempus lectus hendrerit sit amet.\nSTOP"

local textref = fe.add_text("X",flw*0.5,0,flw * 0.5,flh * 0.6)
textref.msg = "START\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque lobortis euismod nunc id accumsan. In vitae ultrices neque. Morbi vestibulum nibh et velit euismod eleifend. Curabitur at sodales ligula. Aliquam dapibus ipsum purus, non sollicitudin arcu gravida non. Etiam eleifend eleifend nibh. Nullam a nisi quam. Sed at dui nulla. Curabitur euismod ut nisl non dignissim. Integer semper condimentum ipsum ac dapibus. Donec vulputate, magna eu dignissim suscipit, ante sapien commodo libero, vel lobortis ante justo sit amet neque. Morbi vitae viverra est. Proin nulla elit, dapibus id sapien in, rutrum congue quam. Sed id sapien congue, faucibus libero eu, varius orci. Cras vestibulum erat sed semper luctus.\nPhasellus efficitur et quam non congue. Duis ornare vestibulum massa, id eleifend metus feugiat vitae. Donec convallis est justo, quis tempus lectus hendrerit sit amet.\nSTOP"
textref.align = tboard.align
textref.char_size = tboard.char_size 
textref.margin = tboard.margin
textref.word_wrap = true

tboard.set_bg_rgb(0,0,100)
tboard.set_rgb(200, 200, 200)
tboard.bg_alpha = 100
tboard.tx_alpha = 255
tboard.alpha = 255


local overlay = fe.add_rectangle (tboard.x + tboard.margin, tboard.y+tboard.margin,tboard.width - 2 * tboard.margin, tboard.height-2*tboard.margin)
overlay.set_rgb(200,0,0)
overlay.alpha = 0
