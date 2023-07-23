local txt = fe.add_text( "dupa", 0, 0, fe.layout.width, fe.layout.height )
txt.char_size = 32
txt.align = Align.TopLeft

local str = ""

function countlines(str_in) {
	local num = 0
	local i = str_in.find("\n")
	while (i != null){
		num++
		str_in = str_in.slice(i+1)
		i = str_in.find("\n")
	}
	return (num + 1)
}

print (countlines("pippo*pluto*o***aoerino")+"\n")

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

local target = 100000

function getstr(){
	while (str.len() <= target - 100){
		str = str + format("%010i", str.len())+".........................................................................................\n"
	}
	str = str + format("%010i", str.len())+"........................................................................................."
}
print("A\n")
getstr()
print("B\n")
print (str.len()+"\n")
print (str+"\n")

local tbox = fe.add_text(str,0,0,fe.layout.width,fe.layout.height)
tbox.word_wrap = true
tbox.align = Align.TopLeft
tbox.char_size = 25
local hint0 = 0
local hint = 1
tbox.first_line_hint = 1
local wraptext = ""
local lines = 0
local lines0 = 0

local t0 = fe.layout.time
print("START\n")
tbox.first_line_hint = hint
lines = split_complete(tbox.msg_wrapped,"\n").len()
lines0 = lines
while (lines0 == lines){
	/*
	print ("-------------------------------------------------------------------\n")
	print ("HINT0:"+hint0+" HINT:"+hint+"\n")
	print ("LINES0:"+lines0+" LINES:"+lines+"\n")
	print ("*\n"+tbox.msg_wrapped+"*\n")
	print ("-------------------------------------------------------------------\n")
	*/
	hint0 = hint
	hint = hint + lines - 1
	lines0 = lines
	tbox.first_line_hint = hint
	lines = split_complete(tbox.msg_wrapped,"\n").len()	
}

print("STOP\n")
print ((fe.layout.time - t0)+"\n")
local hintmax = hint0
tbox.first_line_hint = hintmax


fe.add_ticks_callback( "on_tick" )
function on_tick ( ttime )
{
	
    //str = str + "...................................................................................................."
    //txt.msg = str.len()
}