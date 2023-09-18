local flw = fe.layout.width
local flh = fe.layout.height

local bg = fe.add_rectangle( 0, 0, flw, flh )
bg.set_rgb( 0, 100, 100 )

local su = fe.add_surface( flw / 2, flh )

local subg = su.add_rectangle( 0, 0, su.width, su.height )
subg.set_rgb( 100, 0, 100 )

local txt = su.add_text( "", 0, 0, su.width, su.height * 2 )
txt.word_wrap = true
txt.align = Align.TopLeft
txt.char_size = su.height / 20
txt.msg = "START\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque lobortis euismod nunc id accumsan. In vitae ultrices neque. Morbi vestibulum nibh et velit euismod eleifend. Curabitur at sodales ligula. Aliquam dapibus ipsum purus, non sollicitudin arcu gravida non. Etiam eleifend eleifend nibh. Nullam a nisi quam. Sed at dui nulla. Curabitur euismod ut nisl non dignissim. Integer semper condimentum ipsum ac dapibus. Donec vulputate, magna eu dignissim suscipit, ante sapien commodo libero, vel lobortis ante justo sit amet neque. Morbi vitae viverra est. Proin nulla elit, dapibus id sapien in, rutrum congue quam. Sed id sapien congue, faucibus libero eu, varius orci. Cras vestibulum erat sed semper luctus.\nPhasellus efficitur et quam non congue. Duis ornare vestibulum massa, id eleifend metus feugiat vitae. Donec convallis est justo, quis tempus lectus hendrerit sit amet. Nunc et consectetur turpis. Mauris aliquam elementum magna in tempus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla eu placerat enim, ac porttitor arcu. In hac habitasse platea dictumst. Phasellus cursus risus id augue ultricies, in commodo massa placerat. Pellentesque mollis ligula nulla, in lobortis odio pellentesque non. Cras risus quam, maximus id ligula vitae, lobortis dapibus leo. In a placerat nisi, non rutrum odio. Sed diam nibh, dignissim lobortis posuere finibus, scelerisque et justo. Curabitur non velit non magna maximus fermentum. Sed condimentum vitae velit a rutrum. Suspendisse tempus tempor gravida.\nEtiam erat lacus, dignissim non massa eget, blandit lobortis ipsum. Sed ut leo ipsum. Cras varius eu ex vitae bibendum. Suspendisse dictum, urna sed congue vulputate, tellus felis vehicula enim, sed egestas sem sem sit amet libero. Fusce nec nisl non enim iaculis tincidunt et nec felis. Integer lacinia ante velit. Pellentesque ultricies ante non euismod lobortis. Pellentesque non feugiat justo. Cras aliquam vel est ut porta. Nulla metus nisl, congue vitae consequat nec, vestibulum eget turpis. Vivamus vitae orci nunc. Vivamus sit amet metus ex. In diam felis, pellentesque ac ante id, rutrum pretium lectus. Integer semper eleifend consequat. Praesent sapien mauris, ullamcorper vel dui eu, euismod egestas nulla. Suspendisse justo dolor, laoreet non imperdiet id, aliquam a libero.\nSTOP"

// Cut text and the surface background
local margin_cut = su.add_rectangle( 0, 0, su.width, su.height / 5 )
margin_cut.blend_mode = BlendMode.Subtract

// Redraw cut background
local margin_add = su.add_rectangle( 0, 0, su.width, su.height / 5 )
margin_add.set_rgb( 100, 0, 100 )


fe.add_ticks_callback( "on_tick" )
function on_tick ( ttime )
{
    txt.y -= 0.2
    su.alpha = sin( ttime * 0.001 ) * 127 + 127
}