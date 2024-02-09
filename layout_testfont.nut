


local uifonts = {
	gui = "fonts/font_Roboto-Allcaps-EXT4X.ttf"
	general = "fonts/font_Roboto-Bold.ttf"
	condensed = "fonts/font_Roboto-Condensed-Bold.ttf"
	lite = "fonts/font_Roboto-Regular.ttf"
	arcade = "fonts/font_CPMono_Black.otf"
	arcadeborder = "fonts/font_CPMono_BlackBorder2.otf"
	glyphs = "fonts/font_glyphs.ttf"
	mono = "fonts/font_RobotoMono-VariableFont_wght.ttf"
	monodata = "fonts/font_CQMono.otf"
	pixel = 0.711
	title = "fonts/Figtree-Bold.ttf"
	metapics = "fonts/font_metapics.ttf"
}
/*
local pippo1 = fe.add_text ("X",0,0,300,30)
local pippo2 = fe.add_text ("XX",0,30,300,30)
local pippo3 = fe.add_text ("XX",0,60,300,30)
pippo1.font = pippo2.font = pippo3.font = uifonts.mono
pippo1.char_size = pippo2.char_size = pippo3.char_size = 120
pippo1.align = pippo2.align = pippo3.align = Align.TopLeft
pippo2.char_spacing = 3.0
pippo3.char_spacing = 4.0
print ("char width  :" + pippo1.msg_width + "px \n")
print ("char space 1:" + (pippo2.msg_width - 2.0 * pippo1.msg_width) + "\n")
print ("char space 2:" + (pippo3.msg_width - 2.0 * pippo1.msg_width) + "\n")

pluto = 0
*/

local defmessage = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n123456789012345678901234567890123456789012345678901234567890\n3\n4\n5\n6\n7\n8\n9\n0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0\n1\n2\n3\n4\n5\n6\n7\n8\n9"
local columns = 60

function add_box(x, y, w, h, rgb){
	local textbox_0 = fe.add_text(defmessage, x, y, w, h)
	local scalerate = h * 1.0 / 1200
	textbox_0.margin = 50 * scalerate
	textbox_0.word_wrap = true
	textbox_0.set_bg_rgb (rgb[0], rgb[1], rgb[2])
	textbox_0.bg_alpha = 255
	textbox_0.align = Align.TopLeft
	textbox_0.font = uifonts.mono
	textbox_0.zorder = 100
	textbox_0.char_spacing = 1.0

	// First size definition
	local span_area = (w - 2.0 * 50 * scalerate)
	local char_width = span_area * 1.0 / columns
	local char_height = floor(char_width * 1.645)
	textbox_0.char_size = char_height

	// Size correction with spacing
	local char_real_size = (textbox_0.msg_width * 1.0 / (columns + (columns - 1) * 0.125) )

	//local blank_area = span_area - textbox_0.msg_width
	//local delta_pixel = blank_area * 1.0 / (columns - 1)

	local spacing = ( 0.25 + (span_area - columns * char_real_size)*1.0/((columns - 1) * char_real_size) ) * 1.0 / 0.375
	textbox_0.char_spacing = spacing

	print (" span_area:" + span_area + " msg_width:" + textbox_0.msg_width + " char_real_size:" + char_real_size + "\n")


}

for (local i = 0; i <= 300; i = i + 20){
	add_box(0, 1.5*i, 320 + i, 240, [100, i * 100 / 300, 0])
}
