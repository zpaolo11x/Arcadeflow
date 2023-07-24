// This line loads the module nut file.
fe.do_nut( "textboard_mk2.nut" )

local flw = fe.layout.width = 640
local flh = fe.layout.height = 400

local bg = fe.add_rectangle(0,0,flw,flh )
bg.set_rgb(0,100,100)
bg.alpha = 255

function msgbox_test(){
	local bodytext = ""
	local max = 20
	for (local i = 3; i < max; i++){
		bodytext = bodytext + i + "\n"
	}
	bodytext = bodytext + max
	return("TOTAL:"+"\n\n"+ bodytext)
}

local text_to_show = "Lorem ipsum dolor sit amet, consectetur adipiscing elit.\nQuisque lobortis euismod nunc id accumsan. In vitae ultrices neque. Morbi vestibulum nibh et velit euismod eleifend. Curabitur at sodales ligula. Aliquam dapibus ipsum purus, non sollicitudin arcu gravida non. Etiam eleifend eleifend nibh. Nullam a nisi quam. Sed at dui nulla. Curabitur euismod ut nisl non dignissim. Integer semper condimentum ipsum ac dapibus. Donec vulputate, magna eu dignissim suscipit, ante sapien commodo libero, vel lobortis ante justo sit amet neque. Morbi vitae viverra est.\nSTOP"//Proin nulla elit, dapibus id sapien in, rutrum congue quam. Sed id sapien congue, faucibus libero eu, varius orci. Cras vestibulum erat sed semper luctus.\nSTOP"
local tw = flw * 0.5
local th = flh * 0.25

text_to_show = msgbox_test()

local tboard = fe.add_textboard_mk2("", 0, 0, tw, th)

// "standard" text parameters
tboard.align = Align.TopLeft
tboard.char_size = 12
tboard.margin = 8
tboard.line_spacing = 1.1
tboard.msg = text_to_show

// Color and alpha definition
tboard.set_bg_rgb(0,0,100)			// Color of the board background
tboard.set_rgb(255, 255, 255)		// Color of the text
tboard.bg_alpha = 100				// Alpha of the background
tboard.tx_alpha = 255				// Alpha of the text
tboard.alpha = 255					// Alpha of the whole board

// Scroll parameters

tboard.natural_scroll = false	// Inverts scroll control direction for automatic signal management
tboard.enable_signals = true	// Enable module signal control
tboard.signal_block = true		// Prevents or enable further signal management

tboard.lines_bottom = 2.0		// Faded lines at the bottom of the board
tboard.lines_top = 1.0			// Faded lines at the top of the board

tboard.pingpong = false			// Enable auto-scroll
tboard.pingpong_delay = 3		// Autoscroll delay in seconds

tboard.pingpong_speed = 1.0	// Autoscroll speed in lines per second 
tboard.scroll_pulse = 0.05		// Initial scroll impulse between 0 and 1

tboard.expand_tokens = false	// Enable/disable magic token expansion

// Reference text box to compare
local textref = fe.add_text(text_to_show, tw, 0, tw, flh)
textref.align = tboard.align
textref.char_size = tboard.char_size 
textref.margin = tboard.margin
textref.word_wrap = true
textref.line_spacing = tboard.line_spacing



/*
local overlay = fe.add_rectangle (tboard.x + tboard.margin, tboard.y + tboard.margin, tboard.width - 2 * tboard.margin, tboard.height - 2 * tboard.margin)
overlay.set_rgb(200, 0, 0)
overlay.alpha = 100
*/