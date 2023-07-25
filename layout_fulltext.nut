local flw = fe.layout.width = 400
local flh = fe.layout.height = 300

local text =  "Lorem ipsum dolor sit amet, è consectetur adipiscing elit. Quisque lobortis euismod nunc id accumsan. In vitae ultrices neque. Morbi vestibulum nibh et velit euismod eleifend. Curabitur at sodales ligula. Aliquam dapibus ipsum purus, non sollicitudin arcu gravida non. Etiam eleifend eleifend nibh. Nullam a nisi quam. Sed at dui nulla. Curabitur euismod ut nisl non dignissim."

local fulltext = ""

local tboxref = fe.add_text("[Overview]", 200, 0, 150, 300)
tboxref.char_size = 15
tboxref.word_wrap = true
tboxref.set_bg_rgb(0,100,0)
tboxref.margin = 0
tboxref.align = Align.TopLeft
/*
local numlines = 100
local text = ""
for (local i = 0; i < numlines - 1; i++){
	text += format("%03i", i + 1)+"..........\n"
}
text += format("%03i", numlines)+".........."
*/

local tbox = fe.add_text("[Overview]", 0, 0, 150, 120)
tbox.char_size = 15
tbox.word_wrap = true
tbox.set_bg_rgb(100,0,0)
tbox.margin = 0
tbox.align = Align.TopLeft

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

function m_get_fulltext(tbox){
	local starthint = tbox.first_line_hint

	local hint = 1
	tbox.first_line_hint = hint
print ("hint:"+hint+" flh:"+tbox.first_line_hint+"\n**********\n"+tbox.msg_wrapped+"************\n\n")
	local text_part = tbox.msg_wrapped
	local numlines = m_split_complete(text_part, "\n").len() - 1

	while (hint == tbox.first_line_hint){
		fulltext += text_part
		hint = hint + numlines
		tbox.first_line_hint = hint
		text_part = tbox.msg_wrapped
print ("hint:"+hint+" flh:"+tbox.first_line_hint+"\n**********\n"+tbox.msg_wrapped+"************\n\n")
	}

	local deltalines = hint - tbox.first_line_hint
	local endlines = m_split_complete(tbox.msg_wrapped,"\n")
	for (local i = deltalines; i < endlines.len() - 2; i++) {
		fulltext += endlines[i] + "\n"
	}
	fulltext += endlines[endlines.len() - 2]
	tbox.first_line_hint = starthint
	return fulltext

}
m_get_fulltext(tbox)
	//print ("\n*******"+m_get_fulltext(tbox)+"*******\n")

function get_max_hint(){
	
	local hint0 = 1
	local hint = 1
	tbox.first_line_hint = 1
	local wraptext = ""
	local lines = 0
	local lines0 = 0
	local overhint = 0

	tbox.first_line_hint = hint
	lines = m_split_complete(tbox.msg_wrapped,"\n").len()
	lines0 = lines

	while ((lines0 == lines) && (tbox.first_line_hint == hint)){
		hint0 = hint
		hint = hint + lines - 1
		lines0 = lines
		tbox.first_line_hint = hint
		if (tbox.first_line_hint != hint) overhint = tbox.first_line_hint
		lines = m_split_complete(tbox.msg_wrapped,"\n").len()	
	}

	local hintmax = (overhint != 0) ? overhint : hint0
	tbox.first_line_hint = 1

	return(hintmax)
}

function setline(line_hint){
	print ("SET:"+line_hint+"\n")
	tbox.first_line_hint = line_hint
	print ("***\n"+tbox.msg_wrapped+"***"+"\n")
	print ("NLN:"+(m_split_complete(tbox.msg_wrapped,"\n").len() - 1)+"\n")
	print ("GET:"+tbox.first_line_hint+"\n")
	print ("----------------------------------------------\n\n")	
}

function get_max_hint_2(){
	local line_start = 1
	local line_stop = 300
	setline(1)

	local lines_zero = m_split_complete(tbox.msg_wrapped,"\n").len()

	setline(line_stop)

	for (local i = 0; i <= 300; i++){
		setline (i)
	}
	/*
	while (tbox.first_line_hint != line_stop){
		line_stop = floor((line_stop - line_start) * 0.5)
		setline(line_stop)
	}
	*/
}
