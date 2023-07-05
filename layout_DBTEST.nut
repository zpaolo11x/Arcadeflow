print("ALLGAMES\n")

local textobj = null
local varlist = ["first", "second", "third", "fourth", "fifth", "second", "third", "fourth", "fifth", "second", "third", "fourth", "fifth", "second", "third", "fourth", "fifth", "second", "third", "fourth", "fifth", "second", "third", "fourth", "fifth", "second", "third", "fourth", "fifth", "second", "third", "fourth", "fifth", "second", "third", "fourth", "fifth", "second", "third", "fourth", "fifth", "second", "third", "fourth", "fifth", "second", "third", "fourth", "fifth", "second", "third", "fourth", "fifth", "second", "third", "fourth", "fifth"]

textobj = fe.add_text("", 0, 0, fe.layout.width, fe.layout.height)
textobj.char_size = fe.layout.height * 0.1
textobj.word_wrap = true

foreach(i, item in varlist) {
	//fe.overlay.splash_message("")
	textobj.msg = "NOW LOADING\n" + i + " " + item
	fe.layout.redraw()
}

textobj.visible = false
	
//fe.overlay.splash_message("")
fe.layout.redraw()
//fe.overlay.splash_message("")
