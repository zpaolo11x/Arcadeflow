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

local m_surf = fe.add_surface(tw, th)
m_surf.set_pos(tx, ty)

local m_object = m_surf.add_text( text_to_show, 0, 0, tw, th )
m_object.margin = 10
m_object.set_bg_rgb(0,0,0)
m_object.set_rgb(255, 255, 255)
m_object.bg_alpha = 255
m_object.alpha = 255
m_object.char_size = floor(th * 1.0 / 10)
m_object.word_wrap = true
m_object.align = Align.TopLeft

// Reference text box to compare
local textref = fe.add_text(text_to_show, tw, 0, tw, flh)
textref.align = m_object.align
textref.char_size = m_object.char_size 
textref.margin = m_object.margin
textref.word_wrap = true
textref.style = m_object.style
textref.line_spacing = m_object.line_spacing
textref.set_bg_rgb(0,200,0)
textref.bg_alpha = 128

local textref2 = fe.add_text(text_to_show, 0, th, tw, th)
textref2.align = m_object.align
textref2.char_size = m_object.char_size 
textref2.margin = m_object.margin
textref2.word_wrap = true
textref2.style = m_object.style
textref2.line_spacing = m_object.line_spacing
textref2.set_bg_rgb(0,0,200)
textref2.bg_alpha = 128

local blanktop = fe.add_rectangle(tx, ty, tw, m_object.margin)
local blankbot = fe.add_rectangle(tx,ty + th - m_object.margin,tw,m_object.margin)
blanktop.alpha = blankbot.alpha = 128

function get_line_height()
{
	local temp_msg = m_object.msg
	local temp_first_line_hint = m_object.first_line_hint

	m_object.word_wrap = true
	m_object.msg = "X"
	m_object.first_line_hint = 0
	local f1 = m_object.msg_height
	m_object.msg = "X\nX"
	local f2 = m_object.msg_height

	m_object.msg = temp_msg
	m_object.first_line_hint = temp_first_line_hint

	return (f2 - f1)
}

function get_max_hint(){
	local temp_hint = m_object.first_line_hint

	local t_hint = 1
	m_object.first_line_hint = t_hint
	while (t_hint == m_object.first_line_hint) {
		t_hint ++
		m_object.first_line_hint = t_hint
	}
	local out = m_object.first_line_hint
	
	m_object.first_line_hint = temp_hint

	return (out)
}

local m_line_height = get_line_height()
local m_max_hint = get_max_hint()

function get_visible_lines(){
	local m_area = th - 2.0 * m_object.margin
	local m_1 = m_object.glyph_size - (m_area % m_line_height)
	local m_visible_lines = floor(m_area * 1.0 / m_line_height) + (m_1 > 0 ? 0.0 : 1.0)
	return (m_visible_lines)
}

local m_visible_lines = get_visible_lines()

local m_margin_bottom = m_surf.height - m_object.margin - m_visible_lines * m_line_height

local m_y_start = 0
local m_y_stop = 0
local m_y_speed = null

print ("LINE HEIGHT:" + m_line_height + "\n")
print ("MAX HINT:" + m_max_hint + "\n")
print ("VISIBLE LINES:" + m_visible_lines + "\n")


local m_y_zero = ty - 2.0 * m_line_height
local viewport_max_y = m_max_hint * m_line_height

print (viewport_max_y+"\n")

m_object.y = m_y_zero
m_object.height = th + 4.0 * m_line_height
m_object.msg = " \n \n" + m_object.msg + "\n \n "

local viewport1 = fe.add_rectangle(tw,ty,tw,m_surf.height)
local viewport2 = fe.add_rectangle(tw + m_object.margin,ty + m_object.margin,tw - 2.0 * m_object.margin, m_surf.height - 2.0 * m_object.margin)
viewport1.set_rgb(200,0,0)
viewport1.alpha = 100
viewport2.set_rgb(0,0,200)
viewport2.alpha = 128


function set_viewport(y){
	//print ("y:"+y+" "+"max_y:"+viewport_max_y+"\n")
	if (y <= 0) {
		y = 0
		m_y_start = m_y_stop = y
		m_object.y = m_y_zero
		m_object.first_line_hint = 1
	}
	else if (y >= viewport_max_y){
		print("                    X\n")
		y = viewport_max_y - m_line_height
		m_y_start = m_y_stop = y
		m_object.y = m_y_zero
		m_object.first_line_hint = m_max_hint
	}
	else {
		m_object.y = m_y_zero - y % m_line_height
		m_object.first_line_hint = floor(y * 1.0 / m_line_height) + 1

		textref2.first_line_hint = floor(y * 1.0 / m_line_height) + 1
		m_y_start = y
	}
	viewport1.y = y
	viewport2.y = y + m_object.margin
	//print (viewport1.y+"\n")
}

function goto_start(){
	goto_line(0)
}

function goto_end(){
	goto_line(m_max_hint)
}

function text_up(){
	if (m_y_stop < viewport_max_y - m_line_height - m_margin_bottom) m_y_stop += m_line_height
}

function text_down(){
	if (m_y_stop > 0) m_y_stop -= m_line_height
}

function goto_line(n){
	if (n <= 0) m_y_stop = 0
	else if (n >= m_max_hint) m_y_stop = viewport_max_y - m_line_height
	else m_y_stop = n * m_line_height
}

//set_viewport(viewshift)
//m_object.y = m_y_zero - viewshift
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
		text_down()
		return false
	}
	else if (sig == "down"){
		text_up()
		return false
	}

	else if (sig == "custom1"){
		goto_start()
		return false
	}
	else if (sig == "custom2"){
		goto_end()
		return false
	}
}

function board_on_tick(tick_time){
	print ("start:"+m_y_start+" stop:"+m_y_stop+"\n")
	/*
	viewshift += 20
	print (viewshift+"\n")
	set_viewport(viewshift)
	*/
	if (m_y_start != m_y_stop){
		m_y_speed = 0.15 * (m_y_stop - m_y_start)
		if (absf(m_y_speed) > m_line_height) {
			print ("MAXSPEED\n")
			m_y_speed = (m_y_speed > 0 ? 10 * m_line_height : -10 * m_line_height)
		}
		if (absf(m_y_speed) > 0.0005 * m_line_height) {
			if ((absf(m_y_start - m_y_stop)) > 10000000) {
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
				set_viewport(m_y_start + m_y_speed)
				m_y_start = m_y_start + m_y_speed
			}
		}
		else {
			m_y_start = m_y_stop
			set_viewport (m_y_stop)
		}
	}
}