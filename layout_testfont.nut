/*
local test = fe.add_text("There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.",0,0,350,200)
test.char_size = 20
test.word_wrap = true
test.set_bg_rgb(100,0,0)

local test2 = fe.add_text("There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.",400,0,350,200)
test2.char_size = 20
test2.word_wrap = true
test2.set_bg_rgb(100,0,0)
test2.char_spacing = 2.0

pappo = 0
*/
local limits = [
[60,1],
[120,3],
[180,5],
[240,7],
[300,9],
[301,9],
[360,10],
[420,12],
[480,14],
[540,15],
[600,17],
[660,19],
[720,20],
[780,22],
[840,23],
[899,25],
[958,26],
[1018,28],
[1079,30],
[1138,31],
[1198,33],
[1258,35],
[1318,36],
[1378,38],
[1438,40],
[1498,42],
[1558,43],
[1618,45],
[1678,46],
[1737,48],
[1797,50],
[1857,52],
[1917,54],
[1977,55],
[2036,56],
[2097,58],
[2157,60],
[2216,61],
[2276,63],
[2396,66],
[2456,68],
[2516,70],
[2576,72],
[2636,74],
[2695,75],
[2755,77],
[2816,79],
[2875,80],
[2935,82],
[2995,84],
[3055,85],
[3114,86],
[3175,89],
[3294,91],
[3354,94],
[3414,95],
[3474,97],
[3534,99],
[3593,100],
[3654,102],
[3714,104],
[3773,105],
[3833,107],
[3894,109],
[3953,110],
[4013,112],
[4073,114],
[4133,115],
[4193,117],
[4252,119],
[4312,120],
[4372,122],
[4432,124],
[4492,125],
[4552,127],
[4612,129],
[4672,130],
[4732,132],
[4792,134],
[4851,135],
[4912,137],
[4972,139],
[5031,140],
[5090,142]
]

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
	title = "fonts/Figtree-Bold.ttf"
	metapics = "fonts/font_metapics.ttf"
}
/*
local pippo1 = fe.add_text ("X",0,0,300,30)
local pippo2 = fe.add_text ("XX",0,30,300,30)
local pippo3 = fe.add_text ("XX",0,60,300,30)
pippo1.font = pippo2.font = pippo3.font = uifonts.mono
pippo1.char_size = pippo2.char_size = pippo3.char_size = 120
pippo1.align = pippo2.align = pippo3.align = Align.TopLeft
pippo2.char_spacing = 3.0
pippo3.char_spacing = 4.0
print ("char width  :" + pippo1.msg_width + "px \n")
print ("char space 1:" + (pippo2.msg_width - 2.0 * pippo1.msg_width) + "\n")
print ("char space 2:" + (pippo3.msg_width - 2.0 * pippo1.msg_width) + "\n")

pluto = 0
*/

local defmessage = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
local columns = 60

function add_box(x, y, w, h, rgb, csize){
	local textbox_0 = fe.add_text(defmessage, x, y, w, h)
	textbox_0.margin = 0
	textbox_0.word_wrap = true
	textbox_0.set_bg_rgb (rgb[0], rgb[1], rgb[2])
	textbox_0.bg_alpha = 200
	textbox_0.align = Align.TopRight
	textbox_0.font = uifonts.mono
	textbox_0.zorder = 100
	textbox_0.char_spacing = 1.0
	textbox_0.char_size = 1

	while (textbox_0.lines_total == 1){
		textbox_0.char_size ++
	}
	textbox_0.char_size-- 
	print (w+" "+textbox_0.char_size+"\n")
	/*
	textbox_0.char_size = floor((w * 1.0 / columns) * 1.645)
	print (w+" "+" "+textbox_0.char_size+"\n")
	return
	*/
	/*
	foreach (i, item in limits){
		if ((w >= item[0]) && (w < limits[i+1][0])) {
			textbox_0.char_size = item[1]
			print (w+" "+item[0]+" "+item[1]+" "+textbox_0.lines_total+"\n")
			break
		}
	}
	*/
	/*
	textbox_0.char_size = csize

	local height_1 = textbox_0.char_size
	local width_1 = textbox_0.msg_width
	textbox_0.msg = "XX"
   local width_2 = textbox_0.msg_width
	textbox_0.msg = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
	local width_60 = textbox_0.msg_width
	print (height_1 + " " + width_1 + " " + (width_2 - 2 * width_1) + " " + width_60 + " " + (width_1 * 1.0 / height_1) + "\n")
	*/

	/*
	// First size definition
	local span_area = (w - 2.0 * 50 * scalerate)
	local char_width = span_area * 1.0 / columns
	local char_height = floor(char_width * 1.645)
	textbox_0.char_size = char_height

	// Size correction with spacing
	local char_real_size = (textbox_0.msg_width * 1.0 / (columns + (columns - 1) * 0.125) )

	//local blank_area = span_area - textbox_0.msg_width
	//local delta_pixel = blank_area * 1.0 / (columns - 1)

	local spacing = ( 0.25 + (span_area - columns * char_real_size)*1.0/((columns - 1) * char_real_size) ) * 1.0 / 0.375
	//textbox_0.char_spacing = spacing

	print (" span_area:" + span_area + " msg_width:" + textbox_0.msg_width + " char_real_size:" + char_real_size + "\n")
print (textbox_0.char_size+"\n")
*/
}
local zip = 0
for (local i = 300; i <= 1000; i = i + 10){
//	add_box(0, 1.5*i, 320 + i, 240, [100, i * 100 / 300, 0],i)
	add_box(0, zip, i, 240, [100, 0, 0],i)
	zip = zip + 10
}

/*
for (local i = 1; i <= 300; i = i + 1){
//	add_box(0, 1.5*i, 320 + i, 240, [100, i * 100 / 300, 0],i)
	add_box(0, 0, 20000, 2000, [100, i * 100 / 300, 0],i)
}
*/