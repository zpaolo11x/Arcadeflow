// This line loads the module nut file.
fe.do_nut( "textboard_MKII.nut" )

local flw = fe.layout.width
local flh = fe.layout.height

local bg = fe.add_rectangle(0,0,flw,flh )
bg.set_rgb(0,100,100)
bg.alpha = 255

local text_to_show = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque lobortis euismod nunc id accumsan. In vitae ultrices neque. Morbi vestibulum nibh et velit euismod eleifend. Curabitur at sodales ligula. Aliquam dapibus ipsum purus, non sollicitudin arcu gravida non. Etiam eleifend eleifend nibh. Nullam a nisi quam. Sed at dui nulla. Curabitur euismod ut nisl non dignissim. Integer semper condimentum ipsum ac dapibus. Donec vulputate, magna eu dignissim suscipit, ante sapien commodo libero, vel lobortis ante justo sit amet neque. Morbi vitae viverra est. Proin nulla elit, dapibus id sapien in, rutrum congue quam. Sed id sapien congue, faucibus libero eu, varius orci. Cras vestibulum erat sed semper luctus.\nSTOP"

local tw = flw * 0.5
local th = flh
local tx = 0
local ty = 0

local tboard_surf = fe.add_surface(tw, th)
tboard_surf.set_pos(tx, ty)

local tboard_object = tboard_surf.add_text( text_to_show, 0, 0, tw, th )
tboard_object.margin = 30
tboard_object.set_bg_rgb(0,0,0)
tboard_object.set_rgb(255, 255, 255)
tboard_object.bg_alpha = 255
tboard_object.alpha = 255
tboard_object.char_size = floor(th * 1.0 / 20)
tboard_object.word_wrap = true
tboard_object.align = Align.TopLeft

// Reference text box to compare
local textref = fe.add_text(text_to_show, tw, 0, tw, th)
textref.align = tboard_object.align
textref.char_size = tboard_object.char_size 
textref.margin = tboard_object.margin
textref.word_wrap = true
textref.line_spacing = tboard_object.line_spacing


local blanktop = fe.add_rectangle(tx, ty, tw, tboard_object.margin)
local blankbot = fe.add_rectangle(tx,ty + th - tboard_object.margin,tw,tboard_object.margin)

function getlineheight()
{
	local temp_msg = tboard_object.msg
	local temp_first_line_hint = tboard_object.first_line_hint

	tboard_object.word_wrap = true
	tboard_object.msg = "X"
	tboard_object.first_line_hint = 0
	local f1 = tboard_object.msg_height
	tboard_object.msg = "X\nX"
	local f2 = tboard_object.msg_height
	tboard_object.msg = temp_msg
	tboard_object.first_line_hint = temp_first_line_hint

	return (f2 - f1)
}

local tboard_line_height = getlineheight()

local viewshift = -2.5*tboard_line_height

local viewportblank = fe.add_rectangle(tw,ty,tw,viewshift+tboard_object.margin)
viewportblank.set_rgb(200,0,0)
viewportblank.alpha = 128

local y0 = ty

function set_viewport(y){
	if (y <= 0) {
		tboard_object.y = y0
		tboard_object.first_line_hint = 1
		return
	} 
	tboard_object.y = y0 - y % tboard_line_height
	tboard_object.first_line_hint = floor(y * 1.0 / tboard_line_height)+1
}

set_viewport(viewshift)
//tboard_object.y = y0 - viewshift
/*
local overlay = fe.add_rectangle (tboard.x + tboard.margin, tboard.y + tboard.margin, tboard.width - 2 * tboard.margin, tboard.height - 2 * tboard.margin)
overlay.set_rgb(200, 0, 0)
overlay.alpha = 100
*/
fe.add_ticks_callback( this, "board_on_tick" )

function board_on_tick(tick_time){
	viewshift += 20
	print (viewshift+"\n")
	set_viewport(viewshift)

}