local sizesum = 0
for (local size = 5; size <= 100; size=size+1){
	local	text1 = fe.add_text(" 0 1 2 3 4 5 6 ",0,sizesum,1280,100)
	text1.font = "fonts/font_metapics.ttf"
	text1.char_size = size
	sizesum = sizesum + size
}