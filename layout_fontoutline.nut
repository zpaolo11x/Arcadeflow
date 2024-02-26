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

local message = "HFXJIKLO"
local font_size = 125
local border_size = (4.5 / 100.0) * font_size
local border_offset_x = border_size * 0.3
local border_offset_y = border_size * 0.7

print ("border_size:"+border_size+"\n")

local text0 = fe.add_text(message,0,0,flw*0.5,flh)
text0.char_size = font_size
text0.font = uifonts.arcadeborder
text0.align = Align.MiddleCentre
text0.set_rgb(200,100,100)
text0.word_wrap = true
text0.char_spacing = 0.6

local text1 = fe.add_text(message,0,0,flw*0.5,flh)
text1.char_size = font_size
text1.font = uifonts.arcade
text1.align = Align.MiddleCentre
text1.set_rgb(255,255,255)
text1.word_wrap = true
text1.char_spacing = 0.6

local text2 = fe.add_text(message,flw*0.5 + border_offset_x,border_offset_y,flw*0.5,flh)
text2.char_size = font_size
text2.font = uifonts.arcade
text2.outline = border_size
text2.align = Align.MiddleCentre
text2.set_rgb(200,100,100)
text2.set_outline_rgb(200,200,100)
text2.word_wrap = true
text2.char_spacing = 0.6

local text3 = fe.add_text(message,flw*0.5,0,flw*0.5,flh)
text3.char_size = font_size
text3.font = uifonts.arcade
text3.align = Align.MiddleCentre
text3.set_rgb(255,255,255)
text3.word_wrap = true
text3.char_spacing = 0.6

text0.alpha = text2.alpha = 150
text1.visible = text3.visible = false