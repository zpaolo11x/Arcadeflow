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
	m_text0 = null
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
	m_expand_tokens = null

	m_pong = null
	m_pong_delay = null
	m_pong_count = null
	m_ponging = null
	m_pong_up = null
	m_freezer = null

	m_ch1 = " "
	m_ch2 = "  "

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

	// Read only properties
	m_line_height = null
	m_visible_lines = null

	constructor (_t, _x, _y, _w, _h, _surface = null){

      if ( _surface == null ) _surface = ::fe
		//::print(Info.Name+"\n")
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
		m_expand_tokens = true

		m_text0 = _t
		m_text = expandtokens(m_text0, 0)
		m_margin = 0

		m_surf = _surface.add_surface(_w, _h)
		m_surf.set_pos(_x, _y)
		m_object = m_surf.add_text( "", 0, 0, _w, _h )
		m_object.margin = m_margin
		m_object.set_bg_rgb(0,0,0)
		m_object.set_rgb(255, 255, 255)
		m_object.bg_alpha = 255
		m_object.alpha = 255

		m_blank_top = 0.0
		m_blank_bot = 1.0
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

	function infosarray(var){ 
		return ([::fe.displays[::fe.list.display_index].name,
					::fe.list.size,
					::fe.list.index,
					::fe.filters[::fe.list.filter_index].name,
					::fe.list.search_rule,
					::fe.list.sort_by,
					::fe.game_info(Info.Name, var),
					::fe.game_info(Info.Title, var),
					::fe.game_info(Info.Emulator, var),
					::fe.game_info(Info.CloneOf, var),
					::fe.game_info(Info.Year, var),
					::fe.game_info(Info.Manufacturer, var),
					::fe.game_info(Info.Category, var),
					::fe.game_info(Info.Players, var),
					::fe.game_info(Info.Rotation, var),
					::fe.game_info(Info.Control, var),
					::fe.game_info(Info.Status, var),
					::fe.game_info(Info.DisplayCount, var),
					::fe.game_info(Info.DisplayType, var),
					::fe.game_info(Info.AltRomname, var),
					::fe.game_info(Info.AltTitle, var),
					::fe.game_info(Info.PlayedTime, var),
					::fe.game_info(Info.PlayedCount, var),
					::fe.game_info(Info.SortValue, var),
					::fe.game_info(Info.System, var),
					::fe.game_info(Info.System, var),
					::fe.game_info(Info.Overview, var)
					])
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

	function refreshtext(){
		m_surf.redraw = true
		m_line_height = getlineheight()
		
		m_object.y = - 2.0 * m_line_height
		m_object.height = m_surf.height + 4.0 * m_line_height
		m_y_zero = m_object.y
		m_object.msg = m_ch1 + "\n" + m_ch2 + "\n" + m_text + "\n" + m_ch2 + "\n" + m_ch1

		m_object.first_line_hint = 1
		m_hint_delta = 0
		m_move = 0

		local m_area = m_surf.height - 2.0 * m_object.margin
		local m_1 = m_object.glyph_size - (m_area % m_line_height)
		m_visible_lines = ::floor(m_area * 1.0 / m_line_height) + (m_1 > 0 ? 0.0 : 1.0)

		local marginbottom = m_surf.height - m_object.margin - m_visible_lines * m_line_height

		m_shader.set_param("blanktop", m_object.margin * 1.0 / m_surf.height, (m_object.margin + m_line_height * m_line_top) * 1.0 / m_surf.height)
		m_shader.set_param("blankbot", marginbottom * 1.0 / m_surf.height, (marginbottom + m_line_height * m_line_bot) * 1.0 / m_surf.height)
		m_shader.set_param("alphatop", 0.0)
		m_shader.set_param("alphabot", tb_bottomchar() == m_ch1 ? 0.0 : 1.0)
		m_freezer = 2
	}

	function expandtokens(val, var){
		//::print("Expanding tokens: "+m_expand_tokens+"\n")
		if (!m_expand_tokens) return val
		//::print("EXPAND\n")
		local m_infos = infosarray(var)

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
		if (!m_expand_tokens) return
		if (ttype == Transition.ToNewSelection) {
			if (m_pong) {
				m_ponging = false
				m_pong_count = 0
				m_pong_up = true
			}
			m_text = expandtokens(m_text0, var)
			refreshtext()
		}
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

	function cbool(inval){
		return (inval ? "I":"O")
	}

	function board_on_tick(tick_time){
//::print(m_text+"\n")
		if (m_freezer == 1) {
			m_freezer -- 
			m_surf.clear = false
			m_surf.redraw = false
		}

		if (m_freezer == 2) m_freezer --

		if ((m_pong) && (!m_ponging)){
			if (m_pong_count == 0) 
				m_pong_count = ::fe.layout.time + m_pong_delay
			else if (m_pong_count <= ::fe.layout.time) {
				m_pong_count = 0
				m_ponging = true
				if (m_pong_up) line_up() else line_down()
			}
		}
		//if ((m_move == 0) && (m_surf.redraw = true)) m_surf.redraw = false
		if (m_move != 0) {
			if (m_surf.redraw == false) m_surf.redraw = true
			if (m_move > 0){
				// TEXT GOES DOWN
				m_object.y += m_scroll_speed
				m_move -= m_scroll_speed

				if (tb_topchar() == m_ch2) m_shader.set_param("alphatop", 1.0 - (m_object.y - m_y_zero) * 1.0 / m_line_height)
				if (tb_bottomchar() == m_ch1) m_shader.set_param("alphabot", (m_object.y - m_y_zero) * 1.0 / m_line_height)

				if (m_move % m_line_height <= m_scroll_speed) {
					m_line_move = (m_move - (m_move % m_line_height)) / m_line_height
					if (m_hint_delta != 0) {
						m_hint_delta --
						if (m_object.first_line_hint > 1) m_object.first_line_hint --
						if (m_hint_delta == 0)	m_freezer = 2
					}				
					m_object.y = m_y_zero
					m_move = m_line_move * m_line_height
					if (tb_topchar() == m_ch1) {
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
					m_line_move = (m_move - (m_move % m_line_height)) / m_line_height
					if (m_hint_delta != 0) {
						m_hint_delta ++
						m_object.first_line_hint ++
						if (m_hint_delta == 0)	m_freezer = 2
					}
					m_object.y = m_y_zero
					m_move = m_line_move * m_line_height
					if (tb_bottomchar() == m_ch1) {
						m_move = 0				
						m_hint_delta = 0
						if (m_ponging) pong_down()
					}
					else if (m_ponging) line_up()
				}
			}
		}
	}

	function _set( idx, value )
	{
		switch ( idx )
		{
			case "msg":
				m_text0 = value
				m_text = expandtokens(m_text0, 0)
				refreshtext()
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

			case "expand_tokens":
				//::print("Set expand_tokens to:"+value+"\n")
				m_expand_tokens = value
				m_text = expandtokens(m_text0, 0)
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

			case "buffer_lines":
				return m_bufferlines
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

	function line_down(){
		if (tb_topchar() == m_ch1) return
		m_hint_delta += 1
		m_move += m_line_height
	}
	function line_up(){
		if (tb_bottomchar() == m_ch1) return				
		m_hint_delta -= 1
		m_move -= m_line_height
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
}

fe.add_textboard <- textboard
