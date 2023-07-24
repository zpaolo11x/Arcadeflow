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

local max_hint = get_max_hint_2()

local tbox2 = fe.add_text(fulltext, 100, 0, 100, 200)
tbox2.char_size = 15
tbox2.word_wrap = true
tbox2.set_bg_rgb(0,0,100)
//tbox2.first_line_hint = max_hint