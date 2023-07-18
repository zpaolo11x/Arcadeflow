// TEXT BOARD OBJECT

/*
Add text board to a layout by first enabling the module using:
fe.do_nut ("path_to/textboard.nut")
then add a textboard object the same way a text object is added:
fe.add_textboard(text, x, y, width, height)

Differences from text object:
- textboard is always word wrapped
- default char size is such that at least two or three lines of text are always visible

New properties:
- scroll_speed = speed of scrolling when going up or down
- natural_scroll_scroll = true or false reverses scrolling direction
- enable_signals = enable/disable signal response for scrolling
- signal_block = if true no further up or down signals are managed
*/

class textboard
{
	m_object = null
	m_surf = null
	m_blank_top = null
	m_blank_bot = null
	m_line_top = null
	m_line_bot = null

	m_move = null
	m_line_move = null
	m_hint_delta = null
	m_y_zero = null
	m_step = null
	m_text = null
	m_margin = null
	m_bufferlines = null
	m_shader = null

	m_check = null

	// Reas/write properties
	m_scroll_speed = null
	m_natural_scroll = null
	m_enable_signals = null
	m_signal_block = null
	m_tx_alpha = null
	m_bg_alpha = null
	m_alpha = null

	// Read only properties
	m_line_height = null
	m_visible_lines = null

	constructor (_t, _x, _y, _w, _h, _surface = null){
      if ( _surface == null ) _surface = ::fe
		::print (_x+" "+_y+" "+_w+" "+_h+"\n")
		
		m_shader = ::fe.add_shader(Shader.Fragment, "textboard.glsl")

		m_check = 0

		m_tx_alpha = 255
		m_bg_alpha = 0
		m_alpha = 255

		m_move = 0
		m_line_move = 0
		m_hint_delta = 0
		m_y_zero = 0 //_y
		m_step = 1

		m_scroll_speed = 1
		m_line_height = null
		m_natural_scroll = false
		m_enable_signals = false
		m_signal_block = true

		m_text = _t
		m_margin = 0

		m_surf = _surface.add_surface(_w, _h)
		m_surf.set_pos(_x, _y)
		m_object = m_surf.add_text( "\n\n" + m_text + "\n\n", 0, 0, _w, _h )
		m_object.margin = m_margin
		m_object.set_bg_rgb(0,0,0)
		m_object.set_rgb(255, 255, 255)
		m_object.bg_alpha = 255
		m_object.alpha = 255

		m_blank_top = 0.0
		m_blank_bot = 1.0
		m_line_top = 1.0
		m_line_bot = 1.0
/*
		m_blank_top = m_surf.add_rectangle(0, 0, _w, m_margin)
		m_blank_top.set_rgb(0,0,0)
		m_blank_top.alpha = 128

		m_blank_bot = m_surf.add_rectangle(0, _h - m_margin, _w, m_margin)
		m_blank_bot.set_rgb(0,0,0)
		m_blank_bot.alpha = 128
*/
		m_object.word_wrap = true
		m_object.char_size = _h / 4
		refreshtext()

		m_surf.shader = m_shader
		m_shader.set_param("textcolor", 1, 1, 1)
		m_shader.set_param("panelcolor", 0, 0, 0)
		m_shader.set_param("textalpha", 1)
		m_shader.set_param("panelalpha", 0)
		m_shader.set_param("wholealpha", 1)
		m_shader.set_param("alphatop", m_blank_top)
		m_shader.set_param("alphabot", m_blank_bot)

		m_object.first_line_hint = 1

		::fe.add_signal_handler( this, "board_on_signal" )
		::fe.add_ticks_callback( this, "board_on_tick" )
	}

	function getlineheight()
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

		::print("LH:"+(f2-f1)+"\n")
		return (f2 - f1)
	}

	function refreshtext(){
		m_line_height = getlineheight()
		m_bufferlines = ::floor(m_object.margin * 1.0 / m_line_height) + 2
		m_object.y = - 1.0 * m_line_height * m_bufferlines
		m_object.height = m_surf.height + 2.0 * m_line_height * m_bufferlines
		m_y_zero = m_object.y
		local temptext = ""
		for (local i =0; i < m_bufferlines; i++){
			temptext += "\n"
		}
		temptext += m_text
		for (local i =0; i < m_bufferlines; i++){
			temptext += "\n"
		}
		m_object.msg = temptext

		local marginbottom = ((m_surf.height - 2.0 * m_object.margin) % m_line_height) + m_object.margin

		m_shader.set_param("blanktop", m_object.margin * 1.0 / m_surf.height, (m_object.margin + m_line_height * m_line_top) * 1.0 / m_surf.height)
		m_shader.set_param("blankbot", marginbottom * 1.0 / m_surf.height, (marginbottom + m_line_height * m_line_bot) * 1.0 / m_surf.height)

	}

	function board_on_signal(sig){
		if (!(m_enable_signals && m_object.visible)) return

		local step = m_natural_scroll ? -1 : 1
		if (sig == "up") {
			if (m_natural_scroll) line_up() else line_down()
			return m_signal_block
		}
		if (sig == "down") {
			if (m_natural_scroll) line_down() else line_up()
			return m_signal_block
		}			
	}

	function board_on_tick(tick_time){
		if (m_move != 0) {
			if (m_move > 0){
				::print(m_object.first_line_hint+"\n")
				// TEXT GOES DOWN
				m_object.y += m_scroll_speed
				m_move -= m_scroll_speed

				if (m_object.first_line_hint == 2) m_shader.set_param("alphatop", 1.0 - (m_object.y - m_y_zero) * 1.0 / m_line_height)

				if (m_move % m_line_height <= m_scroll_speed) {
					m_line_move = (m_move - (m_move % m_line_height)) / m_line_height
					if (m_hint_delta != 0) {
						m_hint_delta --
						if (m_object.first_line_hint > 1) m_object.first_line_hint --
					}				
					m_object.y = m_y_zero
					m_move = m_line_move * m_line_height
				}
			}
			else if (m_move < 0) {
				// TEXT GOES UP
				m_object.y -= m_scroll_speed
				m_move += m_scroll_speed
	
				if (m_object.first_line_hint == 1) m_shader.set_param("alphatop", - (m_object.y - m_y_zero) * 1.0 / m_line_height)
	
				if (m_move % m_line_height >= -m_scroll_speed){
					m_line_move = (m_move - (m_move % m_line_height)) / m_line_height
					if (m_hint_delta != 0) {
						m_hint_delta ++
						m_object.first_line_hint ++
					}
					m_object.y = m_y_zero
					m_move = m_line_move * m_line_height
				}
			}
		}
	}

	function _set( idx, value )
	{
		switch ( idx )
		{
			case "msg":
				m_text = value
				refreshtext()
				m_object.first_line_hint = 1
				break
			
			case "visible":
			case "shader":
			case "y":
			case "x":
			case "width":
			case "height":
			case "zorder":
				m_surf[idx] = value
				break

			case "scroll_speed":
				m_scroll_speed = value
				break

			case "signal_block":
				m_signal_block = value
				break

			case "natural_scroll":
				m_natural_scroll = value
				m_step = m_natural_scroll ? -1 : 1
				break

			case "enable_signals":
				m_enable_signals = value
				break

			case "word_wrap":
				break

			case "line_spacing":
				m_object.line_spacing = value
				refreshtext()
				break

			case "char_size":
				m_object.char_size = value
				refreshtext()
				break

			case "margin":
				m_object.margin = value
				refreshtext()
				break
			case "tx_alpha":
				m_tx_alpha = value
				m_shader.set_param("textalpha", value * 1.0 / 255)
				break
			
			case "bg_alpha":
				m_bg_alpha = value
				m_shader.set_param("panelalpha", value * 1.0 / 255)
				break

			case "alpha":
				m_alpha = value
				m_shader.set_param("wholealpha", value * 1.0 / 255)
				break

			case "lines_bottom":
				m_line_bot = value
				refreshtext()
				break
			
			case "lines_top":
				m_line_top = value
				refreshtext()
				break

			default:
   			m_object[idx] = value
		}
	}

	function _get( idx )
	{
		switch ( idx )
		{
			case "visible":
			case "shader":
			case "x":
			case "y":
			case "width":
			case "height":
			case "zorder":
				return m_surf[idx]
				break
			
			case "msg":
				return m_text
				break

			case "scroll_speed":
				return m_scroll_speed
				break
			
			case "visible_lines":
				return (::round((m_surf.height - 2 * m_object.margin) * 1.0 / m_line_height, 1))
				break

			case "line_height":
				return m_line_height
				break
				
			case "natural_scroll":
				return m_natural_scroll
				break
				
			case "enable_signals":
				return m_enable_signals
				break
				
			case "signal_block":
				return m_signal_block
				break

			case "tx_alpha":
				return m_tx_alpha
				break

			case "bg_alpha":
				return m_tx_alpha
				break

			case "alpha":
				return m_tx_alpha
				break

			default:
			   return m_object[idx]
		}
	}

	function set_rgb( r, g, b )
	{
		m_shader.set_param("textcolor", r*1.0/255, g*1.0/255, b*1.0/255)
	}

	function set_bg_rgb( r, g, b )
	{
		m_shader.set_param("panelcolor", r*1.0/255, g*1.0/255, b*1.0/255)
	}
	
	function line_down(){
		//if (m_object.first_line_hint + m_hint_delta + 1 > 2){
			m_hint_delta += 1
			m_move += m_line_height
		//}
	}
	function line_up(){
		//if ((m_object.first_line_hint + m_hint_delta + m_step > 2) && (m_step > 0)){
			m_hint_delta -= 1
			m_move -= m_line_height
		//}
	}
}

fe.add_textboard <- textboard
