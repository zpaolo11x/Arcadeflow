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

	m_move = null
	m_line_move = null
	m_hint_delta = null
	m_y_zero = null
	m_step = null

	m_scroll_speed = null
	m_natural_scroll = null
	m_enable_signals = null
	m_signal_block = null

	m_line_height = null
	m_natural_scroll = null
	m_enable_signals = null
	m_signal_block = null

	constructor (_t, _x, _y, _w, _h, _surface = null){
      if ( _surface == null ) _surface = ::fe

		m_move = 0
		m_line_move = 0
		m_hint_delta = 0
		m_y_zero = _y
		m_step = 1

		m_scroll_speed = 1
		m_line_height = null
		m_natural_scroll = false
		m_enable_signals = false
		m_signal_block = true

		m_object = _surface.add_text( _t, _x, _y, _w, _h )
		m_object.word_wrap = true
		m_object.char_size = _h / 4
		m_line_height = getlineheight()
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
				m_object.msg = value
				m_line_height = getlineheight()
				m_object.first_line_hint = 1
				break
			
			case "y":
				m_object.y = value
				m_y_zero = value
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

			case "char_size":
				m_object.char_size = value
				m_line_height = getlineheight()
				break

			default:
   			m_object[idx] = value
		}
	}

	function _get( idx )
	{
		switch ( idx )
		{
			case "scroll_speed":
				return m_scroll_speed
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
