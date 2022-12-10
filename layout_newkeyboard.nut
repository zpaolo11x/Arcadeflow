// Arcadeflow - v 10.9
// Attract Mode Theme by zpaolo11x
//
// Based on carrier.nut scrolling module by Radek Dutkiewicz (oomek)
// Including code from the KeyboardSearch plugin by Andrew Mickelson (mickelson)

// Load modules
function printline(linein){
	print (linein + " : "+ fe.layout.time +"\n")
}
//fe.load_module("file")
fe.do_nut("nut_file.nut")

// COME CAMBIA AR DA AF98
/*
Modificare la funzione GetAR in modo che restituisca l'AR _DA MOSTRARE_ pre-clamp,
così per il GG è 4/3 come letto da System, per MAME è 3:4 o 4:3 secondo "orientation"
per altri handheld è texture W/H stretto, se siamo in boxart mode è semplicemente texture W/H

l'AR poi viene clampato o snapcroppato, a quel punto viene definita la dimensione dell'artwork.
*/
for (local i = 0; i < 256;i++){
	print ("* "+i.tochar()+" *\n")
}
//EASE PRINT
local CCC = 0

local elapse = {
	name = ""
	t1 = 0
	t2 = 0
	timer = false
}

local ap = '"'.tochar()

function powerman(action){
	if (action == "SHUTDOWN"){
		if (OS == "OSX") system("osascript -e 'tell app "+ap+"System Events"+ap+" to shut down'")
		else if (OS == "Windows") system ("shutdown /s /t 0")
		else system ("sudo shutdown -h now")
	}
	if (action == "REBOOT"){
		if (OS == "OSX") system("osascript -e 'tell app "+ap+"System Events"+ap+" to restart'")
		else if (OS == "Windows") system ("shutdown /r /t 0")
		else system ("sudo reboot")
	}
	if (action == "SUSPEND"){
		if (OS == "OSX") system("osascript -e 'tell app "+ap+"System Events"+ap+" to sleep'")
		else if (OS == "Windows") system ("shutdown /h")
		else system ("sudo pm-hibernate")
	}
}

function timestart(name){
	if (!elapse.timer) return
	print ("\n    "+name+" START\n")
	elapse.name = name
	elapse.t1 = fe.layout.time
}
function timestop(){
	if (!elapse.timer) return
	elapse.t2 = fe.layout.time
	print("\n    "+elapse.name+" STOP: "+(elapse.t2-elapse.t1)+"\n\n")
}
/*
function createdata_GOOD_FOR_RATINGS(){
	local filepath = fe.path_expand( "/Users/paolozago/mame/folders/bestgames.ini")
   local inputfile = ReadTextFile (filepath)
   local out = ""
	local datatable = {}

	//skip to root folder
	while (out != "[ROOT_FOLDER]"){
		out = inputfile.read_line()
	}

	local out = "_"
	for (local value = 1; value <= 10; value++){
		while ((out[0].tochar() != "[")  && (!inputfile.eos())){
			out = inputfile.read_line()
			if (out == "") out = "_"
		}
		out = "_"
		while ((out[0].tochar() != "[") && (!inputfile.eos())) {
			out = inputfile.read_line()
			if ((out != "") && (out[0].tochar() != "[")) datatable[out] <- value
			if (out == "") out = "_"
		}
	}
}
*/


function extradatatable(inputfile){
	local filepath = fe.path_expand(inputfile)

	if (!file_exist(filepath)) return {}

   local inputfile = ReadTextFile (filepath)
   local out = ""
	local datatable = {}
	local value = ""

	//skip to root folder
	while (out != "[ROOT_FOLDER]"){
		out = inputfile.read_line()
	}

	local out = "_"
	while (!inputfile.eos()){
		while ((out[0].tochar() != "[")){
			out = inputfile.read_line()
			if (out == "") out = "_"
		}
		value = out.slice(1,-1)
		out = "_"
		while ((out[0].tochar() != "[") && (!inputfile.eos())) {
			out = inputfile.read_line()
			if ((out != "") && (out[0].tochar() != "[")) datatable[out] <- value
			if (out == "") out = "_"
		}
	}

	return datatable
}

local ratetonumber = {}
ratetonumber["0 to 10 (Worst)"] <- "1.0"
ratetonumber["10 to 20 (Horrible)"] <- "2.0"
ratetonumber["20 to 30 (Bad)"] <- "3.0"
ratetonumber["30 to 40 (Amendable)"] <- "4.0"
ratetonumber["40 to 50 (Decent)"] <- "5.0"
ratetonumber["50 to 60 (Not Good Enough)"] <- "6.0"
ratetonumber["60 to 70 (Passable)"] <- "7.0"
ratetonumber["70 to 80 (Good)"] <- "8.0"
ratetonumber["80 to 90 (Very Good)"] <- "9.0"
ratetonumber["90 to 100 (Best Games)"] <- "10.0"

local IDX = array(100000)

foreach (i, item in IDX) {IDX[i] = format("%s%5u","\x00",i)}

function afsort(arr_in, arr_mixval){

	foreach (i, item in arr_in){
		arr_mixval[i] = arr_mixval[i] + IDX[i]
	}

	arr_mixval.sort()

	arr_mixval.apply(function(value){
		return (arr_in[(value.slice (-5)).tointeger()])
	})

	return arr_mixval
}

/*
	z_list.gametable = afsort2(z_list.gametable,
	z_list.gametable.map(function(a){return(nameclean(a.z_title).tolower())}),
	z_list.gametable.map(function(a){return("|"+a.z_system.tolower())}),
	reverse)

	arr_in is the array that needs to be sorted
	arr_keyval is the value that is used as a key to do the sorting
	arr_extval is the secondary sort order
	reverse toggle reverse order sort

	A fake array is created, each entry being arr_keyval + arr_extval + IDX
*/

function afsort2(arr_in, arr_keyval, arr_extval, reverse){

	foreach (i, item in arr_in){
		arr_extval[i] = arr_keyval[i] + arr_extval[i] + IDX[i]
	}

	arr_extval.sort()

	local sortedindex = arr_extval.map(function(value){
			return (value.slice (-5)).tointeger()
		})

	arr_extval.apply(function(value){
			return (arr_in[(value.slice (-5)).tointeger()])
		})
	if (reverse)  {
		local packetarray = []
		local j = 0
		local temp = arr_keyval[sortedindex[0]]

		packetarray.push([])
		foreach (i, item in arr_extval){
			if (arr_keyval[sortedindex[i]] == temp)
				packetarray[j].push(item)
			else {
				temp = arr_keyval[sortedindex[i]]
				packetarray.push([])
				j = j + 1
				packetarray[j].push(item)
			}
		}
		local outarray = []
		for (local i = packetarray.len() - 1 ; i >= 0; i--){
			outarray.extend(packetarray[i])
		}
		arr_extval = outarray
	}

	return arr_extval

}

function gly(index){
	local uniglyphs = ["","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""]
	local unizero = 0xe900
	try {return (uniglyphs[index-unizero])} catch (err) {return ""}
}


local AF = {
	version = "10.9"
	vernum = 109
	folder = fe.script_dir
	subfolder = ""
	bgsongs = []

	prefs = {
		l0 = []
		a0 = []
		l1 = []
		gl0 = [] //glyph array
		imgpath = "help_images/"
		imgext = ".jpg"
		getout = false
		defaults = null
		driveletters = null
	}

	updatechecking = false
	boxmessage = [""]
	messageoverlay = null
	tsc = 1.0 // Scaling of timer for different parameters

	scrape = {
		stack = []
		regiontable = ["wor","us","eu","ss","jp"]
		regionprefs = [] //This will be populated by options table
		checktable = {}
		purgedromdirlist = null
		listoflists = null
		emudata = null
		forcemedia = false
		romlist = ""
		inprf = {}
		scrapelist_file = null
		scrapelist_lines = null
		romlist_file = null
		romlist_lines = null
		quit = false
		totalroms = 0
		doneroms = 0
		columns = 60
		separator1 = ""
		separator2 = ""
		onegame = ""
		dispatchid = 0
		requests = ""
		report = {}
		threads = 0
	}
}
AF.subfolder = AF.folder.slice(AF.folder.find("layouts"))
for (local i = 0 ; i < AF.scrape.columns;i++){
	AF.scrape.separator1 += "-"
	AF.scrape.separator2 += "="
}
local zmenu = null

//fe.list.search_rule = "" //TEST85

// Load language file
fe.do_nut("nut_language.nut")
local TLNG = "EN"
try {TLNG = loadlanguage ()} catch (err){}
// Language is first taken from file if present. If it's not present "EN" is used. After settings the language is updated and file is updated too.

if (FeVersionNum < 250) fe.overlay.splash_message (ltxt("Arcadeflow requires at least Attract Mode v2.5.0",TLNG))

function exitcommand(){
	local tempfile = ReadTextFile ( fe.path_expand( FeConfigDirectory + "attract.cfg" ) )
	local index0 = 0
	local command = ""
	local args = ""
	while (!tempfile.eos()){
		local templine = tempfile.read_line()
		local templine2 = ""
		local templine3 = ""
		index0 = templine.find("exit_command")
		if (index0 != null) {
			templine2 = strip(templine.slice(index0+12,templine.len()))
			if (templine2 == "") return
			system (templine2)
			return
		}
	}
}

// for debug purposes
function loaddebug(){
   local debugpath = fe.path_expand( AF.folder + "pref_debug.txt")
   local debugfile = ReadTextFile (debugpath)
   local out = debugfile.read_line()
   return (out == "true")
}

function savedebug(savecode){
   local debugpath = fe.path_expand( AF.folder + "pref_debug.txt")
   local debugfile = WriteTextFile (debugpath)
   debugfile.write_line(savecode)
}

local DBGON = false
try {DBGON = loaddebug()} catch (err) {}

function debugpr (instring){
	if (DBGON) print (instring)
}

function scraprt (instring){
	print (instring)
}

function testpr (instring){
	print (instring)
}

function testprln (instring){
	print (instring+"\n")
}

function testprln2 (instring){
	print ("\n"+instring+"\n\n")
}

function unzipfile (zipfilepath, outputpath){
   local ap = '"'.tochar()
   local zipdir = zip_get_dir (zipfilepath)
   local blb = null
   local fout = null

	// Create output folder if needed
   system ("mkdir " + ap + outputpath + ap)

   foreach (id, item in zipdir){

      // Item is a folder, create it
      if ((item.slice(-1)=="/") && (!(split(item,"/")[split(item,"/").len()-1].slice(0,1)=="."))) {
         system ("mkdir " + ap + outputpath + item + ap)
      }

      // Item is a file, unpack it to the proper folder
      if ((item.slice(-1)!="/") && (!(split(item,"/")[split(item,"/").len()-1].slice(0,1)=="."))) {
         local savepath = fe.path_expand(outputpath + item)
         fout = file( savepath, "wb" )
         blb = zip_extract_file( zipfilepath, item )
         fout.writeblob( blb )
      }
   }
}

function savetabletofile(table,file_name){
	if (table == null) return
	local tempfile = WriteTextFile ( fe.path_expand( AF.folder + file_name ) )
	foreach (cell,val in table){
		local savestring = "|"+cell
		foreach (i, item in val){
			savestring = savestring + "|" + item
		}
		savestring = savestring+"|\n"
		tempfile.write_line(savestring)
	}
}

function loadtablefromfile (file_name,textonly){
	if (!(file_exist(fe.path_expand( AF.folder + file_name )))) return null
	local tempfile = ReadTextFile ( fe.path_expand( AF.folder + file_name ) )
	local table = {}
	while (!tempfile.eos()){
		local templine = tempfile.read_line()
		local temparray = split(templine,"|")
		local outarray = []
		for (local i = 1 ; i < temparray.len();i++){
			local tempval = temparray[i]
			if (!textonly){
				try {
					tempval = tempval.tointeger()
				} catch (err) {
					if (tempval == "true") tempval = true
					else if (tempval =="false") tempval = false
				}
			}
			outarray.push (tempval)
		}
		table[temparray[0]] <- outarray
	}
	return table
}

fe.do_nut("nut_picfunctions.nut")
fe.do_nut("nut_gauss.nut")
fe.do_nut("nut_scraper.nut")
dofile( AF.folder + "nut_fileutil.nut" )


// CRC BANCHMARK
/*
local crr = {
	tttt0 = 0
	tttt1 = 0
	fil = "/Volumes/Ext256/ROMS/snes/Star Ocean (Japan).zip"
}
crr.tttt0 = fe.layout.time
testpr ("CRC:" + (getromcrc_old(crr.fil))[0] + " ")
crr.tttt1 = fe.layout.time
testpr(crr.tttt1-crr.tttt0+"msec\n")

crr.tttt0 = fe.layout.time
testpr ("CRC:" + (getromcrc(crr.fil))[0] + " ")
crr.tttt1 = fe.layout.time
testpr(crr.tttt1-crr.tttt0+"msec\n")

crr.tttt0 = fe.layout.time
testpr ("CRC:" + (getromcrc_halfbyte(crr.fil))[0] + " ")
crr.tttt1 = fe.layout.time
testpr(crr.tttt1-crr.tttt0+"msec\n")

crr.tttt0 = fe.layout.time
testpr ("CRC:" + (getromcrc_lookup(crr.fil))[0] + " ")
crr.tttt1 = fe.layout.time
testpr(crr.tttt1-crr.tttt0+"msec\n")

crr.tttt0 = fe.layout.time
testpr ("CRC:" + (getromcrc_lookup4(crr.fil))[0] + " ")
crr.tttt1 = fe.layout.time
testpr(crr.tttt1-crr.tttt0+"msec\n")
*/
//missing_manufacturer_list_vector()

/// Preferences functions and table
function letterdrives(){
	local letters = "CDEFGHIJKLMNOPQRSTUVWXYZ"
	local drives = []
	foreach (i, item in letters){
		if (fe.path_test ( item.tochar() + ":" , PathTest.IsDirectory) ) drives.push (item.tochar()+":\\")
	}

	//	return (drives.len() > 0 ? drives : ["/"])
	return drives
}

AF.prefs.driveletters = letterdrives()

local prf = null
local selection_pre = null

local umtable = []
local umpresel = 0
local umvisible = false

local multifilterz = {}
multifilterz.l0 <- {}

function umtablenames(tablein){
	local n0 = []
	tablein.sort(@(a,b) a.id <=> b.id)
	foreach (i, item in tablein){
		n0.push((item.glyph == -1) ? "----- "+item.label: item.label)
	}
	return n0
}

function mfztablenames(tablein){
	local outnames = []
	foreach (item, val in tablein){
		outnames.push (item)
	}
	outnames.sort(@(a,b) ltxt(a,TLNG).tolower() <=> ltxt(b,TLNG).tolower())
	foreach (i, item in outnames){
		outnames[i] = ltxt(item,TLNG)
	}
	return (outnames)
}

function sortstring(num){
	local strz=""
	for (local i=1;i<=num;i++){
		strz=strz+i+","
	}
	return strz
}

function languageflags() {
	local inputarray = languagetokenarray()
	local out = inputarray
	foreach (i, item in inputarray){
		out[i] = "flags" + out[i] + AF.prefs.imgext
	}
	return out
}

local menucounter = 0

AF.prefs.l0.push({label = "GENERAL", glyph = 0xe993, description = "Define the main options of Arcadeflow like number of rows, general layout, control buttons, language, thumbnail source etc"})
AF.prefs.l1.push([
{v = 10.2, varname = "layoutlanguage", glyph = 0xe9ca, initvar = function(val,prf){prf.LAYOUTLANGUAGE <- val}, title = "Layout language", help = "Chose the language of the layout" , options = languagearray(), values = languagetokenarray(), selection = 1, picsel = languageflags(),pic="flags.jpg"},
{v = 10.5, varname = "powermenu", glyph = 0xe9b6, initvar = function(val,prf){prf.POWERMENU <- val}, title = "Power menu", help = "Enable or disable power options in exit menu" , options = ["Yes","No"], values = [true,false], selection = 1},
{v = 0.0, varname = "", glyph = -1, title = "Layout", selection = -10},
{v = 7.2, varname = "horizontalrows", glyph = 0xea72, initvar = function(val,prf){prf.HORIZONTALROWS <- val}, title = "Rows in horizontal", help = "Number of rows to use in 'horizontal' mode" , options = ["1-Small", "1", "2", "3"], values = [-1,1,2,3], selection = 2, picsel = ["rows1mini"+AF.prefs.imgext,"rows1"+AF.prefs.imgext,"rows2"+AF.prefs.imgext,"rows3"+AF.prefs.imgext],pic = "rows2"+AF.prefs.imgext},
{v = 7.2, varname = "verticalrows", glyph = 0xea71, initvar = function(val,prf){prf.VERTICALROWS <- val}, title = "Rows in vertical", help = "Number of rows to use in 'vertical' mode" , options = ["1", "2", "3"], values = [1,2,3], selection = 2, picsel = ["rowsv1"+AF.prefs.imgext,"rowsv2"+AF.prefs.imgext,"rowsv3"+AF.prefs.imgext],pic = "rowsv3"+AF.prefs.imgext},
{v = 7.2, varname = "cleanlayout", glyph = 0xe997, initvar = function(val,prf){prf.CLEANLAYOUT <- val}, title = "Clean layout", help = "Reduce game data shown on screen" , options = ["Yes","No"], values = [true,false], selection = 1, picsel = ["cleanyes"+AF.prefs.imgext,"cleanno"+AF.prefs.imgext],pic = "cleanyes"+AF.prefs.imgext},
{v = 7.2, varname = "lowres", glyph = 0xe997, initvar = function(val,prf){prf.LOWRES <- val}, title = "Low resolution", help = "Optimize theme for low resolution screens, 1 row layout forced, increased font size and cleaner layout" , options = ["Yes","No"], values = [true,false], selection = 1,picsel = ["lowreson"+AF.prefs.imgext,"lowresoff"+AF.prefs.imgext],pic = "lowreson"+AF.prefs.imgext},
{v = 7.2, varname = "baserotation", glyph = 0xea2e, initvar = function(val,prf){prf.BASEROTATION <- val}, title = "Screen rotation", help = "Rotate screen" , options = ["None", "Left", "Right", "Flip"], values =["none", "left", "right", "flip"], selection =0,picsel=["rotnone"+AF.prefs.imgext,"rotleft"+AF.prefs.imgext,"rotright"+AF.prefs.imgext,"rotflip"+AF.prefs.imgext],pic = "rotright"+AF.prefs.imgext},
{v = 0.0, varname = "", glyph = -1, title = "Game Data", selection = -10},
{v = 7.2, varname = "showsubname", glyph = 0xea6d, initvar = function(val,prf){prf.SHOWSUBNAME <- val}, title = "Display Game Long Name", help = "Shows the part of the rom name with version and region data" , options = ["Yes","No"], values = [true,false], selection = 0, picsel = ["subdefaultname"+AF.prefs.imgext,"subnosubname"+AF.prefs.imgext]},
{v = 7.2, varname = "showsysname", glyph = 0xea6d, initvar = function(val,prf){prf.SHOWSYSNAME <- val}, title = "Display System Name", help = "Shows the System name under the game title" , options = ["Yes","No"], values = [true,false], selection = 0, picsel = ["subdefaultname"+AF.prefs.imgext,"subnosystem"+AF.prefs.imgext]},
{v = 10.1, varname = "showarcadename", glyph = 0xea6d, initvar = function(val,prf){prf.SHOWARCADENAME <- val}, title = "Display Arcade System Name", help = "Shows the name of the Arcade system if available" , options = ["Yes","No"], values = [true,false], selection = 0},
{v = 7.2, varname = "showsysart", glyph = 0xea6d, initvar = function(val,prf){prf.SHOWSYSART <- val}, title = "System Name as artwork", help = "If enabled, the system name under the game title is rendered as a logo instead of plain text" , options = ["Yes","No"], values = [true,false], selection = 0, picsel = ["subdefaultname"+AF.prefs.imgext,"subnosystemart"+AF.prefs.imgext]},
{v = 0.0, varname = "", glyph = -1, title = "Scroll & Sort", selection = -10},
{v = 10.3, varname = "scrollamount", glyph = 0xea45, initvar = function(val,prf){prf.SCROLLAMOUNT <- val}, title = "Page jump size", help = "Page jumps are one screen by default, you can increase it if you want to jump faster" , options = ["1 Screen", "2 Screens", "3 Screens"], values = [1, 2, 3] , selection = 0},
{v = 7.2, varname = "scrollertype", glyph = 0xea45, initvar = function(val,prf){prf.SCROLLERTYPE <- val}, title = "Scrollbar style", help = "Select how the scrollbar should look" , options = ["Timeline", "Scrollbar", "Label List"], values = ["timeline", "scrollbar", "labellist"] , selection = 0, picsel = ["scrolltimeline"+AF.prefs.imgext,"scrollscrollbar"+AF.prefs.imgext,"scrolllabellist"+AF.prefs.imgext],pic="scroll"+AF.prefs.imgext},
{v = 7.2, varname = "striparticle", glyph = 0xea4c, initvar = function(val,prf){prf.STRIPARTICLE <- val}, title = "Strip article from sort", help = "When sorting by Title ignore articles" , options = ["Yes","No"], values = [true,false], selection = 1},
{v = 10.9, varname = "enablesort", glyph = 0xea4c, initvar = function(val,prf){prf.ENABLESORT <- val}, title = "Enable sorting", help = "Enable custom realtime sorting, diable to keep romlist sort order" , options = ["Yes","No"], values = [true,false], selection = 0},
{v = 7.2, varname = "sortsave", glyph = 0xea4c, initvar = function(val,prf){prf.SORTSAVE <- val}, title = "Save sort order", help = "Custom sort order is saved through Arcadeflow sessions" , options = ["Yes","No"], values = [true,false], selection = 0},
{v = 0.0, varname = "", glyph = -1, title = "Danger Zone", selection = -10},
{v = 10.9, varname = "enabledelete", glyph = 0xe9ac, initvar = function(val,prf){prf.ENABLEDELETE <- val}, title = "Enable rom delete", help = "Enable or disable the options to delete a rom" , options = ["Yes","No"], values = [true,false], selection = 1},
])

menucounter ++
AF.prefs.l0.push({label = "BUTTONS", glyph = 0xea54, description = "Define custom control buttons for different features of Arcadeflow"})
AF.prefs.l1.push([
{v = 7.2, varname = "overmenubutton", glyph = 0xea54, initvar = function(val,prf){prf.OVERMENUBUTTON <- val}, title = "Context menu button", help = "Chose the button to open the game context menu" , options = ["None","Select", "Custom 1", "Custom 2", "Custom 3", "Custom 4", "Custom 5", "Custom 6"], values=["none","select", "custom1", "custom2", "custom3", "custom4", "custom5", "custom6"], selection = 1,pic = "contextmenu"+AF.prefs.imgext},
{v = 7.2, varname = "utilitymenubutton", glyph = 0xea54, initvar = function(val,prf){prf.UTILITYMENUBUTTON <- val}, title = "Utility menu button", help = "Chose the button to open the utility menu" , options = ["None", "Up", "Custom 1", "Custom 2", "Custom 3", "Custom 4", "Custom 5", "Custom 6"], values =["none", "up", "custom1", "custom2", "custom3", "custom4", "custom5", "custom6"], selection = 1,pic = "utilitymenu"+AF.prefs.imgext},
{v = 7.2, varname = "historybutton", glyph = 0xea54, initvar = function(val,prf){prf.HISTORYBUTTON <- val}, title = "History page button", help = "Chose the button to open the history or overview page" , options = ["None", "Select", "Custom 1", "Custom 2", "Custom 3", "Custom 4", "Custom 5", "Custom 6"], values =["none", "select", "custom1", "custom2", "custom3", "custom4", "custom5", "custom6"], selection = 0,pic = "bgcustomhistory"+AF.prefs.imgext},
{v = 7.2, varname = "switchmodebutton", glyph = 0xea54, initvar = function(val,prf){prf.SWITCHMODEBUTTON <- val}, title = "Thumbnail mode button", help = "Chose the button to use to switch from snapshot mode to box art mode" , options = ["None", "Custom 1", "Custom 2", "Custom 3", "Custom 4", "Custom 5", "Custom 6"], values=["none", "custom1", "custom2", "custom3", "custom4", "custom5", "custom6"], selection = 3,pic = "boxarton"+AF.prefs.imgext},
{v = 7.5, varname = "searchbutton", glyph = 0xea54, initvar = function(val,prf){prf.SEARCHBUTTON <- val}, title = "Search menu button", help = "Chose the button to use to directly open the search menu instead of using the utility menu" , options = ["None", "Custom 1", "Custom 2", "Custom 3", "Custom 4", "Custom 5", "Custom 6"], values=["none", "custom1", "custom2", "custom3", "custom4", "custom5", "custom6"], selection = 0,pic = "inputscreenkeys"+AF.prefs.imgext},
{v = 7.6, varname = "categorybutton", glyph = 0xea54, initvar = function(val,prf){prf.CATEGORYBUTTON <- val}, title = "Category menu button", help = "Chose the button to use to open the list of game categories" , options = ["None", "Custom 1", "Custom 2", "Custom 3", "Custom 4", "Custom 5", "Custom 6"], values=["none", "custom1", "custom2", "custom3", "custom4", "custom5", "custom6"], selection = 0},
{v = 7.6, varname = "multifilterbutton", glyph = 0xea54, initvar = function(val,prf){prf.MULTIFILTERBUTTON <- val}, title = "Multifilter menu button", help = "Chose the button to use to open the menu for dynamic filtering of romlist" , options = ["None", "Custom 1", "Custom 2", "Custom 3", "Custom 4", "Custom 5", "Custom 6"], values=["none", "custom1", "custom2", "custom3", "custom4", "custom5", "custom6"], selection = 0},
{v = 9.8, varname = "deletebutton", glyph = 0xea54, initvar = function(val,prf){prf.DELETEBUTTON <- val}, title = "Delete ROM button", help = "Chose the button to use to delete the current rom from the disk. Deleted roms are moved to a -deleted- folder" , options = ["None", "Custom 1", "Custom 2", "Custom 3", "Custom 4", "Custom 5", "Custom 6"], values=["none", "custom1", "custom2", "custom3", "custom4", "custom5", "custom6"], selection = 0},
])

menucounter ++
AF.prefs.l0.push({label = "UTILITY MENU", glyph = 0xe9bd, description = "Customize the utility menu entries that you want to see in the menu"})
AF.prefs.l1.push([
{v = 10.5, varname = "umvector", glyph = 0xe9bd, initvar = function(val,prf){prf.UMVECTOR <- val}, title = "Customize Utility Menu", help = "Sort and select Utility Menu entries: Left/Right to move items up and down, Select to enable/disable item" , options = function(){return(umtablenames(umtable))}, values = sortstring(18), selection = -4},
{v = 10.5, varname = "umvectorreset", glyph = 0xe965, initvar = function(val,prf){prf.UMVECTORRESET <- val}, title = "Reset Utility Menu", help = "Reset sorting and selection of Utility Menu entries" , options = "", values = function(){AF.prefs.l1[2][0].values = sortstring(18)}, selection = -2},
])

menucounter ++
AF.prefs.l0.push({ label = "SCRAPE AND XML IMPORT", glyph = 0xea80, description = "You can use Arcadeflow internal scraper to get metadata and media for your games, or you can import XML data in EmulationStation format"})
AF.prefs.l1.push([
{v = 0.0, varname = "", glyph = -1, title = "SCRAPING", selection = -10},
{v = 10.0, varname = "scraperomlist", glyph = 0xe9c2, initvar = function(val,prf){prf.SCRAPEROMLIST <- val}, title = "Scrape current romlist", help = "Arcadeflow will scrape your current romlist metadata and media, based on your options" , options = "", values = function(){local tempprf = generateprefstable();scraperomlist2(tempprf,tempprf.MEDIASCRAPE,"")},selection = -2},
{v = 10.1, varname = "scrapegame", glyph = 0xe9c2, initvar = function(val,prf){prf.SCRAPEGAME <- val}, title = "Scrape selected game", help = "Arcadeflow will scrape only metadata and media for current game" , options = "", values = function(){local tempprf = generateprefstable();scraperomlist2(tempprf,tempprf.MEDIASCRAPE,getcurrentgame())},selection = -2},
{v = 10.9, varname = "buildxml", glyph = 0xe9c2, initvar = function(val,prf){prf.BUILDXML <- val}, title = "Build gamelist xml", help = "You can export your romlist in the XML format used by EmulationStation" , options = "", values = function(){buildgamelistxml()},selection = -2},
{v = 10.3, varname = "nocrc", glyph = 0xe9c4, initvar = function(val,prf){prf.NOCRC <- val}, title = "Enable CRC check", help = "You can enable rom CRC matching (slower) or just name matching (faster)" , options = ["Yes","No"], values = [false,true],selection = 0},
{v = 10.1, varname = "romscrape", glyph = 0xe9c4, initvar = function(val,prf){prf.ROMSCRAPE <- val}, title = "Rom Scrape Options", help = "You can decide if you want to scrape all roms, only roms with no scrape data or roms with data that don't pefectly match" , options = ["All roms","Skip CRC matched", "Skip name matched","Error only"], values= ["ALL_ROMS","SKIP_CRC","SKIP_NAME","MISSING_ROMS"],selection = 1},
{v = 10.0, varname = "mediascrape", glyph = 0xe90d, initvar = function(val,prf){prf.MEDIASCRAPE <- val}, title = "Media Scrape Options", help = "You can decide if you want to scrape all media, overwriting existing one, or only missing media. You can also disable media scraping" , options = ["Overwrite media", "Only missing","No media scrape"], values= ["ALL_MEDIA","MISSING_MEDIA","NO_MEDIA"],selection = 1},
{v = 10.0, varname = "regionprefs", glyph = 0xe9ca, initvar = function(val,prf){prf.REGIONPREFS <- val}, title = "Region Priority", help = "Sort the regions used to scrape multi-region media and metadata in order of preference" , options = function(){return(AF.scrape.regiontable)}, values = sortstring(5), selection = -4},
{v = 10.0, varname = "resetregions", glyph = 0xe965, initvar = function(val,prf){prf.RESETREGIONS <- val}, title = "Reset Region Table", help = "Reset sorting and selection of Region entries" , options = "", values = function(){AF.prefs.l1[3][4].values = sortstring(5)}, selection = -2},
{v = 0.0, varname = "", glyph = -1, title = "SCREENSCRAPER", selection = -10},
{v = 10.0, varname = "ss_username", glyph = 0xe971, initvar = function(val,prf){prf.SS_USERNAME <- val}, title = "SS Username", help = "Enter your screenscraper.fr username", options = "", values = "", selection = -6},
{v = 10.0, varname = "ss_password", glyph = 0xe98d, initvar = function(val,prf){prf.SS_PASSWORD <- val}, title = "SS Password", help = "Enter your screenscraper.fr password", options = "", values = "", selection = -6},
{v = 0.0, varname = "", glyph = -1, title = "ES XML IMPORT", selection = -10},
{v = 9.7, varname = "importxml", glyph = 0xe92e, initvar = function(val,prf){prf.IMPORTXML <- val}, title = "Import XML data for all romlists", help = "If you specify a RetroPie xml path into emulator import_extras field you can build the romlist based on those data" , options = "", values = function(){local tempprf = generateprefstable();XMLtoAM2(tempprf,false);fe.signal("back");fe.signal("back");fe.set_display(fe.list.display_index)},selection = -2},
{v = 9.8, varname = "import1xml", glyph = 0xeaf4, initvar = function(val,prf){prf.IMPORT1XML <- val}, title = "Import XML data for current romlists", help = "If you specify a RetroPie xml path into emulator import_extras field you can build the romlist based on those data" , options = "", values = function(){local tempprf = generateprefstable();XMLtoAM2(tempprf,true);fe.signal("back");fe.signal("back");fe.set_display(fe.list.display_index)},selection = -2},
{v = 9.8, varname = "usegenreid", glyph = 0xe937, initvar = function(val,prf){prf.USEGENREID <- val}, title = "Prefer genreid categories", help = "If GenreID is specified in your games list, use that instead of usual categories" , options = ["Yes", "No"], values= [true,false],selection = 0},
{v = 9.8, varname = "onlyavailable", glyph = 0xe912, initvar = function(val,prf){prf.ONLYAVAILABLE <- val}, title = "Import only available roms", help = "Import entrief from the games list only if the rom file is actually available" , options = ["Yes", "No"], values= [true,false],selection = 0},
])

menucounter ++
AF.prefs.l0.push({ label = "DISPLAYS MENU PAGE", glyph = 0xe912, description = "Arcadeflow has its own Displays Menu page that can be configured here"})
AF.prefs.l1.push([
{v = 8.7, varname = "dmpenabled", glyph = 0xe912, initvar = function(val,prf){prf.DMPENABLED <- val}, title = "Enable Arcadeflow Displays Menu page", help = "If you disable Arcadeflow menu page you can use other layouts as displays menu" , options = ["Yes", "No"], values= [true,false],selection = 0},
{v = 9.0, varname = "olddisplaychange", glyph = 0xe912, initvar = function(val,prf){prf.OLDDISPLAYCHANGE <- val}, title = "Enable Fast Displays Change", help = "Disable fast display change if you want to use other layouts for different displays" , options = ["Yes", "No"], values= [false,true],selection = 0},
{v = 0.0, varname = "", glyph = -1, title = "Look and Feel", selection = -10},
{v = 7.2, varname = "dmpgeneratelogo", glyph = 0xe90d, initvar = function(val,prf){prf.DMPGENERATELOGO <- val}, title = "Generate display logo", help = "Generate displays name related artwork for displays list" , options = ["Yes","No"], values = [true,false], selection = 0,picsel=["dmplistlogoyes"+AF.prefs.imgext,"dmplistlogono"+AF.prefs.imgext], pic = "dmplistlogo"+AF.prefs.imgext},
{v = 8.9, varname = "dmpsort", glyph = 0xeaf1, initvar = function(val,prf){prf.DMPSORT <- val}, title = "Sort displays menu", help = "Show displays in the menu in your favourite order" , options = ["No sort", "By display name", "By system year", "By system brand then name", "By system brand then year"], values= ["false","display","year","brandname","brandyear"],selection = 3},
{v = 9.4, varname = "dmpseparators", glyph = 0xeaf5, initvar = function(val,prf){prf.DMPSEPARATORS <- val}, title = "Show group separators", help = "When sorting by brand show separators in the menu for each brand" , options = ["Yes", "No"], values= [true,false],selection = 0},
{v = 7.2, varname = "dmpimages", glyph = 0xea77, initvar = function(val,prf){prf.DMPIMAGES <- val}, title = "Displays menu layout", help = "Chose the style to use when entering displays menu, a simple list or a list plus system artwork taken from the menu-art folder" , options = ["List", "List with artwork"], values= [false,true],selection = 0, picsel = ["dmplistartno"+AF.prefs.imgext,"dmplistartyes"+AF.prefs.imgext],pic = "dmplistartyes"+AF.prefs.imgext},
{v = 9.8, varname = "dmart", glyph = 0xe90d, initvar = function(val,prf){prf.DMART <- val}, title = "Artwork Source", help = "Chose where the displays menu artwork comes from: Arcadeflow own system library or Attract Mode menu-art folder" , options = ["Arcadeflow only", "menu-art only", "Arcadeflow first", "menu-art first"], values= ["AF_ONLY","MA_ONLY","AF_MA","MA_AF"],selection = 0},
{v = 10.0, varname = "dmcategoryart", glyph = 0xe90d, initvar = function(val,prf){prf.DMCATEGORYART <- val}, title = "Enable category artwork", help = "You can separately enable/disable artwork for categories like console, computer, pinball etc." , options = ["Yes", "No"], values= [true,false],selection = 1},
{v = 7.3, varname = "dmpgrouped", glyph = 0xea78, initvar = function(val,prf){prf.DMPGROUPED <- val}, title = "Categorized Displays Menu", help = "Displays menu will be grouped by system categories: Arcades, Computer, Handhelds, Consoles, Pinballs and Others for collections" , options = ["Yes", "No"], values= [true,false],selection = 0, picsel = ["dmpgroupedyes"+AF.prefs.imgext,"dmpgroupedno"+AF.prefs.imgext],pic = "dmpgroupedyes"+AF.prefs.imgext},
{v = 7.4, varname = "dmpexitaf", glyph = 0xea7c, initvar = function(val,prf){prf.DMPEXITAF <- val}, title = "Add Exit Arcadeflow to menu", help = "Add an entry to exit Arcadeflow from the displays menu page" , options = ["Yes", "No"], values= [true,false],selection = 1},
{v = 0.0, varname = "", glyph = -1, title = "Behavior", selection = -10},
{v = 7.4, varname = "dmpatstart", glyph = 0xea7a, initvar = function(val,prf){prf.DMPATSTART <- val}, title = "Open the Displays Menu at startup", help = "Show Displays Menu immediately after launching Arcadeflow, this works better than setting it in the general options of Attract Mode" , options = ["Yes", "No"], values= [true,false],selection = 1},
{v = 7.4, varname = "dmpoutexitaf", glyph = 0xea7c, initvar = function(val,prf){prf.DMPOUTEXITAF <- val}, title = "Exit AF when leaving Menu", help = "The esc button from Displays Menu triggers the exit from Arcadeflow" , options = ["Yes", "No"], values= [true,false],selection = 1},
{v = 7.4, varname = "dmpifexitaf", glyph = 0xea7a, initvar = function(val,prf){prf.DMPIFEXITAF <- val}, title = "Enter Menu when leaving display", help = "The esc button from Arcadeflow brings the displays menu instead of exiting Arcadeflow" , options = ["Yes", "No"], values= [true,false],selection = 1},
])

menucounter ++
AF.prefs.l0.push({ label = "PERFORMANCE & FX", glyph = 0xe9a6, description = "Turn on or off special effects that might impact on Arcadeflow performance"})
AF.prefs.l1.push([
{v = 8.2, varname = "adaptspeed", glyph = 0xe994, initvar = function(val,prf){prf.ADAPTSPEED <- val}, title = "Adjust performance", help = "Tries to adapt speed to system performance. Enable for faster scroll, disable for smoother but slower scroll" , options = ["Yes","No"], values = [true,false], selection = 0},
{v = 7.2, varname = "customsize", glyph = 0xe994, initvar = function(val,prf){prf.CUSTOMSIZE <- val}, title = "Resolution W x H", help = "Define a custom resolution for your layout independent of screen resolution. Format is WIDTHxHEIGHT, leave blank for default resolution", options = "", values = "", selection = -1, pic = "customresyes"+AF.prefs.imgext},
{v = 9.8, varname = "rpi", glyph = 0xe994, initvar = function(val,prf){prf.RPI <- val}, title = "Raspberry Pi fix", help = "This applies to systems that gives weird results when getting back from a game, reloading the layout as needed" , options = ["Yes","No"], values = [true,false], selection = 1},
{v = 0.0, varname = "", glyph = -1, title = "Overscan", selection = -10},
{v = 10.6, varname = "overscanw", glyph = 0xe994, initvar = function(val,prf){prf.OVERSCANW <- val}, title = "Width %", help = "For screens with overscan, define which percentage of the screen will be filled with actual content", options = "", values = "", selection = -1, pic = "customresyes"+AF.prefs.imgext},
{v = 10.6, varname = "overscanh", glyph = 0xe994, initvar = function(val,prf){prf.OVERSCANH <- val}, title = "Height %", help = "For screens with overscan, define which percentage of the screen will be filled with actual content", options = "", values = "", selection = -1, pic = "customresyes"+AF.prefs.imgext},
{v = 0.0, varname = "", glyph = -1, title = "Effects", selection = -10},
{v = 7.2, varname = "lowspecmode", glyph = 0xe994, initvar = function(val,prf){prf.LOWSPECMODE <- val}, title = "Low Spec mode", help = "Reduce most visual effects to boost speed on lower spec systems" , options = ["Yes","No"], values = [true,false], selection = 1, picsel=["lslowspec"+AF.prefs.imgext,"lsdefault"+AF.prefs.imgext], pic = "lslowspec1"+AF.prefs.imgext},
{v = 7.2, varname = "datashadowsmooth", glyph = 0xe994, initvar = function(val,prf){prf.DATASHADOWSMOOTH <- val}, title = "Smooth shadow", help = "Enable smooth shadow under game title and data in the GUI" , options = ["Yes","No"], values = [true,false], selection = 0, picsel=["lsdefault"+AF.prefs.imgext,"lsnodrop"+AF.prefs.imgext], pic = "lsdrop"+AF.prefs.imgext},
{v = 7.2, varname = "snapglow", glyph = 0xe994, initvar = function(val,prf){prf.SNAPGLOW <- val}, title = "Glow effect", help = "Add a glowing halo around the selected game thumbnail" , options = ["Yes","No"], values = [true,false], selection = 0, picsel=["lsdefault"+AF.prefs.imgext,"lsnoglow"+AF.prefs.imgext],pic = "lsglow"+AF.prefs.imgext},
{v = 7.2, varname = "snapgradient", glyph = 0xe994, initvar = function(val,prf){prf.SNAPGRADIENT <- val}, title = "Thumb gradient", help = "Blurs the artwork behind the game logo so it's more readable" , options = ["Yes","No"], values = [true,false], selection = 0, picsel=["lsdefault"+AF.prefs.imgext,"lsgradient"+AF.prefs.imgext],pic = "lsgradient1"+AF.prefs.imgext},
])

menucounter ++
AF.prefs.l0.push({ label = "THUMBNAILS", glyph = 0xe915, description = "Chose the aspect ratio of thumbnails, video thumbnails and decorations"})
AF.prefs.l1.push([
{v = 7.2, varname = "cropsnaps", glyph = 0xea57, initvar = function(val,prf){prf.CROPSNAPS <- val}, title = "Aspect ratio", help = "Chose wether you want cropped, square snaps or adaptive snaps depending on game orientation", options = ["Adaptive", "Square"], values = [false, true], selection = 0, picsel= ["aradaptive"+AF.prefs.imgext,"arsquare"+AF.prefs.imgext],pic = "arsquare"+AF.prefs.imgext},
{v = 8.7, varname = "morphaspect", glyph = 0xea57, initvar = function(val,prf){prf.MORPHASPECT <- val}, title = "Morph snap ratio", help = "Chose if you want the box to morph into the actual game video or if it must be cropped", options = ["Morph video", "Crop video"], values = [true, false], selection = 0},
{v = 10.9, varname = "fix169", glyph = 0xea57, initvar = function(val,prf){prf.FIX169 <- val}, title = "Optimize vertical arcade", help = "Enable this option if you have 9:16 vertical artwork from the Vertical Arcade project", options = ["Yes", "No"], values = [true, false], selection = 1},
{v = 10.4, varname = "tilezoom", glyph = 0xea57, initvar = function(val,prf){prf.TILEZOOM <- val}, title = "Zoom thumbnails", help = "Chose if you want the selected thumbnail to zoom to a larger size", options = ["Standard", "Reduced", "None"], values = [2, 1, 0], selection = 0},
{v = 10.7, varname = "logosonly", glyph = 0xea6d, initvar = function(val,prf){prf.LOGOSONLY <- val}, title = "Show only logos", help = "If enabled, only game tilte logos will be shown instead of the screenshot", options = ["Yes", "No"], values = [true, false], selection = 1},
{v = 0.0, varname = "", glyph = -1, title = "Snapshot Options", selection = -10},
{v = 8.8, varname = "titleart", glyph = 0xe915, initvar = function(val,prf){prf.TITLEART <- val}, title = "Snapshot artwork source", help = "Chose if you want the snapshot artwork from gameplay or title screen" options = ["Gameplay", "Title screen"], values = [false, true], selection = 0},
{v = 8.4, varname = "titleonsnap", glyph = 0xea6d, initvar = function(val,prf){prf.TITLEONSNAP <- val}, title = "Show game title", help = "Show the title of the game over the thumbnail" , options = ["Yes","No"], values = [true,false], selection = 0},
{v = 0.0, varname = "", glyph = -1, title = "Box Art Options", selection = -10},
{v = 7.2, varname = "boxartmode", glyph = 0xe918, initvar = function(val,prf){prf.BOXARTMODE <- val}, title = "Box Art mode", help = "Show box art or flyers instead of screen captures by default (can be configured with menu or hotkey)" , options = ["Yes","No"], values = [true,false], selection = 1, picsel = ["boxarton"+AF.prefs.imgext,"boxartoff"+AF.prefs.imgext], pic = "boxart"+AF.prefs.imgext},
{v = 7.2, varname = "titleonbox", glyph = 0xe918, initvar = function(val,prf){prf.TITLEONBOX <- val}, title = "Game title over box art", help = "Shows the game title artwork overlayed on the box art graphics" , options = ["Yes","No"], values = [true,false], selection = 1,picsel = ["boxarttitle"+AF.prefs.imgext,"boxarton"+AF.prefs.imgext],pic = "boxarttitle"+AF.prefs.imgext},
{v = 7.2, varname = "boxartsource", glyph = 0xe918, initvar = function(val,prf){prf.BOXARTSOURCE <- val}, title = "Box Art artwork source", help = "Chose the artwork source for box art graphics" , options = ["flyer", "fanart"], values = ["flyer", "fanart"], selection = 0 },
{v = 0.0, varname = "", glyph = -1, title = "Video Snaps", selection = -10},
{v = 7.2, varname = "thumbvideo", glyph = 0xe913, initvar = function(val,prf){prf.THUMBVIDEO <- val}, title = "Video thumbs", help = "Enable video overlay on snapshot thumbnails" , options = ["Yes","No"], values = [true,false], selection = 0},
{v = 8.5, varname = "fadevideotitle", glyph = 0xe913, initvar = function(val,prf){prf.FADEVIDEOTITLE <- val}, title = "Fade title on video", help = "Fades game title and decoration when the video is playing" , options = ["Yes","No"], values = [true,false], selection = 1},
{v = 8.4, varname = "thumbvidelay", glyph = 0xe913, initvar = function(val,prf){prf.THUMBVIDELAY <- val}, title = "Video delay multiplier", help = "Increase video load delay" , options = ["0.25x","0.5x","1x", "2x","3x","4x","5x"], values = [0.25,0.5,1,2,3,4,5], selection = 2},
{v = 7.2, varname = "missingwheel", glyph = 0xea6d, initvar = function(val,prf){prf.MISSINGWHEEL <- val}, title = "Generate missing title art", help = "If no game title is present, the layout can generate it" , options = ["Yes","No"], values = [true,false], selection = 0,picsel = ["missingwheelyes"+AF.prefs.imgext,"missingwheelno"+AF.prefs.imgext],pic = "missingwheel"+AF.prefs.imgext},
{v = 0.0, varname = "", glyph = -1, title = "Decorations", selection = -10},
{v = 9.6, varname = "redcross", glyph = 0xe936, initvar = function(val,prf){prf.REDCROSS <- val}, title = "Game not available indicator", help = "Games that are not available will be marked with a red cross overlay" , options = ["Yes","No"], values = [true,false], selection = 0},
{v = 7.2, varname = "newgame", glyph = 0xe936, initvar = function(val,prf){prf.NEWGAME <- val}, title = "New game indicator", help = "Games not played are marked with a glyph" , options = ["Yes","No"], values = [true,false], selection = 0, picsel=["decornewgame"+AF.prefs.imgext,"decornone"+AF.prefs.imgext],pic = "decornewgame"+AF.prefs.imgext},
{v = 7.2, varname = "tagshow", glyph = 0xe936, initvar = function(val,prf){prf.TAGSHOW <- val}, title = "Show tag indicator", help = "Shows a tag attached to thumbnails that contains any tag" , options = ["Yes","No"], values = [true,false], selection = 0, picsel=["decortag"+AF.prefs.imgext,"decornone"+AF.prefs.imgext],pic = "decortag"+AF.prefs.imgext},
{v = 7.2, varname = "tagname", glyph = 0xe936, initvar = function(val,prf){prf.TAGNAME <- val}, title = "Custom tag name", help = "You can see a tag glyph overlayed to the thumbs, chose the tag name to use", options = "", values = "", selection = -1},
{v = 7.2, varname = "gbrecolor", glyph = 0xe90c, initvar = function(val,prf){prf.GBRECOLOR <- val}, title = "Game Boy color correction", help = "Apply a colorized palette to Game Boy games based on the system name or forced to your preference" , options = ["Automatic", "Classic", "Pocket", "Light", "None"], values = ["AUTO", "LCDGBC", "LCDGBP", "LCDGBL" ,"NONE"], selection = 0, picsel = ["gb"+AF.prefs.imgext,"gbclassic"+AF.prefs.imgext,"gbpocket"+AF.prefs.imgext,"gblight"+AF.prefs.imgext,"gbnone"+AF.prefs.imgext],pic = "gb"+AF.prefs.imgext},
{v = 10.3, varname = "crtrecolor", glyph = 0xe90c, initvar = function(val,prf){prf.CRTRECOLOR <- val}, title = "MSX crt color correction", help = "Apply a palette correction to MSX media that was captured with MSX2 palette" , options = ["Yes", "No"], values = [true,false], selection = 1},
])

menucounter ++
AF.prefs.l0.push({ label = "COLOR CYCLE", glyph = 0xe982, description = "Enable and edit color cycling animation of tile highlight border"})
AF.prefs.l1.push([
{v = 10.7, varname = "huecycle", glyph = 0xe982, initvar = function(val,prf){prf.HUECYCLE <- val}, title = "Enable color cycle", help = "Enable/disable color cycling of the tile higlight border", options = ["Yes", "No"], values = [true, false], selection = 1},
{v = 0.0, varname = "", glyph = -1, title = "Cycle Options", selection = -10},
{v = 10.7, varname = "hcspeed", glyph = 0xe9a6, initvar = function(val,prf){prf.HCSPEED <- val}, title = "Cycle speed", help = "Select the speed of color cycle" options = ["Slow", "Medium", "Fast"], values = [2, 5, 8], selection = 1},
{v = 10.7, varname = "hccolor", glyph = 0xe90c, initvar = function(val,prf){prf.HCCOLOR <- val}, title = "Cycle color", help = "Select a color intensity preset for the cycle" , options = ["Standard","Popping", "Light"], values = ["0.7_0.7","1.0_0.5","1.0_0.9"], selection = 0},
{v = 10.7, varname = "hcpingpong", glyph = 0xea2d, initvar = function(val,prf){prf.HCPINGPONG <- val}, title = "Ping Pong effect", help = "Enable this if you want the cycle to revert once finished instead of restarting" , options = ["Yes","No"], values = [true,false], selection = 1},
{v = 10.7, varname = "hchuestart", glyph = 0xe994, initvar = function(val,prf){prf.HCHUESTART <- val}, title = "Start hue", help = "Define the start value of the hue cycle (0 - 359)", options = "", values = "", selection = -1},
{v = 10.7, varname = "hchuestop", glyph = 0xe994, initvar = function(val,prf){prf.HCHUESTOP <- val}, title = "Stop hue", help = "Define the stop value of the hue cycle (0 - 359)", options = "", values = "", selection = -1},
])

menucounter ++
AF.prefs.l0.push({ label = "BACKGROUND", glyph = 0xe90c, description = "Chose the layout background theme in main page and in History page, or select custom backgrounds"})
AF.prefs.l1.push([
{v = 7.2, varname = "colortheme", glyph = 0xe90c, initvar = function(val,prf){prf.COLORTHEME <- val}, title = "Overlay color", help = "Setup theme luminosity overlay, Basic is slightly muted, Dark is darker, Light has a white overlay and dark text, Pop keeps the colors unaltered" , options = ["Basic", "Dark", "Light", "Pop"], values =["basic", "dark", "light", "pop"], selection = 3, picsel = ["overlaybasic"+AF.prefs.imgext,"overlaydark"+AF.prefs.imgext,"overlaylight"+AF.prefs.imgext,"overlaypop"+AF.prefs.imgext], pic = "overlay"+AF.prefs.imgext},
{v = 8.9, varname = "overcustom", glyph = 0xe930, initvar = function(val,prf){prf.OVERCUSTOM <- val}, title = "Custom overlay", help = "Insert custom PNG to be overlayed over everything", options = "", values = "pics/", selection = -3},
{v = 8.4, varname = "bgcustom", glyph = 0xe930, initvar = function(val,prf){prf.BGCUSTOM <- val}, title = "Custom main BG image", help = "Insert custom background art path (use grey.png for blank background, vignette.png for vignette overlay)", options = "", values = "pics/", selection = -3,pic="bgcustom"+AF.prefs.imgext},
{v = 8.4, varname = "bgcustomstretch", glyph = 0xea57, initvar = function(val,prf){prf.BGCUSTOMSTRETCH <- val}, title = "Format of main BG image", help = "Select if the custom background must be cropped to fill the screen or stretched", options = ["Crop","Stretch"], values = [false,true], selection = 1,pic="bgcustom"+AF.prefs.imgext},
{v = 0.0, varname = "", glyph = -1, title = "History BG", selection = -10},
{v = 8.4, varname = "bgcustomhistory", glyph = 0xe930, initvar = function(val,prf){prf.BGCUSTOMHISTORY <- val}, title = "Custom history BG image", help = "Insert custom background art path for history page (leave blank if the same as main background)", options = "", values ="pics/", selection = -3,pic="bgcustomhistory"+AF.prefs.imgext},
{v = 8.4, varname = "bgcustomhistorystretch", glyph = 0xea57, initvar = function(val,prf){prf.BGCUSTOMHISTORYSTRETCH <- val}, title = "Format of history BG image", help = "Select if the custom background must be cropped to fill the screen or stretched", options = ["Crop","Stretch"], values = [false,true], selection = 1,pic="bgcustomhistory"+AF.prefs.imgext},
{v = 0.0, varname = "", glyph = -1, title = "BG Snaps", selection = -10},
{v = 7.2, varname = "layersnap", glyph = 0xe90d, initvar = function(val,prf){prf.LAYERSNAP <- val}, title = "Background snap", help = "Add a faded game snapshot to the background" , options = ["Yes","No"], values = [true,false], selection = 1, picsel = ["bgsnapyes"+AF.prefs.imgext,"bgsnapno"+AF.prefs.imgext],pic="bgsnap"+AF.prefs.imgext},
{v = 7.2, varname = "layervideo", glyph = 0xe913, initvar = function(val,prf){prf.LAYERVIDEO <- val}, title = "Animate BG snap", help = "Animate video on background" , options = ["Yes","No"], values = [true,false], selection = 1},
{v = 7.2, varname = "layervidelay", glyph = 0xe913, initvar = function(val,prf){prf.LAYERVIDELAY <- val}, title = "Delay BG animation", help = "Don't load immediately the background video animation" , options = ["Yes","No"], values = [true,false], selection = 1},
{v = 0.0, varname = "", glyph = -1, title = "Per Display", selection = -10},
{v = 7.5, varname = "bgperdisplay", glyph = 0xe912, initvar = function(val,prf){prf.BGPERDISPLAY <- val}, title = "Per Display background", help = "You can have a different background for each display, just put your pictures in menu-art/bgmain and menu-art/bghistory folders named as the display" , options = ["Yes","No"], values = [true,false], selection = 1},
])

menucounter ++
AF.prefs.l0.push({ label = "LOGO", glyph = 0xe916, description = "Customize the splash logo at the start of Arcadeflow"})
AF.prefs.l1.push([
{v = 7.2, varname = "splashon", glyph = 0xe916, initvar = function(val,prf){prf.SPLASHON <- val}, title = "Enable splash logo", help = "Enable or disable the AF start logo" , options = ["Yes","No"], values = [true,false], selection = 0,picsel = ["logoyes"+AF.prefs.imgext,"logono"+AF.prefs.imgext], pic = "logoyes"+AF.prefs.imgext},
{v = 7.2, varname = "splashlogofile", glyph = 0xe930, initvar = function(val,prf){prf.SPLASHLOGOFILE <- val}, title = "Custom splash logo", help = "Insert the path to a custom AF splash logo (or keep blank for default logo)", options = "", values ="", selection =-3,pic = "logocustom"+AF.prefs.imgext},
])

menucounter ++
AF.prefs.l0.push({ label = "ATTRACT MODE", glyph = 0xe9a5, description = "Arcadeflow has its own attract mode screensaver that kicks in after some inactivity. Configure all the options here"})
AF.prefs.l1.push([
{v = 7.2, varname = "amenable", glyph = 0xe9a5, initvar = function(val,prf){prf.AMENABLE <- val}, title = "Enable attract mode", help = "Enable or disable attract mode at layout startup" , options = ["From start", "Inactivity only", "Disabled"], values =["From start", "Inactivity only", "Disabled"], selection = 1,pic = "attractmode"+AF.prefs.imgext},
{v = 0.0, varname = "", glyph = -1, title = "Look & Feel", selection = -10},
{v = 7.2, varname = "amtimer", glyph = 0xe94e, initvar = function(val,prf){prf.AMTIMER <- val}, title = "Attract mode timer (s)", help = "Inactivity timer before attract mode is enabled", options = "", values ="120", selection =-1},
{v = 7.2, varname = "amchangetimer", glyph = 0xe94e, initvar = function(val,prf){prf.AMCHANGETIMER <- val}, title = "Game change time (s)", help = "Time interval between each game change", options = "", values = "10", selection =-1},
{v = 9.1, varname = "amshowlogo", glyph = 0xea6d, initvar = function(val,prf){prf.AMSHOWLOGO <- val}, title = "Attract logo", help = "Show Arcadeflow logo during attract mode", options = ["Yes","No"], values = [true,false], selection = 0},
{v = 7.2, varname = "ammessage", glyph = 0xea6d, initvar = function(val,prf){prf.AMMESSAGE <- val}, title = "Attract message", help = "Text to show during attract mode", options = "", values = " - PRESS ANY KEY - ", selection = -1,pic = "attractmode"+AF.prefs.imgext},
{v = 0.0, varname = "", glyph = -1, title = "Sound", selection = -10},
{v = 7.2, varname = "amtune", glyph = 0xe911, initvar = function(val,prf){prf.AMTUNE <- val}, title = "Background music", help = "Path to a music file to play in background", options = "", values ="", selection = -3},
{v = 7.2, varname = "amsound", glyph = 0xea27, initvar = function(val,prf){prf.AMSOUND <- val}, title = "Enable game sound", help = "Enable game sounds during attract mode" , options = ["Yes","No"], values = [true,false], selection = 0},
])

menucounter ++
AF.prefs.l0.push({ label = "SEARCH & FILTERS", glyph = 0xe986, description = "Configure the search page and multifilter options"})
AF.prefs.l1.push([
{v = 0.0, varname = "", glyph = -1, title = "Search", selection = -10},
{v = 7.9, varname = "livesearch", glyph = 0xe985, initvar = function(val,prf){prf.LIVESEARCH <- val}, title = "Immediate search", help = "Live update results while searching" , options = ["Yes","No"], values = [true,false], selection = 0},
{v = 8.0, varname = "keylayout", glyph = 0xe955, initvar = function(val,prf){prf.KEYLAYOUT <- val}, title = "Keyboard layout", help = "Select the keyboard layout for on-screen keyboard" , options = ["ABCDEF","QWERTY","AZERTY"], values = ["ABCDEF","QWERTY","AZERTY"], selection = 0},
{v = 0.0, varname = "", glyph = -1, title = "Multifilter", selection = -10},
{v = 7.9, varname = "savemfz", glyph = 0xeaed, initvar = function(val,prf){prf.SAVEMFZ <- val}, title = "Save Multifilter sessions", help = "Save the Multifilter of each display when exiting Arcadeflow or changing list" , options = ["Yes","No"], values = [true,false], selection = 0},
{v = 10.1, varname = "mfzvector", glyph = 0xeaed, initvar = function(val,prf){prf.MFZVECTOR <- val}, title = "Customize Multifilter Menu", help = "Sort and select Multifilter Menu entries: Left/Right to move items up and down, Select to enable/disable item" , options = function(){return(mfztablenames(multifilterz.l0))}, values = sortstring(14), selection = -4},
{v = 10.1, varname = "mfzvectorreset", glyph = 0xe965, initvar = function(val,prf){prf.MFZVECTORRESET <- val}, title = "Reset Multifilter Menu", help = "Reset sorting and selection of Multifilter Menu entries" , options = "", values = function(){AF.prefs.l1[10][5].values = sortstring(14)}, selection = -2},
])

menucounter ++
AF.prefs.l0.push({ label = "HISTORY PAGE", glyph = 0xe923, description = "Configure the History page where larger thumbnail and game history data are shown"})
AF.prefs.l1.push([
{v = 0.0, varname = "", glyph = -1, title = "Video Effects", selection = -10},
{v = 8.8, varname = "crtgeometry", glyph = 0xe95b, initvar = function(val,prf){prf.CRTGEOMETRY <- val}, title = "CRT deformation", help = "Enable CRT deformation for CRT snaps" options = ["Yes", "No"], values =[true,false], selection = 0},
{v = 7.2, varname = "scanlinemode", glyph = 0xe95b, initvar = function(val,prf){prf.SCANLINEMODE <- val}, title = "Scanline effect", help = "Select scanline effect: Scanlines = default scanlines, Aperture = aperture mask, Half Resolution = reduced scanline resolution to avoid moiree, None = no scanline" options = ["Scanlines", "Half Resolution", "Aperture", "None"], values =["scanlines", "halfres", "aperture", "none"], selection = 2, picsel = ["slscanline"+AF.prefs.imgext,"slhalfres"+AF.prefs.imgext,"slaperture"+AF.prefs.imgext,"slnone"+AF.prefs.imgext],pic = "sl"+AF.prefs.imgext},
{v = 7.2, varname = "lcdmode", glyph = 0xe959, initvar = function(val,prf){prf.LCDMODE <- val}, title = "LCD effect", help = "Select LCD effect for handheld games: Matrix = see dot matrix, Half Resolution = see matrix at half resolution, None = no effect", options = ["Matrix", "Half Resolution", "None"], values = ["matrix", "halfres", "none"], selection = 1, picsel = ["lcdmatrix"+AF.prefs.imgext, "lcdhalfres"+AF.prefs.imgext, "lcdnone"+AF.prefs.imgext],pic = "lcd"+AF.prefs.imgext},
{v = 0.0, varname = "", glyph = -1, title = "Layout", selection = -10},
{v = 8.3, varname = "historysize", glyph = 0xe923, initvar = function(val,prf){prf.HISTORYSIZE <- val}, title = "Text panel size", help = "Select the size of the history panel at the expense of snapshot area", options = ["Small", "Default", "Large", "Max snap"], values = [0.45,0.65,0.75,-1.0], selection = 1},
{v = 7.2, varname = "historypanel", glyph = 0xe923, initvar = function(val,prf){prf.HISTORYPANEL <- val}, title = "Text panel style", help = "Select the look of the history text panel", options = ["White panel", "Background"], values = [true,false], selection = 0, picsel = ["histpanelyes"+AF.prefs.imgext,"histpanelno"+AF.prefs.imgext],pic="histpanelyes"+AF.prefs.imgext},
{v = 7.2, varname = "darkpanel", glyph = 0xe923, initvar = function(val,prf){prf.DARKPANEL <- val}, title = "Game panel style", help = "Select the look of the history game panel", options = ["Dark", "Standard", "None"], values = [true,false,null], selection = 1,picsel=["histpaneldark"+AF.prefs.imgext,"histpaneldefault"+AF.prefs.imgext,"histpanelnone"+AF.prefs.imgext],pic = "histpaneldefault"+AF.prefs.imgext},
{v = 8.2, varname = "histmininame", glyph = 0xe923, initvar = function(val,prf){prf.HISTMININAME <- val}, title = "Detailed game data", help = "Show extra data after the game name before the history text", options = ["Yes", "No"], values = [false,true], selection = 0},
{v = 8.3, varname = "controloverlay", glyph = 0xe923, initvar = function(val,prf){prf.CONTROLOVERLAY <- val}, title = "Control panel overlay", help = "Show controller and buttons overlay on history page", options = ["Yes", "No"], values = [true,false], selection = 0},
{v = 0.0, varname = "", glyph = -1, title = "Import MAME Files", selection = -10},
{v = 7.2, varname = "dat_path", glyph = 0xe930, initvar = function(val,prf){prf.DAT_PATH <- val}, title = "History.dat", help = "History.dat location.", options = "", values = "", selection = -3},
{v = 7.2, varname = "index_clones", glyph = 0xe922, initvar = function(val,prf){prf.INDEX_CLONES <- val}, title = "Index clones", help = "Set whether entries for clones should be included in the index. Enabling this will make the index significantly larger" , options = ["Yes","No"], values = [true,false], selection = 0},
{v = 7.2, varname = "generate1", glyph = 0xea1c, initvar = function(val,prf){prf.GENERATE1 <- val}, title = "Generate History index", help = "Generate the history.dat index now (this can take some time)", options = "" , values = function(){local tempprf = generateprefstable(); af_generate_index(tempprf);fe.signal("back");fe.signal("back")}, selection = -2},
{v = 8.3, varname = "dat_command_path", glyph = 0xe930, initvar = function(val,prf){prf.DAT_COMMAND_PATH <- val}, title = "Command.dat", help = "Command.dat location.", options = "", values = "", selection = -3},
{v = 7.2, varname = "generate2", glyph = 0xea1c, initvar = function(val,prf){prf.GENERATE2 <- val}, title = "Generate Command index", help = "Generate the command.dat index now (this can take some time)", options = "" , values = function(){local tempprf = generateprefstable(); af_generate_command_index(tempprf);fe.signal("back");fe.signal("back")}, selection = -2},
{v = 9.2, varname = "ini_bestgames_path", glyph = 0xe930, initvar = function(val,prf){prf.INI_BESTGAMES_PATH <- val}, title = "Bestgames.ini", help = "Bestgames.ini location for MAME.", options = "", values = "", selection = -3},
])

menucounter ++
AF.prefs.l0.push({ label = "AUDIO", glyph = 0xea27, description = "Configure layout sounds and audio options for videos"})
AF.prefs.l1.push([
{v = 7.2, varname = "themeaudio", glyph = 0xea27, initvar = function(val,prf){prf.THEMEAUDIO <- val}, title = "Enable theme sounds", help = "Enable audio sounds when browsing and moving around the theme" options = ["Yes","No"], values = [true,false], selection = 0},
{v = 7.2, varname = "audiovidsnaps", glyph = 0xea27, initvar = function(val,prf){prf.AUDIOVIDSNAPS <- val}, title = "Audio in videos (thumbs)", help = "Select wether you want to play audio in videos on thumbs" , options = ["Yes","No"], values = [true,false], selection = 1},
{v = 7.2, varname = "audiovidhistory", glyph = 0xea27, initvar = function(val,prf){prf.AUDIOVIDHISTORY <- val}, title = "Audio in videos (history)", help = "Select wether you want to play audio in videos on history detail page" , options = ["Yes","No"], values = [true,false], selection = 1},
{v = 7.2, varname = "backgroundtune", glyph = 0xe911, initvar = function(val,prf){prf.BACKGROUNDTUNE <- val}, title = "Layout background music", help = "Chose a background music file to play while using Arcadeflow" ,  options = "", values ="", selection = -3},
{v = 10.2, varname = "randomtune", glyph = 0xe911, initvar = function(val,prf){prf.RANDOMTUNE <- val}, title = "Randomize background music", help = "If this is enabled, Arcadeflow will play a random mp3 from the folder of the selected background music" ,  options = ["Yes","No"], values = [true,false], selection = 1},
{v = 7.2, varname = "nobgonattract", glyph = 0xe911, initvar = function(val,prf){prf.NOBGONATTRACT <- val}, title = "Stop bg music in attract mode", help = "Stops playing the layout background music during attract mode" ,  options = ["Yes","No"], values =[true,false] selection = 0},
])

menucounter ++
AF.prefs.l0.push({ label = "UPDATES", glyph = 0xe91c, description = "Configure update notifications"})
AF.prefs.l1.push([
{v = 8.0, varname = "updatecheck", glyph = 0xe91c, initvar = function(val,prf){prf.UPDATECHECK <- val}, title = "Automatically check for updates", help = "Will check for updates at each AF launch, if you dismiss one update you won't be notified until the next one" options = ["Yes","No"], values = [true,false], selection = 0},
{v = 8.0, varname = "autoinstall", glyph = 0xe91c, initvar = function(val,prf){prf.AUTOINSTALL <- val}, title = "Install update after download", help = "Arcadeflow allows you to chose if you just want to download updates, or if you want to install them directly" options = ["Install after download","Download only"], values = [true,false], selection = 1},
])

menucounter ++
AF.prefs.l0.push({ label = "SAVE & LOAD", glyph = 0xe962, description = "Save or reload options configurations"})
AF.prefs.l1.push([
{v = 9.9, varname = "saveprefs", glyph = 0xe9c5, initvar = function(val,prf){prf.SAVEPREFS <- val}, title = "Save current options", help = "Save the current options configuration in a custom named file", options = "" , values = function(){savecurrentoptions()}, selection = -5},
{v = 9.9, varname = "loadprefs", glyph = 0xe9c6, initvar = function(val,prf){prf.LOADPREFS <- val}, title = "Load options from external file", help = "Restore AF options from a previously saved file", options = "" , values = function(){ restoreoptions()}, selection = -5},
])

menucounter ++
AF.prefs.l0.push({ label = "DEBUG", glyph = 0xe998, description = "This section is for debug purposes only"})
AF.prefs.l1.push([
{v = 7.2, varname = "fpson", glyph = 0xe998, initvar = function(val,prf){prf.FPSON <- val}, title = "FPS counter", help = "DBGON FPS COUNTER" options = ["Yes","No"], values = [true,false], selection = 1},
{v = 7.2, varname = "debugmode", glyph = 0xe998, initvar = function(val,prf){prf.DEBUGMODE <- val}, title = "DEBUG mode", help = "Enter DBGON mode, increased output logging" options = ["Yes","No"], values = [true,false], selection = 1},
{v = 7.2, varname = "oldoptions", glyph = 0xe998, initvar = function(val,prf){prf.OLDOPTIONS <- val}, title = "AM options page", help = "Shows the default Attract-Mode options page" options = "", values = function(){prf.OLDOPTIONSPAGE = true; AF.prefs.getout = true; fe.signal("layout_options");fe.signal("reload")}, selection = -2},
{v = 9.5, varname = "generatereadme", glyph = 0xe998, initvar = function(val,prf){prf.GENERATEREADME <- val}, title = "Generate readme file", help = "For developer use only..." options = "", values = function(){ AF.prefs.getout = true;savereadme()}, selection = -2},
{v = 7.2, varname = "resetlayout", glyph = 0xe998, initvar = function(val,prf){prf.RESETLAYOUT <- val}, title = "Reset all options", help = "Restore default settings for all layout options, erase sorting options, language options and thumbnail options" options = "", values = function(){ AF.prefs.getout = true;reset_layout()}, selection = -2},
])

function reset_layout() {

	try { remove (AF.folder + "pref_savedlanguage.txt") } catch (err) {}
	try { remove (AF.folder + "pref_sortorder.txt") } catch (err) {}
	try { remove (AF.folder + "pref_thumbtype.txt") } catch (err) {}
	try { remove (AF.folder + "pref_layoutoptions.txt") } catch (err) {}
	try { remove (AF.folder + "pref_update.txt") } catch (err) {}
	try { remove (AF.folder + "pref_checkdate.txt") } catch (err) {}

	try { remove (AF.folder + "latest_version.txt") } catch (err) {}

	local dir = DirectoryListing( AF.folder )
	foreach (item in dir.results){
		if (item.find("_mf_")) try { remove(item) } catch (err) {}
	}

	fe.signal("exit_to_desktop")
}

// Translate preference data structure

for (local i = 0 ; i < AF.prefs.l1.len() ; i ++) {
	local isnewparent = false
	for (local j = 0 ; j < AF.prefs.l1[i].len() ; j ++) {
		local isnew =  (AF.prefs.l1[i][j].v.tofloat() == AF.version.tofloat())
		AF.prefs.l1[i][j].title = (isnew ? "❗ " : "") + ltxt(AF.prefs.l1[i][j].title,TLNG) + (isnew ? " ❗" : "")
		if ((AF.prefs.l1[i][j].selection != -10)) AF.prefs.l1[i][j].help = ltxt(AF.prefs.l1[i][j].help,TLNG)
		if ((AF.prefs.l1[i][j].selection != -4) && (AF.prefs.l1[i][j].selection != -10)) AF.prefs.l1[i][j].options = ltxtarray(AF.prefs.l1[i][j].options,TLNG)
		if (isnew) isnewparent = true
	}
	AF.prefs.l0[i].label = (isnewparent ? "❗ " : "") + ltxt(AF.prefs.l0[i].label,TLNG) + (isnewparent ? " ❗" : "")
	AF.prefs.l0[i].description = ltxt(AF.prefs.l0[i].description,TLNG)
	AF.prefs.a0.push (AF.prefs.l0[i].label)
	AF.prefs.gl0.push (AF.prefs.l0[i].glyph)
}

// GENERATE ABOUT FILE

function abouttext(){
	local about = []

	for (local i = 0 ; i < AF.prefs.l0.len() ; i++){
		about.push (AF.prefs.l0[i].label+"\n")
		about.push (AF.prefs.l0[i].description+"\n")
		about.push("\n")
		for (local j = 0 ; j < AF.prefs.l1[i].len() ; j++) {
			try{about.push ("- '" + AF.prefs.l1[i][j].title + "'" + " : " + AF.prefs.l1[i][j].help +"\n")} catch (err){}
		}
		about.push ("\n")
	}
	return (about)
}

function historytext(){
	local scanver = AF.vernum - 1
	local verfile = null
	local history = []
	while (scanver > 10) {
		if (file_exist(AF.folder+scanver+".txt")) {
			verfile = ReadTextFile (AF.folder+scanver+".txt")
			history.push ("*v"+verfile.read_line()+"*"+"\n\n")
			while (!verfile.eos()){
				history.push ("- "+verfile.read_line()+"\n")
			}
			history.push ("\n")
		}
		scanver --
	}
	verfile = ReadTextFile (AF.folder+"10.txt")
	while (!verfile.eos()){
		history.push (verfile.read_line()+"\n")
	}
	return history
}

function buildreadme(){
	local infile = null
	local readme = []

	readme.push ("# Arcadeflow - Attract Mode theme by zpaolo11x - v "+AF.version+" #\n")
	readme.push ("\n")

	infile = ReadTextFile (AF.folder+"00_intro.txt")
	while (!infile.eos()) readme.push (infile.read_line()+"\n")
	readme.push ("\n")
	readme.push ("## What's new in v "+AF.version+" #"+"\n")
	readme.push ("\n")

	infile = ReadTextFile (AF.folder+AF.vernum+".txt")
	infile.read_line()
	while (!infile.eos()) readme.push ("- "+infile.read_line()+"\n")
	readme.push ("\n")

	infile = ReadTextFile (AF.folder+"00_presentation.txt")
	while (!infile.eos()) readme.push (infile.read_line()+"\n")
	readme.push ("\n")

	readme.extend(abouttext())

	readme.push("## Previous versions history #\n\n")

	readme.extend(historytext())

	return readme

	foreach (i,item in readme){
		print (item)
	}

}

function savereadme(){
   local aboutpath = fe.path_expand( AF.folder + "README.md")
   local aboutfile = WriteTextFile (aboutpath)
   local about = buildreadme()
	for (local i = 0 ; i < about.len() ; i++){
		aboutfile.write_line(about[i])
	}
}


/*
function whatsnewtext(){
	local scanver = AF.vernum - 1
	local verfile = null
	while (scanver > 10) {
		if (file_exist(AF.folder+scanver+".txt")) {
			verfile = ReadTextFile (AF.folder+scanver+".txt")
			print ("*v"+verfile.read_line()+"*"+"\n")
			while (!verfile.eos()){
				print ("- "+verfile.read_line()+"\n")
			}
			print ("\n")
		}
		scanver --
	}
}

function historytext(){
	local scanver = AF.vernum - 1
	local verfile = null
	while (scanver > 10) {
		if (file_exist(AF.folder+scanver+".txt")) {
			verfile = ReadTextFile (AF.folder+scanver+".txt")
			print ("*v"+verfile.read_line()+"*"+"\n")
			while (!verfile.eos()){
				print ("- "+verfile.read_line()+"\n")
			}
			print ("\n")
		}
		scanver --
	}
	verfile = ReadTextFile (AF.folder+"10.txt")
	while (!verfile.eos()){
		print (verfile.read_line()+"\n")
	}

}
*/
function saveabout(){
   local aboutpath = fe.path_expand( AF.folder + "about.txt")
   local aboutfile = WriteTextFile (aboutpath)
   local about = abouttext()
	for (local i = 0 ; i < about.len() ; i++){
		aboutfile.write_line(about[i]+"\n")
	}
}

function printabout(){
	   local about = abouttext()
	for (local i = 0 ; i < about.len() ; i++){
		print(about[i]+"\n")
	}
}
//saveabout()
//historytext()

// Reads data from the preferences structures and builds the preferences variable table
// This is the table with the values used in the layout like prf.BOXARTMODE = true etc
function generateprefstable(){
   local prf = {}
   for (local i = 0 ; i < AF.prefs.l0.len() ; i++){
      for (local j = 0 ; j < AF.prefs.l1[i].len() ; j++){
         local tempdat = AF.prefs.l1[i][j]
         if (tempdat.selection != -10){
				if (tempdat.selection >=0) tempdat.initvar(((tempdat.values != "") ? tempdat.values[tempdat.selection] : tempdat.options[tempdat.selection]),prf)
   	      else if ((tempdat.selection != -2) && (tempdat.selection != -5))tempdat.initvar(tempdat.values,prf) //-2 is the function execution
			}
		}
   }
   return prf
}

// Reads data from the preferences structures and builds the selections variable table
// These values are the selections on the prefs and are used for save/load
// This table contains the NAME of the variable (like "BOXARTMODE" and the current selection like 0, 1, 2 etc )
function generateselectiontable(){
   local prf = {}
   for (local i = 0 ; i < AF.prefs.l0.len() ; i++){
      for (local j = 0 ; j < AF.prefs.l1[i].len() ; j++){
         local tempdat = AF.prefs.l1[i][j]
         if (tempdat.selection != -10){
	         if (tempdat.selection >=0) tempdat.initvar(tempdat.selection,prf)
   	      else if ((tempdat.selection != -2) && (tempdat.selection != -5)) tempdat.initvar(tempdat.values,prf)
			}
		}
   }
   return prf
}

// Input output functions should save and load the SELECTION value, not the actual value.
// Therefore saveprefdata must be called on a table generated with generateselectiontable()
function saveprefdata(prf,target){
   local prfpath = fe.path_expand( AF.folder+"pref_layoutoptions.txt")
   if (target != null) prfpath = target
	local prffile = WriteTextFile (prfpath)
	prffile.write_line (AF.version+"\n")
   foreach (label, val in prf){
      prffile.write_line ("|" + label + "|" + val+"|\n")
   }
}

// readprefdata() reads values of a selection and puts them in the preferences structure.
// To use this values in the layout preferences variable must be recreated using generateprefstable()

function readprefdata(target){
   local prfpath = fe.path_expand( AF.folder+"pref_layoutoptions.txt")
   if (target != null) prfpath = target
	local prffile = ReadTextFile (prfpath)
   local ptable = {}
	local version = ""
	try {	version = prffile.read_line() } catch (err) {
		fe.overlay.splash_message ("Error reading prefs file, resetting to default")
		return false
	}

	// if (version != AF.version) {
	//		fe.overlay.splash_message ("Preference version different from AF version, resetting to default")
	//		return false
	//	}
	// else {
		local warnmessage = ""
		while (!prffile.eos()){
			local templine = prffile.read_line()
			local z = split (templine,"|")

			for (local i = 0 ; i < AF.prefs.l0.len() ; i++){
				for (local j = 0 ; j < AF.prefs.l1[i].len() ; j++){
					local tempdat = AF.prefs.l1[i][j] //Instancing!

					if (tempdat.varname.toupper() == z[0]) {

						if (tempdat.v.tofloat() <= version.tofloat() ) {
							if (tempdat.selection >= 0) tempdat.selection = z[1].tointeger()
							else if (z.len() == 1) tempdat.values = ""
							else tempdat.values = z[1]
						}
						else {
							warnmessage = warnmessage + ("- "+ tempdat.title + "\n")
						}
					}
				}
			}
		}
		if (warnmessage != "") {
			fe.overlay.splash_message ("Reset prefs:\n\n" + warnmessage)
			return false
		}
	return true
	// }
}

/// Current date management ///

function currentdate(){
	return (date().year*1000 + date().yday)
}
function savedate(){
	local currentdate = date().year*1000 + date().yday
   local datepath = fe.path_expand( AF.folder+"pref_checkdate.txt")
   local datefile = WriteTextFile (datepath)
   datefile.write_line (currentdate+"\n")
}
function loaddate(){
   local datepath = fe.path_expand( AF.folder+"pref_checkdate.txt")
	if (!(file_exist(datepath))) return ("000000")
   local datefile = ReadTextFile (datepath)
   return (datefile.read_line ())
}

/// Layout start ///

local transdata = ["StartLayout", "EndLayout", "ToNewSelection","FromOldSelection","ToGame","FromGame","ToNewList","EndNavigation","ShowOverlay","HideOverlay","NewSelOverlay","ChangedTag"]

local z_info = {
	z_name = Info.Name
	z_title = Info.Title
	z_emulator = Info.Emulator
	z_cloneof = Info.CloneOf
	z_year = Info.Year
	z_manufacturer = Info.Manufacturer
	z_category = Info.Category
	z_players = Info.Players
	z_rotation = Info.Rotation
	z_control = Info.Control
	z_status = Info.Status
	z_displaycount = Info.DisplayCount
	z_displaytype = Info.DisplayType
	z_altromname = Info.AltRomname
	z_alttitle = Info.AltTitle
	z_extra = Info.Extra
	z_favourite = Info.Favourite
	z_tags = Info.Tags
	z_playedcount = Info.PlayedCount
	z_playedtime = Info.PlayedTime
	z_fileisavailable = Info.FileIsAvailable
	z_system = Info.System
	z_buttons = Info.Buttons
	z_region = Info.Region
	z_overview = Info.Overview
	z_ispaused = Info.IsPaused

	z_rundate = 90
	z_favdate = 91
	z_rating = 92
	z_series = 93
}

local orderdatalabel = {}
orderdatalabel [Info.System] <- split(ltxt("_System",TLNG),"_")[0]
orderdatalabel [Info.Name] <- split(ltxt("_Name",TLNG),"_")[0]
orderdatalabel [Info.Title] <- split(ltxt("_Title",TLNG),"_")[0]
orderdatalabel [Info.Emulator] <- split(ltxt("_Emul",TLNG),"_")[0]
orderdatalabel [Info.CloneOf] <- split(ltxt("_Clone",TLNG),"_")[0]
orderdatalabel [Info.Year] <- split(ltxt("_Year",TLNG),"_")[0]
orderdatalabel [Info.Manufacturer] <- split(ltxt("_Manuf",TLNG),"_")[0]
orderdatalabel [Info.Category] <- split(ltxt("_Categ",TLNG),"_")[0]
orderdatalabel [Info.Players] <- split(ltxt("_Players",TLNG),"_")[0]
orderdatalabel [Info.Rotation] <- split(ltxt("_Rot",TLNG),"_")[0]
orderdatalabel [Info.Control] <- split(ltxt("_Cntrl",TLNG),"_")[0]
orderdatalabel [Info.Status] <- split(ltxt("_Status",TLNG),"_")[0]
orderdatalabel [Info.DisplayCount] <- split(ltxt("_DispCt",TLNG),"_")[0]
orderdatalabel [Info.DisplayType] <- split(ltxt("_DispTp",TLNG),"_")[0]
orderdatalabel [Info.AltRomname] <- split(ltxt("_AltRomn",TLNG),"_")[0]
orderdatalabel [Info.AltTitle] <- split(ltxt("_AltTitle",TLNG),"_")[0]
orderdatalabel [Info.Extra] <- split(ltxt("_Extra",TLNG),"_")[0]
orderdatalabel [Info.Favourite] <- split(ltxt("_Fav",TLNG),"_")[0]
orderdatalabel [Info.Tags] <- split(ltxt("_Tags",TLNG),"_")[0]
orderdatalabel [Info.PlayedCount] <- split(ltxt("_PlCount",TLNG),"_")[0]
orderdatalabel [Info.PlayedTime] <- split(ltxt("_PlTime",TLNG),"_")[0]
orderdatalabel [Info.FileIsAvailable] <- split(ltxt("_Avail",TLNG),"_")[0]

orderdatalabel [z_info.z_rundate] <- split(ltxt("_Run",TLNG),"_")[0]
orderdatalabel [z_info.z_favdate] <- split(ltxt("_FavD.",TLNG),"_")[0]
orderdatalabel [z_info.z_rating] <- split(ltxt("_Rate",TLNG),"_")[0]
orderdatalabel [z_info.z_series] <- split(ltxt("_Series",TLNG),"_")[0]

function readsystemdata(){
	local unilogos = [" ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""]
	local sysdata = {}
	local sysinc = 0
	local syspath = fe.path_expand( AF.folder+"data_systems.txt")

	local sysfile = file(syspath,"rb")
	local tempcell = {}

	while ( !sysfile.eos() ) {
		local char = 0
		local line = ""

		while (char != 10) {
			char = sysfile.readn('b')
			if (char != 10) line = line + char.tochar()
		}

		if (line != ""){
			local linearray = split (line,",")
			if (linearray.len() > 1){

				sysdata[linearray[0]] <- {
					w = linearray[1].tofloat()
					h = linearray[2].tofloat()
					label = linearray[3]
					screen = linearray[4]
					recolor = linearray[5]
					ar = (linearray[6].tofloat() == 0.0) ? ( linearray[1].tofloat() == 0.0 ? 0.0 : linearray[1].tofloat()*1.0/linearray[2].tofloat()) : linearray[6].tofloat()*1.0/linearray[7].tofloat()
					group = linearray[8]
					logo = unilogos[sysinc]
					brand = linearray[9] == "null" ? "" : linearray[9]
					year = linearray[10] == "null" ? "9998" : linearray[10]
					sysname = linearray[11] == "null" ? "" : linearray[11]
					ss_id = linearray[12] == "null" ? null : linearray[12]
					ss_media = linearray[13] == "null" ? null : linearray[13]

				}
				tempcell = sysdata[linearray[0]]
			}
			else {
				sysdata[linearray[0]] <- tempcell
			}
		}
		else {
			sysinc++
		}
	}

return sysdata

}

local system_data = readsystemdata()

// prf is the table that cotains all the layout variables as they are used in the layout, like prf.CROPSNAPS etc
// this command generate default prefs table, this contains the variable names and values as used in the layout (not the selections)
prf = generateprefstable()
//local prfval = generateselectiontable()

// This function generates a clone of the "prefs" table (the one with all the data, not the variable table)
// It can be used as a reference to reset the save file to default values
AF.prefs.defaults = generateselectiontable()

// tries to load variables from file and regenerates list
try {
	// This function loads saved data into the current "prefs" data structure
	readprefdata(null)
	// Then this data is used to generate the new prf file with variables to use in the layout
	prf = generateprefstable()
}
catch (err){print("Error loading prefs file\n")}

// readprefsdata returns false if there is an issue with the file or if some options need to be reset
if (readprefdata(null) == false) saveprefdata(generateselectiontable(),null)

//This is used for parameters that can be changed dynamically with respect to the saved value
local prfzero = {}
foreach (item, val in prf){
	prfzero [item] <- val
}

// Prefs variables used as temporary checks for using grouped displays menu
prf.JUMPDISPLAYS <- false //This is used for group display jump, to avoid reordering lists until we are at the right spot
prf.JUMPSTEPS <- 0
prf.JUMPLEVEL <- 0 //Level 0 for parent list, level 1 for sub-lists, exit arcadeflow added only on parent list

prf.OLDOPTIONSPAGE <- false

prf.SPLASHLOGOFILE = ( prf.SPLASHLOGOFILE == "" ? "aflogow3.png" : prf.SPLASHLOGOFILE),

prf.AMSTART <- (prf.AMENABLE == "From start")
prf.AMENABLE = (prf.AMENABLE != "Disabled")

prf.SLIMLINE <- false

// Update version dismiss: prf.UPDATEDIMISSVER gets the value of the latest "dismissed" revision,
// checkforupdates downloads the latest version info and checks versus this one, if it's not newer than this
// no update display is triggered.
// prf.UPDATECHECKED is a "local" switch: once the update menu auto-popups, this is set to false so it doesn't pop
// up again until next launch, unless you "Dismiss" from the menu
prf.UPDATECHECKED <- false
prf.UPDATEDISMISSVER <- 0.0
if (file_exist(fe.path_expand( AF.folder + "pref_update.txt"))) prf.UPDATEDISMISSVER = (ReadTextFile (fe.path_expand( AF.folder + "pref_update.txt")).read_line())

// Set and save debug mode
DBGON = prf.DEBUGMODE
savedebug(DBGON ? "true" : "false")

// Set and save layout language
TLNG = prf.LAYOUTLANGUAGE
savelanguage(TLNG)

// Check conflicts in custom buttons
function check_buttons(){
	local buttonarray = [prf.SWITCHMODEBUTTON , prf.UTILITYMENUBUTTON, prf.OVERMENUBUTTON, prf.HISTORYBUTTON, prf.SEARCHBUTTON,prf.CATEGORYBUTTON,prf.MULTIFILTERBUTTON,prf.DELETEBUTTON]

	local conflict = false

	for (local i = 0 ; i < buttonarray.len() ; i++){
		if (buttonarray[i] != "none") {
			for (local j = 0 ; j < buttonarray.len() ; j++){
				if ((j != i) && (buttonarray[j] == buttonarray[i])) conflict = true
			}
		}
	}
	if (conflict) 	fe.overlay.splash_message ("WARNING: Conflict in Arcadeflow button assignment")
}

check_buttons()

try {prf.AMTIMER = prf.AMTIMER.tointeger()}
catch (err) {prf.AMTIMER = 120}

try {prf.AMCHANGETIMER = prf.AMCHANGETIMER.tointeger()}
catch (err) {prf.AMCHANGETIMER = 10}

if (prf.BASEROTATION == "none") fe.layout.base_rotation = RotateScreen.None
else if (prf.BASEROTATION == "left") fe.layout.base_rotation = RotateScreen.Left
else if (prf.BASEROTATION == "right") fe.layout.base_rotation = RotateScreen.Right
else if (prf.BASEROTATION == "flip") fe.layout.base_rotation = RotateScreen.Flip

local DISPLAYTABLE = {}
try { DISPLAYTABLE = loadtablefromfile("pref_thumbtype.txt",false) } catch (err) {}
if (DISPLAYTABLE == null) DISPLAYTABLE = {}

local SORTTABLE = {}
try { SORTTABLE = loadtablefromfile("pref_sortorder.txt",false) } catch (err) {}
if (SORTTABLE == null) SORTTABLE = {}

local displaystore = fe.list.display_index

try {
	prf.BOXARTMODE = ( (DISPLAYTABLE[fe.displays[fe.list.display_index].name][0] == "BOXES") ? true : false )
}
catch (err){}

if (prf.BGCUSTOM == "pics/") prf.BGCUSTOM = ""
if (prf.BGCUSTOMHISTORY == "pics/") prf.BGCUSTOMHISTORY = ""

if (prf.LOWSPECMODE){
	prf.DATASHADOWSMOOTH = false
	prf.SNAPGRADIENT = false
	prf.SNAPGLOW = false
}


//HUECYCLE
//prf.HUECYCLE <- true
local huecycle = {
	hue = 0
	RGB = {R=1.0,G=1.0,B=1.0}
	speed = prf.HCSPEED	//Hue shift speed
	saturation = split(prf.HCCOLOR,"_")[0].tofloat()		//Saturation value
	lightness = split(prf.HCCOLOR,"_")[1].tofloat()		//Lightness value (0 to 0.5 from black to full color, 0.5 to 1.0 for color to white)
	minhue = 0 				//Hue cycle start from 0 to 359
	maxhue = 359 			//Hue cycle stop rom 0 to 359
	pingpong = prf.HCPINGPONG		//Jump back and forth between min and max
}
huecycle.hue = huecycle.minhue
try{
	huecycle.minhue = prf.HCHUESTART.tointeger()
	if (huecycle.minhue < 0) huecycle.minhue = 0
	if (huecycle.minhue > 358) huecycle.minhue = 358
}catch(err){}
try{
	huecycle.maxhue = prf.HCHUESTOP.tointeger()
	if (huecycle.maxhue < 1) huecycle.maxhue = 1
	if (huecycle.maxhue > 359) huecycle.maxhue = 359
}catch(err){}

if (huecycle.maxhue <= huecycle.minhue){
	huecycle.minhue = 0
	huecycle.maxhue = 359
}

//TEST107 prf.LOGOSONLY <- !true
if (prf.LOGOSONLY) {
	prf.FADEVIDEOTITLE = true
	prf.CROPSNAPS = false
	prf.BOXARTMODE = false
}
// End prf setup


local commandtable = af_create_command_table()

// cleanup frosted glass screen grabs
local dir0 = {
	dir = DirectoryListing( FeConfigDirectory )
	fpos01 = null
	fpos02 = null
}

// Background and data crossfade stack

local bgvidsurf = null

local bgs = {
	stacksize = (prf.LOWSPECMODE ? 3 : 5)
	bgpic_array = []
	bgvid_array = []
	flowalpha = []
	bg_lcd = []
	bg_mono = []
	bg_box = []
	bg_index = []
	bg_aspect = []
}

local dat = {
	stacksize = (prf.LOWSPECMODE ? 3 : 5)
	var_array = []
	cat_array = []
	but_array = []
	ctl_array = []
	ply_array = []
	mainctg_array = []
	manufacturer_array = []
	manufacturername_array = []
	gamename_array = []
	gamesubname_array = []
	gameyear_array = []
	alphapos = []
}

// Initialize variables
local var = 0
local z_var = 0

// Fade data: [0 - FADE COUNTER, 1 - FADE VALUE, 2 - FADE STARTER, 3 - FADE INCREASER, 4 - FADE EASER]
// FADE COUNTER counts from 0 to 1 (if FADE INCREASER > 0) or from 1 to 0 (FADE INCREASER < 0) linearly
// FADE VALUE is a fade value calculated from FADE COUNTER based on FADE EASER: 0.0 linear, n.0 ease start, -n.0 ease stop
// FADE STARTER is the counter value at which the fade is when changing fade,
// it should be equal to FADE VALUE and FADE COUNTER when initializing the variable,
// is used for incremental non-linear fading and shouldn't be touched if not by startfade function

local flowT = {
	overmenu = [0.0,0.0,0.0,0.0,0.0]
	history = [0.0,0.0,0.0,0.0,0.0]
	histtext = [0.0,0.0,0.0,0.0,0.0]
	data = [0.0,0.0,0.0,0.0,0.0]
	logo = [0.0,1.0,0.0,0.0,0.0]
	fg = [0.0,1.0,0.0,0.0,0.0]
	groupbg = [0.0,0.0,0.0,0.0,0.0]
	attract = [0.0,1.0,0.0,0.0,0.0]
	gametoblack = [0.0,0.0,0.0,0.0,0.0]
	blacker = [0.0,1.0,0.0,0.0,0.0]
	historydata = [0.0,0.0,0.0,0.0,0.0]
	historyscroll = [0.0,0.0,0.0,0.0,0.0]
	historyblack = [0.0,0.0,0.0,0.0,0.0]

	// Keyboard fade
	keyboard = [0.0,0.0,0.0,0.0,0.0]

	// Zmenu related fades
	zmenubg = [0.0,0.0,0.0,0.0,0.0]
	zmenush = [0.0,0.0,0.0,0.0,0.0]
	zmenutx = [0.0,0.0,0.0,0.0,0.0]
	zmenudecoration = [0.0,0.0,0.0,0.0,0.0]

	// Blur effect intensity
	frostblur = [0.0,0.0,0.0,0.0,0.0]

	filterbg = [0.0,0.0,0.0,0.0,0.0]

	// Game letter or display name zoom/fade
	alphaletter = [0.0,0.0,0.0,0.0,0.0]
	zoomletter = [0.0,0.0,0.0,0.0,0.0]
	alphadisplay = [0.0,0.0,0.0,0.0,0.0]
	zoomdisplay = [0.0,0.0,0.0,0.0,0.0]
}

local noshader = fe.add_shader( Shader.Empty )

// Search parameters
local search_base_rule = "Title"
local backs = {
	index = -1
	corrector = -1
}

local column ={
	stop = 0
	start = 0
	offset = 0
}

local squarizer = true

// Apply color theme
local themeT = {
	themeoverlaycolor = 255 //basic color of overlay
	themeoverlayalpha = 80	// overlay alpha
	themetextcolor = 255	// color of main text
	themelettercolor = 255	// color of popup letter
	themehistorytextcolor = 90 // color of history text
	themeshadow = 50 // shadow color
	menushadow = 50 // menu shadow color
	listboxbg = 200 // listbox overlay color
	listboxalpha = 15 //listbox overlay alpha
	listboxselbg = 250 // listbox selection background
	listboxseltext = 250 // listbox text of selected item
	optionspanelrgb = 128 // Grey level of options panel
	optionspanelalpha = 80 // Alpha of options panel
	mfmrgb = 0
	mfmalpha = 150
}

local satin = {
	rate = 0.95
	vid = 50
}

if (prf.COLORTHEME == "basic"){
	themeT.themeoverlaycolor = 255
	themeT.themeoverlayalpha = 80
	themeT.themetextcolor = 255
	themeT.themelettercolor = 255
	themeT.themehistorytextcolor = 90
	themeT.themeshadow = 50
	themeT.menushadow = 50
	themeT.listboxbg = 200
	themeT.listboxalpha = 15
	themeT.listboxselbg = 250
	themeT.listboxseltext = 50
	themeT.optionspanelrgb = 100
	themeT.optionspanelalpha = 80
	themeT.mfmrgb = 60
	themeT.mfmalpha = 230
}
if (prf.COLORTHEME == "dark"){
	themeT.themeoverlaycolor = 0
	themeT.themeoverlayalpha = 110*0 + 140*0 + 150
	themeT.themetextcolor = 230*0 + 240
	themeT.themelettercolor = 255
	themeT.themehistorytextcolor = 90
	themeT.themeshadow = 80
	themeT.menushadow = 80
	themeT.listboxbg = 200
	themeT.listboxalpha = 15
	themeT.listboxselbg = 225
	themeT.listboxseltext = 50
	themeT.optionspanelrgb = 0
	themeT.optionspanelalpha = 70
	themeT.mfmrgb = 0
	themeT.mfmalpha = 220
}
if (prf.COLORTHEME == "light"){
	themeT.themeoverlaycolor = 255
	themeT.themeoverlayalpha = 190
	themeT.themetextcolor = 90
	themeT.themelettercolor = 255
	themeT.themehistorytextcolor = 90
	themeT.themeshadow = 50
	themeT.menushadow = 25
	themeT.listboxbg = 255
	themeT.listboxalpha = 120
	themeT.listboxselbg = 95
	themeT.listboxseltext = 200
	themeT.optionspanelrgb = 128
	themeT.optionspanelalpha = 50
	themeT.mfmrgb = 255
	themeT.mfmalpha = 200
}
if (prf.COLORTHEME == "pop"){
	themeT.themeoverlaycolor = 255
	themeT.themeoverlayalpha = 0
	themeT.themetextcolor = 255
	themeT.themelettercolor = 255
	themeT.themehistorytextcolor = 90
	themeT.themeshadow = 70
	themeT.menushadow = 70
	themeT.listboxbg = 200
	themeT.listboxalpha = 15
	themeT.listboxselbg = 250
	themeT.listboxseltext = 50
	themeT.optionspanelrgb = 50
	themeT.optionspanelalpha = 50
	themeT.mfmrgb = 0
	themeT.mfmalpha = 240
}

// Math functions

function minv(vectorin){ //Return min value in an array
	local resultArray = vectorin.map(function(value) {return value})
	resultArray.sort()
	return (resultArray[0])
}

function maxv(vectorin){ //Return max value in an array
 	local resultArray = vectorin.map(function(value) {return value})
	resultArray.sort()
	return (resultArray[resultArray.len()-1])
}

function minvindex(vectorin){ //Return min value index in an array
	local resultArray = vectorin.map(function(value) {return value})
	return vectorin.find(minv(resultArray))
}

function maxvindex(vectorin){ //Return max value index in an array
	local resultArray = vectorin.map(function(value) {return value})
	return vectorin.find(maxv(resultArray))
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

function hsl2rgb (H,S,L){
	local C = (1.0 - absf(2.0 * L - 1.0)) * S
	local X = C * (1.0 - absf( ((H*1.0/60.0) % 2 ) - 1.0 ))
	local m = L - C/2.0
	local R1 = null
	local G1 = null
	local B1 = null

	if			((H >= 0)	&& (H < 60))	{R1 = C ; G1 = X ; B1 = 0}
	else if	((H >= 60)	&& (H < 120))	{R1 = X ; G1 = C ; B1 = 0}
	else if	((H >= 120) && (H < 180))	{R1 = 0 ; G1 = C ; B1 = X}
	else if	((H >= 180) && (H < 240))	{R1 = 0 ; G1 = X ; B1 = C}
	else if	((H >= 240) && (H < 300))	{R1 = X ; G1 = 0 ; B1 = C}
	else if	((H >= 300) && (H < 360))	{R1 = C ; G1 = 0 ; B1 = X}

	local OUT ={
		R = (R1 + m)
		G = (G1 + m)
		B = (B1 + m)
	}
	return (OUT)
}

//TEST102
if (prf.RANDOMTUNE && (prf.BACKGROUNDTUNE != "")){
	local songdirarray = split (prf.BACKGROUNDTUNE,"/")
	local songdir = prf.BACKGROUNDTUNE[0].tochar() == "/" ? "/" : ""
	for (local i = 0; i < songdirarray.len()-1; i++){
		songdir += songdirarray[i]+"/"
	}
	local filelist = DirectoryListing (songdir).results
	foreach (i,item in filelist){
		if (item.slice(-3).tolower() == "mp3") AF.bgsongs.push (item)
	}
}


// UI sounds
local snd = {
	clicksound = fe.add_sound("mouse3.mp3")
	plingsound = fe.add_sound("pling1.wav")
	mplinsound = fe.add_sound("pling2.wav")
	wooshsound = fe.add_sound("woosh4.mp3")
	mbacksound = fe.add_sound("woosh5.mp3")
	attracttune = fe.add_sound(prf.AMTUNE)
	bgtune = !(prf.RANDOMTUNE && prf.BACKGROUNDTUNE != "") ? fe.add_sound(prf.BACKGROUNDTUNE) : fe.add_sound(AF.bgsongs[AF.bgsongs.len()*rand()/RAND_MAX])
	attracttuneplay = false
	bgtuneplay = false
}
snd.plingsound.pitch = 2.0
snd.mbacksound.pitch = 0.8

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

local globalposnew = 0
local	surfacePos = 0

local impulse2 = {
	delta = 0
	step = 0
	step_f = 0
	flow0 = 0
	flow = 0
	tilepos = 0
	tilepos0 = 0
	samples = 13 //13 o 15?
	filtern = 1
	maxoffset = null
}

local filterw = array(impulse2.samples,1.0)
local filtersw = []

filtersw.push(array(impulse2.samples,0.0))
filtersw[0][impulse2.samples-1] = 1.0
filtersw.push(array(impulse2.samples,1.0))

foreach(i,item in filtersw[1]){
	filtersw[1][i] = impulse2.samples-i
}
for(local i = 0; i < (impulse2.samples-1)*0.5; i++){
	filtersw[1][i] = i+1
}

/*
foreach (i,item in filtersw){
	foreach (i2, item2 in item){
		print (item2+" ")
	}
	print ("\n")
}
*/

local srfposhistory = array(impulse2.samples,0.0)

function getfiltered(arrayin,arrayw){
	local sumv = 0
	local sumw = 0
	foreach (i,item in arrayin){
		sumv += arrayin[i]*arrayw[i]
		sumw += arrayw[i]
	}
	return sumv*1.0/sumw
}

local colormapper = {}

colormapper["LCDGBA"] <- {
	shad = fe.add_shader (Shader.Fragment, "glsl/colormapper.glsl")
	a = hsl2rgb(150,0.5,0.2)
	b = hsl2rgb(70,0.50,0.6)
	lcdcolor = 1.0
	remap = 0.0
	hsv = [0.0,0.0,0.0]
}

colormapper["LCDGBC"] <- {
	shad = fe.add_shader (Shader.Fragment, "glsl/colormapper.glsl")
	a = hsl2rgb(103.0,0.95,0.15)
	b = hsl2rgb(68,0.68,0.40)
	lcdcolor = 0.0
	remap = 1.0
	hsv = [0.0,0.0,0.0]
}
colormapper["LCDGBP"] <- {
	shad = fe.add_shader (Shader.Fragment, "glsl/colormapper.glsl")
	a = hsl2rgb(90,0.05,0.10)
	b = hsl2rgb(66,0.26,0.7)
	lcdcolor = 0.0
	remap = 1.0
	hsv = [0.0,0.0,0.0]
}
colormapper["LCDGBL"] <- {
	shad = fe.add_shader (Shader.Fragment, "glsl/colormapper.glsl")
	a = hsl2rgb(160,0.9,0.15)
	b = hsl2rgb(160,0.7,0.5)
	lcdcolor = 0.0
	remap = 1.0
	hsv = [0.0,0.0,0.0]
}
colormapper["LCDBW"] <- {
	shad = fe.add_shader (Shader.Fragment, "glsl/colormapper.glsl")
	a = hsl2rgb(90,0.05,0.2)
	b = hsl2rgb(66,0.2,0.7)
	lcdcolor = 0.0
	remap = 1.0
	hsv = [0.0,0.0,0.0]
}
colormapper["NONE"] <- {
	shad = fe.add_shader (Shader.Fragment, "glsl/colormapper.glsl")
	a = hsl2rgb(150,0.5,0.2)
	b = hsl2rgb(70,0.50,0.6)
	lcdcolor = 0.0
	remap = 0.0
	hsv = [0.0,0.0,0.0]
}
colormapper["BOXART"] <- {
	shad = fe.add_shader (Shader.Fragment, "glsl/colormapper.glsl")
	a = hsl2rgb(0,0.0,0.8)
	b = hsl2rgb(0,0.0,0.4)
	lcdcolor = 0.0
	remap = 1.0
	hsv = [0.0,0.0,0.0]
}

colormapper["8BIT"] <- {
	shad = fe.add_shader (Shader.Fragment, "glsl/colormapper.glsl")
	a = hsl2rgb(0,0.0,0.0)
	b = hsl2rgb(0,0.0,0.0)
	lcdcolor = 0.0
	remap = 0.0
	hsv = prf.CRTRECOLOR ? [0.0,-0.2,-0.03] : [0.0,0.0,0.0]
}

foreach (item, val in colormapper){
	colormapper[item].shad.set_param ("color1",val.a.R,val.a.G,val.a.B)
	colormapper[item].shad.set_param ("color2",val.b.R,val.b.G,val.b.B)
	colormapper[item].shad.set_param ("lcdcolor",val.lcdcolor)
	colormapper[item].shad.set_param ("remap",val.remap)
	colormapper[item].shad.set_param ("hsv",val.hsv[0],val.hsv[1],val.hsv[2])
}

// GAME BOY green tints in HSL format (H = 0 360, SL = 0 1)

local gbrgb = {
	"LCDGBC" : {
		a = hsl2rgb(103.0,0.95,0.15)
		b = hsl2rgb(68,0.68,0.40)
	}
	"LCDGBP" : {
		a = hsl2rgb(90,0.05,0.10)
		b = hsl2rgb(66,0.26,0.7)
	}
	"LCDGBL" : {
		a = hsl2rgb(160,0.9,0.15)
		b = hsl2rgb(160,0.7,0.5)
	}
	"LCDBW" : {
		a = hsl2rgb(90,0.05,0.2)
		b = hsl2rgb(66,0.2,0.7)
	}
	"NONE" : {
		a = hsl2rgb(150,0.5,0.2)
		b = hsl2rgb(70,0.50,0.6)
	}
}

// Horizontal rows definition
if (prf.HORIZONTALROWS == -1){
	prf.HORIZONTALROWS = 1
	prf.SLIMLINE = true
}
else {
	prf.HORIZONTALROWS = prf.HORIZONTALROWS.tointeger()
	prf.SLIMLINE = false
}

// layout preferences
local rows = prf.HORIZONTALROWS

local vertical = false

// font definition
local uifonts = {
	gui = "font_Roboto-Allcaps-EXT3X.ttf"
	general = "font_Roboto-Bold.ttf"
	condensed = "font_Roboto-Condensed-Bold.ttf"
	lite = "font_Roboto-Regular.ttf"
	arcade = "font_CPMono_Black.otf"
	arcadeborder = "font_CPMono_BlackBorder2.otf"
	glyphs = "font_glyphs.ttf"
	mono = "font_RobotoMono-VariableFont_wght.ttf"
	pixel = 0.711
}

//screen layout definition
local scr = {
	w = ScreenWidth
	h = ScreenHeight
}

if (prf.CUSTOMSIZE != ""){
	try {
		scr.w = split(prf.CUSTOMSIZE,"xX")[0]
		scr.h = split(prf.CUSTOMSIZE,"xX")[1]
		scr.w = scr.w.tointeger()
		scr.h = scr.h.tointeger()
	}
	catch ( err ) { fe.overlay.splash_message("Wrong syntax in screen resolution");prf.CUSTOMSIZE = "";scr.w = ScreenWidth; scr.h = ScreenHeight }
}


local fl = {
	w_os = scr.w
	h_os = scr.h
	surf = null
	surf2 = null
	surf3 = null
	overscan_w = 1.0
	overscan_h = 1.0
	w = 0
	h = 0
	x = 0
	y = 0
}

if (prf.OVERSCANW != "") {
	try {
		fl.overscan_w = prf.OVERSCANW.tointeger()
		if ((fl.overscan_w > 0) && (fl.overscan_w <= 100)){
			fl.overscan_w = fl.overscan_w / 100.0
		}
	}catch(err){}
}

if (prf.OVERSCANH != "") {
	try {
		fl.overscan_h = prf.OVERSCANH.tointeger()
		if ((fl.overscan_h > 0) && (fl.overscan_h <= 100)){
			fl.overscan_h = fl.overscan_h / 100.0
		}
	}catch(err){}
}

local rotation = {
	real = null
	r90 = null
}

rotation.real = ( fe.layout.base_rotation + fe.layout.toggle_rotation ) % 4
rotation.r90 = ((rotation.real % 2) != 0)

if (rotation.r90){
	fl.w_os = scr.h
	fl.h_os = scr.w
}

fl.w = fl.w_os * fl.overscan_w
fl.h = fl.h_os * fl.overscan_h
fl.x = 0.5 * (fl.w_os - fl.w)
fl.y = 0.5 * (fl.h_os - fl.h)


/*
fl.surf2 = fe.add_surface (fl.w_os*0.2,fl.h_os*0.2)
fl.surf2.mipmap = 1
fl.surf2.zorder = 100000
*/
if (fl.h_os > fl.w_os) vertical = true
if (vertical) prf.SLIMLINE = false
if (vertical) rows = prf.VERTICALROWS

rows = (prf.LOWRES ? 1 : rows)

fe.layout.width = fl.w_os
fe.layout.height = fl.h_os
fe.layout.preserve_aspect_ratio = true
fe.layout.page_size = rows
fe.layout.font = uifonts.general


local scalerate = (vertical ? fl.w : fl.h)/1200.0

// Changed header spacer from 200 to 220 better centering
local header = {
	h = floor (prf.LOWRES ? 260*scalerate : 200*scalerate ) // content
	h2 = floor (prf.LOWRES ? 330*scalerate : (((rows == 1) && (!prf.SLIMLINE))? 250*scalerate : 220*scalerate)) //spacer
}
// Changed header spacer from 100 to 90 better centering
local footer = {
	h = floor (prf.LOWRES ? 150*scalerate : 100*scalerate ) // content
	h2 = floor (prf.LOWRES ? 150*scalerate : (((rows == 1) && (!prf.SLIMLINE)) ? 150*scalerate : 90*scalerate)) //spacer
}

// multiplier of padding space (normally 1/6 of thumb area)
local padding_scaler = 1.0/6.0

local height = (fl.h - header.h2 - footer.h2)/(rows + rows*padding_scaler + padding_scaler)
if ((prf.SLIMLINE) ){
	height = (fl.h - header.h2 - footer.h2)/(2.0 + 2.0*padding_scaler + padding_scaler)
	footer.h = 1.5*footer.h
}

local width = height

local padding = height * padding_scaler
local widthpadded = width + 2 * padding
local heightpadded = height + 2 * padding

local width169 = height*10/16 //TEST169
local width169padded = width169 + 2 * padding //TEST169
local widthmix = (prf.FIX169 ? width169 : width)
local widthpaddedmix = (prf.FIX169 ? width169padded : widthpadded)

local verticalshift = height*16.0/480.0

/*
Nominal (for calculation purposes) sizes:
	Tile size: 640 x 640
	Square center size: 480 x 480
	Vertical shift: 16
*/


//calculate number of columns
local cols = (1 + 2*(floor (( fl.w/2 + widthmix/2 - padding) / (widthmix + padding))))
// add safeguard tiles
cols += 2

local pagejump = prf.SCROLLAMOUNT*rows*(cols-2)

// carrier sizing in general layout
local carrierT = {
	x = fl.x -(cols * (widthmix + padding) + padding - fl.w) * 0.5,
	y = fl.y + header.h2 + (prf.SLIMLINE ? height * 0.5 : 0 ),
	w = cols * (widthmix + padding) + padding,
	h = rows * height + rows * padding + padding
}

// Changed selectorscale from 1.5 to 1.45 in default zoom
// selector and zooming data
//TEST106 Changed reduced zoom from 1.1 to 1.15 (still no overlap of tiles)
local selectorscale = (prf.TILEZOOM == 0 ? 1.0 : (prf.TILEZOOM == 1 ? 1.15 : (rows == 1 ? (vertical ? 1.15 : 1.45) : ((prf.SCROLLERTYPE == "labellist") ? 1.4 : 1.45) )))

local whitemargin = 0.15

local selectorwidth = selectorscale * widthpadded

// correction data for non-centered first tiles
local deltacol = (cols - 3)/2 //TEST103 controllare se questo "-3" va sempre bene o in alcuni casi fa saltare

local centercorr = {
	zero = null
	val = null
	shift = null
}

centercorr.zero = - deltacol*(widthmix + padding) -(fl.w - (carrierT.w - 2*(widthmix + padding))) / 2 - padding*(1 + selectorscale*0.5) - widthmix/2 + selectorwidth/2
centercorr.val = 0
centercorr.shift = centercorr.zero

// transitions speeds
local spdT = {
	scrollspeed = 0.91 //TEST105 was 0.92
	dataspeedin = 0.91 //TEST105 was 0.92
	dataspeedout = 0.88
}

// Video delay parameters to skip fade-in
local vidstarter = 10000
local delayvid = vidstarter - 60 * prf.THUMBVIDELAY
local fadevid = delayvid - 35

// Fading letter and scroller sizes
local lettersize = {
	name = 250 * scalerate
	//display = (fl.w_os * 30.0/200.0) / uifonts.pixel
}

local footermargin = 250 * scalerate
local scrollersize = 2 * floor (20 * scalerate * 0.5) + 1

// Blurred backdrop definition
local bgT = {
	x = 0
	y = (fl.h_os - fl.w_os) / 2.0
	w = fl.w_os
}

// Picture background definition
local bgpicT = {
	x = 0,
	y = 0,
	w = fl.w_os,
	h = fl.h_os,
	ar = 1.0
}

if (vertical){
	bgT.x = (fl.w_os - fl.h_os) / 2
	bgT.y = 0
	bgT.w = fl.h_os
}

// parameters for changing scroll jump spacing
local scroll = {
	jump = false
	step = rows
	sortjump = false
}

// Capslocked keyboard also adds special characters:
// 1 2 3 4 5 6 7 8 9 0
// ! $ & / ( ) = ? + -

// keys definition for on screen keyboard
local key_names = {"^":"^","+":"+","-":"-","(":"(",")":")","&":"&",".":".",",":",", "/":"/", "A": "A", "B": "B", "C": "C", "D": "D", "E": "E", "F": "F", "G": "G", "H": "H", "I": "I", "J": "J", "K": "K", "L": "L", "M": "M", "N": "N", "O": "O", "P": "P", "Q": "Q", "R": "R", "S": "S", "T": "T", "U": "U", "V": "V", "W": "W", "X": "X", "Y": "Y", "Z": "Z", "1": "1", "2": "2", "3": "3", "4": "4", "5": "5", "6": "6", "7": "7", "8": "8", "9": "9", "0": "0", "<": "⌫", " ": "⎵", "|": "⌧", "~": "DONE","}" : " ", "{":" " }
local key_names_secondary = {"^":"^","+":"#","-":"_","(":"[",")":"]","&":"*",".":"!",",":":", "/":"?", "A": "a", "B": "b", "C": "c", "D": "d", "E": "e", "F": "f", "G": "g", "H": "h", "I": "i", "J": "j", "K": "k", "L": "l", "M": "m", "N": "n", "O": "o", "P": "p", "Q": "q", "R": "r", "S": "s", "T": "t", "U": "u", "V": "v", "W": "w", "X": "x", "Y": "y", "Z": "z", "1": "1", "2": "2", "3": "3", "4": "4", "5": "5", "6": "6", "7": "7", "8": "8", "9": "9", "0": "0", "<": "⌫", " ": "⎵", "|": "⌧", "~": "DONE","}" : " ", "{":" " }
//local key_rows = ["abcdefghi123", "jklmnopqr456", "stuvwxyz/789", "}<{} {}|{}0{","~"]
local key_rows = ["<1234567890-", "|ABCDEFGHIJ+", "^KLMNOPQRS()"," TUVWXYZ.,&/","~"]
if (prf.KEYLAYOUT == "QWERTY") key_rows = ["qwertyuiop123", "asdfghjkl{456", "}zxcvbnm{{789", "}<{} {}|{{}0{","~"]
if (prf.KEYLAYOUT == "AZERTY") key_rows = ["azertyuiop123", "qsdfghjklm456", "}}wxcvbn{{789", "}<{} {}|{{}0{","~"]

if (vertical) {
	key_rows = ["1234567890","abcdefghij","klmnopqrst","uvwxyz{< |","~"]
	if (prf.KEYLAYOUT == "QWERTY") 	key_rows = ["1234567890","qwertyuiop","asdfghjkl{","zxcvbnm< |","~"]
	if (prf.KEYLAYOUT == "AZERTY") 	key_rows = ["1234567890","azertyuiop","qsdfghjklm","}wxcvbn< |","~"]
}
local key_selected = [0,0]
local keyboard_entrytext = ""

/// XML import routines ///

function char_replace (inputstring,old,new){
   local out = ""
   local splitarray = split (inputstring,old)
   foreach (id,item in splitarray){
      out = out + (id > 0 ? new : "") + item
   }
   return out
}

function manufacturer_cleanup (inputstring){
   // Remove NBSP
	local nbsp = 0xc2
   nbsp = nbsp.tochar()
   local zip = inputstring.find(nbsp)
   while (zip != null){
      inputstring = inputstring.slice(0,zip) + " " + inputstring.slice (zip + 2)
      zip = inputstring.find(nbsp)
   }

	// Remove strange characters
	//inputstring = char_replace (inputstring,"’","'")

	return inputstring
}

function string_enum(string,text){
	local i = 0
	local num = 0
	local strlen = string.len()
	while ((i < strlen) && (i != null)){
		i = string.find (text,i)
		if (i != null) {
			i = i + text.len()
			num ++
		}
	}
	return (num)
}

function subst_replace (inputstring,old,new){
   local st = inputstring.find (old)
   while (st != null){
      inputstring = (inputstring.slice (0,st)+new+inputstring.slice (st+old.len()))
      st = inputstring.find(old)
   }
   return inputstring
}

function clean_desc (inputstring){
   return char_replace(char_replace (subst_replace(subst_replace(inputstring,"&amp;","&"),"&#039;","'"),";","§"),"’","'")
}

function clean_synopsis (inputstring){
   return char_replace(char_replace (subst_replace(subst_replace(inputstring,"\\n","^"),"&#039;","'"),";","§"),"’","'")

}

function parseXML(inputpath) {
   local XMLT = {}
   local line = ""
   local inputfile = ReadTextFile (inputpath)
   local gamepath = ""
	local gamepathwext = ""
   local patharray = []
   local patharray2 = []
	local gameext = ""

   local tag1 = ""
   local indesc = false
	local ingame = false

   while (!inputfile.eos()){
      line = inputfile.read_line()

      line = clean_desc(line)

      local a1 = split(line,"<>")

      tag1 = a1.len() > 0 ? a1[0] : ""

		if ( !ingame && tag1 == "path") {
			ingame = true
		}

		if (ingame) {
			switch (tag1){

				case "path":
					patharray = split(a1[1],"/")
					gamepathwext = patharray[patharray.len() - 1]
					patharray2 = split(gamepathwext,".")
					gameext = patharray2[patharray2.len() - 1]
					gamepath = gamepathwext.slice (0,-1-gameext.len())

					/*
					local gp1 = split(gamepath,"(")
					gamepath = gp1[0]
					*/

					XMLT[gamepath] <- {
						name = ""
						rating = ""
						releasedate = ""
						developer = ""
						publisher = ""
						genre = ""
						players = ""
						desc = ""
						genreid = ""
						ext = gameext
					}
				break

				case "name /":
				case "rating /":
				case "releasedate /":
				case "developer /":
				case "publisher /":
				case "genre /":
				case "players /":
				case "desc /":
				case "genreid /":
					XMLT[gamepath][split(tag1," /")[0]] <- ""
					indesc = false
				break

				case "name":
				case "rating":
				case "releasedate":
				case "developer":
				case "publisher":
				case "genre":
				case "players":
				case "genreid":
					XMLT[gamepath][tag1] <- manufacturer_cleanup(a1[1])
					indesc = false
				break

				case "desc":
					XMLT[gamepath][tag1] <- a1.len() > 1 ? clean_desc(a1[1]) : ""
					indesc = true
					tag1 = ""
				break

				default:
					if (indesc) XMLT[gamepath]["desc"] += "^" + clean_desc(tag1)
				break
			}
		}
   }

   return (ingame ? XMLT : null)
}

function getemulatordata(emulatorname){
	local out = {
		rompath = null
		romextarray = null
		importextras = null
		mainsysname = null
		artworktable = {}
	}
	local infile = ReadTextFile (FeConfigDirectory+"emulators/"+emulatorname)
   local inline = ""
	local rompath = ""
	local gamepath = ""
	local romext = ""
	local romextarray = []
	local extras = ""
	local mainsysname = ""
	local artworktable = {}

	while (!infile.eos()){
		inline = infile.read_line()
		if (inline.find("rompath") == 0) {
			rompath = strip(inline.slice(7))
			if ((rompath.slice(-1) != "\\") && (rompath.slice(-1) != "/")) rompath = rompath + "/"
			gamepath = fe.game_info(Info.Name)
		}
		else if (inline.find ("romext") == 0){
			romext = strip(inline.slice(6))
			romextarray = split(romext,";")
		}
		else if (inline.find ("system") == 0){
			mainsysname = strip(inline.slice(6))
			mainsysname = split(mainsysname,";")[0]
		}
		else if (inline.find("import_extras") == 0){
			if (inline.len() > 14){
				extras = fe.path_expand(strip(inline.slice (14)))
			}
			else extras = ""
		}
		else if (inline.find("artwork") == 0){
			inline = split(inline," ")
			if (inline.len()>2) {
				local path = ""
				for (local i = 2; i < inline.len();i++){
					path += (inline[i]+" ")
				}
				artworktable[inline[1]] <- strip(path)
			}
			//extras = fe.path_expand(strip(inline.slice (14)))

		}
	}
	if (artworktable.snap.find(";") != null){
		artworktable.video <- split(artworktable.snap,";")[1]
		artworktable.snap = split(artworktable.snap,";")[0]
	}

	try{if (rompath.slice(0,3) == "../") rompath = FeConfigDirectory + rompath} catch(err){}
	foreach (id,item in artworktable){
		try{if (item.slice(0,3) == "../") artworktable[id] = FeConfigDirectory + item}catch(err){}
	}

	foreach (id,item in artworktable) artworktable[id] = fe.path_expand(item)

	out.rompath = fe.path_expand(rompath)
	out.romextarray = romextarray
	out.importextras = extras
	out.mainsysname = mainsysname
	out.artworktable = artworktable

	return (out)
}

function messageOLDboxer(title,message,new,arrayin){
	// Creates a "scrolling" message box on the screen:

	// If title is not "", it will appear as title anc
	// clear all the data on the screen

	// If message is not "", and new is enabled, message
	// is added on top and older text is scrolled down

	// If message is not "" but new is false, text is appended
	// to the end of the current top line

	if (title != ""){
		arrayin[0] = title
		if(message == ""){
			for (local i = 1; i<arrayin.len();i++){
				arrayin[i] = ""
			}
		}
	}

	if (message != ""){
		if (new){
			for (local i = arrayin.len() - 1; i>1; i--){
				arrayin[i] = arrayin[i-1]
			}
			arrayin[1] = message
		}
		else {
			arrayin[1] = message
		}
	}

	local text = ""
	foreach (id,item in arrayin){
		text = text + arrayin[id]+"\n"
		if (id == 0) text+="\n"
	}
	fe.overlay.splash_message(text)
	//AF.messageoverlay.msg = text
	return arrayin
}

function messageboxer(title,message,new,arrayin){
	// Creates a "scrolling" message box on the screen:

	// If title is not "", it will appear as title anc
	// clear all the data on the screen

	// If message is not "", and new is enabled, message
	// is added on top and older text is scrolled down

	// If message is not "" but new is false, text is appended
	// to the end of the current top line

	if (title != ""){
		arrayin[0] = title
		if(message == ""){
			arrayin[1] = ""
		}
	}

	if (message != ""){
		if (new){
			arrayin[1] = message+arrayin[1]
		}
		else {
			arrayin[1] = message
		}
	}

	local text = ""
	foreach (id,item in arrayin){
		text = text + arrayin[id]+"\n"
		if (id == 0) text+="\n"
	}
	//fe.overlay.splash_message(text)
	AF.messageoverlay.msg = text
	return arrayin
}


function patchtext (string1,string2,width2,columns){
	local out = ""
	local separator = "…"
	local separatorsize = 1

	local string1space = columns - width2 -1
	if (string1.len() > string1space){
		string1 = string1.slice(0,string1space*0.5-separatorsize)+separator+string1.slice(string1.len()-string1space*0.5,string1.len())
	}

	while (string1.len() < string1space){
		string1 += " "
	}

	out = string1+" "+string2

	while (out.len() < columns){
		out += " "
	}
	return out

}

function textrate (num,den,columns){
	local out = ""
	local limit = (num*columns)/den
	local i = 0
	local char = ""

	while (out.len() < limit){
		out += "|"
	}
	while (out.len() < columns){
		out += "\\"
	}
	return out
}

function collatelist2(romlistid){
						// Copy the romlists in the destination romlist
			//local fileout = WriteTextFile (romlistpath)
				AF.boxmessage = messageboxer (AF.scrape.romlist,romlistid+"\n",true,AF.boxmessage)

				local listfilepath = fe.path_expand(FeConfigDirectory+"romlists/" + romlistid + ".txt")
				local listfile = ReadTextFile (listfilepath)
				while (!listfile.eos()){
					local inline = listfile.read_line()
					AF.scrape.romlist_lines.push(inline)
				}

			//AF.boxmessage = messageOLDboxer ("",item+" DONE",false,AF.boxmessage)

		//AF.messageoverlay.visible = false
//		AF.boxmessage = messageboxer (AF.scrape.romlist,"COMPLETED\nPRESS ESC TO RELOAD LAYOUT\n\n",true,AF.boxmessage)
		//AF.scrape.purgedromdirlist = null
}

local dispatcher = []
local dispatchernum = 0

function createjsonA(scrapeid,ssuser,sspass,romfilename,romcrc,romsize,systemid,romtype){
   scraprt("ID"+scrapeid+"-createjsonA"+"\n")
	local unicorrect = unicorrect()

	try {remove (AF.folder + "json/" + scrapeid + "jsonA.nut")} catch(err){}
	try {remove (AF.folder + "json/" + scrapeid + "jsonA.txt")} catch(err){}

	local execss = ""
	if (OS == "Windows"){
		execss =  char_replace(AF.subfolder,"/","\\") + "\\curlscrape2.vbs"+" "+ap+"http://adb.arcadeitalia.net/service_scraper.php?ajax=query_mame&game_name="
		if (romfilename != null) execss += romfilename
		execss += "&use_parent=1"+ap + " " + ap + char_replace(AF.subfolder,"/","\\") + "\\json\\" + scrapeid + "jsonA.nut" + ap + " "+ ap + char_replace(AF.subfolder,"/","\\") + "\\json\\" + scrapeid + "jsonA.txt" + ap
	}
	else {
		execss = "curl -s "+ap+"http://adb.arcadeitalia.net/service_scraper.php?ajax=query_mame&game_name="
		if (romfilename != null) execss += romfilename
		execss += "&use_parent=1"+ap + " -o " + ap + AF.folder + "json/" + scrapeid + "jsonA.nut" + ap + "&& echo ok > " + ap + AF.folder + "json/" + scrapeid + "jsonA.txt" + ap + " &"
	}

	system (execss)
	dispatcher[scrapeid].pollstatusA = true
	suspend()

	local jsarray = []
	local jsfilein = ReadTextFile(fe.path_expand(AF.folder + "json/" + scrapeid + "jsonA.nut"))
	while (!jsfilein.eos()){
		local linein = jsfilein.read_line()
		jsarray.push (linein)
	}

	//TEST104 CONTROLLARE!
	if (!file_exist(AF.folder + "json/" + scrapeid + "jsonA.nut")){
		dispatcher[scrapeid].jsonstatus = "ERROR"
		return
	}

  	if (jsarray[0].slice(0,1) != "{") {
   	echoprint ("Error on file *"+subst_replace(romfilename,"%20"," ")+"*\n")
   	echoprint ("*"+jsarray[0]+"*"+"\n")
		dispatcher[scrapeid].jsonstatus = "ERROR"
		return
	}
   jsarray.push (")")
   jsarray[0] = "return(" + jsarray[0]

   local jsfileout = WriteTextFile(fe.path_expand(AF.folder + "json/" + scrapeid + "jsonA_out.nut"))
   foreach (i,item in jsarray){
      local item_clean = item
      item_clean = uniclean(item_clean)
      foreach (uid, uval in unicorrect){
         item_clean = subst_replace(item_clean,uval.old,uval.new)
      }
      jsfileout.write_line(item_clean+"\n")
   }
	 scraprt("ID"+scrapeid+"-createjsonA scraped\n")
	dispatcher[scrapeid].jsonstatus = "SCRAPED"
   return

}

function createjson(scrapeid,ssuser,sspass,romfilename,romcrc,romsize,systemid,romtype){
   scraprt("ID"+scrapeid+"-createjson"+"\n")
	local unicorrect = unicorrect()

	try {remove (AF.folder + "json/" + scrapeid + "json.nut")} catch(err){}
	try {remove (AF.folder + "json/" + scrapeid + "json.txt")} catch(err){}

	local urlencoder1 = [" ","[","]","{",":","/","?","#","@","!","$","&","'","(",")","*","+",",",";","=" ]
	local urlencoder2 = ["%20","%5B","%5D","%7B","%3A","%2F","%3F","%23","%40","%21","%24","%26","%27","%28","%29","%2A","%2B","%2C","%3B","%3D"]

	foreach (i,item in urlencoder1){
		romfilename = subst_replace (romfilename, urlencoder1[i],urlencoder2[i])
	}

	local execss = ""
	if (OS == "Windows"){
		execss =  char_replace(AF.subfolder,"/","\\") + "\\curlscrape2.vbs"+" "+ap+"https://www.screenscraper.fr/api2/jeuInfos.php?devid=zpaolo11x&devpassword=BFrCcPgtSRc&softname=Arcadeflow&output=json"
		if (ssuser != null) execss += "&ssid="+ssuser
		if (sspass != null) execss += "&sspassword="+sspass
		if (romcrc != null) execss += "&crc="+romcrc
		if (systemid != null) execss += "&systemeid="+systemid
		if (romtype != null) execss += "&romtype="+romtype
		if (romfilename != null) execss += "&romnom="+romfilename
		if (romsize != null) execss += "&romtaille="+romsize
		execss += ap + " " + ap + char_replace(AF.subfolder,"/","\\") + "\\json\\" + scrapeid + "json.nut" + ap + " "+ ap + char_replace(AF.subfolder,"/","\\") + "\\json\\" + scrapeid + "json.txt" + ap
	}
	else {
		execss = "curl -s "+ap+"https://www.screenscraper.fr/api2/jeuInfos.php?devid=zpaolo11x&devpassword=BFrCcPgtSRc&softname=Arcadeflow&output=json"
		if (ssuser != null) execss += "&ssid="+ssuser
		if (sspass != null) execss += "&sspassword="+sspass
		if (romcrc != null) execss += "&crc="+romcrc
		if (systemid != null) execss += "&systemeid="+systemid
		if (romtype != null) execss += "&romtype="+romtype
		if (romfilename != null) execss += "&romnom="+romfilename
		if (romsize != null) execss += "&romtaille="+romsize
		execss += ap + " -o " + ap + AF.folder + "json/" + scrapeid + "json.nut" + ap + "&& echo ok > " + ap + AF.folder + "json/" + scrapeid + "json.txt" + ap + " &"
	}

	system (execss)

	dispatcher[scrapeid].pollstatus = true
	scraprt("ID"+scrapeid+"-createjson suspend\n")
	suspend() //TEST102
	scraprt("ID"+scrapeid+"-createjson resumed\n")

	local jsarray = []
	local jsfilein = ReadTextFile(fe.path_expand(AF.folder + "json/" + scrapeid + "json.nut"))
	while (!jsfilein.eos()){
		local linein = jsfilein.read_line()
		jsarray.push (linein)
		if(jsarray[(jsarray.len()-1)][0].tochar() == "<") {
			dispatcher[scrapeid].jsonstatus = "ERROR"
			return
		}
	}

	if (!file_exist(AF.folder + "json/" + scrapeid + "json.nut")){
		dispatcher[scrapeid].jsonstatus = "ERROR"
		return
	}

  	if (jsarray[0].slice(0,1) != "{") {
   	echoprint ("Error on file *"+subst_replace(romfilename,"%20"," ")+"*\n")
   	echoprint ("*"+jsarray[0]+"*"+"\n")
		dispatcher[scrapeid].jsonstatus = "ERROR"
		if (jsarray[0] == "The maximum threads is already used  ") {
			echoprint("RETRY\n")
			AF.scrape.purgedromdirlist.insert(0,dispatcher[scrapeid].rominputitem)
			//dispatchernum ++
			dispatcher[scrapeid].jsonstatus = "RETRY"
		}
		return
	}
   jsarray.push (")")
   jsarray[0] = "return(" + jsarray[0]

   local jsfileout = WriteTextFile(fe.path_expand(AF.folder + "json/" + scrapeid + "json_out.nut"))
   foreach (i,item in jsarray){
      local item_clean = item
      item_clean = uniclean(item_clean)
      foreach (uid, uval in unicorrect){
         item_clean = subst_replace(item_clean,uval.old,uval.new)
      }
      jsfileout.write_line(item_clean+"\n")
   }
	 scraprt("ID"+scrapeid+"-createjson scraped\n")
	dispatcher[scrapeid].jsonstatus = "SCRAPED"
   return
}


function getromdata(scrapeid, ss_username, ss_password, romname, systemid, systemmedia, isarcade, regionprefs, rompath){
	scraprt("ID"+scrapeid+"-getromdata "+rompath+"\n")

	//TEST104 Start arcade scraping
   if (isarcade){
		dispatcher[scrapeid].createjsonA.call(scrapeid,ss_username,ss_password,strip(split(romname,"(")[0]),null,null,systemid,systemmedia)
		suspend()

		if (dispatcher[scrapeid].jsonstatus != "ERROR"){
   	   dispatcher[scrapeid].gamedata.scrapestatus = "ARCADE"
      	dispatcher[scrapeid].gamedata = parsejsonA (scrapeid, dispatcher[scrapeid].gamedata)
		}

		try {remove (AF.folder + "json/" + scrapeid + "jsonA.txt")} catch(err){}
		try {remove (AF.folder + "json/" + scrapeid + "jsonA.nut")}catch(err){}
		try {remove (AF.folder + "json/" + scrapeid + "jsonA_out.nut")}catch(err){}
	}

	//TEST104 Finished DBA scraping, go on with SS scraping
   dispatcher[scrapeid].gamedata.crc = AF.scrape.inprf.NOCRC ? null : getromcrc_lookup4(rompath)

    scraprt("ID"+scrapeid+"-getromdata call createjson 1\n")
   dispatcher[scrapeid].createjson.call(scrapeid,ss_username,ss_password,strip(split(romname,"(")[0]),AF.scrape.inprf.NOCRC?"":dispatcher[scrapeid].gamedata.crc[0],null,systemid,systemmedia)

	 scraprt("ID"+scrapeid+"-getromdata suspend 1\n")
	suspend() //TEST102
	 scraprt("ID"+scrapeid+"-getromdata resumed\n")
	if ((dispatcher[scrapeid].jsonstatus != "ERROR") && (dispatcher[scrapeid].jsonstatus != "RETRY")) {

      local getcrc = matchrom(scrapeid,romname) //This is the CRC of a rom with matched name
      // Scraped rom has correct CRC, no more scraping needed
      if (!AF.scrape.inprf.NOCRC && (getcrc.rom_crc == dispatcher[scrapeid].gamedata.crc[0] || getcrc.rom_crc == dispatcher[scrapeid].gamedata.crc[1])) {
			dispatcher[scrapeid].gamedata.scrapestatus = "CRC"
         dispatcher[scrapeid].gamedata = parsejson (scrapeid, dispatcher[scrapeid].gamedata)
      }
      else {
         if (getcrc.name_crc == "") dispatcher[scrapeid].gamedata.scrapestatus = "GUESS"
         else dispatcher[scrapeid].gamedata.scrapestatus = "NAME"
         echoprint ("Second check: " + dispatcher[scrapeid].gamedata.scrapestatus + "\n")
         // Once the name is perfectly matched, a new scrape is done to get proper rom status
         dispatcher[scrapeid].jsonstatus = null
		   scraprt("ID"+scrapeid+"-getromdata call createjson 2\n")
			dispatcher[scrapeid].createjson.call(scrapeid,ss_username,ss_password,romname,getcrc.name_crc,null,systemid,systemmedia)
		   scraprt("ID"+scrapeid+"-getromdata suspend 2\n")
			suspend()
		   scraprt("ID"+scrapeid+"-getromdata resumed\n")

			if (dispatcher[scrapeid].jsonstatus != "ERROR"){
            dispatcher[scrapeid].gamedata = parsejson (scrapeid, dispatcher[scrapeid].gamedata)
            echoprint ("Matched NAME "+dispatcher[scrapeid].gamedata.filename+" with " +dispatcher[scrapeid].gamedata.matchedrom+"\n")
         }
      }

      if (dispatcher[scrapeid].gamedata.notgame) dispatcher[scrapeid].gamedata.scrapestatus = "NOGAME"
   }
   else if(dispatcher[scrapeid].jsonstatus == "RETRY"){ //TEST103 CHECK!!!
      echoprint ("RETRY\n")
      dispatcher[scrapeid].gamedata.scrapestatus = "RETRY"
   }
   else if(dispatcher[scrapeid].jsonstatus == "ERROR"){ //TEST103 CHECK!!!
      echoprint ("ERROR\n")
      dispatcher[scrapeid].gamedata.scrapestatus = "ERROR"
   }
   //dispatcher[scrapeid].gamedata = gamedata
   dispatcher[scrapeid].done = true

	try {remove (AF.folder + "json/" + scrapeid + "json.txt")} catch(err){}
	try {remove (AF.folder + "json/" + scrapeid + "json.nut")}catch(err){}
	try {remove (AF.folder + "json/" + scrapeid + "json_out.nut")}catch(err){}
	 scraprt("ID"+scrapeid+"-getromdata return\n")
	return //gamedata
}


function scrapegame2(scrapeid, inputitem, forceskip){
	dispatcher[AF.scrape.dispatchid].rominputitem = inputitem

	local scrapecriteria = AF.scrape.inprf.ROMSCRAPE
	//local gamedata = {}
	local ext = split(inputitem,".").pop() // Get file extension
	try{dispatcher[scrapeid].gamedata.clear()}catch(err){}
	local gd = systemSSname (AF.scrape.emudata.mainsysname)
	local garcade = systemSSarcade (AF.scrape.emudata.mainsysname)
	local gname = inputitem.slice(0,-1*(ext.len()+1))
	local listline = ""

	local scrapethis = true

	if (scrapecriteria == "ALL_ROMS") scrapethis = true
	else if (scrapecriteria == "SKIP_CRC") {
		// Scrape all roms that are not CRC matched
		try {scrapethis = ((AF.scrape.checktable[inputitem].status != "CRC"))}catch(err){}
	}
	else if (scrapecriteria == "SKIP_NAME") {
		// Scrape only roms that have guess name matches
		try {scrapethis = ((AF.scrape.checktable[inputitem].status == "GUESS") || (AF.scrape.checktable[inputitem].status == "ERROR"))}catch(err){}
	}
	else if (scrapecriteria == "MISSING_ROMS") {
		try {scrapethis = ((AF.scrape.checktable[inputitem].status == "ERROR"))}catch(err){}
	}

	// When you are force scraping a single game, scrapethis can't be false
	if (AF.scrape.onegame != "") {
		scrapethis = true
		forceskip = (AF.scrape.onegame != gname)
		dispatcher[scrapeid].skip = forceskip
	}

	dispatcher[scrapeid].gamedata = {
		filename = gname
		matchedrom = ""
		regions = ""

		// SS scrape data
		title = gname
		publisher = ""
		developer = ""
		players = ""
		synopsis = ""
		releasedate = ""
		series = ""
		genre = ""
		rating = ""
		media = {}
		extradata = ""
		scrapestatus = "NONE"
		requests = ""
		regionprefs = AF.scrape.regionprefs

		// SS Arcade scrape data
		isarcade = garcade
		a_rotation = ""
		a_resolution = ""
		a_system = ""
		a_buttons = ""
		a_controls = ""

		// ADB Arcade scrape data
		adb_title = ""
		adb_cloneof = ""
		adb_manufacturer = ""
		adb_genre = ""
		adb_players = ""
		adb_year = ""
		adb_status = ""
		adb_rate = ""
		adb_inputcontrols = ""
		adb_inputbuttons = ""
		adb_buttonscolors = ""
		adb_serie = ""
		adb_screenorientation = ""
		adb_screenresolution = ""
		adb_media = {}
		adb_history = ""

		notgame = true
		crc = null
	}

	if (scrapethis && !forceskip) {
		//TEST102 gamedata = getromdata(AF.scrape.inprf.SS_USERNAME, AF.scrape.inprf.SS_PASSWORD, gname,gd[0],gd[1],garcade,AF.scrape.regionprefs,AF.scrape.emudata.rompath+inputitem)
		dispatcher[scrapeid].getromdata.call(scrapeid,AF.scrape.inprf.SS_USERNAME, AF.scrape.inprf.SS_PASSWORD, gname,gd[0],gd[1],garcade,AF.scrape.regionprefs,AF.scrape.emudata.rompath+inputitem)
	   scraprt("ID"+scrapeid+"-scrapegame2 suspend\n")
		suspend()
	   scraprt("ID"+scrapeid+"-scrapegame2 resume\n")

		local isarcade = dispatcher[scrapeid].gamedata.isarcade
		if ((dispatcher[scrapeid].gamedata.scrapestatus != "NOGAME")  && (dispatcher[scrapeid].gamedata.scrapestatus != "RETRY")){
			if ((dispatcher[scrapeid].gamedata.scrapestatus != "ERROR")){

				listline = gname+";" //Name
				listline += isarcade ? dispatcher[scrapeid].gamedata.adb_title+";" : dispatcher[scrapeid].gamedata.title+(dispatcher[scrapeid].gamedata.extradata!=""?"("+dispatcher[scrapeid].gamedata.extradata+")" : "")+";" //Title with extradata
				listline += AF.scrape.romlist+";" //Emulator
				listline += ";" //Clone
				listline += isarcade ? dispatcher[scrapeid].gamedata.adb_year+";" : dispatcher[scrapeid].gamedata.releasedate+";" //Year
				listline += isarcade ? dispatcher[scrapeid].gamedata.adb_manufacturer+";" : dispatcher[scrapeid].gamedata.publisher+";" //Manufacturer
				listline += isarcade ? dispatcher[scrapeid].gamedata.adb_genre+";" : dispatcher[scrapeid].gamedata.genre+";" //Category
				listline += isarcade ? dispatcher[scrapeid].gamedata.adb_players+";" : dispatcher[scrapeid].gamedata.players+";" //Players
				listline += isarcade ? dispatcher[scrapeid].gamedata.adb_screenorientation+";" : dispatcher[scrapeid].gamedata.a_rotation+";" //Rotation
				listline += isarcade ? dispatcher[scrapeid].gamedata.adb_inputcontrols+";" : dispatcher[scrapeid].gamedata.a_controls+";" //Control
				listline += isarcade ? dispatcher[scrapeid].gamedata.adb_status+";" : ";" //Status
				listline += ";" //DisplayCount
				listline += ";" //DisplayType
				listline += ";" //AltRomname
				listline += ";" //AltTitle
				listline += "‖ "+dispatcher[scrapeid].gamedata.scrapestatus +" ‖ "+ dispatcher[scrapeid].gamedata.synopsis+" ‖ "+(isarcade ? split(dispatcher[scrapeid].gamedata.adb_screenresolution,"p")[0] : dispatcher[scrapeid].gamedata.a_resolution)+" ‖ "+dispatcher[scrapeid].gamedata.a_system+" ‖ " + (isarcade ? dispatcher[scrapeid].gamedata.adb_buttonscolors : "") + " ‖"+";" //Extra
				listline += isarcade ? dispatcher[scrapeid].gamedata.adb_inputbuttons+";" : dispatcher[scrapeid].gamedata.a_buttons+";"
				/*
				if (isarcade) { //Buttons
					if (dispatcher[scrapeid].gamedata.adb_buttonscolors == "") listline += dispatcher[scrapeid].gamedata.a_buttons+";"
					else {
						local enumbuttons = string_enum(dispatcher[scrapeid].gamedata.adb_buttonscolors,"P1_BUTTON")
						listline += enumbuttons == 0 ? ";" : enumbuttons + ";"
					}
				}
				else listline += dispatcher[scrapeid].gamedata.a_buttons+";"
				*/
				listline += isarcade ? dispatcher[scrapeid].gamedata.adb_serie+";" : dispatcher[scrapeid].gamedata.series+";" //Series
				listline += ";" // Language
				listline += isarcade ? ";" : dispatcher[scrapeid].gamedata.regions+";" //Region
				listline += dispatcher[scrapeid].gamedata.rating+";" //Rating
			}
			else {
				try{listline = AF.scrape.checktable[inputitem].line}catch(err){
					listline = gname+";"+gname+";"+AF.scrape.romlist+";;;;;;;;;;;;;"+"‖ "+dispatcher[scrapeid].gamedata.scrapestatus +" ‖ "+ dispatcher[scrapeid].gamedata.scrapestatus+" ‖"+";;;;;;"
				}
			}
			AF.scrape.scrapelist_lines.push (inputitem+"|"+dispatcher[scrapeid].gamedata.scrapestatus+"|"+listline)
		}
	}
	else {
		local tempreason = ""
		try{tempreason = " "+AF.scrape.checktable[inputitem].status}catch(err){}
		//TEST102XXX if (AF.scrape.onegame == "") AF.boxmessage = messageboxer (AF.scrape.romlist+" "+(AF.scrape.totalroms-AF.scrape.purgedromdirlist.len())+"/"+AF.scrape.totalroms+"\n"+textrate((AF.scrape.totalroms-AF.scrape.purgedromdirlist.len()),AF.scrape.totalroms,AF.scrape.columns), patchtext(gname,"(SKIP"+tempreason+")",11,AF.scrape.columns)+"\n",true,AF.boxmessage)
		if (AF.scrape.onegame == "") dispatcher[scrapeid].gamedata.scrapestatus = "SKIP "+strip(tempreason)
		try{
			listline = AF.scrape.checktable[inputitem].line
			AF.scrape.scrapelist_lines.push (inputitem+"|"+AF.scrape.checktable[inputitem].status+"|"+listline)
		}catch(err){
			listline = gname+";"+gname+";"+AF.scrape.romlist+";;;;;;;;;;;;;"+"‖ "+"ERROR" +" ‖ "+ "ERROR"+" ‖"+";;;;;;"
			AF.scrape.scrapelist_lines.push (inputitem+"|"+"ERROR"+"|"+listline)
		}
		dispatcher[scrapeid].skip = true
		dispatcher[scrapeid].done = true
	}
	//AF.scrape.romlist_file.write_line(listline+"\n")

	//scraprt("ID"+scrapeid+"-ENTERING:"+listline+"\n")
	AF.scrape.romlist_lines.push(listline)
	if (dispatcher[scrapeid].gamedata.scrapestatus != "RETRY"){
		try{
			AF.scrape.report[dispatcher[scrapeid].gamedata.scrapestatus].tot ++
			AF.scrape.report[dispatcher[scrapeid].gamedata.scrapestatus].names.push (inputitem)
			AF.scrape.report[dispatcher[scrapeid].gamedata.scrapestatus].matches.push (dispatcher[scrapeid].gamedata.matchedrom)
		}
		catch (err){
			AF.scrape.report[dispatcher[scrapeid].gamedata.scrapestatus] <- {
				tot = 1
				names = [inputitem]
				matches = [dispatcher[scrapeid].gamedata.matchedrom]
			}
		}
	}

	if ((scrapethis && !forceskip) && (dispatcher[scrapeid].gamedata.scrapestatus!="ERROR")){
		debugpr("gamedata.scrapestatus:"+dispatcher[scrapeid].gamedata.scrapestatus+"\n")
		debugpr("gamedata.media table size:"+dispatcher[scrapeid].gamedata.media.len()+"\n")
		foreach (emuartcat, emuartfolder in AF.scrape.emudata.artworktable){

			debugpr("emuartcat:"+emuartcat+" "+emuartfolder+"\n")
			local tempdata = []
			local tempdataA = null
			try{tempdata = dispatcher[scrapeid].gamedata.media[emuartcat]}catch(err){}
			if (dispatcher[scrapeid].gamedata.isarcade) try{tempdataA = dispatcher[scrapeid].gamedata.adb_media[emuartcat]}catch(err){}

			debugpr("gamedata.media[emuartcat] size:"+tempdata.len()+"\n")

			if (tempdataA != null){
				if (tempdataA.url == "") tempdataA = null
			}

			if (tempdataA != null) {
				if ( !(AF.scrape.forcemedia == "NO_MEDIA") && ((AF.scrape.forcemedia == "ALL_MEDIA") || !(file_exist(emuartfolder + "/"+ dispatcher[scrapeid].gamedata.filename +"."+ tempdataA.ext)))) {
					if (OS == "Windows"){
						//TEST104 CORREGGERE
						system (char_replace(AF.subfolder,"/","\\") + "\\curlrunner.vbs " + ap + tempdataA.url + ap + " " + ap + emuartfolder + "\\"+ dispatcher[scrapeid].gamedata.filename +"."+ tempdataA.ext + ap)
					}
					else {
						system ("curl -f --create-dirs -s " + ap + tempdataA.url + ap + " -o " + ap + emuartfolder + "/"+ dispatcher[scrapeid].gamedata.filename +"."+ tempdataA.ext + ap+ (emuartcat == "wheel" ? "": " &"))
					}
				}

				if ((tempdata.len()>0) && (emuartcat == "wheel") && (  !(file_exist(emuartfolder + "/"+ dispatcher[scrapeid].gamedata.filename +"."+ tempdataA.ext))) ){

					if (OS == "Windows"){
						system (char_replace(AF.subfolder,"/","\\") + "\\curlrunner.vbs " + ap + tempdata[0].path + ap + " " + ap + emuartfolder + "\\"+ dispatcher[scrapeid].gamedata.filename +"."+ tempdata[0].extension + ap)
					}
					else {
						system ("curl --create-dirs -s " + ap + tempdata[0].path + ap + " -o " + ap + emuartfolder + "/"+ dispatcher[scrapeid].gamedata.filename +"."+ tempdata[0].extension + ap+" &")
					}
				}

			}
			else if(tempdata.len()>0){
				if ( !(AF.scrape.forcemedia == "NO_MEDIA") && ((AF.scrape.forcemedia == "ALL_MEDIA") || !(file_exist(emuartfolder + "/"+ dispatcher[scrapeid].gamedata.filename +"."+ tempdata[0].extension)))) {
					if (OS == "Windows"){
						system (char_replace(AF.subfolder,"/","\\") + "\\curlrunner.vbs " + ap + tempdata[0].path + ap + " " + ap + emuartfolder + "\\"+ dispatcher[scrapeid].gamedata.filename +"."+ tempdata[0].extension + ap)
					}
					else {
						system ("curl --create-dirs -s " + ap + tempdata[0].path + ap + " -o " + ap + emuartfolder + "/"+ dispatcher[scrapeid].gamedata.filename +"."+ tempdata[0].extension + ap+" &")
					}
				}
			}
		}
	}
}


function scraperomlist2(inprf, forcemedia, onegame){

	AF.scrape.doneroms = 0
	AF.scrape.onegame = onegame
	AF.messageoverlay.visible = true
	AF.scrape.romlist_lines = []

	//AF.boxmessage = array (floor(0.78*(fl.h_os-2.0*AF.messageoverlay.margin)/AF.messageoverlay.char_size),"")
	AF.boxmessage = array (2,"")
	AF.boxmessage = messageboxer ("Scraping...","",true,AF.boxmessage)

	AF.scrape.forcemedia = forcemedia
	AF.scrape.inprf = inprf

	// Sorts and filters regionprefs to create the right regionprefs array
	AF.scrape.regionprefs = []
	foreach (i, item in split(inprf.REGIONPREFS,",")){
		if (item.tointeger() > 0) {
			AF.scrape.regionprefs.push (AF.scrape.regiontable[item.tointeger()-1])
		}
	}

	local romlist = fe.displays[fe.list.display_index].romlist
	AF.scrape.romlist = romlist
	//fe.overlay.splash_message("Scraping\n"+romlist+"\n")

	local emulator_present = (file_exist(fe.path_expand(FeConfigDirectory + "emulators/" + romlist + ".cfg")))

	if (!emulator_present) {
		 // Emulator is not present, the list is a collection romlist
			AF.boxmessage = messageboxer (AF.scrape.romlist,"",true,AF.boxmessage)

			local romlistpath = fe.path_expand(FeConfigDirectory+"romlists/"+romlist+".txt")
			local filein = ReadTextFile(romlistpath)
			local listoflists = {}

			// Build the table of emulators in the romlist
			while (!filein.eos()){
				local inline = filein.read_line()
				local dataline = split(inline,";")
				if ((dataline.len() >=3 ) && (dataline[2]!="@") && (dataline[2]!="Emulator")){
					try {
						listoflists[dataline[2]] <- 1
					}catch (err) {}
				}
			}
			AF.scrape.listoflists = []

			foreach (romlistid, val in listoflists){
				AF.scrape.listoflists.push(romlistid)
			}


	}
	else {
		// Romlist is a single emulator scrapable romlist
		// Read scrape report file and build data table for scraping status
		local checkfile_in = null
		local checkfile_array = []
		local readin = null
		try{checkfile_array = dofile(FeConfigDirectory+"romlists/" + romlist + ".scrape")}
		catch(err){
			checkfile_in = ReadTextFile(FeConfigDirectory+"romlists/" + romlist + ".scrape")
			while (!checkfile_in.eos()){
				readin = checkfile_in.read_line()
				checkfile_array.push (readin)
			}
		}
		AF.scrape.checktable.clear()
		foreach (i, item in checkfile_array){
			local readarray = split(item,"|")
			try{
				AF.scrape.checktable[readarray[0]] <- {
					status = readarray[1]
					line = readarray[2]
				}
			} catch(err) {}
		}

		AF.scrape.scrapelist_lines = []

		AF.boxmessage = messageboxer ("Scraping "+romlist,"",true,AF.boxmessage)

		AF.scrape.emudata = getemulatordata(romlist+".cfg")
		local romdirlist = DirectoryListing (AF.scrape.emudata.rompath,false).results


		AF.scrape.totalroms = 0
		AF.scrape.purgedromdirlist = []
		foreach (id2, item2 in romdirlist){
			local ext = split(item2,".").pop() // Get file extension
			local start = item2.slice(0,2)
			if ((start != "._") && (AF.scrape.emudata.romextarray.find("."+ext)!=null)) { // Check if extension is in the .cfg list
				AF.scrape.totalroms++
				AF.scrape.purgedromdirlist.push(item2)
			}
		}
		AF.scrape.purgedromdirlist.reverse()
	}
}


// Pre parse function that screens the current or all romlists, and calls XMLtoAM
function XMLtoAM2(prefst,current){
	AF.boxmessage = array (6,"")
	AF.boxmessage = messageOLDboxer ("XML import start","",false,AF.boxmessage)

	local dirlist = null
	local romlists = []
	if (!current){ // Build an array of romlist files
		dirlist = DirectoryListing (FeConfigDirectory+"romlists/",false).results
		foreach (item in dirlist){
			if (item.slice(-4) == ".txt"){
				romlists.push(item.slice(0,-4))
			}
		}
	}
	else { // Create a 1 item array with current romlist
		romlists = [fe.displays[fe.list.display_index].romlist]
	}

	// Scan the list of romlists to check what are single emulator romlists and populate the
	// emulator_present array with the emulator .cfg path
	local emulator_present = []
	foreach (id, item in romlists) {
		emulator_present.push (file_exist(fe.path_expand(FeConfigDirectory + "emulators/" + item + ".cfg")))
	}

	AF.boxmessage = messageOLDboxer ("Load standard romlists","",false,AF.boxmessage)

	// First go through all the romlists that have a .cfg file to import XML data
	foreach (id, item in romlists){
		if (emulator_present[id]){
			XMLtoAM(prefst,[item+".cfg"])
		}
	}

	AF.boxmessage = messageOLDboxer ("Load collection romlists","",false,AF.boxmessage)
	// Once the normal romlists are created, create collections
	foreach (id, item in romlists){
		if (!emulator_present[id]){ // Emulator is not present, the list is a collection romlist
			AF.boxmessage = messageOLDboxer ("",item,true,AF.boxmessage)

			local romlistpath = fe.path_expand(FeConfigDirectory+"romlists/"+item+".txt")
			local filein = ReadTextFile(romlistpath)
			local listoflists = {}

			// Build the list of emulators in the romlist
			while (!filein.eos()){
				local inline = filein.read_line()
				local dataline = split(inline,";")
				if ((dataline.len() >=3 ) && (dataline[2]!="@") && (dataline[2]!="Emulator")){
					try {
						listoflists[dataline[2]] <- 1
					}catch (err) {}
				}
			}

			// Copy the romlists in the destination romlist
			local fileout = WriteTextFile (romlistpath)
			foreach (romlistid, val in listoflists){
				local listfilepath = fe.path_expand(FeConfigDirectory+"romlists/" + romlistid + ".txt")
				local listfile = ReadTextFile (listfilepath)
				while (!listfile.eos()){
					local inline = listfile.read_line()
					fileout.write_line(inline+"\n")
				}
			}
			AF.boxmessage = messageOLDboxer ("",item+" DONE",false,AF.boxmessage)

		}
	}
	AF.boxmessage = messageOLDboxer ("Reloading Layout","",false,AF.boxmessage)

}


function XMLtoAM(prefst,dir){
	//AF.boxmessage = messageboxer ("Load romlists","",false,AF.boxmessage)

	// prefst is a preference table used for local update in options menu
	// dir is an array of emulator.cfg files that is used to get the xml extra data
   //local dir = DirectoryListing (FeConfigDirectory+"emulators/",false)

   local xmlpaths = []
   local xmlsysnames = []

	foreach (item in dir){
		if (item.slice(-3) == "cfg"){
			local emudata = getemulatordata(item)
			if (emudata.importextras != ""){
				if (emudata.importextras.slice(-4) == ".xml")  {
					xmlpaths.push (emudata.importextras)
					xmlsysnames.push (item.slice(0,-4))
				}
			}
		}
   }
	//fe.overlay.splash_message (xmlmessage)

   foreach (id, item in xmlpaths){
      local XMLT = {}
		AF.boxmessage = messageOLDboxer ("",xmlsysnames[id],true,AF.boxmessage)

      //fe.overlay.splash_message (xmlmessage)

      XMLT = parseXML (xmlpaths[id])

		if (XMLT == null) {

			AF.boxmessage = messageOLDboxer ("",xmlsysnames[id] + " SKIP",false,AF.boxmessage)
			//fe.overlay.splash_message (xmlmessage)
			continue
		}
		AF.boxmessage = messageOLDboxer ("",xmlsysnames[id] + " DONE",false,AF.boxmessage)
		//fe.overlay.splash_message (xmlmessage)

		//clear scrape data
		//local scrapepath = FeConfigDirectory+"romlists/" + xmlsysnames[id] + ".scrape"
		//try{remove(scrapepath)}catch(err){}

      local romlistpath = FeConfigDirectory+"romlists/" + xmlsysnames[id] + ".txt"
		local rompath = getemulatordata (xmlsysnames[id]+".cfg").rompath

      local romlist_file = WriteTextFile (romlistpath)
		romlist_file.write_line("#Name;Title;Emulator;CloneOf;Year;Manufacturer;Category;Players;Rotation;Control;Status;DisplayCount;DisplayType;AltRomname;AltTitle;Extra;Buttons;Series;Language;Region;Rating\n")
      foreach (id2,item2 in XMLT) {
         local listline = id2+";"
         listline += item2.name+";"
         listline += xmlsysnames[id]+";;"
         listline += (item2.releasedate.len() >= 4 ? item2.releasedate.slice (0,4) : "") +";"
         listline += item2.publisher+";"
         listline += (prefst.USEGENREID ? getgenreid(item2.genreid) : item2.genre)+";"
         listline += item2.players+";"
         listline += ";;;;;;;"
         listline += "‖ XML ‖ "+item2.desc+" ‖;;;;;"
         listline += item2.rating+";"
			if (file_exist(rompath+id2+"."+item2.ext) || !prefst.ONLYAVAILABLE) romlist_file.write_line(listline+"\n")
      }
   }
	//fe.set_display(fe.list.display_index)
}

/// Sort List Backend Functions ///

function modwrap (i,l){
	return (i>=0 ? i%l : (i%l == 0 ? 0 : l + (i%l) ))
}

function z_listprint(array){
	print("\n")
	for (local i = 0 ; i < array.len();i++){
		print(array[i].z_felistindex + " ||| " + array[i].z_title+" ||| " + array[i].z_manufacturer+" ||| " + array[i].z_year+" ||| " + array[i].z_category+"\n")
	}
	print("\n")
}

function z_stopprint(array){
	print("i L 0 1 < >\n")
	for (local i=0;i<array.len();i++){
		print(i+" "+array[i].key + " " + array[i].start + " " + array[i].stop + " " + array[i].prev+" " + array[i].next+"\n")
	}
}


// Define the new list data
local z_list = {
	boot = []

	index = 0
	newindex = 0
	gametable = []
	jumptable = []
	size = 0
	orderby = Info.Title
	reverse = false
	layoutstart = false
	tagstable = {}
	favsarray = []

	rundatetable = {}
	favdatetable = {}
	ratingtable = {}

	allromlists = {}
}

local focusindex = {
	new = 0
	old = 0
}

// Metadata initialisation
local metadata = {
	path = fe.path_expand(FeConfigDirectory+"romlists/"+fe.displays[fe.list.display_index].romlist+".nut")
	ids = [	"z_title",
				"z_year",
				"z_manufacturer",
				"z_category",
				"z_players",
				"z_rotation",
				"z_buttons",
				"z_region",
				"z_rating",
				"z_series"
				"z_arcadesystem"
				]
	names = ["Title",
				"Year",
				"Manufacturer",
				"Category",
				"Players",
				"Rotation",
				"Buttons",
				"Region",
				"Rating",
				"Series",
				"Arcade System"
				]
	sub =   ["string",
				"string",
				"string",
				"string",
				"string",
				"string",//["Horizontal","Vertical","0","90","270","180"],
				"string",//["1","2","3","4","5","6"],
				"string",
				"string",
				"string",
				"string"
				]
}

local meta_edited = {}
local meta_original = {}
try {meta_edited = dofile (metadata.path)}catch(err){}


/*
This is the strategy:

- after boot meta_edited is loaded from file, this is a table that has an entry for each game NAME that
  has custom metadata, and each entry is a table of pairs like "z_year" = 1991
  with the edited value
- meta_original is an emtpy table that will contain the unmodified original values
- z_list.boot creation is changed accordingly: For each entry in the romlist:
  -  z_list.boot entries are created with romlist data
  -  for each item in the meta_edited[game name] table a value is added in the
     meta_original table (for future reference)
  -  z_list.boot is updated with the NEW edited value
- FROM NOW ON z_list.boot carries all the metadata from the romlist + edits, while
  meta_original carries the original (scraped, romlist) metadata
- Each time the edit metadata menu is accessed meta_edited is changed following the user
  choices, and when it's finished the file is saved to disk and the whole list is refreshed
  - after metadata changes this procedure is called
		z_listboot()
		mfz_build(true)
		try{
			mfz_load()
			mfz_populatereverse()
			} catch(err){}
		mfz_apply(true)
*/

function metachanger(gamename, meta_new, metavals, metaflag, result){
	local meta_changed = (meta_new != metavals[result])
	if (meta_changed && (meta_new != "")) {

		if ( metaflag[result]) {
			// Caso 1: il metadato era già stato editato in precedenza
			meta_edited[gamename][metadata.ids[result]] <- meta_new
		}
		else {
			// Caso 2: il metadato era in stato "original" e viene editato per la prima volta
			try { // Aggiungo il dato all'original
				meta_original[gamename][metadata.ids[result]] <- metavals[result]
			}
			catch (err){
				// Se il gioco non è nell'entry aggiungo tutto ex novo
				meta_original[gamename] <- {}
				meta_original[gamename][metadata.ids[result]] <- metavals[result]
			}
			try { // Aggiungo il dato all'edited
				meta_edited[gamename][metadata.ids[result]] <- meta_new
			}
			catch (err){
				// Se il gioco non è nell'entry aggiungo tutto ex novo
				meta_edited[gamename] <- {}
				meta_edited[gamename][metadata.ids[result]] <- meta_new
			}
		}
		metamenu(result)
	}
	if (meta_new == ""){
		meta_edited[gamename].rawdelete(metadata.ids[result])
		metamenu(result)
	}
}

function metamenu(starter){
	local metavals = []
	local metanotes = []
	local metaglyphs = []
	local metaflag = []
	foreach (id, item in metadata.ids){
		metavals.push (z_list.gametable[z_list.index][item])
		try {metavals[id] = meta_original[z_list.gametable[z_list.index].z_name][item]}catch(err){}
		try {metavals[id] = meta_edited[z_list.gametable[z_list.index].z_name][item]}catch(err){}
		metaglyphs.push(0)

		metaflag.push(false)
		try{
			if (meta_edited[z_list.gametable[z_list.index].z_name][item] != "") {
				metaglyphs[id] = 0xe905
				metaflag[id] = true
			}
		}catch(err){}
		metanotes.push (metavals[id])
	}
	zmenudraw (metadata.names,metaglyphs,metanotes, ltxt("Game Metadata",TLNG),0xe906,starter,false,false,false,false,
	function (result){

		local gamename = z_list.gametable[z_list.index].z_name

		if (result != -1) {
			local meta_unedited = ""
			try {meta_unedited = meta_original[gamename][metadata.ids[result]] }catch(err){
				meta_unedited = metavals[result]
			}
			local meta_new = ""
			if (typeof metadata.sub[result] == "string") {
				meta_new = fe.overlay.edit_dialog (metadata.names[result]+" value:\n("+meta_unedited+")",metavals[result])
				metachanger (gamename, meta_new, metavals, metaflag, result)
			}
			else if (typeof metadata.sub[result] == "array"){
				testpr("META_UNEDITED: "+meta_unedited+"\n")
				local current_index = metadata.sub[result].find(meta_unedited)
				zmenudraw(metadata.sub[result],null,null,metadata.names[result]+" value:",0xe906,current_index,false,false,false,false,
				function (result2){
					if (result2 == -1) {
						metamenu (result)
					}
					else {
						meta_new = metadata.sub[result][result2]
						metachanger (gamename, meta_new, metavals, metaflag, result)
					}
				}
				)
			}

		}
		else {
			frosthide()
			zmenuhide()

			local outfile = WriteTextFile (metadata.path)
			outfile.write_line("return({\n")
			foreach (item, val in meta_edited){
				outfile.write_line("   " + ap + item + ap + " : {\n")
				foreach (item2, val2 in val){
					outfile.write_line ("      "+item2+" = "+ap+val2+ap+"\n")
				}
				outfile.write_line("   }\n")
			}
			outfile.write_line("})\n")

			z_listboot()
			buildcategorytable()
			mfz_build(true)
			try{
				mfz_load()
				mfz_populatereverse()
			} catch(err){}
			mfz_apply(true)

			z_listrefreshtiles()
			updatebgsnap (focusindex.new)

		}
		return
	})
}


local logotitle = null
local boxtitle = null

function getcurrentgame(){
	return (z_list.gametable[z_list.index].z_name)
}

function z_list_startorder(){
	z_list.orderby = Info.Title
	z_list.reverse = false

	if (prf.SORTSAVE && prf.ENABLESORT) {
		try {
			z_list.orderby = SORTTABLE[aggregatedisplayfilter()][0]
			z_list.reverse = SORTTABLE[aggregatedisplayfilter()][1]
		}
		catch (err){}
	}

}

// This function scans the romlist looking for all the romlists that are present
// in a "collection" and returns a table of those romlist names

function allromlists(){
	local romlist_table = {}
	for (local i = 0; i < fe.list.size; i++){
		try {
			romlist_table [fe.game_info(Info.Emulator,i)] <- 1
		} catch (err){}
	}
	return romlist_table
}

z_list.allromlists = allromlists() //TEST98

// Proxy function that replicates in z_list.tagstable the tags folder files
// This is created with each mfz_apply() function so from then on, list creation
// uses the data in memory and not from disk

// When a tag is created or deleted, the system updates the files and the
// disk, then mfz_apply() is used to run z_inittagsfromfiles and after that
// listcreate is run

function z_inittagsfromfiles(){
	// Clear the tags table
	z_list.tagstable = {}


	foreach (romlistid, val in z_list.allromlists){
		local tagsarray = []
		local tagsnamesarray = []

		local romdir = (FeConfigDirectory+"romlists/"+romlistid)
		local romdirpresent = (fe.path_test( romdir, PathTest.IsDirectory ))

		// No tags at all are present
		if (!romdirpresent) continue

		// Rom dir is present
		// List all possible tags
		tagsarray = DirectoryListing(romdir,false).results
		if (tagsarray.len() == 0) continue // If there are no tags files, return clear table

		// Scan all to create tags names
		for (local i = 0 ; i < tagsarray.len();i++){
			if (tagsarray[i][0].tochar()!=".") {
				tagsnamesarray.push (tagsarray[i].slice (0,tagsarray[i].len()-4))
			}
		}

		local tempval = null
		// Now scan all the files to populate the tags lists with rom names
		foreach (item in tagsnamesarray){
			local temparray = []
			local filein = ReadTextFile(romdir+"/"+item+".tag")
			while (!filein.eos()){
				tempval = filein.read_line()
				temparray.push(romlistid + " " + tempval)
			}
			if (temparray.len() >=1){
				z_list.tagstable[item] <- temparray
			}
		}

	}
}

function z_initfavsfromfiles(){
	// Clear the favs table
	z_list.favsarray = []

	foreach (romlistid, val in z_list.allromlists){
		local favfile = (FeConfigDirectory+"romlists/"+romlistid+".tag")
		local favfilepresent = (fe.path_test( favfile, PathTest.IsFile ))

		// No favs at all are present
		if (!favfilepresent) continue //TEST98 was break

		local tempval = null
		// Now scan the file to populate the favs list with rom names
		local temparray = []
		local filein = ReadTextFile(favfile)

		while (!filein.eos()){
			tempval = filein.read_line()
			z_list.favsarray.push(romlistid + " " + tempval)
		}
	}
}

function z_initfavdatefromfiles(){
	// Clear the table
	z_list.favdatetable = {}

	foreach (romlistid, val in z_list.allromlists){
		z_list.favdatetable[romlistid] <- {}

		local favdatefile = (FeConfigDirectory+"romlists/"+romlistid+".favdate")

		if (!file_exist(favdatefile)) continue

		local filein = ReadTextFile(favdatefile)
		while (!filein.eos()){
			local templine = filein.read_line()
			local temparray = split(templine,"|")
			if (temparray.len() == 2) {
				z_list.favdatetable[romlistid][temparray[0]] <- temparray[1].tostring()
			}
		}

	}
}

// This function pre-builds the z_rundatetable from the proper file.
function z_initrundatefromfiles(){
	// Clear the table
	z_list.rundatetable = {}

	foreach (romlistid, val in z_list.allromlists){
		z_list.rundatetable[romlistid] <- {}

		local rundatefile = (FeConfigDirectory+"romlists/"+romlistid+".rundate")

		if (!file_exist(rundatefile)) continue

		local filein = ReadTextFile(rundatefile)
		while (!filein.eos()){
			local templine = filein.read_line()
			local temparray = split(templine,"|")
			if (temparray.len() == 2) {
				z_list.rundatetable[romlistid][temparray[0]] <- temparray[1].tostring()
				//z_list.rundatetable[romlistid+" "+temparray[0]] <- temparray[1].tostring()
			}
		}
	}
}

// This function saves the rundate table to file
function z_saverundatetofile(){
	foreach (romlistid, romlisttable in z_list.rundatetable){ //Scan romlists!
		local rundatefile = (FeConfigDirectory+"romlists/"+romlistid+".rundate")

		local fileout = WriteTextFile(rundatefile)
		foreach (item, value in romlisttable){
			fileout.write_line(item+"|"+value+"\n")
		}
	}
}

function z_savefavdatetofile(){

	foreach (romlistid, romlisttable in z_list.favdatetable){ //Scan romlists!

		local favdatefile = (FeConfigDirectory+"romlists/"+romlistid+".favdate")

		local fileout = WriteTextFile(favdatefile)
		foreach (item, value in romlisttable){
			fileout.write_line(item+"|"+value+"\n")
		}
	}
}

// Initialize tags table, favs table, rundate and favdate data.
// These tables are used in the layout instead of standard fav and
// tag properties with the custom fav and tag menu

z_inittagsfromfiles()
z_initfavsfromfiles()
z_initrundatefromfiles()
z_initfavdatefromfiles()

z_list.ratingtable = prf.INI_BESTGAMES_PATH == "" ? {} : extradatatable(prf.INI_BESTGAMES_PATH)


// returns an array of tags for the game at "offset" reading from the list table (faster)
function z_gettags(offset,checkzero){
	if ((checkzero) && (z_list.size == 0)) return []
	local romname = z_list.boot[offset + fe.list.index].z_name
	local emulatorname = z_list.boot[offset + fe.list.index].z_emulator
	local out = []
	// Now check in the whole tags structure
	foreach(item, tagsarray in z_list.tagstable){
		if (tagsarray.find(emulatorname + " " + romname) != null) out.push(item)
	}

	return out
}

// returns favourite state for the game at "offset" reading from the list table (faster)
function z_getfavs(offset){
	local romname = z_list.boot[offset + fe.list.index].z_name
	local emulatorname = z_list.boot[offset + fe.list.index].z_emulator
	// Now check in the whole favs structure
	return ((z_list.favsarray.find(emulatorname + " " + romname) != null) ? "1" : "0")
}

function z_getrundate(offset){
	local out = "00000000000000"

	try {out = z_list.rundatetable[fe.game_info(Info.Emulator,offset)][fe.game_info(Info.Name,offset)]}catch(err){}
	return out
}

function z_getfavdate(offset){
	local out = "00000000000000"
	try {out = z_list.favdatetable[fe.game_info(Info.Emulator,offset)][fe.game_info(Info.Name,offset)]}catch(err){}
	return out
}

function z_getrating(offset){
	local out = ""
	//mame rating
	try {out = fe.game_info(Info.Rating,offset)}catch(err){}

	if (out == "") try {out = ratetonumber[z_list.ratingtable[fe.game_info(Info.Name,offset)]]}catch(err){}
	//xml rating
	//try {out =  (10*split(fe.game_info(Info.Extra,offset),"‖")[0].tofloat())+"/10"}catch(err){}
	//romlist rating
	if ((out.find(".")==null) && (out.len()>0)) out=out+".0"
	return out
}

function z_getscrapestatus(offset){
	local out = "NONE"
	// XML old description
	//try {out = char_replace(char_replace(split (fe.game_info(Info.Extra,offset),"‖")[2],"§",";"),"^","\n\n")}catch(err){}
	try {out = strip(split (fe.game_info(Info.Extra,offset),"‖")[0])}catch(err){}
	return out
}

function z_getdescription(offset){
	local out = fe.game_info(Info.Overview,offset)
	// XML old description
	//try {out = char_replace(char_replace(split (fe.game_info(Info.Extra,offset),"‖")[2],"§",";"),"^","\n\n")}catch(err){}
	try {out = char_replace(char_replace(strip(split (fe.game_info(Info.Extra,offset),"‖")[1]),"§",";"),"^","\n\n")}catch(err){}
	return out
}


function parsecommands(instring){
	local str_array = split(instring,"§")
	local btn_array = []
	foreach (i,item in str_array) {
		local cleanitem = subst_replace(item,"::",": :")
		if ( cleanitem.find("P1_BUTTON") == 0 ) btn_array.push (split(cleanitem,":")[2] == " " ? "" : split(cleanitem,":")[2])
	}
	return btn_array
}

function z_getcommands(offset){
	local out = ""
	try {out = strip(split (fe.game_info(Info.Extra,offset),"‖")[4])}catch(err){}
	return out
}

function z_getresolution(offset){
	local out = ""
	// XML old description
	//try {out = char_replace(char_replace(split (fe.game_info(Info.Extra,offset),"‖")[2],"§",";"),"^","\n\n")}catch(err){}
	try {out = strip(split (fe.game_info(Info.Extra,offset),"‖")[2])}catch(err){}
	return out
}
function z_getarcadesystem(offset){
	local out = ""
	// XML old description
	//try {out = char_replace(char_replace(split (fe.game_info(Info.Extra,offset),"‖")[2],"§",";"),"^","\n\n")}catch(err){}
	try {out = strip(split (fe.game_info(Info.Extra,offset),"‖")[3])}catch(err){}
	return out
}

// This function takes a category text string and parses it to produce an
// array variable like [maincategoryname,subcategoryname], if multiple categories
// are present, maincategoryname is an array.
function parsecategory (categoryname){
	local out = ""
	// Clean up silly name in RetroPie XML
	categoryname = subst_replace (categoryname,"Puzzle-Game","Puzzle")
	categoryname = subst_replace (categoryname,"Whac-A-Mole","Whac A Mole")
	categoryname = subst_replace (categoryname,"Mini-Games","Mini Games")
	categoryname = subst_replace (categoryname,"Tree - Plant","Tree Plant")
	categoryname = subst_replace (categoryname,"Versus Co-op","Versus Co op")
	categoryname = subst_replace (categoryname,"Othello - Reversi","Othello Reversi")
	categoryname = subst_replace (categoryname,"Hot-air Balloon","Hot air Balloon")
	categoryname = subst_replace (categoryname,"Run, Jump & Scrolling","Run Jump & Scrolling")
	if (categoryname == "") categoryname = "Unknown"
	// Split main to subcategory
	local catarray = split (categoryname,"/")
	// There is a main/sub category, so we get rid of all other categories
	if (catarray.len() > 1) {
		catarray[0] = strip(catarray[0])
		catarray[1] = strip(catarray[1])

		local mainarray = split(catarray[0],",-")
		if (mainarray.len() > 1) catarray[0] = strip(mainarray[mainarray.len()-1])
		local subarray = split(catarray[1],",-")
		if (subarray.len() > 1) catarray[1] = strip(subarray[0])

		out = catarray[0]+" / "+catarray[1]
	}
	if (catarray.len() == 1){
		local multiarray = split(catarray[0],",-")
		foreach (i,item in multiarray){
			out = out + strip(item) + (i<multiarray.len()-1 ? "," : "")
		}
	}
	return (out)
}
/*
for (local i = 0 ; i < fe.list.size ; i++){
	print (fe.game_info(Info.Category,i)+"   ")
	local cta = parsecategory (fe.game_info(Info.Category,i))
	print (cta+"\n")
}
*/
/// Multifilter definition ///

/*

multifilterz is a table with 2 entries: l0 and filter.

multifilterz.l0 is a table, each entry is a main category, like:

multifilter.l0["System"] = {
	label = "" // This is the label shown in the menu, it's translated to language
	filtered = false
	translate = false // This refers to the l1 menu, it can be translated or not
	sort = true // Still refers to l1 menu, if sort is true it's sorted by translated value, otherwise by non-translated index
	menu = {} // the menu structure built later
	levcheck = function(index){}
}

levcheck is the function that returns data related to a game like:

	out.l1val = the index value of the game in that category (e.g. "Platform/")
	out.l1name = the index name to use in menus (e.g. "Platform ...")
	out.sub = true if the data needs to be put into a submenu
	out.l2val = null or the same as l1... but for the l2 submenu
	out.l2name = null

This levcheck function is used to build the menus and olso to check the values of filters

multifilterz.filter is a table, for each l0 entry it has an array of filtered values:

multifilterz.filter = {
	"Year" : ["1980", "198x"]
	"Category" : []
	etc
}

mfz_build is a function that builds the menu {} tables inside l0

e.g. for categories, if the game is "Platform/Run Jimp":

menu = {
	"platform..." = { // this is the value shown in menus, eventually translated
		num = 1 // The number of entries with this category
		filtered = false // If the category is currently filtered
		filtervalue = "platform/" <- is the value used for filtering purposes
		submenu = { // if this was a pure level1 entry this will be null
			"run jump" = {
				num = 1
				filtered = false
				filtervalue = "platform/run jump" // Notice that this value is from levcheck and will be checked to filter lists
			}
		}
	}
}


multifilterz = {
	"Year" = {
		num = 1
		label = "Year"
		translate = true
		sort = true
		filtered = true/false
		menu = {
			19?? = {
				num = totale dei giochi nel filtro
				filtered = false
				filtervalue = 19??
				submenu = null (è un level1 puro)
			}
			199x... = {
				num = totale dei giochi nel filtro
				filtered = true/false
				filtervalue = 199x
				submenu = { (è un menu di secondo livello level2)
					1991 = {}
					1992 = {
						num = 2
						filtered = false
						filtervalue = 1992
					}
					1993 = {}
				}
			}
		}
	}
}

once mfz_build has created the structure, you can call menus to change the "filtered" value of your current entry
then mfz_populate is used: it scans through the whole menus and if an entry is "filtered" the proper value is added to the
multifilterz.filter entry.

mfz_populatereverse does the opposite: starting from a multifilterz.filter loaded from disk, it rebuilds
the filtered status of the filter structure (this could be done in mfz_build maybe?)

vediamo come creare il menu category...
lev1check(){
	la categoria contiene "/" o " / "? se si splitto su / e restituisco la prima parte + un flag submenu vero
	altrimenti restituisco tutta la categoria + un flag submenu falso
}
lev2check(){
	restituisco tutta la categoria tipo platform/runjump
}

NOTA: potrei fare una sola funzione levcheck che restituisce una tabella:
{lev1 check value, lev1 name, submenu flag, lev2 name, lev2 check value}

NUOVA routine di popolamento:
prendi il gioco, tira fuori la category, applico levcheck
compongo il menu di primo livello col valore passato e metto il filtervalue,
se submenu flag è vero, passo a comporre anche il menu di secondo livello
con gli stessi dati presi prima

il menu dei valori dev'essere univoco perché poi io testo i valori per level0, ovvero avrò
[1992,1991,199x] e devo sapere che 199x è un level2

se il risultato di levcheck() è un'array allora aggiungo un menu per ogni voce

*/



multifilterz.l0["System"] <- {
		label = ""
		filtered = false
		translate = false
		sort = true
		menu = {}
		levcheck = function(index){
			//local out = {l1val = null, l1array = false, l1name = null, sub = null, l2val = null, l2name = null}

			local v = z_list.boot[index+fe.list.index].z_system
			if (v == "") v = "?"

			return( {
				l1val = v
				l1array = false
				l1name = v
				sub = false
				l2val = null
				l2name = null
			})

//			return (out)
		}
	}

multifilterz.l0["Arcade"] <- {
		label = ""
		filtered = false
		translate = false
		sort = true
		menu = {}
		levcheck = function(index){
			//local out = {l1val = null, l1array = false, l1name = null, sub = null, l2val = null, l2name = null}

			local v = z_list.boot[index+fe.list.index].z_arcadesystem
			if (v == "") v = "?"

			return( {
				l1val = v
				l1array = false
				l1name = v
				sub = false
				l2val = null
				l2name = null
			})

//			return (out)
		}
	}

multifilterz.l0["Tags"] <- {
		label = ""
		filtered = false
		translate = false
		sort = true
		menu = {}
		levcheck = function(index){
			//local out = {l1val = null, l1array = false, l1name = null, sub = null, l2val = null, l2name = null}

			local v = z_gettags(index,false)
			// Return data when no category is selected
			if (v.len()==0) return {l1val = "None", l1array = false, l1name = "None", sub = false, l2val = null, l2name = null}

			return ( {
				l1val = v
				l1array = true
				l1name = v
				sub = false
				l2val = null
				l2name = null
			})

			return (out)
		}
	}

multifilterz.l0["Category"] <- {
		label = ""
		filtered = false
		translate = false
		sort = true
		menu = {}
		levcheck = function(index){
			//local out = {l1val = null, l1array = false,  l1name = null, sub = null, l2val = null, l2name = null}

			local v = z_list.boot[index+fe.list.index].z_category

			// Return data when no category is selected
			if (v == "") return {l1val = "Unknown",l1array = false,  l1name = "Unknown", sub = false, l2val = null, l2name = null}

			local v2 = split (v,"/")
			local v3 = split (v,",")

			if((v2.len() == 1) && (v3.len() > 1)){ //Array of values
				for (local i =0 ; i < v3.len();i++){
					v3[i] = strip (v3[i])
				}
				return ({
					l1val = v3
					l1array = true
					l1name = v3
					sub = false
					l2val = null
					l2name = null
				})
			}
			else { // not an array!
				if (v2.len() > 1){ //Cascaded values
					return ({
						l1val = strip(v2[0])+"/"
						l1array = false
						l1name = strip(v2[0])+"..."
						sub = true
						l2val = strip(v2[0])+"/"+strip(v2[1])
						l2name = strip(v2[1])
					})
				}
				else { //Single value
					return ({
						l1val = v
						l1array = false
						l1name = v
						sub = false
						l2val = null
						l2name = null
					})
				}
			}
			return (out)
		}
	}

multifilterz.l0["Year"] <- {
		label = ""
		filtered = false
		translate = false
		sort = true
		menu = {}
		levcheck = function(index){
			//local out = {l1val = null, l1array = false, l1name = null, sub = null, l2val = null, l2name = null}

			local v = z_list.boot[index+fe.list.index].z_year

			// Return data when no category is selected
			if ((v=="") || (v =="0") || (v=="?") || (v=="1")) return {l1val = "Unknown", l1array = false, l1name = "Unknown", sub = false, l2val = null, l2name = null}
			if (v=="[unreleased]") return {l1val = "Unreleased", l1array = false, l1name = "Unreleased", sub = false, l2val = null, l2name = null}
			if (v=="19??") return {l1val = "19??", l1array = false, l1name = "19??", sub = false, l2val = null, l2name = null}
			local v2 = v.slice(0,3) + "x"

			return ({
				l1val = v2
				l1val = v2
				l1array = false
				l1name = v2 +"..."
				sub = true
				l2val = v
				l2name = v
			})
		}
	}

multifilterz.l0["Manufacturer"] <- {
		label = ""
		filtered = false
		menu = {}
		translate = false
		sort = true
		levcheck = function(index){
			//local out = {l1val = null, l1array = false, l1name = null, sub = null, l2val = null, l2name = null}

			local v = z_list.boot[index+fe.list.index].z_manufacturer

			// Return data when no category is selected
			if ((v=="") || (v=="<unknown>")) return {l1val = "?", l1array = false, l1name = "?", sub = false, l2val = null, l2name = null}

			if (v.len() >= 7) {
				if ((v.slice(0,7)=="bootleg") ) return {l1val = "? bootleg", l1array = false, l1name = "? bootleg", sub = false, l2val = null, l2name = null}
			}
			local v2 = v.slice(0,1)

			return ({
				l1val = v2
				l1array = false
				l1name = v2+"..."
				sub = true
				l2val = v
				l2name = v
			})

			return (out)
		}
	}

multifilterz.l0["Favourite"] <- {
		label = ""
		filtered = false
		menu = {}
		translate = true
		sort = false
		levcheck = function(index){
			//local out = {l1val = null, l1array = false, l1name = null, sub = null, l2val = null, l2name = null}

			local v = z_getfavs(index) //fe.game_info(Info.Favourite,index)

			return ({
				l1val = (v == "1" ? "1 - Favourite" : "2 - Not Favourite")
				l1array = false
				l1name = (v == "1" ? "Favourite" : "Not Favourite")
				sub = false
				l2val = null
				l2name = null
			})
			return (out)
		}
	}


multifilterz.l0["Buttons"] <- {
		label = ""
		filtered = false
		menu = {}
		translate = true
		sort = true
		levcheck = function(index){
			//local out = {l1val = null, l1array = false, l1name = null, sub = null, l2val = null, l2name = null}

			local v = z_list.boot[index+fe.list.index].z_buttons
			if (v == "") v = "??"
			if (v.len() == 1) v = " " + v

			return ({
				l1val = v
				l1array = false
				l1name = v
				sub = false
				l2val = null
				l2name = null
			})

			return (out)
		}
	}

multifilterz.l0["Players"] <- {
		label = ""
		filtered = false
		menu = {}
		translate = true
		sort = true
		levcheck = function(index){
			//local out = {l1val = null, l1array = false, l1name = null, sub = null, l2val = null, l2name = null}

			local v = z_list.boot[index+fe.list.index].z_players
			if (v == "") v = " ?"
			if (v.len() == 1) v = " " + v

			return ({
				l1val = v
				l1array = false
				l1name = v
				sub = false
				l2val = null
				l2name = null
			})

			return (out)
		}
	}

multifilterz.l0["Played"] <- {
		label = ""
		filtered = false
		menu = {}
		translate = true
		sort = false
		levcheck = function(index){
			//local out = {l1val = null, l1array = false, l1name = null, sub = null, l2val = null, l2name = null}

			local v = z_list.boot[index+fe.list.index].z_playedcount

			return ({
				l1val = (v == "0" ? "2 - Not Played" : "1 - Played")
				l1array = false
				l1name = (v == "0" ? "Not Played" : "Played")
				sub = false
				l2val = null
				l2name = null
			})

			return (out)
		}
	}

multifilterz.l0["Orientation"] <- {
		label = ""
		filtered = false
		menu = {}
		translate = true
		sort = false
		levcheck = function(index){
			//local out = {l1val = null, l1array = false, l1name = null, sub = null, l2val = null, l2name = null}

			local v = z_list.boot[index+fe.list.index].z_rotation
			local vcheck = ((v == "0") || (v == "180") || (v == "Horizontal") || (v == "horizontal") || (v == ""))

			return ({
				l1val = vcheck ? "1 - Horizontal" : "2 - Vertical"
				l1array = false
				l1name = vcheck ? "Horizontal" : "Vertical"
				sub = false
				l2val = null
				l2name = null
			})

			return (out)
		}
	}

multifilterz.l0["Controls"] <- {
		label = ""
		filtered = false
		menu = {}
		translate = false
		sort = true
		levcheck = function(index){
			//local out = {l1val = null, l1array = false, l1name = null, sub = null, l2val = null, l2name = null}

			local v = z_list.boot[index+fe.list.index].z_control

			if (v == "") return {l1val = "?", l1array = false, l1name = "?", sub = false, l2val = null, l2name = null}

			local v2 = [null]

			local varray = split (v,",")
			if (varray.len() == 1) v2 = varray[0]
			else {
				local outarray = []
				outarray.push (varray[0])
				for (local i =1;i<varray.len();i++){
					if (varray[i] == outarray[0]) break
					outarray.push(varray[i])
				}
				v2 = outarray[0]
				for (local i = 1 ; i < outarray.len() ; i++) {
					v2=v2+","+outarray[i]
				}
			}

			return ({
				l1val = v2
				l1array = false
				l1name = v2
				sub = false
				l2val = null
				l2name = null
			})

			return (out)
		}
	}

multifilterz.l0["Rating"] <- {
		label = ""
		filtered = false
		menu = {}
		translate = false
		sort = false
		levcheck = function(index){
			//local out = {l1val = null, l1array = false, l1name = null, sub = null, l2val = null, l2name = null}

			local v = z_list.boot[index+fe.list.index].z_rating
			if (v == "") v = "??/10"
			local v2 = format ("%05s",v)
			local v3 = v
			//if (v.len() == 1) v = " "+v

			return ({
				l1val = v2
				l1array = false
				l1name = v3
				sub = false
				l2val = null
				l2name = null
			})

			return (out)
		}
	}

multifilterz.l0["Series"] <- {
		label = ""
		filtered = false
		menu = {}
		translate = false
		sort = true
		levcheck = function(index){
			//local out = {l1val = null, l1array = false, l1name = null, sub = null, l2val = null, l2name = null}

			local v = z_list.boot[index+fe.list.index].z_series
			if (v == "") v = " ?? "

			return ({
				l1val = v
				l1array = false
				l1name = v
				sub = false
				l2val = null
				l2name = null
			})

			return (out)
		}
	}

// Add the filter values to the multifilter in a separate table

multifilterz.filter <- {}
foreach (item, table in multifilterz.l0){
	multifilterz.filter[item] <- []
}

savetabletofile(multifilterz.filter,"pref_mf_0.txt")

function mfz_on(){
	foreach (item,table in multifilterz.l0){
		if (multifilterz.filter[item].len() > 0) return true
	}
	return false
}

function mfz_num(){
	local out = 0
	foreach (item,table in multifilterz.l0){
		if (multifilterz.filter[item].len() > 0) out ++
	}
	return out
}

function mfz_build (reset){
	timestart("mfz_build")
	debugpr("mfz_build reset:" + reset+"\n")

	// Reset all menu data
	foreach (item,table in multifilterz.l0){
		if (reset) multifilterz.filter[item] = []
		try{table.menu.clear()}catch(err){print("\nERROR!\n")}
		multifilterz.l0[item].label = ltxt(item,TLNG)
	}

	// Scan the whole romlist
	for (local i = 0 ; i < fe.list.size ; i++) {
		// Scan throught the "items" ("Year", "Category" etc) in the multifilter,
		foreach (id0, table0 in multifilterz.l0){
			local vals = table0.levcheck(i-fe.list.index)

			// Check if level 1 value is an ARRAY!
			if ((vals.l1array)){
				for (local i = 0; i<vals.l1name.len();i++){
					try {
						table0.menu[vals.l1name[i]].num ++
					}
					catch (err){
						table0.menu[vals.l1name[i]] <- {
							num = 1
							filtered = false
							filtervalue = vals.l1val[i]
							submenu = null
						}
					}
				}
			}
			else { // level1 value is not an ARRAY
			// Populate or update level1 menu
				try {
					table0.menu[vals.l1name].num ++
				}
				catch (err){
					table0.menu[vals.l1name] <- {
						num = 1
						filtered = false
						filtervalue = vals.l1val
						submenu = null
					}
				}

				if (vals.sub){ //submenu is present
					// Populate or update level 2 menu
					try {
						table0.menu[vals.l1name].submenu[vals.l2name].num ++
					}
					catch(err){
						if (table0.menu[vals.l1name].submenu == null) table0.menu[vals.l1name].submenu = {}
						table0.menu[vals.l1name].submenu[vals.l2name] <-{
							num = 1
							filtered = false
							filtervalue = vals.l2val
						}
					}
				}
			}
		}
	}
	//mfz_print()
	timestop()
}

// mfz_build (true)

function mfz_print(){
	print("MULTIFILTERMENU\n")
	foreach (item0,table0 in multifilterz.l0){
		print ("\n"+item0+"\n")
		foreach (item1,table1 in multifilterz.l0[item0].menu){
			print ("* "+item1+" "+table1.num+" "+table1.filtered+"\n")
			if (table1.submenu != null){
				foreach (item2,table2 in multifilterz.l0[item0].menu[item1].submenu){
					print ("+- "+ item2+ " "+table2.num+" "+table2.filtered+"\n")
				}
			}
		}
	}
}

function mfz_printfilter(){
	print("MULTIFILTERFILTER\n")
	print(multifilterz.filter+"\n")
	foreach (item0,table0 in multifilterz.filter){
		print ("\n"+item0+"\n")
		foreach (item1 in table0){
			print ("* "+item1+"\n")
		}
	}
}

// Populate the filter fields of the multifilter structure based on selections
function mfz_populate(){
	debugpr("mfz_populate\n")
	foreach (id0, table0 in multifilterz.l0){
		multifilterz.filter[id0] = []
		foreach (id1, table1 in table0.menu){
			if (table1.filtered) multifilterz.filter[id0].push (table1.filtervalue)
			if (table1.submenu != null){
				foreach (id2, table2 in table1.submenu) {
					if (table2.filtered) multifilterz.filter[id0].push (table2.filtervalue)
				}
			}
		}
	}
}

function mfz_populatereverse(){
	timestart("mfz_populatereverse")
	debugpr ("mfz_populatereverse\n")
	foreach (id0, table0 in multifilterz.l0){

		foreach (id1, table1 in table0.menu){
			if (multifilterz.filter[id0].find(table1.filtervalue) != null) {
				table1.filtered = true
			}
			else {table1.filtered = false}

			if (table1.submenu != null){
				foreach (id2, table2 in table1.submenu) {
					if (multifilterz.filter[id0].find(table2.filtervalue) != null) {
						table2.filtered = true
					}
					else {
						table2.filtered = false
					}
					//if (table2.filtered) multifilterz.filter[id0].push (table2.filtervalue)
				}
			}
		}
	}
	timestop()
}

local mf = {
	cat0 = null
	cat1 = null
	cat2 = null
	sel0 = 0
	sel1 = -1
	sel2 = -1
}

local multifilterglyph = null // This is the layout object that turns on when a multifilter is active

function mfz_checkin(index){

	local outOR = false
	local outAND = false
	local vtemp = null

	foreach (id0, table0 in multifilterz.l0){
		outOR = false
		if (multifilterz.filter[id0].len() > 0){
			vtemp = table0.levcheck(index)
			foreach (value in multifilterz.filter[id0]) { //Check every value in OR form
				if (vtemp.l1array){
					for (local i =0;i<vtemp.l1val.len();i++){
						if ((value == vtemp.l1val[i] ) ) {
							outOR = true
							break
						}
					}
				}
				else {
					if ((value == vtemp.l1val ) || (value == vtemp.l2val)) {
						outOR = true
						break
					}
				}
			}
			if (outOR == false){
				return false
			}
		}

	}
	return true
}

function mfz_menudata(inputtable, level, translate, sort){

	// Translate translates names and keep everything sorted by translated name
	// Sort means that menu items are sort by (eventually translated)
	// name value, otherwise they get sorted by filter value (to force sorting)

	local outindex = []
	local outnames = []
	local outglyph = []
	local outnumbr = []

	foreach (item, val in inputtable){
		outindex.push (item)
		outnames.push (item)
		outglyph.push (item)
		outnumbr.push (item)
	}

	// outnames viene tradotto e aggiornato coi totali
	// outglyph viene popolato in base al filtraggio
	// outindex è l'elenco degli indici puri

	if (sort){
		if (translate) {
			// tutti vengono ordinati in base ad outnames tradotto
			outindex.sort(@(a,b) ltxt(a,TLNG).tolower() <=> ltxt(b,TLNG).tolower())
			outnames.sort(@(a,b) ltxt(a,TLNG).tolower() <=> ltxt(b,TLNG).tolower())
			outglyph.sort(@(a,b) ltxt(a,TLNG).tolower() <=> ltxt(b,TLNG).tolower())
			outnumbr.sort(@(a,b) ltxt(a,TLNG).tolower() <=> ltxt(b,TLNG).tolower())
		}
		else {
			// tutti vengono ordinati in base ad outnames NON tradotto
			outindex.sort(@(a,b) a.tolower() <=> b.tolower())
			outnames.sort(@(a,b) a.tolower() <=> b.tolower())
			outglyph.sort(@(a,b) a.tolower() <=> b.tolower())
			outnumbr.sort(@(a,b) a.tolower() <=> b.tolower())
		}
	}
	else {
		// tutti vengono ordinati in base al val, non al name
		outindex.sort(@(a,b) inputtable[a].filtervalue.tolower() <=> inputtable[b].filtervalue.tolower())
		outnames.sort(@(a,b) inputtable[a].filtervalue.tolower() <=> inputtable[b].filtervalue.tolower())
		outglyph.sort(@(a,b) inputtable[a].filtervalue.tolower() <=> inputtable[b].filtervalue.tolower())
		outnumbr.sort(@(a,b) inputtable[a].filtervalue.tolower() <=> inputtable[b].filtervalue.tolower())
	}

	// poi outnames viene effettivamente tradotto e aggiunto il dato esterno
	for (local i=0;i<outindex.len();i++){
		if (translate)
			outnames[i] = ltxt(outnames[i],TLNG)
		else
			outnames[i] = outnames[i]
	}

	for (local i=0;i<outindex.len();i++){
			outnumbr[i] = (level != 0 ? "(" + inputtable[outindex[i]].num +  ")" :"")
	}

	// outglyph viene popolato in base al level
	for (local i=0;i<outindex.len();i++){

		outglyph[i] = (inputtable[outindex[i]].filtered ? 0xea52 : 0)

		if (level == 1){
			if ((outglyph[i] == 0) && (inputtable[outindex[i]].submenu != null)){
				foreach (id, table in inputtable[outindex[i]].submenu){
					if (table.filtered == true) {
						outglyph[i] = 0xea53
						break
					}
				}
			}
		}
		if ((level == 0) && (outglyph[i] == 0)){
			foreach (id1, table1 in inputtable[outindex[i]].menu){
				if (table1.filtered){
					outglyph[i] = 0xea53
					break
				}
				else if (table1.submenu != null) {
					foreach (id2, table2 in table1.submenu){
						if (table2.filtered == true) {
							outglyph[i] = 0xea53
							break
						}
					}
				}
			}
		}
	}

	local out = {}

	if (level == 0){
		local mfzvector = split(prf.MFZVECTOR,",")
		out = {
			index = []
			names = []
			glyph = []
			numbr = []
		}
		for (local i=0;i<outindex.len();i++){
			if (mfzvector[i].tointeger() > 0) {
				out.index.push (outindex[abs(mfzvector[i].tointeger())-1])
				out.names.push (outnames[abs(mfzvector[i].tointeger())-1])
				out.glyph.push (outglyph[abs(mfzvector[i].tointeger())-1])
				out.numbr.push (outnumbr[abs(mfzvector[i].tointeger())-1])
			}
		}
	}
	else{
		out = {
			index = outindex
			names = outnames
			glyph = outglyph
			numbr = outnumbr
		}
	}

	return (out)

}

/*
Come funziona la glyphatura dei filtri? Se ho selezionato esplicitamente
"ALL" da un submenu allora il parent è filtered = true e compare con la spunta "forte"
in caso contrario quando disegno il menu controllo se ci sono sottofiltri e se sono selezionati, se
lo sono in parte allora metto "quadrato vuoto".
*/

function ztestz(){

	local test ={}

	test["Filter"] <- "CIAO"
	print ("------------------TEST--------------------\n")
	foreach(item,val in test){
		print (item+" : "+val+"\n")
	}

}

//ztestz()

function mfz_refreshnum(catin){
	timestart("mfz_refreshnum")
	debugpr("mfz_refreshnum\n")
	//	return
	// Reset menu numbers (not menu values!)
	foreach (id0,table0 in multifilterz.l0) {
		foreach (id1, table1 in table0.menu){
			table1.num = 0
			if (table1.submenu != null){
				foreach (id2,table2 in table1.submenu){
					table2.num = 0
				}
			}
		}
	}

	// Scan the whole romlist
	//for (local i = 0 ; i < fe.list.size ; i++) {

	foreach (i, item in z_list.boot){
		foreach (id0, table0 in multifilterz.l0){

			// Call the function that return the menu entry for the current game
			local vals = table0.levcheck(i - fe.list.index)
			if ((z_list.boot[i].z_inmfz || (id0 == catin)) && (z_list.boot[i].z_insearch) && (z_list.boot[i].z_incat) && (z_list.boot[i].z_inmots2)) {
				if ((vals.l1array)){
					foreach (i2, item2 in vals.l1name){
						table0.menu[item2].num ++
					}
				}
				else { // level1 value is not an ARRAY
					// Populate or update level1 menu
					table0.menu[vals.l1name].num ++
					if (vals.sub){ //submenu is present
						// Populate or update level 2 menu
						table0.menu[vals.l1name].submenu[vals.l2name].num ++
					}
				}
			}

		}
	}
	timestop()
}

function mfz_menu2(presel){
	//2nd level menu is never translated and is always sorted by value

	local valcurrent = multifilterz.l0[mf.cat0].levcheck(z_list.gametable[z_list.index].z_felistindex - fe.list.index)

	local mfzdat = mfz_menudata(multifilterz.l0[mf.cat0].menu[mf.cat1].submenu , 2, false,true)
	local namearray = mfzdat.names
	local indexarray = mfzdat.index
	local filterarray = mfzdat.glyph
	local numberarray = mfzdat.numbr

	namearray.insert(0,ltxt("ALL",TLNG))
	namearray.insert(0,ltxt("CLEAR",TLNG))

	indexarray.insert(0,0)
	indexarray.insert(0,0)

	filterarray.insert(0,multifilterz.l0[mf.cat0].menu[mf.cat1].filtered ? 0xea52 : 0)
	filterarray.insert(0,0xea0f)

	numberarray.insert (0,"")
	numberarray.insert (0,"")

	if ((valcurrent.l1name == mf.cat1) && (presel==0)) presel = indexarray.find(valcurrent.l2name)

	zmenudraw (namearray,filterarray, numberarray,mf.cat1,0xeaed,presel,false,false,false,false,
	function(out){

		if (out == -1) {
			mf.sel2 = 0
			mfz_menu1(mf.sel1)
		}
		else {
			if (out == 0) {
				foreach (item, table in multifilterz.l0[mf.cat0].menu[mf.cat1].submenu){
					table.filtered = false
				}
				multifilterz.l0[mf.cat0].menu[mf.cat1].filtered = false
			}
			else if (out == 1) {
				multifilterz.l0[mf.cat0].menu[mf.cat1].filtered = !(multifilterz.l0[mf.cat0].menu[mf.cat1].filtered)
			}
			else {
				mf.cat2 = indexarray[out]
				mf.sel2 = out
				multifilterz.l0[mf.cat0].menu[mf.cat1].submenu[mf.cat2].filtered = !(multifilterz.l0[mf.cat0].menu[mf.cat1].submenu[mf.cat2].filtered)
			}

			mfz_menu2(out)
			mfz_populate()
			mfz_apply(false) //TEST101
			mfz_save()

		}
	})
}

function mfz_menu1(presel){
	local valcurrent = null

	if (z_list.size > 0) valcurrent = multifilterz.l0[mf.cat0].levcheck(z_list.gametable[z_list.index].z_felistindex - fe.list.index)

	local mfzdat = mfz_menudata(multifilterz.l0[mf.cat0].menu , 1, multifilterz.l0[mf.cat0].translate,multifilterz.l0[mf.cat0].sort)
	local namearray = mfzdat.names
	local indexarray = mfzdat.index
	local filterarray = mfzdat.glyph
	local numberarray = mfzdat.numbr

	namearray.insert(0,ltxt("CLEAR",TLNG))
	indexarray.insert(0,0)
	filterarray.insert(0,0xea0f)
	numberarray.insert (0,"")

	if (valcurrent == null) presel = 0
	else {
		if ((presel == -1) && !(valcurrent.l1array)) presel = indexarray.find(valcurrent.l1name)
		else if (presel == -1) presel = 0
	}

	zmenudraw (namearray,filterarray,numberarray,multifilterz.l0[mf.cat0].label,0xeaed,presel,false,false,false,false,
	function(out){
		if (out == -1) {
			mf.sel1 = -1
			mfz_menu0(mf.sel0)
		}
		else if (out == 0){ //clear or subsequent filters
			foreach (item1, table1 in multifilterz.l0[mf.cat0].menu){
				table1.filtered = false
				if (table1.submenu != null){
					foreach (item2,table2 in table1.submenu) {
						table2.filtered = false
					}
				}
			}
			mfz_menu1(0)
			mfz_populate()
			mfz_apply(false)
//			mfz_refreshnum(null)
			mfz_save()

		}
		else {
			mf.cat1 = indexarray[out]
			mf.sel1 = out

			if (multifilterz.l0[mf.cat0].menu[mf.cat1].submenu == null){ //this is a level1 entry alone
				multifilterz.l0[mf.cat0].menu[mf.cat1].filtered = !(multifilterz.l0[mf.cat0].menu[mf.cat1].filtered)


				mfz_menu1(out)
				mfz_populate()
				mfz_apply(false) //TEST101
//				mfz_refreshnum(null)
				mfz_save()

			}
			else { // this is a multilevel entry
				mfz_menu2(0)
			}


		}
	})
}

function mfz_menu0(presel){
	// Level zero menu is always translated and sorted by value
 	zmenu.mfm = true

	local mfzdat = mfz_menudata(multifilterz.l0 , 0,true,true)
	local namearray = mfzdat.names
	local indexarray = mfzdat.index
	local filterarray = mfzdat.glyph

	namearray.insert(0,ltxt("CLEAR",TLNG))
	indexarray.insert(0,0)
	filterarray.insert(0,0xea0f)

	zmenudraw (namearray,filterarray,null,ltxt("Multifilter",TLNG),0xeaed,presel,false,false,false,false,
	function(out){
		if (out == -1){
			if (!umvisible){
				mfmbghide()
				frosthide()
				zmenuhide()
			}
			else {
				mfmbghide()
				//frostshow()
				utilitymenu(umpresel)
			}
		}
		else if (out == 0) {
			foreach (item0, table0 in multifilterz.l0){
				table0.filtered = false
				foreach (item1, table1 in table0.menu){
					table1.filtered = false
					if (table1.submenu != null){
						foreach (item2,table2 in table1.submenu) {
							table2.filtered = false
						}
					}
				}
			}
			mfz_menu0(0)
			mfz_populate()
			mfz_apply(false)
//			mfz_refreshnum(mf.cat0)
			mfz_save()
		}
		else {
			mf.cat0 = indexarray[out]
			mf.sel0 = out
			mfz_refreshnum(filterarray[out] != 0 ? mf.cat0 : null)
			mfz_menu1(mf.sel1)

		}
	})
}


function mfz_save(){
	debugpr("mfsave\n")
	if (prf.SAVEMFZ) savetabletofile(multifilterz.filter,"pref_mf_"+ aggregatedisplayfilter() +".txt")
}

function mfz_load(){
	local tempresult = loadtablefromfile("pref_mf_"+ aggregatedisplayfilter() +".txt",true)

	if ((tempresult == null) || (!prf.SAVEMFZ)){
		multifilterz.filter = loadtablefromfile("pref_mf_0.txt",true)
	}
	else {
		multifilterz.filter = tempresult
	}
}

function z_list_updategamedata(index){
	// TEST109 CAMBIARE QUI USANDO z_list.boot??
	// In realtà questo è il current, basta evitare casi di lista vuota
	if (z_list.size == 0) return
	dat.manufacturer_array[dat.stacksize - 1].msg = manufacturer_vec_name (z_list.boot[index].z_manufacturer)
	dat.cat_array[dat.stacksize - 1].file_name = category_pic_name (z_list.boot[index].z_category)
	dat.manufacturername_array[dat.stacksize - 1].visible = (dat.manufacturer_array[dat.stacksize - 1].msg == "")
	dat.but_array[dat.stacksize - 1].file_name = ("button_images/" + z_list.boot[index].z_buttons+"button.png")
	dat.ply_array[dat.stacksize - 1].file_name = ("players_images/players_" + z_list.boot[index].z_players+".png")
	dat.ctl_array[dat.stacksize - 1].file_name = (controller_pic (z_list.boot[index].z_control))

	dat.mainctg_array[dat.stacksize - 1].msg = maincategorydispl(index)
	dat.gamename_array[dat.stacksize - 1].msg = gamename2(index)

	dat.gamesubname_array[dat.stacksize - 1].msg = gamesubname(index)
	dat.gameyear_array[dat.stacksize - 1].msg = gameyearstring (index)
	dat.manufacturername_array[dat.stacksize - 1].msg = gamemanufacturer (index)
}

// Applies the multifilter to the romlist updating all the tiles
function mfz_apply(startlist){
	timestart ("mfz_apply")
	local bootlist_index_remap = 0
	local bootlist_index_old = 0
	try {bootlist_index_old = z_list.gametable[z_list.index].z_felistindex}catch(err){}
	local reindex = null // This is the new index of the new z_list
	local z_list_index_old = z_list.index
	local listzero = ((z_list.size == 0) || startlist)

	if (listzero){
		foreach (i, item in dat.var_array){
			dat.var_array[i]=0
		}
	}

	// This function defines the bootlist index that is right or left of current z_list entry
	if (!listzero) {
		debugpr("ZLI:"+z_list.index +" ZLNI:"+z_list.newindex+ " FLI:"+fe.list.index)
		if (z_list.index < z_list.size - 1)
			try{bootlist_index_remap = z_list.gametable[z_list.index + 1].z_felistindex}catch(err){}
		else
			try{bootlist_index_remap = z_list.gametable[z_list.index - 1].z_felistindex}catch(err){}
	}

	debugpr("mfz_apply\n")
	// Create z_list
	z_listcreate()
	if (prf.ENABLESORT) z_list_startorder()
	z_list.layoutstart = false
	if (prf.ENABLESORT) z_listsort(z_list.orderby,z_list.reverse)

	if (!listzero){
		// If the old game index is still inside the list, and if the felistindex is the same as the old one...
		if ((z_list_index_old < z_list.size) && (z_list.gametable[z_list_index_old].z_felistindex == bootlist_index_old)) {
			reindex = z_list_index_old // ... then we assign reindex the old z_list index value
		}
		else {
			//TEST109 Serve davvero questo sotto? Dovrebbe servire perché se filtro e
			// il gioco attuale non è nel filtro, ma lo è quello a fianco,
			// allora seleziona il gioco a fianco....
			for (local i = 0 ; i < z_list.size ; i++){
				if (z_list.gametable[i].z_felistindex == bootlist_index_remap) {
					reindex = i
					break
				}
			}
			for (local i = 0 ; i < z_list.size ; i++){
				if (z_list.gametable[i].z_felistindex == bootlist_index_old) {
					reindex = i
					break
				}
			}
		}
	}

	z_filteredlistupdateindex(reindex)

	z_liststops()

	z_listrefreshlabels()

	if (!startlist) z_listrefreshtiles() //TEST100

	if(z_list.size > 0) z_list_updategamedata(z_list.gametable[z_list.index].z_felistindex)

	z_updatefilternumbers(z_list.index)

	timestop()
}

local searchdata = null

local	search = {
	smart = "" // This is the main search field for smart search
	catg = ["",""] // This is the search field from category menu
	mots2 = ["",""]
	mots2string = [""]
}

function updatesearchdatamsg(){
	local textarray = [""]
	if (search.catg[0] != "") textarray.push( "📁:"+search.catg[0]+(search.catg[1] == "" ? "" : "/"+search.catg[1]) )
	if (search.smart != "")	textarray.push ( "🔍:"+search.smart )
	if (search.mots2string != "")	textarray.push ( "🔎"+search.mots2string )

	local out = textarray[0]

	for (local i = 1 ; i < textarray.len()-1 ; i++){
		out = out + textarray[i] + " - "
	}
	out = out + textarray [textarray.len()-1]
	searchdata.msg = out
}

function z_listsearch(index){
	local searchtext = search.smart.tolower()
	if (searchtext == "") return true

	local checkstr = z_list.boot[index + fe.list.index].z_title.tolower()
	if (checkstr.find(searchtext) != null) return true

	checkstr = z_list.boot[index + fe.list.index].z_manufacturer.tolower()
	if (checkstr.find(searchtext) != null) return true

	checkstr = z_list.boot[index + fe.list.index].z_year.tolower()
	if (checkstr.find(searchtext) != null) return true

	checkstr = z_list.boot[index + fe.list.index].z_category.tolower()
	if (checkstr.find(searchtext) != null) return true

	return false
}

function z_catfilter(index){

	if (search.catg[0] == "") return true

	local nowcat = stripcat(index)

	if ((search.catg[1] == "*") && (search.catg[0] == nowcat[0])) return true
	if ((search.catg[0] == nowcat[0]) && (search.catg[1] == nowcat[1])) return true

	return false

}

function z_mots2filter(index){

	if (search.mots2[0] == "") return true //TEST92 DA VERIFICARE
	local currentval = z_list.boot[index + fe.list.index][search.mots2[0]]

	if (search.mots2[0] == "z_tags"){
		foreach (i, item in currentval){
			if (currentval[i] == search.mots2[1]) return true
		}
		return false
		//return (currentval.find(search.mots2[1]+";") != null)

	}
	else {
		return (currentval.find(search.mots2[1]) == 0)
	}
/*
	local nowcat = stripcat(index)

	if ((search.catg[1] == "*") && (search.catg[0] == nowcat[0])) return true
	if ((search.catg[0] == nowcat[0]) && (search.catg[1] == nowcat[1])) return true
*/
	return false

}

function z_checkhidden(i){
	local tagarray = z_gettags (i,true)
	if (tagarray.len() > 0) return (tagarray.find ("HIDDEN") != null)
}

// create a proxy list, takes a while but should make faster filtering and sorting changes
function z_listboot(){
	timestart ("z_listboot")
	debugpr("z_listboot\n")

	z_list.allromlists = allromlists()

	z_inittagsfromfiles()
	z_initfavsfromfiles()
	z_initrundatefromfiles()
	z_initfavdatefromfiles()


	z_list.boot = []
	for (local i = 0 ; i < fe.list.size; i++){
		local ifeindex = i - fe.list.index

		z_list.boot.push({
			z_name = fe.game_info(Info.Name,ifeindex)
			z_title = fe.game_info(Info.Title,ifeindex)
			//z_emulator = fe.game_info(Info.Emulator,ifeindex)
			//z_cloneof = fe.game_info(Info.CloneOf,ifeindex)
			z_year = fe.game_info(Info.Year,ifeindex)
			z_manufacturer = fe.game_info(Info.Manufacturer,ifeindex)
			z_category = parsecategory(fe.game_info(Info.Category,ifeindex))
			z_players = fe.game_info(Info.Players,ifeindex)
			z_rotation = fe.game_info(Info.Rotation,ifeindex)
			z_control = fe.game_info(Info.Control,ifeindex)
			//z_status = fe.game_info(Info.Status,ifeindex)
			//z_displaycount = fe.game_info(Info.DisplayCount,ifeindex)
			//z_displaytype = fe.game_info(Info.DisplayType,ifeindex)
			//z_altromname = fe.game_info(Info.AltRomname,ifeindex)
			//z_alttitle = fe.game_info(Info.AltTitle,ifeindex)
			//z_extra = fe.game_info(Info.Extra,ifeindex)
			z_favourite = fe.game_info(Info.Favourite,ifeindex) == "1" ? "1" : "0"
			z_tags = split (fe.game_info(Info.Tags,ifeindex), ";") // Loads the tags as array instead of string
			z_playedcount = fe.game_info(Info.PlayedCount,ifeindex)
			//z_playedtime = fe.game_info(Info.PlayedTime,ifeindex)
			z_fileisavailable = fe.game_info(Info.FileIsAvailable,ifeindex)
			z_system = fe.game_info(Info.System,ifeindex)
			z_emulator = fe.game_info(Info.Emulator,ifeindex)
			z_buttons = fe.game_info(Info.Buttons,ifeindex)
			z_region = fe.game_info(Info.Region,ifeindex)

			//z_overview = fe.game_info(Info.Overview,ifeindex)
			//z_ispaused = fe.game_info(Info.IsPaused,ifeindex)
			z_rundate = z_getrundate(ifeindex)
			z_favdate = z_getfavdate(ifeindex)
			z_rating = z_getrating(ifeindex)
			z_series = fe.game_info(Info.Series,ifeindex)
			z_description = z_getdescription(ifeindex)
			z_scrapestatus = z_getscrapestatus(ifeindex)
			z_resolution = z_getresolution(ifeindex)
			z_arcadesystem = z_getarcadesystem(ifeindex)
			z_commands = z_getcommands(ifeindex)
			z_inmfz = true
			z_insearch = true
			z_incat = true
			z_inmots2 = true

		})

		//apply metadata customisation
		//TEST109 THIS MUST BE TRY/CATCHED
		local game_edited = false
		try {game_edited = meta_edited[z_list.boot[i].z_name]!=null}catch(err){}
		if (game_edited) {
			meta_original[z_list.boot[i].z_name] <- {}
			foreach (item, val in meta_edited[z_list.boot[i].z_name]){
				meta_original[z_list.boot[i].z_name][item] <- z_list.boot[i][item]
				z_list.boot[i][item] = val
			}
			/*
			testpr("EDITED\n")
				foreach (item,val in meta_edited){
					testpr (item+" : "+val+"\n")
					foreach (item2,val2 in val){
						testpr ("   " + item2+" : "+val2+"\n")
					}
				}
			testpr("ORIGINAL\n")
				foreach (item,val in meta_original){
					testpr (item+" : "+val+"\n")
					foreach (item2,val2 in val){
						testpr ("   " + item2+" : "+val2+"\n")
					}
				}
				*/
		}

	}
	timestop()
}

// Create the new list from current fe.list
function z_listcreate(){

	debugpr("LIST: Create\n")

	z_list.gametable.clear()
	z_list.jumptable.clear()
	z_list.index = z_list.newindex = fe.list.index

	local ireal = 0
	local ifilter = 0
	z_list.size = 0

	local felist = array(fe.list.size)

	foreach (i, item in z_list.boot){

		local ifeindex = i - fe.list.index
		local checkfilter = true
		if (mfz_on()) checkfilter = mfz_checkin(ifeindex)

		z_list.boot[i].z_inmfz = checkfilter
		z_list.boot[i].z_insearch = z_listsearch(ifeindex)
		z_list.boot[i].z_incat = z_catfilter(ifeindex)
		z_list.boot[i].z_inmots2 = z_mots2filter(ifeindex)

		if ((checkfilter)){
			ifilter++

			if (z_list.boot[i].z_insearch && z_list.boot[i].z_incat && z_list.boot[i].z_inmots2 && (!(z_checkhidden(ifeindex)) || prf.SHOWHIDDEN) ) {
				z_list.jumptable.push (
					{
						index = ireal
						start = 0
						next = 0
						prev = 0
						stop = 0
						key = ""
					}
				)

				ireal ++
				z_list.size = ireal

				z_list.gametable.push(
					{
						z_felistindex = i

						z_name = item.z_name
						z_title = item.z_title
						//z_emulator = fe.game_info(Info.Emulator,ifeindex)
						//z_cloneof = fe.game_info(Info.CloneOf,ifeindex)
						z_year = item.z_year
						z_manufacturer = item.z_manufacturer
						z_category = item.z_category
						z_players = item.z_players
						z_rotation = item.z_rotation
						z_control = item.z_control
						//z_status = fe.game_info(Info.Status,ifeindex)
						//z_displaycount = fe.game_info(Info.DisplayCount,ifeindex)
						//z_displaytype = fe.game_info(Info.DisplayType,ifeindex)
						//z_altromname = fe.game_info(Info.AltRomname,ifeindex)
						//z_alttitle = fe.game_info(Info.AltTitle,ifeindex)
						//z_extra = fe.game_info(Info.Extra,ifeindex)
						z_favourite = z_getfavs (ifeindex)
						z_tags = z_gettags (ifeindex,true) // Loads the tags as array
						z_playedcount = item.z_playedcount
						//z_playedtime = fe.game_info(Info.PlayedTime,ifeindex)
						z_fileisavailable = fe.game_info(Info.FileIsAvailable,ifeindex)
						z_system = item.z_system
						z_emulator = item.z_emulator
						z_buttons = item.z_buttons
						z_region = item.z_region
						//z_overview = fe.game_info(Info.Overview,ifeindex)
						//z_ispaused = fe.game_info(Info.IsPaused,ifeindex)
						z_rundate = z_getrundate(ifeindex)
						z_favdate = z_getfavdate(ifeindex)
						z_rating = item.z_rating
						z_series = item.z_series
						z_description = item.z_description
						z_scrapestatus = item.z_scrapestatus
						z_resolution = item.z_resolution
						z_arcadesystem = item.z_arcadesystem
						z_commands = item.z_commands
					}
				)
			}
		}
	}
	multifilterglyph.visible = mfz_on()
}

// scrap articles from names
function nameclean (s){
	if (prf.STRIPARTICLE){
		if (s.find("The ") == 0) s = s.slice(4,s.len())
		else if (s.find("Vs. The ") == 0) s = s.slice(8,s.len())
		else if (s.find("Vs. ") == 0) s = s.slice(4,s.len())
		else if (s.find("Vs ") == 0) s = s.slice(3,s.len())
	}
	return s
}

function sortclean (s){
	if ((s == "") || (s[0].tochar() == "<")) return "!"
	else if (s.tolower() == "bootleg") return "☠"
	else return s
}

function aggregatedisplayfilter(){
	return ( fe.displays[fe.list.display_index].name + "_" + ( (fe.filters.len() != 0) ? fe.filters[fe.list.filter_index].name : "" ) )
}

// Function to sort the list
function z_listsort(orderby,reverse){
	local blanker = "                                                            "
	if (z_list.size == 0) return

	debugpr ("LIST: Sort\n")
	z_list.orderby = orderby
	z_list.reverse = reverse


	if (orderby == Info.Title)
		//z_list.gametable.sort(@(a,b) nameclean(a.z_title).tolower()+a.z_system.tolower() <=> nameclean(b.z_title).tolower()+b.z_system.tolower())

		z_list.gametable = afsort2(z_list.gametable,
		z_list.gametable.map(function(a){return(nameclean(a.z_title).tolower()+blanker)}),
		z_list.gametable.map(function(a){return("|"+a.z_system.tolower()+blanker)}),
		reverse)

	else if (orderby == Info.Year)
		//z_list.gametable.sort(@(a,b) sortclean(a.z_year).tolower()+nameclean(a.z_title).tolower()+a.z_system.tolower() <=> sortclean(b.z_year).tolower()+nameclean(b.z_title).tolower()+b.z_system.tolower())
		z_list.gametable = afsort2(z_list.gametable,
		z_list.gametable.map(function(a){return( format("%010s",sortclean(a.z_year).tolower()))}),
		z_list.gametable.map(function(a){return( "|"+nameclean(a.z_title).tolower()+blanker+"|"+a.z_system.tolower()+blanker)}),
		reverse)

	else if (orderby == Info.Manufacturer )
		//z_list.gametable.sort(@(a,b) sortclean(a.z_manufacturer).tolower()+nameclean(a.z_title).tolower()+a.z_system.tolower() <=> sortclean(b.z_manufacturer).tolower()+nameclean(b.z_title).tolower()+b.z_system.tolower())
		z_list.gametable = afsort2(z_list.gametable,
		z_list.gametable.map(function(a){return(sortclean(a.z_manufacturer).tolower())}),
		z_list.gametable.map(function(a){return("|"+nameclean(a.z_title).tolower()+blanker+"|"+a.z_system.tolower()+blanker)}),
		reverse)

	else if (orderby == Info.PlayedCount )
		//z_list.gametable.sort(@(a,b) a.z_playedcount.tolower()+nameclean(a.z_title).tolower()+a.z_system.tolower() <=> b.z_playedcount.tolower()+nameclean(b.z_title).tolower()+b.z_system.tolower())
		z_list.gametable = afsort2(z_list.gametable,
		z_list.gametable.map(function(a){return( format("%010s",a.z_playedcount.tolower()))}),
		z_list.gametable.map(function(a){return( "|"+nameclean(a.z_title).tolower()+blanker+"|"+a.z_system.tolower()+blanker)}),
		reverse)

	else if (orderby == Info.Category )
		//z_list.gametable.sort(@(a,b) sortclean(a.z_category).tolower()+nameclean(a.z_title).tolower()+a.z_system.tolower() <=> sortclean(b.z_category).tolower()+nameclean(b.z_title).tolower()+b.z_system.tolower())
		//z_list.gametable = afsort(z_list.gametable, z_list.gametable.map(function(a){return(sortclean(a.z_category).tolower()+nameclean(a.z_title).tolower()+a.z_system.tolower())}))
		z_list.gametable = afsort2(z_list.gametable,
		z_list.gametable.map(function(a){return(sortclean(a.z_category).tolower()+blanker)}),
		z_list.gametable.map(function(a){return("|"+nameclean(a.z_title).tolower()+blanker+"|"+a.z_system.tolower()+blanker)}),
		reverse)

	else if (orderby == Info.Players )
		//z_list.gametable.sort(@(a,b) a.z_players.tolower()+nameclean(a.z_title).tolower()+a.z_system.tolower() <=> b.z_players.tolower()+nameclean(b.z_title).tolower()+b.z_system.tolower())
		z_list.gametable = afsort2(z_list.gametable,
		z_list.gametable.map(function(a){return( a.z_players.tolower())}),
		z_list.gametable.map(function(a){return( "|"+nameclean(a.z_title).tolower()+blanker+"|"+a.z_system.tolower()+blanker)}),
		reverse)

	else if (orderby == Info.System)
		//z_list.gametable.sort(@(a,b) a.z_system.tolower()+nameclean(a.z_title).tolower() <=> b.z_system.tolower()+nameclean(b.z_title).tolower())
		z_list.gametable = afsort2(z_list.gametable,
		z_list.gametable.map(function(a){return(a.z_system.tolower()+blanker)}),
		z_list.gametable.map(function(a){return("|"+nameclean(a.z_title).tolower()+blanker)}),
		reverse)

	else if (orderby == z_info.z_rundate)
		//z_list.gametable.sort(@(a,b) b.z_rundate + nameclean(a.z_title).tolower() <=> a.z_rundate + nameclean(b.z_title).tolower())
		z_list.gametable = afsort2(z_list.gametable,
		z_list.gametable.map(function(a){return(a.z_rundate )}),
		z_list.gametable.map(function(a){return("|"+nameclean(a.z_title).tolower()+blanker)}),
		reverse)

	else if (orderby == z_info.z_favdate)
		//z_list.gametable.sort(@(a,b) b.z_favdate + b.z_favourite + nameclean(a.z_title).tolower() <=> a.z_favdate + a.z_favourite + nameclean(b.z_title).tolower())
		z_list.gametable = afsort2(z_list.gametable,
		z_list.gametable.map(function(a){return(a.z_favdate + a.z_favourite)}),
		z_list.gametable.map(function(a){return("|"+nameclean(a.z_title).tolower()+blanker)}),
		reverse)

	else if (orderby == z_info.z_series) {
		//z_list.gametable.sort(@(a,b) a.z_system.tolower()+nameclean(a.z_title).tolower() <=> b.z_system.tolower()+nameclean(b.z_title).tolower())
		z_list.gametable = afsort2(z_list.gametable,
		z_list.gametable.map(function(a){return(a.z_series.tolower())}),
		z_list.gametable.map(function(a){return(( format("%010s",sortclean(a.z_year).tolower())) + "|"+nameclean(a.z_title).tolower()+blanker + "|"+a.z_system.tolower()+blanker)}),
		reverse)
	}

	else if (orderby == z_info.z_rating) {
		//z_list.gametable.sort(@(a,b) a.z_system.tolower()+nameclean(a.z_title).tolower() <=> b.z_system.tolower()+nameclean(b.z_title).tolower())
		z_list.gametable = afsort2(z_list.gametable,
		z_list.gametable.map(function(a){return(format("%010s",a.z_rating.tolower()))}),
		z_list.gametable.map(function(a){return("|"+nameclean(a.z_title).tolower()+blanker + "|"+a.z_system.tolower()+blanker)}),
		reverse)
	}

	if ((prf.SORTSAVE)){
		SORTTABLE [aggregatedisplayfilter()] <- [orderby,reverse]
		savetabletofile(SORTTABLE,"pref_sortorder.txt")
	}
}

// Creates an array for prev-next jump
function z_liststops(){
	local temp = []

	for (local i = 0 ; i < z_list.size ; i++){

		if ((z_list.orderby == Info.Title)) {
			local s = z_list.gametable[i].z_title
			if (prf.STRIPARTICLE) s = nameclean (s)
			s = s[0].tochar().tolower()
			if ("'1234567890".find (s) != null) s = "#"
			temp.push (s )
		}

		else if (z_list.orderby == Info.Year) {
			local s = z_list.gametable[i].z_year.tolower()
			if ((s != "") && (s.len()>3)) s = s.slice (0,3)+"x"
			else (s = "?")
			temp.push( s)
		}

		else if (z_list.orderby == Info.Manufacturer ) {
			local s = z_list.gametable[i].z_manufacturer
			if (s == "") s = "?"
			else if (s.tolower() == "bootleg") s = "☠"
			else (s = s[0].tochar().tolower())
			if (s=="<") s = "?"
			if ("'1234567890".find (s) != null) s = "#"
			temp.push(s)
		}


		else if (z_list.orderby == Info.PlayedCount ) temp.push( z_list.gametable[i].z_playedcount.tolower())

		else if (z_list.orderby == z_info.z_rundate ){
			local rdate = z_list.gametable[i].z_rundate.tostring()
			if (rdate == "00000000000000") temp.push("?")
			else {
				temp.push( "'"+rdate.slice(2,4)+"/"+rdate.slice(4,6))
			}
		}

		else if (z_list.orderby == z_info.z_favdate ){
			local rdate = z_list.gametable[i].z_favdate.tostring()
			if (rdate == "00000000000000") temp.push("?")
			else {
				temp.push( "'"+rdate.slice(2,4)+"/"+rdate.slice(4,6))
			}
		}

		else if (z_list.orderby == Info.System ) temp.push( z_list.gametable[i].z_system.tolower())

		else if (z_list.orderby == Info.Category ) {
			local sout = ""
			local s0 = z_list.gametable[i].z_category.tolower()
			if (s0 == "") temp.push("?")
			else {
				local s = split( s0, "/" )
				if ( s.len() > 1 ) {
					sout = strip(s[0]).tolower()
				}
				else sout = strip(s0).tolower()

				temp.push(sout)
			}
		}

		else if (z_list.orderby == Info.Players ) temp.push( z_list.gametable[i].z_players.tolower())

		else if (z_list.orderby == z_info.z_series ) temp.push( z_list.gametable[i].z_series.tolower())

		else if (z_list.orderby == z_info.z_rating ) temp.push( z_list.gametable[i].z_rating.tolower())
	}

	for (local i = 0 ; i < z_list.size ; i++){
		z_list.jumptable[i].key = temp[i]
		if (i == 0) {
			z_list.jumptable[i].start = 0
			z_list.jumptable[z_list.size-1-i].stop = z_list.size -1
		}
		else {
			if (temp[i] == temp[i-1]) z_list.jumptable[i].start = z_list.jumptable[i-1].start
			else {
				z_list.jumptable[i].start = i
			}
			if (temp[z_list.size-1-i] == temp[z_list.size-i]) z_list.jumptable[z_list.size-1-i].stop = z_list.jumptable[z_list.size-i].stop
			else{
				z_list.jumptable[z_list.size-1-i].stop = z_list.size-1-i
			}
		}
	}

	for (local i=0;i<z_list.size;i++){
		z_list.jumptable[i].next = (z_list.jumptable[i].stop + 1 )%z_list.size

		if (z_list.jumptable[i].start == 0) {
			z_list.jumptable[i].prev = (z_list.jumptable[z_list.jumptable[z_list.size - 1].start ].start )
		}
		else {
			z_list.jumptable[i].prev = z_list.jumptable[i].start -1 -( z_list.jumptable[z_list.jumptable[i].start -1].stop - z_list.jumptable[z_list.jumptable[i].start -1].start)
		}
		//z_list.jumptable[i].prev = modwrap (z_list.jumptable[i].stop - 1 , z_list.size)
	}
}

// Function to re-sync the index when a list has been ordered
function z_liststupdateindex(){
	for (local i = 0 ; i < z_list.size ; i++){
		if (z_list.gametable[i].z_felistindex == fe.list.index) {
			z_list.index = i
			break
		}
	}
}

function z_filteredlistupdateindex(reindex){
	//TEST109 added to cleanup when changing list
	/*
	foreach (i, item in dat.var_array){
		dat.var_array[i] = reindex == null ? 0 : reindex
	}
*/
	if (reindex != null) {
		z_list.newindex = z_list.index = reindex
		fe.list.index = z_list.gametable[reindex].z_felistindex
		return
	}

	if(!mfz_checkin(0) || !z_listsearch(0) || !z_catfilter(0) || (z_checkhidden(0) && !prf.SHOWHIDDEN )){
		z_list.index = 0
		z_list.newindex = 0

		if (z_list.size > 0) fe.list.index = z_list.gametable[0].z_felistindex
	}
	else {
		z_liststupdateindex()
		z_list.newindex = z_list.index
	}
}

// Function to apply a change to the z_list
function z_list_indexchange(newindex){

	z_var = newindex - z_list.index
	z_list.newindex = newindex
	if (z_list.size != 0) fe.list.index = z_list.gametable[modwrap ( (newindex) , z_list.size)].z_felistindex
	z_updatefilternumbers(z_list.newindex)
}


local regsys = {
	LCD = regexp(@"([Pp][Cc]\s*[Ee]ngine\s*[Gg][Tt])|([Vv]ita)|([Dd][Ss])|(3[Dd][Ss])|(PSP\s*Go)|([Gg]ame\s*[Bb]oy)|([Gg]ame\s*[Gg]ear)|([Ll]ynx)|([Tt]urbo\s*[Ee]xpress)|([Gg]amate)|([Ss]upervision)|([Nn]omad)|([Nn]eo\s*[Gg]eo\s*[Pp]ocket)|([Ww]onder\s*[Ss]wan)|([Pp]lay\s*[Ss]tation\s*[Pp]ortable)")
	MONO = regexp(@"([Gg]ame\s*[Bb]oy$)|([Gg]ame\s*[Bb]oy\s*[Pp]ocket$)")
}

function systemSSname (sysname){
	local name = null
	local output = null

	if (sysname == "") return [null,null]
	try { output = [system_data[sysname.tolower()].ss_id,system_data[sysname.tolower()].ss_media]}
	catch (err) {return [null,null]}
	return output
}

function systemSSarcade (sysname){
	local name = null
	local output = null

	if (sysname == "") return (false)
	try {output = system_data[sysname.tolower()].group == "ARCADE"}
	catch (err) {return (false)}
	return output
}

function systemSSindex (index){
	local name = null
	local output = null
	if ( (z_list.size > 0)){
		name = z_list.gametable[index].z_system
		if (name == "") return [null,null]

		name = split(name,";")
		try { output = [system_data[name[0].tolower()].ss_id,system_data[name[0].tolower()].ss_media]}
		catch (err) {return [null,null]}
		return output
	}
	return [null,null]
}

function systemAR (offset,var){
	local name = null
	local output = null
	local hcheck = null
	if ( (z_list.size > 0)){
		name =  z_list.gametable[ modwrap (z_list.index + offset + var, z_list.size) ].z_system
		if (name == "") return 0.0

		name = split(name, ";")
//		if (system_data[name[0].tolower()].h == 0) return 0.0
		try { hcheck = system_data[name[0].tolower()].h == 0 }
		catch(err) {return 0.0}
		if (hcheck == 0) return 0.0
		try { output = system_data[name[0].tolower()].ar }
		catch (err) {return 0.0}
		return output
	}
	return 0.0
}

function screentype (offset,var){
	local name = null
	local output = null
	if ( (z_list.size > 0)){
		name = z_list.gametable[ modwrap (z_list.index + offset + var, z_list.size) ].z_system
		if (name == "") return "CRT"

		name = split(name,";")
		try { output = system_data[name[0].tolower()].screen}
		catch (err) {return "CRT"}
		return output
	}
	return "CRT"
}

function recolorise (offset,var){
	local value = null
	local output = null
	if ( (z_list.size > 0)){
		value = z_list.gametable[ modwrap (z_list.index + offset + var, z_list.size) ].z_system
		if (value == "") return "NONE"

		value = split(value,";")
		try { output = system_data[value[0].tolower()].recolor}
		catch (err) {return "NONE"}
		local isgb = ((output == "LCDGBC") || (output == "LCDGBP") || (output == "LCDGBL"))
		if (isgb) {
			if (prf.GBRECOLOR == "AUTO") return (output) else return (prf.GBRECOLOR)
		}
		return (output)
	}
	return ("NONE")
}

function islcd (offset,var){
	local value = null
	local output = null
	if ( (z_list.size > 0)){
		value = z_list.gametable[ modwrap (z_list.index + offset + var, z_list.size) ].z_system
		if (value == "") return false

		value = split(value,";")
		try { output = system_data[value[0].tolower()].screen}
		catch (err) {return false}
		return (output == "LCD")
	}
	return false
}


function screenrecolor (lcdtype){

	local out = "NONE"

	// CASE 1: It's a gameboy
	local isgb = ((lcdtype == "LCDGBC") || (lcdtype == "LCDGBP") || (lcdtype == "LCDGBL"))
	if (isgb) {
		if (prf.GBRECOLOR == "AUTO") return (lcdtype) else return (prf.GBRECOLOR)
	}

	// CASE 2: It's a recolored system
	local isrecolor = ((lcdtype == "LCDBW") || (lcdtype == "LCDGBA"))
	if (isrecolor){
		return lcdtype
	}

	// CASE 3: It's everything else
	return ("NONE")
}



/// Misc functions ///

// wrap around value witin range 0 - N
function wrap( i, N ) {
	while ( i < 0 ) { i += N }
	while ( i >= N ) { i -= N }
	return i
}

// scale a picture with origin at the center
function picscale (obj,scale){
	obj.width = obj.width * scale
	obj.height = obj.height * scale
	obj.origin_x = obj.width * 0.5
	obj.origin_y = obj.height * 0.5
}

// resize a picture with origin at the center
function picsize (obj,sizex,sizey,offx,offy){
	obj.origin_x = obj.width * 0.5 + offx * obj.width
	obj.origin_y = obj.height * 0.5 + offy * obj.height
	obj.width = sizex
	obj.height = sizey
	obj.origin_x = obj.width * 0.5 + offx * obj.width
	obj.origin_y = obj.height * 0.5 + offy * obj.height
}

function recalculate( str ) {
	if ( str.len() == 0 ) return ""
	str = str.tolower()
	local words = split( str, " " )
	local temp=""
	foreach ( idx, w in words ) {
		//print("searching: " + w )
		//if ( idx > 0 ) temp += " "
		//foreach( c in w )
		// if ( c != " " ) temp += ( "1234567890".find(c.tochar()) != null ) ? c.tochar() : "[" + c.tochar().toupper() + c.tochar().tolower() + "]"
		if ( temp.len() > 0 )
		temp += " "
		local f = w.slice( 0, 1 )
		temp += ( "1234567890".find(f) != null ) ? "[" + f + "]" + w.slice(1) : "[" + f.toupper() + f.tolower() + "]" + w.slice(1)
	}
	return temp
}

// For Magic Token
function zlistentry(offset){
	return z_list.newindex + 1
}

// For Magic Token
function zlistsize(){
	return z_list.size
}

function gamelistorder (offset){
	return ( "◊" + orderdatalabel [z_list.orderby] + (z_list.reverse ? " ▼":" ▲"))
}

//MAGIC TOKEN
function gameyearstring (offset){
	local s0 = z_list.boot[offset].z_year
	if (s0 != ""){
		return ("© " + s0 + "  ")
	}
	else return ("")
}

// MAGIC TOKEN gets the first part of the game name
function gamename1 ( s ) {
	local s1 = split( s, "([" )
	if ( s1.len() > 0 ) {
		return s1[0]
	}
	return ""
}

//MAGIC TOKEN
function gamename2( offset ) {
	local s0 = split(z_list.boot[offset].z_title,"([")
	if (s0.len() > 0) {
		s0 = strip(s0[0])
		local s1 = split( s0, "/" )
		if ( s1.len() > 1 ) {
			return strip(s1[0])+"\n"+strip(s1[1])
		}
		else {
			return s0
		}
	}
	else
		return ""
}

function wrapme(testo , lim_col, lim_row){

	// INITIALIZE OUTPUT VARIABLE
	local out = {
		text = ""
		rows = 0
		cols = 0
	}

	if (testo == "") return (out)

	local col0 = lim_col
	testo = testo.toupper()
	local segmentfind = testo.find (" - ")

	if (segmentfind) testo = testo.slice(0,segmentfind)

	testo = split(testo,"(,")

	if (testo.len() > 0) {
		testo = strip(testo[0])
		testo = split( testo, "/" )
		testo = strip(testo[0])
	}
	else
		testo = ""



	// WORD SPLITTING AND LENGTH
	local textarray = split(testo," ")
	local lenarray = textarray.map(function(value){
		return value.len()
	})

	// CALCULATION OF MAX WORD LENGTH
	local maxword = 0
	for (local i = 0 ; i < textarray.len();i++){
		if (textarray[i].len() > maxword) maxword = textarray[i].len()
	}

	// SIMPLE ROWS CASE
	out.rows = textarray.len() // = 3 (tre righe)
	out.cols = maxword // = 6 (lunghezza di GUNNER)

	for (local i = 0 ; i < lim_row ; i++){
		if (textarray.len() == i+1) {
			out.text = textarray[0]
			for (local ii = 1 ; ii <= i ; ii++){
				out.text = out.text +"\n" + textarray[ii]
			}
			return out
		}
	}

	local coltrick = ceil(testo.len()/(lim_row - 0.2))
	local colsize = (coltrick > col0 ? coltrick : col0)

	if (colsize < maxword) colsize = maxword
	if (colsize > testo.len() ) colsize = testo.len()

	local curline = textarray[0] // è "ZERO"
	local finline = curline // è "ZERO"
	out.text = "" // RESETTA I DATI DI OUT
	out.rows = 0
	out.cols = 0
	local starter = 1

	while ((curline.len() < colsize) && (textarray.len()>1)){
		curline = curline + " " + textarray[starter]
		finline = curline
		starter ++
	}
	if (curline.len() > colsize) colsize = curline.len()

	for (local i = starter ; i < textarray.len() ; i++){

		curline = curline + " " + textarray[i]

		if (curline.len() > colsize){
			out.text = out.text + finline+"\n"
			out.rows ++
			finline = curline = textarray[i]
			if (finline.len() > colsize){
				out.text = out.text + finline.slice (0,colsize)+"\n"
				out.rows ++
				curline = finline = finline.slice (colsize,finline.len())
			}
		}
		else {
			finline = curline
		}
	}

	out.cols = colsize
	out.text = out.text + curline
	out.rows ++

	return out
}

//MAGIC TOKEN
function gamemanufacturer( offset ) {
	local s0 = z_list.boot[offset].z_manufacturer
	local s1 = split( s0, "/" )
	if ( s1.len() > 1 ) {
		return strip(s1[0])+"\n"+strip(s1[1])
	}
	else {
		return s0
	}
}

//MAGIC TOKEN
function gameplaycount( offset ) {
	local s = fe.game_info( Info.PlayedCount, offset )
	if ( s.len() > 0 ) {
		return s[0]
	}
	return ""
}

// MAGIC TOKEN gets the second part of the game name, after the "("
function gamesubname( offset ) {
	local system = split ( z_list.boot[offset].z_system ,";" )

	local arcadesystem = z_list.boot[offset].z_arcadesystem
	if (prf.SHOWARCADENAME && (arcadesystem != "") && (arcadesystem.tolower() != "mame")) system = ["⎔ "+arcadesystem]

	local system2 = ""
	if ( system.len() > 0 ) system2 = system[0]

	local s0 = z_list.boot[offset].z_title


	//local s = split( fe.game_info( Info.Title, offset ), "([" )
	local s = split (s0, "([")
	local s2 = ""
	local s3 = ""

	if (z_list.boot[offset].z_region != "") s3 = s3 + z_list.boot[offset].z_region

	if ((( s.len() > 1 ) || (s3 != "")) && (prf.SHOWSUBNAME)){
		for (local i = 1 ; i<s.len() ; i++){
			s2 = split(s[i],"])")
			s3 = s3 + " " + s2[0]
		}
		return ( ((system2 == "") || (!prf.SHOWSYSNAME)) ? strip(s3) : (prf.SHOWSYSART ?  systemfont(system2,false) : system2) + " - " + strip(s3))
	}
	return ( ((system2 == "") || (!prf.SHOWSYSNAME)) ? "" : (prf.SHOWSYSART ?  systemfont(system2,false) : system2))
}

local categorytable = {}

//grey
categorytable[""] <- ["?"," ",[255,255,255]]//
categorytable["UNKNOWN"] <- ["?"," ",[255,255,255]]//TEST98
categorytable["?"] <- ["?"," ",[255,255,255]]//
categorytable["MULTIPLAY"] <- ["MULTI","MULTI",[255,255,255]]//
categorytable["COMPILATION"] <- ["COMPIL","COMPIL",[255,255,255]]//
categorytable["EDUCATIONAL"] <- ["EDU","EDU",[255,255,255]]//
categorytable["RHYTHM"] <- ["RHTM","RHYTHM",[255,255,255]]//
categorytable["ELECTROMECANICAL"] <- ["ELCT","ELECTR",[255,255,255]]//
categorytable["MISC."] <- ["MISC","MISC",[255,255,255]]//
categorytable["VARIOUS"] <- ["VAR","VAR",[255,255,255]]//
categorytable["MISCELLANEOUS"] <- ["MISC","MISC",[255,255,255]]//
categorytable["QUIZ"] <- ["QUIZ","QUIZ",[255,255,255]]//

//orange yellow
categorytable["ACTION"] <- ["ACTN","ACTION",[255,130,0]]//
categorytable["PLATFORM"] <- ["PLATF","PLATFRM",[255,130,0]]//
categorytable["PLATFORMER"] <- ["PLATF","PLATFRM",[255,130,0]]//

//purple
categorytable["BALL & PADDLE"] <- ["PADDL","PADDLE",[180,50,250]]//

//orange red
categorytable["BEATEMUP"] <- ["BEAT","BEAT",[240,80,0]]//
categorytable["BEAT 'EM UP"] <- ["BEAT","BEAT",[240,80,0]]//
categorytable["FIGHTER"] <- ["FIGHT","FIGHT",[240,80,0]]//
categorytable["FIGHT"] <- ["FIGHT","FIGHT",[240,80,0]]//
categorytable["BEAT'EM UP"] <- ["BEAT","BEAT",[240,80,0]]//

//dark red on darker red
categorytable["DRIVING"] <- ["DRIVE","DRIVE",[200,0,0]]//
categorytable["MOTORCYCLE"] <- ["MCYC","MCYCLE",[200,0,0]]//
categorytable["RACE"] <- ["RACE","RACE",[200,0,0]]//

categorytable["MAZE"] <- ["MAZE","MAZE",[100,200,0]]//

categorytable["PUZZLE"] <- ["PUZZL","PUZZLE",[150,120,200]]

//blue
categorytable["SHOOTEMUP"] <- ["SHOOT","SHOOT",[0,120,250]]//
categorytable["SHOOTER"] <- ["SHOOT","SHOOT",[0,120,250]]//
categorytable["SHOOT 'EM UP"] <- ["SHOOT","SHOOT",[0,120,250]]//
categorytable["FLYING"] <- ["FLY","FLYIN",[0,120,250]]//
categorytable["SHOOT'EM UP"] <- ["SHOOT","SHOOT",[0,120,250]]//

categorytable["SIMULATION"] <- ["SIM","SIMUL",[150,180,200]]//

//yellow
categorytable["ADVENTURE"] <- ["ADVN","ADVNT",[255,180,0]]//
categorytable["ROLE-PLAYING"] <- ["RPG","RPG",[255,180,0]]//
categorytable["ROLE PLAYING GAMES"] <- ["RPG","RPG",[255,180,0]]//

//greygreen
categorytable["STRATEGY"] <- ["STRT","STRAT",[100,200,100]]//

//dark grey
categorytable["BOARDGAMES"] <- ["BOARD","BOARD",[80,80,80]]//
categorytable["BOARD GAME"] <- ["BOARD","BOARD",[80,80,80]]//
categorytable["BOARD GAMES"] <- ["BOARD","BOARD",[80,80,80]]//

//aqua green
categorytable["SPORTS"] <- ["SPORT","SPORT",[0,200,150]]

//muted red
categorytable["WHAC A MOLE"] <- ["WHAC","WHAC-M",[200,100,100]]//

//dark grey
categorytable["CASINO"] <- ["CASINO","CASINO",[80,80,80]]//

//neon green
categorytable["GUN"] <- ["GUN","GUN",[0,250,200]]//

//pure red
categorytable["PINBALL"] <- ["PBALL","PBALL",[255,0,0]]//

function systemlabel(input){
	local sout = input.tolower()
	try {
		return (system_data[sout].label)
	}
	catch (err) {
		return (sout.toupper())
	}
}

function systemfont(input,blank){
	local sout = input.tolower()
	try {
		return ( system_data[sout].logo)
	}
	catch (err) {
		return ((blank ? " " : input))
	}
}

function categorylabel(input,index){
	local sout = input.toupper()
	try {
		return (categorytable[sout][index])
	}
	catch (err) {
		return (sout)
	}
}

function maincategory(offset){
	local sout = ""
	local s0 = parsecategory(z_list.boot[offset].z_category)

	if (s0 == "") return ""

	local s = split( s0, "/" )
	if ( s.len() > 1 ) {
		sout = strip(s[0]).toupper()
	}
	else {
		local s1 = split (s0,",")
		sout = strip(s1[0]).toupper()
	}
	return (sout)
}

//MAGIC TOKEN
function maincategorydispl(offset) {

	local s2 = categorylabel(maincategory(offset),1)

	return (s2)
}

function categorycolor(offset,index){
	//index = 2 or 3 : first or second color
	local sout = ""
	local sout = maincategory(offset) // parsecategory(fe.game_info( Info.Category, offset ))

	if (sout == "") return ([0.5,0.5,0.5])

	sout = sout.toupper()

	try {
		return (categorytable[sout][index])
	}
	catch (err) {
		return ([0.5,0.5,0.5])
	}
}


/// Main layout surface ///

fl.surf = fe.add_surface(fl.w_os,fl.h_os)

// fl.surf.mipmap = 1
// fl.surf.zorder = -1000


/// Controls Overlay Variable Definition ///

local overlay = {
	charsize = null
	rowsize = null
	labelsize = null
	labelcharsize = null
	rows = null
	fullwidth = null
	fullheight = null

	background = null
	listbox = null
	label = null
	sidelabel = null
	glyph = null
	shad = []
	wline = null
	filterbg = null
	ex_top = floor(header.h * 0.6)
	ex_bottom = floor(footer.h * 0.5)
	in_side = vertical ? floor(footer.h * 0.5) : floor(footer.h * 0.65)
	x = 0
	y = 0
	w = 0
	h = 0
}

overlay.charsize = (prf.LOWRES ? floor( 65*scalerate ) : floor( 50*scalerate ))
overlay.rowsize = (prf.LOWRES ? (overlay.charsize*2.5) : (overlay.charsize*3.0))
overlay.labelsize = (overlay.rowsize * 1)
overlay.labelcharsize = overlay.charsize * 1

overlay.fullheight = fl.h - header.h - footer.h - overlay.labelsize + overlay.ex_top + overlay.ex_bottom
overlay.fullwidth = ((overlay.fullheight + overlay.labelsize)*3.0/2.0 < (fl.w - 2 * overlay.in_side) ? (overlay.fullheight + overlay.labelsize)*3.0/2.0 : (fl.w - 2 * overlay.in_side))

overlay.fullheight = floor(overlay.fullheight)
overlay.fullwidth = floor(overlay.fullwidth)

overlay.rows = floor(overlay.fullheight/overlay.rowsize)

if (floor(overlay.rows / 2.0)*2.0 == overlay.rows ) overlay.rows ++


overlay.x = fl.x + 0.5*(fl.w - overlay.fullwidth)
overlay.y = fl.y + header.h - overlay.ex_top
overlay.w = overlay.fullwidth
overlay.h = overlay.fullheight + overlay.labelsize


/// Frosted glass surface ///

local frostpic = {
	size = 64.0 * 0 + 320.0
	w = null
	h = null
	matrix = 0
	sigma = 0
}

frostpic.matrix = floor(frostpic.size*(11.0/64.0))
if (frostpic.matrix % 2.0 == 0) frostpic.matrix ++
frostpic.sigma = frostpic.size*(2.5/64.0)

if (!vertical){
	frostpic.w = frostpic.size
	frostpic.h = frostpic.size * fl.h/fl.w
}
else {
	frostpic.w = frostpic.size * fl.w/fl.h
	frostpic.h = frostpic.size
}

local frost_picT = {
	x = 0,
	y = 0,
	w = frostpic.w,
	h = frostpic.h
}

local frost = {
	surf_1 = null
	surf_2 = null
	pic = null
	surf_rt = null
	top = null
	scaler = null
	picnofrost = null
	mfm = null
}

local flipshader = null
local shader_fr = null

frost.scaler = frostpic.w*1.0/fl.w

frost.surf_rt = fe.add_surface(overlay.w * frost.scaler, overlay.h * frost.scaler)
frost.surf_2 = frost.surf_rt.add_surface(frostpic.w,frostpic.h)
frost.surf_1 = frost.surf_2.add_surface(frostpic.w,frostpic.h)

frost.surf_1.mipmap = 1
frost.pic = frost.surf_1.add_clone(fl.surf)
frost.pic.mipmap = 1
frost.pic.set_pos (frost_picT.x,frost_picT.y,frost_picT.w,frost_picT.h)


shader_fr = {
	v = fe.add_shader( Shader.Fragment, "glsl/gauss_kernsigma_o.glsl" )
	h = fe.add_shader( Shader.Fragment, "glsl/gauss_kernsigma_o.glsl" )
	alpha = fe.add_shader( Shader.Fragment, "glsl/alphafrost.glsl" )
}

shader_fr.v.set_texture_param( "texture")
shader_fr.v.set_param ("kernelData", frostpic.matrix, frostpic.sigma)
shader_fr.v.set_param ("offsetFactor", 0.000,1.0/frostpic.h)

shader_fr.h.set_texture_param( "texture")
shader_fr.h.set_param ("kernelData", frostpic.matrix, frostpic.sigma)
shader_fr.h.set_param ("offsetFactor", 1.0/frostpic.w, 0.000)

frost.surf_2.set_pos(-overlay.x * frost.scaler,-overlay.y*frost.scaler,fl.w_os*frost.scaler,fl.h_os*frost.scaler)

frost.surf_rt.set_pos(overlay.x,overlay.y,overlay.w,overlay.h)

frost.surf_rt.alpha = 0
frost.surf_rt.visible = false

shader_fr.alpha.set_texture_param( "texture",frost.surf_rt)
shader_fr.alpha.set_param ( "alpha",0.0 ) //TEST94 CHECK

frost.surf_rt.shader = shader_fr.alpha
frost.surf_rt.shader = noshader

/// Background image creation ///

local bglay = {
	whitepic = null
	commonground = null
	smallsize = null
	blursize = null
	bgpic = null
	surf_1 = null
	surf_2 = null
	surf_rt = null
	bg_surface = null
	pixelgrid = null
	bgvidsize = null
}

// Needs to be a textured image
bglay.whitepic = fe.add_image("pics/white.png",0,0,1,1)
bglay.whitepic.visible = false

bglay.commonground = fl.surf.add_image("pics/grey.png",0,0,fl.w_os,fl.h_os)
bglay.commonground.zorder = -7

bglay.smallsize = 26
bglay.blursize = 1/26.0

bglay.surf_rt = fl.surf.add_surface(bglay.smallsize,bglay.smallsize)
bglay.surf_2 = bglay.surf_rt.add_surface(bglay.smallsize,bglay.smallsize)
bglay.surf_1 = bglay.surf_2.add_surface(bglay.smallsize,bglay.smallsize)

bglay.bgpic = null

for (local i = 0; i < bgs.stacksize; i++){
	bgs.flowalpha.push ([0.0,0.0,0.0,0.0,0.0])
	bglay.bgpic = bglay.surf_1.add_image("pics/transparent.png",0,0,bglay.smallsize,bglay.smallsize)
	bglay.bgpic.alpha = 255
	bglay.bgpic.trigger = Transition.EndNavigation
	// TEST VA TOLTO DAVVERO?
	//bglay.bgpic.video_flags = Vid.ImagesOnly
	bglay.bgpic.smooth = true
	//bglay.bgpic.mipmap = 1
	bglay.bgpic.preserve_aspect_ratio = false

	bglay.bgpic.shader = colormapper["NONE"].shad //TEST99 cancellare quello prima

	bgs.bgpic_array.push(bglay.bgpic)
	bgs.bg_lcd.push (false)
	bgs.bg_mono.push ("NONE")
	bgs.bg_aspect.push (0.75)
	bgs.bg_box.push ([false,[255,255,255],[0,0,0]])
	bgs.bg_index.push (z_list.index)
}


local shader_bg = {
	h = fe.add_shader (Shader.VertexAndFragment, "glsl/gauss_kern9_v.glsl", "glsl/gauss_kern9_f.glsl")
	v = fe.add_shader (Shader.VertexAndFragment, "glsl/gauss_kern9_v.glsl", "glsl/gauss_kern9_f.glsl")
	bg = fe.add_shader (Shader.Fragment, "glsl/bgdresser.glsl")
}
gaussshader (shader_bg.v, 9.0, 2.2, 0.0, bglay.blursize)
gaussshader (shader_bg.h, 9.0, 2.2, bglay.blursize, 0.0)
shader_bg.bg.set_param ("bgmix",themeT.themeoverlayalpha/255.0)
shader_bg.bg.set_param ("bgcol",themeT.themeoverlaycolor/255.0)

bglay.surf_1.shader = shader_bg.h
bglay.surf_2.shader = shader_bg.v
bglay.surf_rt.shader = shader_bg.bg

bglay.surf_rt.set_pos(bgT.x,bgT.y,bgT.w,bgT.w)

bglay.pixelgrid = null
bglay.bgvidsize = 90.0


function squarebg(){

	for (local i = 0; i < bgs.stacksize ; i++){
		if ((!prf.BOXARTMODE) || ((prf.BOXARTMODE) && (prf.LAYERSNAP))){

			local remapcolor = bgs.bg_mono[i]
			bgs.bgpic_array[i].shader = colormapper[remapcolor].shad
			bgs.bgpic_array[i].set_rgb (255,255,255)

			local aspect = bgs.bg_aspect[i]
			local cropaspect = 1.0

			if (aspect > cropaspect){ // Cut sides
				bgs.bgpic_array[i].subimg_width =  bgs.bgpic_array[i].texture_width * (cropaspect/aspect)
				bgs.bgpic_array[i].subimg_height = bgs.bgpic_array[i].texture_height
				bgs.bgpic_array[i].subimg_x = 0.5 * (bgs.bgpic_array[i].texture_width - bgs.bgpic_array[i].subimg_width)
				bgs.bgpic_array[i].subimg_y =  0.0
			}
			else { // Cut top and bottom
				bgs.bgpic_array[i].subimg_width = bgs.bgpic_array[i].texture_width
				bgs.bgpic_array[i].subimg_height = bgs.bgpic_array[i].texture_height * (aspect/cropaspect)
				bgs.bgpic_array[i].subimg_x = 0.0
				bgs.bgpic_array[i].subimg_y = 0.5*(bgs.bgpic_array[i].texture_height - bgs.bgpic_array[i].subimg_height)
			}
			if (prf.LAYERSNAP){
				local vidaspect = getAR(bgs.bg_index[i]-z_list.index,bgs.bgvid_array[i],0,false)
				if (vidaspect > cropaspect){ // Cut sides
					bgs.bgvid_array[i].subimg_width =  bgs.bgvid_array[i].texture_width * (cropaspect/vidaspect)
					bgs.bgvid_array[i].subimg_height = bgs.bgvid_array[i].texture_height
					bgs.bgvid_array[i].subimg_x = 0.5 * (bgs.bgvid_array[i].texture_width - bgs.bgvid_array[i].subimg_width)
					bgs.bgvid_array[i].subimg_y =  0.0
				}
				else { // Cut top and bottom
					bgs.bgvid_array[i].subimg_width = bgs.bgvid_array[i].texture_width
					bgs.bgvid_array[i].subimg_height = bgs.bgvid_array[i].texture_height * (vidaspect/cropaspect)
					bgs.bgvid_array[i].subimg_x = 0.0
					bgs.bgvid_array[i].subimg_y = 0.5*(bgs.bgvid_array[i].texture_height - bgs.bgvid_array[i].subimg_height)
				}
			}
		}
		else {
			//TEST99 questo si può cambiare inserendo un field nelle bgbox (o nelle tile pure) per dire che filtro usare
			bgs.bgpic_array[i].shader = bgs.bg_box[i][0] ? colormapper["BOXART"].shad : colormapper["NONE"].shad
			bgs.bgpic_array[i].set_rgb (bgs.bg_box[i][1][0],bgs.bg_box[i][1][1],bgs.bg_box[i][1][2])

			// BOXART MODE ON
			if (bgs.bgpic_array[i].texture_width > bgs.bgpic_array[i].texture_height){
				bgs.bgpic_array[i].subimg_width = bgs.bgpic_array[i].texture_height
				bgs.bgpic_array[i].subimg_x = 0.5*(bgs.bgpic_array[i].texture_width - bgs.bgpic_array[i].texture_height)
			}
			else if (bgs.bgpic_array[i].texture_width < bgs.bgpic_array[i].texture_height)
			{
				bgs.bgpic_array[i].subimg_height = bgs.bgpic_array[i].texture_width
				bgs.bgpic_array[i].subimg_y = 0.5*(bgs.bgpic_array[i].texture_height - bgs.bgpic_array[i].texture_width)
			}
		}
	}
}

if (prf.LAYERSNAP){
	bgvidsurf = fl.surf.add_surface(bglay.bgvidsize,bglay.bgvidsize)

	for (local i = 0; i < bgs.stacksize; i++){
		local bgvid = null

		if (!prf.LAYERVIDEO) {
			bgvid = bgvidsurf.add_clone(bgs.bgpic_array[i])
			//bgvid.video_flags = Vid.ImagesOnly
		}
		else if (i == bgs.stacksize - 1 ){
			if (prf.LAYERVIDELAY){
				bgvid = bgvidsurf.add_image("white",0,0,bglay.bgvidsize,bglay.bgvidsize)
				bgvid.video_flags = Vid.NoAudio
				bgvid.alpha = 0
			}
			else {
				bgvid = bgvidsurf.add_artwork("snap",0,0,bglay.bgvidsize,bglay.bgvidsize)
				bgvid.video_flags = Vid.NoAudio
			}
		}
		else{
			bgvid = bgvidsurf.add_clone(bgs.bgpic_array[i])
			bgvid.visible = false
		}

		bgvid.set_pos(0,0,bglay.bgvidsize,bglay.bgvidsize)
		bgvid.preserve_aspect_ratio = false
		bgvid.trigger = Transition.EndNavigation
		bgvid.smooth = true
		bgs.bgvid_array.push(bgvid)
	}

	bgvidsurf.smooth = false

	bgvidsurf.alpha = satin.vid

	bgvidsurf.set_pos(bgT.x,bgT.y,bgT.w,bgT.w)

	bglay.pixelgrid = fl.surf.add_image("grid128x.png",bgT.x,bgT.y,bgT.w,bgT.w*128.0/bglay.bgvidsize)
	bglay.pixelgrid.alpha = 50

	bgvidsurf.zorder = bglay.pixelgrid.zorder = -2
}

local picture = {
	bg = null
	bg_hist = null
	fg = null
}

picture.bg = fl.surf.add_image("pics/transparent.png",0,0,fl.w_os,fl.h_os)
picture.bg.alpha = 255

prf.BGCUSTOM0 <- prf.BGCUSTOM
prf.BGCUSTOMHISTORY0 <- prf.BGCUSTOMHISTORY

bglay.surf_rt.zorder = -6
picture.bg.zorder = -5

/// Display Table Creation ///

// Define new displays array, each item is a table of display data
local z_disp = []

// Initialize table entries
for (local i = 0; i < fe.displays.len(); i++){
	z_disp.push ({
		dispindex = i	// Index of the Display in AM
		dispname = fe.displays[i].name	//Full name of the display as set in AM
		incycle = fe.displays[i].in_cycle	//proxy of in_cycle value
		inmenu = fe.displays[i].in_menu	//proxy of in_menu value
		cleanname = split (fe.displays[i].name,("!#"))[0] //Name of the display cleaned from ! and #
		group = "OTHER" //Display group (console, computer etc)
		ontop = fe.displays[i].name[0].tochar() == "!"	//Is true if the display must be on top (!name)
		notes = ""
		groupnotes = ""
		sortkey = ""
		brand = "ZZZZ"
		year = "9999"
	})
}


// Post process displays data
foreach(i, item in z_disp){

	try {item.brand = system_data[item.cleanname.tolower()].brand}
	catch(err){}

	try {item.year = system_data[item.cleanname.tolower()].year}
	catch(err){}

	if (prf.DMPGENERATELOGO) {
		try {item.cleanname = system_data[item.cleanname.tolower()].sysname}
		catch(err){}
	}

	// Update "sortkey", side notes and separator titles to show when sorting
	switch (prf.DMPSORT){
		case "false" :
			// notes, groupnotes and sortkey are left to ""
		break
		case "display" :
			item.sortkey = (item.ontop ? "!" : "") + item.cleanname.tolower()
			// notes and groupnotes are left to ""
		break
		case "brandname" :
			item.sortkey = (item.ontop ? "!"+ item.cleanname.tolower() : item.brand.tolower() + item.cleanname.tolower())
			item.notes =  prf.DMPSEPARATORS ? "" : (item.brand == "ZZZZ" ? "" : item.brand )
			item.groupnotes = item.brand == "ZZZZ" ? "Other" : item.brand
		break
		case "brandyear" :
			item.sortkey = (item.ontop ? "!" : "") + item.brand.tolower() + item.year + item.cleanname.tolower()
			item.notes = (prf.DMPSEPARATORS ? "" : (item.brand == "ZZZZ" ? "" : item.brand ) + "\n"  ) + (((item.year == "9999") || (item.year == "9998")) ? "" : item.year)
			item.groupnotes =  item.brand == "ZZZZ" ? "Other" : item.brand
		break
		case "year" :
			item.sortkey = (item.ontop ? "!" : "") + item.year + item.cleanname.tolower()
			item.notes =  (item.year == "9998" ? "Unknown" : (item.year == "9999" ? "" : item.year))
			item.groupnotes = (item.year == "9998" ? "Year" : (item.year == "9999" ? "Other" : "Year"))
		break
	}

	// Update "group" value
	try { z_disp[i].group = split (item.dispname,("#"))[1].toupper()}
	catch (err){
		try{z_disp[i].group = system_data[item.cleanname.tolower()].group} catch (err) {}
	}
}


/// Carrier - variables definition ///

local tilez = []

local tilesTablePos = {
	X = []
	Y = []
	Offset = 0
}
local tilesTableUpdate = []
local tilesTableZoom = []
local gr_vidszTableFade = []
local aspectratioMorph = []
local vidpos = []
local vidindex = []

local corrector = 0

local	vidposbg = 0
local vidbgfade=[0.0,0.0,0.0,0.0,0.0]

//TEST96
/*
local fade = {
	letter = 0
	display = 0
	displayzoom = 0
}
*/

/// Carrier - constructor ///

local tiles = {
	count = cols*rows
	offscreen = (vertical ? 3 * rows : 4 * rows)
	total = null
}
tiles.total = tiles.count + 2 * tiles.offscreen

local surfacePosOffset = (tiles.offscreen/rows) * (widthmix + padding)

impulse2.maxoffset = (tiles.offscreen/rows + 1.0) * (widthmix + padding)

local snap_glow = []
local snap_grad = []

local loshz = null
local txshz = null
local txt1z = null
local txt2z = null
local txbox = null

local logosurf_1 = null
local logosurf_rt = null
//local shader_lg = null

local gradsurf_rt = null
local gradsurf_1 = null
local gr_snapz = null
local gr_vidsz = null
local greenshader = {
	vid = null,
	grad = null
}

/// Carrier - tile creation loop ///

local logo = {
	w = null
	h = null
	margin = null
	shw = null
	shh = null
	shscale = null
	shcharsize = null

	txtlinespacing = null
	txtcharspacing = null
	txtfont = null
	txtmargin = null
	txtalign = null
}

logo.w = 240.0
logo.h = 120.0
logo.margin = 20.0
logo.shcharsize = 35.0

logo.shw = logo.w + 2 * logo.margin
logo.shh = logo.h + 2 * logo.margin

logo.shscale = 0.21

logo.txtlinespacing = 0.6
logo.txtcharspacing = 0.7
logo.txtfont = uifonts.arcade
logo.txtmargin = 0
logo.txtalign = Align.MiddleCentre

local gradsizer = 8.0
local gradscaler = 1

local shaders = {
	// Define blur shader for the tile image
	gr = {
		//h = fe.add_shader( Shader.Fragment, "glsl/gauss_kernsigma_o.glsl" )
		//v = fe.add_shader( Shader.Fragment, "glsl/gauss_kernsigma_o.glsl" )
		hv = fe.add_shader( Shader.VertexAndFragment, "glsl/quadrablur_v.glsl", "glsl/quadrablur_f.glsl" )
	}
	// Define blur shader for the logo shadow
	lg = {
		//v = fe.add_shader( Shader.Fragment, "glsl/gauss_kernsigma_o.glsl" )
		//h = fe.add_shader( Shader.Fragment, "glsl/gauss_kernsigma_o.glsl" )
		hv = fe.add_shader( Shader.VertexAndFragment, "glsl/octablur_v.glsl", "glsl/octablur_f.glsl" )
	}

}

shaders.gr.hv.set_texture_param( "texture")
shaders.gr.hv.set_param ("size", gradsizer, gradsizer)
/*
shaders.gr.h.set_texture_param( "texture")
shaders.gr.h.set_param ("kernelData", 5.0, 2.0)
shaders.gr.h.set_param ("offsetFactor", 1.0/gradsizer, 0.0)

shaders.gr.v.set_texture_param( "texture")
shaders.gr.v.set_param ("kernelData", 5.0, 2.0)
shaders.gr.v.set_param ("offsetFactor", 0.0, 1.0/gradsizer)


shaders.lg.v.set_texture_param( "texture")
shaders.lg.v.set_param ("kernelData", 5.0 , 1.75)
shaders.lg.v.set_param ("offsetFactor", 0.0000, 1.0/(logo.shh*logo.shscale))

shaders.lg.h.set_texture_param( "texture")
shaders.lg.h.set_param ("kernelData", 5.0 , 1.75)
shaders.lg.h.set_param ("offsetFactor", 1.0/(logo.shw*logo.shscale), 0.0)
*/
shaders.lg.hv.set_texture_param( "texture")
shaders.lg.hv.set_param ("size", logo.shw*logo.shscale, logo.shh*logo.shscale)



for (local i = 0; i < tiles.total; i++ ) {

	// main tile object
	local obj = fl.surf.add_surface(widthpadded*selectorscale,heightpadded*selectorscale)
	obj.origin_x = obj.width * 0.5
	obj.origin_y = obj.height * 0.5

	obj.zorder = -2

	if (prf.SNAPGRADIENT){

		gradsurf_rt = obj.add_surface (gradsizer, gradsizer)
		gradsurf_1 = gradsurf_rt.add_surface (gradsizer, gradsizer)

		gr_snapz = gradsurf_1.add_image("pics/transparent.png",0,0,gradsizer,gradsizer)
		gr_snapz.preserve_aspect_ratio = false
		gr_snapz.mipmap = 1

		gr_vidsz = gradsurf_1.add_image("pics/transparent.png",0,0,gradsizer,gradsizer)
		gr_vidsz.preserve_aspect_ratio = false
		gr_vidsz.mipmap = 1

		//gr_vidsz.visible = false
		if (!prf.AUDIOVIDSNAPS) gr_vidsz.video_flags = Vid.NoAudio


		gradsurf_1.shader = shaders.gr.hv

		gradsurf_rt.set_pos (gradsizer*gradscaler*i , 0,gradsizer*gradscaler,gradsizer*gradscaler)
		gradsurf_rt.visible = true
	}
	else {
		gr_snapz = obj.add_image("pics/transparent.png",0,0,gradsizer,gradsizer)
		gr_snapz.preserve_aspect_ratio = false
		//gr_snapz.video_flags = Vid.ImagesOnly

		gr_vidsz = obj.add_image("pics/transparent.png",0,0,gradsizer,gradsizer)
		gr_vidsz.preserve_aspect_ratio = false
		gr_vidsz.mipmap = 1

		/*
		greenshader.vid = fe.add_shader (Shader.Fragment, "glsl/colormapper.glsl")
		greenshader.vid.set_texture_param("texture")
		greenshader.vid.set_param ("remap",0.0)
		greenshader.vid.set_param ("lcdcolor",0.0)

		gr_vidsz.shader = greenshader.vid
		*/

		if (!prf.AUDIOVIDSNAPS) gr_vidsz.video_flags = Vid.NoAudio
	}

	local sh_mx = obj.add_image ("sh_1_1_64.png",0,0,widthpadded*selectorscale,heightpadded*selectorscale)
	sh_mx.alpha = prf.LOGOSONLY ? 0 : 230

	local glomx = obj.add_image ("gl_1_1_64.png",0,-selectorscale*verticalshift,widthpadded*selectorscale,selectorscale*heightpadded)
	glomx.alpha = 0

	local bd_mx = obj.add_text ("",selectorscale*padding*(1.0-whitemargin),selectorscale*(-verticalshift + height/8.0 + padding*(1.0 - whitemargin)),selectorscale*(width + padding*2.0*whitemargin),selectorscale*(height*(3/4.0)+padding*2.0*whitemargin))
	bd_mx.set_bg_rgb(255,255,255)
	bd_mx.bg_alpha = 0

	local snapz = obj.add_clone(gr_snapz)
	if(!prf.SNAPGRADIENT) gr_snapz.visible = false
	snapz.preserve_aspect_ratio = false
	snapz.set_pos (selectorscale*padding,selectorscale*(padding-verticalshift),selectorscale*width,selectorscale*height)
	snapz.alpha = prf.LOGOSONLY ? 0 : 255

	local gr_overlay = null

	snap_grad.push(null)
	if (prf.SNAPGRADIENT) {
		gr_overlay = obj.add_image("pics/white.png",gradsurf_rt.width,gradsurf_rt.height)
		gradsurf_rt.visible = false
		gr_overlay.preserve_aspect_ratio = false
		// snapz.video_flags = Vid.ImagesOnly
		gr_overlay.set_pos (selectorscale*padding,selectorscale*(padding-verticalshift),selectorscale*width,selectorscale*height)
		snap_grad[i] = fe.add_shader( Shader.Fragment, "glsl/gradalpha_109.glsl" )
		snap_grad[i].set_texture_param("texturecolor",gradsurf_rt)
		if (prf.LOGOSONLY) //TEST107
			snap_grad[i].set_param ("limits",0.0,0.0)
		else
			snap_grad[i].set_param ("limits",0.25,0.8)
		gr_overlay.shader = snap_grad[i]
		gr_overlay.alpha = prf.LOGOSONLY ? 0 : 255
	}

	txbox = obj.add_text("XXXXXXXXXXXXXXXXXXXXXXXX",selectorscale*padding*10.0/8.0,selectorscale*(padding*0.3 + padding*10.0/8.0-verticalshift),selectorscale*width*44.0/48.0,selectorscale*height*44.0/48.0)
	txbox.char_size = txbox.height/4.0
	txbox.word_wrap = true
	txbox.align = Align.TopCentre
	txbox.font = logo.txtfont
	txbox.margin = 0
	txbox.line_spacing = logo.txtlinespacing
	txbox.char_spacing = logo.txtcharspacing
	txbox.set_rgb (255,255,255)
	//txbox.set_bg_rgb(255,0,0)
	//txbox.bg_alpha = 128

	snap_glow.push (null)

	if (prf.SNAPGLOW){
		snap_glow[i] = fe.add_shader( Shader.Fragment, "glsl/powerglow103.glsl" )
		snap_glow[i].set_texture_param( "texture", (prf.SNAPGRADIENT ? gradsurf_rt : bglay.whitepic) )
		snap_glow[i].set_texture_param( "textureglow",glomx)
		snap_glow[i].set_param( "cycle",prf.HUECYCLE ? 1.0 : 0.0)
		//TEST97 snap_glow[i].set_param ("enabled",true)

		glomx.shader = noshader
	}
	else{
		glomx.visible = false
	}

	local snap_shadow_shape = fe.add_shader( Shader.Fragment, "glsl/shadow.glsl" )
	snap_shadow_shape.set_texture_param("texture")
	sh_mx.shader = snap_shadow_shape

	local vidsz = obj.add_clone(gr_vidsz)
	vidsz.set_pos (selectorscale*padding,selectorscale*(padding-verticalshift),selectorscale*width,selectorscale*height)
	vidsz.preserve_aspect_ratio = false
	//gr_vidsz.visible = false
	if (!prf.SNAPGRADIENT) gr_vidsz.visible = false
	// if (!prf.AUDIOVIDSNAPS) vidsz.video_flags = Vid.NoAudio


	local nw_mx = obj.add_image ("nw_1.png",selectorscale*padding,selectorscale*(padding-verticalshift+height*6.0/8.0),width*selectorscale/8.0,height*selectorscale/8.0)
	nw_mx.visible = false
	nw_mx.alpha = ((prf.NEWGAME == true)? 220 : 0)

	local tg_mx = obj.add_image ("tagww.png",0,0,width*selectorscale/6.0,height*selectorscale/6.0)
	tg_mx.visible = false
	tg_mx.mipmap = true
	tg_mx.alpha = ((prf.TAGSHOW == true)? 255 : 0)

	local donez = obj.add_image("completed.png",selectorscale*padding,selectorscale*(padding-verticalshift),selectorscale*width,selectorscale*height)
	donez.visible = false
	donez.preserve_aspect_ratio = false
	donez.mipmap = true

	local availz = obj.add_text("✘",0,0,widthpadded*selectorscale,heightpadded*selectorscale)
	availz.visible = false
	availz.font = uifonts.gui
	availz.char_size = width * 0.7
	availz.align = Align.MiddleCentre
	availz.set_rgb(200,50,0)
	availz.alpha = 150

	local favez = obj.add_image("starred.png",selectorscale*(padding+width/2),selectorscale*(padding+height/2-verticalshift),selectorscale*width/2,selectorscale*height/2)
	favez.visible = false
	favez.preserve_aspect_ratio = false

	logosurf_rt = obj.add_surface (logo.shw*logo.shscale,logo.shh*logo.shscale)
	logosurf_1 = logosurf_rt.add_surface (logo.shw*logo.shscale,logo.shh*logo.shscale)

	loshz = logosurf_1.add_image ("pics/transparent.png",logo.margin*logo.shscale,logo.margin*logo.shscale,logo.w*logo.shscale,logo.h*logo.shscale)
	loshz.mipmap = 1

	txshz = logosurf_1.add_text("...",loshz.x,loshz.y,loshz.width,loshz.height)
	txshz.char_size = logo.shcharsize*logo.shscale
	txshz.word_wrap = true
	txshz.align = logo.txtalign
	txshz.font = logo.txtfont
	txshz.margin = logo.txtmargin
	txshz.line_spacing = logo.txtlinespacing
	txshz.char_spacing = logo.txtcharspacing
	txshz.set_rgb (0,0,0)
	txshz.alpha = 150

	logosurf_1.shader = shaders.lg.hv

	logosurf_rt.preserve_aspect_ratio = true
	logosurf_rt.visible = true

	if (prf.LOGOSONLY){
		logosurf_rt.set_pos (selectorscale*padding*0.5,selectorscale*(padding*0.6-verticalshift+height*0.25),selectorscale*(width+padding),selectorscale*(height*0.5+padding))

	}
	else {
		if (!prf.CROPSNAPS)
			logosurf_rt.set_pos (selectorscale*padding*0.5,selectorscale*(padding*0.4*0.5-verticalshift),selectorscale*(width+padding),selectorscale*(height*0.5+padding))
		else
			logosurf_rt.set_pos (selectorscale*padding,selectorscale*(padding-verticalshift),selectorscale*width,selectorscale*width*logo.shh/logo.shw)
	}

	local logoz = obj.add_clone (loshz)

	logoz.preserve_aspect_ratio = true

	if (prf.LOGOSONLY){
		logoz.set_pos (selectorscale*padding,selectorscale*(padding +height*0.25 - verticalshift ),selectorscale*width,selectorscale*height*0.5)
	}
	else {
		if (!prf.CROPSNAPS)
			logoz.set_pos (selectorscale*padding,selectorscale*(padding*0.6-verticalshift),selectorscale*width,selectorscale*height*0.5)
		else
			logoz.set_pos (selectorscale*(padding+width*logo.margin/logo.shw),selectorscale*(padding-verticalshift+width*(15/20.0)*logo.margin/logo.shw),selectorscale*width*logo.w/logo.shw,selectorscale*height*logo.h/logo.shw)
	}

	txt2z = obj.add_text("...",logoz.x,logoz.y,logoz.width,logoz.height)
	txt2z.char_size = logo.shcharsize*(88.0/40.0)*scalerate
	txt2z.word_wrap = true
	txt2z.align = logo.txtalign
	txt2z.font = uifonts.arcadeborder
	txt2z.margin = logo.txtmargin
	txt2z.line_spacing = logo.txtlinespacing*0.6/0.6
	txt2z.char_spacing = logo.txtcharspacing
	txt2z.set_rgb (80,80,80)
	txt2z.alpha = 120

	txt2z.set_rgb (150,150,150)
	txt2z.alpha = 255

	txt2z.set_rgb (135,135,135)
	txt2z.alpha = 255

	//txshz = obj.add_text("[Title]",selectorscale*(padding +height*(1.0/8.0)),selectorscale*(padding+height*(1.0/8.0)),selectorscale*width*3.0/4.0,selectorscale*height*3.0/4.0)
	txt1z = obj.add_text("...",logoz.x,logoz.y,logoz.width,logoz.height)
	txt1z.char_size = logo.shcharsize*(88.0/40.0)*scalerate
	txt1z.word_wrap = true
	txt1z.align = logo.txtalign
	txt1z.font = logo.txtfont
	txt1z.margin = logo.txtmargin
	txt1z.line_spacing = logo.txtlinespacing
	txt1z.char_spacing = logo.txtcharspacing
	//txt1z.set_bg_rgb(200,0,0)
	//txt1z.bg_alpha = 50

	loshz.alpha = 150
	loshz.preserve_aspect_ratio = true
	loshz.set_rgb(0,0,0)

	tilesTablePos.X.push((width+padding) * (i/rows) + padding + obj.width*0.5)
	tilesTablePos.Y.push((width+padding) * (i%rows) + padding + carrierT.y + obj.height*0.5)
	tilesTableZoom.push ([0.0,0.0,0.0,0.0,0.0])
	tilesTableUpdate.push ([0.0,0.0,0.0,0.0,0.0])
	gr_vidszTableFade.push ([0.0,0.0,0.0,0.0,0.0])
	aspectratioMorph.push ([0.0,0.0,0.0,0.0,0.0])
	vidpos.push (0)
	vidindex.push (0)

	obj.preserve_aspect_ratio = false

	gr_vidsz.alpha = vidsz.alpha = 0

	//TEST107
	/*
	if(prf.LOGOSONLY){
		snapz.visible = false
		gr_snapz.visible = false
		bd_mx.visible = false
		gr_overlay.visible = false
		vidsz.visible = false
		sh_mx.visible = false
		glomx.visible = false
	}
	*/

	tilez.push({
		obj = obj
		snapz = snapz
		logoz = logoz
		loshz = loshz
		favez = favez
		donez = donez
		availz = availz
		sh_mx = sh_mx
		nw_mx = nw_mx
		tg_mx = tg_mx
		gr_vidsz = gr_vidsz
		vidsz = vidsz
		gr_snapz = gr_snapz
		gr_overlay = gr_overlay
		bd_mx = bd_mx
		glomx = glomx
		txt1z = txt1z
		txt2z = txt2z
		txshz = txshz
		txbox = txbox

		offset = 0
		index = 0

		AR = ({snap = 1.0, vids = 1.0, crop = 1.0, current = 1.0})
		offlist = false // True if the tile is offscreen (and therfore put to visible = false)
		alphazero = 255 // This is the alpha value of the tile, can be 255 or different if it's a "hidden" game
		alphafade = 0 // This is the alpha counter for the tile, when fading happens

		alphalogosonly = prf.LOGOSONLY ? 0.0 : 1.0 // This is an alpha factor that is used to blank items in logos only mode

		sh_mx_alpha = 230
		bd_mx_alpha = bd_mx.bg_alpha
		glomx_alpha = glomx.alpha
	})

}

impulse2.flow = 0.5

/// Data surface construction ///

local data_surface = fl.surf.add_surface (fl.w,fl.h)
data_surface.set_pos(fl.x,fl.y)


// Creation of data shadow

local sh_scale = {
	r1 = (vertical ? 400.0 / data_surface.width : 400.0 / data_surface.height)
	r2 = null
}

if (!prf.DATASHADOWSMOOTH) sh_scale.r1 = 1.0

local shader_tx = {
	h = fe.add_shader( Shader.VertexAndFragment, "glsl/gauss_kern9_v.glsl", "glsl/gauss_kern9_f.glsl" )
	v = fe.add_shader( Shader.VertexAndFragment, "glsl/gauss_kern9_v.glsl", "glsl/gauss_kern9_f.glsl" )
}
gaussshader (shader_tx.h, 9.0, 3.0, 1.0/(fl.w*sh_scale.r1), 0.0)
gaussshader (shader_tx.v, 9.0, 3.0, 0.0, 1.0/(fl.h*sh_scale.r1))


local data_surface_sh_rt = fl.surf.add_surface(data_surface.width * sh_scale.r1 , data_surface.height * sh_scale.r1)
local data_surface_sh_2 = data_surface_sh_rt.add_surface(data_surface.width * sh_scale.r1 , data_surface.height * sh_scale.r1)
local data_surface_sh_1 = data_surface_sh_2.add_clone(data_surface)
data_surface_sh_1.set_pos (0 , 0 , data_surface.width * sh_scale.r1 , data_surface.height * sh_scale.r1)
data_surface_sh_1.set_rgb(0,0,0)

if (prf.DATASHADOWSMOOTH){
	data_surface_sh_1.shader = shader_tx.v
	data_surface_sh_2.shader = shader_tx.h
}

data_surface_sh_rt.alpha = themeT.themeshadow

data_surface_sh_rt.zorder = -1

data_surface_sh_rt.set_pos(fl.x + 4*scalerate,fl.y+7*scalerate,data_surface.width,data_surface.height)


local filterdata = data_surface.add_text ( "footer",0,fl.h-footer.h,footermargin,footer.h)
filterdata.align = Align.Centre
filterdata.set_rgb( 255, 255, 255)
filterdata.word_wrap = true
filterdata.char_size = (prf.LOWRES ? 35*scalerate/uifonts.pixel : 25*scalerate/uifonts.pixel)
filterdata.visible = true
filterdata.font = uifonts.gui
filterdata.set_rgb(themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)
//filterdata.set_bg_rgb (200,10,10)

local filternumbers = data_surface.add_text ( (prf.CLEANLAYOUT ? "" :"[!zlistentry]\n[!zlistsize]"),fl.w-footermargin,fl.h-footer.h,footermargin,footer.h)
filternumbers.align = Align.Centre
filternumbers.set_rgb( 255, 255, 255)
filternumbers.word_wrap = true
filternumbers.char_size = (prf.LOWRES ? 35*scalerate/uifonts.pixel : 25*scalerate/uifonts.pixel)
filternumbers.visible = true
filternumbers.font = uifonts.gui
filternumbers.set_rgb(themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)

local separatorline = data_surface.add_text("",fl.w-footermargin+footermargin*0.3, fl.h-footer.h + footer.h*0.5,footermargin*0.4,1)
separatorline.set_bg_rgb(themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)
separatorline.visible = !((prf.CLEANLAYOUT))

multifilterglyph = data_surface.add_text("X",fl.w-footermargin,fl.h-footer.h,footermargin*0.3,footer.h)
multifilterglyph.margin = 0
multifilterglyph.char_size = scalerate * 45
multifilterglyph.align = Align.MiddleCentre
// multifilterglyph.set_bg_rgb (100,0,0)
multifilterglyph.set_rgb(themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)
multifilterglyph.word_wrap = true
multifilterglyph.msg = ""
multifilterglyph.font = uifonts.glyphs
multifilterglyph.visible = false



// scroller definition
local scrolline = data_surface.add_text ("",footermargin,fl.h - footer.h*0.5 - 1, fl.w-2*footermargin, 1 )
//scrolline.alpha = 255
scrolline.set_bg_rgb(themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)

local scrollineglow = data_surface.add_image ("whitedisc2.png",footermargin, fl.h - footer.h*0.5 - 10*scalerate -1 ,fl.w-2*footermargin, 20*scalerate + 1)
scrollineglow.visible = false
scrollineglow.alpha = 200
scrollineglow.set_rgb(themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)

local scroller = data_surface.add_image ("whitedisc.png",footermargin - scrollersize*0.5,fl.h-footer.h*0.5-(scrollersize + 1 )*0.5,scrollersize,scrollersize)
scroller.set_rgb(themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)

local scroller2 = data_surface.add_image ("whitedisc2.png",scroller.x - scrollersize*0.5, scroller.y-scrollersize*0.5,scrollersize*2,scrollersize*2)
scroller2.visible = false
scroller2.alpha = 200
scroller2.set_rgb(themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)

if (prf.SCROLLERTYPE == "labellist") scroller2.alpha = scrollineglow.alpha = scroller.alpha = scrolline.bg_alpha = 0

local labelstrip = data_surface.add_image("wbox2.png")
labelstrip.visible = false

local labelsurf = data_surface.add_surface (fl.w,fl.h)
labelsurf.set_pos (fl.x,fl.y)
//local labelblack = null //TEST109 PUT here for legacy, but probably not needed in AF109
//if (prf.SCROLLERTYPE == "labellist") labelblack = labelsurf.add_image("pics/black.png",0,0,1,1)

searchdata = data_surface.add_text (fe.list.search_rule,0,fl.h-footer.h*0.5,fl.w,footer.h*0.5)
searchdata.align = Align.Centre
searchdata.set_rgb( 255, 255, 255)
searchdata.word_wrap = true
searchdata.char_size = 25*scalerate
searchdata.visible = true
searchdata.font = uifonts.gui
searchdata.set_rgb(themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)

function displaynamelogo (offset){
	/*
	local dispname = ( fe.displays[fe.list.display_index].name)
	local dispname2 = split (dispname,"#")
	if (dispname2.len() > 1) dispname = dispname2[0]
	*/
	return systemfont (z_disp[fe.list.display_index].cleanname,false)
}
//TEST106 AGGIORNARE CON OVERSCAN
local displaynamesurf = {
	surf = null
	w = fl.w_os * 2.0
	h = 0
}
displaynamesurf.h = displaynamesurf.w * 30.0/200.0
displaynamesurf.surf = data_surface.add_surface (displaynamesurf.w,displaynamesurf.h)
displaynamesurf.surf.set_pos (0.5*(fl.w_os - displaynamesurf.w), 0.5*(fl.h_os - displaynamesurf.h))
local displayname = displaynamesurf.surf.add_text("...",0,0,displaynamesurf.w,displaynamesurf.h)

displayname.char_size = displaynamesurf.h * 1.01
displayname.margin = 0
displayname.word_wrap = true
displayname.alpha = 0
displayname.font = uifonts.gui
displayname.align = Align.MiddleCentre

// fading letter
local letterobjsurf = {
	surf = null
	w = fl.w_os*3.0
	h = carrierT.h
	y0 = carrierT.y
}
letterobjsurf.surf = data_surface.add_surface(letterobjsurf.w,letterobjsurf.h)
letterobjsurf.surf.set_pos (0.5*(fl.w_os - letterobjsurf.w),letterobjsurf.y0)
local letterobj = letterobjsurf.surf.add_text("...",0,0,letterobjsurf.w,letterobjsurf.h)
letterobj.alpha = 0
letterobj.char_size = lettersize.name * 2.0
letterobj.font = uifonts.gui
letterobj.set_rgb(themeT.themelettercolor,themeT.themelettercolor,themeT.themelettercolor)
letterobj.margin = 0
letterobj.align = Align.MiddleCentre

local blsize = {
	mini = 45 * scalerate,
	catp = 110 * scalerate,
	subt = 35 * scalerate,
	posy = 137 * scalerate,
	manu = 145 * scalerate,
	dath = 25 * scalerate

}

if (prf.LOWRES) {
	blsize = {
		mini = 60 * scalerate,
		catp = 150 * scalerate,
		subt = 45 * scalerate,
		posy = 180 * scalerate,
		manu = 150 * scalerate,
		dath = 40 * scalerate
	}
}

// category image
local game_catpicT = {
	x = 30 * scalerate,
	y = 20 * scalerate,
	w = blsize.catp,
	h = blsize.catp
}

// players image, controller image, button image
local game_plypicT = {
	x = blsize.catp + 2.0 * game_catpicT.x,
	y = blsize.posy,
	w = blsize.mini,
	h = blsize.mini
}

local game_ctlpicT = {
	x = game_plypicT.x + (blsize.mini + 10 * scalerate),
	y = game_plypicT.y,
	w = blsize.mini,
	h = blsize.mini
}

local game_butpicT = {
	x = game_plypicT.x + 2 * (blsize.mini + 10 * scalerate),
	y = game_plypicT.y,
	w = blsize.mini * 1.25,
	h = blsize.mini
}

// main game category
local game_maincatT = {
	x = 20 * scalerate,
	y = header.h - 20 * scalerate - blsize.subt,
	w = game_plypicT.x - 2 * 20 * scalerate,
	h = blsize.subt
}

// right side: manufacturer and year
local game_manufacturerpicT = {
	x = fl.w - 2 * blsize.manu - 30 * scalerate,
	y = (prf.LOWRES ? 20*scalerate : 10 * scalerate),
	w = 2 * blsize.manu,
	h = blsize.manu
}
local game_yearT = {
	x = game_manufacturerpicT.x,
	y = header.h - 20 * scalerate - blsize.dath,
	w = game_manufacturerpicT.w,
	h = blsize.dath
}

// game main name and subname
local game_mainnameT = {
	x = game_plypicT.x,
	y = game_catpicT.y,
	w = fl.w - game_plypicT.x - game_manufacturerpicT.w - 30*scalerate - 5 * scalerate,
	h = game_catpicT.h
}

local game_subnameT = {
	x = game_butpicT.x + game_butpicT.w + 15 * scalerate,
	y = game_maincatT.y,
	w = fl.w - game_butpicT.x - game_butpicT.w - 15 *scalerate - game_manufacturerpicT.w - 30*scalerate - 5 * scalerate,
	h = blsize.subt
}

local bwtoalpha = fe.add_shader( Shader.Fragment, "glsl/bwtoalpha.glsl" )
bwtoalpha.set_texture_param( "texture")

local txtoalpha = fe.add_shader( Shader.Fragment, "glsl/txtoalpha.glsl" )
txtoalpha.set_texture_param( "texture")

for (local i = 0; i < dat.stacksize; i++){

	local game_catpic = data_surface.add_image("pics/white.png",game_catpicT.x, game_catpicT.y, game_catpicT.w, game_catpicT.h)
	game_catpic.smooth = false
	game_catpic.preserve_aspect_ratio = true
	game_catpic.set_rgb(themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)
	game_catpic.shader = bwtoalpha
	game_catpic.mipmap = 1
	//game_catpic.fix_masked_image()

	local game_butpic = data_surface.add_image("pics/white.png",game_butpicT.x, game_butpicT.y, game_butpicT.w, game_butpicT.h)
	game_butpic.smooth = true
	game_butpic.preserve_aspect_ratio = true
	game_butpic.set_rgb(themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)
	game_butpic.shader = bwtoalpha
	game_butpic.mipmap = 1

	local game_plypic = data_surface.add_image("pics/white.png",game_plypicT.x, game_plypicT.y, game_plypicT.w, game_plypicT.h)
	game_plypic.smooth = true
	game_plypic.preserve_aspect_ratio = true
	game_plypic.set_rgb(themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)
	game_plypic.shader = bwtoalpha
	game_plypic.mipmap = 1

	local game_ctlpic = data_surface.add_image("pics/white.png",game_ctlpicT.x, game_ctlpicT.y, game_ctlpicT.w, game_ctlpicT.h)
	game_ctlpic.smooth = true
	game_ctlpic.preserve_aspect_ratio = true
	game_ctlpic.set_rgb(themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)
	game_ctlpic.shader = bwtoalpha
	game_ctlpic.mipmap = 1

	local game_maincat = data_surface.add_text("",game_maincatT.x,game_maincatT.y,game_maincatT.w,game_maincatT.h)
	game_maincat.align = Align.MiddleCentre
	game_maincat.word_wrap = true
	game_maincat.set_rgb(themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)
	game_maincat.char_size = (game_maincatT.h - 10*scalerate)/uifonts.pixel
	game_maincat.font = uifonts.condensed
	game_maincat.alpha = 255
	game_maincat.margin = 0
	game_maincat.line_spacing = 0.8
	//	game_maincat.set_bg_rgb (255,0,0)


	local game_mainname = data_surface.add_text( "", game_mainnameT.x, game_mainnameT.y , game_mainnameT.w, game_mainnameT.h )
	game_mainname.align = Align.MiddleLeft
	game_mainname.word_wrap = true
	game_mainname.set_rgb(themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)
	game_mainname.char_size = (game_mainnameT.h - 10*scalerate)*0.5/uifonts.pixel
	game_mainname.line_spacing = 0.670000068
	game_mainname.margin = 0
	game_mainname.font = uifonts.gui
	game_mainname.alpha = 255
	// game_mainname.set_bg_rgb(200,0,0)
	game_mainname.visible = true

	local game_subname = data_surface.add_text( "", (prf.CLEANLAYOUT ? game_mainnameT.x : game_subnameT.x), game_subnameT.y, game_subnameT.w, game_subnameT.h )
	game_subname.align = Align.TopLeft
	game_subname.word_wrap = false
	game_subname.set_rgb(themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)
	game_subname.char_size = game_subnameT.h/uifonts.pixel
	game_subname.font = uifonts.gui
	game_subname.alpha = 255
	game_subname.margin = 0
	//	game_subname.set_bg_rgb(200,100,0)


	local game_manufacturerpic = data_surface.add_text("",game_manufacturerpicT.x , game_manufacturerpicT.y , game_manufacturerpicT.w, game_manufacturerpicT.h)

	// game_manufacturerpic.mipmap = 1
//	game_manufacturerpic.smooth = true
//	game_manufacturerpic.preserve_aspect_ratio = false
	game_manufacturerpic.set_rgb(themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)
//	game_manufacturerpic.shader = bwtoalpha
	game_manufacturerpic.char_size = game_manufacturerpicT.h-5*scalerate
	game_manufacturerpic.margin = 5*scalerate
	game_manufacturerpic.align = Align.BottomCentre
	game_manufacturerpic.font = "font_manufacturers.ttf"
	//game_manufacturerpic.set_bg_rgb(255,0,0)


	local game_manufacturername = data_surface.add_text("",game_manufacturerpicT.x , game_manufacturerpicT.y, game_manufacturerpicT.w, game_manufacturerpicT.h)
	// game_manufacturerpic.mipmap = 1
	game_manufacturername.align = Align.MiddleCentre
	game_manufacturername.set_rgb( 255, 255, 255)
	game_manufacturername.word_wrap = true
	game_manufacturername.char_size = 0.2*game_manufacturerpicT.h/uifonts.pixel
	game_manufacturername.visible = false
	game_manufacturername.font = uifonts.gui
	game_manufacturername.margin = 0
	game_manufacturername.set_rgb(themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)


	local game_year = data_surface.add_text( "", game_yearT.x, game_yearT.y, game_yearT.w, game_yearT.h)
	game_year.align = Align.TopCentre
	game_year.set_rgb( 255, 255, 255)
	game_year.word_wrap = false
	game_year.char_size = game_yearT.h/uifonts.pixel
	game_year.visible = true
	game_year.font = uifonts.gui
	game_year.margin = 0
	game_year.set_rgb(themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)
	// game_year.set_bg_rgb(200,000,100)

	if (prf.CLEANLAYOUT){
		game_manufacturerpic.visible = game_maincat.visible = game_year.visible = game_manufacturername.visible = game_catpic.visible = game_butpic.visible = game_ctlpic.visible = game_plypic.visible = false
	}

	dat.var_array.push(0)
	dat.alphapos.push (1)
	dat.cat_array.push(game_catpic)
	dat.but_array.push (game_butpic)
	dat.ply_array.push (game_plypic)
	dat.ctl_array.push (game_ctlpic)
	dat.mainctg_array.push(game_maincat)
	dat.manufacturer_array.push(game_manufacturerpic)
	dat.manufacturername_array.push(game_manufacturername)
	dat.gamename_array.push(game_mainname)
	dat.gamesubname_array.push(game_subname)
	dat.gameyear_array.push(game_year)
}

//TEST89 Uncomment this to monitor the cloned surface
/*
fl.surf3 = fl.surf2.add_clone(fl.surf)
fl.surf3.set_pos(0,0,fl.w_os*0.2,fl.h_os*0.2)
*/
//fl.surf2.set_pos(0,0,fl.w_os,fl.h_os)


/// Context Menu ///

//local overmenuwidth = (vertical ? fl.w_os * 0.7 : fl.h_os * 0.7)
local overmenuwidth = selectorwidth * 0.9
if (((rows == 1) && vertical ) || (!vertical && (rows == 1) && (prf.SLIMLINE == false) && (prf.TILEZOOM == 2) )) overmenuwidth = selectorwidth * 0.6
local overmenu = fl.surf.add_image("overmenu4.png",fl.x + fl.w*0.5-overmenuwidth*0.5,fl.y + fl.h*0.5-overmenuwidth*0.5,overmenuwidth,overmenuwidth)
overmenu.visible = false
overmenu.alpha = 0

function overmenu_visible(){
	return ((overmenu.visible) && (flowT.overmenu[3] >= 0))
}

function overmenu_show(){
	overmenu.y = fl.x + fl.h*0.5*0 + header.h2 + heightpadded*0.5 -overmenuwidth*0.5 - corrector * (heightpadded - padding)
	if (rows == 1 ) overmenu.y = fl.y + fl.h*0.5*0 + header.h2 + heightpadded*0.5 - overmenuwidth*0.5
	if (prf.SLIMLINE == true) overmenu.y = fl.y + header.h + (fl.h-header.h-footer.h)*0.5 - overmenuwidth*0.5
	overmenu.x = fl.x + fl.w*0.5 - overmenuwidth*0.5 + centercorr.val
	if(prf.THEMEAUDIO) snd.wooshsound.playing = true

	overmenu.visible = true
	flowT.overmenu = startfade (flowT.overmenu , 0.095,0.0)
}

function overmenu_hide(strict){

	if(strict) {
		overmenu.alpha = 0
		overmenu.visible = false
		flowT.overmenu = [0.0,0.0,0.0,0.0,0.0]
		return
	}
	else
	 flowT.overmenu = startfade (flowT.overmenu , -0.08,-3.0)
}

/// Controls Overlays Construction (Listbox) ///


// Overlay area background
overlay.background = fe.add_text ("", overlay.x, overlay.y, overlay.w, overlay.h)
overlay.background.set_bg_rgb(themeT.listboxbg,themeT.listboxbg,themeT.listboxbg)
//overlay.background.set_bg_rgb(255,0,0)
overlay.background.bg_alpha = themeT.listboxalpha

overlay.listbox = fe.add_listbox( overlay.x, overlay.y + overlay.labelsize, overlay.w , overlay.fullheight )
overlay.listbox.rows = overlay.rows
overlay.listbox.char_size = overlay.charsize
overlay.listbox.bg_alpha = 0
overlay.listbox.set_rgb(themeT.themetextcolor-5,themeT.themetextcolor-5,themeT.themetextcolor-5)
overlay.listbox.set_bg_rgb( 0, 0, 0 )
overlay.listbox.set_sel_rgb( themeT.listboxseltext, themeT.listboxseltext, themeT.listboxseltext )
overlay.listbox.set_selbg_rgb( themeT.listboxselbg,themeT.listboxselbg,themeT.listboxselbg )
overlay.listbox.selbg_alpha = 255
overlay.listbox.font = uifonts.gui
overlay.listbox.align = Align.MiddleCentre
overlay.listbox.sel_alpha = 255

overlay.label = fe.add_text( "LABEL", overlay.x, overlay.y, overlay.w, overlay.labelsize )
overlay.label.char_size = overlay.labelcharsize
overlay.label.set_rgb(themeT.themetextcolor-5,themeT.themetextcolor-5,themeT.themetextcolor-5)
overlay.label.align = Align.MiddleCentre
overlay.label.font = uifonts.gui
overlay.label.set_bg_rgb(0,200,0)
overlay.label.bg_alpha = 0

overlay.sidelabel = fe.add_text( "", overlay.x, overlay.y, overlay.w, overlay.labelsize )
overlay.sidelabel.char_size = overlay.labelcharsize*0.6
overlay.sidelabel.set_rgb(themeT.themetextcolor-5,themeT.themetextcolor-5,themeT.themetextcolor-5)
overlay.sidelabel.align = Align.MiddleRight
overlay.sidelabel.font = uifonts.lite
overlay.sidelabel.set_bg_rgb(0,200,0)
overlay.sidelabel.bg_alpha = 0
overlay.sidelabel.word_wrap = true

overlay.glyph = fe.add_text( "", overlay.x + padding, overlay.y, overlay.labelsize*0.98, overlay.labelsize*0.98 )
overlay.glyph.font = uifonts.glyphs
overlay.glyph.margin = 0
overlay.glyph.char_size = overlay.charsize*1.25
overlay.glyph.align = Align.MiddleCentre
//overlay.glyph.set_bg_rgb (100,0,0)
overlay.glyph.bg_alpha = 0
overlay.glyph.set_rgb(themeT.themetextcolor-5,themeT.themetextcolor-5,themeT.themetextcolor-5)
overlay.glyph.word_wrap = true

overlay.wline = fe.add_text ("",overlay.x,overlay.y + overlay.labelsize-2,overlay.w,2)

//TEST106 CHECK OVERSCAN
overlay.shad.push (fe.add_image ("wgradientBb.png", overlay.x, fl.y + fl.h-footer.h+overlay.ex_bottom, overlay.w, floor(50*scalerate)))
overlay.shad.push (fe.add_image ("wgradientTb.png", overlay.x, overlay.y-floor(50*scalerate), overlay.w, floor(50*scalerate)))
overlay.shad.push (fe.add_image ("wgradientLb.png", overlay.x-floor(50*scalerate), overlay.y,floor(50*scalerate), overlay.h))
overlay.shad.push (fe.add_image ("wgradientRb.png", overlay.x + overlay.w, overlay.y, floor(50*scalerate), overlay.h))

foreach (item in overlay.shad){
	item.alpha = 0
	item.set_rgb(0,0,0)
}

overlay.wline.bg_alpha = 0
overlay.wline.set_bg_rgb(themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)


//overlay.filterbg.visible = overlay.background.visible = overlay.listbox.visible = overlay.sidelabel.visible = overlay.label.visible = overlay.glyph.visible = overlay.wline.visible = false
overlay.background.visible = overlay.listbox.visible = overlay.sidelabel.visible = overlay.label.visible = overlay.glyph.visible = overlay.wline.visible = false
foreach (item in overlay.shad) item.visible = false
fe.overlay.set_custom_controls( overlay.label, overlay.listbox )

function mfmbgshow(){
	frost.surf_rt.shader = shader_fr.alpha
	flowT.filterbg = startfade(flowT.filterbg,0.08,0.0)
}

function mfmbghide(){
	flowT.filterbg = startfade(flowT.filterbg,-0.10,0.0)
}

function frostshow(){

	if (overmenu_visible()) overmenu_hide(false)

	//TEST94 if (frost.surf_rt.visible) return
	//frost.surf_rt.alpha = 255
	frostshaders(true)

	overlay.background.visible = true
	flowT.zmenubg = startfade(flowT.zmenubg,0.08,0.0)
	flowT.frostblur = startfade(flowT.frostblur,0.08,0.0)
}

function frosthide(){ //TEST104 tolto l'if controllare il zmenubg
	flowT.zmenubg = startfade(flowT.zmenubg,-0.10,0.0)
	flowT.frostblur = startfade(flowT.frostblur,-0.10,0.0)
}

function frostshaders (turnon){

	if (turnon){
	//	frost.top.shader = flipshader
		frost.surf_rt.visible = true
		frost.surf_1.shader = shader_fr.h
		frost.pic.shader = shader_fr.v
	}
	else{
	//	frost.top.shader = noshader
		frost.surf_rt.visible = false
		frost.surf_1.shader = noshader
		frost.pic.shader = noshader
	}

}

function videosnap_hide(){
	for (local i = 0 ; i < tiles.total ; i++){
		gr_vidszTableFade[i] = startfade (gr_vidszTableFade[i],-0.1,1.0)
		aspectratioMorph[i] = startfade (aspectratioMorph[i],-0.1,1.0)
		vidpos[i] = 0
	}
}

function videosnap_restore(){
	if (tilez[focusindex.new].gr_vidsz.alpha == 0) {
		vidpos[focusindex.new] = vidstarter
		vidindex[focusindex.new] = tilez[focusindex.new].offset
	}
	else {
		gr_vidszTableFade[focusindex.new] = startfade (gr_vidszTableFade[focusindex.new],0.03,1.0)
		aspectratioMorph[focusindex.new] = startfade (aspectratioMorph[focusindex.new],0.06,1.0)
	}
}

function overlay_visible() {
	return overlay.listbox.visible
}

function overlay_show(var0){

	if (overmenu_visible()) overmenu_hide(false)

	if ((prf.AUDIOVIDSNAPS) && (prf.THUMBVIDEO)) tilez[focusindex.new].gr_vidsz.video_flags = Vid.NoAudio

	if (prf.THUMBVIDEO) videosnap_hide()

	if (!prf.DMPENABLED){
		flowT.fg = [0.0,1.0,0.0,0.0,0.0]
		fg_surface.alpha = 255*satin.rate
		fg_surface.visible = true
	}

	overlay.listbox.visible = true
	overlay.glyph.visible = false
	overlay.background.visible = overlay.sidelabel.visible = overlay.label.visible = overlay.wline.visible = true
	foreach (item in overlay.shad) item.visible = true
	flowT.zmenutx = startfade(flowT.zmenutx,0.05,0.0)
	flowT.zmenush = startfade(flowT.zmenush,0.05,0.0)
}

function overlay_hide(){
	if ((prf.AUDIOVIDSNAPS) && (prf.THUMBVIDEO)) tilez[focusindex.new].gr_vidsz.video_flags = Vid.Default

	if (prf.THUMBVIDEO) videosnap_restore()

	frosthide()

	if (!prf.DMPENABLED){
		fg_surface.alpha = 0
		flowT.fg = [0.0,0.0,0.0,0.0,0.0]
		fg_surface.visible = false
	}

	overlay.background.visible = overlay.listbox.visible = overlay.sidelabel.visible = overlay.label.visible = overlay.glyph.visible = overlay.wline.visible = false
	foreach (item in overlay.shad) item.visible = false
}


/// Preferences overlay ///

function getsubmenu(index){
   local out = []
   for (local i = 0 ; i < AF.prefs.l1[index].len() ; i++ ) {
      out.push (AF.prefs.l1[index][i].title)
   }
   return out
}

function getsubmenuglyphs(index){
   local out = []
   for (local i = 0 ; i < AF.prefs.l1[index].len() ; i++ ) {
      out.push (AF.prefs.l1[index][i].glyph)
   }
   return out
}

function getsubmenunotes(index){
   local out = []
   for (local i = 0 ; i < AF.prefs.l1[index].len() ; i++ ) {

		local selection = AF.prefs.l1[index][i].selection
		if 	  (selection == -1) out.push ("⌨")
		else if (selection == -2) out.push ("⏩")
		else if (selection == -3) out.push ("⏏")
		else if (selection == -4) out.push ("☰")
		else if (selection < 0) out.push ("")
		else out.push (AF.prefs.l1[index][i].options[AF.prefs.l1[index][i].selection])
   }
   return out
}


local prfmenu = {
	res0 = 0
	res1 = 0
	res2 = 0
	outres0 = 0
	outres1 = 0
	outres2 = 0
	level = 0
	bg = fe.add_text("",0,0,0,0)
	description = fe.add_text("",0,0,100,100)
	helppic = fe.add_image("pics/transparent.png",0,fl.h_os*0.5,fl.h_os*0.5,fl.h_os*0.5)
	showing = false
	browsershowing = false
	browserfile = ""
	browserdir = []
	//	picratew = overlay.fullwidth * 0.3
	picrateh = overlay.fullheight * 0.4
	//	picratew = 1.25 * overlay.fullheight * 0.4
	picratew = overlay.fullwidth * 0.3

}

prfmenu.picratew = prfmenu.picrateh = (overlay.fullheight * 1.0 / overlay.rows) * 2.0 - padding * 0.5

//prfmenu.description.set_bg_rgb(100,0,0)
prfmenu.description.char_size = 48*scalerate //TEST102 era 46
prfmenu.description.font = uifonts.lite //TEST102
prfmenu.description.word_wrap = true
prfmenu.description.margin = 0
prfmenu.description.set_rgb (themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)
//overlay.listbox.set_bg_rgb(80,0,0)
//overlay.listbox.bg_alpha = 128

prfmenu.helppic.preserve_aspect_ratio = true

prfmenu.bg.set_bg_rgb (themeT.optionspanelrgb,themeT.optionspanelrgb,themeT.optionspanelrgb)
prfmenu.bg.bg_alpha = themeT.optionspanelalpha

prfmenu.bg.set_pos(overlay.x,overlay.y + overlay.labelsize + overlay.fullheight - prfmenu.picrateh , overlay.fullwidth , prfmenu.picrateh)
prfmenu.helppic.set_pos (prfmenu.bg.x, prfmenu.bg.y, prfmenu.picratew , prfmenu.picrateh)
prfmenu.description.set_pos (prfmenu.bg.x + padding + prfmenu.picratew , prfmenu.bg.y , overlay.fullwidth - prfmenu.picratew - 2*padding , prfmenu.picrateh)

prfmenu.description.visible = prfmenu.helppic.visible = prfmenu.bg.visible = false

function buildselectarray(options,selection){
	local out = []
	for (local i = 0 ; i < options.len(); i++) {
		out.push (0)
	}
	out[selection] = 0xea10
	return (out)
}

function updatemenu(level,var){

	if (level == 1){
		prfmenu.helppic.file_name =AF.folder + AF.prefs.imgpath + "gear2.png"
		prfmenu.helppic.set_rgb(themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)
	}

	else if (level == 2) {
		prfmenu.helppic.set_rgb(255,255,255)

		try {prfmenu.helppic.file_name = AF.folder + AF.prefs.imgpath + AF.prefs.l1[prfmenu.outres0][zmenu.selected].picsel[AF.prefs.l1[prfmenu.outres0][zmenu.selected].selection]}
		catch(err){
			try {prfmenu.helppic.file_name = AF.folder + AF.prefs.imgpath + AF.prefs.l1[prfmenu.outres0][var].pic}
			catch (err) {
				prfmenu.helppic.file_name = AF.folder + AF.prefs.imgpath + "gear2.png"
				prfmenu.helppic.set_rgb(themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)
			}
		}
	}

	else if (level == 3) {
		prfmenu.helppic.set_rgb(255,255,255)
		try {prfmenu.helppic.file_name = AF.folder + AF.prefs.imgpath + AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].picsel[var]}
		catch (err) {
			try {prfmenu.helppic.file_name = AF.folder + AF.prefs.imgpath + AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].pic}
			catch (err) {
				prfmenu.helppic.file_name = AF.folder + AF.prefs.imgpath + "gear2.png"
				prfmenu.helppic.set_rgb(themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)
			}
		}
	}
}

//Third level menu
function optionsmenu2(){
	prfmenu.description.msg = AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].help
	prfmenu.level = 3

	updatemenu(prfmenu.level,AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].selection)
	if (AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].selection >= 0 ){
		// MULTIPLE CHOICE OPTION
		zmenudraw (AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].options, buildselectarray(AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].options,AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].selection),null,AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].title ,0xe991,AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].selection,false,false,true,false,
		function(prfmenures2){
			prfmenu.res2 = prfmenures2
			if (prfmenu.res2 != -1) {
				if(prf.THEMEAUDIO) snd.clicksound.playing = true
				AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].selection = prfmenu.res2
				prfmenu.outres2 = prfmenu.res2
				optionsmenu2()
			}
			else {
				optionsmenu1()
			}
		})
	}
	else if (AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].selection == -1){
		// TEXT INPUT OPTION (selection = -1)
		zmenuhide()
		flowT.zmenudecoration = startfade(flowT.zmenudecoration,0.2,0.0)

		keyboard_select (0, vertical ? 1 : 0)

		keyboard_show(AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].title,AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values ,
		function(){ //TYPE
			return
		},
		function(){ //BACK
			optionsmenu1()
			return
		},
		function(){ //DONE
			AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values = keyboard_entrytext
			prfmenu.res2 = -1
			optionsmenu1()
			return
		}
		)

		//AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values = fe.overlay.edit_dialog( AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].title, AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values )
		//prfmenu.res2 = -1
		//optionsmenu1()

	}
	else if (AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].selection == -6){
		// TEXT INPUT OPTION (selection = -6)
		AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values = fe.overlay.edit_dialog( AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].title, AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values )
		prfmenu.res2 = -1
		optionsmenu1()

	}
	else if (AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].selection == -2){
		// EXECUTE FUNCTION OPTION (selection = -2)
		AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values()
		prfmenu.res2 = -1
		optionsmenu1()
	}
	else if (AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].selection == -3){
		// FILE REQUESTER OPTION (selection = -3)
		AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values = filebrowser(AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values)
		prfmenu.res2 = -1
	}
	else if (AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].selection == -4){
		// MENU SORT AND CUSTOMIZE OPTION (selection = -4)
		local v0 = split(AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values,",")
		for (local i = 0 ; i < v0.len() ; i++){
			v0[i] = v0[i].tointeger()
		}
		local n0 = AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].options()
		//local intab = AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].options()
		//local n0 = []
		/*
		for (local i =0 ; i<intab.len() ; i++){
			n0.push(intab[i]["label"])
		}
		*/
		sortmenu(v0,n0,0,AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].glyph,AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].title)
	}
	else if (AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].selection == -5){
		// EXECUTE FUNCTION OPTION WITHOUT GETTING BACK TO MENU (selection = -5)
		// Useful for options that require data input AND processing
		AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values()
	}
}

//Second menu level
function optionsmenu1(){

	prfmenu.level = 2

	updatemenu(prfmenu.level,prfmenu.outres1)

	zmenudraw (getsubmenu(prfmenu.outres0),getsubmenuglyphs(prfmenu.outres0),getsubmenunotes(prfmenu.outres0),AF.prefs.l0[prfmenu.outres0].label,AF.prefs.l0[prfmenu.outres0].glyph,prfmenu.outres1,false,false,false,false,
	function(prfmenures1){
		prfmenu.res1 = prfmenures1
		// EXIT FROM SUBMENU 1
		try{prfmenu.description.msg = AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].help}catch(err){prfmenu.description.msg=""}
		if (prfmenu.res1 == -1) {
			prfmenu.outres1 = 0
			optionsmenu0()
		}
		else {
			prfmenu.outres1 = prfmenu.res1
			optionsmenu2()
		}
	}
	function(){//Left
		if (AF.prefs.l1[prfmenu.outres0][zmenu.selected].selection < 0) return
		if (AF.prefs.l1[prfmenu.outres0][zmenu.selected].selection == 0) {
			if(prf.THEMEAUDIO) snd.wooshsound.playing = true

			AF.prefs.l1[prfmenu.outres0][zmenu.selected].selection = AF.prefs.l1[prfmenu.outres0][zmenu.selected].values.len() - 1
			prfmenu.outres1 = zmenu.selected
			optionsmenu1()
			return
		}
		if (AF.prefs.l1[prfmenu.outres0][zmenu.selected].selection > 0){
			if (prf.THEMEAUDIO) snd.clicksound.playing = true

			AF.prefs.l1[prfmenu.outres0][zmenu.selected].selection --
			prfmenu.outres1 = zmenu.selected
			optionsmenu1()
			return
		}
	}
	function(){//Right
		if (AF.prefs.l1[prfmenu.outres0][zmenu.selected].selection < 0) return
		if (AF.prefs.l1[prfmenu.outres0][zmenu.selected].selection == AF.prefs.l1[prfmenu.outres0][zmenu.selected].values.len() - 1) {

			if(prf.THEMEAUDIO) snd.wooshsound.playing = true

			AF.prefs.l1[prfmenu.outres0][zmenu.selected].selection = 0
			prfmenu.outres1 = zmenu.selected
			optionsmenu1()

			return
		}
		if (AF.prefs.l1[prfmenu.outres0][zmenu.selected].selection < AF.prefs.l1[prfmenu.outres0][zmenu.selected].values.len() - 1){
			if (prf.THEMEAUDIO) snd.clicksound.playing = true

			AF.prefs.l1[prfmenu.outres0][zmenu.selected].selection ++
			prfmenu.outres1 = zmenu.selected
			optionsmenu1()
		}
	})
}


//First menu level
function optionsmenu0(){
	prfmenu.description.msg = AF.prefs.l0[prfmenu.outres0].description
	prfmenu.level = 1
	updatemenu(prfmenu.level,prfmenu.outres0)

	// First level menu
	zmenudraw (AF.prefs.a0, AF.prefs.gl0,null,ltxt("Layout options",TLNG), 0xe991, prfmenu.outres0,false,false,false,false,
	function(prfmenures0){
		// EXIT FROM OPTIONSMENU
		prfmenu.res0 = prfmenures0
		if (prfmenu.res0 == -1) {

			// APPLY CHANGES

			// Reset preference menu status
			prfmenu.showing = false
			prfmenu.description.visible = prfmenu.helppic.visible = prfmenu.bg.visible = false

			// Save prefs data and reload the layout
			local selection_post = generateselectiontable()
			local updated = false

			foreach (label, val in selection_post){
				if (selection_pre[label] != val) updated = true
			}

			if (updated){
				saveprefdata(selection_post,null)
				prf = generateprefstable()

				TLNG = prf.LAYOUTLANGUAGE
				savelanguage(TLNG)

				DBGON = prf.DEBUGMODE
				savedebug(DBGON ? "true" : "false")

				fe.signal("reload")
			}
			else {
				prfmenu.outres0 = 0

				frosthide()
				zmenuhide()
				if ( (prf.DMPATSTART) && (prf.DMPENABLED) ){
					/*
					flowT.fg = startfade(flowT.fg,-0.02,-1.0)
					flowT.data = startfade(flowT.data,0.02,-1.0)
					*/
					flowT.groupbg = startfade (flowT.groupbg,0.02,-1.0)
				}
			}
		}
		else {
			prfmenu.outres0 = prfmenu.res0
			while (AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].selection == -10){
				prfmenu.outres1++
			}
			try{prfmenu.description.msg = AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].help}catch(err){prfmenu.description.msg=""}
			optionsmenu1()
		}
	})
}

function optionsmenu(){

	prfmenu.res0 = prfmenu.res1 = prfmenu.res2 = prfmenu.outres0 = prfmenu.outres1 = prfmenu.outres2 = prfmenu.level = 0
	prfmenu.showing = true

	prfmenu.bg.visible = prfmenu.description.visible = prfmenu.helppic.visible = true

	selection_pre = generateselectiontable()

	optionsmenu0()
}

function savecurrentoptions(){
	zmenuhide()
	flowT.zmenudecoration = startfade(flowT.zmenudecoration,0.2,0.0)

	keyboard_select (0, vertical ? 1 : 0)

	keyboard_show("Name","",
	function(){ //TYPE
		return
	},
	function(){ //BACK
		prfmenu.res2 = -1
		optionsmenu1()
		return
	},
	function(){ //DONE
		if (keyboard_entrytext != ""){
			local current_selection = generateselectiontable()

			local savefilepath = fe.path_expand(AF.folder + "options/" + keyboard_entrytext+".txt")
			local prffile = WriteTextFile (savefilepath)

			saveprefdata (current_selection,savefilepath)

		}

		prfmenu.res2 = -1
		optionsmenu1()
		return
	}
	)
}

function restoreoptions(){
	local optionsdir = fe.path_expand(AF.folder + "options")
	local optionsfiles = DirectoryListing( optionsdir, false ).results
	local optionsnames = []
	foreach (id, item in optionsfiles){
		if (item[0].tochar() != ".") optionsnames.push (item.slice(0,-4))
	}
	if (optionsnames.len() > 0){
		zmenudraw (optionsnames,null,null,"Options files",null,0,false,false,false,false,
		function(out){
			if (out == -1){
				optionsmenu1()
			}
			else {
				local prefsfilepath = fe.path_expand(AF.folder + "options/" + optionsnames.results[out]+".txt")
				readprefdata(prefsfilepath)
				local outprefs = generateselectiontable()
				saveprefdata(outprefs,null)
				fe.signal("reload")

			}
		},
		function(){},
		function(){}
		)
	}
}

/// File Browser ///

local fb = {
	startdir = null
	sortdir = []
	prevdir = null
	prevdirarray = []
	file00 = null
	select0 = null
	root = false
	dir = null
}

function filebrowser1(file0){
	local extensions = {
		".png"	: 0xe90d
		".jpg"	: 0xe90d
		".jpeg"	: 0xe90d
		".psd"	: 0xe90d
		".gif"	: 0xe90d

		".txt"	: 0xe926
		".nut"	: 0xe926

		".mp3"	: 0xe911
		".wav"	: 0xe911

		".zip"	: 0xe92b
		".rar"	: 0xe92b

		".mp4"	: 0xe913
		".mkv"	: 0xe913
		".avi"	: 0xe913

		".doc"	: 0xeae1
		".docx"	: 0xeae1

		".xls"	: 0xeae2
		".xlsx"	: 0xeae2

		".pdf"	: 0xeadf

		".ttf"	: 0xea5c
		".otf"	: 0xea5c
	}
	local lastname = []
	local folderappend = []

	lastname.push( ltxt ("DEFAULT", TLNG) )
	lastname.push( ltxt ("Attract Folder", TLNG) )
	lastname.push( ltxt ("Arcadeflow Folder", TLNG) )
	lastname.push("..")

	folderappend.push(0)
	folderappend.push(0)
	folderappend.push(0)
	folderappend.push(0)

	for (local i = 4 ; i < fb.sortdir.len() ; i++){
		local isfile = !fe.path_test(fb.sortdir[i],PathTest.IsDirectory)
		local lastnametemp = split(fb.sortdir[i],"\\/")
		lastnametemp = (lastnametemp[lastnametemp.len()-1])
		lastname.push (lastnametemp)
		local extemp = ""
		if (isfile) {
			extemp = lastnametemp.slice(lastnametemp.len()-4,lastnametemp.len())
			try {extemp = extensions[extemp.tolower()]} catch (err) { extemp = ""}
		}
		folderappend.push (isfile ? extemp : 0xe92f)
	}

	zmenudraw (lastname,folderappend,null,fb.startdir,0xe930,4+fb.select0,false,false,false,false,
	function(out){
		fb.file00 = fb.startdir

		if (out == -1) {
			prfmenu.browsershowing = false
			AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values = file0
			optionsmenu1()
			return
		}
		if (out == 0) {
			prfmenu.browsershowing = false
			AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values = AF.prefs.defaults[AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].varname.toupper()]
			optionsmenu1()
			return
		}

		if ((out == 3) && fb.root ){
				fb.sortdir = letterdrives()
				fb.startdir = "Volumes"
		}
		else {
			fb.root = false

			// Updates startdir value with the selected file and update the browserfile
			fb.startdir = fb.sortdir[out]
			prfmenu.browserfile = fb.startdir

			// if startdir is not a directory, then startdir is the selection
			if (!fe.path_test(fb.startdir,PathTest.IsDirectory)) {
				prfmenu.browsershowing = false
				AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values = fb.startdir
				optionsmenu1()
				return (fb.startdir)
			}

			fb.dir = DirectoryListing( fb.startdir, true )

			fb.sortdir = []
			for (local i = 0 ; i < fb.dir.results.len() ; i++){
				if (fe.path_test(fb.dir.results[i],PathTest.IsDirectory)) fb.sortdir.push("0_"+fb.dir.results[i])
				else fb.sortdir.push("1_"+fb.dir.results[i])
			}
			fb.sortdir.sort(@(a,b) a.tolower() <=> b.tolower())
			for (local i = 0 ; i < fb.sortdir.len() ; i++){
				fb.sortdir[i] = fb.sortdir[i].slice(2,fb.sortdir[i].len())
			}
		}

		fb.select0 = fb.sortdir.find( ((fb.file00[fb.file00.len()-1].tochar() == "/") ? fb.file00.slice(0,fb.file00.len()-1) : fb.file00) )
		if (fb.select0 == null) fb.select0 = -1 //If there's no item found default to the ".." folder

		prfmenu.browserdir = fb.sortdir
		try {prfmenu.browserfile = fb.sortdir[fb.select0]} catch (err) {prfmenu.browserfile = ""}
		try {prfmenu.helppic.file_name = fb.sortdir[fb.select0]} catch (err) {prfmenu.helppic.file_name = "pics/transparent.png"}

		//decompound directory path
		fb.prevdirarray = split(fb.startdir,"\\/")

		// By default make previous directory equal to actual
		fb.prevdir = fb.startdir

		if (AF.prefs.driveletters.len() > 0) { // Prev directory and fb.root management for Windows
			if (fb.prevdirarray.len() > 1) {
				fb.prevdir = fb.prevdir.slice (0,-1 -1 * fb.prevdirarray[fb.prevdirarray.len()-1].len()) //NEW MAC
				if (fb.prevdir.len() == 2) fb.prevdir = fb.prevdir +"\\"
				fb.sortdir.insert (0,fb.prevdir)
				fb.root = false
			}
			else if ( (fb.prevdirarray.len() == 1)  ) {
				fb.sortdir.insert (0,fb.prevdir)
				fb.root = true
			}
			else  {
				fb.prevdir = "C:\\"
				fb.startdir = "Drives"
				fb.sortdir = letterdrives()
				prfmenu.browserdir = fb.sortdir
				fb.sortdir.insert(0,"C:\\")
			}
		}
		if ((AF.prefs.driveletters.len() == 0)) { // Prev directory and fb.root management for MacOS, Linux etc
			if (fb.prevdir[fb.prevdir.len()-1].tochar() != "/") {
				fb.prevdir = fb.prevdir + "/"
			}
			if ( fb.prevdirarray.len() > 0 ) fb.prevdir = fb.prevdir.slice (0, -1 -1 * fb.prevdirarray[fb.prevdirarray.len()-1].len())
			if (fb.prevdir != "")
				fb.sortdir.insert (0,fb.prevdir)
			else
				fb.sortdir.insert (0,fb.startdir)
		}

		fb.sortdir.insert (0,AF.folder)
		fb.sortdir.insert (0,FeConfigDirectory)
		fb.sortdir.insert (0,"")

		filebrowser1(file0)
	})





}

function filebrowser(file0){
	fb.file00 = file0
	prfmenu.browsershowing = true

	if (!file_exist(file0)) fb.file00 = ""

	fb.startdir = AF.folder
	local endchar = fb.file00.slice(fb.file00.len()-1,fb.file00.len())

	if ((endchar == "/") || (endchar == "\\")){
		fb.startdir = AF.folder+fb.file00
	}
	else if (fb.file00 != "") {
		local startdir0 = split(fb.file00,"\\/")
		fb.startdir = fb.file00.slice (0,-1 -1 * startdir0[startdir0.len()-1].len())
	}

	fb.dir = DirectoryListing( fb.startdir, true )

	fb.sortdir = []

	for (local i = 0 ; i < fb.dir.results.len() ; i++){
		if (fe.path_test(fb.dir.results[i],PathTest.IsDirectory)) fb.sortdir.push("0_"+fb.dir.results[i])
		else fb.sortdir.push("1_"+fb.dir.results[i])
	}
	fb.sortdir.sort(@(a,b) a.tolower() <=> b.tolower())
	for (local i = 0 ; i < fb.sortdir.len() ; i++){
		fb.sortdir[i] = fb.sortdir[i].slice(2,fb.sortdir[i].len())
	}

	fb.select0 = fb.sortdir.find(fb.file00)
	if (fb.select0 == null) fb.select0 = 0

	prfmenu.browserdir = fb.sortdir
	prfmenu.browserfile = fb.sortdir[fb.select0]
	// ADD IMAGE UPDATE HERE???
	prfmenu.helppic.file_name = fb.sortdir[fb.select0]

	local out = 0
	local dirtype = []
	fb.prevdirarray = split(fb.startdir,"\\/")

	fb.prevdir = fb.startdir
	fb.prevdir = fb.prevdir.slice (0,-1 -1 * fb.prevdirarray[fb.prevdirarray.len()-1].len())
	fb.sortdir.insert (0,fb.prevdir)
	fb.sortdir.insert (0,AF.folder)
	fb.sortdir.insert (0,FeConfigDirectory)
	fb.sortdir.insert (0,"")

	fb.root = false

	filebrowser1(file0)

	return (file0)
}


/// On Screen Keyboard ///

local keyboard_surface = fe.add_surface(overlay.w, overlay.h)
keyboard_surface.set_pos(overlay.x,overlay.y)
keyboard_surface.preserve_aspect_ratio = true
keyboard_surface.alpha = 255*0

local kb = {
	keys = {}
	keylow = 100

	secondary = false

	rt_stringkeys = "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ- <"
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
	// keyboard_surface.alpha = 255
	flowT.keyboard = startfade(flowT.keyboard,0.1,0.0)
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

/// Search Functions ///

function search_update_rule(){
	search.smart = keyboard_entrytext
	updatesearchdatamsg()
	mfz_apply(false)
}

function keyboard_search(){

	keyboard_select (0, vertical ? 1 : 0)

	keyboard_show("🔍",search.smart,
	function(){ //TYPE
		if (prf.LIVESEARCH) search_update_rule()
		return
	},
	function(){ //BACK
		if (umvisible) {
			frostshow()
			utilitymenu (umpresel)
		}
		return
	},
	function(){ //DONE
		if (!prf.LIVESEARCH) search_update_rule()
		if (!prf.LIVESEARCH) frosthide()
		if (umvisible) {
			frostshow()
			utilitymenu (umpresel)
		}
		return
	}
	)
}

prf.SHOWHIDDEN <- false

/// Tags & Favs management ///

// Gets the list of tags for the current romlist directly from Attract Mode folders
function tags_menu(){

	local tagsarray = []
	local tagstatus = []
	foreach (item, array in z_list.tagstable) {
		if ((item != "COMPLETED") && (item != "HIDDEN")) {
			tagsarray.push(item)
			tagstatus.push(0)
		}
	}
	tagsarray.sort (@(a,b) a.tolower()<=>b.tolower())

	tagsarray.insert (0,"HIDDEN")
	tagstatus.insert (0,0)
	tagsarray.insert (0,"COMPLETED")
	tagstatus.insert (0,0)


	for (local i = 0 ; i < tagsarray.len() ; i++){
		tagstatus[i] = (z_list.gametable[z_list.index].z_tags.find(tagsarray[i]) == null) ? 0xea0a : 0xea0b
	}

	tagsarray.push (prf.SHOWHIDDEN ? ltxt("Hide Hidden",TLNG) : ltxt("Show Hidden",TLNG))
	tagstatus.push (0)
	tagsarray.push (ltxt("New Tag",TLNG))
	tagstatus.push (0xeaee)

	zmenudraw (tagsarray,tagstatus,null,ltxt("TAGS",TLNG),0xeaef,0,false,false,true,false,
	function(out){
		if (out == -1) { //BACK
			frosthide()
			zmenuhide()
		}
		else if (out == tagsarray.len()-2){ //CHANGE HIDDEN STATUS
			zmenuhide()
			frosthide()
			prf.SHOWHIDDEN = !prf.SHOWHIDDEN
			mfz_apply(false)
		}
		else if (out == tagsarray.len()-1){ //ADD NEW TAG
			zmenuhide()
			flowT.zmenudecoration = startfade(flowT.zmenudecoration,0.2,0.0)
			add_new_tag()
		}
		else {
			if (tagstatus[out] == 0xea0a) {
				add_tag (tagsarray[out])
			}
			else {
				remove_tag (tagsarray[out])
			}
			zmenuhide()
			frosthide()
		}
		return
	})
}

// add_fav, add_tag, remove_fav and remove_tag work directly on the tag file on disk
// after the file has been edited, the initfromfile function is called to update the
// table in memory, then this data is used in the z_listcreate function

function add_fav(){
	local favfile = FeConfigDirectory+"romlists/" +  z_list.gametable[z_list.index].z_emulator +".tag"
	local favfilepresent = (fe.path_test( favfile, PathTest.IsFile ))

	if (!favfilepresent){
		local file = WriteTextFile(favfile)
		file.write_line(fe.game_info(Info.Name))
	}
	else {
		local outtxt = []
		local filein = ReadTextFile(favfile)
		while (!filein.eos()){
			local gamein = filein.read_line()
			if (gamein != fe.game_info(Info.Name)) outtxt.push (gamein)
		}
		outtxt.push (fe.game_info(Info.Name))
		local fileout = WriteTextFile(favfile)
		for (local i = 0 ; i < outtxt.len()-1;i++){
			fileout.write_line(outtxt[i]+"\n")
		}
		if (outtxt.len() >=1 ) fileout.write_line(outtxt[outtxt.len()-1])
	}

	z_list.boot[fe.list.index].z_favourite = "1"

	z_initfavsfromfiles()
	mfz_build(true)
	try{
		mfz_load()
		mfz_populatereverse()
	} catch(err){}
	mfz_apply(false)

}

function remove_fav (){
	local favfile = FeConfigDirectory+"romlists/" + z_list.gametable[z_list.index].z_emulator +".tag"
	local favfilepresent = (fe.path_test( favfile, PathTest.IsFile ))

	local outtxt = []
	local filein = ReadTextFile(favfile)

	while (!filein.eos()){
		local gamein = filein.read_line()
		if (gamein != fe.game_info(Info.Name)) outtxt.push (gamein)
	}

	if (outtxt.len() != -1)//WAS if (outtxt.len() == 0) remove (favfile)
	{
		local fileout = WriteTextFile(favfile)
		for (local i = 0 ; i < outtxt.len()-1;i++){
			fileout.write_line(outtxt[i]+"\n")
		}
		if (outtxt.len() >=1 ) fileout.write_line(outtxt[outtxt.len()-1])
	}

	//TEST92 SERVE DAVVERO?
	z_list.boot[fe.list.index].z_favourite = "0"

	z_initfavsfromfiles()
	mfz_build(true)
	try{
		mfz_load()
		mfz_populatereverse()
	} catch(err){}
	mfz_apply(false)
}

function add_tag (tagname){
	local romdir = (FeConfigDirectory+"romlists/"+fe.displays[fe.list.display_index].romlist)
	// Check if romdir exists
	local romdirpresent = (fe.path_test( romdir, PathTest.IsDirectory ))

	local tagfile = romdir+"/"+tagname.toupper()+".tag"
	local tagfilepresent = (fe.path_test( tagfile, PathTest.IsFile ))

	if (!romdirpresent) { // no tags directory for this romlist, it must be created
		system ("mkdir "+ap+romdir+ap) //TEST103
	}

	// If no romdir then create it and create a new tag file for that
	if (!tagfilepresent){
		local file = WriteTextFile(tagfile)
		file.write_line(fe.game_info(Info.Name))
	}
	else {
		local outtxt = []
		local filein = ReadTextFile(tagfile)
		while (!filein.eos()){
			local gamein = filein.read_line()
			if (gamein != fe.game_info(Info.Name)) outtxt.push (gamein)
		}
		outtxt.push (fe.game_info(Info.Name))
		local fileout = WriteTextFile(tagfile)
		for (local i = 0 ; i < outtxt.len()-1;i++){
			fileout.write_line(outtxt[i]+"\n")
		}
		if (outtxt.len() >=1 ) fileout.write_line(outtxt[outtxt.len()-1])
	}

	//TEST92 SERVE DAVVERO?
	z_list.boot[fe.list.index].z_tags.push (tagname)

	z_inittagsfromfiles()

	mfz_build(true)
	try{
		mfz_load()
		mfz_populatereverse()
	} catch(err){}
	mfz_apply(false)
}

function remove_tag (tagname){
	local romdir = (FeConfigDirectory+"romlists/"+fe.displays[fe.list.display_index].romlist)
	local tagfile = romdir+"/"+tagname+".tag"

	local outtxt = []
	local filein = ReadTextFile(tagfile)

	while (!filein.eos()){
		local gamein = filein.read_line()
		if (gamein != fe.game_info(Info.Name)) outtxt.push (gamein)
	}

	//if (outtxt.len() == 0) remove (tagfile)
	//else {
	if (outtxt.len() != -1){
		local fileout = WriteTextFile(tagfile)
		for (local i = 0 ; i < outtxt.len()-1;i++){
			fileout.write_line(outtxt[i]+"\n")
		}
		if (outtxt.len() >=1 ) fileout.write_line(outtxt[outtxt.len()-1])
	}
	//}

/*
	local arraystring = ""
	local temparray = split (z_list.boot[fe.list.index].z_tags, ";")
	foreach (i,item in temparray){
		if (item == tagname) temparray.remove(i)
	}
	if (temparray.len() > 0) {
		arraystring = ";"
		foreach(i, item in temparray){
			arraystring = arraystring + item + ";"
		}
	}

	z_list.boot[fe.list.index].z_tags = arraystring
*/

	foreach (i,item in z_list.boot[fe.list.index].z_tags) {
		if (item == tagname) z_list.boot[fe.list.index].z_tags.remove(i)
	}

	z_inittagsfromfiles()
	mfz_build(true)
	try{
		mfz_load()
		mfz_populatereverse()
	} catch(err){}
	mfz_apply(false)
}

function add_new_tag(){
	frostshow()
	keyboard_show("🏷 ","",
	function(){ //TYPE
		return
	},
	function(){ //BACK
		frosthide()
		return
	},
	function(){ //DONE
		frosthide()
		add_tag (keyboard_entrytext)
		return
	}
	)

}


/// History Page ///


local hist = {
	direction = 0,
	split_h = 0.55,
	scrollreset = false,
	panel_ar = prf.HISTORYSIZE //panel width/height 0.45, 0.65, 0.75
}

if (prf.HISTORYSIZE == -1) hist.panel_ar = (fl.w - fl.h)*1.0/fl.h

hist.split_h = (fl.w - (fl.h * hist.panel_ar)) * 1.0/fl.w


local hist_titleT = {
	x = fl.x + fl.w * hist.split_h + 15*scalerate,
	y = fl.y + 15 * scalerate,
	w = fl.w * (1.0 - hist.split_h) - 30 * scalerate,
	h = fl.h * 0.25 - 30 * scalerate
	transparency = 50
}

local hist_screenT = {
	x = fl.x,
	y = fl.y + (fl.h - fl.w*hist.split_h) * 0.5,
	w = fl.w * hist.split_h,
	h = fl.w * hist.split_h
}

hist_screenT.y += hist_screenT.y % 2.0
hist_screenT.w += hist_screenT.w % 2.0
hist_screenT.h += hist_screenT.h % 2.0

if (hist_screenT.h > fl.h){
	hist_screenT.x = fl.x + (fl.w*hist.split_h-fl.h)*0.5
	hist_screenT.y = fl.y
	hist_screenT.x += hist_screenT.x % 2.0
	hist_screenT.w = fl.h
	hist_screenT.w += hist_screenT.w % 2.0
	hist_screenT.h = fl.h
	hist_screenT.h += hist_screenT.h % 2.0
}

local hist_textT = {
	x = fl.x + fl.w * hist.split_h,
	y = fl.y + fl.h * 0.25,
	w = fl.w * (1.0-hist.split_h),
	h = fl.h * 0.75
}

if (vertical){

	if (prf.HISTORYSIZE == -1) hist.panel_ar = (fl.h - fl.w)*1.0/fl.w

	hist.split_h = (fl.h - (fl.w * hist.panel_ar)) * 1.0/fl.h

	hist_titleT.x = fl.x
	hist_titleT.y = fl.y + fl.h * hist.split_h
	hist_titleT.w = fl.w
	hist_titleT.h = fl.w * 0.2

	hist_screenT.x = fl.x + (fl.w-fl.h*hist.split_h)*0.5
	hist_screenT.x += hist_screenT.x % 2.0
	hist_screenT.y = fl.y
	hist_screenT.w = fl.h * hist.split_h
	hist_screenT.w += hist_screenT.w % 2.0
	hist_screenT.h = fl.h * hist.split_h
	hist_screenT.h += hist_screenT.h % 2.0

	if (hist_screenT.w > fl.w){
		hist_screenT.x = fl.x
		hist_screenT.y = fl.y + (fl.h * hist.split_h - fl.w)*0.5
		hist_screenT.y += hist_screenT.y % 2.0
		hist_screenT.w = fl.w
		hist_screenT.w += hist_screenT.w % 2.0
		hist_screenT.h = fl.w
		hist_screenT.h += hist_screenT.h % 2.0
	}

	hist_textT.x = fl.x
	hist_textT.y = fl.y + fl.h * hist.split_h + fl.w * 0.2
	hist_textT.w = fl.w
	hist_textT.h = fl.h * (1.0 - hist.split_h) - fl.w * 0.2
}

local shadowscale = 0.025

hist_titleT.x = hist_titleT.x+hist_titleT.w*shadowscale
hist_titleT.y = hist_titleT.y+hist_titleT.h*shadowscale
hist_titleT.w = hist_titleT.w*(1-shadowscale*2)
hist_titleT.h = hist_titleT.h*(1-shadowscale*2)


local historypadding = (hist_screenT.w * 0.025)
historypadding += historypadding % 2.0

local hist_curr_rom = ""
local history_surface = fe.add_surface(fl.w_os,fl.h_os)

/*
local hist_bg = history_surface.add_text ("",0,0,history_surface.width,history_surface.height)
hist_bg.set_bg_rgb(0,0,0)
hist_bg.bg_alpha = 1
*/

picture.bg_hist = history_surface.add_image("pics/black.png",0,0,fl.w_os,fl.h_os)
picture.bg_hist.alpha = 1

//TEST104
function groupalpha(alphain){
	if (prf.LAYERSNAP) {
		bgvidsurf.alpha = satin.vid * alphain/255.0
		bglay.pixelgrid.alpha = 50 * alphain/255.0
	}
	//picture.bg.alpha = alphain
	data_surface.alpha = alphain
	data_surface_sh_rt.alpha = themeT.themeshadow * alphain/255.0
	foreach (i, item in tilez){
		item.alphafade = alphain
		item.obj.alpha = item.alphazero * item.alphafade/255.0
	}
}

//TEST104
function groupvisible(visibility){
	bgvidsurf.visible = picture.bg.visible = data_surface.visible = data_surface_sh_rt.visible = visibility
}

function updatecustombg(){
	prf.BGCUSTOM = prf.BGCUSTOM0
	prf.BGCUSTOMHISTORY = prf.BGCUSTOMHISTORY0

	if (prf.BGPERDISPLAY) {
		local artname = FeConfigDirectory + "menu-art/bgmain/" + fe.displays[fe.list.display_index].name
		if (file_exist(artname+".jpg")) prf.BGCUSTOM = artname+".jpg"
		if (file_exist(artname+".png")) prf.BGCUSTOM = artname+".png"

		local artname = FeConfigDirectory + "menu-art/bghistory/" + fe.displays[fe.list.display_index].name
		if (file_exist(artname+".jpg")) prf.BGCUSTOMHISTORY = artname+".jpg"
		if (file_exist(artname+".png")) prf.BGCUSTOMHISTORY = artname+".png"

	}
	picture.bg.visible = false
	picture.bg_hist.visible = false

	if (prf.BGCUSTOM != "") {

		picture.bg.file_name = prf.BGCUSTOM

		bgpicT.ar = (picture.bg.texture_width*1.0) / picture.bg.texture_height

		if (!prf.BGCUSTOMSTRETCH){
			if (bgpicT.ar >= fl.w_os/(fl.h_os*1.0)){
				bgpicT.h = fl.h_os
				bgpicT.w = bgpicT.h * bgpicT.ar
				bgpicT.y = 0
				bgpicT.x = - (bgpicT.w - fl.w_os)*0.5
			}
			else {
				bgpicT.w = fl.w_os
				bgpicT.h = bgpicT.w / bgpicT.ar*1.0
				bgpicT.y = - (bgpicT.h - fl.h_os)*0.5
				bgpicT.x = 0
			}
		}
		else {
			bgpicT.w = fl.w_os
			bgpicT.h = fl.h_os
			bgpicT.y = 0
			bgpicT.x = 0
		}
		picture.bg.set_pos(bgpicT.x,bgpicT.y,bgpicT.w,bgpicT.h)
		picture.bg.visible=true
	}
	else picture.bg.file_name = "pics/transparent.png"

	if ((prf.BGCUSTOMHISTORY != "") || (prf.BGCUSTOM != "")) {
		picture.bg_hist.alpha = 255
		picture.bg_hist.file_name = (((prf.BGCUSTOMHISTORY != "") ? prf.BGCUSTOMHISTORY : prf.BGCUSTOM))
		picture.bg_hist.visible = false
		bgpicT.ar = (picture.bg_hist.texture_width*1.0) / picture.bg_hist.texture_height

		if (!prf.BGCUSTOMHISTORYSTRETCH){
			if (bgpicT.ar >= fl.w_os/(fl.h_os*1.0)){
				bgpicT.h = fl.h_os
				bgpicT.w = bgpicT.h * bgpicT.ar
				bgpicT.y = 0
				bgpicT.x = - (bgpicT.w - fl.w_os)*0.5
			}
			else {
				bgpicT.w = fl.w_os
				bgpicT.h = bgpicT.w / bgpicT.ar*1.0
				bgpicT.y = - (bgpicT.h - fl.h_os)*0.5
				bgpicT.x = 0
			}
		}
		else {
			bgpicT.w = fl.w_os
			bgpicT.h = fl.h_os
			bgpicT.y = 0
			bgpicT.x = 0
		}
		picture.bg_hist.set_pos(bgpicT.x,bgpicT.y,bgpicT.w,bgpicT.h)
		picture.bg_hist.visible=true
	}
	picture.bg_hist.visible=true

}

updatecustombg()

local histgr = {
	black = null
	g1 = null
	g2 = null
}

if (!vertical){
	histgr.black = history_surface.add_image("pics/black.png",0,0,fl.w*hist.split_h+0.5*(fl.w_os-fl.w),fl.h_os)
	histgr.g1 = history_surface.add_image("wgradientT.png",0,0,fl.w*hist.split_h+0.5*(fl.w_os-fl.w),fl.h_os*0.5)
	histgr.g2 = history_surface.add_image("wgradientB.png",0,fl.h_os*0.5,fl.w*hist.split_h+0.5*(fl.w_os-fl.w),fl.h_os*0.5)
}
else{
	histgr.black = history_surface.add_image("pics/black.png",0,0,fl.w_os,fl.h*hist.split_h+0.5*(fl.h_os-fl.h))
	histgr.g1 = history_surface.add_image("wgradientL.png",0,0,fl.w_os*0.5,fl.h*hist.split_h+0.5*(fl.h_os-fl.h))
	histgr.g2 = history_surface.add_image("wgradientR.png",fl.w_os*0.5,0,fl.w_os*0.5,fl.h*hist.split_h+0.5*(fl.h_os-fl.h))
}

histgr.black.set_rgb (0,0,0)
histgr.g1.set_rgb (0,0,0)
histgr.g2.set_rgb (0,0,0)

histgr.g1.alpha = histgr.g2.alpha = (prf.DARKPANEL == null ? 0 : 150)
histgr.black.alpha =  (prf.DARKPANEL == null ? 0 : (prf.DARKPANEL == true ? 180 : 50))


local hist_white = null

if (prf.HISTORYPANEL){
	if (vertical) {
		hist_white = history_surface.add_text("",0,fl.y + fl.h*hist.split_h,hist_textT.w+(fl.w_os-fl.w),fl.h-hist_screenT.h+0.5*(fl.h_os-fl.h))
	}
	else{
		hist_white = history_surface.add_text("",hist_textT.x,0,hist_textT.w + 0.5*(fl.w_os-fl.w),fl.h_os)
	}
	hist_white.set_bg_rgb(255,255,255)
	hist_white.bg_alpha = 200
}

local hist_title = history_surface.add_image ("pics/transparent.png",hist_titleT.x,hist_titleT.y,hist_titleT.w,hist_titleT.h)
hist_title.preserve_aspect_ratio = true


local hist_title_top = null
local hist_titletxt_bot = null



if (prf.HISTORYPANEL){
	hist_title_top = history_surface.add_clone (hist_title)

	hist_title_top.preserve_aspect_ratio = true

	hist_title.set_pos (hist_titleT.x-hist_titleT.w*shadowscale ,hist_titleT.y+2*shadowscale*hist_titleT.h,hist_titleT.w*(1+shadowscale*2),hist_titleT.h*(1+shadowscale*2))
	hist_title.set_rgb(0,0,0)
	hist_title.alpha = hist_titleT.transparency

	hist_titletxt_bot = history_surface.add_text("...",hist_title.x, hist_title.y, hist_title.width,hist_title.height)

	hist_titletxt_bot.char_size = 150*scalerate
	hist_titletxt_bot.word_wrap = true
	hist_titletxt_bot.margin = 0
	hist_titletxt_bot.align = Align.MiddleCentre
	hist_titletxt_bot.char_spacing = 0.7

	hist_titletxt_bot.font = uifonts.arcadeborder
	hist_titletxt_bot.line_spacing = 0.6
	hist_titletxt_bot.set_rgb(0,0,0)
	hist_titletxt_bot.alpha = hist_titleT.transparency

}

local hist_titletxt_bd = history_surface.add_text("...",hist_titleT.x,hist_titleT.y,hist_titleT.w,hist_titleT.h)
local hist_titletxt = history_surface.add_text("...",hist_titleT.x,hist_titleT.y,hist_titleT.w,hist_titleT.h)

hist_titletxt_bd.char_size = hist_titletxt.char_size = 150*scalerate
hist_titletxt_bd.word_wrap = hist_titletxt.word_wrap = true
hist_titletxt_bd.margin = hist_titletxt.margin = 0
hist_titletxt_bd.align = hist_titletxt.align = Align.MiddleCentre
hist_titletxt_bd.char_spacing = hist_titletxt.char_spacing = 0.7

hist_titletxt_bd.font = uifonts.arcadeborder
hist_titletxt_bd.line_spacing = 0.6
hist_titletxt_bd.set_rgb (80,80,80)
hist_titletxt_bd.alpha = 200
hist_titletxt_bd.set_rgb (135,135,135)
hist_titletxt_bd.alpha = 255

hist_titletxt.font = uifonts.arcade
hist_titletxt.line_spacing = 0.6

local CRTprf = null

if (prf.SCANLINEMODE == "scanlines"){
	CRTprf = {
		aperature_type = 0.0
		hardScan = -15.0
		hardPix = -2.0
		maskDark = 0.4
		maskLight = 1.5
		saturation = 1.0
		tint = 0.0
		blackClip = 0.1
		brightMult = 1.4
		distortion = 0.2
		cornersize = 0.05
		cornersmooth = 60
		scanresample = 1.0
	}
}

if (prf.SCANLINEMODE == "aperture"){
	CRTprf = {
		aperature_type = 1.0
		hardScan = -3.0
		hardPix = -2.0
		maskDark = 0.6
		maskLight = 1.3
		saturation = 1.0
		tint = 0.0
		blackClip = 0.1
		brightMult = 1.1
		distortion = 0.2
		cornersize = 0.05
		cornersmooth = 60
		scanresample = 1.0
	}
}

if (prf.SCANLINEMODE == "halfres"){
	CRTprf = {
		aperature_type = 0.0
		hardScan = -15.0
		hardPix = -4.0
		maskDark = 0.4
		maskLight = 1.5
		saturation = 1.0
		tint = 0.0
		blackClip = 0.1
		brightMult = 1.4
		distortion = 0.2
		cornersize = 0.05
		cornersmooth = 60
		scanresample = 0.5
	}
}

if (prf.SCANLINEMODE == "none"){
	CRTprf = {
		aperature_type = 0.0
		hardScan = -3.0
		hardPix = -2.0
		maskDark = 0.4
		maskLight = 1.5
		saturation = 1.0
		tint = 0.0
		blackClip = 0.1
		brightMult = 1.0
		distortion = 0.2
		cornersize = 0.05
		cornersmooth = 60
		scanresample = 1.0
	}
}

local LCDprf = null

if (prf.LCDMODE == "matrix"){
	LCDprf = {
		matrix = 1.0
		scaler = 1.0
	}
}
if (prf.LCDMODE == "halfres"){
	LCDprf = {
		matrix = 1.0
		scaler = 0.5
	}
}
if (prf.LCDMODE == "none"){
	LCDprf = {
		matrix = 0.0
		scaler = 1.0
	}
}

local shader_lottes = null;
shader_lottes=fe.add_shader(Shader.VertexAndFragment,"glsl/CRTL-geom_vsh.glsl","glsl/CRTL-geom_fsh.glsl");
shader_lottes.set_param ("aperature_type", CRTprf.aperature_type); // 0.0 = none, 1.0 = TV style, 2.0 = Aperture grille, 3.0 = VGA
shader_lottes.set_param ("hardScan", CRTprf.hardScan);			// Hardness of Scanline 0.0 = none -8.0 = soft -16.0 = medium
shader_lottes.set_param ("hardPix", CRTprf.hardPix);			// Hardness of pixels in scanline -2.0 = soft, -4.0 = hard
shader_lottes.set_param ("maskDark",CRTprf.maskDark);			// Sets how dark a "dark subpixel" is in the aperture pattern.
shader_lottes.set_param ("maskLight", CRTprf.maskLight);		// Sets how dark a "bright subpixel" is in the aperture pattern
shader_lottes.set_param ("saturation", CRTprf.saturation);	// 1.0 is normal saturation. Increase as needed.
shader_lottes.set_param ("tint", CRTprf.tint);					// 0.0 is 0.0 degrees of Tint. Adjust as needed.
shader_lottes.set_param ("blackClip", CRTprf.blackClip);		// Drops the final color value by this amount if GAMMA_CONTRAST_BOOST is defined
shader_lottes.set_param ("brightMult", CRTprf.brightMult);	// Multiplies the color values by this amount if GAMMA_CONTRAST_BOOST is defined
shader_lottes.set_param ("distortion", CRTprf.distortion);	// 0.0 to 0.2 seems right
shader_lottes.set_param ("cornersize", CRTprf.cornersize);	// 0.0 to 0.1
shader_lottes.set_param ("cornersmooth", CRTprf.cornersmooth); // Reduce jagginess of corners
shader_lottes.set_param ("vignettebase", 0.3,1.0,2.0);			// base lightness for vignette

shader_lottes.set_texture_param("texture")

local pixelpic = fe.add_image("pixel8.png",0,0)
pixelpic.visible = false
local shader_lcd = null
shader_lcd = fe.add_shader (Shader.Fragment,"glsl/lcd.glsl")
shader_lcd.set_texture_param( "texture")
shader_lcd.set_texture_param( "pixel",pixelpic)
shader_lcd.set_param ("pixelsize", 10,10)
shader_lcd.set_param ("matrix", LCDprf.matrix)
shader_lcd.set_param ("color1",0,0,0)
shader_lcd.set_param ("color2",0,0,0)
shader_lcd.set_param ("remap", 0.0)
shader_lcd.set_param ("plusminus", 1.0)
shader_lcd.set_param ("lcdcolor", 0.0)

// History text surface
local hist_text_surf = history_surface.add_surface( hist_textT.w, hist_textT.h )
hist_text_surf.set_pos (hist_textT.x, hist_textT.y )

local hist_text = hist_text_surf.add_text( "", 0,0, hist_textT.w, hist_textT.h )
hist_text.char_size = (prf.LOWRES ? 55*scalerate : (40 * scalerate > 8 ? 40*scalerate : 8))
hist_text.align = Align.TopCentre

hist_text.first_line_hint = 1

hist_text.visible = true
if (prf.HISTORYPANEL) {
	hist_text.set_rgb(themeT.themehistorytextcolor,themeT.themehistorytextcolor,themeT.themehistorytextcolor)
	hist_text_surf.set_rgb(themeT.themehistorytextcolor,themeT.themehistorytextcolor,themeT.themehistorytextcolor)
}
else {
	hist_text.set_rgb(themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)
	hist_text_surf.set_rgb(themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)
}

local gradshader = fe.add_shader (Shader.Fragment, "glsl/blackgrad2.glsl")
gradshader.set_texture_param( "texture")
gradshader.set_param ("limits", 40 * scalerate * 1.7 / hist_textT.h , 40 * scalerate * 5.0 / hist_textT.h)

hist_text_surf.shader = noshader

local histglow = {
	w = hist_screenT.w - 2 * historypadding
	x = hist_screenT.x + historypadding
	y = hist_screenT.y + historypadding
}

// shadow parameters
local shadow = {
	radius = histglow.w*0.25
	downsample = 26.0/histglow.w
	enlarge = 0.97
}

// creation of render trget surface
local shadowsurf_rt = history_surface.add_surface (shadow.downsample * (histglow.w + 2 * shadow.radius), shadow.downsample * (histglow.w + 2 * shadow.radius))
// creation of second surface
local shadowsurf_2 = shadowsurf_rt.add_surface (shadowsurf_rt.width, shadowsurf_rt.height)
// creation of first surface with safeguards area
local shadowsurf_1 = shadowsurf_2.add_surface (shadowsurf_rt.width, shadowsurf_rt.height)

// add a clone of the picture to topmost surface
local hist_glow_pic = shadowsurf_1.add_image("pics/transparent.png",(shadow.radius-0.5*histglow.w*(shadow.enlarge - 1.0))*shadow.downsample,(shadow.radius-0.5*histglow.w*(shadow.enlarge - 1.0))*shadow.downsample,histglow.w*shadow.enlarge*shadow.downsample,histglow.w*shadow.enlarge*shadow.downsample)
hist_glow_pic.mipmap = 1
hist_glow_pic.preserve_aspect_ratio = false //TEST88 era true

local hist_glow_shader = fe.add_shader(Shader.Fragment, "glsl/colormapper.glsl")
hist_glow_shader.set_texture_param ("texture")
hist_glow_shader.set_param ("remap",0.0)
hist_glow_shader.set_param ("lcdcolor",0.0)
hist_glow_shader.set_param ("color1",0,0,0)
hist_glow_shader.set_param ("color2",0,0,0)
hist_glow_pic.shader = hist_glow_shader

local blursizeglow = {
	x = 1.0/shadowsurf_rt.width
	y = 1.0/shadowsurf_rt.height
}

local kerneldat = {
	size = shadow.downsample * (shadow.radius * 2) + 1
	sigma = shadow.downsample * shadow.radius * 0.3
}

local shadowshader = {
	h = fe.add_shader( Shader.VertexAndFragment, "glsl/gauss_kern13_v.glsl","glsl/gauss_kern13_f.glsl" )
	v = fe.add_shader( Shader.VertexAndFragment, "glsl/gauss_kern13_v.glsl","glsl/gauss_kern13_f.glsl" )
	glow = fe.add_shader (Shader.Fragment, "glsl/testglow.glsl")
}
gaussshader (shadowshader.h,13.0,2.0,blursizeglow.x, 0.0)
gaussshader (shadowshader.v,13.0,2.0,0.0,blursizeglow.y)

shadowsurf_1.shader = noshader
shadowsurf_2.shader = noshader
shadowsurf_rt.shader = noshader

shadowsurf_rt.set_pos (histglow.x-shadow.radius,histglow.y-shadow.radius, histglow.w + 2 * shadow.radius , histglow.w + 2 * shadow.radius)

//local hist_screen_ar = hist_screenT.w * 1.0 / hist_screenT.h

local hist_screensurf = history_surface.add_surface (hist_screenT.w-2.0*historypadding,hist_screenT.h-2.0*historypadding)
hist_screensurf.set_pos(hist_screenT.x+historypadding,hist_screenT.y+historypadding)

local hist_screen = hist_screensurf.add_clone(hist_glow_pic)
hist_screen.set_pos(0,0,hist_screenT.w-2.0*historypadding,hist_screenT.h-2.0*historypadding)
hist_screen.preserve_aspect_ratio = false //TEST88 era true
if (!prf.AUDIOVIDHISTORY) hist_screen.video_flags = Vid.NoAudio
hist_screen.shader = noshader

local hist_over = {
	overlaybuttonsdata = {}
	surface = null
	overbuttons = null
	overbuttons2 = null
	overcontrol = null
	picscale = hist_screenT.w*1.0/800.0
	bt = []
	btsh = []
}

if (prf.CONTROLOVERLAY){

	hist_over.overlaybuttonsdata["6"] <- {
		pic = "6.png"
		pica = "6a.png"
		btxy = [ [432.0,28.0],[556.0,20.0],[673.0,60.0],[290.0,192.0],[500.0,210.0],[660.0,200.0]]
		btalign = [Align.TopLeft,Align.TopLeft,Align.TopLeft,Align.BottomRight,Align.BottomLeft,Align.BottomLeft]
	}
	hist_over.overlaybuttonsdata["4"] <- {
		pic = "4.png"
		pica = "4a.png"
		btxy =[ [275.0,190.0],[430.0,28.0],[556.0,14.0],[684.0,48.0],[0,0],[0,0]]
		btalign = [Align.BottomRight,Align.TopLeft,Align.TopLeft,Align.TopLeft,Align.TopLeft,Align.TopLeft]
	}
	hist_over.overlaybuttonsdata["3"] <- {
		pic = "3.png"
		pica = "3a.png"
		btxy = [ [426.,57.0],[550.0,43.0],[667.0,87.0],[0,0],[0,0],[0,0]]
		btalign = [Align.TopLeft,Align.TopLeft,Align.TopLeft,Align.TopLeft,Align.TopLeft,Align.TopLeft]
	}
	hist_over.overlaybuttonsdata["2"] <- {
		pic = "2.png"
		pica = "2a.png"
		btxy = [ [426.0,57.0],[555.0,43.0],[0,0],[0,0],[0,0],[0,0]]
		btalign = [Align.TopLeft,Align.TopLeft,Align.TopLeft,Align.TopLeft,Align.TopLeft,Align.TopLeft]
	}
	hist_over.overlaybuttonsdata["1"] <- {
		pic = "1.png"
		pica = "1a.png"
		btxy = [ [610.0,53.0],[0,0],[0,0],[0,0],[0,0],[0,0]]
		btalign = [Align.TopLeft,Align.TopLeft,Align.TopLeft,Align.TopLeft,Align.TopLeft,Align.TopLeft]
	}
	hist_over.overlaybuttonsdata["0"] <- {
		pic = "pics/transparent.png"
		pica = "pics/transparent.png"
		btxy = [ [0,0],[0,0],[0,0],[0,0],[0,0],[0,0]]
		btalign = [Align.TopLeft,Align.TopLeft,Align.TopLeft,Align.TopLeft,Align.TopLeft,Align.TopLeft]
	}

	hist_over.surface = history_surface.add_surface(hist_screenT.w,hist_screenT.h*(280.0/800.0))

	hist_over.surface.set_pos (hist_screenT.x,hist_screenT.y+hist_screenT.h*(520.0/800.0))
	hist_over.overcontrol = hist_over.surface.add_image("pics/transparent.png",0,0,hist_over.surface.width,hist_over.surface.height)
	hist_over.overbuttons = hist_over.surface.add_image("pics/transparent.png",0,0,hist_over.surface.width,hist_over.surface.height)
	hist_over.overbuttons2 = hist_over.surface.add_image("pics/transparent.png",0,0,hist_over.surface.width,hist_over.surface.height)
	hist_over.overbuttons.alpha = hist_over.overcontrol.alpha = 220

	for (local i = 0 ; i < 6 ; i++){
		hist_over.btsh.push (hist_over.surface.add_text(i,0,0,120 * hist_over.picscale, 65 * hist_over.picscale))
		hist_over.bt.push (hist_over.surface.add_text(i,0,0,120 * hist_over.picscale, 65 * hist_over.picscale))
		hist_over.btsh[i].align = hist_over.bt[i].align = Align.Left
		hist_over.btsh[i].char_size = hist_over.bt[i].char_size = 22*hist_over.picscale
		hist_over.btsh[i].word_wrap = hist_over.bt[i].word_wrap = true
		hist_over.btsh[i].margin = hist_over.bt[i].margin = 0
		hist_over.btsh[i].line_spacing = hist_over.bt[i].line_spacing = 0.75
		hist_over.btsh[i].font = hist_over.bt[i].font = uifonts.gui
		hist_over.btsh[i].set_rgb(80,80,80)
		hist_over.btsh[i].alpha = 80
	//	hist_over.bt[i].set_bg_rgb(200,0,0)
	}
}

history_surface.visible = false
history_surface.alpha = 0
history_surface.set_pos(0,0)

function history_updateoverlay(){

	try{hist_over.overcontrol.file_name = "overlay_"+controller_pic (z_list.gametable[z_list.index].z_control)}catch(err){}

	local commands = []


	local numbuttons = z_list.gametable[z_list.index].z_buttons
	local labeldata = hist_over.overlaybuttonsdata["0"]
	try{labeldata = hist_over.overlaybuttonsdata[numbuttons]}catch(err){}
	for (local i = 0 ; i < 6 ; i++){
		hist_over.bt[i].set_pos (hist_over.picscale*labeldata.btxy[i][0],hist_over.picscale*labeldata.btxy[i][1])
		hist_over.btsh[i].set_pos (hist_over.picscale*labeldata.btxy[i][0] + 3*scalerate,hist_over.picscale*labeldata.btxy[i][1]+5*scalerate)
		hist_over.btsh[i].align = hist_over.bt[i].align = labeldata.btalign[i]
		hist_over.btsh[i].msg = hist_over.bt[i].msg =""
	}

	local rom = fe.game_info( Info.Name )

	local commands_dat = []
	local commands_scrape = []
	try {commands_dat = commandtable[rom]}catch(err){}
	try {commands_scrape = parsecommands(z_list.gametable[z_list.index].z_commands)}catch(err){}
	if (commands_scrape.len() == 0) commands = commands_dat else commands = commands_scrape

	if (commands.len() > 0){
		if (numbuttons == "") numbuttons = "0"
		try{hist_over.overbuttons2.file_name = "overlay_button_images/"+numbuttons+"over.png"}catch(err){}
		for (local i = 0 ; i < min(commands.len(),min(6,numbuttons.tointeger())) ; i++){
			hist_over.btsh[i].msg = hist_over.bt[i].msg = commands[i].toupper()
		}
	}
	else {
		hist_over.overbuttons2.file_name = "pics/transparent.png"
	}
		try{hist_over.overbuttons.file_name = "overlay_button_images/"+numbuttons+".png"}catch(err){}
}


function history_updatesnap(){
	hist_screen.file_name = fe.get_art ("snap")
	hist_screen.shader = (islcd(0,0) ? shader_lcd : (prf.CRTGEOMETRY ? shader_lottes : noshader))

	local crt_deformed = (!islcd(0,0) && prf.CRTGEOMETRY)

	local remapdata = colormapper[recolorise(0,0)]

	hist_screen.shader.set_param ("remap",remapdata.remap)
	hist_glow_shader.set_param ("remap",remapdata.remap)

	hist_screen.shader.set_param ("lcdcolor",remapdata.lcdcolor)
	hist_glow_shader.set_param ("lcdcolor",remapdata.lcdcolor)

	hist_glow_shader.set_param ("color1", remapdata.a.R, remapdata.a.G, remapdata.a.B)
	hist_glow_shader.set_param ("color2", remapdata.b.R, remapdata.b.G, remapdata.b.B)
	hist_screen.shader.set_param ("color1", remapdata.a.R, remapdata.a.G, remapdata.a.B)
	hist_screen.shader.set_param ("color2", remapdata.b.R, remapdata.b.G, remapdata.b.B)

	hist_screen.shader.set_param ("hsv",remapdata.hsv[0],remapdata.hsv[1],remapdata.hsv[2])
	hist_glow_shader.set_param ("hsv",remapdata.hsv[0],remapdata.hsv[1],remapdata.hsv[2])

	/*
	if (recolorise(0,0) == "LCDGBA"){
		hist_screen.shader.set_param ("remap",0.0)
		hist_glow_shader.set_param ("remap",0.0)
		hist_screen.shader.set_param ("lcdcolor",1.0)
		hist_glow_shader.set_param ("lcdcolor",1.0)
	}
	else if (recolorise(0,0) != "NONE") {
		local remapcolor = recolorise(0,0)
		//local localcolor = ( gbrgb[remapcolor] )

		local localcolor =  {
			a = colormapper[remapcolor].a
			b = colormapper[remapcolor].b
		}

		hist_screen.shader.set_param ("lcdcolor",0.0)
		hist_glow_shader.set_param ("lcdcolor",0.0)

		hist_screen.shader.set_param ("hsv",0.0,0.0,0.0)
		hist_glow_shader.set_param ("hsv",0.0,0.0,0.0)

		hist_screen.shader.set_param ("remap",colormapper[remapcolor].remap)
		hist_glow_shader.set_param ("remap",colormapper[remapcolor].remap)
		hist_glow_shader.set_param ("color1", localcolor.a.R, localcolor.a.G, localcolor.a.B)
		hist_glow_shader.set_param ("color2", localcolor.b.R, localcolor.b.G, localcolor.b.B)
		hist_screen.shader.set_param ("color1", localcolor.a.R, localcolor.a.G, localcolor.a.B)
		hist_screen.shader.set_param ("color2", localcolor.b.R, localcolor.b.G, localcolor.b.B)
	}
	else{
		hist_screen.shader.set_param ("remap",0.0)
		hist_glow_shader.set_param ("remap",0.0)
		hist_screen.shader.set_param ("lcdcolor",0.0)
		hist_glow_shader.set_param ("lcdcolor",0.0)
		hist_screen.shader.set_param ("hsv",0.0,0.0,0.0)
		hist_glow_shader.set_param ("hsv",0.0,0.0,0.0)
	}
*/
	if (islcd(0,0)) hist_screen.shader.set_param ("plusminus",(recolorise(0,0) == "NONE" || recolorise (0,0) == "LCDGBA") ? -1.0 : 1.0)

	shadowsurf_1.shader = shadowshader.h
	shadowsurf_2.shader = shadowshader.v
	shadowsurf_rt.shader = shadowshader.glow

	local histAR = getAR(0,hist_screen,0,false)
	local ARdata = ARprocess(histAR)

	local hist_screen_size = hist_screenT.w-2.0*historypadding

	hist_screen.width = hist_screen_size * ARdata.w * (crt_deformed ? 680.0/500.0 : 620.0/500.0)
	hist_screen.height = hist_screen_size * ARdata.h * (crt_deformed ? 680.0/500.0 : 620.0/500.0)

	hist_screen.x = ( hist_screen_size - hist_screen.width ) * 0.5
	hist_screen.y = ( hist_screen_size - hist_screen.height ) * 0.5

	local hist_glow_size = histglow.w*shadow.enlarge*shadow.downsample
	hist_glow_pic.width = hist_glow_size * ARdata.w * (crt_deformed ? 680.0/500.0 : 620.0/500.0)
	hist_glow_pic.height = hist_glow_size * ARdata.h * (crt_deformed ? 680.0/500.0 : 620.0/500.0)
	hist_glow_pic.x = (shadow.radius-0.5*histglow.w*(shadow.enlarge - 1.0))*shadow.downsample + ( hist_glow_size - hist_glow_pic.width ) * 0.5
	hist_glow_pic.y = (shadow.radius-0.5*histglow.w*(shadow.enlarge - 1.0))*shadow.downsample + ( hist_glow_size - hist_glow_pic.height ) * 0.5

	//local hist_glow_pic = shadowsurf_1.add_image("pics/transparent.png",(shadow.radius-0.5*histglow.w*(shadow.enlarge - 1.0))*shadow.downsample,(shadow.radius-0.5*histglow.w*(shadow.enlarge - 1.0))*shadow.downsample,histglow.w*shadow.enlarge*shadow.downsample,histglow.w*shadow.enlarge*shadow.downsample)

	//hist_screen.visible = false //TEST99XXX

	local nativeres = null

	try{
		nativeres = [system_data[fe.game_info(Info.System).tolower()].w , system_data[fe.game_info(Info.System).tolower()].h]
		if ((system_data[fe.game_info(Info.System).tolower()].ar < 0) && (hist_screen.texture_width < hist_screen.texture_height)){
			nativeres.reverse()
		}
	}
	catch (err){
		nativeres = [hist_screen.texture_width,hist_screen.texture_height]
	}

	if ( (nativeres[0] == 0) && (nativeres[1] == 0) ) {
		nativeres = [hist_screen.texture_width,hist_screen.texture_height]
	}


	if (!islcd(0,0)){
		hist_screen.smooth = true
		hist_screen.shader.set_param ("vert", (nativeres[0] >= nativeres[1] ? 0.0 : 1.0));
		hist_screen.shader.set_param ("color_texture_sz", nativeres[0]*CRTprf.scanresample, nativeres[1]*CRTprf.scanresample);
		hist_screen.shader.set_param ("color_texture_pow2_sz", nativeres[0]*CRTprf.scanresample, nativeres[1]*CRTprf.scanresample);
	}
	else {
		hist_screen.smooth = true
		hist_screen.shader.set_param ("pixelsize", 1.0*nativeres[0]*LCDprf.scaler,1.0*nativeres[1]*LCDprf.scaler )
	}
}

function history_updatetext(){
	hist_title.file_name = fe.get_art ("wheel")
	hist_text.first_line_hint = 1

	local char_rows = ( ((hist_titleT.w/hist_titleT.h) > 3.0) ? 2 : 3)
	local charfontsize = 1.1*hist_titleT.h/char_rows
	local char_cols = floor (hist_titleT.w / (charfontsize*0.6))

	local hist_logotitle = wrapme( gamename2 (z_list.gametable[z_list.index].z_felistindex),char_cols,char_rows )

	hist_titletxt_bd.msg = hist_titletxt.msg = hist_logotitle.text
	if (prf.HISTORYPANEL) hist_titletxt_bot.msg = hist_logotitle.text

	hist_titletxt_bd.char_size = hist_titletxt.char_size = min( ((charfontsize*0.95)*char_cols)/hist_logotitle.cols , ((charfontsize*0.95)*char_rows)/hist_logotitle.rows )

	if (prf.HISTORYPANEL) hist_titletxt_bot.char_size = hist_titletxt.char_size * (hist_titletxt_bot.width/hist_titletxt.width)

	hist_titletxt_bd.x = hist_titletxt.x + 0.015 * hist_titletxt.char_size
	hist_titletxt_bd.y = hist_titletxt.y - 0.025 * hist_titletxt.char_size

	hist_titletxt_bd.visible = hist_titletxt.visible = (hist_title.subimg_height == 0)
	if (prf.HISTORYPANEL) hist_titletxt_bot.visible = (hist_title.subimg_height == 0)

	hist_text_surf.shader = gradshader

	local sys = split( fe.game_info( Info.System ), ";" )
	local rom = fe.game_info( Info.Name )
	local hist_text_tempmessage = ""
	local hist_text_premessage = []

	if (prf.HISTMININAME) {
		hist_text_tempmessage =  ("\n"+ gamename1(z_list.gametable[z_list.index].z_title) + "\n")
	}
	else {
		local iline = 0
		//first line
		hist_text_premessage.push ("\n"+ z_list.gametable[z_list.index].z_title + "\n©"+ z_list.gametable[z_list.index].z_year + " "+ z_list.gametable[z_list.index].z_manufacturer + (z_list.gametable[z_list.index].z_system!="" ? " ("+ z_list.gametable[z_list.index].z_system+")" : ""))

		//second line
		iline++
		hist_text_premessage.push ("")
		if (z_list.gametable[z_list.index].z_category != "") hist_text_premessage[iline] = hist_text_premessage[iline] +" "+ gly(0xe902) +" "+ z_list.gametable[z_list.index].z_category+" "
		if (z_list.gametable[z_list.index].z_players != "") hist_text_premessage[iline] = hist_text_premessage[iline] + " "+gly(0xe900) +" "+ z_list.gametable[z_list.index].z_players+" "
		if (z_list.gametable[z_list.index].z_buttons != "") hist_text_premessage[iline] = hist_text_premessage[iline] +" "+ gly(0xe901) +" "+ z_list.gametable[z_list.index].z_buttons+" "

		//Third line
		iline++
		hist_text_premessage.push ("")
		if (z_list.gametable[z_list.index].z_rating != "") hist_text_premessage[iline] = hist_text_premessage[iline] +" "+ gly(0xe904) +" "+ z_list.gametable[z_list.index].z_rating+" "
		if (z_list.gametable[z_list.index].z_series != "") hist_text_premessage[iline] = hist_text_premessage[iline] +" "+ gly(0xe905) +" "+ z_list.gametable[z_list.index].z_series+" "


		//fourth line
		iline++
		hist_text_premessage.push("")
		local tagarray = z_list.gametable[z_list.index].z_tags
		tagarray.sort (@(a,b) a.tolower()<=>b.tolower())
		if (tagarray.len() >=1)
		hist_text_premessage[iline] = hist_text_premessage[iline] + gly(0xe903)+" "+tagarray[0]
		for (local i = 1 ; i < tagarray.len();i++){
			hist_text_premessage[iline] = hist_text_premessage[iline] +", "+ tagarray[i]
		}
		/*
		if (z_list.gametable[z_list.index].z_tags.len() > 0){
			hist_text_premessage.push ("TAG:")
			for (local i = 0; i<z_list.gametable[z_list.index].z_tags.len();i++){
				hist_text_premessage[2]=hist_text_premessage[2]
			}
		}
		*/
		hist_text_tempmessage = hist_text_premessage [0] + "\n"

		for (local i =1 ; i < hist_text_premessage.len();i++){
			if (hist_text_premessage[i] != "") hist_text_tempmessage = hist_text_tempmessage + hist_text_premessage[i] +"\n"
		}
	}

	hist_text_tempmessage = hist_text_tempmessage+"\n"
/*
	local commands = []
	try {commands = commandtable[rom]}catch(err){}
	if (commands.len() > 0){
		for (local i = 0 ; i < commands.len() ; i++){
			hist_text_tempmessage = hist_text_tempmessage+commands[i]+"\n"
		}
	}
*/

	//
	// we only go to the trouble of loading the entry if
	// it is not already currently loaded
	//
	//	if ( hist_curr_rom != rom )
	//	{
		hist_curr_rom = rom
		local alt = fe.game_info( Info.AltRomname )
		local cloneof = fe.game_info( Info.CloneOf )

		local lookup = af_get_history_offset( sys, rom, alt, cloneof )
		//hist_text.msg = z_list.gametable[z_list.index].z_description
		local tempdesc = ""

		if ( lookup >= 0 ){
			//fe.overlay.splash_message(lookup + " " + my_config)
			try {
				tempdesc = af_get_history_entry( lookup, prf )
			} catch ( err ) {
				tempdesc = "\n\n\nThere was an error loading game data, please check history.dat preferences in the layout options";
			}
		}
		else
		{
			if ( lookup == -2 )
				tempdesc = "\n\n\nIndex file not found. Try generating an index from the history.dat plug-in configuration menu."
			else
				tempdesc = z_list.gametable[z_list.index].z_description +"\n\n"
		}
		local tempdesc2 = z_list.gametable[z_list.index].z_description
		if ((tempdesc2 != "?") && (tempdesc2 != "")){
			tempdesc = tempdesc2 + "\n\n"
		}
		hist_text.msg = hist_text_tempmessage + tempdesc+fe.game_info(Info.Name)+"\n"+"Scrape: "+z_list.gametable[z_list.index].z_scrapestatus+"\n\n\n"

//	}
}

function history_show(h_startup)
{
	tilesTableZoom[focusindex.new] = startfade (tilesTableZoom[focusindex.new],-0.035,-5.0)

	if ((prf.AUDIOVIDSNAPS) && (prf.THUMBVIDEO)) tilez[focusindex.new].gr_vidsz.video_flags = Vid.NoAudio
	if (prf.THUMBVIDEO) videosnap_hide()

	history_updatesnap()
	history_updatetext()
	if (prf.CONTROLOVERLAY) history_updateoverlay()

	if (h_startup) {
		history_surface.visible=true
		flowT.history = startfade (flowT.history,0.05,3.0)
		flowT.histtext = startfade (flowT.histtext,0.05,-3.0)
		/*
		flowT.data = startfade (flowT.data,-0.08,-3.0)
		flowT.fg = startfade (flowT.fg,0.08,-3.0)
		*/
		flowT.groupbg = startfade (flowT.groupbg,-0.08,-3.0)
		flowT.historyscroll = [0.5,0.5,0.5,0.0,0.0]
	}
}


function history_hide() {
	tilesTableZoom[focusindex.new] = startfade (tilesTableZoom[focusindex.new],0.015,-5.0)

	//history_surface.visible = false
	if ((prf.AUDIOVIDSNAPS) && (prf.THUMBVIDEO))  tilez[focusindex.new].gr_vidsz.video_flags = Vid.Default
	if (prf.THUMBVIDEO) videosnap_restore()

	flowT.history = startfade (flowT.history,-0.05,-3.0)
	flowT.histtext = startfade (flowT.histtext,-0.5,0.0)
	/*
	flowT.data = startfade (flowT.data,0.06,3.0)
	flowT.fg = startfade (flowT.fg,-0.06,3.0)
	*/
	flowT.groupbg = startfade (flowT.groupbg,0.06,3.0)
}

function history_visible() {
	return ((history_surface.visible) && (flowT.history[3] >= 0))
}

function on_scroll_up() {
	if (hist_text.first_line_hint > 1) hist_text.first_line_hint--
}

function on_scroll_down() {
	hist_text.first_line_hint++
}

function history_exit () {
//	hist_title.file_name = "pics/transparent.png"
//	hist_screen.file_name = "pics/transparent.png"
	history_hide()
}

// Fade helper functions

/// Fade mechanics routines ///

function fadeupdate_old(fadearray){
	local t_counter = fadearray[0]
	local t_value = fadearray[1]
	local t_starter = fadearray[2]
	local t_increaser = fadearray[3]
	local t_easer = fadearray[4]

	t_counter = t_counter + t_increaser * AF.tsc

   local speedsign = t_increaser > 0 ? 1.0 : -1.0
   local easesign = t_easer > 0 ? 1.0 : -1.0

	if (t_easer == 0)
		t_value = t_counter
	else if (t_easer > 0)
      t_value = t_starter + speedsign * (pow((speedsign * (t_counter - t_starter)),easesign*t_easer))
	else if (t_easer < 0)
      t_value = t_starter + speedsign * (1.0 - pow(1.0 - speedsign * (t_counter - t_starter),easesign*t_easer))

	return ([t_counter,t_value,t_starter,t_increaser,t_easer])
}

function checkfade_old(fadearray) {
	return (fadearray[3] != 0)
}

function startfade_old(fadearray,t_increaser,t_easer) {
	local t_data = fadearray[1]
	return ([t_data,t_data,t_data,t_increaser,t_easer])
}

/* New fade mechanics

	startfade receives three inputs:
	fadearray is the array with the fade data
	t_in_increaser is the speed of the transition
	t_in_easer is the shape of the resulting curve
		+/-1 	= linear
		> 1 	= tangent start
		< -1 	= tangent stop

	the fadearray has 5 components that are updated on fadeupdate:
	t_counter always goes from 0 to 1, doesn't matter the sign of increaser, it's just it, a counter
	t_value is the actual value of the curve, as calculated using t_easer
	t_starter is a service value
	t_increaser is the increaser (see above)
	t_easer is the easer (see above)

	fadeupdate only triggers if checkfade is not zero, that is t_increaser is not zero

	What does fadeupdate do?
	1 - increase the t_counter by t_increaser.
	2 - Check if t_counter reaches 1.0, if that's the case it returns a vector
	    [0, 1 or 0 as the reached final value, old t_increaser value,0,0]; with this array subsequent
		 checkfade will return false because t_increaser is 0, but the old t_increaser has been passed to t_starter
		 probably for no real reason since it's not used anymore anywhere :D
	3 - recalculates the value using a formula that uses t_counter and t_easer
	    remember that this is not a cumulative but fading curve, so at one t_counter
		 corresponds one and only t_value
	4 - returns [t_counter,t_value,t_starter,t_increaser,t_easer]

	If you call startfade with different parameters when the fade is already in progress,the value of t_counter
	is recalculated from the value of t_value to attach one curve to the other

	To check if the transition has ended the endfade function checks if t_increment is zero and returns the ending t_value.

*/

function fadeupdate(fadearray){
	local t_counter = fadearray[0]
	local t_value = fadearray[1]
	local t_starter = fadearray[2]
	local t_increaser = fadearray[3]
	local t_easer = fadearray[4]

	t_counter = t_counter + fabs(t_increaser) * AF.tsc

   local increase_sign = t_increaser > 0 ? 1.0 : -1.0
   local ease_sign = t_easer > 0 ? 1.0 : -1.0

   if (t_counter > 1.0) return ([0.0,0.5*(increase_sign + 1.0),t_increaser,0.0,0.0])

	if (t_easer == 0)
		t_value =1.0 - 0.5*(1.0+increase_sign) + increase_sign * t_counter
	else if (t_easer > 0)
      t_value = (1.0 - increase_sign)*0.5 + increase_sign * pow ( (fabs(t_counter)),t_easer)
	else if (t_easer < 0)
      t_value = (1.0 - increase_sign)*0.5 + increase_sign*(1.0 - pow((1-fabs(t_counter)),(-1.0*t_easer)) )

	return ([t_counter,t_value,t_starter,t_increaser,t_easer])
}

function checkfade(fadearray){
	return (fadearray[3] != 0)
}

function startfade (fadearray,t_in_increaser,t_in_easer) {
	local t_counter = fadearray[0]
	local t_value = fadearray[1]
	local t_starter = fadearray[2]
	local t_increaser = fadearray[3]
	local t_easer = fadearray[4]

	local fadearray2 = null

   local ease_sign = t_in_easer >= 0 ? 1.0 : -1.0
   local increase_sign = t_in_increaser >= 0 ? 1.0 : -1.0

   if (t_in_easer > 0) {
      // Reverse update counter value with respect to input data
      t_counter = pow(( increase_sign * (t_value - (1.0 - increase_sign)*0.5) ),(1.0/t_in_easer))
      return ([t_counter,t_value,t_starter,t_in_increaser,t_in_easer])
   }
   else if (t_in_easer < 0) {
      // Reverse update counter value with respect to input data
      t_counter = 1.0 - pow((1.0 - increase_sign * (t_value - (1.0 - increase_sign)*0.5)),(-1.0/t_in_easer))
      return ([t_counter,t_value,t_starter,t_in_increaser,t_in_easer])
   }
   else {
      t_counter = increase_sign * (t_value - 1.0 + 0.5*(1.0+increase_sign))
      return ([t_counter,t_value,t_starter,t_in_increaser,t_in_easer])
   }
}

function endfade (fadearray){
	if (fadearray[3] == 0) {
		return fadearray[1]
	}
}

function history_changegame(direction){
	if ((prf.AUDIOVIDSNAPS) && (prf.THUMBVIDEO))  tilez[focusindex.new].gr_vidsz.video_flags = Vid.NoAudio
	hist.scrollreset = true
	hist.direction = direction
	flowT.historyscroll = startfade (flowT.historyscroll,0.0601,0.0)
	flowT.historyblack = startfade (flowT.historyblack,flowT.historyscroll[3]*2.0,-3.0)
	flowT.historydata = startfade (flowT.historydata,0.101,0.0)

}


/// Display Menu Page ///

local disp0 = {
	w = overlay.fullwidth
	h = overlay.fullheight
}

// DISPLAY ARTWORKS (FOR DISPLAYS MENU)
local disp = {
	images = []
	pos0 = []

	tilew =  ((disp0.h > disp0.w*0.5) ? disp0.w * 0.5 : disp0.h)
	tileh =  ((disp0.h > disp0.w*0.5) ? disp0.w * 0.5 : disp0.h)
	xstart = 0
	xstop = 0
	speed = null
	pad = padding
	width = null
	height = overlay.fullheight
	spacing = null
	x = null
	y = overlay.y + overlay.labelsize
	starter = false
	shown = 0

	grouplabel = []
	groupname = []
	groupglyphs = {}
	structure = []
	gmenu0 = null
	gmenu0out = null
	gmenu1in = null
}

disp.width = disp.tilew
disp.speed = disp.tileh * 0.1
disp.spacing = disp0.h
disp.x = overlay.w - disp.tilew

/// Zmenu definition ///

zmenu = {
	items = []
	tilew = overlay.w
	tileh = floor(overlay.fullheight/overlay.rows)
	pos0 = []
	xstart = 0
	xstop = 0
	speed = null
	pad = floor(padding * 0.5)
	width = overlay.w
	fullwidth = overlay.w
	height = overlay.fullheight
	x = overlay.x
	y = overlay.y + overlay.labelsize
	shown = 0 // Number of entry in the list
	selected = 0 // Index of the selected entry
	glyphs = []
	notes = []
	noteitems = []
	glyphw = floor(overlay.fullheight/overlay.rows)
	glyphh = floor(overlay.fullheight/overlay.rows)
	midoffset = 0
	virtualheight = 0
	blanker = null
	overlaymsg = ""
	selectedbar = null
	sidelabel = null
	strikelines = []
	showing = false // Boolean to tell the layout that menu is showing

	reactfunction = null // Response function
	reactleft = null
	reactright = null

	midscroll = false // True if the menu scroll needs to be centered vertically

	dmp = false // True when Display Menu Page is on
	mfm = false // True when multifilter menu is on
}

zmenu.speed = zmenu.tileh * 0.1

local zmenu_surface_container = fe.add_surface (zmenu.width,zmenu.height)

zmenu_surface_container.set_pos (zmenu.x,zmenu.y)


zmenu_surface_container.zorder = 10
sh_scale.r2 = 0.5 * sh_scale.r1

local zmenu_sh = {
	surf_2 = null
	surf_rt = null
	surf_1 = null
}

zmenu_sh.surf_rt = fe.add_surface(zmenu.width * sh_scale.r2 , zmenu.height * sh_scale.r2)
zmenu_sh.surf_2 = zmenu_sh.surf_rt.add_surface(zmenu.width * sh_scale.r2 , zmenu.height * sh_scale.r2)
zmenu_sh.surf_1 = zmenu_sh.surf_2.add_clone(zmenu_surface_container)

zmenu_sh.surf_1.set_pos (0 , 0 , zmenu.width * sh_scale.r2 , zmenu.height * sh_scale.r2)

//zmenu_sh.set_rgb(0,0,0)
zmenu_sh.surf_1.set_rgb(0,0,0)


local shader_tx2 = {
	h = fe.add_shader( Shader.VertexAndFragment, "glsl/gauss_kern9_v.glsl", "glsl/gauss_kern9_f.glsl" )
	v = fe.add_shader( Shader.VertexAndFragment, "glsl/gauss_kern9_v.glsl", "glsl/gauss_kern9_f.glsl" )
}
/*
shader_tx2.v.set_texture_param( "texture")
shader_tx2.v.set_param ("kernelData",9,3.0)
shader_tx2.v.set_param ("offsetFactor",0.000,1.0/(fl.h_os*sh_scale.r2))

shader_tx2.h.set_texture_param( "texture")
shader_tx2.h.set_param ("kernelData",9,3.0)
shader_tx2.h.set_param ("offsetFactor",1.0/(fl.w_os*sh_scale.r2),0.000)
*/
gaussshader (shader_tx2.h,9.0,3.0,1.0/(fl.w*sh_scale.r2),0.0)
gaussshader (shader_tx2.v,9.0,3.0,0.0,1.0/(fl.h*sh_scale.r2))

zmenu_sh.surf_2.shader = noshader
zmenu_sh.surf_1.shader = noshader


zmenu_sh.surf_rt.alpha = themeT.menushadow

zmenu_sh.surf_rt.zorder = 9

zmenu_sh.surf_rt.set_pos(zmenu_surface_container.x + 4*scalerate,zmenu_surface_container.y + 8*scalerate,zmenu_surface_container.width,zmenu_surface_container.height)


local zmenu_surface = zmenu_surface_container.add_surface (zmenu.width,zmenu.height)

zmenu_surface.add_image("pics/black.png",0,0,zmenu_surface.width,zmenu_surface.height)
zmenu.selectedbar = zmenu_surface.add_text ("",0,0,zmenu.width,zmenu.tileh)
zmenu.selectedbar.set_bg_rgb(255,255,255)

zmenu.sidelabel = zmenu_surface.add_text( "", zmenu.pad, 0, zmenu.width - 2 * zmenu.pad, zmenu.tileh )
zmenu.sidelabel.char_size = overlay.labelcharsize*0.8
zmenu.sidelabel.margin = 2
zmenu.sidelabel.set_rgb(0,0,0)
zmenu.sidelabel.align = Align.BottomRight
zmenu.sidelabel.font = uifonts.lite
zmenu.sidelabel.set_bg_rgb(0,200,0)
zmenu.sidelabel.bg_alpha = 0
zmenu.sidelabel.word_wrap = true

zmenu.blanker = zmenu_surface.add_text("",0,0,1,1)
zmenu.blanker.set_bg_rgb(0,0,0)
zmenu.blanker.visible = false
zmenu_surface.shader = txtoalpha


function zmenudraw (menuarray,glypharray,sidearray,title,titleglyph,presel,shrink,dmpart,center,midscroll,response,left = null,right = null){

	if ((!zmenu.showing) && (prf.THEMEAUDIO)) snd.wooshsound.playing = true

	count.skipup = 0
	count.skipdown = menuarray.len() - 1
	count.forceup = false
	count.forcedown = false

	zmenu.midscroll = midscroll

	foreach (item in overlay.shad) item.visible = true
	flowT.zmenudecoration = startfade(flowT.zmenudecoration,0.08,0.0)

	tilesTableZoom[focusindex.new] = startfade (tilesTableZoom[focusindex.new],-0.035,-5.0)

	if (sidearray == null){
		sidearray = array(menuarray.len(),"")
	}

	zmenu.notes = sidearray

	foreach (i, item in zmenu.notes) try{zmenu.notes[i] = zmenu.notes[i].toupper()} catch(err){}
	foreach (item in disp.images){
		item.file_name = "pics/transparent.png"
	}

	if (overmenu_visible()) overmenu_hide(false)

	// silence snap video sound
	if ((prf.AUDIOVIDSNAPS) && (prf.THUMBVIDEO)) tilez[focusindex.new].gr_vidsz.video_flags = Vid.NoAudio

	// Stops video thumb playback
	if (prf.THUMBVIDEO) videosnap_hide()

	// Initialize menu
	zmenu.blanker.visible = false
	zmenu.reactfunction = response
	zmenu.reactleft = left
	zmenu.reactright = right
	overlay.label.msg = title
	overlay.glyph.msg = gly(titleglyph)
	overlay.glyph.x = fl.x + fl.w * 0.5 - overlay.label.msg_width * 0.5 - overlay.labelsize

	overlay.sidelabel.visible = overlay.label.visible = overlay.glyph.visible = overlay.wline.visible = true

	flowT.zmenutx = startfade(flowT.zmenutx,0.05,0.0)
	flowT.zmenush = startfade(flowT.zmenush,0.05,0.0)

	// Change menu height if options menu is visible
	if (prfmenu.showing) {
		zmenu.glyphh = zmenu.tileh = ((prfmenu.bg.y - zmenu.y)/overlay.rows)
		zmenu.height = prfmenu.bg.y - zmenu.y
	}
	else {
		zmenu.glyphh = zmenu.tileh = (overlay.fullheight/overlay.rows)
		zmenu.height = overlay.fullheight
	}

	zmenu.showing = true

	if (glypharray == null) {
		glypharray = []
		for (local i=0;i<menuarray.len();i++){
			glypharray.push (" ")
		}
	}

	local artname = ""
	local filename = ""
	local obj_item = null
	local obj_glyph = null
	local obj_note = null
	local obj_dispimage = null
	local obj_strikeline = null
	local pad = zmenu.pad * 2.0
	local fontscaler = 0.7
	local iindex = 0

	// Hide excess items from menu display
	for (local i = 0 ; i < zmenu.items.len() ; i++ ){
		try {disp.images[i].visible = false} catch (err) {}
		zmenu.items[i].visible = false
		zmenu.glyphs[i].visible = false
		zmenu.noteitems[i].visible = false
		zmenu.strikelines[i].visible = false
	}
	zmenu.virtualheight = zmenu.tileh * menuarray.len()
	zmenu.midoffset = zmenu.height * 0.5 - zmenu.virtualheight * 0.5

	// Generate items for menu display
	for (local i = 0 ; i < menuarray.len() ; i++){

		obj_strikeline = zmenu_surface.add_text("",shrink ? 0 : zmenu.pad , zmenu.tileh*0.5 + zmenu.midoffset + i * zmenu.tileh , zmenu.tilew -2*(shrink ? 0 : zmenu.pad) + (shrink ?  -1.0* disp.width : 0), 1)
		obj_strikeline.visible = false
		obj_strikeline.set_bg_rgb(255,255,255)
		obj_strikeline.bg_alpha = 128

		//Y obj_item = zmenu_surface.add_text(" ",pad, zmenu.height*0.5 - zmenu.tileh*0.5 + i * zmenu.tileh , zmenu.tilew - 2.0*pad, zmenu.tileh)
		obj_item = zmenu_surface.add_text(" ",shrink ? 0 : zmenu.glyphw , zmenu.midoffset + i * zmenu.tileh , zmenu.tilew -2*(shrink ? 0 : zmenu.glyphw) + (shrink ?  -1.0* disp.width : 0), zmenu.tileh)
		obj_item.msg = menuarray[i]
		obj_item.font = uifonts.gui
		obj_item.char_size = overlay.charsize
		obj_item.word_wrap = true
		obj_item.margin = 0
		obj_item.align = (center ? Align.MiddleCentre : Align.MiddleLeft)
		obj_item.bg_alpha = 0
		obj_item.set_rgb(255,255,255)
		//obj_item.set_bg_rgb(100,0,0)

		obj_note = zmenu_surface.add_text(" ",0, zmenu.midoffset + i * zmenu.tileh , zmenu.tilew - zmenu.pad + (shrink ? zmenu.pad - disp.width : 0), zmenu.tileh)
		obj_note.msg = zmenu.notes[i]
		obj_note.font = uifonts.gui
		obj_note.char_size = overlay.charsize
		obj_note.word_wrap = true
		obj_note.margin = 0
		obj_note.align = Align.MiddleRight
		obj_note.bg_alpha = 0
		obj_note.set_rgb(255,255,255)

		if ((zmenu.mfm) && (obj_note.msg == "(0)")) {
			obj_item.set_rgb	(81,81,81)
			obj_note.set_rgb (81,81,81)
		}

		if (zmenu.dmp) obj_note.visible = false

		obj_glyph = zmenu_surface.add_text(" ",0, zmenu.height*0.5 - zmenu.tileh*0.5 + i * zmenu.tileh , zmenu.glyphw, zmenu.glyphh)
		obj_glyph.font = uifonts.glyphs
		obj_item.margin = 0
		obj_glyph.char_size = overlay.charsize*1.25
		obj_glyph.align = Align.MiddleCentre
		obj_glyph.msg = (glypharray[i] == -1) ? "" : gly(glypharray[i])
		//obj_glyph.set_bg_rgb (100,0,0)
		obj_glyph.bg_alpha = 0
		obj_glyph.set_rgb(255,255,255)
		//obj_glyph.set_bg_rgb(200,0,0)

		if (glypharray[i] == -1) {
			obj_item.msg = obj_item.msg.toupper()
			obj_item.font = uifonts.lite
			obj_item.align = Align.MiddleCentre
			obj_item.set_bg_rgb (0,0,0)
			obj_item.bg_alpha = 255
			obj_item.x = (shrink ? zmenu.tilew - disp.width : zmenu.tilew)*0.5 - obj_item.msg_width * 0.5 - zmenu.pad
			obj_item.width = obj_item.msg_width + 2 *zmenu.pad
			obj_strikeline.visible = true
		}

		// Check if there's space for item _and_ notes
		if (!center){
			while (obj_item.msg_width + obj_note.msg_width > (zmenu.tilew - obj_item.x)) {
				obj_item.width = obj_item.width * 0.5
				obj_note.x = obj_item.x + obj_item.width
				//TEST94 CHECK BETTER
				obj_note.width = zmenu.tilew - zmenu.pad + (shrink ? zmenu.pad - disp.width : 0) - obj_item.width - obj_item.x
			}
		}

		if (prf.DMPIMAGES && zmenu.dmp){
			//TEST98 THIS IS JUST A PLACEHOLDER, WILL BE UPDATED LATER TO TAKE STRIKELINES INTO ACCOUNT!!!
			/*
			disp.xstop = - presel * disp.spacing
			disp.xstart = disp.xstop
			*/
			artname = FeConfigDirectory+"menu-art/snap/"+menuarray[i]
			filename = ""

			local system_art = ""
			if (prf.DMPGENERATELOGO) {
				try {system_art = system_data[menuarray[i].tolower()].sysname}
				catch(err){}
			}

			local af_art = null
			local ma_art = null

			if ( file_exist (AF.folder+ "system_images/" + system_art+".png")) af_art = AF.folder+"system_images/" + system_art+".png"

			if ( file_exist (artname+".jpg") ) ma_art = artname+".jpg"
			if ( file_exist (artname+".png") ) ma_art = artname+".png"
			if ( file_exist (artname+".mp4") ) ma_art = artname+".mp4"
			if ( file_exist (artname+".mkv") ) ma_art = artname+".mkv"
			if ( file_exist (artname+".avi") ) ma_art = artname+".avi"

			if (prf.DMART == "AF_ONLY") filename = af_art
			else if (prf.DMART == "MA_ONLY") filename = ma_art
			else if (prf.DMART == "AF_MA") filename = (af_art == null ? ma_art : af_art)
			else if (prf.DMART == "MA_AF") filename = (ma_art == null ? af_art : ma_art)

			if (filename == null) filename = ""
			if (!dmpart) filename = ""

			obj_dispimage = zmenu_surface_container.add_image( "", disp.x + pad + disp.width*0.5 - 0.5 * disp.tilew ,  disp.height * 0.5 - disp.tileh * 0.5 +pad + i * disp.spacing , disp.tilew  -2.0*pad, disp.tileh-2.0*pad )
			obj_dispimage.preserve_aspect_ratio = true
			obj_dispimage.file_name = filename
			obj_dispimage.video_flags = Vid.NoAudio
			obj_dispimage.mipmap = 1

			try {disp.images[i] = obj_dispimage} catch (err) {disp.images.push (obj_dispimage)}
			try {disp.pos0[i] = obj_dispimage.y} catch (err) {disp.pos0.push (obj_dispimage.y)}

			//TEST98 disp.images[i].y = disp.pos0[i] + disp.xstop

			// Crop display artwork
			local extension = disp.images[i].file_name.slice (disp.images[i].file_name.len()-3,disp.images[i].file_name.len())
			if ( extension.tolower()== "jpg") {

				local sizew = min(disp.images[i].texture_width,disp.images[i].texture_height)
				disp.images[i].subimg_width = sizew
				disp.images[i].subimg_height = sizew
				disp.images[i].subimg_x = (disp.images[i].texture_width - sizew  )*0.5
				disp.images[i].subimg_y = (disp.images[i].texture_height - sizew  )*0.5
			}
		}

		try { zmenu.glyphs[i] = obj_glyph } catch (err) { zmenu.glyphs.push (obj_glyph) }
		try { zmenu.items[i] = obj_item } catch (err) { zmenu.items.push (obj_item) }
		try { zmenu.noteitems[i] = obj_note } catch (err) { zmenu.noteitems.push (obj_note) }
		try { zmenu.strikelines[i] = obj_strikeline } catch (err) { zmenu.strikelines.push (obj_strikeline) }
		try { zmenu.pos0 [i] = obj_item.y } catch (err) { zmenu.pos0.push (obj_item.y) }

	}

	//Centering
	if (center) {
		local maxwidth = 0
		for (local i = 0 ; i < glypharray.len() ; i++){
			if (zmenu.items[i].msg_width > maxwidth) maxwidth = zmenu.items[i].msg_width
		}

   	for (local i = 0 ; i < glypharray.len(); i++){
			zmenu.glyphs[i].x = max( ( zmenu.width * 0.5 - 0.5 * maxwidth - zmenu.glyphs[i].width ) , 0 )
			if (shrink) zmenu.glyphs[i].x = zmenu.pad*0.5
		}
	}

	zmenu.shown = menuarray.len()
	zmenu.selected = presel
	while (zmenu.strikelines[zmenu.selected].visible) {
		zmenu.selected ++
		if (zmenu.selected == zmenu.shown) {
			zmenu.selected = 0
		}
	}

	// UPDATE IMAGES POSITION ACCORDING TO NEW SELECTION!
	if (prf.DMPIMAGES && zmenu.dmp){
		disp.xstop = - zmenu.selected * disp.spacing
		disp.xstart = disp.xstop
		foreach (id, item in disp.images){
			item.y = disp.pos0[id] + disp.xstop
		}
	}

	zmenu.sidelabel.msg = zmenu.notes[zmenu.selected]
	zmenu.sidelabel.visible = zmenu.dmp

	zmenu.items[zmenu.selected].set_rgb(0,0,0)
	zmenu.glyphs[zmenu.selected].set_rgb(0,0,0)
	zmenu.noteitems[zmenu.selected].set_rgb(0,0,0)

	zmenu.selectedbar.y = zmenu.sidelabel.y = zmenu.items[zmenu.selected].y
	zmenu.selectedbar.height = zmenu.items[zmenu.selected].height
	zmenu.selectedbar.width = zmenu.tilew + 0*(shrink ?  -1*disp.width : 0)

	zmenu.sidelabel.x = shrink ? 0 : zmenu.pad
	zmenu.sidelabel.width = shrink ? zmenu.width - disp.width : zmenu.width - 2 * zmenu.pad

	if (prfmenu.showing){
		zmenu.blanker = zmenu_surface.add_image("pics/black.png",0,zmenu.height,fl.w,prfmenu.picrateh+padding)
		zmenu.blanker.visible = true
	}

	zmenu_surface.set_rgb(themeT.listboxselbg,themeT.listboxselbg,themeT.listboxselbg)

	zmenu_sh.surf_2.shader = (prf.DATASHADOWSMOOTH ? shader_tx2.v : noshader)
	zmenu_sh.surf_1.shader = (prf.DATASHADOWSMOOTH ? shader_tx2.h : noshader)

	zmenu_surface_container.visible = zmenu_sh.surf_rt.visible = true

	local menucorrect = 0
	if (zmenu.shown - 1 - zmenu.selected < (overlay.rows -1) / 2) menucorrect =  (overlay.rows -1) / 2 - zmenu.shown +1 + zmenu.selected
	if (zmenu.selected < (overlay.rows -1) / 2)  menucorrect = - (overlay.rows -1) / 2 + zmenu.selected

	if (zmenu.midscroll) menucorrect = 0

	zmenu.xstop = menucorrect * zmenu.tileh - zmenu.midoffset - zmenu.selected * zmenu.tileh + (zmenu.height - zmenu.tileh)*0.5
	if ((zmenu.shown <= overlay.rows) && !zmenu.midscroll ) zmenu.xstop = 0
	zmenu.xstart = zmenu.xstop


	// Initialize positions
	for (local i = 0;i < zmenu.shown ; i++) {
		zmenu.items[i].y = zmenu.pos0[i] + zmenu.xstop
		zmenu.glyphs[i].y = zmenu.pos0[i] + zmenu.xstop
		zmenu.noteitems[i].y = zmenu.pos0[i] + zmenu.xstop
		zmenu.strikelines[i].y = zmenu.pos0[i] + zmenu.tileh*0.5 + zmenu.xstop
//			zmenu.items[i].word_wrap = true
//			zmenu.items[i].margin = zmenu.glyphs[i].width - padding
	}

	for (local i = 0 ; i < zmenu.shown; i++){
		zmenu.items[i].set_rgb (255,255,255)
		zmenu.noteitems[i].set_rgb (255,255,255)
		zmenu.glyphs[i].set_rgb (255,255,255)
		if ((zmenu.mfm) && (zmenu.notes[i] == "(0)")){
			 zmenu.items[i].set_rgb(81,81,81)
			 zmenu.noteitems[i].set_rgb(81,81,81)
		}
	}

	zmenu.items[zmenu.selected].set_rgb(0,0,0)
	zmenu.noteitems[zmenu.selected].set_rgb(0,0,0)
	zmenu.glyphs[zmenu.selected].set_rgb(0,0,0)
	zmenu.selectedbar.y = zmenu.sidelabel.y = zmenu.items[zmenu.selected].y = zmenu.noteitems[zmenu.selected].y

	overlay.sidelabel.msg = ""

	// DMP is visible
	if ( (zmenu.dmp)){

		if ((prf.DMPSORT == "display") && prf.DMPENABLED) overlay.sidelabel.msg = ""
		if ((prf.DMPSORT == "brandname") && prf.DMPENABLED)  overlay.sidelabel.msg = "\n"+ltxt("BY BRAND",TLNG)
		if ((prf.DMPSORT == "brandyear") && prf.DMPENABLED)  overlay.sidelabel.msg = "\n"+ltxt("BY BRAND, YEAR",TLNG)
		if ((prf.DMPSORT == "year") && prf.DMPENABLED)  overlay.sidelabel.msg = "\n"+ltxt("BY YEAR",TLNG)

		if (prf.DMPGENERATELOGO) {
			for (local i=0 ; i < ((prf.DMPEXITAF && (prf.JUMPLEVEL==0)) ? zmenu.shown -1 : zmenu.shown); i++){
				if (glypharray[i] != -1) {
					zmenu.items[i].font = uifonts.gui
					zmenu.items[i].char_size = ( (vertical && prf.DMPIMAGES) ? zmenu.tileh*0.5 : zmenu.tileh*0.7)
					zmenu.items[i].align = Align.MiddleCentre

					local renamer = systemfont(zmenu.items[i].msg,true)

					if (renamer == " ") {
						local bobwrapped = null
						bobwrapped = {
							text = zmenu.items[i].msg.toupper()
						}
						zmenu.items[i].font = uifonts.arcade
						zmenu.items[i].align = Align.MiddleCentre
						zmenu.items[i].line_spacing = 0.6
						zmenu.items[i].word_wrap = true
						zmenu.items[i].msg = bobwrapped.text
						zmenu.items[i].char_size = zmenu.items[i].height * ((vertical && prf.DMPIMAGES ) ? 1.25/3.0 : 1.8/3.0)
					}
					else zmenu.items[i].msg = renamer
				}
			}
		}
	}

	// After building menu define skipup limits
	local i = 0
	while (((zmenu.strikelines[i].visible) || (zmenu.mfm && (zmenu.notes[i] == "(0)"))) && (i < zmenu.shown)){
		count.skipup ++
		i++
	}


}

function zmenuhide(){

	tilesTableZoom[focusindex.new] = startfade (tilesTableZoom[focusindex.new],0.035,-5.0)

	foreach (item in disp.images){
		item.file_name = "pics/transparent.png"
	}

	if ((prf.AUDIOVIDSNAPS) && (prf.THUMBVIDEO))  tilez[focusindex.new].gr_vidsz.video_flags = Vid.Default
	if (prf.THUMBVIDEO) videosnap_restore()

	// Fade out zmenu text objects and zmenu shadow objects
	flowT.zmenutx = startfade(flowT.zmenutx,-0.15,0.0)
	flowT.zmenush = startfade(flowT.zmenush,-0.2,0.0)
	flowT.zmenudecoration = startfade(flowT.zmenudecoration,-0.2,0.0)

	zmenu.showing = false
}

zmenu.xstop = 0

zmenu_surface_container.visible = zmenu_sh.surf_rt.visible = false

function checkforupdates(force){

	if (!force && (currentdate().tointeger() <= loaddate().tointeger())) return

	savedate()

	//load latest update version
	fe.overlay.splash_message( "Checking for updates...")
	AF.updatechecking = true

	local updpath = fe.path_expand( AF.folder + "latest_version.txt")
	system ("curl -s http://www.mixandmatch.it/AF/latest_version.txt -o " + ap + updpath + ap)

	local filein = ReadTextFile (updpath)
	local ver_in = ""
	ver_in = filein.read_line()

	AF.updatechecking = false

	if (ver_in == "") return
	if ((ver_in == prf.UPDATEDISMISSVER) && (!force)) return
	if (ver_in.tofloat() <= AF.version.tofloat()) {
		if (force){
			zmenudraw (["Ok"],null, null,ltxt("No update available",TLNG),0xe91c,0,false,false,true,false,
			function(out){
				zmenuhide()
				frosthide()
			})
		}
		return
	}

	frostshow()
	// Get the latest updates

	local textarray = []
	local glypharray = []

	while (!filein.eos()){
		textarray.push(filein.read_line())
		glypharray.push (0xea08)
	}

	textarray.push (ltxt(prf.AUTOINSTALL ? "Download & install new version" : "Download new version",TLNG))
	glypharray.push (0xea36)

	textarray.push (ltxt("Dismiss this update",TLNG))
	glypharray.push (0xea0f)

	zmenudraw (textarray,glypharray, null,ltxt("New version:",TLNG)+" Arcadeflow "+ver_in,0xe91c,0,false,false,false,false,
	function(out){
		if (out == -1) {
			zmenuhide()
			frosthide()
		}

		if (out == textarray.len() - 2){

			// Download latest layout
			local newafname = "Arcadeflow_"+(ver_in.tofloat()*10).tointeger()
			local newaffolder = fe.path_expand( FeConfigDirectory) + "layouts/"+ newafname + "/"

			if (!prf.AUTOINSTALL){
				// Simply download in your home folder
				AF.updatechecking = true
				fe.overlay.splash_message( "Downloading...")
				system ("curl -s http://www.mixandmatch.it/AF/layouts/"+newafname+".zip -o " + ap + fe.path_expand(AF.folder) + newafname+".zip" + ap)
				AF.updatechecking = false
				prf.UPDATECHECKED = true
				zmenudraw (["Ok"],null, null,newafname+".zip downloaded",0xe91c,0,false,false,true,false,
				function(out){
					zmenuhide()
					frosthide()
				})
			}
			else {
				// Download zip of new layout version
				AF.updatechecking = true
				fe.overlay.splash_message( "Downloading...")
				system ("curl -s http://www.mixandmatch.it/AF/layouts/" + newafname + ".zip -o " + ap + fe.path_expand(AF.folder) + newafname + ".zip" + ap)
				// Create target directory
				fe.overlay.splash_message( "Installing...")
				system ("mkdir "+ ap + newaffolder + ap)
				// Unpack layout
				//system ("tar -xf " + ap + AF.folder + newafname +".tar.gz" + ap + " --directory " + ap + newaffolder + ap)
				unzipfile (AF.folder + newafname +".zip", newaffolder) //TEST100
				// Transfer preferences
				local dir = DirectoryListing( AF.folder )
				foreach (item in dir.results){
					if (item.find("pref_")) {
						local basename = item.slice(item.find("pref_"),item.len())
						system ((OS == "Windows" ? "copy " : "cp ") + ap + fe.path_expand(AF.folder) + basename + ap + " " + ap + fe.path_expand(newaffolder) + basename + ap)
					}
				}
				// Remove downloaded file
				local rem0 = 0
				while (rem0 == 0) {
					try {remove (AF.folder + newafname +".zip");rem0 = 1} catch(err){rem0 = 0}
				}
				// Update config file
				local currentlayout = split (AF.folder, "\\/").top()

				local cfgfile = file(fe.path_expand( FeConfigDirectory + "attract.cfg" ),"rb")
				local outarray = []
				local char = 0
				local templine = ""
				local index0 = null
				while (!cfgfile.eos()){
					char = 0
					templine = ""
					while (char != 10) {
						char = cfgfile.readn('b')
						if ((char != 10) && (char != 13)) templine = templine + char.tochar()
					}
					index0 = templine.find(currentlayout)
					if (index0 != null) {
						templine = templine.slice(0,index0) + newafname + templine.slice(index0 + currentlayout.len(),templine.len())
					}
					outarray.push(templine)
				}

				local outfile = WriteTextFile ( fe.path_expand( FeConfigDirectory + "attract.cfg" ) )
				for (local i = 0 ; i < outarray.len() ; i++){
					outfile.write_line(outarray[i]+"\n")
				}
				AF.updatechecking = false
				zmenudraw ([ltxt("Quit",TLNG)],null,null, ltxt("Arcadeflow updated to",TLNG)+" "+ ver_in ,0xe91c,0,false,false,true,false,
				function(out){
					zmenuhide()
					frosthide()
					fe.signal("exit_to_desktop")
				})


			}
		}

		if (out == textarray.len() - 1){

			// Dismiss auto updates
			local updpath = fe.path_expand (AF.folder + "pref_update.txt")
   		local updfile = WriteTextFile (updpath)
   		updfile.write_line(ver_in)
			zmenuhide()
			frosthide()
		}
	}
	)
}



function displayungrouped (){
	zmenu.dmp = true
	prf.JUMPLEVEL = 0

	// Array of display table entries to show in the menu
	local menuarray = []
	for (local i = 0 ; i < fe.displays.len() ; i++){
		if (fe.displays[i].in_menu) {
			menuarray.push (z_disp[i])
		}
	}

	if (prf.DMPSORT != "false") {
		menuarray.sort (@(a,b) a.sortkey <=> b.sortkey)
	}

	// Define menu display arrays
	local showarray = []
	local dispnotes = []
	local groupnotes = []

	foreach (i,item in menuarray){
		showarray.push (item.cleanname)
		dispnotes.push (item.notes)
		groupnotes.push (item.groupnotes)
	}

	local dispglyphs = array (showarray.len(),0)
	local currentnote = ""
	local i = 0
	if (prf.DMPSEPARATORS) {
		while (i < showarray.len()){

			if ((groupnotes[i] != currentnote) && (!menuarray[i].ontop)){
				currentnote = groupnotes[i]
				showarray.insert(i,groupnotes[i])
				dispnotes.insert(i,"")
				groupnotes.insert(i,"")
				dispglyphs.insert(i,-1)
				menuarray.insert (i,null)
				i++
			}
			i++
		}
	}

	if (prf.DMPEXITAF && prf.DMPENABLED) {
		showarray.push(ltxt("EXIT ARCADEFLOW",TLNG))
		dispnotes.push(ltxt("",TLNG))
		groupnotes.push("")
		dispglyphs.push(0)
		menuarray.push (null)
	}

	local currentdisplay = 0
	foreach (i, item in menuarray){
		if (item != null) if (item.dispindex == fe.list.display_index) currentdisplay = i
	}

	zmenudraw (showarray,dispglyphs,dispnotes,ltxt("DISPLAYS",TLNG),0xe912,currentdisplay,prf.DMPIMAGES,true,true,prf.DMPIMAGES,
	function(displayout){

		if (((displayout == -1) && (prf.DMPOUTEXITAF) ) || ((prf.DMPEXITAF) && (displayout == menuarray.len() - 1)) ) {

			zmenu.dmp = false
			zmenudraw (ltxtarray(prf.POWERMENU ? ["Yes","No","Power","Shutdown","Restart","Sleep"]:["Yes","No"],TLNG),prf.POWERMENU ? [0xea10,0xea0f,-1,0xe9b6,0xe984,0xeaf6]:[0xea10,0xea0f],null,ltxt("EXIT ARCADEFLOW?",TLNG),0xe9b6,1,false,false,true,false,
			function(result){
				if (result == 0) fe.signal("exit_to_desktop")
				else if (prf.POWERMENU && (result == 3)) powerman("SHUTDOWN")
				else if (prf.POWERMENU && (result == 4)) powerman("REBOOT")
				else if (prf.POWERMENU && (result == 5)) powerman("SUSPEND")
				else {
					zmenu.dmp = true
					if (prf.DMPOUTEXITAF) {
						//fe.signal("displays_menu")
						displayungrouped()
					}
					else {
						displayungrouped()
					}

				}
			})

		}

		else if (displayout != -1 ) {
			zmenu.dmp = false
			umvisible = false
			frosthide()
			zmenuhide()
			if (prf.DMPATSTART){
				/*
				flowT.fg = startfade(flowT.fg,-0.02,-1.0)
				flowT.data = startfade(flowT.data,0.02,-1.0)
				*/
				flowT.groupbg = startfade(flowT.groupbg,0.02,-1.0)
			}
			//local targetdisplay = displaysindex[displaysarray[displayout]]
			local targetdisplay = menuarray[displayout].dispindex

			local jumps = 0
			local jumpsfw = 0
			local jumpsbw = 0
			local noamfw = false
			local noambw = false
			local oldjump = false

			for (local i = 0; i < fe.displays.len(); i++){
				local ifw = modwrap(fe.list.display_index + i, fe.displays.len())
				if (fe.displays[ifw].layout.tolower().find("arcadeflow") == null) noamfw = true
				if (ifw == targetdisplay) break
				if (fe.displays[ifw].in_cycle) jumpsfw ++
			}
			for (local i = 0; i < fe.displays.len(); i++){
				local ibw = modwrap(fe.list.display_index - i, fe.displays.len())
				if (fe.displays[ibw].layout.tolower().find("arcadeflow") == null) noambw = true
				if (ibw == targetdisplay) break
				if (fe.displays[ibw].in_cycle) jumpsbw --
			}

			if (noamfw && !noambw) jumps = jumpsbw
			else if (!noamfw && noambw) jumps = jumpsfw
			else if (noamfw && noambw) oldjump = true
			else if (abs(jumpsfw) < abs(jumpsbw)) jumps = jumpsfw
			else jumps = jumpsbw

			if ((prf.OLDDISPLAYCHANGE) || oldjump ){
				fe.set_display(targetdisplay)
				prf.JUMPDISPLAYS = false
				jumps = 0
			}

			//local jumps = targetdisplay - fe.list.display_index
			if (jumps != 0 ) {
				prf.JUMPSTEPS = abs(jumps)
				prf.JUMPDISPLAYS = true
			}
			if ( jumps > 0 ) {
				for (local i = 0; i < jumps; i++) fe.signal("next_display")
			}
			if ( jumps < 0 )  {
				for (local i = 0; i < abs(jumps); i++) fe.signal("prev_display")
			}
		}
		else {
			zmenu.dmp = false
			if (!umvisible){
				frosthide()
				zmenuhide()
				if (prf.DMPATSTART){
					/*
					flowT.fg = startfade(flowT.fg,-0.02,-1.0)
					flowT.data = startfade(flowT.data,0.02,-1.0)
					*/
					flowT.groupbg = startfade(flowT.groupbg,0.02,-1.0)
				}
			}
			else {
				utilitymenu (umpresel)
			}
		}
	})
}

function displaygrouped1(){
	zmenu.dmp = true
	prf.JUMPLEVEL = 0

	// Displays the group menu
	zmenudraw (disp.groupname,null,null,ltxt("DISPLAYS",TLNG),0xe912,disp.gmenu0out,prf.DMPIMAGES && prf.DMCATEGORYART,prf.DMPIMAGES && prf.DMCATEGORYART,true,prf.DMPIMAGES && prf.DMCATEGORYART,
	function(gmenu0){
		disp.gmenu0 = gmenu0
		if (disp.gmenu0 != -1) disp.gmenu0out = disp.gmenu0

		// Code when "ESC" is pressed in Displays Menu page
		if (((disp.gmenu0 == -1) && (prf.DMPOUTEXITAF) ) || ((prf.DMPEXITAF) && (disp.gmenu0 == disp.groupname.len() - 1)) ) {

			zmenu.dmp = false
			zmenudraw (ltxtarray(prf.POWERMENU ? ["Yes","No","Power","Shutdown","Restart","Sleep"]:["Yes","No"],TLNG),prf.POWERMENU ? [0xea10,0xea0f,-1,0xe9b6,0xe984,0xeaf6]:[0xea10,0xea0f],null,ltxt("EXIT ARCADEFLOW?",TLNG),0xe9b6,1,false,false,true,false,
			function(result){
				if (result == 0) fe.signal("exit_to_desktop")
				else if (prf.POWERMENU && (result == 3)) powerman("SHUTDOWN")
				else if (prf.POWERMENU && (result == 4)) powerman("REBOOT")
				else if (prf.POWERMENU && (result == 5)) powerman("SUSPEND")

				else displaygrouped1()
			})
		}

		// Group selected, entering the displays menu for that group
		else if (disp.gmenu0 != -1) {

			// Array of display table entries to show in the menu
			local menuarray = []
			for (local i = 0 ; i < disp.structure[disp.grouplabel[disp.gmenu0]].disps.len() ; i++){
				menuarray.push (disp.structure[disp.grouplabel[disp.gmenu0]].disps[i])
			}

			if (prf.DMPSORT != "false") {
				menuarray.sort (@(a,b) a.sortkey <=> b.sortkey)
			}

			prf.JUMPLEVEL = 1

			// Define menu display arrays
			local showarray = []
			local dispnotes = []
			local groupnotes = []

			foreach (i,item in menuarray){
				showarray.push (item.cleanname)
				dispnotes.push (item.notes)
				groupnotes.push (item.groupnotes)
			}

			local dispglyphs = array (showarray.len(),0)
			local currentnote = ""
			local i = 0
			if (prf.DMPSEPARATORS) {
				while (i < showarray.len()){

					if ((groupnotes[i] != currentnote) && (!menuarray[i].ontop)){
						currentnote = groupnotes[i]
						showarray.insert(i,groupnotes[i])
						dispnotes.insert(i,"")
						groupnotes.insert(i,"")
						dispglyphs.insert(i,-1)
						menuarray.insert (i,null)
						i++
					}
					i++
				}
			}


			disp.gmenu1in = 0
			foreach (i, item in menuarray){
				if (item != null) if (item.dispindex == fe.list.display_index) disp.gmenu1in = i
			}

			zmenudraw (showarray,dispglyphs,dispnotes,disp.grouplabel[disp.gmenu0],disp.groupglyphs[disp.gmenu0],disp.gmenu1in,prf.DMPIMAGES,prf.DMPIMAGES,true,prf.DMPIMAGES,
			function (gmenu1){
				if (gmenu1 != -1 ) {
					if (prf.DMPATSTART){
						/*
						flowT.fg = startfade(flowT.fg,-0.02,-1.0)
						flowT.data = startfade(flowT.data,0.02,-1.0)
						*/
						flowT.groupbg = startfade (flowT.groupbg,0.02,-1.0)
					}
					//local targetdisplay = disp.structure[disp.grouplabel[disp.gmenu0]].disps[temparray[gmenu1]].index
					local targetdisplay = menuarray[gmenu1].dispindex

					local jumps = 0
					local jumpsfw = 0
					local jumpsbw = 0
					local noamfw = false
					local noambw = false
					local oldjump = false

					for (local i = 0; i < fe.displays.len(); i++){
						local ifw = modwrap(fe.list.display_index + i, fe.displays.len())
						if (fe.displays[ifw].layout.tolower().find("arcadeflow") == null) noamfw = true
						if (ifw == targetdisplay) break
						if (fe.displays[ifw].in_cycle) jumpsfw ++
					}
					for (local i = 0; i < fe.displays.len(); i++){
						local ibw = modwrap(fe.list.display_index - i, fe.displays.len())
						if (fe.displays[ibw].layout.tolower().find("arcadeflow") == null) noambw = true
						if (ibw == targetdisplay) break
						if (fe.displays[ibw].in_cycle) jumpsbw --
					}

					if (noamfw && !noambw) jumps = jumpsbw
					else if (!noamfw && noambw) jumps = jumpsfw
					else if (noamfw && noambw) oldjump = true
					else if (abs(jumpsfw) < abs(jumpsbw)) jumps = jumpsfw
					else jumps = jumpsbw

					// local jumps = targetdisplay - fe.list.display_index

					zmenu.dmp = false
					umvisible = false
					frosthide()
					zmenuhide()

					if ((prf.OLDDISPLAYCHANGE) || oldjump){
						fe.set_display(targetdisplay)
						prf.JUMPDISPLAYS = false
						jumps = 0
					}

					if (jumps != 0 ) {
						prf.JUMPSTEPS = abs(jumps)
						prf.JUMPDISPLAYS = true
					}
					if ( jumps > 0 ) {
						for (local i = 0; i < jumps; i++) fe.signal("next_display")
					}
					if ( jumps < 0 )  {
						for (local i = 0; i < abs(jumps); i++) fe.signal("prev_display")
					}

				}
				else {
					displaygrouped1()
				}
			})
		}

		else {
			zmenu.dmp = false
			if (!umvisible){
				umvisible = false
				frosthide()
				zmenuhide()
				if (prf.DMPATSTART){
					/*
					flowT.fg = startfade(flowT.fg,-0.02,-1.0)
					flowT.data = startfade(flowT.data,0.02,-1.0)
					*/
					flowT.groupbg = startfade(flowT.groupbg,0.02,-1.0)

				}
			}
			else {
				utilitymenu (umpresel)
			}
		}
	})
}

function displaygrouped(){
	zmenu.dmp = true
	prf.JUMPLEVEL = 0
	disp.grouplabel = ["ARCADE","CONSOLE","HANDHELD","COMPUTER","PINBALL","OTHER"]
	disp.groupname = ["zmenuarcade","zmenuconsole","zmenuhandheld","zmenucomputer","zmenupinball","other"]
	if (!prf.DMPGENERATELOGO) disp.groupname = ["arcade","console","handheld","computer","pinball","other"]
	disp.groupglyphs = [0xeaeb,0xeaec,0xe959,0xe956,0xeaf0,0xe912]

	disp.structure = {}

	foreach (data in disp.grouplabel){
		disp.structure[data] <- {
			size = 0
			disps = []
		}
	}

	// NOTA BENE: Il current display fe.list.display_index considera tutti, anche quelli non mostrati, quindi va bene
	foreach (i, item in z_disp){
		if (item.inmenu){
			try{ disp.structure[item.group].size ++} catch (err){
				disp.structure[item.group] <- {
					size = 1
					disps=[]
				}
				disp.grouplabel.push(item.group)
				disp.groupname.push(item.group)
				disp.groupglyphs.push(0)
			}
			disp.structure[item.group].disps.push(item)
		}
	}

	local templen = disp.grouplabel.len()
	for (local i = templen - 1 ; i >= 0 ; i--) {
		if (disp.structure[disp.grouplabel[i]].size == 0) {
			disp.grouplabel.remove(i)
			disp.groupname.remove(i)
			disp.groupglyphs.remove(i)
		}
	}

	if (prf.DMPEXITAF) disp.groupname.push(ltxt("EXIT ARCADEFLOW",TLNG))

	disp.gmenu0out = disp.grouplabel.len() - 1
	disp.gmenu0 = 0
	disp.gmenu0out = disp.grouplabel.find(z_disp[fe.list.display_index].group)

	local getout = false
	displaygrouped1()

}


/// Layout fades ///

function hideallbutbg () {
	// Returns true if the file is NOT available
	if (prf.REDCROSS && (z_list.gametable[z_list.index].z_fileisavailable != "1")) return true

	//if (z_list.gametable[z_list.index].z_system == "") return //TEST94

	//TEST104 fg_surface.visible = true
	/*
	flowT.data = startfade (flowT.data,-2.0,0.0)
	flowT.fg = startfade (flowT.fg,2.0,0.0)
	*/
	flowT.groupbg = startfade (flowT.groupbg,-2.0,0.0)

//TEST94	flowT.logo = startfade (flowT.logo,-1,0.0)
	flowT.history = startfade (flowT.history,-2.0,0.0)
	flowT.histtext = startfade (flowT.histtext,-2.0,0.0)

	return false
	//history_hide()
}


function layoutfadein () {

	tilesTableZoom[focusindex.new] = startfade (tilesTableZoom[focusindex.new],0.15,5.0) //TEST104

	if (prf.SPLASHON){
		/*
		flowT.fg = [0.0,1.0,0.0,-0.016,3.0]
		flowT.data = [0.0,0.0,0.0,0.016,3.0]
		*/
		flowT.groupbg = [0.0,0.0,0.0,0.016,3.0]
		flowT.logo = [0.0,1.0,0.0,-0.02,3.0]
	}
	else {
		/*
		flowT.fg = [0.0,1.0,0.0,-0.016,-3.0]
		flowT.data = [0.0,0.0,0.0,0.016,-3.0]
		*/
		flowT.groupbg = [0.0,0.0,0.0,0.016,-3.0]
		flowT.logo = [0.0,1.0,0.0,-0.02,3.0]
	}
}
if (prf.LAYERSNAP){
	bgvidsurf.alpha = 0
	bglay.pixelgrid.alpha = 0
}
data_surface.alpha = data_surface_sh_rt.alpha = 0
//TEST104 fg_surface.alpha = 255
//TEST104 fg_surface.visible = true


// moved after the fade if ((!prf.AMENABLE) || (!prf.AMSTART)) layoutfadein ()

/// Attract mode ///
local attract = {
	start = true
	// updatesnap = false
	rolltext = false
	gametimer = false
	starttimer = false

	scanrows = 180.0
	scansize = 5

	textshadow = 80
	game_interval = 1000 * prf.AMCHANGETIMER
	attract_interval = 1000 * prf.AMTIMER
	timer = fe.layout.time
	w = 0
	nw = 0
	x = 0
	y = 0
	msg = prf.AMMESSAGE
	sound = prf.AMSOUND
}

// If the screen resolution is so low that 5 pixels per scanline would not fit,
// pixels per scanlines are calculated as integer and no rescaling is applied.
// otherwise scanlines are 5 pixel tall and image is 900x900 and rescaled to fit
// the actual screen resolution (to improve performance)

if (attract.scansize <= ceil (bgT.w/attract.scanrows)){
	attract.nw = attract.scansize * attract.scanrows
	attract.w = bgT.w * 1.01
	attract.x = bgT.x - bgT.w * 0.005
	attract.y = bgT.y - bgT.w * 0.005
}
else {
	attract.scansize = ceil (bgT.w/attract.scanrows)
	attract.nw = attract.scansize * attract.scanrows
	attract.w = attract.nw
	attract.x = bgT.x - (attract.nw - bgT.w)*0.5
	attract.y = bgT.y - (attract.nw - bgT.w)*0.5
}

local attractitem = {
	surface = null
	snap = null
	refs = null
	black = null
	text_surface = null
	text1 = null
	text2 = null
	fade = null
	vignette = null
	shader_2_lottes = null
}

function attractkick(){

	if (!prf.AMENABLE) return

	if (history_visible()) history_hide()
	if (overmenu_visible()) overmenu_hide(false)
	if (zmenu.showing) {
		frosthide()
		zmenuhide()
	}

	if (prf.THUMBVIDEO) videosnap_hide()

	attract.start = true
	attract.starttimer = false
	attractitem.surface.visible = true
	attractitem.text1.visible = attractitem.text2.visible = true
	attractitem.snap.shader = attractitem.shader_2_lottes

	flowT.attract = startfade (flowT.attract, 0.1,0.0)
	if (prf.AMSHOWLOGO) flowT.logo = startfade (flowT.logo,0.1,0.0)
	//TEST104 CHECK! flowT.fg = startfade (flowT.fg,0.1,0.0)
}

function attractupdatesnap(){
	local randload = (z_list.size*rand()/RAND_MAX)
	attractitem.snap.file_name = fe.get_art("snap",z_list.gametable[randload].z_felistindex - fe.list.index)
	if (attractitem.snap.texture_width * attractitem.snap.texture_height == 0) {
		attractitem.snap.file_name = "pics/attractbg.jpg"
	}
	attractitem.refs.file_name = fe.get_art("snap",z_list.gametable[randload].z_felistindex - fe.list.index,0,Art.ImagesOnly)

	local nativeres = null
	local scalexy = [1.0,1.0]
	try{
		nativeres = [system_data[fe.game_info(Info.System).tolower()].w , system_data[fe.game_info(Info.System).tolower()].h]
	}
	catch (err){
		nativeres = [attractitem.refs.texture_width,attractitem.refs.texture_height]
	}
	if ( (nativeres[0] == 0) && (nativeres[1] == 0) ) {
		nativeres = [attractitem.refs.texture_width,attractitem.refs.texture_height]
	}
	if ( (nativeres[0] == 0) && (nativeres[1] == 0) ) {
		nativeres = [attractitem.snap.texture_width,attractitem.snap.texture_height]
	}
	try{
		scalexy[0] = attractitem.snap.texture_width / nativeres[0]
		scalexy[1] = attractitem.snap.texture_height / nativeres[1]
	}
	catch (err){
		attractitem.snap.file_name = "pics/attractbg.jpg"
		scalexy[0] = scalexy[1] = 1
	}


	local lorescaler = islcd(z_list.gametable[randload].z_felistindex - fe.list.index,0) ? 0.5 : 1.0
	scalexy[0] = lorescaler * scalexy[0]
	scalexy[1] = lorescaler * scalexy[1]

	if (attractitem.snap.texture_width >= attractitem.snap.texture_height){
		attractitem.snap.subimg_y = attractitem.snap.texture_height * 0.5 - attract.scanrows * 0.5 * scalexy[1]
		attractitem.snap.subimg_height = attract.scanrows * scalexy[1]
		attractitem.snap.subimg_x = attractitem.snap.texture_width * 0.5 - attract.scanrows * 0.5  * scalexy[0] * ((attractitem.snap.texture_width * 3.0/4.0)/attractitem.snap.texture_height)
		attractitem.snap.subimg_width = attract.scanrows * scalexy[0] * ((attractitem.snap.texture_width * 3.0/4.0)/attractitem.snap.texture_height)
	}
	else
	{
		attractitem.snap.subimg_x = attractitem.snap.texture_width * 0.5 - attract.scanrows * 0.5 * scalexy[0]
		attractitem.snap.subimg_width = attract.scanrows * scalexy[0]
		attractitem.snap.subimg_y = attractitem.snap.texture_height * 0.5 - attract.scanrows * 0.5 * scalexy[1] * ((attractitem.snap.texture_height * 3.0/4.0)/attractitem.snap.texture_width)
		attractitem.snap.subimg_height = attract.scanrows  * scalexy[1] * ((attractitem.snap.texture_height * 3.0/4.0)/attractitem.snap.texture_width)
	}

	attractitem.shader_2_lottes.set_param ("vert", (attractitem.snap.texture_width >= attractitem.snap.texture_height ? 0.0 : 1.0))
	attractitem.shader_2_lottes.set_param ("color_texture_sz", nativeres[0], nativeres[1])
	attractitem.shader_2_lottes.set_param ("color_texture_pow2_sz", nativeres[0], nativeres[1])
}

if (prf.AMENABLE){

	attractitem.shader_2_lottes = fe.add_shader(Shader.VertexAndFragment,"glsl/CRTL-geom_vsh.glsl","glsl/CRTL-geom_fsh.glsl");


	attractitem.surface = fe.add_surface (attract.nw,attract.nw)
	attractitem.surface.set_pos(attract.x,attract.y,attract.w,attract.w)
	attractitem.snap = attractitem.surface.add_image("pics/attractbg.jpg",0,0,attract.nw,attract.nw)
	attractitem.snap.preserve_aspect_ratio = false
	attractitem.refs = attractitem.surface.add_image("pics/transparent.png",0,0,1,1)
	attractitem.refs.preserve_aspect_ratio = false
	attractitem.refs.visible = false

	attractitem.black = attractitem.surface.add_text("",0,0,attract.nw,attract.nw)
	attractitem.black.set_bg_rgb(0,0,0)
	attractitem.black.bg_alpha = 0

	//attractitem.text_surface = fe.add_surface (attract.w,attract.w)
	//attractitem.text_surface.set_pos(attract.x,attract.y)

	if ((prf.SPLASHON) && (prf.AMSHOWLOGO)){
		attractitem.text1 = fe.add_text(attract.msg,attract.x,attract.y-attractitem.surface.y+fl.h-140*scalerate,attractitem.surface.width,140*scalerate)
	}
	else {
		attractitem.text1 = fe.add_text(attract.msg,attract.x,attract.y,attract.w,attract.w)
	}

	attractitem.text1.char_size = 72 * scalerate
	attractitem.text1.font = uifonts.gui
	attractitem.text1.set_rgb (0,0,0)
	attractitem.text1.alpha = attract.textshadow

	attractitem.text2 = fe.add_text(attract.msg,attractitem.text1.x,attractitem.text1.y-10*scalerate,attractitem.text1.width,attractitem.text1.height)

	attractitem.text2.char_size = 70*scalerate
	attractitem.text2.font = uifonts.gui
	attractitem.text2.set_rgb(255,255,255)

	attractitem.fade = attractitem.surface.add_image("pics/attractbg.jpg",0,0,attract.nw,attract.nw)
	attractitem.fade.alpha = 80
	attractitem.fade.blend_mode = BlendMode.Add

	attractitem.vignette = attractitem.surface.add_image("pics/vignette.png",0,0,attract.nw,attract.nw)
	// attractitem.vignette.alpha = 80

	//attractitem.snap.shader = attractitem.shader_2_lottes
	attractitem.snap.shader = noshader

	attractitem.shader_2_lottes.set_param ("aperature_type", 0.0); 	// 0.0 = none, 1.0 = TV style, 2.0 = Aperture grille, 3.0 = VGA
	attractitem.shader_2_lottes.set_param ("hardScan", -16.0);		// Hardness of Scanline 0.0 = none -8.0 = soft -16.0 = medium
	attractitem.shader_2_lottes.set_param ("hardPix", -2.0);			// Hardness of pixels in scanline -2.0 = soft, -4.0 = hard
	attractitem.shader_2_lottes.set_param ("maskDark",0.65);			// Sets how dark a "dark subpixel" is in the aperture pattern.
	attractitem.shader_2_lottes.set_param ("maskLight", 1.35);		// Sets how dark a "bright subpixel" is in the aperture pattern
	attractitem.shader_2_lottes.set_param ("saturation", 1.0);		// 1.0 is normal saturation. Increase as needed.
	attractitem.shader_2_lottes.set_param ("tint", 0.0);				// 0.0 is 0.0 degrees of Tint. Adjust as needed.
	attractitem.shader_2_lottes.set_param ("blackClip", 0.3);			// Drops the final color value by this amount if GAMMA_CONTRAST_BOOST is defined
	attractitem.shader_2_lottes.set_param ("brightMult", 2.0);		// Multiplies the color values by this amount if GAMMA_CONTRAST_BOOST is defined
	attractitem.shader_2_lottes.set_param ("distortion", 0.2);		// 0.0 to 0.2 seems right
	attractitem.shader_2_lottes.set_param ("cornersize", 0.05);		// 0.0 to 0.1
	attractitem.shader_2_lottes.set_param ("cornersmooth", 60);		// Reduce jagginess of corners
	attractitem.shader_2_lottes.set_param ("vignettebase", 0.0,1.0,3.0);

}

if (prf.AMENABLE){
	if (prf.AMSTART) {
		attractitem.surface.alpha = 255
		attractitem.text1.alpha = attract.textshadow
		attractitem.text2.alpha = 255
		attract.start = true
		attractitem.snap.shader = attractitem.shader_2_lottes
	}
	else {

		attractitem.snap.file_name = "pics/transparent.png"
		attractitem.snap.shader = noshader
		attractitem.surface.visible = false
		attractitem.text1.visible = attractitem.text2.visible = false
		attractitem.surface.alpha = 0
		attractitem.text1.alpha = attractitem.text2.alpha = 0
		if(prf.AMTUNE != "") {
			snd.attracttuneplay = false
			if (prf.BACKGROUNDTUNE != "") snd.bgtuneplay = true
		}
		else if ((prf.BACKGROUNDTUNE != "") && (prf.NOBGONATTRACT)) snd.bgtuneplay = true
		attract.start = false
		attract.timer = fe.layout.time
		attract.starttimer = true

	}
}


/// Splash Screen ///

local aflogo = fe.add_image (prf.SPLASHLOGOFILE,fl.x,fl.y,fl.w,fl.h)
aflogo.visible = false

local aflogoT = {
	w = fl.w,
	h = fl.h,
	x = 0,
	y = 0,
	ar = aflogo.texture_width*1.0 / aflogo.texture_height
}

if (aflogoT.ar >= fl.w/(fl.h*1.0)){
	aflogoT.w = fl.w
	aflogoT.h = aflogoT.w / aflogoT.ar*1.0
	aflogoT.y = fl.y - (aflogoT.h - fl.h)*0.5
	aflogoT.x = fl.x
}
else {
	aflogoT.h = fl.h
	aflogoT.w = aflogoT.h * aflogoT.ar
	aflogoT.y = fl.y
	aflogoT.x = fl.x - (aflogoT.w - fl.w)*0.5
}

aflogo.set_pos(aflogoT.x,aflogoT.y,aflogoT.w,aflogoT.h)

aflogo.visible = prf.SPLASHON


/// Layout fade from black ///

flowT.blacker = [0.0,0.0,0.0,0.09,1.0]


/// BGM Start ///

if(prf.BACKGROUNDTUNE != "") snd.bgtuneplay = true

/// Custom Foreground ///

local user_fg = null
if (prf.OVERCUSTOM != "pics/") {
	user_fg = fe.add_image (prf.OVERCUSTOM,0,0,fl.w_os,fl.h_os)
	user_fg.zorder = 100000
}

// Character size: 1.7*(width/columns) or 0.78*(height/rows)
AF.messageoverlay = fe.add_text ("1234567890123456789012345678901234567890\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13",fl.x,fl.y,fl.w,fl.h)
AF.messageoverlay.margin = 50*scalerate
AF.messageoverlay.char_size = (fl.w-2.0*AF.messageoverlay.margin)*1.7/AF.scrape.columns //40 columns text
AF.messageoverlay.word_wrap = true
AF.messageoverlay.set_bg_rgb (40,40,40)
AF.messageoverlay.bg_alpha = 240
AF.messageoverlay.align = Align.TopLeft
AF.messageoverlay.font = uifonts.mono
AF.messageoverlay.visible = false
AF.messageoverlay.zorder = 100
//Number of rows is 0.78*(fl.h_os-2.0*AF.messageoverlay.margin)/AF.messageoverlay.char_size
/// FPS MONITOR ///

local fps = {
	monitor = null
	monitor2 = null
	x0 = null
	tick000 = null
	tickinterval = 10
}


if (prf.FPSON){
fps.monitor = fe.add_text ("",fe.layout.width*0.5-550*0.5*scalerate,0,550*scalerate,80*scalerate)
//fps.monitor = fe.add_text ("",0,0,fl.w_os,120)

fps.monitor.set_bg_rgb (50,50,50)
fps.monitor.bg_alpha = 200
fps.monitor.set_rgb (255,255,255)
fps.monitor.char_size = 50*scalerate
fps.monitor.zorder = 20000

fps.monitor2 = fe.add_text ("",0,0,10,10)
fps.monitor2.set_bg_rgb (255,0,0)
fps.monitor2.visible = true

fps.tick000 = 0
fps.x0 = 0

fe.add_ticks_callback(this,"monitortick")
}

function monitortick(tick_time){
//fps.monitor.msg =" var:" + var + "zvar:" + z_var + " offs:" + column.offset + " start:" + column.start + " stop:"+column.stop +" ccval:" +centercorr.val+" ccsh:" +centercorr.shift
	fps.monitor2.x ++
	if (fps.monitor2.x - fps.x0 == fps.tickinterval) {
		fps.monitor.msg = (fps.tickinterval*1000/(tick_time - fps.tick000)) + " " + 60.0/AF.tsc +" "+AF.tsc
		fps.monitor2.y = (fl.h_os/60)*(60 - fps.tickinterval*1000/(tick_time - fps.tick000))
		fps.tick000 = tick_time
		fps.x0 = fps.monitor2.x
	}
	if (fps.monitor2.x >= fe.layout.width) {
		fps.monitor2.x = 0
		fps.x0 = 0
		fps.tick000=0
	}

}

/// Pre-Transition functions for labels jumps ///

local sortlabelsarray = []
local sortlabels = {}
local sortticksarray = []
local sortticks = {}

function resetkey (order){
	sortlabels [order].set_rgb (255,255,255)
	sortlabels [order].set_bg_rgb (0,0,0)
	sortlabels [order].bg_alpha = 255
}


function downkey (order){
	sortlabels [order].set_rgb (255,255,255)
	sortlabels [order].set_bg_rgb (0,0,0)
	sortlabels [order].bg_alpha = 255
}

function upkey (order){
	try{
		sortlabels [order].set_rgb (0,0,0)
		sortlabels [order].set_bg_rgb (255,255,255)
		sortlabels [order].bg_alpha = 255
	}
	catch (err){}
}

local labelorder = []
local labelcounter = {}

// All background "layers" which are in an array are
// shuffled at transition callback "tonewselection"

// Updatebgsnap is used to update the bg snap data for current
// background, loading media etc, it's called at "fromoldselection"

// All background data is updated
// via the squarebg() function, which is triggered by the "squarizer" flag
// since it must run in the on_tick routine

function updatebgsnap (index){
	// index è l'indice di riferimento della tilez
	// da questo index devo ricavare i dati usando le
	// proprietà .offset e .index della tabella tilez
	bgs.bgpic_array[bgs.stacksize-1].file_name  = fe.get_art((prf.BOXARTMODE ? (prf.LAYERSNAP ? "snap" : prf.BOXARTSOURCE) : (prf.TITLEART ? (prf.LAYERSNAP ? "snap" : "title") : "snap")) , tilez[index].offset,0,Art.ImagesOnly)

	// Case 1: pure box art mode
	if ((prf.BOXARTMODE) && (!prf.LAYERSNAP)) {
		// Check if boxart file is present otherwise load category pic and set proper coloring
		if (bgs.bgpic_array[bgs.stacksize-1].texture_width == 0) {

			bgs.bgpic_array[bgs.stacksize-1].file_name = category_pic_name (z_list.gametable[tilez[index].index].z_category)

			bgs.bgpic_array[bgs.stacksize-1].shader = colormapper["BOXART"].shad
			local col1 = categorycolor(z_list.gametable[tilez[index].index].z_felistindex,2)
			local col2 = categorycolor(z_list.gametable[tilez[index].index].z_felistindex,3)

			bgs.bg_box[bgs.stacksize-1] = [true,col1,col2]
			// Check if category icon is present, otherwise load grey background
			if (bgs.bgpic_array[bgs.stacksize-1].texture_width == 0) {
				bgs.bgpic_array[bgs.stacksize-1].file_name = "pics/grey.png"
			}
		}
		else {
			bgs.bgpic_array[bgs.stacksize-1].shader = colormapper["NONE"].shad
			bgs.bg_box[bgs.stacksize-1] = [false,[255,255,255],[0,0,0]]
		}
	}
	else { // We are not in boxart mode, OR the layersnap is enabled

		if (bgs.bgpic_array[bgs.stacksize-1].texture_width == 0 ) bgs.bgpic_array[bgs.stacksize-1].file_name = "snapx"+( (fe.game_info(Info.Title,tilez[index].offset).len() % 7))+".png"

		bgs.bgpic_array[bgs.stacksize-1].shader = colormapper["NONE"].shad
		bgs.bg_box[bgs.stacksize-1] = [false,[255,255,255],[255,255,255]]
	}


	bgs.bg_lcd[bgs.stacksize - 1] = islcd ( tilez[index].offset , 0)
	bgs.bg_mono[bgs.stacksize - 1] = recolorise ( tilez[index].offset , 0)
	bgs.bg_index[bgs.stacksize - 1] = z_list.index
	bgs.bg_aspect[bgs.stacksize - 1] = getAR(bgs.bg_index[bgs.stacksize - 1]-z_list.index,bgs.bgpic_array[bgs.stacksize - 1],0,false)

}

function ARcurve(AR){
	local ARrad = atan(AR)
	local ARdeg = ARrad*180/3.14
	local ARarg = -absf(ARdeg - 45)

	local ARradius = 311.126984 - 0.243335 * ARarg*ARarg - 0.010673 * ARarg*ARarg*ARarg -  0.0001884017 * ARarg*ARarg*ARarg*ARarg - 0.000001255074 * ARarg*ARarg*ARarg*ARarg*ARarg

	local out = {
		x = 2 * ARradius * sin(ARrad)
		y = 2 * ARradius * cos(ARrad)
	}
	return out
}

function ARprocess(aspect){
	local out = {x = 0.0,y = 0.0, w = 1.0, h = 1.0}
	//if (aspect <= 1.0){
		out.h = ARcurve(aspect).y *1.0/640 //( min (320.0 + 120.0/aspect, 500.0))/ 640.0
		out.w = ARcurve(aspect).x *1.0/640
		out.x = 0.5 * (1.0 - out.w)
		out.y = 0.5 * (1.0 - out.h)
	/*
	}
	else {
		out.h = ((min (320.0 + 120.0*aspect, 500.0)) / aspect) / 640.0
		out.w = out.h * aspect
		out.x = 0.5 * (1.0 - out.w)
		out.y = 0.5 * (1.0 - out.h)
	}
	*/
	return (out)
}

function getAR (tileindex, tile, var, boxart){
	// Nothing in the list, or no image at all: return 1.0
	if (z_list.size == 0) return (1.0)
	if (tile.texture_height == 0) return 1.0

	local txtAR = (tile.texture_width * 1.0 / tile.texture_height)
	// Boxart enabled, return purely width/height
	if (boxart) return txtAR

	// Get the horizgame parameter, if it's defined then AR is 4:3 or
	local horizgame = z_list.gametable[ modwrap (z_list.index + tileindex + var, z_list.size) ].z_rotation

	// No boxart
	// Get rotation attribute from selected game, this implies it's an arcade CRT game
	local horizgame = z_list.gametable[ modwrap (z_list.index + tileindex + var, z_list.size) ].z_rotation
	if (horizgame != "") {
		horizgame = ((horizgame == "0") || (horizgame == "180") || (horizgame == "horizontal") || (horizgame == "Horizontal"))
		return (horizgame ? 4.0/3.0 : 3.0/4.0)
	}

	// No definition of horizontal or vertical, no boxart mode
	local sysAR = systemAR (tileindex, var)
	if (sysAR < 0) return (txtAR > 1.0 ? -1.0 * sysAR : -1.0/sysAR)

	return (sysAR != 0.0 ? sysAR : txtAR)
}


function update_gradient(i,noboxart){
	local gradenabled = false
	if (((prf.SNAPGRADIENT) && (!prf.BOXARTMODE) && (prf.TITLEONSNAP)) || ((prf.SNAPGRADIENT) && (prf.BOXARTMODE) && (prf.TITLEONBOX)))
		gradenabled = true
	if ((prf.BOXARTMODE) && (!prf.LOWSPECMODE) && (!prf.TITLEONBOX) )
		gradenabled = false
	if ((tilez[i].loshz.subimg_width == 0) && (!prf.MISSINGWHEEL ))
		gradenabled = false
	if (!prf.TITLEONSNAP && !prf.BOXARTMODE)
		gradenabled = false

	if (prf.SNAPGRADIENT) tilez[i].gr_overlay.visible = gradenabled //TEST107

	// Make generated text visible or not
	tilez[i].txshz.visible = tilez[i].txt1z.visible = tilez[i].txt2z.visible =  ((prf.TITLEONSNAP) && (tilez[i].loshz.subimg_width == 0) && (prf.MISSINGWHEEL) && (!(prf.BOXARTMODE) || (prf.BOXARTMODE && prf.TITLEONBOX)) )

}

function clampaspect (aspect){
	local clamper = 4.0
	if (aspect > clamper) return clamper
	if (aspect < 1.0/clamper) return 1.0/clamper
	return aspect
}

// Function that updates snap position, size and internal crop
function update_snapcrop (i,var,indexoffsetvar,indexvar,aspect,cropaspect){
	if (cropaspect == 0){ //INITIALIZE NEW ARTWORK ASPECT
		cropaspect = clampaspect (aspect)
		if (prf.CROPSNAPS && !prf.BOXARTMODE) cropaspect = 1.0
		if (prf.LOGOSONLY) cropaspect = 2.0 //TEST107
		tilez[i].AR.snap = aspect
		tilez[i].AR.crop = cropaspect
		tilez[i].AR.current = tilez[i].AR.crop
	}
	local noboxart = false

	//TEST99 E' GIUSTO TOGLIERE QUESTA PARTE?!?!?
	if (prf.BOXARTMODE){ //TEST97
		//TEST99 tilez[i].snapz.shader.set_param ("lcdcolor",0.0)
		//TEST99 tilez[i].gr_snapz.shader.set_param ("lcdcolor",0.0)
		//tilez[i].snapz.shader = tilez[i].gr_snapz.shader = colormapper["NONE"].shad
	}

	//TEST87 TO DO SPOSTARE QUESTO DOVE VENGONO CARICATI I DATI DELL'IMMAGINE E NON IN CROPSNAP!
	if (prf.BOXARTMODE && (tilez[i].gr_snapz.texture_width == 0 )) {
		noboxart = true
		tilez[i].gr_snapz.file_name = category_pic_10_name (z_list.gametable[indexvar].z_category)

		if (tilez[i].gr_snapz.texture_width == 0 ) tilez[i].gr_snapz.file_name = "category_images_10/grey.png" //TEST99 da snapz a gr_snapz nel secondo

		tilez[i].snapz.shader = tilez[i].gr_snapz.shader = colormapper["BOXART"].shad

		local col1 = categorycolor(z_list.gametable[indexvar].z_felistindex,2)

		tilez[i].snapz.set_rgb(col1[0],col1[1],col1[2])
		tilez[i].gr_snapz.set_rgb(col1[0],col1[1],col1[2])

		tilez[i].txbox.visible = false
		if (!prf.TITLEONBOX) tilez[i].txbox.visible = true
	}
	else if (tilez[i].gr_snapz.file_name.find("category_images_10") == null) {
		if (prf.BOXARTMODE) {
			noboxart = false
			tilez[i].snapz.shader = tilez[i].gr_snapz.shader = colormapper["NONE"].shad
			tilez[i].snapz.set_rgb (255,255,255)
			tilez[i].gr_snapz.set_rgb (255,255,255)
			tilez[i].txbox.visible = false
		}
		else {
			if (tilez[i].gr_snapz.texture_width == 0 ) tilez[i].gr_snapz.file_name = "snapx"+( (fe.game_info(Info.Title,indexoffsetvar).len() % 7))+".png"
			tilez[i].snapz.set_rgb (255,255,255)
			tilez[i].gr_snapz.set_rgb (255,255,255)
			tilez[i].txbox.visible = false
		}
	}

	// NO CROPSNAP BUT REAL ARTWORK ASPECT RATIO FITTED AND CROPPED TO BEST RATIO
	// SNAP IS POSITIONED ACCORDING TO FUZZY ORIENTATION OF GAME OR BOXART

	local ARdata = ARprocess(cropaspect)

	tilez[i].snapz.set_pos(selectorscale * widthpadded * ARdata.x, selectorscale * (widthpadded * ARdata.y - verticalshift), selectorscale * widthpadded * ARdata.w, selectorscale * widthpadded * ARdata.h)
	if (prf.SNAPGRADIENT) tilez[i].gr_overlay.set_pos(selectorscale * widthpadded * ARdata.x, selectorscale * (widthpadded * ARdata.y - verticalshift), selectorscale * widthpadded * ARdata.w, selectorscale * widthpadded * ARdata.h)

	local vidAR = getAR(tilez[i].offset,tilez[i].vidsz,var,false) //This is the AR of the game video if it was not on boxart mode

	if (aspect > cropaspect){ // Cut sides
		tilez[i].gr_snapz.subimg_width = tilez[i].snapz.subimg_width = tilez[i].snapz.texture_width * (cropaspect/aspect)
		tilez[i].gr_snapz.subimg_height = tilez[i].snapz.subimg_height = tilez[i].snapz.texture_height
		tilez[i].gr_snapz.subimg_x = tilez[i].snapz.subimg_x = 0.5*(tilez[i].snapz.texture_width - tilez[i].snapz.subimg_width)
		tilez[i].gr_snapz.subimg_y = tilez[i].snapz.subimg_y = 0.0
	}
	else { // Cut top and bottom
		tilez[i].gr_snapz.subimg_width = tilez[i].snapz.subimg_width = tilez[i].snapz.texture_width
		tilez[i].gr_snapz.subimg_height = tilez[i].snapz.subimg_height = tilez[i].snapz.texture_height * (aspect/cropaspect)
		tilez[i].gr_snapz.subimg_x = tilez[i].snapz.subimg_x = 0.0
		tilez[i].gr_snapz.subimg_y = tilez[i].snapz.subimg_y = 0.5*(tilez[i].snapz.texture_height - tilez[i].snapz.subimg_height)
	}

	// VIDEO SNAPS CROPPER
	if (prf.THUMBVIDEO){
		tilez[i].vidsz.set_pos(tilez[i].snapz.x,tilez[i].snapz.y,tilez[i].snapz.width,tilez[i].snapz.height)

		if (vidAR > cropaspect){ // Cut sides
			tilez[i].gr_vidsz.subimg_width = tilez[i].vidsz.subimg_width = tilez[i].vidsz.texture_width * (cropaspect/vidAR)
			tilez[i].gr_vidsz.subimg_height = tilez[i].vidsz.subimg_height = tilez[i].vidsz.texture_height
			tilez[i].gr_vidsz.subimg_x = tilez[i].vidsz.subimg_x = 0.5*(tilez[i].vidsz.texture_width - tilez[i].vidsz.subimg_width)
			tilez[i].gr_vidsz.subimg_y = tilez[i].vidsz.subimg_y = 0.0
		}
		else { // Cut top and bottom
			tilez[i].gr_vidsz.subimg_width = tilez[i].vidsz.subimg_width = tilez[i].vidsz.texture_width
			tilez[i].gr_vidsz.subimg_height = tilez[i].vidsz.subimg_height = tilez[i].vidsz.texture_height * (vidAR/cropaspect)
			tilez[i].gr_vidsz.subimg_x = tilez[i].vidsz.subimg_x = 0.0
			tilez[i].gr_vidsz.subimg_y = tilez[i].vidsz.subimg_y = 0.5*(tilez[i].vidsz.texture_height - tilez[i].vidsz.subimg_height)
		}
	}

	// ACTIVATE LCD SHADER FOR SNAPS
	local remapcolor = recolorise (tilez[i].offset , var)
	if (!prf.BOXARTMODE){
		tilez[i].snapz.set_rgb (255,255,255)
		tilez[i].gr_snapz.set_rgb (255,255,255)

		tilez[i].snapz.shader = tilez[i].gr_snapz.shader = colormapper[remapcolor].shad
	}

	// ACTIVATE LCD SHADER FOR VIDEOS
	tilez[i].vidsz.shader = tilez[i].gr_vidsz.shader = colormapper[remapcolor].shad

	update_gradient(i,noboxart)
}

function update_borderglow(i,var,aspect){
	aspect = clampaspect (aspect)

	local bd_margin = padding * whitemargin

	tilez[i].bd_mx.visible = true
	tilez[i].glomx.visible = prf.SNAPGLOW

	if (prf.SNAPGLOW) {
		tilez[i].glomx.shader = snap_glow[i]
	}

	local ARdata = ARprocess(aspect)
	/*
	local sysAR = systemAR(tilez[i].offset,var)
	if (!prf.BOXARTMODE){
		if ((aspect != sysAR) && (sysAR != 0.0)) aspect = sysAR
		ARdata = ARprocess(aspect)
	}
	*/
	tilez[i].bd_mx.set_pos (selectorscale * (widthpadded * ARdata.x - bd_margin), selectorscale * (widthpadded * ARdata.y - verticalshift - bd_margin) , selectorscale * (widthpadded * ARdata.w + 2.0*bd_margin), selectorscale * (widthpadded * ARdata.h + 2.0*bd_margin))
	if (prf.SNAPGLOW) {

		local ARadapter = { x=0,y=0,w=0,h=0,m = 70.0/640.0 }
		ARadapter.w = 1.0 / (ARdata.w + 2 * ARadapter.m)
		ARadapter.h = - 1.0 / (ARdata.h + 2 * ARadapter.m)
		ARadapter.x = 0.5 - 0.5 * ARadapter.w
		ARadapter.y = 0.5 - 0.5 * ARadapter.h

		snap_glow[i].set_param ("adapter", ARadapter.x, ARadapter.y, ARadapter.w, ARadapter.h)

		local ARglow = { x = 0, y = 0, w = 0, h = 0, border = (100.0 + 35.0)/640.0}
		ARglow.w = ARdata.w - 35.0 * 2.0 / 640.0
		ARglow.h = ARdata.h - 35.0 * 2.0 / 640.0
		ARglow.x = (1.0 - ARglow.w - 2.0 * ARglow.border) * 0.5
		ARglow.y = (1.0 - ARglow.h - 2.0 * ARglow.border) * 0.5

		snap_glow[i].set_param ("glow", ARglow.x, ARglow.y, ARglow.border)

	}
	//if (prf.SNAPGLOW) tilez[i].glomx.set_pos(0,-selectorscale*verticalshift)
}

function update_thumbdecor(i,var,aspect){
	aspect = clampaspect (aspect)

	if (z_list.size == 0) return

	local z_list_target = modwrap(z_list.index + tilez[i].offset + var,z_list.size)
	local fe_list_target = z_list.gametable[ z_list_target ].z_felistindex

	z_list.gametable[ z_list_target ].z_playedcount = fe.game_info(Info.PlayedCount, fe_list_target - fe.list.index)

	tilez[i].donez.visible = ((z_list.gametable [ z_list_target ].z_tags).find("COMPLETED") != null)

	tilez[i].availz.visible = prf.REDCROSS && ((z_list.gametable[z_list_target].z_system != "") && (z_list.gametable[z_list_target].z_fileisavailable != "1"))

	//TEST104
	//tilez[i].obj.alpha = (prf.SHOWHIDDEN ? (z_checkhidden(fe_list_target - fe.list.index) ? 80 : 255) : 255)

	tilez[i].alphazero = (prf.SHOWHIDDEN ? (z_checkhidden(fe_list_target - fe.list.index) ? 80 : 255) : 255)
	tilez[i].obj.alpha = tilez[i].alphazero * tilez[i].alphafade/255.0

	tilez[i].favez.visible = (z_list.gametable[ z_list_target ].z_favourite == "1")

	tilez[i].logoz.visible = tilez[i].loshz.visible = ((!(prf.BOXARTMODE) && prf.TITLEONSNAP) || (prf.BOXARTMODE && prf.TITLEONBOX))

	tilez[i].nw_mx.visible = !prf.LOGOSONLY && (z_list.gametable[ z_list_target ].z_playedcount == "0")

	//Check if the only tags present are "COMPLETED" or "HIDDEN"
	local tagcheckerlist = z_list.gametable [ z_list_target ].z_tags
	if (
		((tagcheckerlist.len() == 1) && ((tagcheckerlist[0] == "COMPLETED") || (tagcheckerlist[0] == "HIDDEN"))) ||
		((tagcheckerlist.len() == 2) && ((tagcheckerlist[0] == "COMPLETED") && (tagcheckerlist[1] == "HIDDEN"))) ||
		((tagcheckerlist.len() == 2) && ((tagcheckerlist[1] == "COMPLETED") && (tagcheckerlist[0] == "HIDDEN")))
	){
		tilez[i].tg_mx.visible = false
	}
	else if (prf.TAGNAME == "") tilez[i].tg_mx.visible = (tagcheckerlist.len() >= 1)
	else tilez[i].tg_mx.visible = ((z_list.gametable [ z_list_target ].z_tags).find(prf.TAGNAME) != null)

	local ARdata = ARprocess(aspect)
	/*
	local sysAR = systemAR(tilez[i].offset,var)
	if (!prf.BOXARTMODE){
		if ((aspect != sysAR) && (sysAR != 0.0)) aspect = sysAR
		ARdata = ARprocess(aspect)
	}
	*/
	local ARshadow = { x = 0, y = 0, w = 0, h = 0, border = (100.0 + 60.0)/640.0 }
	ARshadow.w = ARdata.w - 60.0 * 2.0 / 640.0
	ARshadow.h = ARdata.h - 60.0 * 2.0 / 640.0
	ARshadow.x = (1.0 - ARshadow.w - 2.0 * ARshadow.border) * 0.5
	ARshadow.y = (1.0 - ARshadow.h - 2.0 * ARshadow.border) * 0.5

	tilez[i].sh_mx.shader.set_param ("shadow", ARshadow.x, ARshadow.y, ARshadow.border)

	tilez[i].sh_mx.visible = true

	tilez[i].nw_mx.set_pos (selectorscale * ARdata.x * widthpadded , selectorscale * ( (ARdata.y + ARdata.h) * widthpadded - height/8.0 - verticalshift))
	tilez[i].tg_mx.set_pos (selectorscale *( (ARdata.x + ARdata.w) * widthpadded - height/8.0), selectorscale * ( (ARdata.y + ARdata.h) * widthpadded - height/10.0 - verticalshift))

}


function switchmode(){
	if (prf.LOGOSONLY) return
	prf.BOXARTMODE = !prf.BOXARTMODE

	z_listrefreshtiles()
	updatebgsnap (focusindex.new)

	DISPLAYTABLE [fe.displays[fe.list.display_index].name] <- (prf.BOXARTMODE ? ["BOXES"] : ["SNAPS"])
	//	try{fe.nv["AF_Display_Type"] <- DISPLAYTABLE} catch (err) {}
	savetabletofile(DISPLAYTABLE,"pref_thumbtype.txt")
}

function new_search(){
	frostshow()

	keyboard_search()

	if (prf.LIVESEARCH) frosthide()
	zmenuhide()
}

umtable = []

function sortarrays(){
	local out = {
		switcharray_sort = [
			""+ ltxt("Title",TLNG) + " ▲",
			""+ ltxt("Title",TLNG) + " ▼",
			""+ ltxt("Manufacturer",TLNG) + " ▲",
			""+ ltxt("Manufacturer",TLNG) + " ▼",
			""+ ltxt("Year",TLNG) + " ▲",
			""+ ltxt("Year",TLNG) + " ▼",
			""+ ltxt("Category",TLNG) + " ▲",
			""+ ltxt("Category",TLNG) + " ▼",
			""+ ltxt("System",TLNG) + " ▲",
			""+ ltxt("System",TLNG) + " ▼",

			""+ ltxt("Rating",TLNG),
			""+ ltxt("Series",TLNG),

			""+ ltxt("Last Played",TLNG),
			""+ ltxt("Last Favourite",TLNG),
		]

		glypharray_sort = []

		nowsort = 0
	}

	out.glypharray_sort.push (((z_list.orderby == Info.Title) && (z_list.reverse == false)) ? 0xea10 : 0)
	out.glypharray_sort.push (((z_list.orderby == Info.Title) && (z_list.reverse == true)) ? 0xea10 : 0)
	out.glypharray_sort.push (((z_list.orderby == Info.Manufacturer) && (z_list.reverse == false)) ? 0xea10 : 0)
	out.glypharray_sort.push (((z_list.orderby == Info.Manufacturer) && (z_list.reverse == true)) ? 0xea10 : 0)
	out.glypharray_sort.push (((z_list.orderby == Info.Year) && (z_list.reverse == false)) ? 0xea10 : 0)
	out.glypharray_sort.push (((z_list.orderby == Info.Year) && (z_list.reverse == true)) ? 0xea10 : 0)
	out.glypharray_sort.push (((z_list.orderby == Info.Category) && (z_list.reverse == false)) ? 0xea10 : 0)
	out.glypharray_sort.push (((z_list.orderby == Info.Category) && (z_list.reverse == true)) ? 0xea10 : 0)
	out.glypharray_sort.push (((z_list.orderby == Info.System) && (z_list.reverse == false)) ? 0xea10 : 0)
	out.glypharray_sort.push (((z_list.orderby == Info.System) && (z_list.reverse == true)) ? 0xea10 : 0)

	out.glypharray_sort.push (((z_list.orderby == z_info.z_rating) && (z_list.reverse == true)) ? 0xea10 : 0)
	out.glypharray_sort.push (((z_list.orderby == z_info.z_series) && (z_list.reverse == false)) ? 0xea10 : 0)

	out.glypharray_sort.push (((z_list.orderby == z_info.z_rundate) && (z_list.reverse == true)) ? 0xea10 : 0)
	out.glypharray_sort.push (((z_list.orderby == z_info.z_favdate) && (z_list.reverse == true)) ? 0xea10 : 0)


 	for (local i = 0 ; i < out.glypharray_sort.len() ; i++) {
		if (out.glypharray_sort[i] != 0) out.nowsort = i
	}

	return (out)
}

function buildutilitymenu(){

	umtable.push ({
		label = ltxt("Sort and Filter",TLNG)
		glyph = -1
		visible = true
		order = 0
		id = 0
		sidenote = function (){return ""}
		command = function (){return}
	})

	umtable.push ({
		label = ltxt("Sort by",TLNG)
		glyph = 0xea4c
		visible = true
		order = 0
		id = 0
		sidenote = function(){
			local dat = sortarrays()
			return dat.switcharray_sort[dat.nowsort]
		}
		command = function(){

			if (!prf.ENABLESORT) return
			// switcharray, glypharray and nowsort moved out of this function so it's available to sidenote
			local dat = sortarrays()

			zmenudraw (dat.switcharray_sort,dat.glypharray_sort,null,"  " + ltxt("Sort by",TLNG)+"...",0xea4c,dat.nowsort,false,false,false,false,
			function(result2){
				local result_sort = []
				if 	  (result2 == 0) result_sort = [Info.Title,false]
				else if (result2 == 1) result_sort = [Info.Title,true]
				else if (result2 == 2) result_sort = [Info.Manufacturer,false]
				else if (result2 == 3) result_sort = [Info.Manufacturer,true]
				else if (result2 == 4) result_sort = [Info.Year,false]
				else if (result2 == 5) result_sort = [Info.Year,true]
				else if (result2 == 6) result_sort = [Info.Category,false]
				else if (result2 == 7) result_sort = [Info.Category,true]
				else if (result2 == 8) result_sort = [Info.System,false]
				else if (result2 == 9) result_sort = [Info.System,true]

				else if (result2 == 10) result_sort = [z_info.z_rating,true]
				else if (result2 == 11) result_sort = [z_info.z_series,false]

				else if (result2 == 12) result_sort = [z_info.z_rundate,true]
				else if (result2 == 13) result_sort = [z_info.z_favdate,true]

				if (result2 != -1 ){
					/*
					umvisible = false
					frosthide()
					zmenuhide()
					*/

					z_listsort(result_sort[0],result_sort[1])
					z_liststupdateindex() //When sorting the index is always there, and no need to rebuild the list
					z_liststops()
					z_listrefreshlabels()
					z_listrefreshtiles()

					utilitymenu(umpresel)

					//if (DBGON) z_listprint (z_list.gametable)
					//if (DBGON) z_stopprint (z_list.jumptable)
				}
				else {
					utilitymenu(umpresel)
				}
			})
		}
	})

	umtable.push ({
		label = ltxt ("Jump to",TLNG)
		glyph = 0xea22
		visible = true
		order = 0
		id = 0
		sidenote = function(){
			try {return (z_list.jumptable[z_list.index].key)} catch (err){return("")}
		}
		command = function(){

			local currentkey = z_list.jumptable[z_list.index].key

			local textarray = []
			foreach (i,item in labelorder) textarray.push (item)

			local currentindex = textarray.find(currentkey)

			local glypharray = []
			foreach (i,item in textarray) glypharray.push (i == currentindex ? 0xea10 : 0)

			zmenudraw (textarray,glypharray,null, "Jump To",0xea22,currentindex,false,false,false,false,
			function(out){
				if (out == -1) {
					utilitymenu(umpresel)
				}
				else {
					local delta = abs(out - currentindex)
					local fwd = (out - currentindex >= 0)

					local indexjump = z_list.index

					for (local i = 0; i < delta; i++){
						indexjump = fwd ? z_list.jumptable[indexjump].next : z_list.jumptable[indexjump].prev
					}
					z_list_indexchange (indexjump)

					umvisible = false
					zmenuhide()
					frosthide()

				}
			})
		}
	})

	umtable.push ({
		label = ltxt("Favourites Filter",TLNG)
		glyph = 0xe9d9
		visible = true
		order = 0
		id = 0
		sidenote = function(){
			local out = ""
			try {out = multifilterz.l0["Favourite"].menu["Favourite"].filtered ? "FAVOURITES" : "ALL GAMES"} catch(err){}
			return (ltxt(out,TLNG))
		}
		command = function(){
			try{
				if (multifilterz.l0["Favourite"].menu["Favourite"].filtered){
					multifilterz.l0["Favourite"].menu["Favourite"].filtered = null
				}
				else multifilterz.l0["Favourite"].menu["Favourite"].filtered = true


				mfz_populate()
				mfz_apply(false)
				utilitymenu(umpresel)
			}
			catch (err){return}
		}
	})

	umtable.push ({
		label = ltxt("Multifilter",TLNG)
		glyph = 0xeaed
		visible = true
		order = 0
		id = 0
		sidenote = function(){
			local numf = mfz_num()
			return (numf > 0 ? numf + " FILTERS" : "NO FILTER")
		}
		command = function(){
			zmenu.mfm = true
			mfmbgshow()
			mfz_menu0(0)
		}
	})

	umtable.push ({
		label = ltxt("Filters",TLNG)
		glyph = 0xea5b
		visible = true
		order = 0
		id = 0
		sidenote = function(){
			return (( (fe.filters.len() != 0) ? fe.filters[fe.list.filter_index].name : "" ))
		}
		command = function(){
			fe.signal("filters_menu")
		}
	})

	umtable.push ({
		label = ltxt("Displays",TLNG)
		glyph = 0xe912
		visible = true
		order = 0
		id = 0
		sidenote = function(){

			local splitname = split( fe.displays[fe.list.display_index].name , "#")
			local displayname = ""
			if (splitname.len()>1)
				displayname = splitname[0]
			else
				displayname = fe.displays[fe.list.display_index].name

			if (prf.DMPGENERATELOGO) {
				try {displayname = system_data[displayname.tolower()].sysname}
				catch(err){}
			}
			if (displayname[0].tochar() == "!") {
				displayname = displayname.slice(1)
			}

			return displayname
		}
		command = function(){
			fe.signal("displays_menu")
		}
	})

	umtable.push ({
		label = ltxt("Categories",TLNG)
		glyph = 0xe916
		visible = true
		order = 0
		id = 0
		sidenote = function(){
		return ((search.catg[0] != "") ? search.catg[0]+(search.catg[1] == "" ? "" : "/"+search.catg[1]) : ltxt("ALL",TLNG))
		}
		command = function(){
			categorymenu()
		}
	})

	umtable.push ({
		label = ltxt("Search",TLNG)
		glyph = 0xe986
		visible = true
		id = 0
		order = 0
		sidenote = function(){
			return (search.smart == "" ? "NO SEARCH" : search.smart)
		}
		command = function(){
			new_search()
		}
	})

	umtable.push ({
		label = ltxt("Screensaver",TLNG)
		glyph = -1
		visible = true
		order = 0
		id = 0
		sidenote = function (){return ""}
		command = function (){return}
	})

	umtable.push ({
		label = ltxt("Attract mode",TLNG)
		glyph = 0xe9a5
		visible = true
		id = 0
		order = 0
		sidenote = function(){
			return "⏩"
		}
		command = function(){
			umvisible = false
			attractkick()
		}
	})

	umtable.push ({
		label = ltxt("Visuals",TLNG)
		glyph = -1
		visible = true
		order = 0
		id = 0
		sidenote = function (){return ""}
		command = function (){return}
	})

	umtable.push ({
		label = ltxt("Snaps or Box-Art",TLNG)
		glyph = 0xeaf3
		visible = true
		id = 0
		order = 0
		sidenote = function(){
			return (prf.BOXARTMODE ? "BOX ART" : "SNAPS")
		}
		command = function(){
			switchmode()
			if(prf.THEMEAUDIO) snd.wooshsound.playing = true
			utilitymenu(umpresel)
			/*
			umvisible = false
			frosthide()
			zmenuhide()
			*/
		}
	})

	umtable.push ({
		label = ltxt("Reset Box Art",TLNG)
		glyph = 0xe965
		visible = true
		id = 0
		order = 0
		sidenote = function(){
			return "⏩"
		}
		command = function(){
			umvisible = false
			DISPLAYTABLE = {}
			savetabletofile (DISPLAYTABLE,"pref_thumbtype.txt")
			fe.signal("reload")
			if(prf.THEMEAUDIO) snd.wooshsound.playing = true
		}
	})

	umtable.push ({
		label = ltxt("System",TLNG)
		glyph = -1
		visible = true
		order = 0
		id = 0
		sidenote = function (){return ""}
		command = function (){return}
	})

	umtable.push ({
		label = ltxt("Layout options",TLNG)
		glyph = 0xe991
		visible = true
		id = 0
		order = 0
		sidenote = function(){
			return "☰"
		}
		command = function(){
			umvisible = false
			fe.signal("layout_options")
		}
	})

	umtable.push ({
		label = ltxt ("Check for updates",TLNG)
		glyph = 0xe91c
		visible = true
		id = 0
		order = 0
		sidenote = function(){
			return "⏩"
		}
		command = function(){
			umvisible = false
			checkforupdates(true)
		}
	})

	umtable.push ({
		label = ltxt ("About Arcadeflow",TLNG)
		glyph = 0xea09
		visible = true
		id = 0
		order = 0
		sidenote = function(){
			return "☰"
		}
		command = function(){
			local aboutpath = fe.path_expand( AF.folder + (AF.version.tofloat()*10).tostring() + ".txt")
			local aboutfile = ReadTextFile (aboutpath)

			local textarray = []
			local glypharray = []

			while (!aboutfile.eos()){
				textarray.push(aboutfile.read_line())
				glypharray.push (0xea08)
			}

			textarray[0] = "What's New"
			glypharray[0] = 0

			zmenudraw (textarray,glypharray,null, "Arcadeflow "+AF.version,0xea09,0,false,false,false,false,
			function(out){
				if (out == -1) {
					utilitymenu (umpresel)
					//zmenuhide()
					//frosthide()
				}
			})
		}
	})

	local v0 = split(prf.UMVECTOR,",")

	for (local i = 0 ; i < v0.len() ; i++){
		umtable[i].id = i
		umtable[abs(v0[i].tointeger()) - 1].visible = v0[i].tointeger() > 0
		umtable[abs(v0[i].tointeger()) - 1].order = i
	}

	umtable.sort(@(a,b) a.order <=> b.order)
}

buildutilitymenu()


function utilitymenu(presel){
	umvisible = true

	local switcharray1 = []
	local glypharray1 = []
	local codearray1 = []
	local sidearray1 = []

	local codei = 0

	foreach (item in umtable){
		if (item.visible){
			switcharray1.push (item.label)
			glypharray1.push (item.glyph)
			codearray1.push (codei)
			sidearray1.push (item.sidenote())
		}
		codei++
	}

	/*
	foreach (i,item in sidearray1){
		sidearray1[i] = i.tostring()
	}
	*/

	frostshow()
	zmenudraw (switcharray1, glypharray1, sidearray1, (ltxt("Utility Menu",TLNG) ),0xe9bd,presel,false,false,false,false,
	function(result1){
		if (result1 == -1){
			umvisible = false
			frosthide()
			zmenuhide()
		}
		else {
			umpresel = codearray1[result1]
			umtable[codearray1[result1]].command()
		}
	})
}

function z_resetthumbvideo(index){
	tilez[index].gr_vidsz.alpha = 0
	tilez[index].vidsz.alpha = 0
	tilez[index].gr_vidsz.file_name = "pics/transparent.png"
	gr_vidszTableFade[index] = [0.0,0.0,0.0,0.0,0.0]
	aspectratioMorph[index] = [0.0,0.0,0.0,0.0,0.0]
	vidpos[index] = 0
}


function updatescrollerposition(){
	scroller.x = footermargin + ((z_list.index/rows)*rows*1.0/(z_list.size - 1 ))*(fl.w - 2.0*footermargin-scrollersize)
	scroller2.x = scroller.x-scrollersize*0.5
}

function resetvarsandpositions(){
	var = 0
	tilesTablePos.Offset = 0

	//TEST105
	impulse2.flow = 0.5
	impulse2.step = 0
	impulse2.delta = 0
	impulse2.filtern = 0
	srfposhistory = array(impulse2.samples, impulse2.step)

	column.offset = 0
	centercorr.val = 0
	centercorr.shift = centercorr.zero

	// loop for all tiles
	for (local i = 0; i < tiles.total ; i++ ) {

		// reset video fade data
		if (prf.THUMBVIDEO) z_resetthumbvideo(i)

		// cleanup position of tiles
		picsize (tilez[i].obj , widthpadded, heightpadded,0,-verticalshift*1.0/widthpadded)
		tilez[i].obj.zorder = -2
		tilez[i].obj.visible = false
		tilesTableZoom[i] = [0.0,0.0,0.0,0.0,0.0]
		tilesTableUpdate[i] = [0.0,0.0,0.0,0.0,0.0]
		tilez[i].bd_mx.bg_alpha = tilez[i].bd_mx_alpha = 0
		tilez[i].glomx.alpha = tilez[i].glomx_alpha = 0
	}
}

function updatetiles() {
	corrector = (rows == 1 ? -1 : -((z_list.index + var) % rows) )

	column.stop = floor((z_list.index + var )*1.0/rows)
	column.start = floor((z_list.index )*1.0/rows)

	column.offset = (column.stop - column.start)
	tilesTablePos.Offset += column.offset*rows


	// Determine center position correction when reaching beginning or end of list
	centercorr.shift = 0
	centercorr.val = 0

	if ((column.stop < deltacol) && (var < 0) ) {
		if (column.stop == deltacol - 1 )
			centercorr.shift = centercorr.zero + (deltacol - 1) * (widthmix + padding)
		else
			centercorr.shift = - (widthmix + padding)
	}
	else if ((column.start < deltacol) && (var > 0)) {
		if (column.start == deltacol - 1 )
			centercorr.shift = - centercorr.zero - (deltacol - 1) * (widthmix + padding)
		else
			centercorr.shift = (widthmix + padding)
	}

	if (z_list.index + var <= deltacol * rows -1){
		centercorr.val = centercorr.zero + floor((z_list.index + var)/rows) * (widthmix + padding)
	}

	if (column.offset == 0) centercorr.shift = 0
}

function changetiledata(i,index,update){

	// i is 0 - number of tiles
	// index is i centered on current tile + correction

	local indexTemp = wrap( i + tilesTablePos.Offset, tiles.total )
	local indexvar = modwrap(z_list.index + index + var,z_list.size)

	// .offset is used for old style game.info reference
	// .index is used for direct z_list reference
	tilez[indexTemp].offset = index
	tilez[indexTemp].index = indexvar

	local indexoffset = 0
	if (z_list.size > 0 ) indexoffset = (z_list.gametable[modwrap(z_list.index + index,z_list.size)].z_felistindex) - fe.list.index
	local indexoffsetvar = 0
	if (z_list.size > 0) indexoffsetvar = (z_list.gametable[modwrap(z_list.index + index + var ,z_list.size)].z_felistindex) - fe.list.index

	if ((update) && (z_list.size > 0)){
		// old style access: fe.get_art must reference old romlist
		tilez[indexTemp].loshz.file_name = fe.get_art("wheel" , indexoffsetvar,0,Art.ImagesOnly)
		tilez[indexTemp].gr_snapz.file_name = fe.get_art((prf.BOXARTMODE ? prf.BOXARTSOURCE : (prf.TITLEART ? "title" : "snap")) , indexoffsetvar,0,Art.ImagesOnly)

		if (prf.THUMBVIDEO) z_resetthumbvideo(indexTemp)

		//RESIZER
		logotitle = wrapme(gamename2(z_list.gametable[indexvar].z_felistindex) ,9,3)
		tilez[indexTemp].txt2z.msg = tilez[indexTemp].txt1z.msg = tilez[indexTemp].txshz.msg = logotitle.text

		tilez[indexTemp].txshz.char_size = min( ((tilez[indexTemp].txshz.width*100.0/600.0)*9)/logotitle.cols , ((tilez[indexTemp].txshz.width*100.0/600.0)*3)/logotitle.rows )
		tilez[indexTemp].txt2z.char_size = tilez[indexTemp].txt1z.char_size = tilez[indexTemp].txshz.char_size * tilez[indexTemp].txt1z.width / tilez[indexTemp].txshz.width

		tilez[indexTemp].txt2z.x = tilez[indexTemp].txt1z.x + 0.015 * tilez[indexTemp].txt1z.char_size
		tilez[indexTemp].txt2z.y = tilez[indexTemp].txt1z.y - 0.025 * tilez[indexTemp].txt1z.char_size

		boxtitle = wrapme( gamename2(z_list.gametable[indexvar].z_felistindex) ,6,4)
		tilez[indexTemp].txbox.msg = boxtitle.text

		tilez[indexTemp].txbox.char_size = min( ((tilez[indexTemp].txbox.width*100.0/400.0)*6)/boxtitle.cols , ((tilez[indexTemp].txbox.width*100.0/400.0)*4)/boxtitle.rows )

		local gameAR = getAR(tilez[indexTemp].offset,tilez[indexTemp].snapz,var,prf.BOXARTMODE)
		//if (prf.LOGOSONLY) gameAR = 2.0 //TEST107
		update_snapcrop (indexTemp, var, indexoffsetvar, indexvar, gameAR, 0)

		// Update visibility of horizontal or vertical shadows, glow, indicator etc
		update_thumbdecor(indexTemp,var,tilez[indexTemp].AR.crop)
		if (tilez[indexTemp].bd_mx_alpha != 0) update_borderglow(indexTemp,var,tilez[indexTemp].AR.crop)

	}
	tilez[indexTemp].obj.zorder = -2

	tilesTablePos.X[indexTemp] = (i/rows) * (widthmix + padding) + carrierT.x + centercorr.val + widthpaddedmix*0.5
	tilesTablePos.Y[indexTemp] = (i%rows) * (height + padding) + carrierT.y + heightpadded * 0.5

	//TEST101 THIS INTERACTS WITH OFF SCREEN VISIBILITY
	//tilez[indexTemp].obj.visible = (( (z_list.index + var + index < 0) || (z_list.index + var + index > z_list.size-1) ) == false)
	tilez[indexTemp].offlist = (( (z_list.index + var + index < 0) || (z_list.index + var + index > z_list.size-1) ))
	//index++
}

function finaltileupdate(){

		// updates the size and features of the previously selected item and new selected item
		focusindex.new = wrap( floor(tiles.total/2)-1-corrector + tilesTablePos.Offset, tiles.total )
		focusindex.old = wrap( floor(tiles.total/2)-1-corrector -var + tilesTablePos.Offset, tiles.total )

		if (!history_visible() && (scroll.jump == false) && (scroll.sortjump == false) && (zmenu.showing == false)) {
			tilesTableZoom[focusindex.old] = startfade (tilesTableZoom[focusindex.old],-0.055,1.0)
			tilesTableZoom[focusindex.new] = startfade (tilesTableZoom[focusindex.new],0.035,-5.0)
		}

		tilesTableUpdate[focusindex.old] = startfade (tilesTableUpdate[focusindex.old],-0.055,1.0)
		tilesTableUpdate[focusindex.new] = startfade (tilesTableUpdate[focusindex.new],0.035,-5.0)

		//activate video load counter
		if ((prf.THUMBVIDEO) ){
			gr_vidszTableFade[focusindex.old] = startfade (gr_vidszTableFade[focusindex.old],prf.LOGOSONLY ? -0.04 : -0.01,1.0)
			aspectratioMorph[focusindex.old] = startfade (aspectratioMorph[focusindex.old],-0.08,1.0)
			vidpos[focusindex.old] = 0

			if (tilez[focusindex.new].gr_vidsz.alpha == 0) {
				vidpos[focusindex.new] = vidstarter
				vidindex[focusindex.new] = tilez[focusindex.new].offset
			}
			else {
				gr_vidszTableFade[focusindex.new] = startfade (gr_vidszTableFade[focusindex.new],0.03,1.0)
				aspectratioMorph[focusindex.new] = startfade (aspectratioMorph[focusindex.new],0.06,1.0)
			}
		}
		tilez[focusindex.old].obj.zorder = -2
		tilez[focusindex.new].obj.zorder = -1
		letterobj.zorder = 0

		update_borderglow(focusindex.new,var,tilez[focusindex.new].AR.crop)

		// trigger squaring of background thumbs
		squarizer = true
}

function z_listrefreshtiles(){
	logotitle = null
	boxtitle = null

	updatescrollerposition()

	// Reset vars and positions
	resetvarsandpositions()

	//if (z_list.size > 0 ) {
		updatetiles()

		// change all the tiles

		local index = - (floor(tiles.total/2) -1) + corrector

		for (local i = 0; i < tiles.total ; i++ ) {
			changetiledata(i,index,true)
			index++
		}

		finaltileupdate()

	//}
}

function z_updatefilternumbers(idx){
	filternumbers.msg = (prf.CLEANLAYOUT ? "" : (idx+1)+"\n"+(z_list.size))
}

function z_listrefreshlabels(){
	// Clean old ticks and labels
	filterdata.msg = (prf.CLEANLAYOUT ? "" : ( ( (fe.filters.len() == 0) ? "" : fe.filters[fe.list.filter_index].name+ "\n")  + gamelistorder(0)))

	try {
		foreach (label in sortlabels){
			label.visible = false
		}
		foreach (tick in sortticks){
			tick.visible = false
		}
	}
	catch (err){}

	// Reinitialize tables
	labelorder = []
	labelcounter = {}
	sortlabels = {}
	sortticks = {}

	// Count how many games are in each label
	for (local i = 0 ; i < z_list.size ; i++){
		local s = (z_list.jumptable[i].key)
		try { labelcounter[s]++ }
		catch (err) {
			labelcounter[s] <- 1
			labelorder.push (s)
		}
	}

	local i = 0
	local w0 = fl.w - 2 * footermargin
	local x0 = footermargin
	local x00 = 0
	local label = {
		w = 100*scalerate,
		h = 40 * scalerate,
		font = 30 * scalerate
	}

	local label_obj = null

	if (prf.SCROLLERTYPE == "labellist"){

		w0 = (fl.w-2*footermargin)*1.0
		x0 = (fl.w-w0) * 0.5
		x00 = 0
		label = {
			w = 100 * scalerate,
			h = 40 * scalerate,
			font = 30 * scalerate
		}

		if (prf.LOWRES){
			label = {
				w = 150 * scalerate,
				h = 70 * scalerate,
				font = 45 * scalerate
			}
		}

		labelstrip.set_pos (x0,fl.h-footer.h*0.5-label.h*0.5+fl.y,w0,label.h)
		labelstrip.set_rgb (themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)
		labelstrip.alpha = 100
		//labelstrip.visible = false

		//labelsurf.set_pos (0,0,w0,label.h)
		local labelarrayindex = 0
		foreach (key in labelorder){
			try{
				sortlabelsarray[labelarrayindex].msg = ((z_list.orderby == Info.Category ? categorylabel(key,0) : (z_list.orderby == Info.System ? systemlabel(key) : key) )).toupper()
				sortlabelsarray[labelarrayindex].x = x00
				sortlabelsarray[labelarrayindex].y = 0
				sortlabelsarray[labelarrayindex].width = floor(w0/labelorder.len())
				sortlabelsarray[labelarrayindex].height = floor(label.h)
			}
			catch(err){
				sortlabelsarray.push(null)
				sortlabelsarray[labelarrayindex] = labelsurf.add_text( ((z_list.orderby == Info.Category ? categorylabel(key,0) : (z_list.orderby == Info.System ? systemlabel(key) : key) )).toupper() ,x00,0,w0/labelorder.len(),label.h)
			}

			sortlabelsarray[labelarrayindex].char_size = label.font
			sortlabelsarray[labelarrayindex].font = uifonts.gui
			sortlabelsarray[labelarrayindex].margin = 0
			sortlabelsarray[labelarrayindex].align = Align.MiddleCentre
			sortlabelsarray[labelarrayindex].set_rgb (255,255,255)
			sortlabelsarray[labelarrayindex].set_bg_rgb (0,0,0)
			sortlabelsarray[labelarrayindex].bg_alpha = 255
			sortlabelsarray[labelarrayindex].alpha = 255
			sortlabelsarray[labelarrayindex].visible = true
			x00 = x00 + w0/labelorder.len()
			sortlabels[key] <- sortlabelsarray[labelarrayindex]
			resetkey (key)
			labelarrayindex ++
		}
		labelsurf.set_rgb(themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)
		labelsurf.shader = txtoalpha

		labelsurf.set_pos(x0,fl.h-footer.h*0.5-label.h*0.5)
		if ((prf.SCROLLERTYPE == "labellist") && (z_list.size !=0 ) ) upkey (z_list.jumptable[z_list.index].key)
	}

	if (prf.SCROLLERTYPE == "timeline"){
		labelstrip.set_pos(x0,fl.y+fl.h - footer.h * 0.5,w0,label.h)
		labelstrip.set_rgb (themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)
		labelstrip.alpha = 100
		//labelstrip.visible = false
		local labelarrayindex = 0
		foreach (key in labelorder){
			i=1 // REMOVE FOR ALTERNATING LETTERS
			local labelspacer = labelcounter[key] * w0 / z_list.size
			try{
				sortlabelsarray[labelarrayindex].msg = ((z_list.orderby == Info.Category ? categorylabel (key,0) : (z_list.orderby == Info.System ? systemlabel(key) : key))).toupper()
				sortlabelsarray[labelarrayindex].x = x0 + labelspacer*0.5 - label.w*0.5
				sortlabelsarray[labelarrayindex].y = fl.h - footer.h * 0.5
				sortlabelsarray[labelarrayindex].width = label.w
				sortlabelsarray[labelarrayindex].height = label.h
			}
			catch(err){
				sortlabelsarray.push(null)
				sortlabelsarray[labelarrayindex] = data_surface.add_text(((z_list.orderby == Info.Category ? categorylabel (key,0) : (z_list.orderby == Info.System ? systemlabel(key) : key))).toupper(),x0 + labelspacer*0.5 - label.w*0.5, fl.h - footer.h * 0.5 , label.w,label.h)
			}

			sortlabelsarray[labelarrayindex].char_size = label.font
			sortlabelsarray[labelarrayindex].font = uifonts.lite
			sortlabelsarray[labelarrayindex].margin = 0
			sortlabelsarray[labelarrayindex].align = Align.MiddleCentre
			sortlabelsarray[labelarrayindex].set_rgb (themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)
			sortlabelsarray[labelarrayindex].set_rgb (themeT.themetextcolor,themeT.themetextcolor,themeT.themetextcolor)

			i++
			sortlabelsarray[labelarrayindex].visible = !( (labelspacer < 0.5*label.h) || ((searchdata.msg != "") && (abs(sortlabelsarray[labelarrayindex].x+sortlabelsarray[labelarrayindex].width*0.5-fl.w*0.5) < searchdata.msg_width)))

			if (labelspacer < sortlabelsarray[labelarrayindex].msg_width * 0.85) sortlabelsarray[labelarrayindex].visible = false

			try{
				sortticksarray[labelarrayindex].set_pos (x0,fl.h - footer.h * 0.5 - 0.5*label.h*0.5,1,0.5*label.h+1)
			}
			catch (err){
				sortticksarray.push(null)
				sortticksarray[labelarrayindex] = data_surface.add_image("pics/white.png",x0,fl.h - footer.h * 0.5 - 0.5*label.h*0.5,1,0.5*label.h+1)
			}

			sortticksarray[labelarrayindex].visible = true

			x0 = x0 + labelspacer
			sortlabels[key] <- sortlabelsarray[labelarrayindex]
			sortticks[key] <- sortticksarray[labelarrayindex]
			labelarrayindex ++
		}

		if (labelorder.len() != 0) sortticks[labelorder[0]].visible = false
	}

}


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

/*
try{testpr ("fl.surf:"+fl.surf.parents+"\n")}catch(err){}

try{testpr ("frost.surf_rt:"+frost.surf_rt.parents+"\n")}catch(err){}
try{testpr ("frost.surf_2:"+frost.surf_2.parents+"\n")}catch(err){}
try{testpr ("frost.surf_1:"+frost.surf_1.parents+"\n")}catch(err){}

try{testpr ("frost.pic:"+frost.pic.parents+"\n")}catch(err){}

try{testpr ("bglay.surf_rt:"+bglay.surf_rt.parents+"\n")}catch(err){}
try{testpr ("bglay.surf_2:"+bglay.surf_2.parents+"\n")}catch(err){}
try{testpr ("bglay.surf_1:"+bglay.surf_1.parents+"\n")}catch(err){}

try{testpr ("bgvidsurf_1:"+bgvidsurf_1.parents+"\n")}catch(err){}

try{testpr ("obj:"+tilez[0].obj.parents+"\n")}catch(err){}
try{testpr ("gradsurf_rt:"+gradsurf_rt.parents+"\n")}catch(err){}
try{testpr ("gradsurf_1:"+gradsurf_1.parents+"\n")}catch(err){}
try{testpr ("logosurf_rt:"+logosurf_rt.parents+"\n")}catch(err){}
try{testpr ("logosurf_1:"+logosurf_1.parents+"\n")}catch(err){}

try{testpr ("data_surface:"+data_surface.parents+"\n")}catch(err){}
try{testpr ("data_surface_sh_rt:"+data_surface_sh_rt.parents+"\n")}catch(err){}
try{testpr ("data_surface_sh_2:"+data_surface_sh_2.parents+"\n")}catch(err){}
try{testpr ("data_surface_sh_1:"+data_surface_sh_1.parents+"\n")}catch(err){}

try{testpr ("labelsurf:"+labelsurf.parents+"\n")}catch(err){}
try{testpr ("displaynamesurf:"+displaynamesurf.parents+"\n")}catch(err){}
try{testpr ("letterobjsurf:"+letterobjsurf.parents+"\n")}catch(err){}

try{testpr ("keyboard_surface:"+keyboard_surface.parents+"\n")}catch(err){}

try{testpr ("history_surface:"+history_surface.parents+"\n")}catch(err){}

try{testpr ("zmenu_surface_container:"+zmenu_surface_container.parents+"\n")}catch(err){}
try{testpr ("zmenu_surface:"+zmenu_surface.parents+"\n")}catch(err){}
try{testpr ("zmenu_sh.surf_rt:"+zmenu_sh.surf_rt.parents+"\n")}catch(err){}
try{testpr ("zmenu_sh.surf_2:"+zmenu_sh.surf_2.parents+"\n")}catch(err){}
try{testpr ("zmenu_sh.surf_1:"+zmenu_sh.surf_1.parents+"\n")}catch(err){}

testpr("\n")
*/

/// On Transition ///

function on_transition( ttype, var0, ttime ) {

	if (ttype == Transition.FromGame) {
		if (prf.RPI) fe.set_display(fe.list.display_index)
		update_thumbdecor (focusindex.new,0,tilez[focusindex.new].AR.current)

		mfz_build(true)
		try{
			mfz_load()
			mfz_populatereverse()
		} catch(err){}
		mfz_apply(true)

	}

	//DBGON transition
	debugpr ("\nTr:" + transdata[ttype] +" var0:" + var0 + "\n")

	if (ttype == Transition.ToGame){

		// Update the rundate table in memory
		local datetab = date()
		local datestr = datetab.year * 10000000000 + datetab.month * 100000000 + datetab.day * 1000000+datetab.hour*10000+datetab.min*100 + datetab.sec
		datestr = datestr.tostring()
		local gamename = z_list.gametable[z_list.index].z_name
		local emulatorname = z_list.gametable[z_list.index].z_emulator

		z_list.rundatetable[emulatorname][gamename] <- datestr

		//save the rundate table to file
		z_saverundatetofile()
	}

	if ((ttype == Transition.ToNewList) && (prf.JUMPDISPLAYS)) return false

	if (ttype == Transition.FromGame) {
		/*
		flowT.data = startfade (flowT.data,0.06,3.0)
		flowT.fg = startfade (flowT.fg,-0.06,3.0)
		*/
		flowT.groupbg = startfade (flowT.groupbg,0.06,3.0)
	}

	if ((ttype == Transition.ShowOverlay) && (prf.THEMEAUDIO) ) snd.wooshsound.playing = true

	if ((prf.LAYERVIDELAY) && (prf.LAYERVIDEO) && (prf.LAYERSNAP)) {
		 if (((ttype == Transition.ToNewSelection) || (ttype == Transition.ToNewList) ) && (prf.LAYERVIDEO)) {

		//background video delay load
			vidposbg = vidstarter
			bgs.bgvid_array[bgs.stacksize - 1].alpha = 0
			vidbgfade=[0.0,0.0,0.0,0.0,0.0]
			bgs.bgvid_array[bgs.stacksize - 1].file_name ="pics/transparent.png"
		 }
	}

	if (ttype == Transition.StartLayout){
	//	multifilterz.filter = loadtablefromfile("pref_multifilter.txt")
		z_list.layoutstart = true
		multifilterglyph.msg = gly(0xeaed)
	}

	// Cleanup search string and renew category table
	if (ttype == Transition.ToNewList){
		if (fe.list.search_rule == "") {
			searchdata.msg = ""
			search.catg = ["",""]
			search.smart = ""
			search.mots2 = ["",""]
			search.mots2string = ""
			//TEST109 moved from here buildcategorytable()
		}
	}

	// sort list at new list or layout start
	if (ttype == Transition.ToNewList) {
		debugpr("TNL")
		// Regenerate list and rebuild multifilter
		//if ((fe.list.display_index != displaystore) && !(z_list.layoutstart)) mfz_build(true)
		z_listboot()
		buildcategorytable()
		mfz_build(true)
		try{
			mfz_load()
			mfz_populatereverse()
			} catch(err){}
		mfz_apply(true)
	}

	if ((ttype == Transition.ToNewSelection) && (z_var != 0)) {
		// when transitioning to a new selection don't change the z_list.index immediately but use z_var as var
		debugpr ("TR:TNS zli:"+z_list.index+" zvar:"+z_var+" var:"+var+" var0:"+var0+"\n")
		var = z_var
	}

	if ((ttype == Transition.FromOldSelection) && (z_var != 0)) {
		// when transitioning from old selection apply the change to z_list.index
		z_list.index = modwrap ( (z_list.newindex) , z_list.size)
		debugpr ("TR:FOS zli:"+z_list.index+" zvar:"+z_var+" var:"+var+" var0:"+var0+"\n")
		var = -z_var

	}

	/*
	if ( (ttype == Transition.ToNewSelection)){
		update_thumbdecor (focusindex.new,0,getAR(tilez[focusindex.new].offset,tilez[focusindex.new].snapz,0,prf.BOXARTMODE))
	}
*/
	logotitle = null
	boxtitle = null

	// PREVENT ATTRACT MODE ENGAGE WHEN RETURNING FROM GAME
	if (ttype == Transition.FromGame){
		attract.timer = fe.layout.time
	}

	if (ttype == Transition.HideOverlay){
		frosthide()
		zmenuhide()
	}

	// FILTER CHANGE REACTION
	if ((ttype == Transition.ToNewList) && (var0 != 0)){
		// fade.display = fade.displayzoom = 1
		displayname.msg = fe.filters[fe.list.filter_index].name

		flowT.alphadisplay = startfade (flowT.alphadisplay,0.04,-2.0)
		flowT.zoomdisplay = [0.0,0.0,0.0,0.0,0.0]
		flowT.zoomdisplay = startfade (flowT.zoomdisplay,0.015,-2.0)
	}

	// DISPLAY CHANGE REACTION
	if ((ttype == Transition.ToNewList) && (fe.list.display_index != displaystore)){
		// fade.display = fade.displayzoom = 1
		displayname.msg = displaynamelogo(0)

		flowT.alphadisplay = startfade (flowT.alphadisplay,0.04,-2.0)
		flowT.zoomdisplay = [0.0,0.0,0.0,0.0,0.0]
		flowT.zoomdisplay = startfade (flowT.zoomdisplay,0.015,-2.0)

		// restore global settings
		prf.CROPSNAPS = prfzero.CROPSNAPS
		prf.THUMBVIDEO = prfzero.THUMBVIDEO
		prf.LAYERSNAP = prfzero.LAYERSNAP
		prf.SNAPGRADIENT = prfzero.SNAPGRADIENT
		prf.BOXARTMODE = prfzero.BOXARTMODE

		if (prf.LOWSPECMODE){
			prf.DATASHADOWSMOOTH = false
			prf.SNAPGRADIENT = false
			prf.SNAPGLOW = false
		}

		if (prf.LOGOSONLY) {
			prf.FADEVIDEOTITLE = true
			prf.CROPSNAPS = false
			prf.BOXARTMODE = false
		}

		//Update background image
		updatecustombg()

		try {
			prf.BOXARTMODE = ( (DISPLAYTABLE[fe.displays[fe.list.display_index].name][0] == "BOXES") ? true : false )
		}
		catch (err){}

		displaystore = fe.list.display_index
	}



	// UPDATE LABEL WHEN NEW SELECTION
	if ((prf.SCROLLERTYPE == "labellist") && (ttype == Transition.ToNewSelection)){
		local sortl1 = z_list.jumptable[z_list.index].key
		local sortl2 = z_list.jumptable[modwrap(z_list.index + z_var,z_list.size)].key

		if (sortl1 != sortl2){
			downkey (sortl1)
			upkey (sortl2)
		}
	}

	// UPDATE TILES FROM OLD SELECTION
	if (ttype == Transition.FromOldSelection) {
		updatebgsnap (focusindex.new)
	}

	// some fixes for the tags menu
	if (ttype == Transition.ShowOverlay){
		overlay_show(var0)
	}

	if (ttype == Transition.HideOverlay){

		zmenu_surface_container.visible = zmenu_sh.surf_rt.visible = false

		//overlay.listbox.width = overlay.fullwidth
		zmenu_sh.surf_2.shader = noshader
		zmenu_sh.surf_1.shader = noshader

		overlay_hide()
		//TEST ADD THIS FOR FAVS?	zoompos = 1

		zmenu.xstop = 0

	}

	// scroller is always updated
	updatescrollerposition()

	// RESET TILES WHEN GOING TO NEW LIST
	if ((ttype == Transition.ToNewList) ) {
		// Reset vars and positions
		debugpr ("TRANSBLOCK 1 - TNL - RESET VAR centercorr.val ETC \n")
		resetvarsandpositions()
	}

	// UPDATE TILES DATA AND POSITION
	if ( ((ttype == Transition.ToNewList) || (ttype == Transition.ToNewSelection) ) ) {

		if (z_list.size > 0) {
			debugpr ("TRANSBLOCK 2 - TNL TNS - UPDATE TILES \n")

			updatetiles()

			// updates all the tiles
			debugpr ("TRANSBLOCK 2 - TNL TNS - CHANGE ALL TILES \n")

			local index = - (floor(tiles.total/2) -1) + corrector

			for (local i = 0; i < tiles.total ; i++ ) {

				changetiledata(i,index,( (ttype == Transition.ToNewList) || ((ttype == Transition.ToNewSelection) && (( ( (column.stop>column.start) && (i/rows >= tiles.total/rows - column.offset) ) || ( (column.stop < column.start) && (i/rows < -column.offset) ))))))

				index ++
			}

			finaltileupdate()

		}

	}

	// UPDATE GAME DATA
	if ((ttype == Transition.ToNewList)){
		updatebgsnap (focusindex.new)
	}

	// if the transition is to a new selection initialize crossfade, scrolling and srfpos.Pos
	if( (ttype == Transition.ToNewSelection) ){

		debugpr ("TRANSBLOCK 3.0 - TNS - TRANSITION TO NEW SELECTION ONLY \n")

		local l1 = z_list.jumptable[z_list.index].key
		local l2 = z_list.jumptable[z_list.newindex].key

		if (l1 != l2){
			// Update the letter item, checking if it can use a system font
			letterobj.msg = systemfont (l2,false)
			flowT.alphaletter = startfade (flowT.alphaletter,0.06,-2.0)
			flowT.zoomletter = [0.0,0.0,0.0,0.0,0.0]
			flowT.zoomletter = startfade (flowT.zoomletter,0.03,-2.0)
		}

		//bgs.bgpic_array[0].file_name = fe.get_art((prf.BOXARTMODE ? "flyer" : "snap") , tilez[focusindex.new].loshz.index_offset+var,0,Art.ImagesOnly)

		for (local i = 0; i < bgs.stacksize-1;i++){
			bgs.bgpic_array[i].swap(bgs.bgpic_array[i+1])
			bgs.flowalpha[i] = bgs.flowalpha[i+1]
			bgs.bg_lcd[i] = bgs.bg_lcd[i+1]
			bgs.bg_mono[i] = bgs.bg_mono[i+1]
			bgs.bg_aspect[i] = bgs.bg_aspect[i+1]
			bgs.bg_box[i] = bgs.bg_box[i+1]
			bgs.bg_index[i] = bgs.bg_index[i+1]
		}


		for (local i = 0; i < dat.stacksize - 2;i++){
			dat.var_array[i] = dat.var_array[i+1]
		}

		dat.var_array [dat.stacksize - 1] = z_list.gametable[z_list.newindex].z_felistindex
		dat.var_array [dat.stacksize - 2] = z_list.gametable[z_list.index].z_felistindex

		local varoffset = 0

		for (local i=0 ; i< dat.stacksize ; i++){
			dat.mainctg_array[i].msg = maincategorydispl(dat.var_array[i])
			dat.gamename_array[i].msg = gamename2(dat.var_array[i])
			dat.gamesubname_array[i].msg = gamesubname(dat.var_array[i])
			dat.gameyear_array[i].msg = gameyearstring (dat.var_array[i])
			dat.manufacturername_array[i].msg = gamemanufacturer (dat.var_array[i])
		}

		for (local i=0 ; i< dat.stacksize -1 ; i++){
			// dat.manufacturer_array[i].rawset_index_offset(dat.var_array[i])
			// dat.cat_array[i].rawset_index_offset(dat.var_array[i])
			local msgtemp = dat.manufacturer_array[i].msg
			dat.manufacturer_array[i].msg = dat.manufacturer_array[i+1].msg
			dat.manufacturer_array[i+1].msg = msgtemp
			dat.cat_array[i].swap (dat.cat_array[i+1])
			dat.but_array[i].swap (dat.but_array[i+1])
			dat.ply_array[i].swap (dat.ply_array[i+1])
			dat.ctl_array[i].swap (dat.ctl_array[i+1])

			//varoffset = z_list.gametable[modwrap (z_list.newindex + dat.var_array[i] , z_list.size) ].z_felistindex - z_list.gametable[modwrap (z_list.newindex, z_list.size) ].z_felistindex

			dat.manufacturername_array[i].visible = (dat.manufacturer_array[i].msg == "")

			if (i != dat.stacksize -2 )
				dat.alphapos[i] = dat.alphapos[i+1]
			else
				dat.alphapos[i] = 1.0 - dat.alphapos[i+1]
		}

		varoffset = z_list.gametable[modwrap (z_list.newindex , z_list.size) ].z_felistindex - z_list.gametable[modwrap (z_list.index, z_list.size) ].z_felistindex

		z_list_updategamedata(z_list.gametable[z_list.newindex].z_felistindex)  //TEST109 era varoffset

		dat.alphapos [dat.stacksize - 1] = 1
		z_updatefilternumbers(z_list.newindex)

		//bgs.flowalpha [bgs.stacksize - 1] = 255

		bgs.flowalpha[bgs.stacksize - 1] = [0,0,0.0,0.0,0.0,0.0]
		bgs.flowalpha[bgs.stacksize - 1] = startfade(bgs.flowalpha[bgs.stacksize - 1],0.015,-4.0) //TEST105 speed was 0.02

		surfacePos += (column.offset * (widthmix + padding) ) - centercorr.shift

		impulse2.delta = (column.offset * (widthmix + padding) ) - centercorr.shift
		impulse2.filtern = 1
		if (impulse2.delta > impulse2.maxoffset) {
			impulse2.filtern = 0
			impulse2.delta = impulse2.maxoffset
		}
		if (impulse2.delta < -impulse2.maxoffset) {
			impulse2.filtern = 0
			impulse2.delta = -impulse2.maxoffset
		}

		impulse2.step += impulse2.delta
	}

	return false
}

local timescale = {
	current = fe.layout.time
	sum = 0
   values = 0
	limits = 15
	delay = 15
}



/// On Tick ///
function tick( tick_time ) {
	/*
	tilez[focusindex.new].glomx.visible = false
	tilez[focusindex.new].sh_mx.visible = false
	tilez[focusindex.new].gr_overlay.visible = false
	tilez[focusindex.new].snapz.visible = false
*/

	if (prf.HUECYCLE){
		huecycle.RGB = hsl2rgb(huecycle.hue,huecycle.saturation,huecycle.lightness)

		huecycle.hue = huecycle.hue + huecycle.speed
		if (huecycle.hue > (huecycle.maxhue)) {
			huecycle.hue = huecycle.pingpong ? huecycle.maxhue - huecycle.speed : huecycle.minhue
			if (huecycle.pingpong) huecycle.speed = huecycle.speed * -1
		}
		else if (huecycle.hue < huecycle.minhue) {
			huecycle.hue = huecycle.minhue - huecycle.speed
			huecycle.speed = huecycle.speed * -1
		}

		snap_glow[focusindex.new].set_param ("basergb", huecycle.RGB.R, huecycle.RGB.G, huecycle.RGB.B)

		tilez[focusindex.new].bd_mx.set_bg_rgb(255*huecycle.RGB.R,255*huecycle.RGB.G,255*huecycle.RGB.B)
	}

	if (snd.bgtuneplay != snd.bgtune.playing) {
		if (snd.bgtuneplay && prf.RANDOMTUNE) 	snd.bgtune = fe.add_sound(AF.bgsongs[AF.bgsongs.len()*rand()/RAND_MAX])

		snd.bgtune.playing = snd.bgtuneplay
	}

	if (snd.attracttuneplay != snd.attracttune.playing) {
		snd.attracttune.playing = snd.attracttuneplay
	}

	if (AF.scrape.purgedromdirlist != null){
		if ((AF.scrape.purgedromdirlist.len() == 0) && (dispatchernum == 0)){

			local romlistpath = FeConfigDirectory+"romlists/" + AF.scrape.romlist + ".txt"
			AF.scrape.romlist_file = WriteTextFile (romlistpath)
			AF.scrape.romlist_file.write_line("#Name;Title;Emulator;CloneOf;Year;Manufacturer;Category;Players;Rotation;Control;Status;DisplayCount;DisplayType;AltRomname;AltTitle;Extra;Buttons;Series;Language;Region;Rating\n")
			foreach (i, item in AF.scrape.romlist_lines){
				AF.scrape.romlist_file.write_line(item+"\n")
			}
			AF.scrape.romlist_file = ReadTextFile (romlistpath)

			local scrapelistpath = FeConfigDirectory+"romlists/" + AF.scrape.romlist + ".scrape"
			AF.scrape.scrapelist_file = WriteTextFile (scrapelistpath)
			//TEST102 ADD HERE NEW FORMAT OUTPUT
			AF.scrape.scrapelist_file.write_line("return([\n")
			foreach (i, item in AF.scrape.scrapelist_lines){
				AF.scrape.scrapelist_file.write_line(ap+item+ap+",\n")
			}
			AF.scrape.scrapelist_file.write_line("])\n")
			AF.scrape.scrapelist_file = ReadTextFile (scrapelistpath)

			AF.scrape.purgedromdirlist = null

			local endreport = ""
			endreport += "SCRAPE STATUS REPORT\n"
			foreach (item,content in AF.scrape.report){
				endreport += (item+":"+content.tot+" ")
			}
			endreport += ("\n")
			foreach (item,content in AF.scrape.report){
				endreport += (AF.scrape.separator1+"\n"+item+"\n")
				foreach (i2, item2 in content.names){
					endreport += ("- "+item2+"\n"+" ["+content.matches[i2]+"]\n")
				}
			}

			AF.boxmessage = messageboxer(AF.scrape.romlist+" "+AF.scrape.totalroms+"/"+AF.scrape.totalroms,"COMPLETED - PRESS ESC TO RELOAD LAYOUT\n"+AF.scrape.separator2+"\n"+endreport+"\n",false,AF.boxmessage)


		}
		if ((AF.scrape.purgedromdirlist != null) && (AF.scrape.purgedromdirlist.len() != 0) && (AF.scrape.threads < 100)){
			AF.scrape.threads ++
			dispatcher.push({
				scrapegame2 = newthread(scrapegame2)
				getromdata = newthread(getromdata)
				createjsonA = newthread(createjsonA)
				createjson = newthread(createjson)
				pollstatus = false
				pollstatusA = false
				rominputitem = ""
				gamedata = null
				jsonstatus = null
				done = false
				quit = AF.scrape.quit
				skip = false
			})
			local inputitem = AF.scrape.purgedromdirlist[AF.scrape.purgedromdirlist.len()-1]
			local ext = split(inputitem,".").pop()
			local gname = inputitem.slice(0,-1*(ext.len()+1))

			local t0 = fe.layout.time

			scraprt("ID:"+AF.scrape.dispatchid+" DISPATCH "+AF.scrape.purgedromdirlist[AF.scrape.purgedromdirlist.len()-1]+"\n")
			dispatchernum ++

			dispatcher[AF.scrape.dispatchid].scrapegame2.call(AF.scrape.dispatchid,AF.scrape.purgedromdirlist.pop(),AF.scrape.quit)
			AF.scrape.dispatchid ++
		}
	}

	if (dispatchernum != 0){
		foreach (i, item in dispatcher){
				//print (i+" done:"+item.done+" quit:"+item.quit+" skip:"+item.skip+"\n")
			if (item.done){
				if (item.gamedata.scrapestatus != "RETRY") AF.scrape.doneroms ++
				try {remove (AF.folder + "json/" + i + "json.txt")} catch(err){}
				try {remove (AF.folder + "json/" + i + "json.nut")} catch(err){}
				try {remove (AF.folder + "json/" + i + "json_out.nut")} catch(err){}
				scraprt("COMPLETED "+item.gamedata.filename+"\n")
				if (item.gamedata.requests != "") AF.scrape.requests = item.gamedata.requests
				AF.boxmessage = messageboxer (patchtext (AF.scrape.romlist+" "+(AF.scrape.totalroms-AF.scrape.purgedromdirlist.len())+"/"+AF.scrape.totalroms, AF.scrape.requests,11,AF.scrape.columns)+"\n"+textrate(AF.scrape.doneroms,AF.scrape.totalroms,AF.scrape.columns), patchtext(item.gamedata.filename,item.gamedata.scrapestatus,11,AF.scrape.columns)+"\n",true,AF.boxmessage)

				AF.scrape.threads --
				dispatchernum --
				scraprt("ID"+i+"-main scrapegame2 wakeup\n")
				if ((!item.quit) && (!item.skip)) item.scrapegame2.wakeup()
				//scraprt("ID"+i+"-main continue second check\n")
				item.gamedata = null
				item.done = false
			}
			else if (!item.done && item.pollstatus && file_exist(AF.folder + "json/" + i + "json.txt")){
				try {remove (AF.folder + "json/" + i + "json.txt")} catch(err){}
				item.pollstatus = false
	   		scraprt("ID"+i+"-main createjson wakeup\n")
				item.createjson.wakeup()
	   		scraprt("ID"+i+"-main getromdata wakeup\n")
				item.getromdata.wakeup()
				scraprt("ID"+i+"-main end first check\n")
			}
			else if (!item.done && item.pollstatusA && file_exist(AF.folder + "json/" + i + "jsonA.txt")){
				try {remove (AF.folder + "json/" + i + "jsonA.txt")} catch(err){}
				item.pollstatusA = false
	   		scraprt("ID"+i+"-main createjson wakeup\n")
				item.createjsonA.wakeup()
	   		scraprt("ID"+i+"-main getromdata wakeup\n")
				item.getromdata.wakeup()
				scraprt("ID"+i+"-main end first check\n")
			}
		}
	}

	if (AF.scrape.listoflists != null){
		if (AF.scrape.listoflists.len() == 0) {

			local romlistpath = FeConfigDirectory+"romlists/" + AF.scrape.romlist + ".txt"
			AF.scrape.romlist_file = WriteTextFile (romlistpath)
			AF.scrape.romlist_file.write_line("#Name;Title;Emulator;CloneOf;Year;Manufacturer;Category;Players;Rotation;Control;Status;DisplayCount;DisplayType;AltRomname;AltTitle;Extra;Buttons;Series;Language;Region;Rating\n")
			foreach (i, item in AF.scrape.romlist_lines){
				AF.scrape.romlist_file.write_line(item+"\n")
			}
			AF.scrape.romlist_file = ReadTextFile (romlistpath)

			AF.scrape.listoflists = null
			AF.boxmessage = messageboxer(AF.scrape.romlist,"COMPLETED\nPRESS ESC TO RELOAD LAYOUT\n\n",true,AF.boxmessage)
		}
		if (AF.scrape.listoflists != null) collatelist2(AF.scrape.listoflists.pop())
	}

	if (keyboard_visible()){
		foreach (key, item in kb.rt_keys) {
			local pressedkey = fe.get_input_state(key)
			if (!item.prs && pressedkey) {
				//displaybutton.msg = displaybutton.msg + item.val
				keyboard_select (0,4)
				keyboard_type(item.val)
			}
			item.prs = pressedkey
		}
	}

	// Timescale, changes fade and animation speeds based on actual system performance
	// Skip first spurious data when launching layout
	if (timescale.delay > 0) {
		timescale.delay --
		timescale.current = tick_time
	}
	// Start gathering framerate data
	if (timescale.delay <= 0) {
		if ((timescale.values < timescale.limits) ){
			timescale.sum = timescale.sum + tick_time - timescale.current
			timescale.values = timescale.values + 1

			pixelpic.y++
		}
		timescale.current = tick_time
		// Update variables when limit is reached
		if (timescale.values == timescale.limits) {
			timescale.delay = -1
			if (prf.ADAPTSPEED) AF.tsc = 60.0 / (1000.0/(timescale.sum/timescale.values))
			foreach (item,value in spdT) {
				spdT[item] = 1.0 - (1.0 - value) * AF.tsc
			}

			delayvid = round(vidstarter - 60*prf.THUMBVIDELAY/AF.tsc , 1)
			fadevid = round(delayvid - 35/AF.tsc , 1)

			count.movestart = ceil(count.movestart/AF.tsc)
			count.movestepslow = ceil(count.movestepslow/AF.tsc)
			count.movestepfast = ceil(count.movestepfast/AF.tsc)
			count.movestepdelay = ceil(count.movestepdelay/AF.tsc)
			count.movestep = count.movestepslow

			timescale.values = timescale.limits + 1

			if (prf.THUMBVIDEO) videosnap_restore()
		}
	}

	// prevent attract mode from running when menus are visible
	if ((overlay.listbox.visible == true) || (zmenu.showing) || (AF.messageoverlay.visible)) attract.timer = fe.layout.time

	if ((disp.xstart != disp.xstop) && (prf.DMPIMAGES) && (zmenu.dmp) ){
		disp.speed = (0.15 * (disp.xstop - disp.xstart))
		if (absf(disp.speed) > disp.tileh) {
			disp.speed = (disp.speed > 0 ? 10*disp.tileh : -10*disp.tileh)
		}
		if (absf(disp.speed) > 0.0005*disp.tileh) {
			if ((absf(disp.xstart - disp.xstop)) > disp.spacing * (fe.displays.len()-2)) {
				disp.xstart = disp.xstop
				for (local i = 0;i < disp.images.len() ; i++) {
					disp.images[i].y = disp.pos0[i] + disp.xstop
				}
			}
			else {
				for (local i = 0;i < disp.images.len() ; i++) {
					disp.images[i].y = disp.pos0[i] + disp.xstart + disp.speed
				}
				disp.xstart = disp.xstart + disp.speed
			}
		}
		else {
			disp.xstart = disp.xstop
			for (local i = 0;i < disp.images.len() ; i++) {
				disp.images[i].y = disp.pos0[i] + disp.xstop
			}
		}
	}


	if (zmenu.xstart != zmenu.xstop){
		zmenu.speed = (0.2 * (zmenu.xstop - zmenu.xstart))
		if (absf(zmenu.speed) > 0.0005*zmenu.tileh) {
			for (local i = 0;i < zmenu.shown ; i++) {
				zmenu.items[i].y = zmenu.pos0[i] + zmenu.xstart + zmenu.speed
				zmenu.noteitems[i].y = zmenu.pos0[i] + zmenu.xstart + zmenu.speed
				zmenu.glyphs[i].y = zmenu.pos0[i] + zmenu.xstart + zmenu.speed
				zmenu.strikelines[i].y = zmenu.pos0[i] + zmenu.tileh*0.5 + zmenu.xstart + zmenu.speed

			}

			zmenu.xstart = zmenu.xstart + zmenu.speed
		}
		else {
			zmenu.xstart = zmenu.xstop
			for (local i = 0;i < zmenu.shown ; i++) {
				zmenu.items[i].y = zmenu.pos0[i] + zmenu.xstop
				zmenu.noteitems[i].y = zmenu.pos0[i] + zmenu.xstop
				zmenu.glyphs[i].y = zmenu.pos0[i] + zmenu.xstop
				zmenu.strikelines[i].y = zmenu.pos0[i] +zmenu.tileh*0.5 + zmenu.xstop
			}
		}
		zmenu.selectedbar.y = zmenu.sidelabel.y = zmenu.items[zmenu.selected].y
	}

	// Attract mode management
	if (prf.AMENABLE) {

		if (attract.start){
			// block theme videos and set snap audio
			if (prf.LAYERVIDEO) bgs.bgvid_array[bgs.stacksize - 1].video_playing = false
			if (prf.THUMBVIDEO) tilez[focusindex.new].gr_vidsz.video_playing = false
			if (prf.THUMBVIDEO) videosnap_hide()
			if (!attract.sound) attractitem.snap.video_flags = Vid.NoAudio

			if(prf.AMTUNE != "") {
				snd.attracttuneplay = true
				if (prf.BACKGROUNDTUNE != "") snd.bgtuneplay = false
			}
			else if ((prf.BACKGROUNDTUNE != "") && (prf.NOBGONATTRACT)) snd.bgtuneplay = false

			attract.start = false
			attract.rolltext = true
			attract.gametimer = true
			//attract.updatesnap = true
			attractupdatesnap()
			attract.timer = tick_time
		}

		if (attract.rolltext){
			attractitem.text2.alpha = 255*(0.5+0.5*cos(tick_time/500.0))
			attractitem.text1.alpha = attract.textshadow * attractitem.text2.alpha / 255
		}

		if (attract.gametimer){
			if ((tick_time - attract.timer) > attract.game_interval){
				flowT.gametoblack = startfade (flowT.gametoblack,0.1,0.0)
			}
		}

		if (attract.starttimer){
			if ((tick_time - attract.timer) > attract.attract_interval){
				attractkick()
			}
		}
	}

	// Apply square screen cropping for background artwork
	if (squarizer){
		squarizer = false
		squarebg()
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

	// crossfade of the blurred background
	for (local i = 0 ; i < bgs.stacksize ; i++){
		if (checkfade(bgs.flowalpha[i])){
			bgs.flowalpha[i] = fadeupdate(bgs.flowalpha[i])
			bgs.bgpic_array[i].alpha = 255 * bgs.flowalpha[i][1]
			if (prf.LAYERSNAP) bgs.bgvid_array[i].alpha = 255 * bgs.flowalpha[i][1]
		}
	}

	if (checkfade(flowT.alphaletter)){
		flowT.alphaletter = fadeupdate(flowT.alphaletter)
		if (endfade(flowT.alphaletter) == 1.0) {
			flowT.alphaletter = startfade (flowT.alphaletter,-0.06,2.0)
		}
		letterobj.alpha = 255 * flowT.alphaletter[1]
	}
//TEST106 CHECK OVERSCAN
	if (checkfade(flowT.zoomletter)){
		flowT.zoomletter = fadeupdate(flowT.zoomletter)
		local scalesurf = 0.5 + 0.5 * flowT.zoomletter[1]
		//letterobj.charsize = lettersize.name * (1.0+flowT.zoomletter[1])
		letterobjsurf.surf.set_pos(0.5*(fl.w_os-letterobjsurf.w*scalesurf),letterobjsurf.y0 + 0.5*letterobjsurf.h-0.5*letterobjsurf.h*scalesurf,letterobjsurf.w*scalesurf,letterobjsurf.h*scalesurf)

	}

	if (checkfade(flowT.alphadisplay)){
		flowT.alphadisplay = fadeupdate(flowT.alphadisplay)
		if ( (endfade(flowT.alphadisplay) == 1.0) ) {
			flowT.alphadisplay = startfade (flowT.alphadisplay,-0.04,2.0)
		}
		displayname.alpha  = 255 * flowT.alphadisplay[1]
	}
//TEST106 CHECK OVERSCAN
	if (checkfade(flowT.zoomdisplay)){
		flowT.zoomdisplay = fadeupdate(flowT.zoomdisplay)
		//displayname.char_size = lettersize.display * (1.0+flowT.zoomdisplay[1])
		local scalesurf = 0.25 + 0.75 * flowT.zoomdisplay[1]
		displaynamesurf.surf.set_pos(0.5*(fl.w_os-displaynamesurf.w*scalesurf),0.5*(fl.h_os-displaynamesurf.h*scalesurf),displaynamesurf.w*scalesurf,displaynamesurf.h*scalesurf)
	}

	// Manage tiles zoom and unzoom
	foreach (i, item in tilesTableUpdate){
		if (checkfade(tilesTableUpdate[i])){
			tilesTableUpdate[i] = fadeupdate(tilesTableUpdate[i])
			local updatetemp = tilesTableUpdate[i]

			// hide glow image and border image when zero is reached
			if (endfade (updatetemp) == 0){
				tilez[i].glomx.visible = false
				tilez[i].glomx.shader = noshader
				tilez[i].bd_mx.visible = false
			}

			//TEST96 check if I can manage the fade out differently! glow alpha
			if (updatetemp[3] < 0){
				tilez[i].glomx_alpha = 255*pow(updatetemp[1],5)
				tilez[i].bd_mx_alpha = 240*pow(updatetemp[1],5)
				tilez[i].bd_mx.bg_alpha = tilez[i].alphalogosonly * tilez[i].bd_mx_alpha
				tilez[i].glomx.alpha = tilez[i].alphalogosonly * tilez[i].glomx_alpha
			}
			else{
				tilez[i].glomx_alpha = 255*(updatetemp[1])
				tilez[i].bd_mx_alpha = 240*(updatetemp[1])
				tilez[i].bd_mx.bg_alpha = tilez[i].alphalogosonly * tilez[i].bd_mx_alpha
				tilez[i].glomx.alpha = tilez[i].alphalogosonly * tilez[i].glomx_alpha
			}
		}
	}

	foreach (i, item in tilesTableZoom){
		if (checkfade(tilesTableZoom[i])){
			tilesTableZoom[i] = fadeupdate(tilesTableZoom[i])
			local zoomtemp = tilesTableZoom[i]

			// update size and glow alpha
			picsize(tilez[i].obj, widthpadded + (selectorwidth-widthpadded)*(zoomtemp[1]), widthpadded + (selectorwidth-widthpadded)*(zoomtemp[1]) , 0, -verticalshift*1.0/widthpadded)

		}
	}

	// Manage video fade and unfade, anc crop fade
	foreach (i, item in aspectratioMorph){
		if (checkfade (aspectratioMorph[i])){
			aspectratioMorph[i] = fadeupdate (aspectratioMorph[i])
			local fadetemp = aspectratioMorph[i]

			local aspectmorph = (tilez[i].AR.crop + fadetemp[1] * (tilez[i].AR.vids - tilez[i].AR.crop))
			if (prf.CROPSNAPS && !prf.BOXARTMODE && prf.MORPHASPECT){
				aspectmorph = (1.0 + fadetemp[1] * (tilez[i].AR.vids - 1.0))
			}
			//if (aspectmorph != tilez[i].AR.current){

			if (prf.MORPHASPECT)	{
				update_snapcrop (i,0,var,z_list.index+var,tilez[i].AR.snap, aspectmorph )	//TEST88 CHECK VAR
				update_borderglow(i,0,aspectmorph)
				update_thumbdecor(i,0,aspectmorph)
				tilez[i].AR.current = aspectmorph
			}
		}

		if (checkfade(gr_vidszTableFade[i])){
			gr_vidszTableFade[i] = fadeupdate(gr_vidszTableFade[i])
			local fadetemp = gr_vidszTableFade[i]

			// hide glow image and border image when zero is reached
			if (endfade (fadetemp) == 0){
				tilez[i].vidsz.file_name = tilez[i].gr_vidsz.file_name = "pics/transparent.png"
				tilez[i].gr_vidsz.alpha = 0
				tilez[i].vidsz.alpha = 0
				if (prf.FADEVIDEOTITLE){
					tilez[i].txshz.alpha = tilez[i].loshz.alpha = 150
					tilez[i].txt2z.alpha = tilez[i].txt1z.alpha = tilez[i].donez.alpha = tilez[i].favez.alpha = tilez[i].logoz.alpha = 255
					tilez[i].nw_mx.alpha = ((prf.NEWGAME == true)? 220 : 0)
					tilez[i].tg_mx.alpha = ((prf.TAGSHOW == true)? 255 : 0)
				}
			}

			//TEST107
			if (prf.LOGOSONLY) {
				tilez[i].alphalogosonly = fadetemp[1]
				tilez[i].bd_mx.bg_alpha = tilez[i].alphalogosonly * tilez[i].bd_mx_alpha
				tilez[i].glomx.alpha = tilez[i].alphalogosonly * tilez[i].glomx_alpha
				tilez[i].sh_mx.alpha = tilez[i].alphalogosonly * tilez[i].sh_mx_alpha
				tilez[i].gr_overlay.alpha = tilez[i].alphalogosonly * 255
				tilez[i].snapz.alpha = tilez[i].alphalogosonly * 255
			}

			// update size and glow alpha
			tilez[i].gr_vidsz.alpha = tilez[i].vidsz.alpha = 255*(fadetemp[1])
			if (prf.FADEVIDEOTITLE){
				tilez[i].txshz.alpha = tilez[i].loshz.alpha = 150 * (1.0 - fadetemp[1])
				tilez[i].txt2z.alpha = tilez[i].txt1z.alpha = tilez[i].donez.alpha = tilez[i].favez.alpha = tilez[i].logoz.alpha = 255 * (1.0 - fadetemp[1])
				tilez[i].nw_mx.alpha = ((prf.NEWGAME == true)? 220 : 0)* (1.0 - fadetemp[1])
				tilez[i].tg_mx.alpha = ((prf.TAGSHOW == true)? 255 : 0)* (1.0 - fadetemp[1])
			}

			if ((!prf.TITLEONBOX) && (tilez[i].txbox.visible == true)) {
				tilez[i].txbox.alpha = 255 * (1.0 - fadetemp[1])
			}
		}
	}


	// crossfade of game data
	for (local i = 0 ; i < dat.stacksize ; i++){
		if (dat.alphapos[i] != 0 ){
			if ((dat.alphapos[i] <0.01) && (dat.alphapos[i] > -0.01)) dat.alphapos[i] = 0

			if (i != dat.stacksize -1){
				dat.alphapos[i] = dat.alphapos[i] * spdT.dataspeedout
				dat.ply_array[i].alpha = dat.ctl_array[i].alpha = dat.but_array[i].alpha = dat.cat_array[i].alpha = dat.mainctg_array[i].alpha = dat.manufacturer_array[i].alpha = dat.gamename_array[i].alpha = dat.gamesubname_array[i].alpha = dat.manufacturername_array[i].alpha = dat.gameyear_array[i].alpha = 255 * (dat.alphapos[i])*1.0
			}
			else {
				dat.alphapos[dat.stacksize -1] = dat.alphapos[dat.stacksize - 1] * spdT.dataspeedin
				dat.ply_array[i].alpha = dat.ctl_array[i].alpha = dat.but_array[dat.stacksize - 1].alpha = dat.cat_array[dat.stacksize - 1].alpha = dat.mainctg_array[dat.stacksize - 1].alpha = dat.manufacturer_array[dat.stacksize - 1].alpha = dat.gamename_array[dat.stacksize - 1].alpha = dat.gamesubname_array[dat.stacksize - 1].alpha = dat.manufacturername_array[dat.stacksize - 1].alpha =dat.gameyear_array[dat.stacksize - 1].alpha = 255 * (1.0 - dat.alphapos[dat.stacksize - 1])*1.0
			}
		}
	}

	//EASE PRINT
/*
	local pippo1 = fe.add_image("pics/white.png",CCC,fl.h_os*0.5+(impulse2.tilepos)*0.1,3,3) //RED
	local pippo2 = fe.add_image("pics/white.png",CCC,fl.h_os*0.5+(impulse2.flow)*0.1,3,3) //BLACK
	local pippo3 = fe.add_image("pics/white.png",CCC,fl.h_os*0.5+(impulse2.maxoffset)*0.1,3,3) //WHITE
	local pippo4 = fe.add_image("pics/white.png",CCC,fl.h_os*0.5-(impulse2.maxoffset)*0.1,3,3) //BLUE
	pippo1.zorder = pippo2.zorder = pippo3.zorder = pippo4.zorder =20000
	pippo1.set_rgb(255,0,0)
	pippo2.set_rgb(0,0,0)
	pippo3.set_rgb(255,255,255)
	pippo4.set_rgb(0,0,255)
	CCC = CCC + 0.5
*/

	if (impulse2.flow + impulse2.step != 0){
		impulse2.step_f = getfiltered(srfposhistory,filtersw[impulse2.filtern])


		impulse2.flow0 = (impulse2.step_f + impulse2.flow) * spdT.scrollspeed - impulse2.step_f
		impulse2.tilepos0 = impulse2.flow0 + impulse2.step

		if ((impulse2.tilepos0 > impulse2.maxoffset)){
			//impulse2.filtern = 0
			impulse2.step = impulse2.step - (impulse2.tilepos0 - impulse2.maxoffset)
			impulse2.step_f = getfiltered(srfposhistory,filtersw[impulse2.filtern])
		}
		if(impulse2.tilepos0 < -impulse2.maxoffset) {
			//impulse2.filtern = 0
			impulse2.step = impulse2.step - (impulse2.tilepos0 + impulse2.maxoffset)
			impulse2.step_f = getfiltered(srfposhistory,filtersw[impulse2.filtern])
		}

		impulse2.flow = (impulse2.step_f + impulse2.flow) * spdT.scrollspeed - impulse2.step_f


		srfposhistory.push (impulse2.step)
		srfposhistory.remove(0)

		if ((impulse2.flow+impulse2.step < 0.1) && (impulse2.flow+impulse2.step > -0.1)) {
			impulse2.flow = -impulse2.step
			srfposhistory = array(impulse2.samples, impulse2.step)
		}



		impulse2.tilepos = impulse2.flow + impulse2.step


		for (local i = 0; i < tiles.total; i++ ) {
			tilez[i].obj.x = impulse2.tilepos - surfacePosOffset + tilesTablePos.X[i]
			tilez[i].obj.y = tilesTablePos.Y[i]

			//TEST101 ADD VISIBILITY OFF SCREEN CONTROL
			local offscreen = ((tilez[i].obj.x + tilez[i].obj.width * 0.5 < 0) || (tilez[i].obj.x - tilez[i].obj.width * 0.5 > fl.w_os))
			if (tilez[i].obj.visible && tilez[i].offlist) tilez[i].obj.visible = false
			else if (!tilez[i].offlist){
				if (tilez[i].obj.visible && offscreen) tilez[i].obj.visible = false
				if (!tilez[i].obj.visible && !offscreen) tilez[i].obj.visible = true
			}

			globalposnew = tilez[focusindex.new].obj.x
		}

	}

	if ((surfacePos != 0)) {

		if ((surfacePos < 0.1) && (surfacePos > -0.1)) surfacePos = 0
		surfacePos = surfacePos * spdT.scrollspeed

		if (surfacePos > impulse2.maxoffset) {
			surfacePos = impulse2.maxoffset
		}
		if (surfacePos < -impulse2.maxoffset) {
			surfacePos = -impulse2.maxoffset
			}

	}
	// fade of bg video
	if ((prf.LAYERVIDELAY) && (prf.LAYERVIDEO) && (prf.LAYERSNAP) ){
		if (vidposbg !=0){
			vidposbg = vidposbg - 1

			if (vidposbg == delayvid){
				bgs.bgvid_array[bgs.stacksize - 1].file_name = fe.get_art("snap",0)
				bgs.bgvid_array[bgs.stacksize - 1].alpha = 0
			}
			if (vidposbg == fadevid){
				vidbgfade = startfade (vidbgfade,0.03,1.0)
				vidposbg = 0
			}
		}

		if (checkfade(vidbgfade)){
			vidbgfade = fadeupdate(vidbgfade)
			local fadetemp = vidbgfade
			// update size and glow alpha
			bgs.bgvid_array[bgs.stacksize - 1].alpha = 255*(fadetemp[1])
		}
	}

	// crossfade of video snaps, tailored to skip initial fade in
	local index = - (floor(tiles.total/2) -1) + corrector
	foreach (i, item in vidpos){
		if (( vidpos[i] != 0 ) && (!zmenu.showing) && (displayname.alpha < 10) ) {
			vidpos[i] = vidpos[i] - 1
			//if (vidpos[i] == 0) vidpos[i] = 0
			// focusindex.new = wrap( tiles.total/2-1-corrector + tilesTablePos.Offset, tiles.total )

			if ((vidpos[i] == delayvid) ){
				//tilez[focusindex.new].gr_vidsz.visible = true
				if ((prf.THUMBVIDEO)){
					tilez[i].gr_vidsz.file_name = fe.get_art("snap",vidindex[i])
					if ((prf.AUDIOVIDSNAPS) && (!history_visible()) && (!zmenu.showing)) tilez[i].gr_vidsz.video_flags = Vid.Default

					tilez[i].AR.vids = getAR(tilez[i].offset,tilez[i].vidsz,0,false)

					//TEST87 DA COJTROLLARE SI PUO' SOSTITUIRE CON UNO SNAPCROP DEL VIDEO
					if (!prf.MORPHASPECT) update_snapcrop (i,0,0,z_list.index,tilez[i].AR.vids,tilez[i].AR.crop)

				}
				if (prf.AMENABLE) {
					if (attract.rolltext) tilez[i].gr_vidsz.video_playing = false
				}

				tilez[i].gr_vidsz.alpha = tilez[i].vidsz.alpha = 0

				tilez[i].vidsz.set_pos(tilez[i].snapz.x,tilez[i].snapz.y,tilez[i].snapz.width,tilez[i].snapz.height)
			}

			if ((vidpos[i] == fadevid) ) {
				gr_vidszTableFade[i] = startfade (gr_vidszTableFade[i],0.03,1.0)
				aspectratioMorph[i] = startfade (aspectratioMorph[i],0.06,1.0)
				vidpos[i] = 0
				//tilez[i].gr_vidsz.alpha = tilez[i].vidsz.alpha = 255.0*(1-0.01*vidpos[i]*(1/fadevid))
				//else
				//tilez[focusindex.new].gr_vidsz.alpha = tilez[focusindex.new].vidsz.alpha = 0
			}
		}
	}

	// context menu fade in fade out

	if ((overmenu.visible) && (flowT.overmenu[3] >= 0) && (impulse2.flow + impulse2.step !=0)) {
		overmenu.x = globalposnew - overmenuwidth*0.5
	}

	if (prf.UPDATECHECK){
		if ((tick_time >= 6000) && (!prf.UPDATECHECKED) && (!zmenu.showing) && (!frost.surf_rt.visible)) {
			prf.UPDATECHECKED = true
			checkforupdates(false)
		}
	}

	if (checkfade (flowT.keyboard)){
		flowT.keyboard = fadeupdate(flowT.keyboard)
		keyboard_surface.alpha = 255 * flowT.keyboard[1]
	}

	if (checkfade (flowT.zmenudecoration)){
		flowT.zmenudecoration = fadeupdate(flowT.zmenudecoration)
		if (endfade (flowT.zmenudecoration) == 0){
			foreach (item in overlay.shad) item.visible = false
		}
		foreach (item in overlay.shad) item.alpha = 60 * (flowT.zmenudecoration[1])
	}

	if (checkfade (flowT.zmenubg)){
		flowT.zmenubg = fadeupdate(flowT.zmenubg)
		if (endfade (flowT.zmenubg) == 0){
			overlay.background.visible = false
			frost.surf_rt.alpha = 0
			frostshaders(false)
		}

		frost.surf_rt.alpha = 255 //In frosted glass case we don't fade the surface but the blur radius
		overlay.background.bg_alpha = themeT.listboxalpha * (flowT.zmenubg[1])
	}

	if (checkfade (flowT.filterbg)){
		flowT.filterbg = fadeupdate(flowT.filterbg)
		if (endfade (flowT.filterbg) == 0) {
			frost.surf_rt.shader.set_param ("alpha",0.0)
			frost.surf_rt.shader = noshader
			zmenu.mfm = false
		}
		frost.surf_rt.shader.set_param ("alpha", flowT.filterbg[1])
	}



	if (checkfade (flowT.frostblur)){
		flowT.frostblur = fadeupdate(flowT.frostblur)

		frost.surf_1.shader.set_param ("kernelData",frostpic.matrix,frostpic.sigma*flowT.frostblur[1])
		frost.pic.shader.set_param ("kernelData",frostpic.matrix,frostpic.sigma*flowT.frostblur[1])

	}


	if (checkfade (flowT.zmenush)){
		flowT.zmenush = fadeupdate(flowT.zmenush)
		if (endfade (flowT.zmenush) == 0) {
			zmenu_sh.surf_rt.visible = false
		}
		zmenu_sh.surf_rt.alpha = themeT.menushadow * (flowT.zmenush[1])
		prfmenu.bg.bg_alpha = themeT.optionspanelalpha * (flowT.zmenush[1])
	}

	if (checkfade (flowT.zmenutx)){
		flowT.zmenutx = fadeupdate(flowT.zmenutx)
		if (endfade (flowT.zmenutx) == 0) {
			zmenu_surface_container.visible = false
			overlay.sidelabel.visible = overlay.label.visible = overlay.glyph.visible = overlay.wline.visible = false
		}
		overlay.sidelabel.alpha = 255 * (flowT.zmenutx[1])
		overlay.label.alpha = 255 * (flowT.zmenutx[1])
		overlay.glyph.alpha = 255 * (flowT.zmenutx[1])
		overlay.wline.bg_alpha = 255 * (flowT.zmenutx[1])
		zmenu_surface_container.alpha = 255 * (flowT.zmenutx[1])
		prfmenu.helppic.alpha = 255 * (flowT.zmenutx[1])
		prfmenu.description.alpha = 255 * (flowT.zmenutx[1])
	}

	if (checkfade (flowT.historyblack)){
		flowT.historyblack = fadeupdate(flowT.historyblack)

		if (endfade(flowT.historyblack) ==1) {
			// history_updatesnap()
			flowT.historyblack = startfade (flowT.historyblack,-flowT.historyscroll[3]*2.0,3.0)
		}

		hist_screensurf.set_rgb (255 * (1.0 - flowT.historyblack[1]),255 * (1.0 - flowT.historyblack[1]),255 * (1.0 - flowT.historyblack[1]))
		hist_glow_pic.set_rgb (255 * (1.0 - flowT.historyblack[1]),255 * (1.0 - flowT.historyblack[1]),255 * (1.0 - flowT.historyblack[1]))
		hist_glow_pic.alpha = hist_screensurf.alpha = 255 * (1.0 - flowT.historyblack[1])

	}

	if (checkfade (flowT.historyscroll)){
		flowT.historyscroll = fadeupdate(flowT.historyscroll)

		if (endfade(flowT.historyscroll) == 1) {
			history_updatesnap()
			hist.scrollreset = false
			flowT.historyscroll = [0.0,0.0,0.0,0.0601,0.0]
		}
		else {
			if ((flowT.historyscroll[1] < 0.5) && (flowT.historyscroll[1] > 0.5 - flowT.historyscroll[3]*AF.tsc) && (!hist.scrollreset)) {
				flowT.historyscroll = [0.5,0.5,0.5,0.0,0.0]
			}
			if (!vertical){
				hist_screensurf.y = hist_screenT.y + historypadding - hist.direction * 1.50 * fl.h_os * (flowT.historyscroll[1] - 0.5)
				shadowsurf_rt.y = histglow.y - shadow.radius - hist.direction * 1.50 * fl.h_os * (flowT.historyscroll[1] - 0.5)
			}
			else
			{
				hist_screensurf.x = hist_screenT.x + historypadding - hist.direction * 1.50 * fl.w_os * (flowT.historyscroll[1] - 0.5)
				shadowsurf_rt.x = histglow.x - shadow.radius - hist.direction * 1.50 * fl.w_os * (flowT.historyscroll[1] - 0.5)
			}
		}
	}


	if (checkfade (flowT.historydata)){
		flowT.historydata = fadeupdate(flowT.historydata)

		if (endfade(flowT.historydata) == 1) {
			history_updatetext()
			if (prf.CONTROLOVERLAY) history_updateoverlay()
			flowT.historydata = startfade (flowT.historydata,-0.101,3.0)
		}

		hist_text.alpha = 255 * (1.0 - flowT.historydata[1])
		if(prf.CONTROLOVERLAY) hist_over.surface.alpha = 255 * (1.0 - flowT.historydata[1])*(1.0 - flowT.historydata[1])*(1.0 - flowT.historydata[1])

		if (prf.HISTORYPANEL) {
			hist_titletxt_bot.alpha = hist_title.alpha = hist_titleT.transparency * (1.0 - flowT.historydata[1])
			hist_titletxt_bd.alpha = hist_titletxt.alpha = hist_title_top.alpha = 255 * (1.0 - flowT.historydata[1])
		}
		else {
			hist_titletxt_bd.alpha = hist_titletxt.alpha = hist_title.alpha = 255 * (1.0 - flowT.historydata[1])
		}
	}


	if (checkfade(flowT.overmenu)){
		flowT.overmenu = fadeupdate(flowT.overmenu)

		if (endfade(flowT.overmenu) == 0) {
			overmenu_hide(false)
		}

		overmenu.alpha = 255 * flowT.overmenu[1]
	}

	// splash logo fade in fade out
	if (checkfade(flowT.logo)){
		flowT.logo = fadeupdate(flowT.logo)
		if (endfade(flowT.logo) == 0){

			if (prf.DMPATSTART && prf.DMPENABLED) 	fe.signal("displays_menu")
		}
		aflogo.alpha = 255 * flowT.logo[1]
	}

	// data surface fade in and fade out
	/*
	if (checkfade(flowT.data)){
		flowT.data = fadeupdate(flowT.data)

		data_surface.alpha = 255 * flowT.data[1]
		data_surface_sh_rt.alpha = themeT.themeshadow * flowT.data[1]
	}
*/
	if (checkfade(flowT.groupbg)){
		flowT.groupbg = fadeupdate(flowT.groupbg)

		groupalpha(255 * flowT.groupbg[1])
	}

	// foreground surface fade in and fade out
	/*
	if (checkfade(flowT.fg)){
		//TEST104 if ((fg_surface.alpha > 0) && !fg_surface.visible) fg_surface.visible = true
		flowT.fg = fadeupdate(flowT.fg)
		if (endfade(flowT.fg) == 0){
			//TEST104 fg_surface.visible = false
		}
		//TEST104 fg_surface.alpha = 255 * flowT.fg[1]
	}
*/
	// attract mode surface fade
	if (checkfade(flowT.attract)){
		flowT.attract = fadeupdate(flowT.attract)

		if (endfade(flowT.attract) == 0) {
			if (prf.THUMBVIDEO) videosnap_restore()

			attractitem.snap.file_name = "pics/transparent.png"
			attractitem.snap.shader = noshader
			attractitem.surface.visible = false
			attractitem.text1.visible = attractitem.text2.visible = false
			attract.starttimer = true
			if(prf.AMTUNE != "") {
				snd.attracttuneplay = false
				if (prf.BACKGROUNDTUNE != "") snd.bgtuneplay = true
			}
			else if ((prf.BACKGROUNDTUNE != "") && (prf.NOBGONATTRACT)) snd.bgtuneplay = true

		}

		attractitem.surface.alpha = attractitem.text2.alpha = 255 * flowT.attract[1]
		attractitem.text1.alpha = attract.textshadow * flowT.attract[1]
	}

	// Fade to black games in attract mode
	if (checkfade(flowT.gametoblack)){

		flowT.gametoblack = fadeupdate(flowT.gametoblack)

		if (endfade(flowT.gametoblack) == 1) {

			attractitem.snap.alpha = 255
			attractupdatesnap()
			attract.timer = tick_time
			flowT.gametoblack = startfade (flowT.gametoblack,-0.02,0.0)
		}

		attractitem.black.bg_alpha = 255 * flowT.gametoblack[1]
	}

	// Fade whole layout from black
	if (checkfade(flowT.blacker)){

		if (flowT.blacker[0] == 0.0) tilesTableZoom[focusindex.new] = startfade (tilesTableZoom[focusindex.new],-0.035,-1.0)


		flowT.blacker = fadeupdate(flowT.blacker)


		if (endfade(flowT.blacker) == 1) {
			//layoutblacker.visible = false

			if (prf.DMPATSTART && prf.DMPENABLED){
				if (prf.SPLASHON){
					flowT.logo = [0.0,1.0,0.0,-0.02,3.0]
				}
				else {
					flowT.logo = [0.0,1.0,0.0,-0.02,3.0]
				}
			}

			else if ((!prf.AMENABLE) || (!prf.AMSTART)) layoutfadein ()
		}

		fl.surf.alpha = 255*flowT.blacker[1]
		if (user_fg != null) user_fg.alpha = 255*flowT.blacker[1]
		if (prf.SPLASHON) aflogo.alpha = 255*flowT.blacker[1]
		//layoutblacker.alpha = 255 * flowT.blacker[1]
	}

	// history text fade
	if (checkfade(flowT.histtext)){
		flowT.histtext = fadeupdate(flowT.histtext)

		hist_text.y = hist_textT.h * (1.0 - flowT.histtext[1])
	}

	// history page fade in fade out
	if (checkfade(flowT.history)){
		flowT.history = fadeupdate(flowT.history)

		if (endfade(flowT.history) == 0) {
			hist_title.file_name = "pics/transparent.png"
			hist_screen.file_name = "pics/transparent.png"
			hist_screen.shader = noshader
			shadowsurf_1.shader = noshader
			shadowsurf_2.shader = noshader
			shadowsurf_rt.shader = noshader
			hist_text_surf.shader = noshader
			history_surface.visible = false
		}

		history_surface.alpha = 255 * flowT.history[1]
	}
}

//Category functions used for category filter menu
local cat = {}

function cleancat(str){

	while (str.find("(") != null){
		local ind = str.find("(")
		str = str.slice(0,ind)+"."+str.slice(ind+1,str.len())
	}
	while (str.find(")") != null){
		local ind = str.find(")")
		str = str.slice(0,ind)+"."+str.slice(ind+1,str.len())
	}
	return str
}

function buildcategorytable(){ //TEST109 AGGIORNARE Info.Category per avere la lista corretta
	cat = {}

	local cat0 = ""
	local cat1 = ""
	local cat2 = ""

	for (local i = 0; i < fe.list.size ;i++){
		cat0 = parsecategory(z_list.boot[i].z_category)

		if (cat0 == "") cat0 = "Unknown"
		local catarray = split (cat0,"/")
		cat1 = strip(catarray[0])
		if (catarray.len() > 1) cat2 = strip(catarray[1]) else cat2 = ""

		try {
			cat[cat1].num ++
		}
		catch (err) {
			cat[cat1] <- {
				num = 1
				subcats = {}
			}
		}

		try {
			cat[cat1].subcats[cat2] ++
		}
		catch (err){
			cat[cat1].subcats[cat2] <- 1
		}

	}

	local cat1array = []
}


function stripcat (offset){
	local cat = z_list.boot[offset + fe.list.index].z_category
	if (cat == "") return (["Unknown",""])

	local catarray = split (cat,"/")
	for (local i = 0 ; i < catarray.len();i++ ){
		catarray[i] = strip(catarray[i])
	}

	if (catarray.len() > 1) return (catarray)
	else return ([catarray[0],""])
}

function subcategorymenu(maincategory,subcategory){
	local categories = {}
	local ctgarray = []
	local ctgarray2 = []
	local ctgarraynum = []
	local ctgarrayglyph = []
	local cat0 = ""
	local cat1 = ""
	local cat2 = ""
	//TEST94 local currentcat = fe.game_info (Info.Category)

	local i = 0
	foreach(item,val in cat[maincategory].subcats){
		ctgarray.push(item)
	}
	ctgarray.sort(@(a,b) a.tolower()<=>b.tolower())

	for (local i = 0 ; i < ctgarray.len();i++){
		ctgarraynum.push ( cat[maincategory].subcats[ctgarray[i]])
	}
	//local currentcat = (search.catg[1] == "") ? 0 : ctgarray.find( search.catg[1] )

	for (local i = 0 ; i < ctgarray.len();i++){
		ctgarray2.push ((ctgarray[i] == "" ? maincategory : ctgarray[i] ))
	}


	ctgarray.insert(0,ltxt("ALL",TLNG))
	ctgarray2.insert(0,ltxt("ALL",TLNG))
	ctgarraynum.insert(0,"")

	local currentcat = (search.catg[1] == "*") ? 0 : ctgarray.find( search.catg[1] )

	foreach (i,item in ctgarray) ctgarrayglyph.push (i == currentcat ? 0xea10 : 0)


	zmenudraw (ctgarray2, ctgarrayglyph,ctgarraynum, maincategory, 0xe916,  subcategory == "" ? 0 : ctgarray.find(subcategory), false,false,  false,false,
	function(result){
		if (result == -1) maincategorymenu(maincategory,subcategory)

		else {
			if (result == 0) {
				if (maincategory == "Unknown"){
					//TEST75 qui andrebbe un sistema per quando non c'è categoria
				}
				else {
					// ALL selection, both single ("Plarform") and multiple ("Platform/" or "Platform /")
					search.catg = [maincategory,"*"]
				}
			}
			else {
				if (ctgarray[result] == "") {
					search.catg = [maincategory,""]
				}
				else {
					search.catg = [maincategory,ctgarray[result]]
				}
			}

			local currentname = z_list.gametable[z_list.index].z_name
			local currentsystem = z_list.gametable[z_list.index].z_system

			updatesearchdatamsg()

			mfz_apply(false)

			frosthide()
			zmenuhide()
		}
	})
}

function maincategorymenu(maincategory,subcategory){
	local categories = {}
	local ctgarray = []
	local ctgarraynum = []
	local ctgarrayglyph = []
	local cat0 = ""
	local cat1 = ""

	local i = 0
	foreach(item,val in cat){
		ctgarray.push(item)
	}
	ctgarray.sort(@(a,b) a.tolower()<=>b.tolower())

	for (local i = 0 ; i < ctgarray.len();i++){
		ctgarraynum.push (cat[ctgarray[i]].num)
	}

	ctgarray.insert (0,ltxt("ALL",TLNG))
	ctgarraynum.insert (0,"")
	local currentcat = (search.catg[0] == "") ? 0 : ctgarray.find( search.catg[0] )

	foreach (i,item in ctgarray) ctgarrayglyph.push (i == currentcat ? 0xea10 : 0)

	frostshow()

	zmenudraw (ctgarray, ctgarrayglyph,ctgarraynum, ltxt("Categories",TLNG), 0xe916, ctgarray.find(maincategory), false,false, false,false,
	function(result){
		if (result == -1) {
			if (umvisible){
				utilitymenu (umpresel)
			}
			else {
				frosthide()
				zmenuhide()
			}
		}
		else if (result == 0) {
			search.catg = ["",""]
			updatesearchdatamsg()
			mfz_apply(false)
			if (umvisible) umvisible = false
			frosthide()
			zmenuhide()
		}
		else {
			subcategorymenu(ctgarray[result], (ctgarray[result] == maincategory) ? subcategory : "")
		}
	})
}

function categorymenu(){
	// Detect current main category
	local currentcat = stripcat(0)
	maincategorymenu(currentcat[0],currentcat[1])

}

function sortmenu(vector,namevector,presel,glyph,title){

	local labelvector = []
	local glyphvector = []
	for (local i=0 ; i < namevector.len() ; i++){
		labelvector.push (namevector[abs(vector[i])-1])
		glyphvector.push (vector[i] > 0 ? 0xea52 : 0 )
	}

	zmenudraw (labelvector,glyphvector,null,title,glyph,presel,false,false,false,false,
	function(out){
		if (out == -1){
			local v0 = ""
			for (local i = 0 ; i < vector.len();i++){
				v0 = v0 + vector[i]+","
			}
			AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values = v0
			optionsmenu1()
		}
		else {
			vector[zmenu.selected] = -1 * vector[zmenu.selected]
			sortmenu(vector,namevector,zmenu.selected,glyph,title)
		}
	},
	function(){
		local startsel = zmenu.selected
		if (startsel > 0) {
			local preval = vector[zmenu.selected - 1]
			vector[zmenu.selected - 1] = vector[zmenu.selected]
			vector[zmenu.selected] = preval
			sortmenu(vector,namevector,zmenu.selected - 1,glyph,title)
		}
		return
	},
	function(){
		local startsel = zmenu.selected
		if (startsel < vector.len()-1) {
			local preval = vector[zmenu.selected + 1]
			vector[zmenu.selected + 1] = vector[zmenu.selected]
			vector[zmenu.selected] = preval
			sortmenu(vector,namevector,zmenu.selected + 1,glyph,title)
		}
		return
	}
	)

}

function deletecurrentrom(){
	if (!prf.ENABLEDELETE) return
	local emulatorname = fe.game_info (Info.Emulator)
	local infile = ReadTextFile (FeConfigDirectory+"emulators/"+emulatorname+".cfg")
   local inline = ""
	local rompath = ""
	local gamepath = ""
	local romext = ""
	local romextarray = []

	while (!infile.eos()){
		inline = infile.read_line()
		if (inline.find("rompath") == 0) {
			rompath = strip(inline.slice(7))
			if ((rompath.slice(-1) != "\\") && (rompath.slice(-1) != "/")) rompath = rompath + "/"
			gamepath = fe.game_info(Info.Name)
		}
		else if (inline.find ("romext") == 0){
			romext = strip(inline.slice(6))
			romextarray = split(romext,";")
		}
	}
	foreach (i, item in romextarray){
		print ("Deleting " + gamepath + item + "\n")
		try {
			system ("mkdir " + ap + rompath + "deleted" + ap)
			system ((OS == "Windows" ? "move " : "mv ") + ap + rompath + gamepath + item + ap + " " + ap + rompath + "deleted/" +gamepath + item + ap )
		} catch (err) {print ("skipped\n")}
	}
	z_list.gametable[z_list.index].z_fileisavailable = 0
	z_listrefreshtiles()

//	fe.set_display(fe.list.display_index)
}

function buildgamelistxml(){

	local romlist = fe.displays[fe.list.display_index].romlist
	local emudata = getemulatordata(romlist+".cfg")
	local rompath = emudata.rompath
	local xmlpath = emudata.rompath+"gamelist.xml"
	local extarray = emudata.romextarray
	local outputfile = WriteTextFile (fe.path_expand(xmlpath))
	local ext = ""

	outputfile.write_line ("<gameList>\n")
	foreach (index, item in z_list.gametable){
		outputfile.write_line("  <game>\n")
		ext = ""
		foreach (i, item in extarray){
			if (file_exist (rompath+z_list.gametable[index].z_name+item)){
				ext = item
				break
			}
		}
		outputfile.write_line("    <path>"+"./"+z_list.gametable[index].z_name+ext+"</path>\n")
		outputfile.write_line("    <name>"+z_list.gametable[index].z_title+"</name>\n")
		outputfile.write_line("    <desc>"+z_list.gametable[index].z_description+"</desc>\n")

		outputfile.write_line("    <image>"+"./"+emudata.artworktable.snap.slice(emudata.artworktable.snap.find(rompath)+rompath.len())+z_list.gametable[index].z_name+".png"+"</image>\n")
		outputfile.write_line("    <marquee>"+"./"+emudata.artworktable.wheel.slice(emudata.artworktable.wheel.find(rompath)+rompath.len())+z_list.gametable[index].z_name+".png"+"</marquee>\n")
		outputfile.write_line("    <thumbnail>"+"./"+emudata.artworktable.flyer.slice(emudata.artworktable.flyer.find(rompath)+rompath.len())+z_list.gametable[index].z_name+".png"+"</thumbnail>\n")
		outputfile.write_line("    <video>"+"./"+emudata.artworktable.video.slice(emudata.artworktable.video.find(rompath)+rompath.len())+z_list.gametable[index].z_name+".mp4"+"</video>\n")
		outputfile.write_line("    <releasedate>"+z_list.gametable[index].z_year+"0101T000000"+"</releasedate>\n")
		outputfile.write_line("    <rating>"+("0"+z_list.gametable[index].z_rating).tofloat()/10.0+"</rating>\n")
		outputfile.write_line("    <developer>"+z_list.gametable[index].z_manufacturer+"</developer>\n")
		outputfile.write_line("    <publisher>"+z_list.gametable[index].z_manufacturer+"</publisher>\n")
		outputfile.write_line("    <genre>"+z_list.gametable[index].z_category+"</genre>\n")
		outputfile.write_line("    <players>"+z_list.gametable[index].z_players+"</players>\n")
		outputfile.write_line("    <region>"+z_list.gametable[index].z_region+"</region>\n")

		outputfile.write_line("  </game>\n")
	}
	outputfile.write_line("</gameList>\n\n")
}

function editmetadata(){

}

/// On Signal ///
function on_signal( sig ){
	debugpr ("\n Si:" + sig )

	if ((sig == "back") && (zmenu.showing) && (prf.THEMEAUDIO)) snd.mbacksound.playing = true
	if ((((sig == "up") && checkrepeat(count.up))|| ((sig == "down") && checkrepeat(count.down))) && (zmenu.showing) && (prf.THEMEAUDIO)) snd.mplinsound.playing = true

	if (AF.scrape.purgedromdirlist != null) {
		if (sig == "back") AF.scrape.quit = true
		return true
	}

	if ((AF.scrape.purgedromdirlist == null) && (AF.messageoverlay.visible == true)) {
		if (sig == "back") {
			AF.messageoverlay.visible = false
			fe.signal("back")
			fe.signal("back")
			fe.set_display(fe.list.display_index)
		}
		//else if (sig == "up") AF.messageoverlay.first_line_hint--
		//else if (sig == "down") AF.messageoverlay.first_line_hint++
		else if (sig == "up") {
			if (checkrepeat(count.up)){
				AF.messageoverlay.first_line_hint--
				count.up ++
				return true
			}
			else return true
		}

		else if (sig == "down") {
			if (checkrepeat(count.down)){
				AF.messageoverlay.first_line_hint++
				count.down ++
				return true
			}
			else return true
		}

		else if (sig == "left") {
			if (checkrepeat(count.down)){
				AF.messageoverlay.first_line_hint-=10
				count.left ++
				return true
			}
			else return true
		}

		else if (sig == "right") {
			if (checkrepeat(count.down)){
				AF.messageoverlay.first_line_hint+=10
				count.right ++
				return true
			}
			else return true
		}

		else if (sig == "screenshot"){
			return false
		}
		return true
	}

	if (AF.updatechecking) return

	// search page signal response
	if (keyboard_visible())
	{
		debugpr (" SEARCH \n")

		if ( sig == "up" ) {
			keyboard_select_relative( 0, -1 )
			while ((key_rows[key_selected[1]][key_selected[0]].tochar()=="{") || (key_rows[key_selected[1]][key_selected[0]].tochar()=="}"))
				keyboard_select_relative( (key_rows[key_selected[1]][key_selected[0]].tochar()=="{" ? -1 : 1), 0 )
		}

		else if ( sig == "down" ) {
			keyboard_select_relative( 0, 1 )
			while ((key_rows[key_selected[1]][key_selected[0]].tochar()=="{") || (key_rows[key_selected[1]][key_selected[0]].tochar()=="}"))
				keyboard_select_relative( (key_rows[key_selected[1]][key_selected[0]].tochar()=="{") ? -1 : 1, 0 )
		}

		else if ( sig == "left" ) {
			keyboard_select_relative( -1, 0 )
			while ((key_rows[key_selected[1]][key_selected[0]].tochar()=="{") || (key_rows[key_selected[1]][key_selected[0]].tochar()=="}"))
				keyboard_select_relative( -1, 0 )
		}

		else if ( sig == "right" ) {
			keyboard_select_relative( 1, 0 )
			while ((key_rows[key_selected[1]][key_selected[0]].tochar()=="{") || (key_rows[key_selected[1]][key_selected[0]].tochar()=="}"))
				keyboard_select_relative( 1, 0 )
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

	if (sig == prf.DELETEBUTTON){
		deletecurrentrom()
	}

	// Manage display jumps for nested displays list
	if (  ((sig == "prev_display") || (sig == "next_display")) && (prf.JUMPDISPLAYS)) {
		prf.JUMPSTEPS --
		if (prf.JUMPSTEPS == 0) prf.JUMPDISPLAYS = false
	}

	// Key response when attract mode is enabled (running or not)
	if (prf.AMENABLE){
		// Resets attract timer so when attract is not running the wait time is reset
		attract.timer = fe.layout.time

		if (attract.rolltext){
			// If attract is running stops attract unless we are taking screenshots

			if (sig == "screenshot") return false

			flowT.attract = [0.0,1.0,0.0,-0.09,3.0]
			attract.start = false
			attract.rolltext = false
			attract.gametimer = false

			layoutfadein()
			return true
		}

	}

	// Signal responses that are available in every context

	// Switch thumbnails between snaps and boxart
	if ((sig == prf.SWITCHMODEBUTTON) ){
		if (keyboard_visible()) return true

		switchmode()
		return true
	}

	if (sig == prf.CATEGORYBUTTON){
		if (history_visible()) return true
		if (prfmenu.showing || zmenu.dmp) return true
		if (keyboard_visible()) return true

		categorymenu()
	}

	if (sig == prf.MULTIFILTERBUTTON){
		if (history_visible()) return true
		if (prfmenu.showing || zmenu.dmp) return true
		if (keyboard_visible()) return true

		zmenu.mfm = true
		frostshow()
		mfmbgshow()
		mfz_menu0(0)
	}

	if (sig == prf.SEARCHBUTTON){
		if (history_visible()) return true
		if (prfmenu.showing || zmenu.dmp) return true

		new_search()
	}

	if (sig == "filters_menu"){

		if (fe.filters.len() == 0) return true //Don't open menu if no filters are available

		if (history_visible()) return true
		if (prfmenu.showing || zmenu.dmp) return true
		if (keyboard_visible()) return true

		local filterarray = []
		local filterglyphs = []
		local filternotes = []
		local filterindex = 0
		for (local i = 0; i <fe.filters.len();i++){
			filterarray.push (fe.filters[i].name)
			filternotes.push (fe.filters[i].size)
			filterglyphs.push (fe.filters[i].name == fe.list.filter ? 0xea10 : 0)
		}

		frostshow()
		zmenudraw (filterarray,filterglyphs,filternotes,ltxt("FILTERS",TLNG),0xea5b,(fe.filters.len() != 0 ? fe.list.filter_index : 0 ),false,false,false,false,
		function(result){
			if (result != -1) {
				fe.list.filter_index = result

				if (umvisible) umvisible = false
				frosthide()
				zmenuhide()
			}
			else {
				if (umvisible) utilitymenu(umpresel)
				else {
					frosthide()
					zmenuhide()
				}
			}
		})
		//return true
	}

	// Signal response when the new menu system is showing
	if ((zmenu.showing) && (sig != "displays_menu") && ((sig != "layout_options"))){
		if (sig == "screenshot") return false
		if (sig == "reload") return false
		//if (!prf.JUMPDISPLAYS && ((sig == "prev_display") || (sig == "next_display")))  return false

		if (sig == "up") {
			if (checkrepeat(count.up)){
				if (zmenu.selected > count.skipup) {
					zmenu.selected = zmenu.selected - 1

					while ((zmenu.strikelines[zmenu.selected].visible) || (zmenu.mfm && (zmenu.notes[zmenu.selected] == "(0)"))) {
						if (zmenu.selected > count.skipup) {
							zmenu.selected = zmenu.selected - 1
						}
						else {
							zmenu.selected = zmenu.selected + 1
							count.skipup = zmenu.selected
						}
					}
				}
				else if ((count.up == 0) ){
					zmenu.selected = zmenu.shown - 1

					while ((zmenu.strikelines[zmenu.selected].visible) || (zmenu.mfm && (zmenu.notes[zmenu.selected] == "(0)"))){
						if (zmenu.selected > count.skipup) {
							zmenu.selected = zmenu.selected - 1
						}
					}
					count.forceup = false
					//return true
				}
				else if ((!count.forceup) && (count.up !=0)){
					count.forceup = true
					//return true
				}
				zmenu.sidelabel.msg = zmenu.notes[zmenu.selected]
				count.up ++
			}
			else return true
		}

		if (sig == "down") {
			if (checkrepeat (count.down)){
				if (zmenu.selected < count.skipdown) {
					zmenu.selected = zmenu.selected + 1

					while ((zmenu.strikelines[zmenu.selected].visible) || (zmenu.mfm && (zmenu.notes[zmenu.selected] == "(0)"))){
						if (zmenu.selected < count.skipdown) {
							zmenu.selected = zmenu.selected + 1
						}
						else {
							zmenu.selected = zmenu.selected - 1
							count.skipdown = zmenu.selected
						}
					}
				}
				else if (count.down == 0){
					zmenu.selected = 0

					while ((zmenu.strikelines[zmenu.selected].visible) || (zmenu.mfm && (zmenu.notes[zmenu.selected] == "(0)"))){
						if (zmenu.selected < count.skipdown) {
							zmenu.selected = zmenu.selected + 1
						}
					}
					count.forcedown = false
					//return true
				}
				else if ((!count.forcedown) && (count.down !=0)){
					count.forcedown = true
					//return true
				}
				/*
				while (zmenu.strikelines[zmenu.selected].visible) {
					if (zmenu.selected < zmenu.shown -1) zmenu.selected = zmenu.selected + 1
					else zmenu.selected = 0
				}
				*/
				zmenu.sidelabel.msg = zmenu.notes[zmenu.selected]
				count.down ++
			}
			else return true
		}

		if (sig == "left") {
			if (zmenu.reactleft == null) {
				zmenu.selected = count.skipup
				zmenu.sidelabel.msg = zmenu.notes[zmenu.selected]
			}
			else zmenu.reactleft()
		}

		if (sig == "right") {
			if (zmenu.reactright != null) zmenu.reactright()
		}

		if ((sig == "up") || (sig == "down") || (sig == "left") || (sig == "right")) {
			if (prf.DMPIMAGES) disp.xstop = - zmenu.selected * disp.spacing

			if (prfmenu.showing)	{
				updatemenu(prfmenu.level,zmenu.selected)
      		prfmenu.description.msg =  (prfmenu.level == 1 ? AF.prefs.l0[zmenu.selected].description : (AF.prefs.l1[prfmenu.outres0][(prfmenu.level == 2 ? zmenu.selected : prfmenu.outres1)].help))
			}

		   if (prfmenu.browsershowing) {
				prfmenu.helppic.file_name = prfmenu.browserdir[zmenu.selected]
			}

			local menucorrect = 0

			if (zmenu.shown - 1 - zmenu.selected < (overlay.rows -1) / 2) menucorrect =  (overlay.rows -1) / 2 - zmenu.shown +1 + zmenu.selected
			if (zmenu.selected < (overlay.rows -1) / 2) menucorrect = - (overlay.rows -1) / 2 + zmenu.selected

			if (zmenu.midscroll) menucorrect = 0

			zmenu.xstop = menucorrect * zmenu.tileh - zmenu.midoffset - zmenu.selected * zmenu.tileh + (zmenu.height - zmenu.tileh)*0.5
			if ( (zmenu.shown <= overlay.rows) && !zmenu.midscroll ) zmenu.xstop = 0

			for (local i = 0 ; i < zmenu.shown; i++){
				zmenu.items[i].set_rgb (255,255,255)
				zmenu.noteitems[i].set_rgb (255,255,255)
				zmenu.glyphs[i].set_rgb (255,255,255)

				if ((zmenu.mfm) &&(zmenu.notes[i] == "(0)")) {
					zmenu.items[i].set_rgb(81,81,81)
					zmenu.noteitems[i].set_rgb(81,81,81)
				}

			}
			zmenu.items[zmenu.selected].set_rgb(0,0,0)
			zmenu.noteitems[zmenu.selected].set_rgb(0,0,0)
			zmenu.glyphs[zmenu.selected].set_rgb(0,0,0)
			zmenu.selectedbar.y = zmenu.sidelabel.y = zmenu.items[zmenu.selected].y
			return true
		}

		if (sig == "select") {
			if (prf.THEMEAUDIO) snd.clicksound.playing = true
			zmenu.reactfunction(zmenu.selected)
			return true
		}

		if (sig == "exit_to_desktop"){
			//frosthide()
			//zmenuhide()

			exitcommand()

			return false
		}

		if (sig == "back") {
			zmenu.reactfunction(-1)
			return true
		}

	return true

	}

	if (sig == "exit"){
		if (!prf.DMPIFEXITAF){
			frostshow()
			zmenudraw (ltxtarray(prf.POWERMENU ? ["Yes","No","Power","Shutdown","Restart","Sleep"]:["Yes","No"],TLNG),prf.POWERMENU ? [0xea10,0xea0f,-1,0xe9b6,0xe984,0xeaf6]:[0xea10,0xea0f],null,ltxt("EXIT ARCADEFLOW?",TLNG),0xe9b6,1,false,false,true,false,
			function(result){
				if (result == 0) 	fe.signal("exit_to_desktop")
				else if (prf.POWERMENU && (result == 3)) powerman("SHUTDOWN")
				else if (prf.POWERMENU && (result == 4)) powerman("REBOOT")
				else if (prf.POWERMENU && (result == 5)) powerman("SUSPEND")
				else {
					frosthide()
					zmenuhide()
				}
			})
		}
		else if (prf.DMPENABLED){
			fe.signal("displays_menu")
		}
		return true
	}

	// This is the way to call a frosted glass menu:
	if ((sig == "layout_options") && (!prf.OLDOPTIONSPAGE)) {	// Check if the desired signal is triggered
		if (history_visible()) return true
		if (zmenu.dmp) zmenu.dmp = false
		if (keyboard_visible()) return true


		frostshow()
		optionsmenu() // This is the final part where custom code to manage the signal can be added.

		return true
	}

	if (sig == "add_favourite"){
		if (z_list.gametable[z_list.index].z_favourite == "1") {
			local gamename = z_list.gametable[z_list.index].z_name
			local emulatorname = z_list.gametable[z_list.index].z_emulator
			try{delete z_list.favdatetable[emulatorname][gamename]}catch(err){}
			//save the favdate table to file
			z_savefavdatetofile()
			remove_fav()
			} else {

			local datetab = date()
			local datestr = datetab.year * 10000000000 + datetab.month * 100000000 + datetab.day * 1000000+datetab.hour*10000+datetab.min*100 + datetab.sec
			datestr = datestr.tostring()
			local gamename = z_list.gametable[z_list.index].z_name
			local emulatorname = z_list.gametable[z_list.index].z_emulator
			z_list.favdatetable[emulatorname][gamename] <- datestr
			//save the favdate table to file
			z_savefavdatetofile()
			add_fav()
			// Update the favdate table in memory
		}
		return true //TEST105 was return true, use return false to dinamically update AM
	}

	if (sig == "displays_menu"){
		if (!prf.DMPENABLED) return false

		if (history_visible()) return true
		if (prfmenu.showing) return true
		if (keyboard_visible()) return true

		if (prf.DMPATSTART){
			/*
			flowT.fg = startfade(flowT.fg,1.02,-1.0)
			flowT.data = startfade(flowT.data,-1.02,-1.0)
			*/
			flowT.groupbg = startfade(flowT.groupbg,-1.02,-1.0)
		}

		frostshow()

		if ((prf.DMPGROUPED) ){

			displaygrouped()
			return true
		}
		else if ((!prf.DMPGROUPED) ){

			displayungrouped()
			return true
		}
	}

	// frosted glass effect signal response
	if (sig == "add_tags"){
		if (history_visible()) return true
		if (keyboard_visible()) return true

		frostshow()
		tags_menu()
		return true
	}

	// rotation controls signal response
	if(sig == "toggle_rotate_right"){
		if (fe.layout.toggle_rotation == RotateScreen.None)
		{
			fe.layout.toggle_rotation = RotateScreen.Right
			fe.signal ("reload")
		}
		else{
			fe.layout.toggle_rotation = RotateScreen.None
			fe.signal ("reload")
		}
		return true
	}

	if(sig == "toggle_rotate_left"){
		if (fe.layout.toggle_rotation == RotateScreen.None)
		{
			fe.layout.toggle_rotation = RotateScreen.Left
			fe.signal ("reload")
		}
		else{
			fe.layout.toggle_rotation = RotateScreen.None
			fe.signal ("reload")
		}
		return true
	}


	// SPECIAL CASES SIGNAL RESPONSE
	// context menu signal response
	if (overmenu_visible())
	{
		debugpr (" OVERMENU \n")

		if (sig == "up"){

			frostshow()
			overmenu_hide(false)

			zmenudraw (["More of the same...","Scrape selected game","Edit metadata","CAUTION!","Delete ROM"],[0xe987,0xe9c2,0xe906,-1,0xe9ac],["","","","",prf.ENABLEDELETE?"":"Disabled"], ltxt("Game Menu",TLNG),0xe916,0,false,false,false,false,
			function (result){
				if (result == 0) {
					local taglist = z_list.gametable[z_list.index].z_tags
					local switcharray = []
					local switchnotes = []
					switcharray.push(ltxt("Year",TLNG))
					switcharray.push(ltxt("Decade",TLNG))
					switcharray.push(ltxt("Manufacturer",TLNG))
					switcharray.push(ltxt("Main Category",TLNG))
					switcharray.push(ltxt("Sub Category",TLNG))
					switcharray.push(ltxt("Orientation",TLNG))
					switcharray.push(ltxt("Favourite state",TLNG))
					switcharray.push(ltxt("Series",TLNG))
					switcharray.push(ltxt("Rating",TLNG))
					switcharray.push(ltxt("Arcade system",TLNG))

					switchnotes.push( z_list.gametable[z_list.index].z_year)
					switchnotes.push( (z_list.gametable[z_list.index].z_year.len() > 3 ? z_list.gametable[z_list.index].z_year.slice(0,3) : "")+"x")
					switchnotes.push( z_list.gametable[z_list.index].z_manufacturer )
					try{
						switchnotes.push( split(z_list.gametable[z_list.index].z_category,"/")[0] )
					}
					catch (err){
						switchnotes.push("?")
					}
					switchnotes.push( z_list.gametable[z_list.index].z_category )
					switchnotes.push( z_list.gametable[z_list.index].z_rotation )
					switchnotes.push( (z_list.gametable[z_list.index].z_favourite == "1" ? ltxt("Yes",TLNG) : ltxt("No",TLNG) ))
					switchnotes.push( z_list.gametable[z_list.index].z_series )
					switchnotes.push( z_list.gametable[z_list.index].z_rating )
					switchnotes.push( z_list.gametable[z_list.index].z_arcadesystem )

					local numset = switcharray.len()

					switcharray.extend( taglist.map (function(value){ return ("🏷 "+value)}) )
					foreach(i, item in switcharray) switchnotes.push ("")

					local numtag = switcharray.len()
					//switcharray.push (ltxt("RESET (KEEP FOCUS)",TLNG))
					switcharray.push (ltxt("RESET",TLNG))

					frostshow()
					zmenudraw (switcharray,null,switchnotes, "  " + ltxt("More of the same",TLNG)+"...",0xe987,0,false,false,false,false,
					function(result){
						if(result==numtag){
							search.mots2string = ""
							search.mots2 = ["",""]
							updatesearchdatamsg()
							mfz_apply(false)
						}

						if (result == -1) {
							frosthide()
							zmenuhide()
						}

						if (result == 0) {
							search.mots2 = ["z_year", z_list.gametable[z_list.index].z_year]
							search.mots2string = ltxt("Year",TLNG)+":"+search.mots2[1]
						}

						if (result == 1) {
							search.mots2 = ["z_year", z_list.gametable[z_list.index].z_year.slice(0,3)]
							search.mots2string = ltxt("Year",TLNG)+":"+search.mots2[1]+"x"

						}

						if (result == 2) {
							search.mots2 = ["z_manufacturer", z_list.gametable[z_list.index].z_manufacturer]
							search.mots2string = ltxt("Manufacturer",TLNG)+":"+search.mots2[1]
						}

						if (result == 3) {
							try{
								local s = z_list.gametable[z_list.index].z_category
								local s2 = split( s, "/" )
								search.mots2 = ["z_category", cleancat(s2[0])]
								search.mots2string = ltxt("Category",TLNG)+":"+s2[0]
							}
							catch(err){}
						}

						if (result == 4) {
							search.mots2 = ["z_category", z_list.gametable[z_list.index].z_category]
							search.mots2string = ltxt("Category",TLNG)+":"+search.mots2[1]

						}

						if (result == 5) {
							search.mots2 = ["z_rotation", z_list.gametable[z_list.index].z_rotation]
							search.mots2string = ltxt("Rotation",TLNG)+":"+search.mots2[1]
						}

						if (result == 6) {
							search.mots2 = ["z_favourite", z_list.gametable[z_list.index].z_favourite]
							search.mots2string = ltxt("Favourite",TLNG)+":"+search.mots2[1]
						}

						if (result == 7) {
							search.mots2 = ["z_series", z_list.gametable[z_list.index].z_series]
							search.mots2string = ltxt("Series",TLNG)+":"+search.mots2[1]
						}

						if (result == 8) {
							search.mots2 = ["z_rating", z_list.gametable[z_list.index].z_rating]
							search.mots2string = ltxt("Rating",TLNG)+":"+search.mots2[1]
						}

						if (result == 9) {
							search.mots2 = ["z_arcadesystem", z_list.gametable[z_list.index].z_arcadesystem]
							search.mots2string = ltxt("Arcade Sys",TLNG)+":"+search.mots2[1]
						}

						if ((result >= numset) && (result < numtag)) {
							search.mots2 = ["z_tags", taglist[result - numset]]
							search.mots2string = ltxt("Tags",TLNG)+":"+search.mots2[1]
						}

						// GOOD
						if ((result != numtag) && (result != -1) && (search.mots2[1] != "")) {

							local currentname = z_list.gametable[z_list.index].z_name
							local currentsystem = z_list.gametable[z_list.index].z_system
							if (backs.index == -1) {
								backs.index = fe.list.index
							}
							updatesearchdatamsg()

							mfz_apply(false)
						}

						frosthide()
						zmenuhide()
					})
				} // Here ends the first entry of the menu
				if (result == 1) { // Scrape current game
					local tempprf = generateprefstable()
					scraperomlist2(tempprf,tempprf.MEDIASCRAPE,getcurrentgame())
				}
				if (result == 2){ // Edit metadata
					metamenu(0)
				}
				if (result == 3){ // Delete ROM
					zmenudraw (["Delete","Cancel"],[0xea10,0xea0f],null,"Delete "+fe.game_info(Info.Name)+"?",0xe9ac,1,false,false,true,false,
					function (result){
						if (result == 0){
							deletecurrentrom()
						}
						frosthide()
						zmenuhide()
					}
				)}
				if (result == -1) {
					frosthide()
					zmenuhide()
				}
			})

/*

			*/
			return true
		}

		else if (sig == "down") {
			overmenu_hide(false)
			history_show(true)

			return true
		}

		else if (sig == "left") {
			// add tags
			overmenu_hide(false)
			fe.signal ("add_tags")
			return true
		}

		else if (sig == "right") {
			// add current game to favorites
			overmenu_hide(false)
			//fe.signal("add_favourite")
			//frostshow()
			fe.signal("add_favourite")


			return true
		}

		else if (sig == "back") {
			overmenu_hide(false)
			return true
		}

		else if (sig == "select") {

			overmenu_hide(true)
			//hideallbutbg()
			return hideallbutbg ()
		}
		else if ((sig == prf.OVERMENUBUTTON) && (prf.OVERMENUBUTTON != "select")) {

			overmenu_hide(false)
			return true
		}

		return false
	}

	// IF NO OVERMENU OR SEARCH, WE ARE IN HISTORY OR GRID, SO PREV/NEXT CONTROLS ARE COMMON
	else {

		// next and previous game or page signal response
		if (sig == "next_game") {
			if (checkrepeat(count.next_game)) {
				if(prf.THEMEAUDIO) snd.plingsound.playing = true
				if (z_list.index < (z_list.size -1 )) z_list_indexchange(z_list.index + 1 )
				else z_list_indexchange( 0 )
				if (history_visible()) history_changegame(1)
				count.next_game ++
			}
			return true
		}
		if (sig == "prev_game") {
			if (checkrepeat(count.prev_game)) {
				if(prf.THEMEAUDIO) snd.plingsound.playing = true
				if (z_list.index > 0) z_list_indexchange(z_list.index - 1 )
				else z_list_indexchange( z_list.size - 1 )
				if (history_visible()) history_changegame(-1)
				count.prev_game ++
			}
			return true
		}

		if(sig == "prev_page"){
			if (checkrepeat(count.prev_page)) {
				if(prf.THEMEAUDIO) snd.plingsound.playing = true
				if (z_list.index > pagejump) z_list_indexchange (z_list.index - pagejump)
				else z_list_indexchange (0)
				if (history_visible()) history_changegame(-1)
				count.prev_page ++
			}
			return true
		}
		if(sig == "next_page"){
			if (checkrepeat(count.next_page)) {
				if(prf.THEMEAUDIO) snd.plingsound.playing = true
				if (z_list.index < z_list.size - 1 - pagejump) z_list_indexchange(z_list.index + pagejump)
				else z_list_indexchange (z_list.size -1 )
				if (history_visible()) history_changegame(1)
				count.next_page ++
			}
			return true
		}


		if (sig == "next_favourite"){
			local i0 = z_list.index
			local i1 = i0 +1

			while (i0 != i1){
				if (i1 == z_list.size) i1 = 0
				if (z_list.gametable[i1].z_favourite == "1") {
					z_list_indexchange(i1)
					break
				}
				i1 ++
			}

			return true
		}

		if (sig == "prev_favourite"){
			local i0 = z_list.index
			local i1 = i0 -1

			while (i0 != i1){
				if (i1 == -1) i1 = z_list.size - 1
				if (z_list.gametable[i1].z_favourite == "1") {
					z_list_indexchange(i1)
					break
				}
				i1 --
			}

			return true
		}

		if (sig =="next_letter"){
			if (checkrepeat(count.next_letter)) {
				if(prf.THEMEAUDIO) snd.plingsound.playing = true
				z_list_indexchange (z_list.jumptable[z_list.index].next)
				if (history_visible()) history_changegame(1)
				count.next_letter ++
			}
			return true
		}
		if (sig =="prev_letter"){
			if (checkrepeat(count.prev_letter)) {
				if(prf.THEMEAUDIO) snd.plingsound.playing = true
				z_list_indexchange (z_list.jumptable[z_list.index].prev)
				if (history_visible()) history_changegame(-1)
				count.prev_letter ++
			}
			return true
		}
		if (sig == "random_game"){
			z_list_indexchange(z_list.size*rand()/RAND_MAX )
			if(prf.THEMEAUDIO) snd.plingsound.playing = true
			if (history_visible()) history_changegame(1)
			return true
		}

		// history page signal response
		if (history_visible())
		{
			debugpr (" HISTORY \n")

			if (sig == "select") {
				if (z_list.gametable[z_list.index].z_system == "") {
					history_hide()
					return
				}
				return (hideallbutbg () )
			}

			if (sig == "up") {
				if (checkrepeat(count.up)){
					on_scroll_up()
					count.up ++
					return true
				}
				else return true
			}

			else if (sig == "down") {
				if (checkrepeat(count.down)){
					on_scroll_down()
					count.down ++
					return true
				}
				else return true
			}

			else if ((sig == "left")) {
				if (checkrepeat(count.left)){

					if (z_list.index > 0) {
						z_list_indexchange (z_list.index - 1)
						history_changegame(-1)
					}
					else{
						z_list_indexchange (z_list.size - 1)
						history_changegame(1)
					}

					count.left++
					//history_show(false)
					return true
				}
				else return true
			}

			else if ((sig == "right") ) {

				if (checkrepeat(count.right)){

					if (z_list.index < (z_list.size -1 )) {
						z_list_indexchange (z_list.index + 1)
						history_changegame(1)
					}
					else {
						z_list_indexchange (0)
						history_changegame (-1)
					}
					//history_show(false)
					count.right++
					return true
				}
				else return true
			}

			else if (sig == "back") {
				history_exit()
				return true
			}

			return false
		}



		// normal signal response no history visible
		else {

			if ((sig == "select") && (prf.HISTORYBUTTON != "select") && (prf.OVERMENUBUTTON != "select")){
				return (hideallbutbg ())
			}

			if ((sig == prf.UTILITYMENUBUTTON) && (prf.UTILITYMENUBUTTON != "up")){
				utilitymenu(0)
				return true
			}



			debugpr (" NORMAL \n")
			switch ( sig ){

				case prf.HISTORYBUTTON:
					history_show(true)
				return true

				case prf.OVERMENUBUTTON:
					if (z_list.size == 0) return true
					if (z_list.gametable[z_list.index].z_system == "") return false
					overmenu_show()
				return true

				case "left":
				if ( checkrepeat(count.left) ){
					if (scroll.sortjump){
						fe.signal ("prev_letter")
					}
					else {
						if (z_list.index > scroll.step - 1) {
								z_list_indexchange (z_list.index - scroll.step)
								if(prf.THEMEAUDIO) snd.plingsound.playing = true
							}
						else if ((count.left == 0)){
							z_list_indexchange (z_list.size - 1)
							count.forceleft = false
							return true
						}
						else if ((!count.forceleft) && (count.left != 0)){
							tilesTableZoom[focusindex.new] = [0.8,0.8,0.8,0.04,0.0]
							tilesTableUpdate[focusindex.new] = [0.8,0.8,0.8,0.04,0.0]
							count.forceleft = true
							return true
						}
					}
					count.left ++
				}
				return true

				case "right":
				if (checkrepeat(count.right)){
					if (scroll.sortjump){
						fe.signal ("next_letter")
					}
					else {
						if ((z_list.index < z_list.size - scroll.step)){
							// A) Normal scrolling routine: index is changed unless we are at the last item in the list
							z_list_indexchange (z_list.index + scroll.step)
							if(prf.THEMEAUDIO) snd.plingsound.playing = true
						}
						else if ((count.right == 0)){
							// B) We are at the last item of the list, and count.right = 0, therefore
							// the "right" key has not been kept pressed.
							// Pressing this will jump to the beginning of the list and restore forceright
							z_list_indexchange (0)
							count.forceright = false
							return true
						}
						else if ((!count.forceright) && (count.right != 0)){
							// C) We are at the end of the list but forceright is still false (we haven't hit the wall)
							// and count.right is not zero (we are still running towards the wall),
							// we switch forceright to true so nothing more will happen and next time it will be "B" case
							tilesTableZoom[focusindex.new] = [0.8,0.8,0.8,0.04,0.0]
							tilesTableUpdate[focusindex.new] = [0.8,0.8,0.8,0.04,0.0]
							count.forceright = true
							return true
						}
					}
					count.right ++
				}
				return true

				case "up":
				if (checkrepeat(count.up)){

					if ((z_list.index % rows > 0) && (scroll.jump == false) && (scroll.sortjump == false)) {
						z_list_indexchange (z_list.index -1)
						if(prf.THEMEAUDIO) snd.plingsound.playing = true
					}
					else if (scroll.jump == true){
						if(prf.THEMEAUDIO) snd.wooshsound.playing = true
						tilesTableZoom[focusindex.new] = startfade (tilesTableZoom[focusindex.new],0.035,-5.0)

						scroll.jump = false
						scroll.step = rows
						scroller2.visible = scrollineglow.visible = false
					}
					else if (scroll.sortjump == true){
						if(prf.THEMEAUDIO) snd.wooshsound.playing = true

					if (prf.SCROLLERTYPE == "labellist") tilesTableZoom[focusindex.new] = startfade (tilesTableZoom[focusindex.new],0.035,-5.0)

						scroll.sortjump = false
						labelstrip.visible = false
						if (prf.SCROLLERTYPE != "labellist") {
							scroll.jump = true
							scroll.step = pagejump
							scroller2.visible = scrollineglow.visible = true
						}
					}

					else {
						count.up = -1
						if (prf.UTILITYMENUBUTTON == "up") {

							utilitymenu(0)
						}
					}
					count.up ++
				}
				return true

				case "down":
				if (checkrepeat(count.down)){

				if ((scroll.jump == false) && (scroll.sortjump == false) && ((z_list.index % rows < rows -1) && ( ! ( (z_list.index / rows == z_list.size / rows)&&(z_list.index%rows + 1 > (z_list.size -1)%rows) ))) ){
					if ((corrector == 0) && (z_list.index == z_list.size-1)) return true
					z_list_indexchange (z_list.index + 1)
					if(prf.THEMEAUDIO) snd.plingsound.playing = true
				}

				// if you go down and label list is not active, activate scroll.jump
				else if ((scroll.jump == false) && (scroll.sortjump == false) && (prf.SCROLLERTYPE != "labellist")){
					if(prf.THEMEAUDIO) snd.wooshsound.playing = true

					tilesTableZoom[focusindex.new] = startfade (tilesTableZoom[focusindex.new],-0.035,-5.0)

					scroll.jump = true
					scroll.step = rows*(cols-2)
					scroller2.visible = scrollineglow.visible = true
					scroll.sortjump = false
				}

				// if scroll.jump is enabled and we are not in scrollbar mode, or if we are in labellist mode, activate scroll.sortjump
				else if (((scroll.jump == true) && (scroll.sortjump == false) && (z_list.size > 0) && (prf.SCROLLERTYPE != "scrollbar")) || ((prf.SCROLLERTYPE == "labellist") && (z_list.size > 0) && (scroll.sortjump == false))){
					if(prf.THEMEAUDIO) snd.wooshsound.playing = true

					tilesTableZoom[focusindex.new] = startfade (tilesTableZoom[focusindex.new],-0.035,-5.0)

					scroll.jump = false
					scroller2.visible = scrollineglow.visible = false
					scroll.sortjump = true
					labelstrip.visible = true
				}
				count.down++
				}
				return true

				// All other cases
				//default:
					//if(prf.THEMEAUDIO) {snd.wooshsound.playing = true


			}// END OF SWITCH SIGNAL LOOP
		}// CLOSE ELSE GROUP
	}
	return false
}
