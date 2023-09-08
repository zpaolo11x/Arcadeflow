// TEXT BOARD OBJECT

/*

Copy nut_textboard.nut and textboard.glsl in your layout with this structure:

layout_folder/
	nut_textboard.nut
	glsl/
		textboard.glsl

Add text board to a layout by first enabling the module
adding this line at the beginning of your layout nut file:

fe.do_nut ("nut_textboard.nut")

then add a textboard object the same way a text object is added:
fe.add_textboard(text, x, y, width, height)

if your object lays on a surface, call it as a parameter:
fe.add_textboard(text, x, y, width, height, surface)

Properties:

Textboard shares all the properties of a text object plus some others:

- tx_alpha = alpha value of the text alone
- bg_alpha = alpha value of the background alone
- alpha = composite alpha of the whole text object

- lines_bottom = lines to fade out at the bottom of the box
- lines_top = lines to fade out at the top of the box

- target_line = set/get this value to a desired target line

- scroll_pulse = (0 to 1) speed of scrolling when manually moving up or down
- natural_scroll = true or false reverses scrolling direction
- enable_signals = enable/disable signal response for scrolling (up/down goes up or down, left/right jumps to top and bottom)
- enable_transition = enable/disable automatic transition update when text box uses magic tokens
- signal_block = if true no further up or down signals are managed

- pingpong = makes the text scroll up and down automatically
- pingpong_speed = scroll speed in lines per second
- pingpong_delay = delay to start movement in seconds

There are some methods you can call using, for example, your_object.goto_start()

- goto_start(), goto_end() smoothly moves to first or last line
- line_up(), line_down() smoothly move text up or down by one line
- goto_line(n) smoothly moves to line n (lines start from 1)

*/

class textboard
{
	// mk2 Objects
	m_object = null
	m_surf = null

	// mk2 Blanking parameters
	m_line_top = null
	m_line_bot = null

	// mk2 Read only properties
	m_line_height = null
	m_lines = null
	m_viewport_max_y = null
	m_max_hint = null
	m_lines_total = null

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

	m_viewport_y = null

	// mk2 text parameters
	m_text = null
	m_margin = null
	m_margin_bottom = null
	m_shader = null

	// Reas/write properties
	m_natural_scroll = null
	m_enable_signals = null
	m_signal_block = null
	m_enable_transition = null
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
	m_time_constant = null
	m_pong_speed = null

	// Performace management properties
	m_freezer = null
	tick_time_0 = null
	tick_elapse = null

	m_i2 = null

	m_count = null

	// DEBUG
	m_debug = false
	m_overlay = null
	m_overlay2 = null
	m_overnum = null
	textref2 = null

	constructor (_t, _x, _y, _w, _h, _surface = null) {
		tick_time_0 = 0
		tick_elapse = 0

		m_viewport_y = 0

		mi2_initialize()

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

		m_time_constant = 75
		m_scroll_pulse = ::pow(2.7182, -1.0 / (75 * ScreenRefreshRate / 1000.0))

		m_line_height = null
		m_natural_scroll = false
		m_enable_signals = true
		m_enable_transition = true
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

		if (m_debug) {
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

	function mi2_initialize() {
		m_i2 = {
			delta = 0

			stepcurve = 0
			smoothcurve = 0
			pos = 0

			poles = 4
			buffer = ::array(4, 0.0)

			debug = false
			dbcounter = 0
		}

	}

	function mi2_getfiltered(arrayin, arrayw) {
		local sumv = 0
		local sumw = 0
		foreach (i, item in arrayin) {
			sumv += arrayin[i] * arrayw[i]
			sumw += arrayw[i]
		}
		return sumv * 1.0 / sumw
	}

	function mi2_impulse(deltain) {
		m_freezer = 0
		m_i2.delta = deltain
		m_i2.stepcurve += m_i2.delta
	}

	function dbprint(text) {
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

	function refreshtext() {
		m_surf.redraw = true
		m_object.y = 0
		m_object.height = m_surf.height
		m_object.msg = m_text
		m_object.word_wrap = true
		m_object.first_line_hint = 1
		m_target_line = 1

		if (m_debug) {
			textref2.msg = m_text
			textref2.align = m_object.align
			textref2.char_size = m_object.char_size
			textref2.margin = m_object.margin
			textref2.line_spacing = m_object.line_spacing
			textref2.first_line_hint = 1
		}

		m_line_height = m_object.line_size

		m_lines = m_object.lines
		m_lines_total = m_object.lines_total
		m_max_hint = m_lines_total - m_lines + 1

		if (m_max_hint <= 0) m_max_hint = 1

		m_viewport_max_y = (m_max_hint - 1) * m_line_height

		m_object.y = - 2.0 * m_line_height
		m_object.height = m_surf.height + 4.0 * m_line_height
		m_y_zero = m_object.y

		m_object.msg = " \n \n" + m_text + "\n \n "

		m_hint_new = 1

		mi2_initialize()

		m_y_start = 0
		m_y_stop = 0
		m_y_shift = null

		m_margin_bottom = m_surf.height - m_object.margin - m_lines * m_line_height
		if (m_margin_bottom < 0) m_margin_bottom = 0

		m_shader.set_param("blanktop", m_object.margin * 1.0 / m_surf.height, (m_object.margin + m_line_height * m_line_top) * 1.0 / m_surf.height)
		m_shader.set_param("blankbot", m_margin_bottom * 1.0 / m_surf.height, (m_margin_bottom + m_line_height * m_line_bot) * 1.0 / m_surf.height)
		m_shader.set_param("alphatop", 0.0)
		m_shader.set_param("alphabot", m_max_hint <= 1 ? 0.0 : 1.0)

		m_freezer = 2

		dbprint("line height:"+m_line_height+"\n")
		dbprint("visible lines:"+m_lines+"\n")
		dbprint("all lines:"+m_lines_total+"\n")
		dbprint("max hint:"+m_max_hint+"\n")
		dbprint("viewport max:"+m_viewport_max_y+"\n")
		dbprint("margin bottom:"+m_margin_bottom+"\n")
		dbprint("\n")

		if (m_pong) pong_up()
	}

	function resetstatus()
	{
		m_object.first_line_hint = 1 //TEST needed?
		m_target_line = 1

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

	function board_on_transition(ttype, var, ttime) {
		//TEST NEEDED FOR PING PONG?
		if (m_enable_transition && (ttype == Transition.FromOldSelection) || (ttype == Transition.ToNewList)) {
			if (m_pong) pong_up()
			refreshtext()
		}
	}

	function board_on_signal(sig) {
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
		if (sig == "left") {
			goto_start()
			return m_signal_block
		}
		if (sig == "right") {
			goto_end()
			return m_signal_block
		}
	}

	function board_on_tick(tick_time) {

		if (m_i2.debug) {
			local multi = 1.0
			local tr_pos = ::fe.add_rectangle(m_i2.dbcounter, ::fe.layout.height * 0.5 - (m_i2.pos) * multi, 3, 3) //RED
			local tr_smooth = ::fe.add_rectangle(m_i2.dbcounter, ::fe.layout.height * 0.5 - (m_i2.smoothcurve) * multi, 3, 3) //BLACK
			local tr_step = ::fe.add_rectangle(m_i2.dbcounter, ::fe.layout.height * 0.5 - (m_i2.stepcurve) * multi, 3, 3) //WHITE
			local tr_line1 = ::fe.add_rectangle(m_i2.dbcounter, ::fe.layout.height * 0.5 - (m_line_height) * multi, 3, 3) //BLUE
			local tr_line2 = ::fe.add_rectangle(m_i2.dbcounter, ::fe.layout.height * 0.5 - 2.0 * (m_line_height) * multi, 3, 3) //BLUE
			local tr_line3 = ::fe.add_rectangle(m_i2.dbcounter, ::fe.layout.height * 0.5 - 3.0 * (m_line_height) * multi, 3, 3) //BLUE
			local tr_line4 = ::fe.add_rectangle(m_i2.dbcounter, ::fe.layout.height * 0.5 - 4.0 * (m_line_height) * multi, 3, 3) //BLUE

			tr_line1.zorder = tr_line2.zorder = tr_line3.zorder = tr_line4.zorder = 20000
			tr_step.zorder = 20002
			tr_smooth.zorder = 20004
			tr_pos.zorder = 20001

			tr_pos.set_rgb(255, 0, 0)
			tr_smooth.set_rgb(0, 0, 0)
			tr_step.set_rgb(255, 255, 255)
			tr_line1.set_rgb(0, 0, 255)
			tr_line2.set_rgb(0, 0, 255)
			tr_line3.set_rgb(0, 0, 255)
			tr_line4.set_rgb(0, 0, 255)
			m_i2.dbcounter = m_i2.dbcounter + 0.5
		}

		tick_elapse = tick_time - tick_time_0
		tick_time_0 = tick_time

		if (m_enable_signals) {
			if (m_count.right != 0) m_count.right = m_repeatsignal("right", m_count.right)
			if (m_count.left != 0) m_count.left = m_repeatsignal("left", m_count.left)
			if (m_count.up != 0) m_count.up = m_repeatsignal("up", m_count.up)
			if (m_count.down != 0) m_count.down = m_repeatsignal("down", m_count.down)
		}

		if (m_debug) {
			m_overnum.msg = m_object.first_line_hint+" / "+m_max_hint
			m_overnum.char_size = 20

			m_overlay.y = m_viewport_max_y
			m_overlay2.y = m_i2.stepcurve
		}

		if (m_freezer == 1) {
			m_freezer --
			m_surf.clear = false
			m_surf.redraw = false
		}

		if (m_freezer == 2) {
			m_surf.clear = true
			m_surf.redraw = true
			m_freezer --
		}

		if (!m_surf.visible) return

		if ((m_pong) && (!m_ponging)) {
			if (m_pong_count == 0) {
				m_pong_count = ::fe.layout.time + m_pong_delay
			}
			else if (m_pong_count <= ::fe.layout.time) {
				m_ponging = true
				m_pong_count = 0
				if (m_pong_up) m_y_pong_speed = -(m_pong_speed * m_line_height * 1.0 / 1000) else m_y_pong_speed = 1.0 * (m_pong_speed * m_line_height * 1.0 / 1000)
			}
		}

		if (m_y_pong_speed != 0) {
			if (m_surf.redraw == false) m_surf.redraw = true
			mi2_impulse(-1.0 * m_y_pong_speed * tick_elapse)
		}

		// Impulse scrolling routines

		if (m_i2.smoothcurve - m_i2.stepcurve != 0) {
			if (m_surf.redraw == false) m_surf.redraw = true

			if (m_i2.stepcurve < 0) m_i2.stepcurve = 0
			if (m_i2.stepcurve > m_viewport_max_y) m_i2.stepcurve = m_viewport_max_y

			//m_i2.buffer[0] = m_i2.buffer[0] + m_scroll_pulse * (60.0 / ScreenRefreshRate) * (m_i2.stepcurve - m_i2.buffer[0])
			m_i2.buffer[0] = m_i2.stepcurve + m_scroll_pulse * (m_i2.buffer[0] - m_i2.stepcurve)
			for (local i = 1; i < m_i2.poles; i++){
				//m_i2.buffer[i] = m_i2.buffer[i] + m_scroll_pulse * (60.0 / ScreenRefreshRate) * (m_i2.buffer[i-1] - m_i2.buffer[i])
				m_i2.buffer[i] = m_i2.buffer[i-1] + m_scroll_pulse * (m_i2.buffer[i] - m_i2.buffer[i-1])
			}

			m_i2.smoothcurve = m_i2.buffer[m_i2.poles - 1]


			if ((m_i2.smoothcurve - m_i2.stepcurve < 0.1) && (m_i2.smoothcurve - m_i2.stepcurve > -0.1)) { //TEST WAS 0.1
				m_i2.smoothcurve = m_i2.stepcurve
				m_surf.redraw = false
			}

			m_i2.pos = m_i2.smoothcurve - m_i2.stepcurve

			set_viewport(m_i2.smoothcurve)
		}
	}

	function _set( idx, value ) {
		switch ( idx ) {
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

			case "enable_transition":
				m_enable_transition = value
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

			case "time_constant":
				m_time_constant = value
				m_scroll_pulse = ::pow(2.7182, -1.0 / (value * ScreenRefreshRate / 1000.0))
				break

			case "pingpong_speed":
				m_pong_speed = value
				break

			default:
   			m_object[idx] = value
		}
	}

	function _get( idx ) {
		switch ( idx ) {
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

			case "lines":
				return m_lines
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

			case "enable_transition":
				return m_enable_transition
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

			case "lines_total":
				return m_lines_total
				break

			default:
			   return m_object[idx]
		}
	}

	function set_rgb( r, g, b ) {
		m_shader.set_param("textcolor", r*1.0/255, g*1.0/255, b*1.0/255)
	}

	function set_bg_rgb( r, g, b ) {
		m_shader.set_param("panelcolor", r*1.0/255, g*1.0/255, b*1.0/255)
	}

	function set_viewport(y) {
		if (y <= 0) {
			y = 0
			m_object.y = m_y_zero
			m_hint_new = 1
			if (m_object.first_line_hint != m_hint_new) m_object.first_line_hint = m_hint_new
			if (m_ponging && (m_y_pong_speed > 0)) pong_up()
		}
		else if (y >= m_viewport_max_y) {
			y = m_viewport_max_y
			m_object.y = m_y_zero
			m_hint_new = m_max_hint
			if (m_object.first_line_hint != m_hint_new) m_object.first_line_hint = m_hint_new
			if (m_ponging && (m_y_pong_speed < 0)) pong_down()
		}
		else {
			m_object.y = m_y_zero - y % m_line_height

			m_hint_new = ::floor(y * 1.0 / m_line_height) + 1
			if (m_object.first_line_hint != m_hint_new) m_object.first_line_hint = m_hint_new
			//m_y_start = y
		}

		if ((y > m_line_height) && (y < m_viewport_max_y - m_line_height)) { //TEST can be improved by not applying at every redraw
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
		m_viewport_y = y
	}

	function goto_start() {
		if (m_debug) textref2.first_line_hint = 1
		m_target_line = 1
		goto_line(1)
	}

	function goto_end() {
		if (m_debug) textref2.first_line_hint = m_max_hint
		m_target_line = m_max_hint
		goto_line(m_max_hint)
	}

	function line_up() {
		if (m_debug) textref2.first_line_hint = textref2.first_line_hint + 1
		if (m_target_line < m_max_hint) m_target_line ++
		mi2_impulse(m_line_height)
	}

	function line_down() {
		if (m_debug) textref2.first_line_hint = textref2.first_line_hint - 1
		if (m_target_line > 1) m_target_line --
		mi2_impulse(- m_line_height)
	}

	function goto_line(n) {
		mi2_impulse(((n - 1) * m_line_height - m_i2.stepcurve))
		m_target_line = n < 1 ? 1 : (n > m_max_hint ? m_max_hint : n)
		return
	}

	function pong_down() {
		m_ponging = false
		m_pong_count = 0
		m_pong_up = false
		m_y_pong_speed = 0
	}

	function pong_up() {
		m_ponging = false
		m_pong_count = 0
		m_pong_up = true
		m_y_pong_speed = 0
	}
}

fe.add_textboard <- textboard
