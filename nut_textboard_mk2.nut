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

class textboard_mk2
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
	m_full_text = null
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
	m_text0 = null
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
	m_expand_tokens = null

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

	m_tokens = [
		"[DisplayName]",
		"[ListSize]",
		"[ListEntry]",
		"[FilterName]",
		"[Search]",
		"[SortName]",
		"[Name]",
		"[Title]",
		"[Emulator]",
		"[CloneOf]",
		"[Year]",
		"[Manufacturer]",
		"[Category]",
		"[Players]",
		"[Rotation]",
		"[Control]",
		"[Status]",
		"[DisplayCount]",
		"[DisplayType]",
		"[AltRomname]",
		"[AltTitle]",
		"[PlayedTime]",
		"[PlayedCount]",
		"[SortValue]",
		"[System]",
		"[SystemN]",
		"[Overview]"
	]

	m_char_table = {
		a = ["à","á","â","ã","ä"],
		c = ["ç"],
		e = ["è","é","ê","ë"],
		i = ["ì","í","î","ï"],
		n = ["ñ"],
		o = ["ò","ó","ô","õ","ö"],
		s = ["š"],
		u = ["ú","ù","û","ü"],
		y = ["ý","ÿ"],
		z = ["ž"],
		A = ["À","Á","Â","Ã","Ä"],
		C = ["Ç"],
		E = ["È","É","Ê","Ë"],
		I = ["Ì","Í","Î","Ï"],
		N = ["Ñ"],
		O = ["Ò","Ó","Ô","Õ","Ö"],
		S = ["Š"],
		U = ["Ú","Ù","Û","Ü"],
		Y = ["Ý","Ÿ"],
		Z = ["Ž"]
	}

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
		m_expand_tokens = true

		m_text0 = _t
		m_text = expandtokens(m_text0, 0, 0)

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

		m_object.first_line_hint = 1
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

	function infosarray(index_offset, filter_offset){ 
		return ([::fe.displays[::fe.list.display_index].name,
					::fe.list.size,
					::fe.list.index,
					::fe.filters[::fe.list.filter_index].name,
					::fe.list.search_rule,
					::fe.list.sort_by,
					::fe.game_info(Info.Name, index_offset, filter_offset),
					::fe.game_info(Info.Title, index_offset, filter_offset),
					::fe.game_info(Info.Emulator, index_offset, filter_offset),
					::fe.game_info(Info.CloneOf, index_offset, filter_offset),
					::fe.game_info(Info.Year, index_offset, filter_offset),
					::fe.game_info(Info.Manufacturer, index_offset, filter_offset),
					::fe.game_info(Info.Category, index_offset, filter_offset),
					::fe.game_info(Info.Players, index_offset, filter_offset),
					::fe.game_info(Info.Rotation, index_offset, filter_offset),
					::fe.game_info(Info.Control, index_offset, filter_offset),
					::fe.game_info(Info.Status, index_offset, filter_offset),
					::fe.game_info(Info.DisplayCount, index_offset, filter_offset),
					::fe.game_info(Info.DisplayType, index_offset, filter_offset),
					::fe.game_info(Info.AltRomname, index_offset, filter_offset),
					::fe.game_info(Info.AltTitle, index_offset, filter_offset),
					::fe.game_info(Info.PlayedTime, index_offset, filter_offset),
					::fe.game_info(Info.PlayedCount, index_offset, filter_offset),
					::fe.game_info(Info.SortValue, index_offset, filter_offset),
					::fe.game_info(Info.System, index_offset, filter_offset),
					::fe.game_info(Info.System, index_offset, filter_offset),
					::fe.game_info(Info.Overview, index_offset, filter_offset)
					])
	}

	function get_line_height()
	{
		local temp_msg = m_object.msg
		local temp_first_line_hint = m_object.first_line_hint

		m_object.word_wrap = true
		m_object.msg = "X"
		m_object.first_line_hint = 1
		local f1 = m_object.msg_height
		m_object.msg = "X\nX"
		local f2 = m_object.msg_height
		m_object.msg = temp_msg
		m_object.first_line_hint = temp_first_line_hint

		return (f2 - f1)
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

	function text_cleanup(input_text){
		foreach (good_char, bad_char_array in m_char_table){
			foreach (i, bad_char in bad_char_array){
				input_text = m_char_replace(input_text, bad_char, good_char)
			}
		}
		return input_text
	}

	function get_full_text(tbox){
		local fulltext = ""
		local starthint = tbox.first_line_hint

		local hint = 1
		tbox.first_line_hint = hint

		local text_part = tbox.msg_wrapped
		local numlines = m_split_complete(text_part, "\n").len() - 1

		while (hint == tbox.first_line_hint){
			fulltext += text_part
			hint = hint + numlines
			tbox.first_line_hint = hint
			text_part = tbox.msg_wrapped
		}

		local deltalines = hint - tbox.first_line_hint

		local endlines = m_split_complete(tbox.msg_wrapped,"\n")

		if (deltalines != m_visible_lines){
			for (local i = deltalines; i < endlines.len() - 2; i++) {
				fulltext += endlines[i] + "\n"
			}
			fulltext += endlines[endlines.len() - 2]
		} else {
			fulltext = fulltext.slice(0, -1)
		}
		tbox.first_line_hint = starthint

		return fulltext

	}

	function get_max_hint(){
		
		local hint0 = 1
		local hint = 1
		m_object.first_line_hint = 1

		local wraptext = ""
		local lines = 0
		local lines0 = 0
		local overhint = 0

		dbprint("OBJECT MESSAGE\n"+m_object.msg+"\n")

		local oldmsg = m_object.msg
		m_object.msg = text_cleanup(oldmsg)

		local t0 = ::fe.layout.time

		m_object.first_line_hint = hint
		lines = m_split_complete(m_object.msg_wrapped,"\n").len()
		lines0 = lines
		
		dbprint("hint:"+hint+" realflh:"+m_object.first_line_hint+"\n")

		while ((lines0 == lines) && (m_object.first_line_hint == hint)){
			dbprint("-------------------------------------------------------------------\n")
			dbprint("HINT0:"+hint0+" HINT:"+hint+"\n")
			dbprint("LINES0:"+lines0+" LINES:"+lines+"\n")
			dbprint("*\n"+m_object.msg_wrapped+"*\n")
			
			hint0 = hint
			hint = hint + lines - 1
			lines0 = lines
			m_object.first_line_hint = hint
			if (m_object.first_line_hint != hint) overhint = m_object.first_line_hint

			dbprint ("hint:"+hint+" realflh:"+m_object.first_line_hint+"\n")
			dbprint ("-------------------------------------------------------------------\n")

			lines = m_split_complete(m_object.msg_wrapped,"\n").len()	
		}

		dbprint("STOP\n")

		dbprint("-------------------------------------------------------------------\n")
		dbprint("HINT0:"+hint0+" HINT:"+hint+"\n")
		dbprint("LINES0:"+lines0+" LINES:"+lines+"\n")
		dbprint("*\n"+m_object.msg_wrapped+"*\n")
			

		dbprint((::fe.layout.time - t0)+"\n")

		local hintmax = (overhint != 0) ? overhint : hint0
		m_object.msg = oldmsg

		return(hintmax)
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

		if (m_debug) {		
			textref2.msg = m_text
			textref2.align = m_object.align
			textref2.char_size = m_object.char_size 
			textref2.margin = m_object.margin
			textref2.line_spacing = m_object.line_spacing
			textref2.first_line_hint = 1
		}

		m_line_height = get_line_height()
		m_visible_lines = get_visible_lines()
		m_full_text = (m_text == "") ? "" : get_full_text(m_object)

		m_full_lines = m_split_complete(m_full_text,"\n").len()
		m_max_hint = m_full_lines - m_visible_lines + 1//(m_text == "") ? 0 : get_max_hint()

		if (m_max_hint <= 0) m_max_hint = 1

		m_viewport_max_y = (m_max_hint - 1) * m_line_height

		m_object.y = - 2.0 * m_line_height
		m_object.height = m_surf.height + 4.0 * m_line_height
		m_y_zero = m_object.y
		m_object.msg = " \n \n" + m_text + "\n \n "

		m_object.first_line_hint = 1 //TEST needed?
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
		dbprint("max hint:"+m_max_hint+"\n")
		dbprint("viewport max:"+m_viewport_max_y+"\n")
		dbprint("margin bottom:"+m_margin_bottom+"\n")
		dbprint("num lines:"+m_full_lines+"\n")
		dbprint("visible lines:"+m_visible_lines+"\n")
		dbprint("\n")

		if (m_pong) {
			m_ponging = false
			m_pong_count = 0
			m_pong_up = true
			m_y_pong_speed = 0
		}
	}

	function resetstatus()
	{
		m_surf.redraw = true
		m_object.y = 0
		
		m_object.y = - 2.0 * m_line_height
		m_y_zero = m_object.y

		m_object.first_line_hint = 1 //TEST needed?
		m_hint_new = 1

		m_y_start = 0
		m_y_stop = 0
		m_y_shift = null

		m_shader.set_param("blanktop", m_object.margin * 1.0 / m_surf.height, (m_object.margin + m_line_height * m_line_top) * 1.0 / m_surf.height)
		m_shader.set_param("blankbot", m_margin_bottom * 1.0 / m_surf.height, (m_margin_bottom + m_line_height * m_line_bot) * 1.0 / m_surf.height)
		m_shader.set_param("alphatop", 0.0)
		m_shader.set_param("alphabot", m_max_hint <= 1 ? 0.0 : 1.0)
		m_freezer = 2
	
		if (m_pong) {
			m_ponging = false
			m_pong_count = 0
			m_pong_up = true
		}		
	}

	function expandtokens(val, index_offset, filter_offset){
		if (!m_expand_tokens) return val

		local m_infos = infosarray(index_offset, filter_offset)
		
		local start = null
		local stop = null
		local expanded = val

		foreach (i, item in m_tokens){
			start = expanded.find(item)
			stop = null
			while (start != null){
				stop = start + item.len()
				expanded = expanded.slice(0, start) +m_infos[i] + expanded.slice(stop,expanded.len())
				start = expanded.find(item)
			}
		}
		return expanded
	}

	function board_on_transition(ttype, var, ttime){
		if (!m_expand_tokens) return

		if ((ttype == Transition.ToNewSelection) || (ttype == Transition.ToNewList)) {
			if (m_pong) {
				m_ponging = false
				m_pong_count = 0
				m_pong_up = true
			}
			local index_offset = (ttype == Transition.ToNewSelection) ? var : 0
			local filter_offset = (ttype == Transition.ToNewList) ? var : 0
			m_text = expandtokens(m_text0, index_offset, filter_offset)
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
			
			/*
			if (m_absf(m_y_shift) > m_line_height) {
				m_y_shift = (m_y_shift > 0 ? m_line_height : -1.0 * m_line_height)
			}
			*/

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
			case "msg":
				m_text0 = value
				m_text = expandtokens(m_text0, 0, 0)
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

			case "font":
			case "line_spacing":
			case "char_size":
			case "margin":
				m_object[idx] = value
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
				resetstatus()
				break
			
			case "lines_top":
				m_line_top = value
				resetstatus()
				break

			case "expand_tokens":
				m_expand_tokens = value
				m_text = expandtokens(m_text0, 0, 0)
				refreshtext()
				break

			case "target_line":
				goto_line(target_line)
				break

			case "pingpong_delay":
				m_pong_delay = value * 1000
				break

			case "pingpong":
				m_pong = value
				m_ponging = false
				m_pong_count = 0
				m_pong_up = true
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
			
			case "expand_tokens":
				return m_expand_tokens
				break

			case "full_text":
				return m_full_text
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
			m_shader.set_param("alphatop",1.0)
			m_shader.set_param("alphabot",1.0)
		} else {
			if (y <= m_line_height) {
				m_shader.set_param("alphatop", y * 1.0 / m_line_height)
			}
			if (y >= m_viewport_max_y - m_line_height) {
				m_shader.set_param("alphabot",(((m_viewport_max_y - y)*1.0/m_line_height)))
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

fe.add_textboard_mk2 <- textboard_mk2
