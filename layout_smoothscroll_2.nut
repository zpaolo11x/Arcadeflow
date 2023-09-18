function getlineheight(textobject){
	// Use this function after setting font char_size and line_height,
	// and before setting the actual message, line_hint and word_wrap
	textobject.word_wrap = true
	textobject.msg = "XXX"
	textobject.first_line_hint = 0
	local f1 = textobject.msg_height
	textobject.msg = "XXX\nXXX"
	local f2 = textobject.msg_height
	return (f2 - f1)
}

local flw = fe.layout.width
local flh = fe.layout.height
local y0 = 0

local tm = {
	move = 0
	speed = 0.5
	hint = 0
	linmove = 0
	linheight = 0
}

tm.move = 0
tm.speed = 0.5
tm.hint = 0
tm.linmove = 0

local textbox = fe.add_text("", 0, y0, flw*0.5, flh)
textbox.char_size = 20
textbox.line_spacing = 1.2
tm.linheight = getlineheight(textbox)

textbox.word_wrap = true
textbox.margin = 20
textbox.align = Align.TopLeft
textbox.msg = "START\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque lobortis euismod nunc id accumsan. In vitae ultrices neque. Morbi vestibulum nibh et velit euismod eleifend. Curabitur at sodales ligula. Aliquam dapibus ipsum purus, non sollicitudin arcu gravida non. Etiam eleifend eleifend nibh. Nullam a nisi quam. Sed at dui nulla. Curabitur euismod ut nisl non dignissim. Integer semper condimentum ipsum ac dapibus. Donec vulputate, magna eu dignissim suscipit, ante sapien commodo libero, vel lobortis ante justo sit amet neque. Morbi vitae viverra est. Proin nulla elit, dapibus id sapien in, rutrum congue quam. Sed id sapien congue, faucibus libero eu, varius orci. Cras vestibulum erat sed semper luctus.\nPhasellus efficitur et quam non congue. Duis ornare vestibulum massa, id eleifend metus feugiat vitae. Donec convallis est justo, quis tempus lectus hendrerit sit amet. Nunc et consectetur turpis. Mauris aliquam elementum magna in tempus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla eu placerat enim, ac porttitor arcu. In hac habitasse platea dictumst. Phasellus cursus risus id augue ultricies, in commodo massa placerat. Pellentesque mollis ligula nulla, in lobortis odio pellentesque non. Cras risus quam, maximus id ligula vitae, lobortis dapibus leo. In a placerat nisi, non rutrum odio. Sed diam nibh, dignissim lobortis posuere finibus, scelerisque et justo. Curabitur non velit non magna maximus fermentum. Sed condimentum vitae velit a rutrum. Suspendisse tempus tempor gravida.\nEtiam erat lacus, dignissim non massa eget, blandit lobortis ipsum. Sed ut leo ipsum. Cras varius eu ex vitae bibendum. Suspendisse dictum, urna sed congue vulputate, tellus felis vehicula enim, sed egestas sem sem sit amet libero. Fusce nec nisl non enim iaculis tincidunt et nec felis. Integer lacinia ante velit. Pellentesque ultricies ante non euismod lobortis. Pellentesque non feugiat justo. Cras aliquam vel est ut porta. Nulla metus nisl, congue vitae consequat nec, vestibulum eget turpis. Vivamus vitae orci nunc. Vivamus sit amet metus ex. In diam felis, pellentesque ac ante id, rutrum pretium lectus. Integer semper eleifend consequat. Praesent sapien mauris, ullamcorper vel dui eu, euismod egestas nulla. Suspendisse justo dolor, laoreet non imperdiet id, aliquam a libero.\nSTOP"
textbox.first_line_hint = 10
textbox.set_bg_rgb(0,120,0)

// CREATE ALTERNATING LINES
local numrows = split(textbox.msg_wrapped,"\n").len()

for (local i = 0; i < numrows; i++){
	local liner = fe.add_rectangle(0, y0 + textbox.margin + tm.linheight * i, textbox.width, tm.linheight)
	if (i % 2 == 0) 
		liner.set_rgb(0, 0, 200)
	else
		liner.set_rgb(200, 0, 0)
	liner.alpha = 128
}

fe.add_signal_handler(this, "on_signal")
fe.add_ticks_callback(this, "tick")

function on_signal(sig) {
	if (sig == "up") {
		tm.hint --
		tm.move = tm.move - tm.linheight
		return true
	}
	if (sig == "down") {
		tm.hint ++
		tm.move = tm.move + tm.linheight
		return true
	}	
}

function tick(tick_time) {
	if (tm.move != 0) {
		if (tm.move > 0) {
			textbox.y += tm.speed
			tm.move -= tm.speed
			if (tm.move % tm.linheight <= tm.speed) {
				tm.linmove = (tm.move - (tm.move % tm.linheight)) / tm.linheight
				if (tm.hint != 0) {
					tm.hint --
					textbox.first_line_hint --
					if (textbox.first_line_hint == 0) textbox.first_line_hint = 1
				}				
				textbox.y = y0
				tm.move = tm.linmove * tm.linheight
			}
		}
		else 	if (tm.move < 0) {
			textbox.y -= tm.speed
			tm.move += tm.speed
			if (tm.move % tm.linheight >= -tm.speed){
				tm.linmove = (tm.move - (tm.move % tm.linheight)) / tm.linheight
				if (tm.hint != 0) {
					tm.hint ++
					textbox.first_line_hint ++
				}
				textbox.y = y0
				tm.move = tm.linmove * tm.linheight
			}
		}
	}
}
