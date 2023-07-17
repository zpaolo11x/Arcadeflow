class textboard
{
	m_object = null
	m_line_height = null

	m_move = 0
	m_speed = 0.5
	m_line_move = 0
	m_hint_delta = 0
	m_y_zero = null

	constructor (_t, _x, _y, _w, _h, _s){
		m_y_zero = _y
	
		m_object = ::fe.add_text( _t, _x, _y, _w, _h )
		m_line_height = getlineheight()

		::fe.add_signal_handler( this, "board_on_signal" )
		::fe.add_ticks_callback( this, "board_on_tick" )
	}

	function getlineheight()
	{
		// Use this function after setting font char_size and line_height,
		// and before setting the actual message, line_hint and word_wrap
		local temp_msg = m_object.msg
		local temp_first_line_hint = m_object.first_line_hint
		local temp_word_wrap = m_object.word_wrap

		m_object.word_wrap = true
		m_object.msg = "XXX"
		m_object.first_line_hint = 0
		local f1 = m_object.msg_height

		m_object.msg = "XXX\nXXX"
		local f2 = m_object.msg_height
		
		m_object.word_wrap = temp_word_wrap
		m_object.msg = temp_msg
		m_object.first_line_hint = temp_first_line_hint

		return (f2 - f1)
	}

	function board_on_signal(sig){
		if (sig == "up") {
			m_hint_delta --
			m_move = m_move - m_line_height
			return true
		}
		if (sig == "down") {
			m_hint_delta ++
			m_move = m_move + m_line_height
			return true
		}			
	}

	function board_on_tick(tick_time){
	if (m_move != 0) {
		if (m_move > 0) {
			m_object.y += m_speed
			m_move -= m_speed
			if (m_move % m_line_height <= m_speed) {
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
			m_object.y -= m_speed
			m_move += m_speed
			if (m_move % m_line_height >= -m_speed){
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

	function _set( idx, val )
	{
		switch ( idx )
		{
			case "msg":
				m_object.msg = val
				m_line_height = getlineheight()
				break

			case "char_size":
				m_object.char_size = val
				m_line_height = getlineheight()
				break

			default:
   			m_object[idx] = val
		}
	}

	function _get( idx )
	{
		switch ( idx )
		{
			case "line_height":
				return m_line_height

			default:
			   return m_object[idx]
		}
	}
}

fe.add_textboard <- textboard
