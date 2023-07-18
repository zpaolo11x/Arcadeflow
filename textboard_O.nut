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
	m_cut_top = null
	m_cut_bot = null
	m_add_top = null
	m_add_bot = null

	m_move = null
	m_line_move = null
	m_hint_delta = null
	m_y_zero = null
	m_step = null
	m_text = null
	m_bufferlines = null

	// Reas/write properties
	m_scroll_speed = null
	m_natural_scroll = null
	m_enable_signals = null
	m_signal_block = null

	// Read only properties
	m_line_height = null
	m_visible_lines = null

	constructor (_t, _x, _y, _w, _h, _surface = null){
      if ( _surface == null ) _surface = ::fe
		//::print (_x+" "+_y+" "+_w+" "+_h+"\n")
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

		m_surf = _surface.add_surface(_w, _h)
		m_surf.set_pos(_x, _y)
		m_object = m_surf.add_text( "\n\n" + m_text + "\n\n", 0, 0, _w, _h )
		
		m_object.margin = 0

		m_cut_top = m_surf.add_rectangle(0, 0, m_surf.width, m_object.margin)
		m_cut_bot = m_surf.add_rectangle(0, m_surf.height - m_cut_top.height, m_surf.width, m_cut_top.height)
		m_cut_top.blend_mode = BlendMode.Subtract
		m_cut_bot.blend_mode = BlendMode.Subtract
		m_add_top = m_surf.add_rectangle(0, 0, m_cut_top.width, m_cut_top.height)
		m_add_bot = m_surf.add_rectangle(0, m_cut_bot.y, m_cut_bot.width, m_cut_bot.height)

		m_object.word_wrap = true
		m_object.char_size = _h / 4
		refreshtext()
		/*
		m_line_height = getlineheight()

		m_object.y = - 2.0 * m_line_height
		m_object.height = _h + 4.0 * m_line_height
		m_y_zero = m_object.y
		*/
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

		//::print("LH:"+(f2-f1)+"\n")
		return (f2 - f1)
	}

	function refreshtext(){
		m_line_height = getlineheight()
		m_bufferlines = ::floor(m_object.margin * 1.0 / m_line_height) + 2
		//::print("BLINES:"+m_bufferlines+"\n")
		m_object.y = - 1.0 * m_line_height * m_bufferlines
		m_object.height = m_surf.height + 2.0 * m_line_height * m_bufferlines
		m_y_zero = m_object.y
		local temptext = ""
		for (local i =0; i < m_bufferlines; i++){
			::print ("1-LINEADD\n")
			temptext += "\n"
		}
		temptext += m_text
		for (local i =0; i < m_bufferlines; i++){
			::print ("2-LINEADD\n")
			temptext += "\n"
		}
		m_object.msg = temptext
		m_cut_top.set_pos(0, 0, m_surf.width, m_object.margin)
		m_cut_bot.set_pos(0, m_surf.height - m_cut_top.height, m_surf.width, m_cut_top.height)
		m_add_top.set_pos(m_cut_top.x, m_cut_top.y, m_cut_top.width, m_cut_top.height)
		m_add_bot.set_pos(m_cut_bot.x, m_cut_bot.y, m_cut_bot.width, m_cut_bot.height)
		//::print("*\n"+m_object.msg+"\n*\n")
	}

	function board_on_signal(sig){
		if (!(m_enable_signals && m_object.visible)) return

		local step = m_natural_scroll ? -1 : 1
		if (sig == "up") {
			m_hint_delta += step
			m_move += step * m_line_height
			return m_signal_block
		}
		if (sig == "down") {
			m_hint_delta -= step
			m_move -= step * m_line_height
			return m_signal_block
		}			
	}

	function board_on_tick(tick_time){
		if (m_move != 0) {
			::print (m_move+"\n")
			if (m_move > 0) {
				m_object.y += m_scroll_speed
				m_move -= m_scroll_speed
				if (m_move % m_line_height <= m_scroll_speed) {
					m_line_move = (m_move - (m_move % m_line_height)) / m_line_height
					if (m_hint_delta != 0) {
						m_hint_delta --
						m_object.first_line_hint --
						if (m_object.first_line_hint == 0) m_object.first_line_hint = 1
					}				
					m_object.y = m_y_zero
					m_move = m_line_move * m_line_height
				}
			}
			else 	if (m_move < 0) {
				m_object.y -= m_scroll_speed
				m_move += m_scroll_speed
				if (m_move % m_line_height >= -m_scroll_speed){
					m_line_move = (m_move - (m_move % m_line_height)) / m_line_height
					if (m_hint_delta != 0) {
						::print("XXX\n")
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

			default:
   			m_object[idx] = value
		}
	}

	function _get( idx )
	{
		switch ( idx )
		{
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
				//::print ("m_surf.height:" + m_surf.height+"\n")
				//::print ("m_object.margin:" + m_object.margin+"\n")
				//::print ("m_line_height:" + m_line_height+"\n")
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
			
			default:
			   return m_object[idx]
		}
	}

	function set_rgb( r, g, b )
	{
		m_object.set_rgb( r, g, b )
	}

	function set_bg_rgb( r, g, b )
	{
		m_object.set_bg_rgb( r, g, b )
		m_add_top.set_rgb( r, g, b )
		m_add_bot.set_rgb( r, g, b )
	}
	function line_down(){
			m_hint_delta -= m_step
			m_move -= m_step * m_line_height
	}
	function line_up(){
			m_hint_delta += m_step
			m_move += m_step * m_line_height
	}
}

fe.add_textboard <- textboard
