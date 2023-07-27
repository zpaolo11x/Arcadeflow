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
- pingpong = makes the text scroll up and down automatically
*/

class textboard_mk3
{
	// mk2 Objects
	m_object = null
	m_surf = null

	// mk2 Blanking parameters
	m_line_top = null
	m_line_bot = null

	// mk2 Read only properties
	m_line_height = null
	m_visible_lines = null
	m_viewport_max_y = null
	m_max_hint = null
	m_full_lines = null

	m_target_line = 1

	// mk2 Movement helpers
	// This are not set by the user
	// who sets bong_speed and scroll_speed
	m_y_start = null
	m_y_stop = null
	m_y_shift = null
	m_y_zero = null
	m_y_pong_speed = null

	m_hint_new = null

	// mk2 text parameters
	m_text = null
	m_margin = null
	m_margin_bottom = null
	m_shader = null

	// Reas/write properties
	m_natural_scroll = null
	m_enable_signals = null
	m_signal_block = null
	m_tx_alpha = null
	m_bg_alpha = null
	m_alpha = null

	// Pingpong properties
	m_pong_delay = null
	m_pong_count = null
	m_ponging = null
	m_pong_up = null
	
	m_pong = null
	m_scroll_pulse = null
	m_pong_speed = null

	// Performace management properties
	m_freezer = null
	tick_time_0 = null
	tick_elapse = null


	m_count = null

	// DEBUG
	m_debug = true
	m_overlay = null
	m_overlay2 = null
	m_overnum = null
	textref2 = null

	constructor (_t, _x, _y, _w, _h, _surface = null){
		tick_time_0 = 0
		tick_elapse = 0

      if (_surface == null) _surface = ::fe
		m_shader = ::fe.add_shader(Shader.Fragment, "glsl/textboard.glsl")

		m_count = {
			right = 0
			left = 0
			up = 0
			down = 0

			movestart = 20
			movestep = 0
			movestepslow = 6
			movestepfast = 3
			movestepdelay = 6
	
			countstep = 0
		}

		foreach (item, value in m_count) m_count[item] = ::ceil(value * ScreenRefreshRate / 60.0)
		m_count.movestep = m_count.movestepslow

		m_tx_alpha = 255
		m_bg_alpha = 0
		m_alpha = 255

		m_y_start = 0
		m_y_stop = 0
		m_y_shift = null
		m_y_zero = 0
		m_y_pong_speed = 0

		m_scroll_pulse = 1.0

		m_line_height = null
		m_natural_scroll = false
		m_enable_signals = false
		m_signal_block = true

		m_text = _t

		m_margin = 0

		m_surf = _surface.add_surface(_w, _h)
		m_surf.set_pos(_x, _y)
		m_object = m_surf.add_text( "", 0, 0, _w, _h )
		m_object.margin = m_margin
		m_object.set_bg_rgb(0,0,0)
		m_object.set_rgb(255, 255, 255)
		m_object.bg_alpha = 255
		m_object.alpha = 255

		if (m_debug){
			m_overlay = ::fe.add_rectangle(_w,0,_w,1)
			m_overlay2 = ::fe.add_rectangle(_w,0,_w,_h)
			m_overlay2.set_rgb(200,0,0)
			m_overlay2.alpha = 120
			m_overnum = ::fe.add_text(m_object.first_line_hint,0,::fe.layout.height*0.5, ::fe.layout.width*0.5,::fe.layout.height*0.5)
		
			textref2 = ::fe.add_text("", 0, m_surf.height, m_surf.width, m_surf.height)
			textref2.align = m_object.align
			textref2.char_size = m_object.char_size 
			textref2.margin = m_object.margin
			textref2.word_wrap = true
			textref2.line_spacing = m_object.line_spacing
			textref2.set_bg_rgb(200,100,0)
			textref2.bg_alpha = 120
		}

		m_line_top = 1.0
		m_line_bot = 1.0

		m_object.word_wrap = true
		m_object.char_size = _h / 4

		refreshtext()

		m_surf.shader = m_shader
		m_shader.set_param("textcolor", 1, 1, 1)
		m_shader.set_param("panelcolor", 0, 0, 0)
		m_shader.set_param("textalpha", 1)
		m_shader.set_param("panelalpha", 0)
		m_shader.set_param("wholealpha", 1)

		m_hint_new = 1

		m_pong = false
		m_ponging = false
		m_freezer = 0
		m_pong_delay = 1000
		m_pong_count = 0
		m_pong_up = true
		m_pong_speed = 1.0

		::fe.add_signal_handler( this, "board_on_signal" )
		::fe.add_ticks_callback( this, "board_on_tick" )
		::fe.add_transition_callback( this, "board_on_transition" )
	}

	function dbprint(text){
		if (m_debug) ::print(text)
	}

	function m_repeatsignal(sig, counter) {
		if (::fe.get_input_state(sig) == false) {
			m_count.countstep = 0
			m_count.movestep = m_count.movestepslow
			return (0)
		}
		else {
			::fe.signal(sig)
			counter ++
			if (counter - m_count.movestart == m_count.movestep + 1) {
				counter = m_count.movestart
				m_count.countstep ++
				m_count.movestep = ::floor((m_count.movestepfast + (m_count.movestepslow - m_count.movestepfast) * ::pow(2.7182, -m_count.countstep / m_count.movestepdelay))+0.5)
			}
			return counter
		}
	}

	function m_checkrepeat(counter) {
		return ((counter == 0) || (counter == m_count.movestart))
	}

	function m_absf(n) {
		return (n >= 0 ? n : -n)
	}

	function m_split_complete(str_in, separator) {
		local outarray = []
		local index = str_in.find(separator)
		while (index != null) {
			outarray.push(str_in.slice(0, index))
			str_in = str_in.slice(index + separator.len())
			index = str_in.find(separator)
		}
		outarray.push(str_in)
		return outarray
	}

	function m_char_replace(inputstring, old, new) {
		local out = ""
		local splitarray = m_split_complete (inputstring, old)
		foreach (id, item in splitarray) {
			out = out + (id > 0 ? new : "") + item
		}
		return out
	}

	function get_visible_lines(){
		local m_area = m_surf.height - 2.0 * m_object.margin
		local m_1 = m_object.glyph_size - (m_area % m_line_height)
		local visible_lines = ::floor(m_area * 1.0 / m_line_height) + (m_1 > 0 ? 0.0 : 1.0)
		return (visible_lines)
	}

	function refreshtext(){
		m_surf.redraw = true
		m_object.y = 0
		m_object.height = m_surf.height
		m_object.msg = m_text
		m_object.word_wrap = true
		m_object.first_line_hint = 1

		if (m_debug) {		
			textref2.msg = m_text
			textref2.align = m_object.align
			textref2.char_size = m_object.char_size 
			textref2.margin = m_object.margin
			textref2.line_spacing = m_object.line_spacing
			textref2.first_line_hint = 1
		}

		m_line_height = m_object.line_size
		m_visible_lines = m_object.lines
		m_full_lines = m_object.lines_total
		m_max_hint = m_full_lines - m_visible_lines + 1
		
		if (m_max_hint <= 0) m_max_hint = 1

		m_viewport_max_y = (m_max_hint - 1) * m_line_height

		m_object.y = - 2.0 * m_line_height
		m_object.height = m_surf.height + 4.0 * m_line_height
		m_y_zero = m_object.y

		m_object.msg = " \n \n" + m_text + "\n \n "
		//m_object.word_wrap = true
		//m_object.first_line_hint = 1

		//m_object.first_line_hint = 1 //TEST needed?
		m_hint_new = 1

		m_y_start = 0
		m_y_stop = 0
		m_y_shift = null

		m_margin_bottom = m_surf.height - m_object.margin - m_visible_lines * m_line_height
		if (m_margin_bottom < 0) m_margin_bottom = 0
		
		m_shader.set_param("blanktop", m_object.margin * 1.0 / m_surf.height, (m_object.margin + m_line_height * m_line_top) * 1.0 / m_surf.height)
		m_shader.set_param("blankbot", m_margin_bottom * 1.0 / m_surf.height, (m_margin_bottom + m_line_height * m_line_bot) * 1.0 / m_surf.height)
		m_shader.set_param("alphatop", 0.0)
		m_shader.set_param("alphabot", m_max_hint <= 1 ? 0.0 : 1.0)
		//m_shader.set_param("alphabot", tb_bottomchar() == m_ch1 ? 0.0 : 1.0)
		m_freezer = 2

		dbprint("line height:"+m_line_height+"\n")
		dbprint("visible lines:"+m_visible_lines+"\n")
		dbprint("all lines:"+m_full_lines+"\n")
		dbprint("max hint:"+m_max_hint+"\n")
		dbprint("viewport max:"+m_viewport_max_y+"\n")
		dbprint("margin bottom:"+m_margin_bottom+"\n")
		dbprint("\n")

		if (m_pong) pong_up()
	}

	function resetstatus()
	{
		m_object.first_line_hint = 1 //TEST needed?

		m_surf.redraw = true
		m_object.y = 0
		
		m_object.y = - 2.0 * m_line_height
		m_y_zero = m_object.y

		m_hint_new = 1

		m_y_start = 0
		m_y_stop = 0
		m_y_shift = null

		m_shader.set_param("blanktop", m_object.margin * 1.0 / m_surf.height, (m_object.margin + m_line_height * m_line_top) * 1.0 / m_surf.height)
		m_shader.set_param("blankbot", m_margin_bottom * 1.0 / m_surf.height, (m_margin_bottom + m_line_height * m_line_bot) * 1.0 / m_surf.height)
		m_shader.set_param("alphatop", 0.0)
		m_shader.set_param("alphabot", m_max_hint <= 1 ? 0.0 : 1.0)
		m_freezer = 2
	
		if (m_pong) pong_up()
		
	}

	function board_on_transition(ttype, var, ttime){
		//TEST NEEDED FOR PING PONG?
		if ((ttype == Transition.FromOldSelection) || (ttype == Transition.ToNewList)) {
			if (m_pong) pong_up()
			refreshtext()
		}
		
	}

	function board_on_signal(sig){
		if (!(m_enable_signals && m_object.visible)) return// && !m_pong)) return

		if (sig == "up") {
			if (m_checkrepeat(m_count.up)) {
				if (m_natural_scroll) line_up() else line_down()
				m_count.up ++
			}
			return m_signal_block
		}
		if (sig == "down") {
			if (m_checkrepeat(m_count.down)) {
				if (m_natural_scroll) line_down() else line_up()
			m_count.down ++
			}
			return m_signal_block
		}	
		if (sig == "left"){
			goto_start()
			return m_signal_block
		}		
			if (sig == "right"){
			goto_end()
			return m_signal_block
		}
	}
	
	function board_on_tick(tick_time){
		tick_elapse = tick_time - tick_time_0
		tick_time_0 = tick_time

		if (m_count.right != 0) m_count.right = m_repeatsignal("right", m_count.right)
		if (m_count.left != 0) m_count.left = m_repeatsignal("left", m_count.left)
		if (m_count.up != 0) m_count.up = m_repeatsignal("up", m_count.up)
		if (m_count.down != 0) m_count.down = m_repeatsignal("down", m_count.down)

		if (m_debug) {
			m_overnum.msg = m_object.first_line_hint+" / "+m_max_hint
			m_overnum.char_size = 20

			m_overlay.y = m_viewport_max_y
			m_overlay2.y = m_y_stop
		}

		if (m_freezer == 1) {
			m_freezer -- 
			m_surf.clear = false
			m_surf.redraw = false
		}

		if (m_freezer == 2) m_freezer --

		if (!m_surf.visible) return

		if ((m_pong) && (!m_ponging)){
			if (m_pong_count == 0){
				m_pong_count = ::fe.layout.time + m_pong_delay
			}
			else if (m_pong_count <= ::fe.layout.time) {
				m_pong_count = 0
				m_ponging = true
				if (m_pong_up) m_y_pong_speed = (m_pong_speed * m_line_height * 1.0 / 1000) else m_y_pong_speed = -1.0 * (m_pong_speed * m_line_height * 1.0 / 1000)
			}
		}
		
		if (m_y_pong_speed != 0) {
			if (m_surf.redraw == false) m_surf.redraw = true
			m_y_stop += m_y_pong_speed * tick_elapse
		}

		if ((m_y_start != m_y_stop) || (m_y_pong_speed != 0)){
			if (m_surf.redraw == false) m_surf.redraw = true

			m_y_shift = m_scroll_pulse * (m_y_stop - m_y_start) * 60.0 / ScreenRefreshRate

			if (m_absf(m_y_shift) > 0.0005 * m_line_height) {
				set_viewport(m_y_start + m_y_shift)
				m_y_start = m_y_start + m_y_shift
			}
			else {
				m_y_start = m_y_stop
				set_viewport (m_y_stop)
			}
		}		
	}

	function _set( idx, value )
	{
		switch ( idx )
		{
			case "font":
			case "line_spacing":
			case "char_size":
			case "margin":
				m_object[idx] = value
				refreshtext()
				break


			case "msg":
				m_text = value
				refreshtext()
				break

			case "y":
			case "x":
			case "width":
			case "height":
			case "zorder":
				m_surf[idx] = value
				break

			case "visible":
				m_surf.visible = value
				// a change in visibility resets the pong status and message status
				resetstatus()
				if (!value) m_surf.redraw = false
				break

			case "signal_block":
				m_signal_block = value
				break

			case "natural_scroll":
				m_natural_scroll = value
				break

			case "enable_signals":
				m_enable_signals = value
				break

			case "first_line_hint":
			case "shader":
			case "word_wrap":
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
				resetstatus()
				break
			
			case "lines_top":
				m_line_top = value
				resetstatus()
				break

			case "target_line":
				goto_line(target_line)
				break

			case "pingpong_delay":
				m_pong_delay = value * 1000
				break

			case "pingpong":
				m_pong = value
				pong_up()
				break

			case "scroll_pulse":
				m_scroll_pulse = value
				break

			case "pingpong_speed":
				m_pong_speed = value
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
			
			case "target_line":
				return m_target_line
				break

			case "visible_lines":
				return m_visible_lines
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
				return m_bg_alpha
				break

			case "alpha":
				return m_alpha
				break

			case "full_lines":
				return m_full_lines
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

	function set_viewport(y){
		if (y <= 0) {
			y = 0
			m_y_start = m_y_stop = y
			m_object.y = m_y_zero
			m_hint_new = 1
			if (m_object.first_line_hint != m_hint_new) m_object.first_line_hint = m_hint_new
			if (m_ponging) pong_up()
		}
		else if (y >= m_viewport_max_y){
			y = m_viewport_max_y
			m_y_start = m_y_stop = y
			m_object.y = m_y_zero
			m_hint_new = m_max_hint
			if (m_object.first_line_hint != m_hint_new) m_object.first_line_hint = m_hint_new
			if (m_ponging) pong_down()
		}
		else {
			m_object.y = m_y_zero - y % m_line_height

			m_hint_new = ::floor(y * 1.0 / m_line_height) + 1
			if (m_object.first_line_hint != m_hint_new) m_object.first_line_hint = m_hint_new
			m_y_start = y
		}


		if ((y > m_line_height) && (y < m_viewport_max_y - m_line_height)){ //TEST can be improved by not applying at every redraw
			m_shader.set_param("alphatop", 1.0)
			m_shader.set_param("alphabot", 1.0)
		} else {
			if (y <= m_line_height) {
				m_shader.set_param("alphatop", y * 1.0 / m_line_height)
			}
			if (y >= m_viewport_max_y - m_line_height) {
				m_shader.set_param("alphabot", (((m_viewport_max_y - y) * 1.0 / m_line_height)))
			}
		}
	}

	function goto_start()
	{
		if (m_debug) textref2.first_line_hint = 1
		m_target_line = 1
		goto_line(1)
	}

	function goto_end()
	{
		if (m_debug) textref2.first_line_hint = m_max_hint
		m_target_line = m_max_hint
		goto_line(m_max_hint)
	}

	function line_up()
	{
		if (m_y_stop < m_viewport_max_y ) {
			if (m_debug) textref2.first_line_hint = textref2.first_line_hint + 1
			m_y_stop += m_line_height
			m_target_line ++
		}
	}

	function line_down()
	{
		if (m_y_stop > 0) {
			if (m_debug) textref2.first_line_hint = textref2.first_line_hint - 1
			m_y_stop -= m_line_height
			m_target_line --
		}
	}

	function goto_line(n)
	{
		if (n <= 1) {
			m_y_stop = 0
			m_target_line = 1
		}
		else if (n >= m_max_hint) {
			m_y_stop = m_viewport_max_y
			m_target_line = m_max_hint
		}
		else {
			m_y_stop = n * m_line_height
			m_target_line = n
		}
	}

	function pong_down()
	{
		m_ponging = false
		m_pong_count = 0
		m_pong_up = false
		m_y_pong_speed = 0
	}

	function pong_up()
	{
		m_ponging = false
		m_pong_count = 0
		m_pong_up = true
		m_y_pong_speed = 0
	}
}

fe.add_textboard_mk3 <- textboard_mk3
