// This line loads the module nut file.

local flw = fe.layout.width = 640
local flh = fe.layout.height = 400

local bg = fe.add_rectangle(0,0,flw,flh )
bg.set_rgb(0,100,100)
bg.alpha = 255

local text_to_show = "Endorsed by Andrè Panza, this video game adaptation of Thai kick boxing features over 35 moves. Use the training gym to build up your character's abilities until you feel ready to take on an opponent. You also have the ability to customize your attacks. When you are ready, go to the ring to take on various opponents as you try to become the best kick boxer in the game. "

local tw = flw * 0.5
local th = flh * 0.5

local tboard = fe.add_text("", 0, 0, tw, th)

tboard.align = Align.TopLeft
tboard.char_size = 20
tboard.word_wrap = true
tboard.set_bg_rgb(0,0,100)
tboard.set_rgb(255, 255, 255)
tboard.bg_alpha = 100
tboard.alpha = 255

tboard.msg = text_to_show

local tboard2 = fe.add_text("", tw, 0, tw, th)
tboard2.align = Align.TopLeft
tboard2.char_size = 20
tboard2.word_wrap = true
tboard2.set_bg_rgb(100,0,0)
tboard2.set_rgb(255, 255, 255)
tboard2.bg_alpha = 100
tboard2.alpha = 255

tboard2.msg = tboard.msg_wrapped

fe.add_signal_handler( this, "board_on_signal" )

function board_on_signal(sig){
	if (sig == "custom1"){
		fe.signal("reload")
		return true
	}
}