function testpr(textin){
	print (textin)
}


function round(x, y) {
	return (x.tofloat()/y+(x>0?0.5:-0.5)).tointeger()*y
}

function max(x,y){
	return (x > y ? x : y)
}

function min(x,y){
	return (x < y ? x : y)
}

function absf (n) {
	return (n >= 0 ? n : -n)
}

local fl = {
	w = fe.layout.width
	h = fe.layout.height
	x = 0
	y = 0
}

local overlay = {
	w = fl.w
	h = fl.h
	x = 0
	y = 0
}

// font definition
local uifonts = {
	gui = "fonts/font_Roboto-Allcaps-EXT4X.ttf"
	general = "fonts/font_Roboto-Bold.ttf"
	condensed = "fonts/font_Roboto-Condensed-Bold.ttf"
	lite = "fonts/font_Roboto-Regular.ttf"
	arcade = "fonts/font_CPMono_Black.otf"
	arcadeborder = "fonts/font_CPMono_BlackBorder2.otf"
	glyphs = "fonts/font_glyphs.ttf"
	mono = "fonts/font_RobotoMono-VariableFont_wght.ttf"
	monodata = "fonts/font_CQMono.otf"
	pixel = 0.711
}

local vertical = false
local scalerate = (vertical ? fl.w : fl.h)/1200.0


// parameters for slowing down key repeat on left-right scrolling
local count = {
	right = 0
	left = 0
	up = 0
	down = 0
	next_game = 0
	prev_game = 0
	next_letter = 0
	prev_letter = 0
	next_page = 0
	prev_page = 0

	movestart = 20 //was 25, 20 is snappier
	movestep = 0
	movestepslow = 6
	movestepfast = 3 //3 o 4, 3 engages the limit sooner
	movestepdelay = 6

	countstep = 0
	forceleft = false
	forceright = false
	forceup = false
	forcedown = false
	skipup = 0
	skipdown = 0
}

count.movestep = count.movestepslow


// Capslocked keyboard also adds special characters:
// 1 2 3 4 5 6 7 8 9 0
// ! $ & / ( ) = ? + -

// keys definition for on screen keyboard
local key_names = {"^":"^","+":"+","-":"-","(":"(",")":")","&":"&",".":".",",":",", "/":"/", "A": "A", "B": "B", "C": "C", "D": "D", "E": "E", "F": "F", "G": "G", "H": "H", "I": "I", "J": "J", "K": "K", "L": "L", "M": "M", "N": "N", "O": "O", "P": "P", "Q": "Q", "R": "R", "S": "S", "T": "T", "U": "U", "V": "V", "W": "W", "X": "X", "Y": "Y", "Z": "Z", "1": "1", "2": "2", "3": "3", "4": "4", "5": "5", "6": "6", "7": "7", "8": "8", "9": "9", "0": "0", "<": "⌫", " ": "⎵", "|": "⌧", "~": "DONE","}" : " ", "{":" " }
local key_names_secondary = {"^":"^","+":"#","-":"_","(":"[",")":"]","&":"*",".":"!",",":":", "/":"?", "A": "a", "B": "b", "C": "c", "D": "d", "E": "e", "F": "f", "G": "g", "H": "h", "I": "i", "J": "j", "K": "k", "L": "l", "M": "m", "N": "n", "O": "o", "P": "p", "Q": "q", "R": "r", "S": "s", "T": "t", "U": "u", "V": "v", "W": "w", "X": "x", "Y": "y", "Z": "z", "1": "1", "2": "2", "3": "3", "4": "4", "5": "5", "6": "6", "7": "7", "8": "8", "9": "9", "0": "0", "<": "⌫", " ": "⎵", "|": "⌧", "~": "DONE","}" : " ", "{":" " }
//local key_rows = ["abcdefghi123", "jklmnopqr456", "stuvwxyz/789", "}<{} {}|{}0{","~"]
local key_rows = ["<1234567890-", "|ABCDEFGHIJ+", "^KLMNOPQRS()"," TUVWXYZ.,&/","~"]

if (vertical) {
	key_rows = ["1234567890","abcdefghij","klmnopqrst","uvwxyz{< |","~"]
}
local key_selected = [0,0]
local keyboard_entrytext = ""


/// On Screen Keyboard ///

local keyboard_surface = fe.add_surface(overlay.w, overlay.h)
keyboard_surface.set_pos(overlay.x,overlay.y)
keyboard_surface.preserve_aspect_ratio = true
keyboard_surface.alpha = 255*0

local kb = {
	keys = {}
	keylow = 100

	secondary = false

	rt_stringkeys = "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ- <^"
	rt_keys = {}

	text_base = "" // This is the pre-text to show
	f_type = null // Custom function when key pressed
	f_back = null // Custom fuction when leaving using back
	f_done = null // Custom function when done is selected
}

// Populate the rt_keys structure that is polled to check realtime typing
foreach(letter in kb.rt_stringkeys){
   local letterchar = letter.tochar()

   if (letterchar == "<"){
      kb.rt_keys["Backspace"] <- {
         val = letterchar
         prs = false
      }
   }
	else if (letterchar == " "){
      kb.rt_keys["Space"] <- {
         val = letterchar
         prs = false
      }
   }
	else if (letterchar == "^"){
      kb.rt_keys["LShift"] <- {
         val = letterchar
         prs = false
      }
      kb.rt_keys["RShift"] <- {
         val = letterchar
         prs = false
      }
   }
  else {
      try {
         letter = letterchar.tointeger()
         kb.rt_keys["Num"+letter] <- {
				val = letter
				prs = false
			}
      }
      catch(err){
			testpr("LC"+letterchar+"\n")
         kb.rt_keys[letterchar] <- {
				val = letterchar
				prs = false
			}
      }
   }
}

local keyboard_text = null

function keyboard_show(text_base,entrytext,f_type,f_back,f_done){

	// Initialize keyboard data structure and functions
	kb.text_base = text_base
	kb.f_type = f_type
	kb.f_back = f_back
	kb.f_done = f_done
	keyboard_entrytext = entrytext

	keyboard_text.msg = kb.text_base + ": "+entrytext

	// Show keyboard graphics
	keyboard_surface.alpha = 255
}

function keyboard_hide(){
	flowT.keyboard = startfade(flowT.keyboard,-0.1,0.0)
	if (!umvisible && !prfmenu.showing) flowT.zmenudecoration = startfade(flowT.zmenudecoration,-0.2,0.0)
	// keyboard_surface.alpha = 0
}

//get current visibility
function keyboard_visible() {
	return (keyboard_surface.alpha > 0)
}

function keyboard_select_relative (rel_col, rel_row){
	keyboard_select( key_selected[0] + rel_col, key_selected[1] + rel_row )
}

function keyboard_select (col, row){
	row = ( row < 0 ) ? key_rows.len() - 1 : ( row > key_rows.len() - 1 ) ? 0 : row
	col = ( col < 0 ) ? key_rows[row].len() - 1 : ( col > key_rows[row].len() - 1 ) ? 0 : col
	local previous = key_rows[key_selected[1]][key_selected[0]].tochar()
	local selected = key_rows[row][col].tochar()

	kb.keys[previous].set_rgb( kb.keylow,kb.keylow,kb.keylow )
	kb.keys[previous].alpha = 255
	kb.keys[selected].set_rgb( 255,255,255 )
	kb.keys[selected].alpha = 255
	key_selected = [ col, row ]
}

function keyboard_type(c){
	if (c == "^"){ //CAPS LOCK
		kb.secondary = !kb.secondary
		foreach (item, val in kb.keys){
			kb.keys[item].msg = kb.secondary ? key_names_secondary[item] : key_names[item]
			testpr(item+"\n")
		}
	}
	else if ( c == "<" ) //BACKSPACE
		keyboard_entrytext = ( keyboard_entrytext.len() > 0 ) ? keyboard_entrytext.slice( 0, keyboard_entrytext.len() - 1 ) : ""
	else if ( c == "|" ) //CLEAR ALL
		keyboard_entrytext = ""
		//keyboard_clear()
	else if ( c == "~" ){ //DONE applica la ricerca e chiude la sessione.
		kb.f_done()
		keyboard_hide()
	}
	else keyboard_entrytext = keyboard_entrytext + (kb.secondary ? key_names_secondary[c] : c)

	// GENERAL UPDATE
	keyboard_text.msg = kb.text_base + ": " + keyboard_entrytext
	// Custom update
	kb.f_type()
}

function keyboard_draw() {

	//draw the search surface bg
	local bg = keyboard_surface.add_image("kbg2.png", 0, 0, keyboard_surface.width, keyboard_surface.height)
	bg.alpha = 230

	//draw the search text object
	local osd_search = {
		x = ( keyboard_surface.width * 0 ) * 1.0,
		y = ( keyboard_surface.height * 0.2 ) * 1.0,
		width = ( keyboard_surface.width * 1 ) * 1.0,
		height = ( keyboard_surface.height * 0.1 ) * 1.0
	}

	keyboard_text = keyboard_surface.add_text(keyboard_entrytext, osd_search.x, osd_search.y, osd_search.width, osd_search.height)
	keyboard_text.align = Align.Left
	keyboard_text.font = uifonts.general
	keyboard_text.set_rgb( 255, 255, 255 )
	keyboard_text.alpha = 255
	keyboard_text.char_size = 80*scalerate


	//draw the search key objects
	foreach ( key,val in key_names ) {

		local key_name = val

		local textkey = keyboard_surface.add_text( key_name, -1, -1, 1, 1 )
		textkey.font = uifonts.gui
		textkey.char_size = 75*scalerate

		textkey.set_rgb( kb.keylow,kb.keylow,kb.keylow)
		textkey.alpha = 255
		textkey.set_bg_rgb (60,60,60)
		textkey.bg_alpha = 128
		textkey.font = uifonts.lite
		textkey.align = Align.MiddleCentre
		kb.keys[ key ] <- textkey

	}


	//set search key positions
	local row_count = 0
	foreach ( row in key_rows )
	{
		local col_count = 0
		local osd = {
			x = ( keyboard_surface.width * 0.1 ) * 1.0,
			y = ( keyboard_surface.height * 0.4 ) * 1.0,
			width = ( keyboard_surface.width * 0.8 ) * 1.0,
			height = ( keyboard_surface.height * 0.5 ) * 1.0
		}
		//local keynumcol = (row == "- <~") ? 4 : 10
		local key_width = ( osd.width / row.len() ) * 1.0
		local key_height = ( osd.height / key_rows.len() ) * 1.0
		foreach ( char in row )
		{
			//local key_image = kb.keys[ iii ]
			local key_image = kb.keys[ char.tochar() ]
			local pos = {
				x = osd.x + ( key_width * col_count )+2,
				y = osd.y + key_height * row_count+2,
				w = key_width-4,
				h = key_height-4
			}
			key_image.set_pos( pos.x, pos.y, pos.w, pos.h )

			col_count++
		}
		row_count++
	}
}

keyboard_draw()
keyboard_select (key_selected[0],key_selected[1])



keyboard_show("🏷 ","",
function(){ //TYPE
	return
},
function(){ //BACK
	return
},
function(){ //DONE
	return
}
)


function repeatsignal (sig,counter){
	if (fe.get_input_state(sig)==false) {
		count.countstep = 0
		count.movestep = count.movestepslow
		return (0)
	}
	else {
		fe.signal(sig)
		counter ++
		if (counter - count.movestart == count.movestep + 1) {
			counter = count.movestart
			count.countstep ++
			count.movestep = round(count.movestepfast + (count.movestepslow-count.movestepfast)*pow(2.7182,-count.countstep/count.movestepdelay) , 1)
		}
		return counter
	}
}

function checkrepeat(counter){
	return ((counter == 0) || (counter == count.movestart))
}


fe.add_signal_handler( this, "on_signal" )
fe.add_transition_callback( this, "on_transition" )
fe.add_ticks_callback( this, "tick" )


/// On Transition ///

function on_transition( ttype, var0, ttime ) {

}



/// On Tick ///
function tick( tick_time ) {

	if (keyboard_visible()){
		foreach (key, item in kb.rt_keys) {
			local pressedkey = fe.get_input_state(key)
			if (!item.prs && pressedkey) {
				testpr(key+"\n")
				//displaybutton.msg = displaybutton.msg + item.val
				keyboard_select (0,4)
				keyboard_type(item.val)
			}
			item.prs = pressedkey
		}
	}

	if (count.right != 0) count.right = repeatsignal("right",count.right)
	if (count.left != 0) count.left = repeatsignal("left",count.left)
	if (count.up != 0) count.up = repeatsignal("up",count.up)
	if (count.down != 0) count.down = repeatsignal("down",count.down)

	if (count.prev_game != 0) count.prev_game = repeatsignal("prev_game",count.prev_game)
	if (count.next_game != 0) count.next_game = repeatsignal("next_game",count.next_game)

	if (count.prev_page != 0) count.prev_page = repeatsignal("prev_page",count.prev_page)
	if (count.next_page != 0) count.next_page = repeatsignal("next_page",count.next_page)

	if (count.prev_letter != 0) count.prev_letter = repeatsignal("prev_letter",count.prev_letter)
	if (count.next_letter != 0) count.next_letter = repeatsignal("next_letter",count.next_letter)

}


/// On Signal ///
function on_signal( sig ){


	// search page signal response
	if (keyboard_visible())
	{

		if ( sig == "up" ) {
			if (checkrepeat(count.up)){
				keyboard_select_relative( 0, -1 )
				while ((key_rows[key_selected[1]][key_selected[0]].tochar()=="{") || (key_rows[key_selected[1]][key_selected[0]].tochar()=="}"))
					keyboard_select_relative( (key_rows[key_selected[1]][key_selected[0]].tochar()=="{" ? -1 : 1), 0 )
				count.up++
			}
		}

		else if ( sig == "down" ) {
			if (checkrepeat(count.down)){
				keyboard_select_relative( 0, 1 )
				while ((key_rows[key_selected[1]][key_selected[0]].tochar()=="{") || (key_rows[key_selected[1]][key_selected[0]].tochar()=="}"))
					keyboard_select_relative( (key_rows[key_selected[1]][key_selected[0]].tochar()=="{") ? -1 : 1, 0 )
				count.down++
			}
		}

		else if ( sig == "left" ) {
			if (checkrepeat(count.left)){
				keyboard_select_relative( -1, 0 )
				while ((key_rows[key_selected[1]][key_selected[0]].tochar()=="{") || (key_rows[key_selected[1]][key_selected[0]].tochar()=="}"))
					keyboard_select_relative( -1, 0 )
				count.left++
			}
		}

		else if ( sig == "right" ) {
			if (checkrepeat(count.right)){
				keyboard_select_relative( 1, 0 )
				while ((key_rows[key_selected[1]][key_selected[0]].tochar()=="{") || (key_rows[key_selected[1]][key_selected[0]].tochar()=="}"))
					keyboard_select_relative( 1, 0 )
				count.right++
			}
		}

		else if ( sig == "select" ) keyboard_type( key_rows[key_selected[1]][key_selected[0]].tochar() )

		else if ( sig == "back" ) {
			kb.f_back()
			keyboard_hide()
		}

		else if (sig == "screenshot"){
			return false
		}

		return true
	}

	return false

}
