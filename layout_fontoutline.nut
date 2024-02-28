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

local flw = fe.layout.width
local flh = fe.layout.height

function get_border(font_size){
	local font_bd = {
		w = ceil((4.5 / 100.0) * font_size)
		x = 0
		y = 0
	}
	font_bd.x = ceil(font_bd.w * 0.3)
	font_bd.y = ceil(font_bd.w * 0.7)
	return(font_bd)	
}
function get_border2(font_size){
	local font_bd = {
		w = ceil((4.5 / 100.0) * font_size)
		x = 0
		y = 0
	}
	font_bd.x = (font_bd.w * 0.3)
	font_bd.y = (font_bd.w * 0.7)
	font_bd.y = font_bd.y < 1 ? 1 : font_bd.y
	return(font_bd)	
}
function createtext(message, size, y){
	local span = ceil (flw * 0.33)
	local font_size = size
	local border = 0

	local text0 = fe.add_text(message,0,y,span,flh)
	text0.char_size = font_size
	text0.font = uifonts.arcadeborder
	text0.align = Align.TopLeft
	text0.set_rgb(200,100,100)
	text0.word_wrap = true
	text0.char_spacing = 0.6
	text0.margin = 0

	local text1 = fe.add_text(message,0,y,span,flh)
	text1.char_size = font_size
	text1.font = uifonts.arcade
	text1.align = Align.TopLeft
	text1.set_rgb(255,255,255)
	text1.word_wrap = true
	text1.char_spacing = 0.6
	text1.margin = 0

	border = get_border(font_size)

	local text2 = fe.add_text(message,span + border.x,y + border.y,span,flh)
	text2.char_size = font_size
	text2.font = uifonts.arcade
	text2.outline = border.w
	text2.align = Align.TopLeft
	text2.set_rgb(200,100,100)
	text2.set_outline_rgb(200,100,100)
	text2.word_wrap = true
	text2.char_spacing = 0.6
	text2.margin = 0

	local text3 = fe.add_text(message,span,y,span,flh)
	text3.char_size = font_size
	text3.font = uifonts.arcade
	text3.align = Align.TopLeft
	text3.set_rgb(255,255,255)
	text3.word_wrap = true
	text3.char_spacing = 0.6
	text3.margin = 0

	border = get_border2(font_size)

	local text4 = fe.add_text(message,2*span + border.x,y + border.y,span,flh)
	text4.char_size = font_size
	text4.font = uifonts.arcade
	text4.outline = border.w
	text4.align = Align.TopLeft
	text4.set_rgb(200,100,100)
	text4.set_outline_rgb(200,100,100)
	text4.word_wrap = true
	text4.char_spacing = 0.6
	text4.margin = 0

	local text5 = fe.add_text(message,2*span,y,span,flh)
	text5.char_size = font_size
	text5.font = uifonts.arcade
	text5.align = Align.TopLeft
	text5.set_rgb(255,255,255)
	text5.word_wrap = true
	text5.char_spacing = 0.6
	text5.margin = 0
}

local ypos = 0
for (local i = 10; i <= 200; i = i + 1){
	createtext ("ABC", i, ypos)
	ypos = ypos + i	
}
