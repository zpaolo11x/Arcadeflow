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

	// mk2 Movement helpers
	m_y_start = null
	m_y_stop = null
	m_y_speed = null
	m_y_zero = null

	//TEST mk2 text parameters
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

	m_pong = null
	m_pong_delay = null
	m_pong_count = null
	m_ponging = null
	m_pong_up = null
	m_freezer = null

	m_debug = true

	count = null

	//DEBUG
	m_overlay = null
	m_overlay2 = null
	m_overnum = null

	m_tokens = ["[DisplayName]",
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


	constructor (_t, _x, _y, _w, _h, _surface = null){

      if ( _surface == null ) _surface = ::fe
		m_shader = ::fe.add_shader(Shader.Fragment, "textboard.glsl")

		count = {
			right = 0
			left = 0
			up = 0
			down = 0

			movestart = 20 //was 25, 20 is snappier
			movestep = 0
			movestepslow = 6
			movestepfast = 3 //3 o 4, 3 engages the limit sooner
			movestepdelay = 6
	
			countstep = 0

		}
		
		count.movestep = count.movestepslow



		m_tx_alpha = 255
		m_bg_alpha = 0
		m_alpha = 255

		m_y_start = 0
		m_y_stop = 0
		m_y_speed = null
		m_y_zero = 0

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

		m_pong = false
		m_ponging = false
		m_freezer = 0
		m_pong_delay = 1000
		m_pong_count = 0
		m_pong_up = true

		::fe.add_signal_handler( this, "board_on_signal" )
		::fe.add_ticks_callback( this, "board_on_tick" )
		::fe.add_transition_callback( this, "board_on_transition" )
	}

	function repeatsignal(sig, counter) {
		if (::fe.get_input_state(sig) == false) {
			count.countstep = 0
			count.movestep = count.movestepslow
			return (0)
		}
		else {
			::fe.signal(sig)
			counter ++
			if (counter - count.movestart == count.movestep + 1) {
				counter = count.movestart
				count.countstep ++
				count.movestep = ::floor((count.movestepfast + (count.movestepslow - count.movestepfast) * ::pow(2.7182, -count.countstep / count.movestepdelay))+0.5)
			}
			return counter
		}
	}

	function checkrepeat(counter) {
		return ((counter == 0) || (counter == count.movestart))
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
		m_object.first_line_hint = 0
		local f1 = m_object.msg_height
		m_object.msg = "X\nX"
		local f2 = m_object.msg_height

		m_object.msg = temp_msg
		m_object.first_line_hint = temp_first_line_hint

		return (f2 - f1)
	}

	function split_complete(str_in, separator) {
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

	function get_max_hint(){

		local hint0 = 1
		local hint = 1
		m_object.first_line_hint = 1
		local wraptext = ""
		local lines = 0
		local lines0 = 0
		local overhint = 0

		local t0 = ::fe.layout.time
		::print("START\n")
		m_object.first_line_hint = hint
		lines = split_complete(m_object.msg_wrapped,"\n").len()
		lines0 = lines
			::print ("hint:"+hint+" realflh:"+m_object.first_line_hint+"\n")

		while ((lines0 == lines) && (m_object.first_line_hint == hint)){
			if (m_debug){
			::print ("-------------------------------------------------------------------\n")
			::print ("HINT0:"+hint0+" HINT:"+hint+"\n")
			::print ("LINES0:"+lines0+" LINES:"+lines+"\n")
			::print ("*\n"+m_object.msg_wrapped+"*\n")
			}
			hint0 = hint
			hint = hint + lines - 1
			lines0 = lines
			m_object.first_line_hint = hint
			if (m_object.first_line_hint != hint) overhint = m_object.first_line_hint
			::print ("hint:"+hint+" realflh:"+m_object.first_line_hint+"\n")
			::print ("-------------------------------------------------------------------\n")
			lines = split_complete(m_object.msg_wrapped,"\n").len()	
		}

		::print("STOP\n")

					::print ("-------------------------------------------------------------------\n")
			::print ("HINT0:"+hint0+" HINT:"+hint+"\n")
			::print ("LINES0:"+lines0+" LINES:"+lines+"\n")
			::print ("*\n"+m_object.msg_wrapped+"*\n")
			

		::print ((::fe.layout.time - t0)+"\n")
		local hintmax = (overhint != 0) ? overhint : hint0

		return(hintmax)
		/*
		local t_hint0 = 1
		local t_hint = 1
		local numlines = 0
		local temptext = ""
		::print("visiblelines:"+m_visible_lines+"\n")
		m_object.first_line_hint = t_hint
		while (t_hint == m_object.first_line_hint) {
			temptext = m_object.msg_wrapped
			numlines = split_complete(temptext,"\n").len() - 1
			::print("numlines:"+numlines+"\n")
			::print(temptext+"\n\n")
			t_hint = t_hint + numlines
			m_object.first_line_hint = t_hint
		}
		local out = m_object.first_line_hint
		::print("\n"+m_object.first_line_hint+"\n")
		::print("\n\n\n****\n"+m_object.msg_wrapped+"****\n\n\n")

		return (out)
	*/
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
		::print("1\n")
		m_object.height = m_surf.height
		::print("2\n")
		m_object.msg = m_text
		::print("3\n")
		m_line_height = get_line_height()
		::print("4\n")
		m_visible_lines = get_visible_lines()
		::print("5\n")
		m_max_hint = (m_text == "") ? 0 : get_max_hint()
		::print("6\n")
		m_viewport_max_y = (m_max_hint - 1) * m_line_height

		m_object.y = - 2.0 * m_line_height
		m_object.height = m_surf.height + 4.0 * m_line_height
		m_y_zero = m_object.y
		m_object.msg = " \n \n" + m_text + "\n \n "

		m_object.first_line_hint = 1 //TEST TENERE?

		m_y_start = 0
		m_y_stop = 0
		m_y_speed = null

		m_margin_bottom = m_surf.height - m_object.margin - m_visible_lines * m_line_height
		if (m_margin_bottom < 0) m_margin_bottom = 0
		
		m_shader.set_param("blanktop", m_object.margin * 1.0 / m_surf.height, (m_object.margin + m_line_height * m_line_top) * 1.0 / m_surf.height)
		m_shader.set_param("blankbot", m_margin_bottom * 1.0 / m_surf.height, (m_margin_bottom + m_line_height * m_line_bot) * 1.0 / m_surf.height)
		m_shader.set_param("alphatop", 0.0)
		m_shader.set_param("alphabot", m_max_hint <= 1 ? 0.0 : 1.0)
		//m_shader.set_param("alphabot", tb_bottomchar() == m_ch1 ? 0.0 : 1.0)
		m_freezer = 2

		::print("line height:"+m_line_height+"\n")
		::print("max hint:"+m_max_hint+"\n")
		::print("viewport max:"+m_viewport_max_y+"\n")
		::print("margin bottom:"+m_margin_bottom+"\n")
		::print("\n")

		if (m_pong) {
			m_ponging = false
			m_pong_count = 0
			m_pong_up = true
		}
	}

	function expandtokens(val, index_offset, filter_offset){
		//::print("Expanding tokens: "+m_expand_tokens+"\n")
		if (!m_expand_tokens) return val
		//::print("EXPAND\n")
		local m_infos = infosarray(index_offset, filter_offset)

		local start = null
		local stop = null
		local expanded = val

		foreach (i, item in m_tokens){
			start = expanded.find(item)
			stop = null
			while (start != null){
				//::print (start+"\n")
				stop = start + item.len()
				expanded = expanded.slice(0, start) +m_infos[i] + expanded.slice(stop,expanded.len())
				start = expanded.find(item)
			}
		}
		//::print ("\n"+expanded+"\n")
		return expanded
	}

	function board_on_transition(ttype, var, ttime){
		/*
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
		*/
	}

	function board_on_signal(sig){
		if (!(m_enable_signals && m_object.visible && !m_pong)) return

		if (sig == "up") {
			if (checkrepeat(count.up)) {
				if (m_natural_scroll) line_up() else line_down()
				count.up ++
			}
			return m_signal_block
		}
		if (sig == "down") {
			if (checkrepeat(count.down)) {
				if (m_natural_scroll) line_down() else line_up()
			count.down ++
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

	function cbool(inval){
		return (inval ? "I":"O")
	}
	
	function board_on_tick(tick_time){

	if (count.right != 0) count.right = repeatsignal("right", count.right)
	if (count.left != 0) count.left = repeatsignal("left", count.left)
	if (count.up != 0) count.up = repeatsignal("up", count.up)
	if (count.down != 0) count.down = repeatsignal("down", count.down)



		if (m_debug) {
			m_overnum.msg = m_object.first_line_hint
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

		if (m_y_start != m_y_stop){
			if (m_surf.redraw == false) m_surf.redraw = true
			m_y_speed = 0.15 * (m_y_stop - m_y_start)
			/*
			if (m_absf(m_y_speed) > m_line_height) {
				::print ("MAXSPEED\n")
				m_y_speed = (m_y_speed > 0 ? 10 * m_line_height : -10 * m_line_height)
			}
			*/
			if (m_absf(m_y_speed) > 0.0005 * m_line_height) {
				if ((m_absf(m_y_start - m_y_stop)) > 10000000) {
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
//::print(m_text+"\n")
/*
		if ((m_pong) && (!m_ponging)){
			if (m_pong_count == 0) 
				m_pong_count = ::fe.layout.time + m_pong_delay
			else if (m_pong_count <= ::fe.layout.time) {
				m_pong_count = 0
				m_ponging = true
				if (m_pong_up) line_up() else line_down()
			}
		}
		//::print ("m_move:"+cbool(m_move)+" m_pong_count:"+m_pong_count+" char_size:"+m_object.char_size+"\n")
		//if ((m_move == 0) && (m_surf.redraw = true)) m_surf.redraw = false
		if (m_move != 0) {
			if (m_surf.redraw == false) m_surf.redraw = true
			if (m_move > 0){
				// TEXT GOES DOWN
				m_object.y += m_scroll_speed
				m_move -= m_scroll_speed

				if (tb_topchar() == m_ch2) m_shader.set_param("alphatop", 1.0 - (m_object.y - m_y_zero) * 1.0 / m_line_height)
				if (tb_bottomchar() == m_ch1) m_shader.set_param("alphabot", (m_object.y - m_y_zero) * 1.0 / m_line_height)
				
				if (tb_topchar() == m_ch2) ::print ("alpha:"+(1.0 - (m_object.y - m_y_zero) * 1.0 / m_line_height)+"\n")
				::print ("move:"+m_move+" lheight:" + m_line_height+"\n")
				::print ("move mod:"+(m_move % m_line_height)+"\n")
				if (m_move % m_line_height <= m_scroll_speed) {
					::print("X\n")
					m_line_move = (m_move - (m_move % m_line_height)) * 1.0 / m_line_height
					if (m_hint_delta != 0) {
						m_hint_delta --
						if (m_object.first_line_hint > 1) m_object.first_line_hint --
						if (m_hint_delta == 0)	m_freezer = 2
					}				
					m_object.y = m_y_zero
					m_move = m_line_move * m_line_height
					if (tb_topchar() == m_ch1) {
						m_shader.set_param("alphatop", 0.0)
						m_move = 0				
						m_hint_delta = 0
						if (m_ponging) pong_up()
					} else if (m_ponging) line_down()
				}
			}
			else if (m_move < 0) {
				// TEXT GOES UP
				m_object.y -= m_scroll_speed
				m_move += m_scroll_speed
	
				//if (m_object.first_line_hint == 1)
				if (tb_topchar() == m_ch1) m_shader.set_param("alphatop", - (m_object.y - m_y_zero) * 1.0 / m_line_height)
				if (tb_bottomchar() == m_ch2) m_shader.set_param("alphabot", 1.0 + (m_object.y - m_y_zero) * 1.0 / m_line_height)
	
				if (m_move % m_line_height >= -m_scroll_speed){
					m_line_move = (m_move - (m_move % m_line_height)) * 1.0 / m_line_height
					if (m_hint_delta != 0) {
						m_hint_delta ++
						m_object.first_line_hint ++
						if (m_hint_delta == 0)	m_freezer = 2
					}
					m_object.y = m_y_zero
					m_move = m_line_move * m_line_height
					if (tb_bottomchar() == m_ch1) {
						m_shader.set_param("alphabot", 0.0)
						m_move = 0				
						m_hint_delta = 0
						if (m_ponging) pong_down()
					}
					else if (m_ponging) line_up()
				}
			}
		}
		*/
	}

	function _set( idx, value )
	{
		switch ( idx )
		{
			case "msg":
				::print("                    msgchange\n")
				m_text0 = value
				m_text = expandtokens(m_text0, 0, 0)
				refreshtext()
				break
			
			case "shader":
			case "y":
			case "x":
			case "width":
			case "height":
			case "zorder":
				m_surf[idx] = value
				break

			case "first_line_hint":
				/*
				m_object.first_line_hint = value
				m_shader.set_param("alphabot", tb_bottomchar() == m_ch2 ? 0.0 : 1.0)
				m_shader.set_param("alphatop", tb_topchar() == m_ch1 ? 0.0 : 1.0)
				m_surf.redraw = true
				m_freezer = 2
				*/
				break

			case "visible":
				m_surf.visible = value
				// a change in visibility resets the pong status and message status
				refreshtext()
				if (!value) m_surf.redraw = false
				break

			case "scroll_speed":
				m_scroll_speed = value
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

			case "expand_tokens":
				//::print("Set expand_tokens to:"+value+"\n")
				m_expand_tokens = value
				m_text = expandtokens(m_text0, 0, 0)
				refreshtext()
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
				return (m_visible_lines)
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
			
			case "expand_tokens":
				return m_expand_tokens
				break

			case "scrolling_direction":
				return ((m_move == 0) ? "stop" : ((m_move > 0) ? "down" : "up")) 
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
	
	function tb_topchar(){
		local splitarray = ::split(m_object.msg_wrapped,"\n")
		return (splitarray[0])
	}

	function tb_bottomchar(){
		local splitarray = ::split(m_object.msg_wrapped,"\n")
		return (splitarray[splitarray.len() - 1])				
	}


	function set_viewport(y){
		if (y <= 0) {
			y = 0
			m_y_start = m_y_stop = y
			m_object.y = m_y_zero
			m_object.first_line_hint = 1
		}
		else if (y >= m_viewport_max_y){
			y = m_viewport_max_y
			m_y_start = m_y_stop = y
			m_object.y = m_y_zero
			m_object.first_line_hint = m_max_hint
		}
		else {
			m_object.y = m_y_zero - y % m_line_height
			m_object.first_line_hint = ::floor(y * 1.0 / m_line_height) + 1
			m_y_start = y
		}
		if (y <= m_line_height) m_shader.set_param("alphatop", y * 1.0 / m_line_height)
		else if (y >= m_viewport_max_y - m_line_height) m_shader.set_param("alphabot",(((m_viewport_max_y - y)*1.0/m_line_height)))
		else { 		//TEST CHECK
			m_shader.set_param("alphatop",1.0)
			m_shader.set_param("alphabot",1.0)
		}
		//::print("FLH:"+m_object.first_line_hint+"\n")
		//viewport1.y = y
		//viewport2.y = y + m_object.margin
		//print (viewport1.y+"\n")
	}

	function goto_start(){
		goto_line(0)
	}

	function goto_end(){
		goto_line(m_max_hint)
	}

	function line_up(){
		::print ("LINE UP           m_y_stop:"+m_y_stop+"\n")
		if (m_y_stop < m_viewport_max_y ) m_y_stop += m_line_height
	}

	function line_down(){
		::print ("LINE DN           m_y_stop:"+m_y_stop+"\n")
		if (m_y_stop > 0) m_y_stop -= m_line_height
	}

	function goto_line(n){
		if (n <= 0) m_y_stop = 0
		else if (n >= m_max_hint) m_y_stop = m_viewport_max_y
		else m_y_stop = n * m_line_height
	}

	function pong_down(){
		m_ponging = false
		m_pong_count = 0
		m_pong_up = false
	}

	function pong_up(){
		m_ponging = false
		m_pong_count = 0
		m_pong_up = true
	}

	function refresh(){
		m_shader.set_param("alphabot", tb_bottomchar() == m_ch2 ? 0.0 : 1.0)
		m_shader.set_param("alphatop", tb_topchar() == m_ch1 ? 0.0 : 1.0)
		m_surf.redraw = true
		m_freezer = 2
	}
}

fe.add_textboard_mk2 <- textboard_mk2
