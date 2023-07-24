fe.layout.mouse_pointer = true

local flw = fe.layout.width
local flh = fe.layout.height

local dbg = fe.add_text ( "dupa", 0, 0, flw, flh/16 )
dbg.align = Align.TopLeft

local txt = fe.add_text ( "dupa", 0, flh/16, flw, flh - flh/16 )
txt.align = Align.TopLeft
txt.char_size = dbg.char_size
txt.word_wrap = true

fe.add_transition_callback( "on_transition" )
function on_transition( ttype, var, ttime )
{
    switch( ttype )
    {
        case Transition.ToNewSelection:
            txt.first_line_hint += var > 0 ? 1 : -1
            dbg.msg = txt.first_line_hint
            break
    }
}

txt.msg = ""

local text = ""

for ( local i = 1; i < 200; i++ )
    text += format("%03u", i) + "\n";

txt.msg = text

dbg.msg = txt.first_line_hint
/*
local flw = fe.layout.width = 400
local flh = fe.layout.height = 300

local numlines = 100
local fulltext = ""
for (local i = 0; i < numlines - 1; i++){
	fulltext += format("%03i", i + 1)+"..........\n"
}
fulltext += format("%03i", numlines)+".........."

local tbox = fe.add_text(fulltext, 0, 0, 100, 200)
tbox.char_size = 15
tbox.word_wrap = true
tbox.set_bg_rgb(100,0,0)

function setline(line_hint){
	print ("SET:"+line_hint+"\n")
	tbox.first_line_hint = line_hint
	print ("***\n"+tbox.msg_wrapped+"***"+"\n")
	print ("GET:"+tbox.first_line_hint+"\n")
	print ("----------------------------------------------\n")	
}

local hintline = 1

function get_max_hint_2(){
	for (local i = 1; i <= 200; i++){
		setline (i)
	}
}

//local max_hint = get_max_hint_2()

local tbox2 = fe.add_text(fulltext, 100, 0, 100, 200)
tbox2.char_size = 15
tbox2.word_wrap = true
tbox2.set_bg_rgb(0,0,100)
//tbox2.first_line_hint = max_hint

fe.add_signal_handler( this, "on_signal" )

function on_signal(sig){
	if (sig == "down"){
		hintline ++
		setline (hintline)
		return true
	}
}
*/