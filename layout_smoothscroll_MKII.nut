// This line loads the module nut file.
fe.do_nut( "textboard_MKII.nut" )

function absf(n) {
	return (n >= 0 ? n : -n)
}

local flw = fe.layout.width
local flh = fe.layout.height

local bg = fe.add_rectangle(0,0,flw,flh )
bg.set_rgb(0,100,100)
bg.alpha = 255

local text_to_show = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque lobortis euismod nunc id accumsan. In vitae ultrices neque. Morbi vestibulum nibh et velit euismod eleifend. Curabitur at sodales ligula. Aliquam dapibus ipsum purus, non sollicitudin arcu gravida non. Etiam eleifend eleifend nibh. Nullam a nisi quam. Sed at dui nulla. Curabitur euismod ut nisl non dignissim. Integer semper condimentum ipsum ac dapibus."// Donec vulputate, magna eu dignissim suscipit, ante sapien commodo libero, vel lobortis ante justo sit amet neque. Morbi vitae viverra est. Proin nulla elit, dapibus id sapien in, rutrum congue quam. Sed id sapien congue, faucibus libero eu, varius orci. Cras vestibulum erat sed semper luctus.\nSTOP"
//text_to_show += "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque lobortis euismod nunc id accumsan. In vitae ultrices neque. Morbi vestibulum nibh et velit euismod eleifend. Curabitur at sodales ligula. Aliquam dapibus ipsum purus, non sollicitudin arcu gravida non. Etiam eleifend eleifend nibh. Nullam a nisi quam. Sed at dui nulla. Curabitur euismod ut nisl non dignissim. Integer semper condimentum ipsum ac dapibus. Donec vulputate, magna eu dignissim suscipit, ante sapien commodo libero, vel lobortis ante justo sit amet neque. Morbi vitae viverra est. Proin nulla elit, dapibus id sapien in, rutrum congue quam. Sed id sapien congue, faucibus libero eu, varius orci. Cras vestibulum erat sed semper luctus.\nSTOP"

local tw = flw * 0.5
local th = flh * 0.5
local tx = 0
local ty = 0

local tboard_surf = fe.add_surface(tw, th)
tboard_surf.set_pos(tx, ty)

local tboard_object = tboard_surf.add_text( text_to_show, 0, 0, tw, th )
tboard_object.margin = 10
tboard_object.set_bg_rgb(0,0,0)
tboard_object.set_rgb(255, 255, 255)
tboard_object.bg_alpha = 255
tboard_object.alpha = 255
tboard_object.style = Style.Bold
tboard_object.char_size = floor(th * 1.0 / 10)
tboard_object.word_wrap = true
tboard_object.align = Align.TopLeft

// Reference text box to compare
local textref = fe.add_text(text_to_show, tw, 0, tw, flh)
textref.align = tboard_object.align
textref.char_size = tboard_object.char_size 
textref.margin = tboard_object.margin
textref.word_wrap = true
textref.style = tboard_object.style
textref.line_spacing = tboard_object.line_spacing
textref.set_bg_rgb(0,200,0)
textref.bg_alpha = 128

local textref2 = fe.add_text(text_to_show, 0, th, tw, th)
textref2.align = tboard_object.align
textref2.char_size = tboard_object.char_size 
textref2.margin = tboard_object.margin
textref2.word_wrap = true
textref2.style = tboard_object.style
textref2.line_spacing = tboard_object.line_spacing
textref2.set_bg_rgb(0,0,200)
textref2.bg_alpha = 128

local blanktop = fe.add_rectangle(tx, ty, tw, tboard_object.margin)
local blankbot = fe.add_rectangle(tx,ty + th - tboard_object.margin,tw,tboard_object.margin)
blanktop.alpha = blankbot.alpha = 128

function get_line_height()
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

function get_max_hint(){
	local temp_hint = tboard_object.first_line_hint

	local t_hint = 1
	tboard_object.first_line_hint = t_hint
	while (t_hint == tboard_object.first_line_hint) {
		t_hint ++
		tboard_object.first_line_hint = t_hint
	}
	local out = tboard_object.first_line_hint
	tboard_object.first_line_hint = temp_hint
	
	return (out)
}

local tboard_line_height = get_line_height()
local tboard_max_hint = get_max_hint()

function get_visible_lines(){
	local m_area = th - 2.0 * tboard_object.margin
	local m_1 = tboard_object.glyph_size - (m_area % tboard_line_height)
	local m_visible_lines = ::floor(m_area * 1.0 / tboard_line_height) + (m_1 > 0 ? 0.0 : 1.0)
	return (m_visible_lines)
}

local tboard_visible_lines = get_visible_lines()

local marginbottom = tboard_surf.height - tboard_object.margin - tboard_visible_lines * tboard_line_height

local bstart = 0
local bstop = 0
local bspeed = null

print ("LINE HEIGHT:" + tboard_line_height + "\n")
print ("MAX HINT:" + tboard_max_hint + "\n")
print ("VISIBLE LINES:" + tboard_visible_lines + "\n")


local y0 = ty - 2.0 * tboard_line_height
local viewport_max_y = tboard_max_hint * tboard_line_height

print (viewport_max_y+"\n")

tboard_object.y = y0
tboard_object.height = th + 4.0 * tboard_line_height
tboard_object.msg = " \n \n" + tboard_object.msg + "\n \n "

local viewport1 = fe.add_rectangle(tw,ty,tw,tboard_surf.height)
local viewport2 = fe.add_rectangle(tw + tboard_object.margin,ty + tboard_object.margin,tw - 2.0 * tboard_object.margin, tboard_surf.height - 2.0 * tboard_object.margin)
viewport1.set_rgb(200,0,0)
viewport1.alpha = 100
viewport2.set_rgb(0,0,200)
viewport2.alpha = 128


function set_viewport(y){
	//print ("y:"+y+" "+"max_y:"+viewport_max_y+"\n")
	if (y <= 0) {
		y = 0
		bstart = bstop = y
		tboard_object.y = y0
		tboard_object.first_line_hint = 1
	}
	else if (y >= viewport_max_y){
		print("                    X\n")
		y = viewport_max_y - tboard_line_height
		bstart = bstop = y
		tboard_object.y = y0
		tboard_object.first_line_hint = tboard_max_hint
	}
	else {
		tboard_object.y = y0 - y % tboard_line_height
		tboard_object.first_line_hint = floor(y * 1.0 / tboard_line_height) + 1

		textref2.first_line_hint = floor(y * 1.0 / tboard_line_height) + 1
		bstart = y
	}
	viewport1.y = y
	viewport2.y = y + tboard_object.margin
	//print (viewport1.y+"\n")
}

function goto_line(n){
	if (n <= 0) bstop = 0
	else if (n >= tboard_max_hint) bstop = viewport_max_y - tboard_line_height
	else bstop = n * tboard_line_height
}

//set_viewport(viewshift)
//tboard_object.y = y0 - viewshift
/*
local overlay = fe.add_rectangle (tboard.x + tboard.margin, tboard.y + tboard.margin, tboard.width - 2 * tboard.margin, tboard.height - 2 * tboard.margin)
overlay.set_rgb(200, 0, 0)
overlay.alpha = 100
*/


fe.add_signal_handler( this, "board_on_signal" )
fe.add_ticks_callback( this, "board_on_tick" )
fe.add_transition_callback( this, "board_on_transition" )

function board_on_signal(sig){
	if (sig == "up") {
		//TEST METTERE QUI MARGINBOTTOM
		if (bstop < viewport_max_y - tboard_line_height - marginbottom) bstop += tboard_line_height
		return false
	}
	else if (sig == "down"){
		if (bstop > 0) bstop -= tboard_line_height
		return false
	}

	else if (sig == "custom1"){

		set_viewport(viewport_max_y)
		return false
	}
	else if (sig == "custom2"){
		goto_line(3)
		return false
	}
}

function board_on_tick(tick_time){
	print ("start:"+bstart+" stop:"+bstop+"\n")
	/*
	viewshift += 20
	print (viewshift+"\n")
	set_viewport(viewshift)
	*/
	if (bstart != bstop){
		bspeed = 0.15 * (bstop - bstart)
		if (absf(bspeed) > tboard_line_height) {
			print ("MAXSPEED\n")
			bspeed = (bspeed > 0 ? 10 * tboard_line_height : -10 * tboard_line_height)
		}
		if (absf(bspeed) > 0.0005 * tboard_line_height) {
			if ((absf(bstart - bstop)) > 10000000) {
				/*
				disp.xstart = disp.xstop
				for (local i = 0; i < disp.images.len(); i++) {
					disp.images[i].y = disp.pos0[i] + disp.xstop
				}
				disp.bgshadowb.y = disp.images[zmenu.selected].y + disp.images[zmenu.selected].height
				disp.bgshadowt.y = disp.images[zmenu.selected].y - disp.bgshadowt.height
				*/
			}
			else {
				set_viewport(bstart + bspeed)
				bstart = bstart + bspeed
			}
		}
		else {
			bstart = bstop
			set_viewport (bstop)
		}
	}
}