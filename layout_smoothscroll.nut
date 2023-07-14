local flw = fe.layout.width
local flh = fe.layout.height
local y0 = 100

local moveshift = 0

local textbox = fe.add_text("test", 0, y0, flw * 0.5, flh *0.5)
textbox.char_size = 15
textbox.word_wrap = true
textbox.align = Align.TopLeft
textbox.msg = " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque lobortis euismod nunc id accumsan. In vitae ultrices neque. Morbi vestibulum nibh et velit euismod eleifend. Curabitur at sodales ligula. Aliquam dapibus ipsum purus, non sollicitudin arcu gravida non. Etiam eleifend eleifend nibh. Nullam a nisi quam. Sed at dui nulla. Curabitur euismod ut nisl non dignissim. Integer semper condimentum ipsum ac dapibus. Donec vulputate, magna eu dignissim suscipit, ante sapien commodo libero, vel lobortis ante justo sit amet neque. Morbi vitae viverra est. Proin nulla elit, dapibus id sapien in, rutrum congue quam. Sed id sapien congue, faucibus libero eu, varius orci. Cras vestibulum erat sed semper luctus.\nPhasellus efficitur et quam non congue. Duis ornare vestibulum massa, id eleifend metus feugiat vitae. Donec convallis est justo, quis tempus lectus hendrerit sit amet. Nunc et consectetur turpis. Mauris aliquam elementum magna in tempus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla eu placerat enim, ac porttitor arcu. In hac habitasse platea dictumst. Phasellus cursus risus id augue ultricies, in commodo massa placerat. Pellentesque mollis ligula nulla, in lobortis odio pellentesque non. Cras risus quam, maximus id ligula vitae, lobortis dapibus leo. In a placerat nisi, non rutrum odio. Sed diam nibh, dignissim lobortis posuere finibus, scelerisque et justo. Curabitur non velit non magna maximus fermentum. Sed condimentum vitae velit a rutrum. Suspendisse tempus tempor gravida.\nEtiam erat lacus, dignissim non massa eget, blandit lobortis ipsum. Sed ut leo ipsum. Cras varius eu ex vitae bibendum. Suspendisse dictum, urna sed congue vulputate, tellus felis vehicula enim, sed egestas sem sem sit amet libero. Fusce nec nisl non enim iaculis tincidunt et nec felis. Integer lacinia ante velit. Pellentesque ultricies ante non euismod lobortis. Pellentesque non feugiat justo. Cras aliquam vel est ut porta. Nulla metus nisl, congue vitae consequat nec, vestibulum eget turpis. Vivamus vitae orci nunc. Vivamus sit amet metus ex. In diam felis, pellentesque ac ante id, rutrum pretium lectus. Integer semper eleifend consequat. Praesent sapien mauris, ullamcorper vel dui eu, euismod egestas nulla. Suspendisse justo dolor, laoreet non imperdiet id, aliquam a libero."
textbox.first_line_hint = 10
//textbox.set_bg_rgb(200,0,0)
textbox.margin = 20

local numlight = 3

local textzero = y0 + textbox.margin
local visiblearea = textbox.msg_height //textbox.height - 2 * textbox.margin
local numrows = split(textbox.msg_wrapped,"\n").len()
local lineheight = visiblearea / numrows

local liner = fe.add_rectangle(0, textzero + lineheight * numlight, textbox.width, lineheight)
liner.set_rgb(0,0,200)
liner.alpha = 128

print("rows:"+numrows+"\n")
print (textbox.char_size+" "+textbox.glyph_size+"\n")

fe.add_signal_handler(this, "on_signal")
fe.add_ticks_callback(this, "tick")

function on_signal(sig) {
	if (sig == "up") {
		moveshift = moveshift - textbox.char_size
		return true
	}
	if (sig == "down") {
		moveshift = moveshift + textbox.char_size
		return true
	}	
}

function tick(tick_time) {
	if (moveshift != 0) {
		if (moveshift > 0) {
			textbox.y ++
			moveshift --
			if (moveshift % textbox.char_size == 0) {
				textbox.first_line_hint --
				textbox.y = y0
			}
		}
		else 	if (moveshift < 0) {
			textbox.y --
			moveshift ++
			if (moveshift % textbox.char_size == 0){
				textbox.first_line_hint ++
				textbox.y = y0
			}
		}
	}
	
}
