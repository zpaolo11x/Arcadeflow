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

	m_move = 0
	m_line_move = 0
	m_hint_delta = 0
	m_y_zero = null
	m_step = 1

	val = {
		line_height = null

		scroll_speed = 1
		natural_scroll = false
		enable_signals = false
		signal_block = true
	}

	constructor (_t, _x, _y, _w, _h){
		m_y_zero = _y
	
		m_object = ::fe.add_text( _t, _x, _y, _w, _h )
		m_object.word_wrap = true
		m_object.char_size = _h / 4
		val.line_height = getlineheight()
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

		return (f2 - f1)
	}

	function board_on_signal(sig){
		if (!(val.enable_signals && m_object.visible)) return

		local step = val.natural_scroll ? -1 : 1
		if (sig == "up") {
			m_hint_delta += step
			m_move += step * val.line_height
			return val.signal_block
		}
		if (sig == "down") {
			m_hint_delta -= step
			m_move -= step * val.line_height
			return val.signal_block
		}			
	}

	function board_on_tick(tick_time){
		if (m_move != 0) {
			if (m_move > 0) {
				m_object.y += val.scroll_speed
				m_move -= val.scroll_speed
				if (m_move % val.line_height <= val.scroll_speed) {
					m_line_move = (m_move - (m_move % val.line_height)) / val.line_height
					if (m_hint_delta != 0) {
						m_hint_delta --
						m_object.first_line_hint --
						if (m_object.first_line_hint == 0) m_object.first_line_hint = 1
					}				
					m_object.y = m_y_zero
					m_move = m_line_move * val.line_height
				}
			}
			else 	if (m_move < 0) {
				m_object.y -= val.scroll_speed
				m_move += val.scroll_speed
				if (m_move % val.line_height >= -val.scroll_speed){
					m_line_move = (m_move - (m_move % val.line_height)) / val.line_height
					if (m_hint_delta != 0) {
						m_hint_delta ++
						m_object.first_line_hint ++
					}
					m_object.y = m_y_zero
					m_move = m_line_move * val.line_height
				}
			}
		}
	}

	function _set( idx, value )
	{
		switch ( idx )
		{
			case "msg":
				m_object.msg = value
				val.line_height = getlineheight()
				m_object.first_line_hint = 1
				break
			
			case "y":
				m_object.y = value
				m_y_zero = value
				break

			case "signal_block":
			case "natural_scroll":
			case "scroll_speed":
			case "enable_signals":
				val[idx] = value
				m_step = val.natural_scroll ? -1 : 1
				break

			case "word_wrap":
				break

			case "char_size":
				m_object.char_size = value
				val.line_height = getlineheight()
				break

			default:
   			m_object[idx] = value
		}
	}

	function _get( idx )
	{
		switch ( idx )
		{
			case "line_height":
			case "natural_scroll":
			case "scroll_speed":
			case "enable_signals":
			case "signal_block":
				return val[idx]
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
	}
	function line_down(){
			m_hint_delta -= m_step
			m_move -= m_step * val.line_height
	}
	function line_up(){
			m_hint_delta += m_step
			m_move += m_step * val.line_height
	}
}


fe.add_textboard <- textboard
