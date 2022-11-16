// Arcadeflow - v 14.9
// Attract Mode Theme by zpaolo11x
//
// Based on carrier.nut scrolling module by Radek Dutkiewicz (oomek)
// Including code from the KeyboardSearch plugin by Andrew Mickelson (mickelson)

// Load file nut
fe.do_nut("nut_file.nut")

function z_write_line(file, line){
	local b = blob( line.len() )
	foreach (id, item in line)
		b.writen( item, 'b' )
	file.writeblob( b )
}

function split_complete(str_in, separator){
	local outarray = []
	local index = 0
	while (str_in.find (separator) != null){
		index = str_in.find (separator)
		outarray.push (str_in.slice(0,index))
		str_in = str_in.slice(index+separator.len())
	}
	outarray.push(str_in)
	return outarray
}

// COME CAMBIA AR DA AF98
/*
Modificare la funzione GetAR in modo che restituisca l'AR _DA MOSTRARE_ pre-clamp,
così per il GG è 4/3 come letto da System, per MAME è 3:4 o 4:3 secondo "orientation"
per altri handheld è texture W/H stretto, se siamo in boxart mode è semplicemente texture W/H

l'AR poi viene clampato o snapcroppato, a quel punto viene definita la dimensione dell'artwork.
*/

//EASE PRINT
//local CCC = 0

local elapse = {
	name = ""
	t1 = 0
	t2 = 0
	timer = false
	timetable = {}
}

local ap = '"'.tochar()

function timestart(name){
	if (!elapse.timer) return
	print ("\n    "+name+" START\n")
	elapse.timetable.rawset(name, fe.layout.time)
}

function timestop(name){
	if (!elapse.timer) return
	elapse.t2 = fe.layout.time
	print("    "+name+" STOP: "+(elapse.t2-elapse.timetable[name])+"\n")
}

local IDX = array(100000)

// Support array for quick sort
foreach (i, item in IDX) {IDX[i] = format("%s%5u","\x00",i)}

// Support array for unicode mapping
function returngly(){
	local uniglyph = [" ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""]
	return (uniglyph)
}

// General AF data table
local AF = {

	dat_freeze = true
	dat_freezecount = 0

	bgs_freezecount = 0

	uniglyphs = returngly()
	version = "14.9"
	vernum = 0
	folder = fe.script_dir
	subfolder = ""
	romlistfolder = fe.path_expand(FeConfigDirectory + "romlists/")
	emulatorsfolder = fe.path_expand(FeConfigDirectory + "emulators/")
	bgsongs = []

	config = null

	soundvolume = 0

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

	req = {
		keyboard = -1
		executef = -2
		filereqs = -3
		menusort = -4
		exenoret = -5
		textentr = -6
		rgbvalue = -7
		huevalue = -8
		slideint = -9
		liner = -100
	}

	updatechecking = false
	boxmessage = [""]
	messageoverlay = null
	tsc = 1.0 // Scaling of timer for different parameters

	scrape = null

	emulatordata = {}

	LNG = ""

	bar = {
		time0 = 0
		time1 = 0
		progress = 0
		pic = null
		picbg = null
		size = 300
		dark = 60
		darkalpha = 90
	}
}

function AFscrapeclear(){
	AF.scrape = {
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
		timeoutroms = []
		columns = 60
		separator1 = ""
		separator2 = ""
		onegame = ""
		dispatchid = 0
		requests = ""
		report = {}
		threads = 0
	}
	for (local i = 0 ; i < AF.scrape.columns;i++){
		AF.scrape.separator1 += "-"
		AF.scrape.separator2 += "="
	}
}

AFscrapeclear()
AF.vernum = AF.version.tofloat()*10

// GitHub versioning data table
local gh = {
	latest_version = 0
	release_notes = 0
	taglist = []
	branchlist = []
}

function gly(index){
	local unizero = 0xe900
	try {return (AF.uniglyphs[index - unizero + 1])} catch (err) {return ""}
}

AF.subfolder = AF.folder.slice(AF.folder.find("layouts"))

local zmenu = null

// Load language file
// Language is first taken from file if present. If it's not present "EN" is used. After settings the language is updated and file is updated too.
fe.do_nut("nut_language.nut")
AF.LNG = "EN"
try {AF.LNG = loadlanguage ()} catch (err){}

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

// Custom splash message wrappers with AF custom fonts
function z_splash_message(text){
	fe.layout.font = uifonts.monodata
	fe.overlay.splash_message(text)
	fe.layout.font = uifonts.general
}

function z_edit_dialog(text1,text2){
	fe.layout.font = uifonts.condensed
	fe.overlay.edit_dialog(text1,text2)
	fe.layout.font = uifonts.general
}


function bar_update(i,init,max){
	//	print ("i:"+i+" ")
		local redraw = false
		if (i == init){
			//print("INIT\n")
			AF.bar.time0 = 0
			AF.bar.time1 = 0
			AF.bar.progress = 0
			AF.bar.pic.visible = true
			AF.bar.picbg.visible = true
			AF.bar.picbg.msg=gly(0xeafb+12)
			AF.bar.pic.msg = gly(0xeafb)
			return
		}

		if (i == max-1){
			//print("CLOSE\n")
			AF.bar.pic.visible = false
			AF.bar.picbg.visible = false
			return
		}

		AF.bar.time1 = clock()

		if (AF.bar.time1 - AF.bar.time0 >= 1.0/ScreenRefreshRate) {
			//print (" FRAME ")
			if (i <= max*0.2) {
				//print ("i<max*0.2")
				redraw = true
				AF.bar.pic.alpha = 255 * i/(max*0.2)
				AF.bar.picbg.alpha = AF.bar.darkalpha * i/(max*0.2)
			}
			else if (i >= max*0.9){
				//print ("i>max*0.8")
				redraw = true
				AF.bar.pic.alpha = 255 * (1.0-(i-max*0.9)/(max*0.1))
				AF.bar.picbg.alpha = 0//AF.bar.darkalpha * (1.0-(i-max*0.8)/(max*0.2))
			}

			if (floor(11*i*1.0/max) != AF.bar.progress){
				AF.bar.progress = floor(11*i*1.0/max)
				AF.bar.pic.msg = gly(0xeafb+AF.bar.progress)
				//print (" progress:"+AF.bar.progress+" ")
				redraw = true
			}
			AF.bar.time0 = AF.bar.time1
			if (redraw) fe.layout.redraw()
			//print("\n")

		}

	}

/// Config management ///

/* Principles of ALLGAMES collections:

FUNCTIONS AND DATA STRUCTURES
parseconfig ()
	scans the attract.cfg and returns a table with all the
	config data.
	During this scan the string "# Enable AF Collections" is
	checekd and is used to determine if the function is
	enabled as out.collections

	The function is called at the beginning of the layout and
	results passed to AF.config

z_af_collections
	data structure of ALLGAMES collections including a table with
	collections names and data and an array that is used to
	force the sorting of the collections

buildconfig (allgames)
	works directly on AF.config, runs through the AF.config and
	removes all the entries related to the ALLGAMES, then
	rebuilds the list with all the ALLGAMES entries at the end
	of the list.
	After rebuilding the config it writes the attract.cfg adding
	the ""# Enable AF Collections" if prf.ALLGAMES is true

WORKFLOW

1) AF.config = parseconfig()
	Populates the AF.config table, AF.config.collections is true or
	false depending on the found string, but notice that this does
	not guarantee that ALLGAMES displays are actually there
	(someone could've altered them manually)

2) Load the whole layout data

3) prf.ALLGAMES != AF.config.collections
	if prf.ALLGAMES is not coherent with AF.config.collections
	buildconfig(prf.ALLGAMES) is called, this cleans the attract.cfg
	and makes it coherent with the preference set.

	After this, if prf.ALLGAMES is true all games collections
	are updated using update_allgames_collections (true)

	In the end the layout must be reloaded
*/

function restartAM(){
	fe.signal("exit_to_desktop")
	if (OS == "Windows") system ("start attractplus-console.exe")
	else if (OS == "OSX") system ("./attractplus &")
	else system ("attractplus &")
}

// This function parses the attract.cfg and builds a structure for all displays
function parseconfig(){
	local cfgfile = ReadTextFile ( fe.path_expand( FeConfigDirectory + "attract.cfg" ) )
	local displaytable = []
	local inline = ""
	local displayname = ""
	local predisplays = []
	local postdisplays = []
	local id = 0
	local af_collections = false

	inline = cfgfile.read_line()
	while (inline[0].tochar() == "#"){
		if (inline.find("# Enable AF Collections") == 0) af_collections = true
		else predisplays.push(inline)
		inline = cfgfile.read_line()
	}
	while (inline.find("display\t") != 0){
		predisplays.push(inline)
		inline = cfgfile.read_line()
	}
	while (!cfgfile.eos()){
		//inline = cfgfile.read_line()
		if (inline.find("display\t") == 0) {
			displayname = split(inline,"\t")[1]
			displaytable.push ({"display": displayname})
			inline = cfgfile.read_line()
			displaytable[id].rawset("filters",[])
			while (inline != ""){
				switch (split(inline,"\t ")[0]){
					case "layout":
					case "romlist":
					case "in_cycle":
					case "in_menu":
						displaytable[id].rawset(split(inline,"\t ")[0],inline.slice(21))
						break
					case "filter":
					case "sort_by":
					case "list_limit":
					case "exception":
					case "global_filter":
					case "rule":
						displaytable[id].filters.push(inline)
						break
				}
				inline = cfgfile.read_line()
			}
			id ++
			inline = cfgfile.read_line()
		}
		else {
			postdisplays.push(inline)
			inline = cfgfile.read_line()
		}
	}
	//Add last read line from stream, which for sure is not a "display"
	postdisplays.push(inline)

	local warning = false
	local tempval = null
	foreach(i, item in postdisplays){
		if (item.find("image_cache_mbytes")==0) {
			tempval = split(item," ")[1]
			if (tempval != "0" ) {
				z_edit_dialog("*WARNING*\nSet Image Cache Size to zero to avoid issues","")
				warning = true
			}
		}
		if (item.find("menu_layout")==0) {
			tempval = split(item," ")
			if (tempval.len()>1){
				if (tempval[1].find("Arcadeflow")==0){
					z_edit_dialog("*WARNING*\nDon't use Arcadeflow as displays menu layout","")
					 warning = true
				}
			}
		}
		if (item.find("startup_mode")==0) {
			tempval = split(item," ")[1]
			if (tempval != "default" ) warning = true
		}
	}
	if (warning) print ("\n\nWARNING: some options in attract.cfg clash with Arcadeflow\n\n")


	local out = {
		header = predisplays
		displays = displaytable
		footer = postdisplays
		collections = af_collections
	}
	//foreach(i,val in out.footer) print (i+" "+val+"\n")
	return (out)
}

// Define AF custom collections
local z_af_collections = {
	tab = {}
	arr = []
}

z_af_collections.tab = {
	"AF All Games" : {
		id = "AF All Games"
		group = "COLLECTIONS"
		groupedname = "All Games"
		ungroupedname = "All Games"
		filename = "_all_all"
	}
	"AF Favourites" : {
		id = "AF Favourites"
		group = "COLLECTIONS"
		groupedname = "Favourites"
		ungroupedname = "Favourites"
		filename = "_favourites_all"
	}
	"AF Last Played" : {
		id = "AF Last Played"
		group = "COLLECTIONS"
		groupedname = "Last Played"
		ungroupedname = "Last Played"
		filename = "_lastplayed_all"
	}
	"AF All Arcade Games" : {
		id = "AF All Arcade Games"
		group = "ARCADE"
		groupedname = "All Games"
		ungroupedname = "All Arcade Games"
		filename = "_arcade_all"
	}
	"AF All Console Games" : {
		id = "AF All Console Games"
		group = "CONSOLE"
		groupedname = "All Games"
		ungroupedname = "All Console Games"
		filename = "_console_all"
	}
	"AF All Handheld Games" : {
		id = "AF All Handheld Games"
		group = "HANDHELD"
		groupedname = "All Games"
		ungroupedname = "All Handheld Games"
		filename = "_handheld_all"
	}
	"AF All Computer Games" : {
		id = "AF All Computer Games"
		group = "COMPUTER"
		groupedname = "All Games"
		ungroupedname = "All Computer Games"
		filename = "_computer_all"
	}
	"AF All Pinball Games" : {
		id = "AF All Pinball Games"
		group = "PINBALL"
		groupedname = "All Games"
		ungroupedname = "All Pinball Games"
		filename = "_pinball_all"
	}
}

z_af_collections.arr.push (z_af_collections.tab["AF All Games"])
z_af_collections.arr.push (z_af_collections.tab["AF Favourites"])
z_af_collections.arr.push (z_af_collections.tab["AF Last Played"])
z_af_collections.arr.push (z_af_collections.tab["AF All Arcade Games"])
z_af_collections.arr.push (z_af_collections.tab["AF All Console Games"])
z_af_collections.arr.push (z_af_collections.tab["AF All Handheld Games"])
z_af_collections.arr.push (z_af_collections.tab["AF All Computer Games"])
z_af_collections.arr.push (z_af_collections.tab["AF All Pinball Games"])
z_af_collections.arr.reverse()

// Update the attract.cfg to incorporate all the collections
// This function doesn't reboot the layout, so changes are not effective
// until AM re-reads the config file
function buildconfig(allgames, tempprf){
	local cfgtable = AF.config

	// First step purges special AF collections
	local i = 0
	while (i < cfgtable.displays.len()){
		if (cfgtable.displays[i].romlist.find("AF ") == 0)  cfgtable.displays.remove(i)
		else i++
	}

	// then rebuilds the display list with all collections at the end of the list
	if (allgames){
		foreach (item, val in z_af_collections.tab){
			cfgtable.displays.push({
				display = item
				layout = fe.displays[fe.list.display_index].layout
				romlist = item
				in_cycle = "yes"
				in_menu = "no"
				filters = tempprf.MASTERLIST ? ["global_filter","rule                 FileIsAvailable equals 1", "filter               All","filter               Favourites","rule                 Favourite equals 1"] : ["filter               All","filter               Favourites","rule                 Favourite equals 1"]
			})
		}
	}

	// Starts writing the text file
	local cfgfile = WriteTextFile ( fe.path_expand( FeConfigDirectory + "attract.cfg" ) )

	foreach (id, item in cfgtable.header){
		cfgfile.write_line(item+"\n")
	}
	if (allgames) cfgfile.write_line ("# Enable AF Collections\n")
	foreach (item, value in cfgtable.displays){
		cfgfile.write_line ("display\t"+value.display+"\n")
		cfgfile.write_line ("\tlayout               "+value.layout+"\n")
		cfgfile.write_line ("\tromlist              "+value.romlist+"\n")
		cfgfile.write_line ("\tin_cycle             "+value.in_cycle+"\n")
		cfgfile.write_line ("\tin_menu              "+value.in_menu+"\n")
		foreach (item2, val2 in value.filters){
			cfgfile.write_line( ((val2.slice(0,6) == "filter") || (val2 == "global_filter")) ? "\t"+val2+"\n" : "\t\t"+val2+"\n")
		}
		cfgfile.write_line("\n")
	}

	foreach (id, item in cfgtable.footer){
		cfgfile.write_line(item+"\n")
	}
	cfgfile.close_file()
}

AF.config = parseconfig()

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
	debugfile.close_file()
}

local DBGON = false
try {DBGON = loaddebug()} catch (err) {}

function debugpr (instring){
	if (DBGON) print (instring)
}
local dispatcher = []
local dispatchernum = 0

function scraprt (instring){
	print (dispatchernum+" "+instring)
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
	tempfile.close_file()
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
print ("CRC:" + (getromcrc_old(crr.fil))[0] + " ")
crr.tttt1 = fe.layout.time
print(crr.tttt1-crr.tttt0+"msec\n")

crr.tttt0 = fe.layout.time
print ("CRC:" + (getromcrc(crr.fil))[0] + " ")
crr.tttt1 = fe.layout.time
print(crr.tttt1-crr.tttt0+"msec\n")

crr.tttt0 = fe.layout.time
print ("CRC:" + (getromcrc_halfbyte(crr.fil))[0] + " ")
crr.tttt1 = fe.layout.time
print(crr.tttt1-crr.tttt0+"msec\n")

crr.tttt0 = fe.layout.time
print ("CRC:" + (getromcrc_lookup(crr.fil))[0] + " ")
crr.tttt1 = fe.layout.time
print(crr.tttt1-crr.tttt0+"msec\n")

crr.tttt0 = fe.layout.time
print ("CRC:" + (getromcrc_lookup4(crr.fil))[0] + " ")
crr.tttt1 = fe.layout.time
print(crr.tttt1-crr.tttt0+"msec\n")
*/

/// Preferences functions and table ///
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
	outnames.sort(@(a,b) ltxt(a,AF.LNG).tolower() <=> ltxt(b,AF.LNG).tolower())
	foreach (i, item in outnames){
		outnames[i] = ltxt(item,AF.LNG)
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

function monitorlist(){
	local out = []
	foreach (id, item in fe.monitors){
		out.push (id.tostring())
	}
	return (out)
}

local menucounter = 0
local sorter = {}

AF.prefs.l0.push({label = "GENERAL", glyph = 0xe993, description = "Define the main options of Arcadeflow like number of rows, general layout, control buttons, language, thumbnail source etc"})
AF.prefs.l1.push([
{v = 10.2, varname = "layoutlanguage", glyph = 0xe9ca, initvar = function(val,prf){prf.LAYOUTLANGUAGE <- val}, title = "Layout language", help = "Chose the language of the layout" , options = languagearray(), values = languagetokenarray(), selection = 1, picsel = languageflags(),pic="flags.jpg"},
{v = 10.5, varname = "powermenu", glyph = 0xe9b6, initvar = function(val,prf){prf.POWERMENU <- val}, title = "Power menu", help = "Enable or disable power options in exit menu" , options = ["Yes","No"], values = [true,false], selection = 1},
{v = 0.0, varname = "", glyph = -1, title = "Layout", selection = AF.req.liner},
{v = 7.2, varname = "horizontalrows", glyph = 0xea72, initvar = function(val,prf){prf.HORIZONTALROWS <- val}, title = "Rows in horizontal", help = "Number of rows to use in 'horizontal' mode" , options = ["1-Small", "1", "2", "3"], values = [-1,1,2,3], selection = 2, picsel = ["rows1mini"+AF.prefs.imgext,"rows1"+AF.prefs.imgext,"rows2"+AF.prefs.imgext,"rows3"+AF.prefs.imgext],pic = "rows2"+AF.prefs.imgext},
{v = 7.2, varname = "verticalrows", glyph = 0xea71, initvar = function(val,prf){prf.VERTICALROWS <- val}, title = "Rows in vertical", help = "Number of rows to use in 'vertical' mode" , options = ["1", "2", "3"], values = [1,2,3], selection = 2, picsel = ["rowsv1"+AF.prefs.imgext,"rowsv2"+AF.prefs.imgext,"rowsv3"+AF.prefs.imgext],pic = "rowsv3"+AF.prefs.imgext},
{v = 7.2, varname = "cleanlayout", glyph = 0xe997, initvar = function(val,prf){prf.CLEANLAYOUT <- val}, title = "Clean layout", help = "Reduce game data shown on screen" , options = ["Yes","No"], values = [true,false], selection = 1, picsel = ["cleanyes"+AF.prefs.imgext,"cleanno"+AF.prefs.imgext],pic = "cleanyes"+AF.prefs.imgext},
{v = 7.2, varname = "lowres", glyph = 0xe997, initvar = function(val,prf){prf.LOWRES <- val}, title = "Low resolution", help = "Optimize theme for low resolution screens, 1 row layout forced, increased font size and cleaner layout" , options = ["Yes","No"], values = [true,false], selection = 1,picsel = ["lowreson"+AF.prefs.imgext,"lowresoff"+AF.prefs.imgext],pic = "lowreson"+AF.prefs.imgext},
{v = 12.8, varname = "customcolor", glyph = 0xe90c, initvar = function(val,prf){prf.CUSTOMCOLOR <- val}, title = "Custom color", help = "Define a custom color for UI elements using sliders" , options = "", values = "", selection = AF.req.rgbvalue},
{v = 0.0, varname = "", glyph = -1, title = "Game Data", selection = AF.req.liner},
{v = 7.2, varname = "showsubname", glyph = 0xea6d, initvar = function(val,prf){prf.SHOWSUBNAME <- val}, title = "Display Game Long Name", help = "Shows the part of the rom name with version and region data" , options = ["Yes","No"], values = [true,false], selection = 0, picsel = ["subdefaultname"+AF.prefs.imgext,"subnosubname"+AF.prefs.imgext]},
{v = 7.2, varname = "showsysname", glyph = 0xea6d, initvar = function(val,prf){prf.SHOWSYSNAME <- val}, title = "Display System Name", help = "Shows the System name under the game title" , options = ["Yes","No"], values = [true,false], selection = 0, picsel = ["subdefaultname"+AF.prefs.imgext,"subnosystem"+AF.prefs.imgext]},
{v = 10.1, varname = "showarcadename", glyph = 0xea6d, initvar = function(val,prf){prf.SHOWARCADENAME <- val}, title = "Display Arcade System Name", help = "Shows the name of the Arcade system if available" , options = ["Yes","No"], values = [true,false], selection = 0},
{v = 7.2, varname = "showsysart", glyph = 0xea6d, initvar = function(val,prf){prf.SHOWSYSART <- val}, title = "System Name as artwork", help = "If enabled, the system name under the game title is rendered as a logo instead of plain text" , options = ["Yes","No"], values = [true,false], selection = 0, picsel = ["subdefaultname"+AF.prefs.imgext,"subnosystemart"+AF.prefs.imgext]},
{v = 0.0, varname = "", glyph = -1, title = "Scroll & Sort", selection = AF.req.liner},
{v = 10.3, varname = "scrollamount", glyph = 0xea45, initvar = function(val,prf){prf.SCROLLAMOUNT <- val}, title = "Page jump size", help = "Page jumps are one screen by default, you can increase it if you want to jump faster" , options = ["1 Screen", "2 Screens", "3 Screens"], values = [1, 2, 3] , selection = 0},
{v = 7.2, varname = "scrollertype", glyph = 0xea45, initvar = function(val,prf){prf.SCROLLERTYPE <- val}, title = "Scrollbar style", help = "Select how the scrollbar should look" , options = ["Timeline", "Scrollbar", "Label List"], values = ["timeline", "scrollbar", "labellist"] , selection = 0, picsel = ["scrolltimeline"+AF.prefs.imgext,"scrollscrollbar"+AF.prefs.imgext,"scrolllabellist"+AF.prefs.imgext],pic="scroll"+AF.prefs.imgext},
{v = 7.2, varname = "striparticle", glyph = 0xea4c, initvar = function(val,prf){prf.STRIPARTICLE <- val}, title = "Strip article from sort", help = "When sorting by Title ignore articles" , options = ["Yes","No"], values = [true,false], selection = 1},
{v = 10.9, varname = "enablesort", glyph = 0xea4c, initvar = function(val,prf){prf.ENABLESORT <- val}, title = "Enable sorting", help = "Enable custom realtime sorting, diable to keep romlist sort order" , options = ["Yes","No"], values = [true,false], selection = 0},
{v = 7.2, varname = "sortsave", glyph = 0xea4c, initvar = function(val,prf){prf.SORTSAVE <- val}, title = "Save sort order", help = "Custom sort order is saved through Arcadeflow sessions" , options = ["Yes","No"], values = [true,false], selection = 0},
])

menucounter ++
AF.prefs.l0.push({ label = "THUMBNAILS", glyph = 0xe915, description = "Chose the aspect ratio of thumbnails, video thumbnails and decorations"})
AF.prefs.l1.push([
{v = 7.2, varname = "cropsnaps", glyph = 0xea57, initvar = function(val,prf){prf.CROPSNAPS <- val}, title = "Aspect ratio", help = "Chose wether you want cropped, square snaps or adaptive snaps depending on game orientation", options = ["Adaptive", "Square"], values = [false, true], selection = 0, picsel= ["aradaptive"+AF.prefs.imgext,"arsquare"+AF.prefs.imgext],pic = "arsquare"+AF.prefs.imgext},
{v = 8.7, varname = "morphaspect", glyph = 0xea57, initvar = function(val,prf){prf.MORPHASPECT <- val}, title = "Morph snap ratio", help = "Chose if you want the box to morph into the actual game video or if it must be cropped", options = ["Morph video", "Crop video"], values = [true, false], selection = 0},
{v = 10.9, varname = "fix169", glyph = 0xea57, initvar = function(val,prf){prf.FIX169 <- val}, title = "Optimize vertical arcade", help = "Enable this option if you have 9:16 vertical artwork from the Vertical Arcade project", options = ["Yes", "No"], values = [true, false], selection = 1},
{v = 10.4, varname = "tilezoom", glyph = 0xea57, initvar = function(val,prf){prf.TILEZOOM <- val}, title = "Zoom thumbnails", help = "Chose if you want the selected thumbnail to zoom to a larger size", options = ["Standard", "Reduced", "None"], values = [2, 1, 0], selection = 0},
{v = 10.7, varname = "logosonly", glyph = 0xea6d, initvar = function(val,prf){prf.LOGOSONLY <- val}, title = "Show only logos", help = "If enabled, only game tilte logos will be shown instead of the screenshot", options = ["Yes", "No"], values = [true, false], selection = 1},
{v = 0.0, varname = "", glyph = -1, title = "Snapshot Options", selection = AF.req.liner},
{v = 8.8, varname = "titleart", glyph = 0xe915, initvar = function(val,prf){prf.TITLEART <- val}, title = "Snapshot artwork source", help = "Chose if you want the snapshot artwork from gameplay or title screen" options = ["Gameplay", "Title screen"], values = [false, true], selection = 0},
{v = 8.4, varname = "titleonsnap", glyph = 0xea6d, initvar = function(val,prf){prf.TITLEONSNAP <- val}, title = "Show game title", help = "Show the title of the game over the thumbnail" , options = ["Yes","No"], values = [true,false], selection = 0},
{v = 0.0, varname = "", glyph = -1, title = "Box Art Options", selection = AF.req.liner},
{v = 7.2, varname = "boxartmode", glyph = 0xe918, initvar = function(val,prf){prf.BOXARTMODE <- val}, title = "Box Art mode", help = "Show box art or flyers instead of screen captures by default (can be configured with menu or hotkey)" , options = ["Yes","No"], values = [true,false], selection = 1, picsel = ["boxarton"+AF.prefs.imgext,"boxartoff"+AF.prefs.imgext], pic = "boxart"+AF.prefs.imgext},
{v = 7.2, varname = "titleonbox", glyph = 0xe918, initvar = function(val,prf){prf.TITLEONBOX <- val}, title = "Game title over box art", help = "Shows the game title artwork overlayed on the box art graphics" , options = ["Yes","No"], values = [true,false], selection = 1,picsel = ["boxarttitle"+AF.prefs.imgext,"boxarton"+AF.prefs.imgext],pic = "boxarttitle"+AF.prefs.imgext},
{v = 7.2, varname = "boxartsource", glyph = 0xe918, initvar = function(val,prf){prf.BOXARTSOURCE <- val}, title = "Box Art artwork source", help = "Chose the artwork source for box art graphics" , options = ["flyer", "fanart"], values = ["flyer", "fanart"], selection = 0 },
{v = 0.0, varname = "", glyph = -1, title = "Video Snaps", selection = AF.req.liner},
{v = 7.2, varname = "thumbvideo", glyph = 0xe913, initvar = function(val,prf){prf.THUMBVIDEO <- val}, title = "Video thumbs", help = "Enable video overlay on snapshot thumbnails" , options = ["Yes","No"], values = [true,false], selection = 0},
{v = 8.5, varname = "fadevideotitle", glyph = 0xe913, initvar = function(val,prf){prf.FADEVIDEOTITLE <- val}, title = "Fade title on video", help = "Fades game title and decoration when the video is playing" , options = ["Yes","No"], values = [true,false], selection = 1},
{v = 8.4, varname = "thumbvidelay", glyph = 0xe913, initvar = function(val,prf){prf.THUMBVIDELAY <- val}, title = "Video delay multiplier", help = "Increase video load delay" , options = ["0.25x","0.5x","1x", "2x","3x","4x","5x"], values = [0.25,0.5,1,2,3,4,5], selection = 2},
{v = 7.2, varname = "missingwheel", glyph = 0xea6d, initvar = function(val,prf){prf.MISSINGWHEEL <- val}, title = "Generate missing title art", help = "If no game title is present, the layout can generate it" , options = ["Yes","No"], values = [true,false], selection = 0,picsel = ["missingwheelyes"+AF.prefs.imgext,"missingwheelno"+AF.prefs.imgext],pic = "missingwheel"+AF.prefs.imgext},
{v = 14.8, varname = "vid169", glyph = 0xea57, initvar = function(val,prf){prf.VID169 <- val}, title = "Vertical arcade videos", help = "Enable this option if you are using 9:16 videos from the Vertical Arcade project", options = ["Yes", "No"], values = [true, false], selection = 1},
{v = 0.0, varname = "", glyph = -1, title = "Decorations", selection = AF.req.liner},
{v = 9.6, varname = "redcross", glyph = 0xe936, initvar = function(val,prf){prf.REDCROSS <- val}, title = "Game not available indicator", help = "Games that are not available will be marked with a red cross overlay" , options = ["Yes","No"], values = [true,false], selection = 0},
{v = 7.2, varname = "newgame", glyph = 0xe936, initvar = function(val,prf){prf.NEWGAME <- val}, title = "New game indicator", help = "Games not played are marked with a glyph" , options = ["Yes","No"], values = [true,false], selection = 0, picsel=["decornewgame"+AF.prefs.imgext,"decornone"+AF.prefs.imgext],pic = "decornewgame"+AF.prefs.imgext},
{v = 7.2, varname = "tagshow", glyph = 0xe936, initvar = function(val,prf){prf.TAGSHOW <- val}, title = "Show tag indicator", help = "Shows a tag attached to thumbnails that contains any tag" , options = ["Yes","No"], values = [true,false], selection = 0, picsel=["decortag"+AF.prefs.imgext,"decornone"+AF.prefs.imgext],pic = "decortag"+AF.prefs.imgext},
{v = 7.2, varname = "tagname", glyph = 0xe936, initvar = function(val,prf){prf.TAGNAME <- val}, title = "Custom tag name", help = "You can see a tag glyph overlayed to the thumbs, chose the tag name to use", options = "", values = "", selection = AF.req.keyboard},
{v = 7.2, varname = "gbrecolor", glyph = 0xe90c, initvar = function(val,prf){prf.GBRECOLOR <- val}, title = "Game Boy color correction", help = "Apply a colorized palette to Game Boy games based on the system name or forced to your preference" , options = ["Automatic", "Classic", "Pocket", "Light", "None"], values = ["AUTO", "LCDGBC", "LCDGBP", "LCDGBL" ,"NONE"], selection = 0, picsel = ["gb"+AF.prefs.imgext,"gbclassic"+AF.prefs.imgext,"gbpocket"+AF.prefs.imgext,"gblight"+AF.prefs.imgext,"gbnone"+AF.prefs.imgext],pic = "gb"+AF.prefs.imgext},
{v = 10.3, varname = "crtrecolor", glyph = 0xe90c, initvar = function(val,prf){prf.CRTRECOLOR <- val}, title = "MSX crt color correction", help = "Apply a palette correction to MSX media that was captured with MSX2 palette" , options = ["Yes", "No"], values = [true,false], selection = 1},
])

menucounter ++
AF.prefs.l0.push({ label = "BACKGROUND", glyph = 0xe90c, description = "Chose the layout background theme in main page and in History page, or select custom backgrounds"})
AF.prefs.l1.push([
{v = 7.2, varname = "colortheme", glyph = 0xe90c, initvar = function(val,prf){prf.COLORTHEME <- val}, title = "Overlay color", help = "Setup theme luminosity overlay, Basic is slightly muted, Dark is darker, Light has a white overlay and dark text, Pop keeps the colors unaltered" , options = ["Basic", "Dark", "Light", "Pop"], values =["basic", "dark", "light", "pop"], selection = 3, picsel = ["overlaybasic"+AF.prefs.imgext,"overlaydark"+AF.prefs.imgext,"overlaylight"+AF.prefs.imgext,"overlaypop"+AF.prefs.imgext], pic = "overlay"+AF.prefs.imgext},
{v = 8.9, varname = "overcustom", glyph = 0xe930, initvar = function(val,prf){prf.OVERCUSTOM <- val}, title = "Custom overlay", help = "Insert custom PNG to be overlayed over everything", options = "", values = "pics/", selection = AF.req.filereqs},
{v = 8.4, varname = "bgcustom", glyph = 0xe930, initvar = function(val,prf){prf.BGCUSTOM <- val}, title = "Custom main BG image", help = "Insert custom background art path (use grey.png for blank background, vignette.png for vignette overlay)", options = "", values = "pics/", selection = AF.req.filereqs,pic="bgcustom"+AF.prefs.imgext},
{v = 8.4, varname = "bgcustomstretch", glyph = 0xea57, initvar = function(val,prf){prf.BGCUSTOMSTRETCH <- val}, title = "Format of main BG image", help = "Select if the custom background must be cropped to fill the screen or stretched", options = ["Crop","Stretch"], values = [false,true], selection = 1,pic="bgcustom"+AF.prefs.imgext},
{v = 0.0, varname = "", glyph = -1, title = "History BG", selection = AF.req.liner},
{v = 8.4, varname = "bgcustomhistory", glyph = 0xe930, initvar = function(val,prf){prf.BGCUSTOMHISTORY <- val}, title = "Custom history BG image", help = "Insert custom background art path for history page (leave blank if the same as main background)", options = "", values ="pics/", selection = AF.req.filereqs,pic="bgcustomhistory"+AF.prefs.imgext},
{v = 8.4, varname = "bgcustomhistorystretch", glyph = 0xea57, initvar = function(val,prf){prf.BGCUSTOMHISTORYSTRETCH <- val}, title = "Format of history BG image", help = "Select if the custom background must be cropped to fill the screen or stretched", options = ["Crop","Stretch"], values = [false,true], selection = 1,pic="bgcustomhistory"+AF.prefs.imgext},
{v = 0.0, varname = "", glyph = -1, title = "BG Snaps", selection = AF.req.liner},
{v = 7.2, varname = "layersnap", glyph = 0xe90d, initvar = function(val,prf){prf.LAYERSNAP <- val}, title = "Background snap", help = "Add a faded game snapshot to the background" , options = ["Yes","No"], values = [true,false], selection = 1, picsel = ["bgsnapyes"+AF.prefs.imgext,"bgsnapno"+AF.prefs.imgext],pic="bgsnap"+AF.prefs.imgext},
{v = 7.2, varname = "layervideo", glyph = 0xe913, initvar = function(val,prf){prf.LAYERVIDEO <- val}, title = "Animate BG snap", help = "Animate video on background" , options = ["Yes","No"], values = [true,false], selection = 1},
{v = 7.2, varname = "layervidelay", glyph = 0xe913, initvar = function(val,prf){prf.LAYERVIDELAY <- val}, title = "Delay BG animation", help = "Don't load immediately the background video animation" , options = ["Yes","No"], values = [true,false], selection = 1},
{v = 0.0, varname = "", glyph = -1, title = "Per Display", selection = AF.req.liner},
{v = 7.5, varname = "bgperdisplay", glyph = 0xe912, initvar = function(val,prf){prf.BGPERDISPLAY <- val}, title = "Per Display background", help = "You can have a different background for each display, just put your pictures in menu-art/bgmain and menu-art/bghistory folders named as the display" , options = ["Yes","No"], values = [true,false], selection = 1},
])

menucounter ++
AF.prefs.l0.push({ label = "LOGO", glyph = 0xe916, description = "Customize the splash logo at the start of Arcadeflow"})
AF.prefs.l1.push([
{v = 7.2, varname = "splashon", glyph = 0xe916, initvar = function(val,prf){prf.SPLASHON <- val}, title = "Enable splash logo", help = "Enable or disable the AF start logo" , options = ["Yes","No"], values = [true,false], selection = 0,picsel = ["logoyes"+AF.prefs.imgext,"logono"+AF.prefs.imgext], pic = "logoyes"+AF.prefs.imgext},
{v = 7.2, varname = "splashlogofile", glyph = 0xe930, initvar = function(val,prf){prf.SPLASHLOGOFILE <- val}, title = "Custom splash logo", help = "Insert the path to a custom AF splash logo (or keep blank for default logo)", options = "", values ="", selection = AF.req.filereqs,pic = "logocustom"+AF.prefs.imgext},
])

menucounter ++
AF.prefs.l0.push({ label = "COLOR CYCLE", glyph = 0xe982, description = "Enable and edit color cycling animation of tile highlight border"})
AF.prefs.l1.push([
{v = 10.7, varname = "huecycle", glyph = 0xe982, initvar = function(val,prf){prf.HUECYCLE <- val}, title = "Enable color cycle", help = "Enable/disable color cycling of the tile higlight border", options = ["Yes", "No"], values = [true, false], selection = 1},
{v = 0.0, varname = "", glyph = -1, title = "Cycle Options", selection = AF.req.liner},
{v = 10.7, varname = "hcspeed", glyph = 0xe9a6, initvar = function(val,prf){prf.HCSPEED <- val}, title = "Cycle speed", help = "Select the speed of color cycle" options = ["Slow", "Medium", "Fast"], values = [2, 5, 8], selection = 1},
{v = 10.7, varname = "hccolor", glyph = 0xe90c, initvar = function(val,prf){prf.HCCOLOR <- val}, title = "Cycle color", help = "Select a color intensity preset for the cycle" , options = ["Standard","Popping", "Light"], values = ["0.7_0.7","1.0_0.5","1.0_0.9"], selection = 0},
{v = 10.7, varname = "hcpingpong", glyph = 0xea2d, initvar = function(val,prf){prf.HCPINGPONG <- val}, title = "Ping Pong effect", help = "Enable this if you want the cycle to revert once finished instead of restarting" , options = ["Yes","No"], values = [true,false], selection = 1},
{v = 12.8, varname = "hchuestart", glyph = 0xe994, initvar = function(val,prf){prf.HCHUESTART <- val}, title = "Start hue", help = "Define the start value of the hue cycle (0 - 359)", options = "", values = "", selection = AF.req.huevalue},
{v = 12.8, varname = "hchuestop", glyph = 0xe994, initvar = function(val,prf){prf.HCHUESTOP <- val}, title = "Stop hue", help = "Define the stop value of the hue cycle (0 - 359)", options = "", values = "", selection = -8},
])

menucounter ++
AF.prefs.l0.push({ label = "AUDIO", glyph = 0xea27, description = "Configure layout sounds and audio options for videos"})
AF.prefs.l1.push([
{v = 7.2, varname = "themeaudio", glyph = 0xea27, initvar = function(val,prf){prf.THEMEAUDIO <- val}, title = "Enable theme sounds", help = "Enable audio sounds when browsing and moving around the theme" options = ["Yes","No"], values = [true,false], selection = 0},
{v = 7.2, varname = "audiovidsnaps", glyph = 0xea27, initvar = function(val,prf){prf.AUDIOVIDSNAPS <- val}, title = "Audio in videos (thumbs)", help = "Select wether you want to play audio in videos on thumbs" , options = ["Yes","No"], values = [true,false], selection = 1},
{v = 7.2, varname = "audiovidhistory", glyph = 0xea27, initvar = function(val,prf){prf.AUDIOVIDHISTORY <- val}, title = "Audio in videos (history)", help = "Select wether you want to play audio in videos on history detail page" , options = ["Yes","No"], values = [true,false], selection = 1},
{v = 7.2, varname = "backgroundtune", glyph = 0xe911, initvar = function(val,prf){prf.BACKGROUNDTUNE <- val}, title = "Layout background music", help = "Chose a background music file to play while using Arcadeflow" ,  options = "", values ="", selection = AF.req.filereqs},
{v = 10.2, varname = "randomtune", glyph = 0xe911, initvar = function(val,prf){prf.RANDOMTUNE <- val}, title = "Randomize background music", help = "If this is enabled, Arcadeflow will play a random mp3 from the folder of the selected background music" ,  options = ["Yes","No"], values = [true,false], selection = 1},
{v = 7.2, varname = "nobgonattract", glyph = 0xe911, initvar = function(val,prf){prf.NOBGONATTRACT <- val}, title = "Stop bg music in attract mode", help = "Stops playing the layout background music during attract mode" ,  options = ["Yes","No"], values =[true,false] selection = 0},
])


menucounter++
AF.prefs.l0.push({label = "", glyph = -1, description = ""})
AF.prefs.l1.push([])

menucounter ++
AF.prefs.l0.push({label = "BUTTONS", glyph = 0xea54, description = "Define custom control buttons for different features of Arcadeflow"})
AF.prefs.l1.push([
{v = 7.2, varname = "overmenubutton", glyph = 0xea54, initvar = function(val,prf){prf.OVERMENUBUTTON <- val}, title = "Context menu button", help = "Chose the button to open the game context menu" , options = ["None","Select", "Custom 1", "Custom 2", "Custom 3", "Custom 4", "Custom 5", "Custom 6"], values=["none","select", "custom1", "custom2", "custom3", "custom4", "custom5", "custom6"], selection = 1,pic = "contextmenu"+AF.prefs.imgext},
{v = 7.2, varname = "utilitymenubutton", glyph = 0xea54, initvar = function(val,prf){prf.UTILITYMENUBUTTON <- val}, title = "Utility menu button", help = "Chose the button to open the utility menu" , options = ["None", "Up", "Custom 1", "Custom 2", "Custom 3", "Custom 4", "Custom 5", "Custom 6"], values =["none", "up", "custom1", "custom2", "custom3", "custom4", "custom5", "custom6"], selection = 1,pic = "utilitymenu"+AF.prefs.imgext},
{v = 7.2, varname = "historybutton", glyph = 0xea54, initvar = function(val,prf){prf.HISTORYBUTTON <- val}, title = "History page button", help = "Chose the button to open the history or overview page" , options = ["None", "Select", "Custom 1", "Custom 2", "Custom 3", "Custom 4", "Custom 5", "Custom 6"], values =["none", "select", "custom1", "custom2", "custom3", "custom4", "custom5", "custom6"], selection = 0,pic = "bgcustomhistory"+AF.prefs.imgext},
{v = 7.2, varname = "switchmodebutton", glyph = 0xea54, initvar = function(val,prf){prf.SWITCHMODEBUTTON <- val}, title = "Thumbnail mode button", help = "Chose the button to use to switch from snapshot mode to box art mode" , options = ["None", "Custom 1", "Custom 2", "Custom 3", "Custom 4", "Custom 5", "Custom 6"], values=["none", "custom1", "custom2", "custom3", "custom4", "custom5", "custom6"], selection = 3,pic = "boxarton"+AF.prefs.imgext},
{v = 0.0, varname = "", glyph = -1, title = "Search and Filters", selection = AF.req.liner},
{v = 7.5, varname = "searchbutton", glyph = 0xea54, initvar = function(val,prf){prf.SEARCHBUTTON <- val}, title = "Search menu button", help = "Chose the button to use to directly open the search menu instead of using the utility menu" , options = ["None", "Custom 1", "Custom 2", "Custom 3", "Custom 4", "Custom 5", "Custom 6"], values=["none", "custom1", "custom2", "custom3", "custom4", "custom5", "custom6"], selection = 0,pic = "inputscreenkeys"+AF.prefs.imgext},
{v = 7.6, varname = "categorybutton", glyph = 0xea54, initvar = function(val,prf){prf.CATEGORYBUTTON <- val}, title = "Category menu button", help = "Chose the button to use to open the list of game categories" , options = ["None", "Custom 1", "Custom 2", "Custom 3", "Custom 4", "Custom 5", "Custom 6"], values=["none", "custom1", "custom2", "custom3", "custom4", "custom5", "custom6"], selection = 0},
{v = 7.6, varname = "multifilterbutton", glyph = 0xea54, initvar = function(val,prf){prf.MULTIFILTERBUTTON <- val}, title = "Multifilter menu button", help = "Chose the button to use to open the menu for dynamic filtering of romlist" , options = ["None", "Custom 1", "Custom 2", "Custom 3", "Custom 4", "Custom 5", "Custom 6"], values=["none", "custom1", "custom2", "custom3", "custom4", "custom5", "custom6"], selection = 0},
{v = 14.2, varname = "favbutton", glyph = 0xea54, initvar = function(val,prf){prf.FAVBUTTON <- val}, title = "Show favorites button", help = "Chose the button to use to toggle favorite filtering" , options = ["None", "Custom 1", "Custom 2", "Custom 3", "Custom 4", "Custom 5", "Custom 6"], values=["none", "custom1", "custom2", "custom3", "custom4", "custom5", "custom6"], selection = 0},
{v = 0.0, varname = "", glyph = -1, title = "Sound", selection = AF.req.liner},
{v = 12.5, varname = "volumebutton", glyph = 0xea54, initvar = function(val,prf){prf.VOLUMEBUTTON <- val}, title = "Volume button", help = "Chose the button to use to change system volume" , options = ["None", "Custom 1", "Custom 2", "Custom 3", "Custom 4", "Custom 5", "Custom 6"], values=["none", "custom1", "custom2", "custom3", "custom4", "custom5", "custom6"], selection = 0},
{v = 0.0, varname = "", glyph = -1, title = "ROM Management", selection = AF.req.liner},
{v = 9.8, varname = "deletebutton", glyph = 0xea54, initvar = function(val,prf){prf.DELETEBUTTON <- val}, title = "Delete ROM button", help = "Chose the button to use to delete the current rom from the disk. Deleted roms are moved to a -deleted- folder" , options = ["None", "Custom 1", "Custom 2", "Custom 3", "Custom 4", "Custom 5", "Custom 6"], values=["none", "custom1", "custom2", "custom3", "custom4", "custom5", "custom6"], selection = 0},
])

menucounter ++
sorter.rawset("um", menucounter)
AF.prefs.l0.push({label = "UTILITY MENU", glyph = 0xe9bd, description = "Customize the utility menu entries that you want to see in the menu"})
AF.prefs.l1.push([
{v = 14.6, varname = "umvector", glyph = 0xe9bd, initvar = function(val,prf){prf.UMVECTOR <- val}, title = "Customize Utility Menu", help = "Sort and select Utility Menu entries: Left/Right to move items up and down, Select to enable/disable item" , options = function(){return(umtablenames(umtable))}, values = sortstring(20), selection = AF.req.menusort},
{v = 14.6, varname = "umvectorreset", glyph = 0xe965, initvar = function(val,prf){prf.UMVECTORRESET <- val}, title = "Reset Utility Menu", help = "Reset sorting and selection of Utility Menu entries" , options = "", values = function(){AF.prefs.l1[sorter.um][0].values = sortstring(20)}, selection = AF.req.executef},
])

menucounter ++
AF.prefs.l0.push({ label = "DISPLAYS MENU PAGE", glyph = 0xe912, description = "Arcadeflow has its own Displays Menu page that can be configured here"})
AF.prefs.l1.push([
{v = 8.7, varname = "dmpenabled", glyph = 0xe912, initvar = function(val,prf){prf.DMPENABLED <- val}, title = "Enable Arcadeflow Displays Menu page", help = "If you disable Arcadeflow menu page you can use other layouts as displays menu" , options = ["Yes", "No"], values= [true,false],selection = 0},
{v = 9.0, varname = "olddisplaychange", glyph = 0xe912, initvar = function(val,prf){prf.OLDDISPLAYCHANGE <- val}, title = "Enable Fast Displays Change", help = "Disable fast display change if you want to use other layouts for different displays" , options = ["Yes", "No"], values= [false,true],selection = 0},
{v = 0.0, varname = "", glyph = -1, title = "Look and Feel", selection = AF.req.liner},
{v = 7.2, varname = "dmpgeneratelogo", glyph = 0xe90d, initvar = function(val,prf){prf.DMPGENERATELOGO <- val}, title = "Generate display logo", help = "Generate displays name related artwork for displays list" , options = ["Yes","No"], values = [true,false], selection = 0,picsel=["dmplistlogoyes"+AF.prefs.imgext,"dmplistlogono"+AF.prefs.imgext], pic = "dmplistlogo"+AF.prefs.imgext},
{v = 8.9, varname = "dmpsort", glyph = 0xeaf1, initvar = function(val,prf){prf.DMPSORT <- val}, title = "Sort displays menu", help = "Show displays in the menu in your favourite order" , options = ["No sort", "By display name", "By system year", "By system brand then name", "By system brand then year"], values= ["false","display","year","brandname","brandyear"],selection = 3},
{v = 9.4, varname = "dmpseparators", glyph = 0xeaf5, initvar = function(val,prf){prf.DMPSEPARATORS <- val}, title = "Show group separators", help = "When sorting by brand show separators in the menu for each brand" , options = ["Yes", "No"], values= [true,false],selection = 0},
{v = 12.3, varname = "dmpimages", glyph = 0xea77, initvar = function(val,prf){prf.DMPIMAGES <- val}, title = "Displays menu layout", help = "Chose the style to use when entering displays menu, a simple list or a list plus system artwork taken from the menu-art folder" , options = ["List", "List with artwork", "list with walls"], values= [null,"ARTWORK","WALLS"],selection = 2, picsel = ["dmplistartno"+AF.prefs.imgext,"dmplistartyes"+AF.prefs.imgext],pic = "dmplistartyes"+AF.prefs.imgext},
{v = 9.8, varname = "dmart", glyph = 0xe90d, initvar = function(val,prf){prf.DMART <- val}, title = "Artwork Source", help = "Chose where the displays menu artwork comes from: Arcadeflow own system library or Attract Mode menu-art folder" , options = ["Arcadeflow only", "menu-art only", "Arcadeflow first", "menu-art first"], values= ["AF_ONLY","MA_ONLY","AF_MA","MA_AF"],selection = 0},
{v = 12.3, varname = "dmcategoryart", glyph = 0xe90d, initvar = function(val,prf){prf.DMCATEGORYART <- val}, title = "Enable category artwork", help = "You can separately enable/disable artwork for categories like console, computer, pinball etc." , options = ["Yes", "No"], values= [true,false],selection = 0},
{v = 7.3, varname = "dmpgrouped", glyph = 0xea78, initvar = function(val,prf){prf.DMPGROUPED <- val}, title = "Categorized Displays Menu", help = "Displays menu will be grouped by system categories: Arcades, Computer, Handhelds, Consoles, Pinballs and Others for collections" , options = ["Yes", "No"], values= [true,false],selection = 0, picsel = ["dmpgroupedyes"+AF.prefs.imgext,"dmpgroupedno"+AF.prefs.imgext],pic = "dmpgroupedyes"+AF.prefs.imgext},
{v = 7.4, varname = "dmpexitaf", glyph = 0xea7c, initvar = function(val,prf){prf.DMPEXITAF <- val}, title = "Add Exit Arcadeflow to menu", help = "Add an entry to exit Arcadeflow from the displays menu page" , options = ["Yes", "No"], values= [true,false],selection = 1},
{v = 0.0, varname = "", glyph = -1, title = "Behavior", selection = AF.req.liner},
{v = 7.4, varname = "dmpatstart", glyph = 0xea7a, initvar = function(val,prf){prf.DMPATSTART <- val}, title = "Open the Displays Menu at startup", help = "Show Displays Menu immediately after launching Arcadeflow, this works better than setting it in the general options of Attract Mode" , options = ["Yes", "No"], values= [true,false],selection = 1},
{v = 7.4, varname = "dmpoutexitaf", glyph = 0xea7c, initvar = function(val,prf){prf.DMPOUTEXITAF <- val}, title = "Exit AF when leaving Menu", help = "The esc button from Displays Menu triggers the exit from Arcadeflow" , options = ["Yes", "No"], values= [true,false],selection = 1},
{v = 7.4, varname = "dmpifexitaf", glyph = 0xea7a, initvar = function(val,prf){prf.DMPIFEXITAF <- val}, title = "Enter Menu when leaving display", help = "The esc button from Arcadeflow brings the displays menu instead of exiting Arcadeflow" , options = ["Yes", "No"], values= [true,false],selection = 1},
])


menucounter ++
AF.prefs.l0.push({ label = "HISTORY PAGE", glyph = 0xe923, description = "Configure the History page where larger thumbnail and game history data are shown"})
AF.prefs.l1.push([
{v = 0.0, varname = "", glyph = -1, title = "Video Effects", selection = AF.req.liner},
{v = 8.8, varname = "crtgeometry", glyph = 0xe95b, initvar = function(val,prf){prf.CRTGEOMETRY <- val}, title = "CRT deformation", help = "Enable CRT deformation for CRT snaps" options = ["Yes", "No"], values =[true,false], selection = 0},
{v = 7.2, varname = "scanlinemode", glyph = 0xe95b, initvar = function(val,prf){prf.SCANLINEMODE <- val}, title = "Scanline effect", help = "Select scanline effect: Scanlines = default scanlines, Aperture = aperture mask, Half Resolution = reduced scanline resolution to avoid moiree, None = no scanline" options = ["Scanlines", "Half Resolution", "Aperture", "None"], values =["scanlines", "halfres", "aperture", "none"], selection = 2, picsel = ["slscanline"+AF.prefs.imgext,"slhalfres"+AF.prefs.imgext,"slaperture"+AF.prefs.imgext,"slnone"+AF.prefs.imgext],pic = "sl"+AF.prefs.imgext},
{v = 7.2, varname = "lcdmode", glyph = 0xe959, initvar = function(val,prf){prf.LCDMODE <- val}, title = "LCD effect", help = "Select LCD effect for handheld games: Matrix = see dot matrix, Half Resolution = see matrix at half resolution, None = no effect", options = ["Matrix", "Half Resolution", "None"], values = ["matrix", "halfres", "none"], selection = 1, picsel = ["lcdmatrix"+AF.prefs.imgext, "lcdhalfres"+AF.prefs.imgext, "lcdnone"+AF.prefs.imgext],pic = "lcd"+AF.prefs.imgext},
{v = 0.0, varname = "", glyph = -1, title = "Layout", selection = AF.req.liner},
{v = 8.3, varname = "historysize", glyph = 0xe923, initvar = function(val,prf){prf.HISTORYSIZE <- val}, title = "Text panel size", help = "Select the size of the history panel at the expense of snapshot area", options = ["Small", "Default", "Large", "Max snap"], values = [0.45,0.65,0.75,-1.0], selection = 1},
{v = 7.2, varname = "historypanel", glyph = 0xe923, initvar = function(val,prf){prf.HISTORYPANEL <- val}, title = "Text panel style", help = "Select the look of the history text panel", options = ["White panel", "Background"], values = [true,false], selection = 0, picsel = ["histpanelyes"+AF.prefs.imgext,"histpanelno"+AF.prefs.imgext],pic="histpanelyes"+AF.prefs.imgext},
{v = 7.2, varname = "darkpanel", glyph = 0xe923, initvar = function(val,prf){prf.DARKPANEL <- val}, title = "Game panel style", help = "Select the look of the history game panel", options = ["Dark", "Standard", "None"], values = [true,false,null], selection = 1,picsel=["histpaneldark"+AF.prefs.imgext,"histpaneldefault"+AF.prefs.imgext,"histpanelnone"+AF.prefs.imgext],pic = "histpaneldefault"+AF.prefs.imgext},
{v = 8.2, varname = "histmininame", glyph = 0xe923, initvar = function(val,prf){prf.HISTMININAME <- val}, title = "Detailed game data", help = "Show extra data after the game name before the history text", options = ["Yes", "No"], values = [false,true], selection = 0},
{v = 14.5, varname = "controloverlay", glyph = 0xe923, initvar = function(val,prf){prf.CONTROLOVERLAY <- val}, title = "Control panel overlay", help = "Show controller and buttons overlay on history page", options = ["Always", "Never","Arcade only"], values = ["always","never","arcade"], selection = 0},
])


menucounter ++
AF.prefs.l0.push({ label = "ATTRACT MODE", glyph = 0xe9a5, description = "Arcadeflow has its own attract mode screensaver that kicks in after some inactivity. Configure all the options here"})
AF.prefs.l1.push([
{v = 7.2, varname = "amenable", glyph = 0xe9a5, initvar = function(val,prf){prf.AMENABLE <- val}, title = "Enable attract mode", help = "Enable or disable attract mode at layout startup" , options = ["From start", "Inactivity only", "Disabled"], values =["From start", "Inactivity only", "Disabled"], selection = 1,pic = "attractmode"+AF.prefs.imgext},
{v = 0.0, varname = "", glyph = -1, title = "Look & Feel", selection = AF.req.liner},
{v = 7.2, varname = "amtimer", glyph = 0xe94e, initvar = function(val,prf){prf.AMTIMER <- val}, title = "Attract mode timer (s)", help = "Inactivity timer before attract mode is enabled", options = "", values ="120", selection = AF.req.keyboard},
{v = 7.2, varname = "amchangetimer", glyph = 0xe94e, initvar = function(val,prf){prf.AMCHANGETIMER <- val}, title = "Game change time (s)", help = "Time interval between each game change", options = "", values = "10", selection = AF.req.keyboard},
{v = 9.1, varname = "amshowlogo", glyph = 0xea6d, initvar = function(val,prf){prf.AMSHOWLOGO <- val}, title = "Attract logo", help = "Show Arcadeflow logo during attract mode", options = ["Yes","No"], values = [true,false], selection = 0},
{v = 7.2, varname = "ammessage", glyph = 0xea6d, initvar = function(val,prf){prf.AMMESSAGE <- val}, title = "Attract message", help = "Text to show during attract mode", options = "", values = " - PRESS ANY KEY - ", selection = AF.req.keyboard,pic = "attractmode"+AF.prefs.imgext},
{v = 0.0, varname = "", glyph = -1, title = "Sound", selection = AF.req.liner},
{v = 7.2, varname = "amtune", glyph = 0xe911, initvar = function(val,prf){prf.AMTUNE <- val}, title = "Background music", help = "Path to a music file to play in background", options = "", values ="", selection = AF.req.filereqs},
{v = 7.2, varname = "amsound", glyph = 0xea27, initvar = function(val,prf){prf.AMSOUND <- val}, title = "Enable game sound", help = "Enable game sounds during attract mode" , options = ["Yes","No"], values = [true,false], selection = 0},
])

menucounter ++
AF.prefs.l0.push({ label = "PERFORMANCE & FX", glyph = 0xe9a6, description = "Turn on or off special effects that might impact on Arcadeflow performance"})
AF.prefs.l1.push([
{v = 14.2, varname = "adaptspeed", glyph = 0xe994, initvar = function(val,prf){prf.ADAPTSPEED <- val}, title = "Adjust performance", help = "Tries to adapt speed to system performance. Enable for faster scroll, disable for smoother but slower scroll" , options = ["Yes","No"], values = [true,false], selection = 1},
{v = 7.2, varname = "customsize", glyph = 0xe994, initvar = function(val,prf){prf.CUSTOMSIZE <- val}, title = "Resolution W x H", help = "Define a custom resolution for your layout independent of screen resolution. Format is WIDTHxHEIGHT, leave blank for default resolution", options = "", values = "", selection = AF.req.keyboard, pic = "customresyes"+AF.prefs.imgext},
{v = 9.8, varname = "rpi", glyph = 0xe994, initvar = function(val,prf){prf.RPI <- val}, title = "Raspberry Pi fix", help = "This applies to systems that gives weird results when getting back from a game, reloading the layout as needed" , options = ["Yes","No"], values = [true,false], selection = 1},
{v = 0.0, varname = "", glyph = -1, title = "Overscan", selection = AF.req.liner},
{v = 12.8, varname = "overscanw", glyph = 0xe994, initvar = function(val,prf){prf.OVERSCANW <- val}, title = "Width %", help = "For screens with overscan, define which percentage of the screen will be filled with actual content", options = [0,100,100], values = 100, selection = AF.req.slideint},
{v = 12.8, varname = "overscanh", glyph = 0xe994, initvar = function(val,prf){prf.OVERSCANH <- val}, title = "Height %", help = "For screens with overscan, define which percentage of the screen will be filled with actual content", options = [0,100,100], values = 100, selection = AF.req.slideint},
{v = 12.8, varname = "overscanx", glyph = 0xe994, initvar = function(val,prf){prf.OVERSCANX <- val}, title = "Shift X %", help = "For screens with overscan, screen will be shifted by the percentage", options = [-100,100,0], values = 0, selection = AF.req.slideint},
{v = 12.8, varname = "overscany", glyph = 0xe994, initvar = function(val,prf){prf.OVERSCANY <- val}, title = "Shift Y %", help = "For screens with overscan, screen will be shifted by the percentage", options = [-100,100,0], values = 0, selection = AF.req.slideint},
{v = 0.0, varname = "", glyph = -1, title = "Effects", selection = AF.req.liner},
{v = 7.2, varname = "lowspecmode", glyph = 0xe994, initvar = function(val,prf){prf.LOWSPECMODE <- val}, title = "Low Spec mode", help = "Reduce most visual effects to boost speed on lower spec systems" , options = ["Yes","No"], values = [true,false], selection = 1, picsel=["lslowspec"+AF.prefs.imgext,"lsdefault"+AF.prefs.imgext], pic = "lslowspec1"+AF.prefs.imgext},
{v = 7.2, varname = "datashadowsmooth", glyph = 0xe994, initvar = function(val,prf){prf.DATASHADOWSMOOTH <- val}, title = "Smooth shadow", help = "Enable smooth shadow under game title and data in the GUI" , options = ["Yes","No"], values = [true,false], selection = 0, picsel=["lsdefault"+AF.prefs.imgext,"lsnodrop"+AF.prefs.imgext], pic = "lsdrop"+AF.prefs.imgext},
{v = 7.2, varname = "snapglow", glyph = 0xe994, initvar = function(val,prf){prf.SNAPGLOW <- val}, title = "Glow effect", help = "Add a glowing halo around the selected game thumbnail" , options = ["Yes","No"], values = [true,false], selection = 0, picsel=["lsdefault"+AF.prefs.imgext,"lsnoglow"+AF.prefs.imgext],pic = "lsglow"+AF.prefs.imgext},
{v = 7.2, varname = "snapgradient", glyph = 0xe994, initvar = function(val,prf){prf.SNAPGRADIENT <- val}, title = "Thumb gradient", help = "Blurs the artwork behind the game logo so it's more readable" , options = ["Yes","No"], values = [true,false], selection = 0, picsel=["lsdefault"+AF.prefs.imgext,"lsgradient"+AF.prefs.imgext],pic = "lsgradient1"+AF.prefs.imgext},
])


menucounter ++
AF.prefs.l0.push({ label = "MULTIPLE MONITOR", glyph = 0xeaf8, description = "Configure the appearence of a second monitor"})
AF.prefs.l1.push([
{v = 0.0, varname = "", glyph = -1, title = "Video Effects", selection = AF.req.liner},
{v = 13.7, varname = "multimon", glyph = 0xeaf8, initvar = function(val,prf){prf.MULTIMON <- val}, title = "Enable multiple monitor", help = "Enable Arcadeflow multiple monitor suport", options = ["Yes", "No"], values =[true,false], selection = 1},
{v = 13.7, varname = "monitornumber", glyph = 0xeaf9, initvar = function(val,prf){prf.MONITORNUMBER <- val}, title = "Monitor identifier", help = "Select the identification number for the external monitor", options = ["Monitor 1", "Monitor 2","Monitor 3"], values = [1,2,3], selection = 0},
{v = 13.7, varname = "monitoraspect", glyph = 0xea57, initvar = function(val,prf){prf.MONITORASPECT <- val}, title = "Correct aspect ratio", help = "Select if the image on the second monitor should be stretched or not", options = ["Yes","No"], values =[true,false], selection = 0}
{v = 13.7, varname = "monitormedia1", glyph = 0xe915, initvar = function(val,prf){prf.MONITORMEDIA1 <- val}, title = "Main media source", help = "Select the artwork source to be used on secondary monitor", options = ["marquee","logo"], values =["marquee","wheel"], selection = 0}
{v = 13.7, varname = "monitormedia2", glyph = 0xe915, initvar = function(val,prf){prf.MONITORMEDIA2 <- val}, title = "Alternate media source", help = "Select the artwork source to be used on secondary monitor in case first one is not present", options = ["marquee","logo"], values =["marquee","wheel"], selection = 1}
])


menucounter++
AF.prefs.l0.push({label = "", glyph = -1, description = ""})
AF.prefs.l1.push([])


menucounter ++
sorter.rawset("scrape", menucounter)
AF.prefs.l0.push({ label = "SCRAPE AND METADATA", glyph = 0xea80, description = "You can use Arcadeflow internal scraper to get metadata and media for your games, or you can import XML data in EmulationStation format"})
AF.prefs.l1.push([
{v = 0.0, varname = "", glyph = -1, title = "SCRAPING", selection = AF.req.liner},
{v = 10.0, varname = "scraperomlist", glyph = 0xe9c2, initvar = function(val,prf){prf.SCRAPEROMLIST <- val}, title = "Scrape current romlist", help = "Arcadeflow will scrape your current romlist metadata and media, based on your options" , options = "", values = function(){local tempprf = generateprefstable();scraperomlist2(tempprf,tempprf.MEDIASCRAPE,false)},selection = AF.req.executef},
{v = 10.1, varname = "scrapegame", glyph = 0xe9c2, initvar = function(val,prf){prf.SCRAPEGAME <- val}, title = "Scrape selected game", help = "Arcadeflow will scrape only metadata and media for current game" , options = "", values = function(){local tempprf = generateprefstable();scraperomlist2(tempprf,tempprf.MEDIASCRAPE,true)},selection = AF.req.executef},
{v = 10.3, varname = "nocrc", glyph = 0xea0c, initvar = function(val,prf){prf.NOCRC <- val}, title = "Enable CRC check", help = "You can enable rom CRC matching (slower) or just name matching (faster)" , options = ["Yes","No"], values = [false,true],selection = 0},
{v = 10.1, varname = "romscrape", glyph = 0xe9c4, initvar = function(val,prf){prf.ROMSCRAPE <- val}, title = "Rom Scrape Options", help = "You can decide if you want to scrape all roms, only roms with no scrape data or roms with data that don't pefectly match" , options = ["All roms","Skip CRC matched", "Skip name matched","Missing only"], values= ["ALL_ROMS","SKIP_CRC","SKIP_NAME","MISSING_ROMS"],selection = 1},
{v = 12.0, varname = "errorscrape", glyph = 0xe9c4, initvar = function(val,prf){prf.ERRORSCRAPE <- val}, title = "Scrape error roms", help = "When scraping you can include or exclude roms that gave an error in the previous scraping" , options = ["Yes","No"], values= [true,false],selection = 1},
{v = 10.0, varname = "mediascrape", glyph = 0xe90d, initvar = function(val,prf){prf.MEDIASCRAPE <- val}, title = "Media Scrape Options", help = "You can decide if you want to scrape all media, overwriting existing one, or only missing media. You can also disable media scraping" , options = ["Overwrite media", "Only missing","No media scrape"], values= ["ALL_MEDIA","MISSING_MEDIA","NO_MEDIA"],selection = 1},
{v = 10.0, varname = "regionprefs", glyph = 0xe9ca, initvar = function(val,prf){prf.REGIONPREFS <- val}, title = "Region Priority", help = "Sort the regions used to scrape multi-region media and metadata in order of preference" , options = function(){return(AF.scrape.regiontable)}, values = sortstring(5), selection = AF.req.menusort},
{v = 10.0, varname = "resetregions", glyph = 0xe965, initvar = function(val,prf){prf.RESETREGIONS <- val}, title = "Reset Region Table", help = "Reset sorting and selection of Region entries" , options = "", values = function(){AF.prefs.l1[sorter.scrape][7].values = sortstring(6)}, selection = AF.req.executef},
{v = 0.0, varname = "", glyph = -1, title = "SCREENSCRAPER", selection = AF.req.liner},
{v = 10.0, varname = "ss_username", glyph = 0xe971, initvar = function(val,prf){prf.SS_USERNAME <- val}, title = "SS Username", help = "Enter your screenscraper.fr username", options = "", values = "", selection = AF.req.textentr},
{v = 10.0, varname = "ss_password", glyph = 0xe98d, initvar = function(val,prf){prf.SS_PASSWORD <- val}, title = "SS Password", help = "Enter your screenscraper.fr password", options = "", values = "", selection = AF.req.textentr},
{v = 0.0, varname = "", glyph = -1, title = "MAME DATA FILES", selection = AF.req.liner},
{v = 12.0, varname = "dat_path", glyph = 0xe930, initvar = function(val,prf){prf.DAT_PATH <- val}, title = "History.dat", help = "History.dat location.", options = "", values = "", selection = AF.req.filereqs},
{v = 12.0, varname = "index_clones", glyph = 0xe922, initvar = function(val,prf){prf.INDEX_CLONES <- val}, title = "Index clones", help = "Set whether entries for clones should be included in the index. Enabling this will make the index significantly larger" , options = ["Yes","No"], values = [true,false], selection = 0},
{v = 12.0, varname = "generate1", glyph = 0xea1c, initvar = function(val,prf){prf.GENERATE1 <- val}, title = "Generate History index", help = "Generate the history.dat index now (this can take some time)", options = "" , values = function(){local tempprf = generateprefstable(); af_generate_index(tempprf);fe.signal("back");fe.signal("back")}, selection = AF.req.executef},
//{v = 12.0, varname = "dat_command_path", glyph = 0xe930, initvar = function(val,prf){prf.DAT_COMMAND_PATH <- val}, title = "Command.dat", help = "Command.dat location.", options = "", values = "", selection = AF.req.filereqs},
//{v = 12.0, varname = "generate2", glyph = 0xea1c, initvar = function(val,prf){prf.GENERATE2 <- val}, title = "Generate Command index", help = "Generate the command.dat index now (this can take some time)", options = "" , values = function(){local tempprf = generateprefstable(); af_generate_command_index(tempprf);fe.signal("back");fe.signal("back")}, selection = AF.req.executef},
{v = 12.0, varname = "ini_bestgames_path", glyph = 0xe930, initvar = function(val,prf){prf.INI_BESTGAMES_PATH <- val}, title = "Bestgames.ini", help = "Bestgames.ini location for MAME.", options = "", values = "", selection = AF.req.filereqs},
{v = 0.0, varname = "", glyph = -1, title = "ES XML IMPORT", selection = AF.req.liner},
{v = 9.7, varname = "importxml", glyph = 0xe92e, initvar = function(val,prf){prf.IMPORTXML <- val}, title = "Import XML data for all romlists", help = "If you specify a RetroPie xml path into emulator import_extras field you can build the romlist based on those data" , options = "", values = function(){local tempprf = generateprefstable();XMLtoAM2(tempprf,false);fe.signal("back");fe.signal("back");fe.set_display(fe.list.display_index)},selection = AF.req.executef},
{v = 9.8, varname = "import1xml", glyph = 0xeaf4, initvar = function(val,prf){prf.IMPORT1XML <- val}, title = "Import XML data for current romlists", help = "If you specify a RetroPie xml path into emulator import_extras field you can build the romlist based on those data" , options = "", values = function(){local tempprf = generateprefstable();XMLtoAM2(tempprf,true);fe.signal("back");fe.signal("back");fe.set_display(fe.list.display_index)},selection = AF.req.executef},
{v = 9.8, varname = "usegenreid", glyph = 0xe937, initvar = function(val,prf){prf.USEGENREID <- val}, title = "Prefer genreid categories", help = "If GenreID is specified in your games list, use that instead of usual categories" , options = ["Yes", "No"], values= [true,false],selection = 0},
{v = 9.8, varname = "onlyavailable", glyph = 0xe912, initvar = function(val,prf){prf.ONLYAVAILABLE <- val}, title = "Import only available roms", help = "Import entrief from the games list only if the rom file is actually available" , options = ["Yes", "No"], values= [true,false],selection = 0},
])

menucounter ++
AF.prefs.l0.push({ label = "ROMLIST MANAGEMENT", glyph = 0xea80, description = "Manage romlists and collections"})
AF.prefs.l1.push([
{v = 0.0, varname = "", glyph = -1, title = "ROMLISTS", selection = AF.req.liner},
{v = 12.0, varname = "refreshromlist", glyph = 0xe982, initvar = function(val,prf){prf.REFRESHROMLIST <- val}, title = "Refresh current romlist", help = "Refresh the romlist with added/removed roms, won't reset current data" , options = "", values = function(){local tempprf = generateprefstable();refreshselectedromlists(tempprf);fe.signal("back");fe.signal("back");fe.set_display(fe.list.display_index)},selection = AF.req.executef},
{v = 14.7, varname = "resetdatabase", glyph = 0xe97c, initvar = function(val,prf){prf.RESETDATABASE <- val}, title = "Erase romlist database", help = "Doesn't rescan the romlist, bur erases all game database information" , options = "", values = function(){local tempprf = generateprefstable();eraseselecteddatabase(tempprf);fe.signal("back");fe.signal("back");fe.set_display(fe.list.display_index)},selection = AF.req.executef},
{v = 12.0, varname = "cleanromlist", glyph = 0xe97c, initvar = function(val,prf){prf.CLEANROMIST <- val}, title = "Reset current romlist", help = "Rescan the romlist erasing and regenerating all romlist data" , options = "", values = function(){local tempprf = generateprefstable();resetselectedromlists(tempprf);fe.signal("back");fe.signal("back");fe.set_display(fe.list.display_index)},selection = AF.req.executef},
{v = 12.3, varname = "resetlastplayed", glyph = 0xe97c, initvar = function(val,prf){prf.RESETLASTPLAYED <- val}, title = "Reset last played", help = "Remove all last played data from the current romlist" , options = "", values = function(){local tempprf = resetlastplayed()},selection = AF.req.executef},
{v = 0.0, varname = "", glyph = -1, title = "MASTER ROMLIST", selection = AF.req.liner},
{v = 13.9, varname = "masterlist", glyph = 0xe95c, initvar = function(val,prf){prf.MASTERLIST <- val}, title = "Enable Master Romlist", help = "Turn this on and set master romlist path so AF can manage it" , options = ["Yes", "No"], values = [true, false],selection = 1},
{v = 13.9, varname = "masterpath", glyph = 0xe930, initvar = function(val,prf){prf.MASTERPATH <- val}, title = "Master Romlist Path", help = "If you are using a master romlist, locate it here to enable AF master romlist optimisation", options = "", values = "", selection = AF.req.filereqs},
{v = 0.0, varname = "", glyph = -1, title = "ROMLIST EXPORT", selection = AF.req.liner},
{v = 12.0, varname = "buildxml", glyph = 0xe961, initvar = function(val,prf){prf.BUILDXML <- val}, title = "Export to gamelist xml", help = "You can export your romlist in the XML format used by EmulationStation" , options = "", values = function(){buildgamelistxml()},selection = AF.req.executef},
{v = 0.0, varname = "", glyph = -1, title = "COLLECTIONS", selection = AF.req.liner},
{v = 12.1, varname = "allgames", glyph = 0xe95c, initvar = function(val,prf){prf.ALLGAMES <- val}, title = "Enable all games collections", help = "If enabled, Arcadeflow will create All Games compilations" , options = ["Yes", "No"], values = [true, false],selection = 1},
{v = 12.0, varname = "updateallgames", glyph = 0xe95c, initvar = function(val,prf){prf.UPDATEALLGAMES <- val}, title = "Update all games collections", help = "Force the update of all games collections, use when you remove displays" , options = "", values = function(){local tempprf = generateprefstable();updateallgamescollections(tempprf);fe.signal("back");fe.signal("back");fe.set_display(fe.list.display_index)},selection = AF.req.executef},
{v = 0.0, varname = "", glyph = -1, title = "DANGER ZONE", selection = AF.req.liner},
{v = 14.7, varname = "cleandatabase", glyph = 0xe97c, initvar = function(val,prf){prf.CLEANDATABASE <- val}, title = "Cleanup database", help = "Rescans all the romlists adding/removing roms, then purges the database to remove unused entry" , options = "", values = function(){local tempprf = generateprefstable();cleandatabase(tempprf);fe.signal("back");fe.signal("back");fe.set_display(fe.list.display_index)},selection = AF.req.executef},
{v = 14.1, varname = "enablehidden", glyph = 0xe997, initvar = function(val,prf){prf.ENABLEHIDDEN <- val}, title = "Enable game hiding", help = "Enable or disable the options to hide games using tags menu" , options = ["Yes","No"], values = [true,false], selection = 0},
{v = 10.9, varname = "enabledelete", glyph = 0xe9ac, initvar = function(val,prf){prf.ENABLEDELETE <- val}, title = "Enable rom delete", help = "Enable or disable the options to delete a rom" , options = ["Yes","No"], values = [true,false], selection = 1},
])


menucounter ++
AF.prefs.l0.push({ label = "RETROARCH INTEGRATION", glyph = 0xeafa, description = "Assign retroarch cores to emulators"})
AF.prefs.l1.push([
	{v = 14.6, varname = "raenabled", glyph = 0xeafa, initvar = function(val,prf){prf.RAENABLED <- val}, title = "Enable RetroArch integration", help = "Enable or disable the integration of RetroArch" , options = ["Yes","No"], values = [true,false], selection = 1},
	{v = 14.6, varname = "raexepath", glyph = 0xe930, initvar = function(val,prf){prf.RAEXEPATH <- val}, title = "Custom executable path", help = "Enter the path to RetroArch executable if not installed in your OS default location", options = "", values = "", selection = AF.req.textentr},
	{v = 14.6, varname = "racorepath", glyph = 0xe930, initvar = function(val,prf){prf.RACOREPATH <- val}, title = "Custom Core folder", help = "Enter a custom folder for RA cores if not using standard locations", options = "", values = "", selection = AF.req.textentr},
	{v = 14.7, varname = "rainfopath", glyph = 0xe930, initvar = function(val,prf){prf.RAINFOPATH <- val}, title = "Custom Info folder", help = "Enter a custom folder for RA info files if not using standard locations", options = "", values = "", selection = AF.req.textentr},
])

menucounter ++
sorter.rawset("mf", menucounter)
AF.prefs.l0.push({ label = "SEARCH & FILTERS", glyph = 0xe986, description = "Configure the search page and multifilter options"})
AF.prefs.l1.push([
{v = 0.0, varname = "", glyph = -1, title = "Search", selection = AF.req.liner},
{v = 7.9, varname = "livesearch", glyph = 0xe985, initvar = function(val,prf){prf.LIVESEARCH <- val}, title = "Immediate search", help = "Live update results while searching" , options = ["Yes","No"], values = [true,false], selection = 0},
{v = 8.0, varname = "keylayout", glyph = 0xe955, initvar = function(val,prf){prf.KEYLAYOUT <- val}, title = "Keyboard layout", help = "Select the keyboard layout for on-screen keyboard" , options = ["ABCDEF","QWERTY","AZERTY"], values = ["ABCDEF","QWERTY","AZERTY"], selection = 0},
{v = 0.0, varname = "", glyph = -1, title = "Multifilter", selection = AF.req.liner},
{v = 7.9, varname = "savemfz", glyph = 0xeaed, initvar = function(val,prf){prf.SAVEMFZ <- val}, title = "Save Multifilter sessions", help = "Save the Multifilter of each display when exiting Arcadeflow or changing list" , options = ["Yes","No"], values = [true,false], selection = 0},
{v = 12.8, varname = "mfzvector", glyph = 0xeaed, initvar = function(val,prf){prf.MFZVECTOR <- val}, title = "Customize Multifilter Menu", help = "Sort and select Multifilter Menu entries: Left/Right to move items up and down, Select to enable/disable item" , options = function(){return(mfztablenames(multifilterz.l0))}, values = sortstring(16), selection = AF.req.menusort},
{v = 12.8, varname = "mfzvectorreset", glyph = 0xe965, initvar = function(val,prf){prf.MFZVECTORRESET <- val}, title = "Reset Multifilter Menu", help = "Reset sorting and selection of Multifilter Menu entries" , options = "", values = function(){AF.prefs.l1[sorter.mf][5].values = sortstring(16)}, selection = AF.req.executef},
])


menucounter++
AF.prefs.l0.push({label = "", glyph = -1, description = ""})
AF.prefs.l1.push([])


menucounter ++
AF.prefs.l0.push({ label = "UPDATES", glyph = 0xe91c, description = "Configure update notifications"})
AF.prefs.l1.push([
{v = 8.0, varname = "updatecheck", glyph = 0xe91c, initvar = function(val,prf){prf.UPDATECHECK <- val}, title = "Automatically check for updates", help = "Will check for updates at each AF launch, if you dismiss one update you won't be notified until the next one" options = ["Yes","No"], values = [true,false], selection = 0},
{v = 8.0, varname = "autoinstall", glyph = 0xe91c, initvar = function(val,prf){prf.AUTOINSTALL <- val}, title = "Install update after download", help = "Arcadeflow allows you to chose if you just want to download updates, or if you want to install them directly" options = ["Install after download","Download only"], values = [true,false], selection = 1},
])

menucounter ++
AF.prefs.l0.push({ label = "SAVE & LOAD", glyph = 0xe962, description = "Save or reload options configurations"})
AF.prefs.l1.push([
{v = 9.9, varname = "saveprefs", glyph = 0xe9c5, initvar = function(val,prf){prf.SAVEPREFS <- val}, title = "Save current options", help = "Save the current options configuration in a custom named file", options = "" , values = function(){savecurrentoptions()}, selection = AF.req.exenoret},
{v = 9.9, varname = "loadprefs", glyph = 0xe9c6, initvar = function(val,prf){prf.LOADPREFS <- val}, title = "Load options from external file", help = "Restore AF options from a previously saved file", options = "" , values = function(){ restoreoptions()}, selection = AF.req.exenoret},
])

menucounter ++
AF.prefs.l0.push({ label = "DEBUG", glyph = 0xe998, description = "This section is for debug purposes only"})
AF.prefs.l1.push([
{v = 7.2, varname = "fpson", glyph = 0xe998, initvar = function(val,prf){prf.FPSON <- val}, title = "FPS counter", help = "DBGON FPS COUNTER" options = ["Yes","No"], values = [true,false], selection = 1},
{v = 7.2, varname = "debugmode", glyph = 0xe998, initvar = function(val,prf){prf.DEBUGMODE <- val}, title = "DEBUG mode", help = "Enter DBGON mode, increased output logging" options = ["Yes","No"], values = [true,false], selection = 1},
{v = 7.2, varname = "oldoptions", glyph = 0xe998, initvar = function(val,prf){prf.OLDOPTIONS <- val}, title = "AM options page", help = "Shows the default Attract-Mode options page" options = "", values = function(){prf.OLDOPTIONSPAGE = true; AF.prefs.getout = true; fe.signal("layout_options");fe.signal("reload")}, selection = AF.req.executef},
{v = 9.5, varname = "generatereadme", glyph = 0xe998, initvar = function(val,prf){prf.GENERATEREADME <- val}, title = "Generate readme file", help = "For developer use only..." options = "", values = function(){ AF.prefs.getout = true;savereadme()}, selection = AF.req.executef},
{v = 7.2, varname = "resetlayout", glyph = 0xe998, initvar = function(val,prf){prf.RESETLAYOUT <- val}, title = "Reset all options", help = "Restore default settings for all layout options, erase sorting options, language options and thumbnail options" options = "", values = function(){ AF.prefs.getout = true;reset_layout()}, selection = AF.req.executef},
])

function reset_layout() {
	try { remove (AF.folder + "pref_savedlanguage.txt") } catch (err) {}
	try { remove (AF.folder + "pref_sortorder.txt") } catch (err) {}
	try { remove (AF.folder + "pref_thumbtype.txt") } catch (err) {}
	try { remove (AF.folder + "pref_layoutoptions.txt") } catch (err) {}
	try { remove (AF.folder + "pref_update.txt") } catch (err) {}
	try { remove (AF.folder + "pref_checkdate.txt") } catch (err) {}
	try { remove (AF.folder + "scrapelog.txt") } catch (err) {}
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
		AF.prefs.l1[i][j].title = (isnew ? "❗ " : "") + ltxt(AF.prefs.l1[i][j].title,AF.LNG) + (isnew ? " ❗" : "")
		if ((AF.prefs.l1[i][j].selection != AF.req.liner)) AF.prefs.l1[i][j].help = ltxt(AF.prefs.l1[i][j].help,AF.LNG)
		if ((AF.prefs.l1[i][j].selection != AF.req.menusort) && (AF.prefs.l1[i][j].selection != AF.req.liner)) AF.prefs.l1[i][j].options = ltxtarray(AF.prefs.l1[i][j].options,AF.LNG)
		if (isnew) isnewparent = true
	}
	AF.prefs.l0[i].label = (isnewparent ? "❗ " : "") + ltxt(AF.prefs.l0[i].label,AF.LNG) + (isnewparent ? " ❗" : "")
	AF.prefs.l0[i].description = ltxt(AF.prefs.l0[i].description,AF.LNG)
	AF.prefs.a0.push (AF.prefs.l0[i].label)
	AF.prefs.gl0.push (AF.prefs.l0[i].glyph)
}

// GENERATE ABOUT FILE
function abouttext(){
	local about = []
	for (local i = 0 ; i < AF.prefs.l0.len() ; i++){
		if (AF.prefs.l0[i].label != ""){
			about.push ("#### "+AF.prefs.l0[i].label+"\n")
			about.push (AF.prefs.l0[i].description+"\n")
			about.push("\n")
			for (local j = 0 ; j < AF.prefs.l1[i].len() ; j++) {
				try {about.push ("- '" + AF.prefs.l1[i][j].title + "'" + " : " + AF.prefs.l1[i][j].help +"\n")}
				catch (err){
					about.push ("- " + AF.prefs.l1[i][j].title + "\n")
				}
			}
			about.push ("\n")
		}
	}
	return (about)
}

function historytext(){
	local scanver = AF.vernum - 1
	local verfile = null
	local history = []
	while (scanver > 10) {
		if (file_exist(AF.folder+"history/"+scanver+".txt")) {
			verfile = ReadTextFile (AF.folder+"history/"+scanver+".txt")
			history.push ("*v"+verfile.read_line()+"*"+"\n\n")
			while (!verfile.eos()){
				history.push ("- "+verfile.read_line()+"\n")
			}
			history.push ("\n")
		}
		scanver --
	}
	verfile = ReadTextFile (AF.folder+"history/10.txt")
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

	infile = ReadTextFile (AF.folder+"history/00_intro.txt")
	while (!infile.eos()) readme.push (infile.read_line()+"\n")
	readme.push ("\n")
	readme.push ("## What's new in v "+AF.version+" #"+"\n")
	readme.push ("\n")

	infile = ReadTextFile (AF.folder+"history/"+AF.vernum+".txt")
	infile.read_line()
	while (!infile.eos()) readme.push ("- "+infile.read_line()+"\n")
	readme.push ("\n")

	infile = ReadTextFile (AF.folder+"history/00_presentation.txt")
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
	aboutfile.close_file()
}

function saveabout(){
   local aboutpath = fe.path_expand( AF.folder + "about.txt")
   local aboutfile = WriteTextFile (aboutpath)
   local about = abouttext()
	for (local i = 0 ; i < about.len() ; i++){
		aboutfile.write_line(about[i]+"\n")
	}
	aboutfile.close_file()
}

function printabout(){
	   local about = abouttext()
	for (local i = 0 ; i < about.len() ; i++){
		print(about[i]+"\n")
	}
}

// Reads data from the preferences structures and builds the preferences variable table
// This is the table with the values used in the layout like prf.BOXARTMODE = true etc
function generateprefstable(){
   local prf = {}
   for (local i = 0 ; i < AF.prefs.l0.len() ; i++){
      for (local j = 0 ; j < AF.prefs.l1[i].len() ; j++){
         local tempdat = AF.prefs.l1[i][j]
         if (tempdat.selection != AF.req.liner){
				if (tempdat.selection >=0) tempdat.initvar(((tempdat.values != "") ? tempdat.values[tempdat.selection] : tempdat.options[tempdat.selection]),prf)
   	      else if ((tempdat.selection != -2) && (tempdat.selection != -5)){//-2 is the function execution
					if (tempdat.selection == AF.req.slideint) tempdat.values = tempdat.values.tointeger()
					tempdat.initvar(tempdat.values,prf)
				}
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
         if (tempdat.selection != AF.req.liner){
	         if (tempdat.selection >=0) tempdat.initvar(tempdat.selection,prf)
   	      else if ((tempdat.selection != -2) && (tempdat.selection != -5)) {
					if (tempdat.selection == AF.req.slideint) tempdat.values = tempdat.values.tointeger()
					tempdat.initvar(tempdat.values,prf)
				}
			}
		}
   }
   return prf
}

// Input output functions should save and load the SELECTION value, not the actual value.
// Therefore saveprefdata must be called on a table generated with generateselectiontable()
function saveprefdata(prf,target){
   local prfpath = fe.path_expand( AF.folder+"pref_layoutoptions.txt")
   local ss_prfpath = fe.path_expand( AF.folder+"ss_login.txt")
   if (target != null) prfpath = target
	local prffile = WriteTextFile (prfpath)
	local ss_prffile = WriteTextFile (ss_prfpath)
	prffile.write_line (AF.version+"\n")
   foreach (label, val in prf){
      if ((label != "SS_USERNAME") && (label != "SS_PASSWORD")) prffile.write_line ("|" + label + "|" + val+"|\n")
		else ss_prffile.write_line ("|" + label + "|" + val+"|\n")
   }
	prffile.close_file()
	ss_prffile.close_file()
}

// readprefdata() reads values of a selection and puts them in the preferences structure.
// To use this values in the layout preferences variable must be recreated using generateprefstable()
function readprefdata(target){
   local prfpath = fe.path_expand( AF.folder+"pref_layoutoptions.txt")
   local ss_prfpath = fe.path_expand( AF.folder+"ss_login.txt")
   if (target != null) prfpath = target
	local prffile = ReadTextFile (prfpath)
	local ss_prffile = ReadTextFile (ss_prfpath)
   local ptable = {}
	local version = ""
	try {	version = prffile.read_line() } catch (err) {
		z_splash_message ("Error reading prefs file, resetting to default")
		return false
	}

	local warnmessage = ""
	while (!prffile.eos()){
		local templine = prffile.read_line()
		local z = split (templine,"|")

		for (local i = 0 ; i < AF.prefs.l0.len() ; i++){
			for (local j = 0 ; j < AF.prefs.l1[i].len() ; j++){
				local tempdat = AF.prefs.l1[i][j] //Instancing!

				if ((tempdat.varname.toupper() == z[0]) && ( (tempdat.varname.toupper() != "SS_USERNAME") && (tempdat.varname.toupper() != "SS_PASSWORD") )) {
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
	while (!ss_prffile.eos()){
		local ss_templine = ss_prffile.read_line()
		local ss_z = split (ss_templine,"|")
		for (local i = 0 ; i < AF.prefs.l0.len() ; i++){
			for (local j = 0 ; j < AF.prefs.l1[i].len() ; j++){
				local ss_tempdat = AF.prefs.l1[i][j] //Instancing!

				if ((ss_tempdat.varname.toupper() == ss_z[0]) && ( (ss_tempdat.varname.toupper() == "SS_USERNAME") || (ss_tempdat.varname.toupper() == "SS_PASSWORD") )) {
						if (ss_tempdat.selection >= 0) ss_tempdat.selection = ss_z[1].tointeger()
						else if (ss_z.len() == 1) ss_tempdat.values = ""
						else ss_tempdat.values = ss_z[1]
				}
			}
		}
	}

	if (warnmessage != "") {
		z_splash_message ("Reset prefs:\n\n" + warnmessage)
		return false
	}
	return true
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
	datefile.close_file()
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

prf.OLDOPTIONSPAGE <- false

prf.CUSTOMLOGO <- (prf.SPLASHLOGOFILE != "")
if (!prf.CUSTOMLOGO) prf.SPLASHLOGOFILE = "pics/logo/aflogox.png"

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
AF.LNG = prf.LAYOUTLANGUAGE
savelanguage(AF.LNG)

// Check conflicts in custom buttons
function check_buttons(){
	local buttonarray = [prf.SWITCHMODEBUTTON , prf.UTILITYMENUBUTTON, prf.OVERMENUBUTTON, prf.HISTORYBUTTON, prf.SEARCHBUTTON,prf.CATEGORYBUTTON,prf.MULTIFILTERBUTTON,prf.DELETEBUTTON,prf.VOLUMEBUTTON,prf.FAVBUTTON]
	local conflict = false
	for (local i = 0 ; i < buttonarray.len() ; i++){
		if (buttonarray[i] != "none") {
			for (local j = 0 ; j < buttonarray.len() ; j++){
				if ((j != i) && (buttonarray[j] == buttonarray[i])) conflict = true
			}
		}
	}
	if (conflict) 	z_splash_message ("WARNING: Conflict in Arcadeflow button assignment")
}

check_buttons()

try {prf.AMTIMER = prf.AMTIMER.tointeger()}
catch (err) {prf.AMTIMER = 120}

try {prf.AMCHANGETIMER = prf.AMCHANGETIMER.tointeger()}
catch (err) {prf.AMCHANGETIMER = 10}

local DISPLAYTABLE = {}
try { DISPLAYTABLE = loadtablefromfile("pref_thumbtype.txt",false) } catch (err) {}
if (DISPLAYTABLE == null) DISPLAYTABLE = {}

local SORTTABLE = {}
try { SORTTABLE = loadtablefromfile("pref_sortorder.txt",false) } catch (err) {}
if (SORTTABLE == null) SORTTABLE = {}
if (prf.ALLGAMES) {
	SORTTABLE.rawset("AF Favourites_All",[91,true])
	SORTTABLE.rawset("AF Last Played_All",[90,true])
}

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

/// HUECYCLE ///
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

try {
	huecycle.minhue = prf.HCHUESTART.tointeger()
	if (huecycle.minhue < 0) huecycle.minhue = 0
	if (huecycle.minhue > 358) huecycle.minhue = 358
}catch(err){}

try {
	huecycle.maxhue = prf.HCHUESTOP.tointeger()
	if (huecycle.maxhue < 1) huecycle.maxhue = 1
	if (huecycle.maxhue > 359) huecycle.maxhue = 359
}catch(err){}

if (huecycle.maxhue <= huecycle.minhue){
	huecycle.minhue = 0
	huecycle.maxhue = 359
}

if (prf.LOGOSONLY) {
	prf.FADEVIDEOTITLE = true
	prf.CROPSNAPS = false
	prf.BOXARTMODE = false
}

try{prf.MONITORNUMBER = prf.MONITORNUMBER.tointeger()} catch(err){
	print ("Error on monitor number\n")
	prf.MONITORNUMBER = 0
}


// End prf setup


local orderdatalabel = {}
orderdatalabel [Info.System] <- split(ltxt("_System",AF.LNG),"_")[0]
orderdatalabel [Info.Name] <- split(ltxt("_Name",AF.LNG),"_")[0]
orderdatalabel [Info.Title] <- split(ltxt("_Title",AF.LNG),"_")[0]
orderdatalabel [Info.Emulator] <- split(ltxt("_Emul",AF.LNG),"_")[0]
orderdatalabel [Info.CloneOf] <- split(ltxt("_Clone",AF.LNG),"_")[0]
orderdatalabel [Info.Year] <- split(ltxt("_Year",AF.LNG),"_")[0]
orderdatalabel [Info.Manufacturer] <- split(ltxt("_Manuf",AF.LNG),"_")[0]
orderdatalabel [Info.Category] <- split(ltxt("_Categ",AF.LNG),"_")[0]
orderdatalabel [Info.Players] <- split(ltxt("_Players",AF.LNG),"_")[0]
orderdatalabel [Info.Rotation] <- split(ltxt("_Rot",AF.LNG),"_")[0]
orderdatalabel [Info.Control] <- split(ltxt("_Cntrl",AF.LNG),"_")[0]
orderdatalabel [Info.Status] <- split(ltxt("_Status",AF.LNG),"_")[0]
orderdatalabel [Info.DisplayCount] <- split(ltxt("_DispCt",AF.LNG),"_")[0]
orderdatalabel [Info.DisplayType] <- split(ltxt("_DispTp",AF.LNG),"_")[0]
orderdatalabel [Info.AltRomname] <- split(ltxt("_AltRomn",AF.LNG),"_")[0]
orderdatalabel [Info.AltTitle] <- split(ltxt("_AltTitle",AF.LNG),"_")[0]
orderdatalabel [Info.Extra] <- split(ltxt("_Extra",AF.LNG),"_")[0]
orderdatalabel [Info.Favourite] <- split(ltxt("_Fav",AF.LNG),"_")[0]
orderdatalabel [Info.Tags] <- split(ltxt("_Tags",AF.LNG),"_")[0]
orderdatalabel [Info.PlayedCount] <- split(ltxt("_PlCount",AF.LNG),"_")[0]
orderdatalabel [Info.PlayedTime] <- split(ltxt("_PlTime",AF.LNG),"_")[0]
orderdatalabel [Info.FileIsAvailable] <- split(ltxt("_Avail",AF.LNG),"_")[0]

orderdatalabel [z_info.z_rundate] <- split(ltxt("_Run",AF.LNG),"_")[0]
orderdatalabel [z_info.z_favdate] <- split(ltxt("_FavDt",AF.LNG),"_")[0]
orderdatalabel [z_info.z_rating] <- split(ltxt("_Rate",AF.LNG),"_")[0]
orderdatalabel [z_info.z_series] <- split(ltxt("_Series",AF.LNG),"_")[0]

function readsystemdata(){
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
					logo = AF.uniglyphs[sysinc]
					brand = linearray[9] == "null" ? "" : linearray[9]
					year = linearray[10] == "null" ? "9998" : linearray[10]
					sysname = linearray[11] == "null" ? "" : linearray[11]
					ss_id = linearray[12] == "null" ? null : linearray[12]
					ss_media = linearray[13] == "null" ? null : linearray[13]
					sys_control = linearray[14] == "null" ? "" : linearray[14]
					sys_buttons = linearray[15] == "null" ? "" : linearray[15]

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

local commandtable = dofile (fe.path_expand(AF.folder+"nut_command.nut"))//af_create_command_table()

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
	bgvid_top = null
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
	used = 0
}

local squarizer = true
local squarizertop = false

// Apply color theme
local themeT = {
	themeoverlaycolor = 255 //basic color of overlay
	themeoverlayalpha = 80	// overlay alpha
	themetextcolor = {r=255,g=255,b=255}	// color of main text
	themelettercolor = 255	// color of popup letter
	themehistorytextcolor = 90 // color of history text
	themeshadow = 50 // shadow color
	menushadow = 50 // menu shadow color
	listboxbg = 200 // listbox overlay color
	listboxalpha = 15 //listbox overlay alpha
	listboxselbg = {r=250,g=250,b=250} // listbox selection background
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
	themeT.themetextcolor = {r=255,g=255,b=255}
	themeT.themelettercolor = 255
	themeT.themehistorytextcolor = 90
	themeT.themeshadow = 50
	themeT.menushadow = 50
	themeT.listboxbg = 200
	themeT.listboxalpha = 15
	themeT.listboxselbg = {r=250,g=250,b=250}
	themeT.listboxseltext = 50
	themeT.optionspanelrgb = 100
	themeT.optionspanelalpha = 80
	themeT.mfmrgb = 60
	themeT.mfmalpha = 230
}
if (prf.COLORTHEME == "dark"){
	themeT.themeoverlaycolor = 0
	themeT.themeoverlayalpha = 150
	themeT.themetextcolor =  {r=240,g=240,b=240}
	themeT.themelettercolor = 255
	themeT.themehistorytextcolor = 90
	themeT.themeshadow = 80
	themeT.menushadow = 80
	themeT.listboxbg = 200
	themeT.listboxalpha = 15
	themeT.listboxselbg = {r=225,g=225,b=225}
	themeT.listboxseltext = 50
	themeT.optionspanelrgb = 0
	themeT.optionspanelalpha = 70
	themeT.mfmrgb = 0
	themeT.mfmalpha = 220
}
if (prf.COLORTHEME == "light"){
	themeT.themeoverlaycolor = 255
	themeT.themeoverlayalpha = 190
	themeT.themetextcolor =  {r=90,g=90,b=90}
	themeT.themelettercolor = 255
	themeT.themehistorytextcolor = 90
	themeT.themeshadow = 50
	themeT.menushadow = 25
	themeT.listboxbg = 255
	themeT.listboxalpha = 120
	themeT.listboxselbg = {r=95,g=95,b=95}
	themeT.listboxseltext = 200
	themeT.optionspanelrgb = 128
	themeT.optionspanelalpha = 50
	themeT.mfmrgb = 255
	themeT.mfmalpha = 200
}
if (prf.COLORTHEME == "pop"){
	themeT.themeoverlaycolor = 255
	themeT.themeoverlayalpha = 0
	themeT.themetextcolor =  {r=255,g=255,b=255}
	themeT.themelettercolor = 255
	themeT.themehistorytextcolor = 90
	themeT.themeshadow = 70
	themeT.menushadow = 70
	themeT.listboxbg = 200
	themeT.listboxalpha = 15
	themeT.listboxselbg = {r=250,g=250,b=250}
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

function integer(n){
	return (floor(n+(n>0?0.5:-0.5)))
}

function integerp(n){
	return (floor(n+0.5))
}

function integereven(n){
	local n_round = integerp(n)
	return (n_round + n_round%2.0)
}
/*
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
*/
function hsl2rgb( H,S,L )
{
	local RGB = [0.0,4.0,2.0]
	RGB.apply(function(value){
		return((L + S * ((min(max(absf(((H / 360.0 * 6.0 + value) % 6.0) - 3.0) - 1.0, 0.0), 1.0 )) - 0.5) * (1.0 - absf(2.0 * L - 1.0))))
	})
	local OUT ={
		R = (RGB[0])
		G = (RGB[1])
		B = (RGB[2])
	}
	return (OUT)
}

function applycustomcolor(){
	local colorarray = split(prf.CUSTOMCOLOR," ")
	if (colorarray.len() != 3) return

	foreach(i, item in colorarray){
		try{colorarray[i] = item.tointeger()} catch (err){return}
	}

	local deltacolor = themeT.listboxselbg.r - themeT.themetextcolor.r

	themeT.themetextcolor.r = min(max(0,colorarray[0]),255)
	themeT.themetextcolor.g = min(max(0,colorarray[1]),255)
	themeT.themetextcolor.b = min(max(0,colorarray[2]),255)

	themeT.listboxselbg.r = min(max(0,colorarray[0] - deltacolor),255)
	themeT.listboxselbg.g = min(max(0,colorarray[1] - deltacolor),255)
	themeT.listboxselbg.b = min(max(0,colorarray[2] - deltacolor),255)

}

if (prf.CUSTOMCOLOR != "") applycustomcolor()

// Music
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
	clicksound = fe.add_sound("sounds/mouse3.mp3")
	plingsound = fe.add_sound("sounds/pling1.wav")
	mplinsound = fe.add_sound("sounds/pling2.wav")
	wooshsound = fe.add_sound("sounds/woosh4.mp3")
	mbacksound = fe.add_sound("sounds/woosh5.mp3")
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
	mfskipdown = 0
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

local UI = {
	vertical = false
	rows = prf.HORIZONTALROWS
	cols = 0

	scalerate = 0

	corewidth = 0
	coreheight = 0
	padding_scaler = 1.0/6.0 //multiplier of padding space (normally 1/6 of thumb area)

	blocks = 0
	blocksize = 0
	blocksspace = 0

	padding = 0
	tilewidth = 0
	tileheight = 0
	tilewidth169 = 0
	tilewidth169padded = 0
	widthmix = 0
	tilewidthmix = 0

	verticalshift = 0

	whiteborder = 0

	zoomedblock = 0
	zoomscale = 0
	zoomedwidth = 0
	zoomedheight = 0
	zoomedborder = 0
	zoomedvshift = 0
	zoomedpadding = 0
	zoomedcorewidth = 0
	zoomedcoreheight = 0

	header = {
		h = 0 //content size
		h2 = 0 //spacer size
	}

	footer = {
		h = 0 //content size
		h2 = 0 //spacer size
	}

	footermargin = 0

	space = 0
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
	catch ( err ) { z_splash_message("Wrong syntax in screen resolution");prf.CUSTOMSIZE = "";scr.w = ScreenWidth; scr.h = ScreenHeight }
}

// Screen size and overscan management
local fl = {
	w_os = scr.w
	h_os = scr.h
	surf = null
	surf2 = null
	surf3 = null
	overscan_w = 1.0
	overscan_h = 1.0
	overscan_x = 0.0
	overscan_y = 0.0
	w = 0
	h = 0
	x = 0
	y = 0
}

try {
	fl.overscan_w = prf.OVERSCANW.tointeger()
	if ((fl.overscan_w > 0) && (fl.overscan_w <= 100)){
		fl.overscan_w = fl.overscan_w / 100.0
	}
}catch(err){}

try {
	fl.overscan_h = prf.OVERSCANH.tointeger()
	if ((fl.overscan_h > 0) && (fl.overscan_h <= 100)){
		fl.overscan_h = fl.overscan_h / 100.0
	}
}catch(err){}

try {
	fl.overscan_x = prf.OVERSCANX.tointeger()
	if ((fl.overscan_x >= -100) && (fl.overscan_x <= 100)){
		fl.overscan_x = fl.overscan_x / 100.0
	}
}catch(err){}

try {
	fl.overscan_y = prf.OVERSCANY.tointeger()
	if ((fl.overscan_y >= -100) && (fl.overscan_y <= 100)){
		fl.overscan_y = fl.overscan_y / 100.0
	}
}catch(err){}



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
fl.x = 0.5 * (fl.w_os - fl.w) + fl.w_os * fl.overscan_x
fl.y = 0.5 * (fl.h_os - fl.h) + fl.h_os * fl.overscan_y

function print_variable(variablein,level,name){
	if (level == "") print ("* "+name+" *\n")
	level = level+"   "
	foreach (item, val in variablein){
		print (level+" "+(typeof val)+" "+item+" "+val+"\n")
		if ((typeof val == "table")||(typeof val == "array")) print_variable(val,level,"")
	}
}


/*
fl.surf2 = fe.add_surface (fl.w_os*0.2,fl.h_os*0.2)
fl.surf2.mipmap = 1
fl.surf2.zorder = 100000
*/
if (fl.h_os > fl.w_os) UI.vertical = true
if (UI.vertical) prf.SLIMLINE = false
if (UI.vertical) UI.rows = prf.VERTICALROWS

UI.rows = (prf.LOWRES ? 1 : UI.rows)

fe.layout.width = fl.w_os
fe.layout.height = fl.h_os
fe.layout.preserve_aspect_ratio = true
fe.layout.page_size = UI.rows
fe.layout.font = uifonts.general

prf.PIXELACCURATE <- true


UI.scalerate = (UI.vertical ? fl.w : fl.h)/1200.0

// Changed header spacer from 200 to 220 better centering
UI.header.h = floor (prf.LOWRES ? 260 * UI.scalerate : 200 * UI.scalerate ) // content
UI.header.h2 = floor (prf.LOWRES ? 330 * UI.scalerate : (((UI.rows == 1) && (!prf.SLIMLINE))? 250 * UI.scalerate : (prf.PIXELACCURATE ? 220 : 220) * UI.scalerate)) //spacer

// Changed header spacer from 100 to 90 better centering
UI.footer.h = floor (prf.LOWRES ? 150 * UI.scalerate : 100 * UI.scalerate ) // content
UI.footer.h = UI.footer.h + UI.footer.h%2.0 // even footer
UI.footer.h2 = floor (prf.LOWRES ? 150 * UI.scalerate : (((UI.rows == 1) && (!prf.SLIMLINE)) ? 150 * UI.scalerate : (prf.PIXELACCURATE ? 90 : 90) * UI.scalerate)) //spacer
if (prf.SLIMLINE) UI.footer.h = floor(UI.footer.h * 1.4)

UI.space = fl.h - UI.header.h2 - UI.footer.h2

UI.blocks = 6 * UI.rows + UI.rows + 1
if (prf.SLIMLINE) UI.blocks = 6 * 2 + 2 + 1
UI.blocksize = UI.space * 1.0/UI.blocks

if (prf.PIXELACCURATE) UI.blocksize = 1 * round(UI.blocksize/1.0,1)

UI.coreheight = UI.corewidth = UI.blocksize * 6

UI.padding = UI.blocksize
UI.tilewidth = UI.corewidth + 2 * UI.padding
UI.tileheight = UI.coreheight + 2 * UI.padding

UI.tilewidth169 = UI.coreheight*10/16
UI.tilewidth169padded = UI.tilewidth169 + 2 * UI.padding
UI.widthmix = (prf.FIX169 ? UI.tilewidth169 : UI.corewidth)
UI.tilewidthmix = (prf.FIX169 ? UI.tilewidth169padded : UI.tilewidth)

UI.blocksspace = UI.blocksize * UI.blocks

UI.header.h2 = UI.header.h2 + floor ((UI.space - UI.blocksspace)*0.5)
UI.footer.h2 = UI.footer.h2 + (UI.space-UI.blocksspace) - floor ((UI.space - UI.blocksspace)*0.5)
UI.space = fl.h - UI.header.h2 - UI.footer.h2

UI.verticalshift = UI.coreheight*16.0/480.0
/*
Nominal (for calculation purposes) sizes:
	Tile size: 640 x 640
	Square center size: 480 x 480
	Vertical shift: 16
*/

//calculate number of columns
UI.cols = (1 + 2*(floor (( fl.w/2 + UI.widthmix/2 - UI.padding) / (UI.widthmix + UI.padding))))
// add safeguard tiles
UI.cols += 2

local pagejump = prf.SCROLLAMOUNT * UI.rows*(UI.cols-2)

// carrier sizing in general layout
local carrierT = {
	x = fl.x -(UI.cols * (UI.widthmix + UI.padding) + UI.padding - fl.w) * 0.5,
	y = fl.y + UI.header.h2 + (prf.SLIMLINE ? UI.coreheight * 0.5 : 0 ),
	w = UI.cols * (UI.widthmix + UI.padding) + UI.padding,
	h = UI.rows * UI.coreheight + UI.rows * UI.padding + UI.padding
}

// Changed zoomscale from 1.5 to 1.45 in default zoom
// selector and zooming data


UI.zoomscale = (prf.TILEZOOM == 0 ? 1.0 : (prf.TILEZOOM == 1 ? 1.15 : (UI.rows == 1 ? (UI.vertical ? 1.15 : 1.45) : ((prf.SCROLLERTYPE == "labellist") ? 1.4 : 1.45) )))

UI.whiteborder = 0.15


if (prf.PIXELACCURATE){
	UI.zoomedblock = round(UI.zoomscale * UI.blocksize,1)
	//TEST138
	// this was a line used to have an even block size, but it's
	// not needed because we can round the centercorr.zero
	// UI.zoomedblock = UI.zoomedblock - UI.zoomedblock%2.0
}
else
	UI.zoomedblock = UI.zoomscale * UI.blocksize

UI.zoomscale = UI.zoomedblock * 1.0/UI.blocksize

UI.zoomedwidth = UI.zoomscale * UI.tilewidth
UI.zoomedheight = UI.zoomscale * UI.tileheight

UI.zoomedcorewidth = UI.zoomscale * UI.corewidth
UI.zoomedcoreheight = UI.zoomscale * UI.coreheight
UI.zoomedvshift = floor(UI.zoomscale * UI.verticalshift)
UI.verticalshift = floor(UI.verticalshift + 0.5)
UI.zoomedpadding = (UI.zoomedwidth - UI.zoomedcorewidth)*0.5

// correction data for non-centered first tiles
// deltacol are the marginal columns with respect to center one
local deltacol = (UI.cols - 3)/2 //TEST103 controllare se questo "-3" va sempre bene o in alcuni casi fa saltare

local centercorr = {
	zero = null // is the value of corrections that centers the list
	val = null // Is the target value of the position of tiles
	shift = null // Is the shift factor added to the usual tile jump
}

centercorr.zero = - deltacol*(UI.widthmix + UI.padding) - (fl.w - (carrierT.w - 2*(UI.widthmix + UI.padding))) / 2 - UI.padding*(1 + UI.zoomscale*0.5) - UI.widthmix/2 + UI.zoomedwidth/2
centercorr.zero = floor(centercorr.zero + 0.5) // Added to align centercorr.zero to pixels

centercorr.val = 0
centercorr.shift = centercorr.zero

// transitions speeds
local spdT = {
	scrollspeed = 0.91
	dataspeedin = 0.91
	dataspeedout = 0.88
}

// Video delay parameters to skip fade-in
local vidstarter = 10000
local delayvid = vidstarter - 60 * prf.THUMBVIDELAY
local fadevid = delayvid - 35

// Fading letter and scroller sizes
local lettersize = {
	name = 250 * UI.scalerate
	//display = (fl.w_os * 30.0/200.0) / uifonts.pixel
}

UI.footermargin = floor (250 * UI.scalerate + 0.5)
local scrollersize = 2 * floor (20 * UI.scalerate * 0.5) + 1

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

if (UI.vertical){
	bgT.x = (fl.w_os - fl.h_os) / 2
	bgT.y = 0
	bgT.w = fl.h_os
}

// parameters for changing scroll jump spacing
local scroll = {
	jump = false
	step = UI.rows
	sortjump = false
}

// Capslocked keyboard also adds special characters:
// 1 2 3 4 5 6 7 8 9 0
// ! $ & / ( ) = ? + -

// keys definition for on screen keyboard
local key_names = { "a": "a", "b": "b", "c": "c", "d": "d", "e": "e", "f": "f", "g": "g", "h": "h", "i": "i", "j": "j", "k": "k", "l": "l", "m": "m", "n": "n", "o": "o", "p": "p", "q": "q", "r": "r", "s": "s", "t": "t", "u": "u", "v": "v", "w": "w", "x": "x", "y": "y", "z": "z", "1": "Num1", "2": "Num2", "3": "Num3", "4": "Num4", "5": "Num5", "6": "Num6", "7": "Num7", "8": "Num8", "9": "Num9", "0": "Num0", "<": "Backspace", " ": "Space", "|": "Clear", "~": "Done"}
local key_rows = ["abcdefghi123", "jklmnopqr456", "stuvwxyz}789", "}<{} {}|{}0{","~"]
local key_sizes = [[1,1,1,1,1,1,1,1,1,1,1,1], [1,1,1,1,1,1,1,1,1,1,1,1], [1,1,1,1,1,1,1,1,1,1,1,1], [0,3,0,0,3,0,0,3,0,0,3,0],[1]]
if (prf.KEYLAYOUT == "QWERTY") {
	key_rows = ["qwertyuiop123", "asdfghjkl{456", "}zxcvbnm{{789", "}<{} {{}|{}0{","~"]
	key_sizes = [[1,1,1,1,1,1,1,1,1,1,1,1,1], [1,1,1,1,1,1,1,1,1,1,1,1,1], [1,1,1,1,1,1,1,1,1,1,1,1,1], [0,3,0,0,4,0,0,0,3,0,0,3,0],[1]]
}
if (prf.KEYLAYOUT == "AZERTY") {
	key_rows = ["azertyuiop123", "qsdfghjklm456", "}}wxcvbn{{789", "}<{} {}|{{}0{","~"]
	key_sizes = [[1,1,1,1,1,1,1,1,1,1,1,1,1], [1,1,1,1,1,1,1,1,1,1,1,1,1], [1,1,1,1,1,1,1,1,1,1,1,1,1], [0,3,0,0,4,0,0,0,3,0,0,3,0],[1]]
}

if (UI.vertical) {
	key_rows = ["1234567890","abcdefghij","klmnopqrst","uvwxyz{{{{","}<{} {{}|{","~"]
	key_sizes = [[1,1,1,1,1,1,1,1,1,1], [1,1,1,1,1,1,1,1,1,1], [1,1,1,1,1,1,1,1,1,1], [1,1,1,1,1,1,1,1,1,1],[0,3,0,0,4,0,0,0,3,0],[1]]
	if (prf.KEYLAYOUT == "QWERTY") 	{
		key_rows = ["1234567890","qwertyuiop","asdfghjkl{","}zxcvbnm{{","}<{} {{}|{","~"]
		key_sizes = [[1,1,1,1,1,1,1,1,1,1], [1,1,1,1,1,1,1,1,1,1], [1,1,1,1,1,1,1,1,1,1], [1,1,1,1,1,1,1,1,1,1],[0,3,0,0,4,0,0,0,3,0],[1]]
	}
	if (prf.KEYLAYOUT == "AZERTY") {
		key_rows = ["1234567890","azertyuiop","qsdfghjklm","}wxcvbn{{{","}<{} {{}|{","~"]
		key_sizes = [[1,1,1,1,1,1,1,1,1,1], [1,1,1,1,1,1,1,1,1,1], [1,1,1,1,1,1,1,1,1,1], [1,1,1,1,1,1,1,1,1,1],[0,3,0,0,4,0,0,0,3,0],[1]]
	}
}
local key_selected = [0,0]
local keyboard_entrytext = ""

/// RELOCATED FUNCTIONS ///


function parsecommanddat(){
	local datpath = fe.path_expand(AF.folder+"command.dat")
	local datfile = ReadTextFile(datpath)
	local outarray = []
	local newline = ""
	local romsarray = []
	local commandsarray = []
	local commandstring = ""
	local i = 0
	local outpath = fe.path_expand(AF.folder+"nut_command.nut")
	local outfile = WriteTextFile(outpath)
	outfile.write_line("return ({\n")
	while (!datfile.eos()){
		newline = datfile.read_line()
		if (newline.find("$info=")!= null){
			i ++
			romsarray = split(split(newline,"=")[1],",")
			newline = ""
			while ((newline != "- CONTROLS -")&&(newline !="«Buttons»")){
				newline = datfile.read_line()
			}
			newline = datfile.read_line() //skip separator
			newline = datfile.read_line() //first button
			while (newline != ""){
				if((newline.find("@left")==null)&&(newline.find("@right")==null)) try{commandsarray.push (strip(split(newline,":(")[1]))}catch(err){}
				newline = datfile.read_line()
			}
			commandstring = "[" + ap + commandsarray[0]+ap
			for (local ii = 1; ii < commandsarray.len(); ii++){
				commandstring = commandstring + ","+ap + commandsarray[ii] + ap
			}
			commandstring += "]"
			foreach (id, item in romsarray) {
				outfile.write_line(ap+item+ap+" : "+commandstring+"\n")
			}
			commandsarray = []
			commandstring = ""
		}
	}
	outfile.write_line("})\n")
	outfile.close_file()

}
//parsecommanddat()

function powerman(action){
	if (action == "SHUTDOWN"){
		if (OS == "OSX") system ("osascript -e 'tell app "+ap+"System Events"+ap+" to shut down'")
		else if (OS == "Windows") system ("shutdown /s /t 0")
		else system ("sudo shutdown -h now")
	}
	if (action == "REBOOT"){
		if (OS == "OSX") system ("osascript -e 'tell app "+ap+"System Events"+ap+" to restart'")
		else if (OS == "Windows") system ("shutdown /r /t 0")
		else system ("sudo reboot")
	}
	if (action == "SUSPEND"){
		if (OS == "OSX") system ("osascript -e 'tell app "+ap+"System Events"+ap+" to sleep'")
		else if (OS == "Windows") system ("shutdown /h")
		else system ("sudo pm-hibernate")
	}
}

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

function afsort(arr_in, arr_mixval){

	foreach (i, item in arr_in){
		arr_mixval[i] = arr_mixval[i] + IDX[i]
	}

	arr_mixval.sort()

	arr_mixval.apply(function(value){
		return (arr_in[(value.slice(-5)).tointeger()])
	})

	return arr_mixval
}

/*
	afsortdual is a variant of afsort2 that works on the twin gametables
	It doesn't need assignment like afsort2 since it works directly on the z_list.gametable
	and z_list.gametable2 arrays.

	afsortdual(arr_keyval, arr_extval, reverse)

	afsortdual(
	z_list.gametable.map(function(a){return(nameclean(a.z_title).tolower())}),
	z_list.gametable.map(function(a){return("|"+a.z_system.tolower())}),
	reverse)

	arr_keyval is the value that is used as a key to do the sorting
	arr_extval is the secondary sort order
	reverse toggle reverse order sort
	IDX is the index in string format

	A fake array is created, each entry being arr_keyval + arr_extval + IDX
*/

function afsortdual(arr_in, arr2_in, arr_keyval, arr_extval, reverse){

	local arr_extval2 = []
	// scans the arr_in (just to get the # of items) and populate extval
	// creting a sortable array
	foreach (i, item in arr_extval){
		arr_extval[i] = arr_keyval[i] + arr_extval[i] + IDX[i]
	}

	// sorts arr_extval
	arr_extval.sort()

	// this functions creates a vector of sort indexes to use in reverse
	local sortedindex = arr_extval.map(function(value){
			return (value.slice(-5)).tointeger()
		})

	// this function restructures arr_extval to be the correct arr_in with sorting
	local sortlist1 = sortedindex.map(function(value){
			return (arr_in[value])
		})
	local sortlist2 = sortedindex.map(function(value){
			return (arr2_in[value])
		})


	if (reverse)  {
		local packetarray = []
		local packetarray2 = []
		local j = 0
		local temp = arr_keyval[sortedindex[0]]

		packetarray.push([])
		packetarray2.push([])
		foreach (i, item in sortlist1){
			if (arr_keyval[sortedindex[i]] == temp)  {
				packetarray[j].push(item)
				packetarray2[j].push(sortlist2[i])
			}
			else {
				temp = arr_keyval[sortedindex[i]]
				packetarray.push([])
				packetarray2.push([])
				j = j + 1
				packetarray[j].push(item)
				packetarray2[j].push(sortlist2[i])
			}
		}
		local outarray = []
		local outarray2 = []
		for (local i = packetarray.len() - 1 ; i >= 0; i--){
			outarray.extend(packetarray[i])
			outarray2.extend(packetarray2[i])
		}
		sortlist1 = outarray
		sortlist2 = outarray2
	}

	return ([sortlist1,sortlist2])

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
	IDX is the index in string format

	A fake array is created, each entry being arr_keyval + arr_extval + IDX
*/

function afsort2(arr_in, arr_keyval, arr_extval, reverse){

	// scans the arr_in (just to get the # of items) and populate extval
	// creting a sortable array
	foreach (i, item in arr_in){
		arr_extval[i] = arr_keyval[i] + arr_extval[i] + IDX[i]
	}

	// sorts arr_extval
	arr_extval.sort()

	// this functions purges arr_extval to get the proper index of sorting
	local sortedindex = arr_extval.map(function(value){
			return (value.slice(-5)).tointeger()
		})
	// this function restructures arr_extval to be the correct arr_in with sorting
	arr_extval.apply(function(value){
			return (arr_in[(value.slice(-5)).tointeger()])
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
      inputstring = inputstring.slice(0,zip) + " " + inputstring.slice(zip + 2)
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
      inputstring = (inputstring.slice(0,st)+new+inputstring.slice(st+old.len()))
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
					gamepath = gamepathwext.slice(0,-1-gameext.len())

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

function isroot(path){
	return ((path.slice(0,1) == "/") || (path.slice(1,2) == ":"))
}

// This function gets emulator data for a specified emulator name
function getemulatordata(emulatorname){
	local out = {
		rompath = null
		romextarray = null
		importextras = null
		mainsysname = null
		artworktable = {}
		executable = null
		args = null
		racore = null
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
	local workdir = ""
	local executable = ""
	local args = ""
	local racore = ""
	local start = 0
	local stop = 0

	while (!infile.eos()){
		inline = infile.read_line()
		if (inline.find("executable") == 0) {
			executable = strip(inline.slice(10))
			executable = fe.path_expand(executable)
		}
		else if (inline.find("args") == 0) {
			args = strip(inline.slice(4))
		}
		else if (inline.find("rompath") == 0) {
			rompath = strip(inline.slice(7))
			rompath = fe.path_expand(rompath)
			if ((rompath.slice(-1) != "\\") && (rompath.slice(-1) != "/")) rompath = rompath + "/"
			gamepath = fe.game_info(Info.Name)
		}
		else if (inline.find ("romext") == 0){
			romext = strip(inline.slice(6))
			romextarray = split(romext,";")
		}
		else if (inline.find ("workdir") == 0){
			workdir = strip(inline.slice(7))
			workdir = fe.path_expand(workdir)
			if ((workdir.slice(-1) != "\\") && (workdir.slice(-1) != "/")) workdir = workdir + "/"
			if (!isroot(workdir)) workdir = FeConfigDirectory + workdir
		}
		else if (inline.find ("system") == 0){
			mainsysname = strip(inline.slice(6))
			mainsysname = split(mainsysname,";")[0]
		}
		else if (inline.find("import_extras") == 0){
			if (inline.len() > 14){
				extras = fe.path_expand(strip(inline.slice(14)))
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
			//extras = fe.path_expand(strip(inline.slice(14)))

		}
	}

	if (executable.tolower().find("retroarch") == null) racore = ""
	else if (args.find("-L ") == null) racore = ""
	else {
		racore = args
		start = racore.find("-L ")+3
		stop = racore.find("_libretro")

		if (stop != null){
			racore = racore.slice(start,stop)
		} else {
			racore = racore.slice(start)
		}
		racore = split(racore," ")[0]
		racore = split(racore,"/\\ ")
		racore = racore[racore.len()-1]
	}

	if (artworktable.rawin ("snap") && artworktable.snap.find(";") != null){
		artworktable.video <- fe.path_expand(split(artworktable.snap,";")[1])
		artworktable.snap = fe.path_expand(split(artworktable.snap,";")[0])
	}

	foreach (id,item in artworktable){
		artworktable[id] = fe.path_expand(artworktable[id])
	}

	//	try {if (rompath.slice(0,3) == "../") rompath = FeConfigDirectory + rompath} catch(err){}
	if (!isroot(rompath)) rompath = ((workdir == "") ? FeConfigDirectory : workdir) + rompath
	rompath = fe.path_expand(rompath)

	foreach (id,item in artworktable){
		//	try {if (item.slice(0,3) == "../") artworktable[id] = FeConfigDirectory + item}catch(err){}
		if (!isroot(item)) artworktable[id] = ((workdir == "") ? FeConfigDirectory : workdir) + item
		artworktable[id] = fe.path_expand(artworktable[id])
	}

	out.rompath = rompath
	out.romextarray = romextarray
	out.importextras = extras
	out.mainsysname = mainsysname
	out.artworktable = artworktable
	out.executable = executable
	out.args = args
	out.racore = racore

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
	z_splash_message(text)
	//AF.messageoverlay.msg = text
	return arrayin
}

function messageboxer(title,message,new,arrayin){
	// Creates a "scrolling" message box on the screen:

	// If title is not "", it will appear as title and
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

	local string1space = columns - width2 - 1
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

function packwrap (intext, columns){
	local outtext = intext+"§"
	if (intext.len() > columns){
		outtext = intext.slice(0,columns)+"§"+intext.slice(columns,intext.len())+"§"
	}
	return (outtext)
}

function packtext (intext, columns){
	if (intext == "") intext = " "
	local spc = "                                                                             "
	local out = ""
	local separator = "§"
	local textarray = split(intext,separator)
	local outstring = ""
	foreach (i, item in textarray){
		if (item.len() > columns) textarray[i] = item.slice(0,columns-1)+"_"
		if (item.len() < columns) textarray[i] = textarray[i] + spc.slice(0,columns-item.len())
		outstring = outstring + textarray[i]
		if (i < textarray.len()-1)outstring = outstring +"\n"
	}
	return (outstring)
}

function textrate (num,den,columns,ch1,ch0){
	local out = ""
	local limit = (num*columns)/den
	local i = 0
	local char = ""

	while (out.len() < limit){
		out += ch1
	}
	while (out.len() < columns){
		out += ch0
	}
	return out
}

//TEST149 put local here
dispatcher = []
dispatchernum = 0

function createjsonA(scrapeid,ssuser,sspass,romfilename,romcrc,romsize,systemid,romtype){
   scraprt("ID"+scrapeid+"             createjsonA START"+"\n")
	local unicorrect = unicorrect()

	try {remove (AF.folder + "json/" + scrapeid + "jsonA.nut")} catch(err){}
	try {remove (AF.folder + "json/" + scrapeid + "jsonA.txt")} catch(err){}

	local execss = ""
	if (OS == "Windows"){
		execss =  char_replace(AF.subfolder,"/","\\") + "\\curlscrape.vbs"+" "+ap+"http://adb.arcadeitalia.net/service_scraper.php?ajax=query_mame&game_name="
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
	scraprt("ID"+scrapeid+"             createjsonA suspend\n")
	suspend()
	scraprt("ID"+scrapeid+"             createjsonA resumed\n")

	local jsarray = []
	local jsfilein = ReadTextFile(fe.path_expand(AF.folder + "json/" + scrapeid + "jsonA.nut"))
	while (!jsfilein.eos()){
		local linein = jsfilein.read_line()
		jsarray.push (linein)
		/*
		if(jsarray[(jsarray.len()-1)][0].tochar() == "<") {
			dispatcher[scrapeid].jsonstatus = "ERROR"
			return
		}
		*/
	}

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
	jsfileout.close_file()
	scraprt("ID"+scrapeid+"             createjsonA SCRAPED\n")
	dispatcher[scrapeid].jsonstatus = "SCRAPED"
   return

}

function createjson(scrapeid,ssuser,sspass,romfilename,romcrc,romsize,systemid,romtype){
   scraprt("ID"+scrapeid+"             createjson START"+"\n")
	local unicorrect = unicorrect()

	try {remove (AF.folder + "json/" + scrapeid + "json.nut")} catch(err){}
	try {remove (AF.folder + "json/" + scrapeid + "json.txt")} catch(err){}

	local urlencoder1 = [" ","[","]","{",":","/","?","#","@","!","$","&","'","(",")","*","+",",",";","=" ]
	local urlencoder2 = ["%20","%5B","%5D","%7B","%3A","%2F","%3F","%23","%40","%21","%24","%26","%27","%28","%29","%2A","%2B","%2C","%3B","%3D"]

	foreach (i,item in urlencoder1){
		romfilename = subst_replace (romfilename, urlencoder1[i],urlencoder2[i])
	}
	romfilename = subst_replace (romfilename, ".","")
	romfilename = subst_replace (romfilename, " ","")

	local execss = ""
	if (OS == "Windows"){
		execss =  char_replace(AF.subfolder,"/","\\") + "\\curlscrape.vbs"+" "+ap+"https://www.screenscraper.fr/api2/jeuInfos.php?devid=zpaolo11x&devpassword=BFrCcPgtSRc&softname=Arcadeflow&output=json"
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
	scraprt("ID"+scrapeid+"             createjson suspend\n")
	suspend()
	scraprt("ID"+scrapeid+"             createjson resumed\n")

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
	jsfileout.close_file()
	scraprt("ID"+scrapeid+"             createjson SCRAPED\n")
	dispatcher[scrapeid].jsonstatus = "SCRAPED"
   return
}


function getromdata(scrapeid, ss_username, ss_password, romname, systemid, systemmedia, isarcade, regionprefs, rompath){
	scraprt("ID"+scrapeid+"         getromdata START "+rompath+"\n")

	// This is the function that actually starts the scraping dispatching createjsons commands

	// Start arcade scraping if the isarcade flag is true
   if (isarcade){
		scraprt("ID"+scrapeid+"         getromdata CALL createjsonA\n")
		// Runs the creation of arcade json and susbends until it has finished
		dispatcher[scrapeid].createjsonA.call(scrapeid,ss_username,ss_password,strip(split(romname,"(")[0]),null,null,systemid,systemmedia)
		suspend()

		// IF no errors are raised gamedata is populated with fields from the arcade json
		if (dispatcher[scrapeid].jsonstatus != "ERROR"){
   	   dispatcher[scrapeid].gamedata.scrapestatus = "ARCADE"
      	dispatcher[scrapeid].gamedata = parsejsonA (scrapeid, dispatcher[scrapeid].gamedata)
		}

		// cleanup
		try {remove (AF.folder + "json/" + scrapeid + "jsonA.txt")} catch(err){}
		try {remove (AF.folder + "json/" + scrapeid + "jsonA.nut")}catch(err){}
		try {remove (AF.folder + "json/" + scrapeid + "jsonA_out.nut")}catch(err){}
	}

	//Notice that createjsonA can change arcade status to false to allow re-scrape as standard game

	// Finished DBA scraping, go on with SS scraping to complete missing fields
	// or to generate a full scraping for non-arcade games
   // CRC check is never enabled for arcade games, so it's run here
	local filemissing = (dispatcher[scrapeid].gamedata.name == dispatcher[scrapeid].gamedata.filename)
	dispatcher[scrapeid].gamedata.crc = (AF.scrape.inprf.NOCRC || filemissing) ? null : getromcrc_lookup4(rompath)
   scraprt("ID"+scrapeid+"         getromdata CALL createjson 1\n")
	 //TEST132 changed splitting to take only part before "_"
	 local strippedrom = strip(split(strip(split(romname,"(")[0]),"_")[0])
	 local stripmatch = true
   dispatcher[scrapeid].createjson.call(scrapeid,ss_username,ss_password,strippedrom,(AF.scrape.inprf.NOCRC || filemissing || dispatcher[scrapeid].gamedata.crc[0] == null)?"":dispatcher[scrapeid].gamedata.crc[0],null,systemid,systemmedia)

	 scraprt("ID"+scrapeid+"         getromdata suspend 1\n")
	suspend() // Wait for the json to be read
	 scraprt("ID"+scrapeid+"         getromdata resumed\n")

	// As with arcade scraping, let's check what happened and if the scan is actually a rescan
	//TEST120 Should we add the retry check to the arcade scrape portion or not???
	if ((dispatcher[scrapeid].jsonstatus != "RETRY")) {
		// If stripped rom fails, try with non-stripped rom
      if ((dispatcher[scrapeid].jsonstatus == "ERROR")&&(strippedrom != romname)){
			stripmatch = false
         dispatcher[scrapeid].jsonstatus = null
		   scraprt("ID"+scrapeid+"         getromdata CALL createjson ERR\n")
			dispatcher[scrapeid].createjson.call(scrapeid,ss_username,ss_password,romname,(AF.scrape.inprf.NOCRC || filemissing || dispatcher[scrapeid].gamedata.crc[0] == null)?"":dispatcher[scrapeid].gamedata.crc[0],null,systemid,systemmedia)
		   scraprt("ID"+scrapeid+"         getromdata suspend ERR\n")
			suspend()
		   scraprt("ID"+scrapeid+"         getromdata resumed\n")
		}

		if ((dispatcher[scrapeid].jsonstatus != "ERROR")) {


			local getcrc = matchrom(scrapeid,romname) //This is the CRC of a rom with matched name
			// Scraped rom has correct CRC, no more scraping needed
			if (!(AF.scrape.inprf.NOCRC || filemissing) && (getcrc.rom_crc == dispatcher[scrapeid].gamedata.crc[0] || getcrc.rom_crc == dispatcher[scrapeid].gamedata.crc[1])) {
				dispatcher[scrapeid].gamedata.scrapestatus = "CRC"
				dispatcher[scrapeid].gamedata = parsejson (scrapeid, dispatcher[scrapeid].gamedata)
			}
			else {
				// If name_crc is null it means no name matched the current rom name, so the scraping is "GUESS"
				// but if name_crc is not null it means one of the roms in the scraped list matched with the current rom "NAME"
				if (getcrc.name_crc == "") dispatcher[scrapeid].gamedata.scrapestatus = "GUESS"
				else dispatcher[scrapeid].gamedata.scrapestatus = "NAME"

				echoprint ("Second check: " + dispatcher[scrapeid].gamedata.scrapestatus + "\n")
				// Once the name is perfectly matched, a new scrape is done to get proper rom status
				dispatcher[scrapeid].jsonstatus = null
				scraprt("ID"+scrapeid+"         getromdata CALL createjson 2\n")
				//TEST132 changed to stripped romname (was just romname)
				dispatcher[scrapeid].createjson.call(scrapeid,ss_username,ss_password,stripmatch ? strippedrom : romname,getcrc.name_crc,null,systemid,systemmedia)
				scraprt("ID"+scrapeid+"         getromdata suspend 2\n")
				suspend()
				scraprt("ID"+scrapeid+"         getromdata resumed 2\n")

				if (dispatcher[scrapeid].jsonstatus != "ERROR"){
					dispatcher[scrapeid].gamedata = parsejson (scrapeid, dispatcher[scrapeid].gamedata)
					echoprint ("Matched NAME "+dispatcher[scrapeid].gamedata.filename+" with " +dispatcher[scrapeid].gamedata.matchedrom+"\n")
				}
			}

			if (dispatcher[scrapeid].gamedata.notgame) {
				dispatcher[scrapeid].gamedata.scrapestatus = "NOGAME"
			}
		}
		else {
			echoprint ("ERROR\n")
			dispatcher[scrapeid].gamedata.scrapestatus = "ERROR"
		}
   }
   else if(dispatcher[scrapeid].jsonstatus == "RETRY"){
      echoprint ("RETRY\n")
      dispatcher[scrapeid].gamedata.scrapestatus = "RETRY"
   }
   /*
	else if(dispatcher[scrapeid].jsonstatus == "ERROR"){
		echoprint ("ERROR\n")
      dispatcher[scrapeid].gamedata.scrapestatus = "ERROR"
   }
	*/
   //dispatcher[scrapeid].gamedata = gamedata
   dispatcher[scrapeid].done = true

	try {remove (AF.folder + "json/" + scrapeid + "json.txt")} catch(err){}
	try {remove (AF.folder + "json/" + scrapeid + "json.nut")}catch(err){}
	try {remove (AF.folder + "json/" + scrapeid + "json_out.nut")}catch(err){}
	scraprt("ID"+scrapeid+"         getromdata RETURN\n")
	return //gamedata
}


function scrapegame2(scrapeid, inputitem, forceskip){
	// Updates the dispatcher with the current scraping game
	dispatcher[AF.scrape.dispatchid].rominputitem = inputitem

	local scrapecriteria = AF.scrape.inprf.ROMSCRAPE

	// Now inputitem is a full z_fields1 table with all the ncessary fields
	// instead of using emudata we need to get emulator data for each game

	// From 12.0 inputitem is NOT the filename.ext, but only the fileNAME with no extension
	// so we want to get the extension of the file if it's available,
	// this is not useful for general scraping but it is if we
	// want to scrape using CRC, otherwise CRC calculation will fail

	//	local ext = split(inputitem,".").pop() // Get file extension
	try {dispatcher[scrapeid].gamedata.clear()}catch(err){}
	local gd = systemSSname (AF.emulatordata[inputitem.z_emulator].mainsysname)
	local garcade = systemSSarcade (AF.emulatordata[inputitem.z_emulator].mainsysname)
	local gname = inputitem.z_name //slice(0,-1*(ext.len()+1))
	local gnamewext = gname
	local listline = ""

	foreach (id, ext in AF.emulatordata[inputitem.z_emulator].romextarray) {
		if (file_exist (AF.emulatordata[inputitem.z_emulator].rompath + gname + ext) ){
			gnamewext = gname + ext
			break
		}
	}
	local scrapethis = true

	dispatcher[scrapeid].gamedata = {
		name = gname
		filename = gnamewext
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

		notgame = false //TEST132 was true
		crc = null
	}

	// Scraping data structure has been created and now we check if we have
	// to actually scrape this game or not

	if (scrapethis && !forceskip) {
		scraprt("ID"+scrapeid+"     scrapegame2 CALL getromdata\n")

		dispatcher[scrapeid].getromdata.call(scrapeid,AF.scrape.inprf.SS_USERNAME, AF.scrape.inprf.SS_PASSWORD, gname,gd[0],gd[1],garcade,AF.scrape.regionprefs,AF.emulatordata[inputitem.z_emulator].rompath+gnamewext)
	   scraprt("ID"+scrapeid+"     scrapegame2 suspend\n")
		suspend()
	   scraprt("ID"+scrapeid+"     scrapegame2 resume\n")

		// Now the results from the scrape are back, let's analyse and put them in the
		// scrapelist fields (in this case no need to use listline!)
		// The data can be written to "inputitem" which is the link to the original data table
		local isarcade = dispatcher[scrapeid].gamedata.isarcade
		if ((dispatcher[scrapeid].gamedata.scrapestatus != "NOGAME")  && (dispatcher[scrapeid].gamedata.scrapestatus != "RETRY")){
			if ((dispatcher[scrapeid].gamedata.scrapestatus != "ERROR")){

				//listline = gname+";" //Name
				inputitem.z_title = isarcade ? dispatcher[scrapeid].gamedata.adb_title : dispatcher[scrapeid].gamedata.title + (dispatcher[scrapeid].gamedata.extradata != "" ? "("+dispatcher[scrapeid].gamedata.extradata+")" : "") //Title with extradata
				inputitem.z_title = subst_replace(inputitem.z_title,ap,"'")
				//listline += AF.scrape.romlist+";" //Emulator
				//listline += ";" //Clone
				inputitem.z_year = isarcade ? dispatcher[scrapeid].gamedata.adb_year : dispatcher[scrapeid].gamedata.releasedate //Year
				inputitem.z_manufacturer = isarcade ? dispatcher[scrapeid].gamedata.adb_manufacturer : dispatcher[scrapeid].gamedata.publisher //Manufacturer
				inputitem.z_manufacturer = subst_replace (inputitem.z_manufacturer,ap,"'")

				inputitem.z_category = isarcade ? dispatcher[scrapeid].gamedata.adb_genre : dispatcher[scrapeid].gamedata.genre //Category
				inputitem.z_players = isarcade ? dispatcher[scrapeid].gamedata.adb_players.tostring() : dispatcher[scrapeid].gamedata.players.tostring() //Players
				inputitem.z_rotation = isarcade ? dispatcher[scrapeid].gamedata.adb_screenorientation : dispatcher[scrapeid].gamedata.a_rotation //Rotation
				inputitem.z_control = isarcade ? dispatcher[scrapeid].gamedata.adb_inputcontrols : dispatcher[scrapeid].gamedata.a_controls //Control
				//listline += isarcade ? dispatcher[scrapeid].gamedata.adb_status+";" : ";" //Status
				//listline += ";" //DisplayCount
				//listline += ";" //DisplayType
				//listline += ";" //AltRomname
				//listline += ";" //AltTitle
				inputitem.z_scrapestatus = dispatcher[scrapeid].gamedata.scrapestatus
				inputitem.z_description = split_complete(dispatcher[scrapeid].gamedata.synopsis,"^")
				inputitem.z_resolution = isarcade ? (dispatcher[scrapeid].gamedata.adb_screenresolution == "" ? "" : split(dispatcher[scrapeid].gamedata.adb_screenresolution,"p")[0]) : dispatcher[scrapeid].gamedata.a_resolution
				inputitem.z_arcadesystem = dispatcher[scrapeid].gamedata.a_system
				inputitem.z_commands = isarcade ? parsecommands(dispatcher[scrapeid].gamedata.adb_buttonscolors) : ""
				//listline += "‖ "+dispatcher[scrapeid].gamedata.scrapestatus +" ‖ "+ dispatcher[scrapeid].gamedata.synopsis+" ‖ "+(isarcade ? split(dispatcher[scrapeid].gamedata.adb_screenresolution,"p")[0] : dispatcher[scrapeid].gamedata.a_resolution)+" ‖ "+dispatcher[scrapeid].gamedata.a_system+" ‖ " + (isarcade ? dispatcher[scrapeid].gamedata.adb_buttonscolors : "") + " ‖"+";" //Extra
				inputitem.z_buttons = isarcade ? dispatcher[scrapeid].gamedata.adb_inputbuttons.tostring() : dispatcher[scrapeid].gamedata.a_buttons.tostring()
				inputitem.z_series = isarcade ? dispatcher[scrapeid].gamedata.adb_serie : dispatcher[scrapeid].gamedata.series //Series
				//listline += ";" // Language
				inputitem.z_region = isarcade ? "" : dispatcher[scrapeid].gamedata.regions //Region
				inputitem.z_rating = dispatcher[scrapeid].gamedata.rating.tostring() //Rating
			}
			else {
				// dispatcher scrapestatus is an error. If no previous scraping was done this is transferred to the rom scrape status
				if (inputitem.z_scrapestatus == "NONE") inputitem.z_scrapestatus = "ERROR"
			}
			/*
			else {
				try {listline = AF.scrape.checktable[inputitem].line}catch(err){
					listline = gname+";"+gname+";"+AF.scrape.romlist+";;;;;;;;;;;;;"+"‖ "+dispatcher[scrapeid].gamedata.scrapestatus +" ‖ "+ dispatcher[scrapeid].gamedata.scrapestatus+" ‖"+";;;;;;"
				}
			}
			AF.scrape.scrapelist_lines.push (inputitem+"|"+dispatcher[scrapeid].gamedata.scrapestatus+"|"+listline)
			*/
		}
		else if (dispatcher[scrapeid].gamedata.scrapestatus == "NOGAME") {
			inputitem.z_scrapestatus = "NOGAME"
		}
	}
	else {
		local tempreason = ""
		try {tempreason = " "+inputitem.z_scrapestatus}catch(err){}

		dispatcher[scrapeid].gamedata.scrapestatus = "SKIP "+strip(tempreason)
		inputitem.z_scrapestatus = "ERROR"

		dispatcher[scrapeid].skip = true
		dispatcher[scrapeid].done = true
	}

	if (dispatcher[scrapeid].gamedata.scrapestatus != "RETRY"){
		try {
			AF.scrape.report[dispatcher[scrapeid].gamedata.scrapestatus].tot ++
			AF.scrape.report[dispatcher[scrapeid].gamedata.scrapestatus].names.push (dispatcher[scrapeid].gamedata.filename)
			AF.scrape.report[dispatcher[scrapeid].gamedata.scrapestatus].matches.push (dispatcher[scrapeid].gamedata.matchedrom)
		}
		catch (err){
			AF.scrape.report[dispatcher[scrapeid].gamedata.scrapestatus] <- {
				tot = 1
				names = [dispatcher[scrapeid].gamedata.filename]
				matches = [dispatcher[scrapeid].gamedata.matchedrom]
			}
		}
	}

	// MEDIA DOWNLOAD
	if ((scrapethis && !forceskip) && (dispatcher[scrapeid].gamedata.scrapestatus!="ERROR")){
		debugpr("gamedata.scrapestatus:"+dispatcher[scrapeid].gamedata.scrapestatus+"\n")
		debugpr("gamedata.media table size:"+dispatcher[scrapeid].gamedata.media.len()+"\n")
		foreach (emuartcat, emuartfolder in AF.emulatordata[inputitem.z_emulator].artworktable){

			debugpr("emuartcat:"+emuartcat+" "+emuartfolder+"\n")
			local tempdata = []
			local tempdataA = null
			try {tempdata = dispatcher[scrapeid].gamedata.media[emuartcat]}catch(err){}
			if (dispatcher[scrapeid].gamedata.isarcade) try {tempdataA = dispatcher[scrapeid].gamedata.adb_media[emuartcat]}catch(err){}

			debugpr("gamedata.media[emuartcat] size:"+tempdata.len()+"\n")

			if (tempdataA != null){
				if (tempdataA.url == "") tempdataA = null
			}

			if (tempdataA != null) {
				if ( !(AF.scrape.forcemedia == "NO_MEDIA") && ((AF.scrape.forcemedia == "ALL_MEDIA") || !(file_exist(emuartfolder + "/"+ dispatcher[scrapeid].gamedata.name +"."+ tempdataA.ext)))) {
					if (OS == "Windows"){
						system (char_replace(AF.subfolder,"/","\\") + "\\curldownload.vbs " + ap + tempdataA.url + ap + " " + ap + emuartfolder + "\\"+ dispatcher[scrapeid].gamedata.name +"."+ tempdataA.ext + ap)
					}
					else {
						system ("curl -f --create-dirs -s " + ap + tempdataA.url + ap + " -o " + ap + emuartfolder + "/"+ dispatcher[scrapeid].gamedata.name +"."+ tempdataA.ext + ap+ (emuartcat == "wheel" ? "": " &"))
					}
				}

				if  (!(AF.scrape.forcemedia == "NO_MEDIA") && ((tempdata.len()>0) && (emuartcat == "wheel") && (  !(file_exist(emuartfolder + "/"+ dispatcher[scrapeid].gamedata.name +"."+ tempdataA.ext))) )){
					if (OS == "Windows"){
						system (char_replace(AF.subfolder,"/","\\") + "\\curldownload.vbs " + ap + tempdata[0].path + ap + " " + ap + emuartfolder + "\\"+ dispatcher[scrapeid].gamedata.name +"."+ tempdata[0].extension + ap)
					}
					else {
						system ("curl --create-dirs -s " + ap + tempdata[0].path + ap + " -o " + ap + emuartfolder + "/"+ dispatcher[scrapeid].gamedata.name +"."+ tempdata[0].extension + ap+" &")
					}
				}

			}
			else if(tempdata.len()>0){
				if ( !(AF.scrape.forcemedia == "NO_MEDIA") && ((AF.scrape.forcemedia == "ALL_MEDIA") || !(file_exist(emuartfolder + "/"+ dispatcher[scrapeid].gamedata.name +"."+ tempdata[0].extension)))) {
					if (OS == "Windows"){
						system (char_replace(AF.subfolder,"/","\\") + "\\curldownload.vbs " + ap + tempdata[0].path + ap + " " + ap + emuartfolder + "\\"+ dispatcher[scrapeid].gamedata.name +"."+ tempdata[0].extension + ap)
					}
					else {
						system ("curl --create-dirs -s " + ap + tempdata[0].path + ap + " -o " + ap + emuartfolder + "/"+ dispatcher[scrapeid].gamedata.name +"."+ tempdata[0].extension + ap+" &")
					}
				}
			}
		}
	}
}

// Define the new list data
local z_list = {
	boot = []
	boot2 = []
	db1 = {}
	db2 = {}
	index = 0
	newindex = 0
	gametable = []
	gametable2 = []
	jumptable = []
	size = 0
	orderby = Info.Title
	reverse = false
	layoutstart = false
	tagstable = {}
	tagstableglobal = {}
	favsarray = []

	rundatetable = {}
	favdatetable = {}
	ratingtable = {}

	allromlists = {}
	allemudata = {}
}

function scraperomlist2(inprf, forcemedia, onegame){
	AF.scrape.report = {}
	AF.scrape.doneroms = 0
	AF.messageoverlay.visible = true

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

	// z_list.allromlists è la tabella con tutti i nomi delle romlist "usate" dalla lista
	// ma a cosa serve? io ho già il db da scorrere... posso scorrere z_list.db1 (raggruppati per romlist)
	// o anche z_list.boot che è una array
	// se edito i dati nel boot1 e boot2 poi si riflettono su db1 e db2 che poi posso esportare in salvataggio!

	// This is only for display purposes
	local romlist = fe.displays[fe.list.display_index].romlist
	AF.scrape.romlist = romlist
	// Questo comando non fa altro che costruire la purgedromdirlist, ma
	// io ho già i vari db, la z_list.boot ecc... posso creare una fake list
	// in cui caricare i giochi da scrapare

	if (onegame){
		AF.scrape.totalroms = 1
		AF.scrape.purgedromdirlist = []
		AF.scrape.purgedromdirlist.push(z_list.boot[fe.list.index])
	}
	else {
		AF.scrape.totalroms = 0
		AF.scrape.purgedromdirlist = []
		local scrapethis = true
		local scrapecriteria = AF.scrape.inprf.ROMSCRAPE
		foreach (id, item in z_list.gametable){

			if (scrapecriteria == "ALL_ROMS") scrapethis = true
			else if (scrapecriteria == "SKIP_CRC") {
				// Scrape all roms that are not CRC matched
				try {scrapethis = ((item.z_scrapestatus != "CRC"))}catch(err){}
			}
			else if (scrapecriteria == "SKIP_NAME") {
				// Scrape only roms that have guess name matches
				try {scrapethis = ((item.z_scrapestatus == "GUESS") || (item.z_scrapestatus == "ERROR"))}catch(err){}
			}
			else if (scrapecriteria == "MISSING_ROMS") {
				try {scrapethis = ((item.z_scrapestatus == "NONE") || (item.z_scrapestatus == "ERROR"))}catch(err){}
			}

			if ((!prf.ERRORSCRAPE) && (item.z_scrapestatus == "ERROR")) scrapethis = false

			if (scrapethis){
				AF.scrape.totalroms++
				AF.scrape.purgedromdirlist.push(item)
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

			local romlistpath = AF.romlistfolder + item + ".txt"
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
				local listfilepath = AF.romlistfolder + romlistid + ".txt"
				local listfile = ReadTextFile (listfilepath)
				while (!listfile.eos()){
					local inline = listfile.read_line()
					fileout.write_line(inline+"\n")
				}
			}
			fileout.close_file()
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
			if (AF.emulatordata[item].importextras != ""){
				if (AF.emulatordata[item].importextras.slice(-4) == ".xml")  {
					xmlpaths.push (AF.emulatordata[item].importextras)
					xmlsysnames.push (item.slice(0,-4))
				}
			}
		}
   }
	//fe.overlay.splash_message (xmlmessage)

   foreach (id, item in xmlpaths){
      local XMLT = {}
		AF.boxmessage = messageOLDboxer ("",xmlsysnames[id],true,AF.boxmessage)

      XMLT = parseXML (xmlpaths[id])

		if (XMLT == null) {
			AF.boxmessage = messageOLDboxer ("",xmlsysnames[id] + " SKIP",false,AF.boxmessage)
			continue
		}
		AF.boxmessage = messageOLDboxer ("",xmlsysnames[id] + " DONE",false,AF.boxmessage)

		//clear scrape data
		//local scrapepath = FeConfigDirectory+"romlists/" + xmlsysnames[id] + ".scrape"
		//try {remove(scrapepath)}catch(err){}

      local romlistpath = FeConfigDirectory+"romlists/" + xmlsysnames[id] + ".txt"
		local rompath = AF.emulatordata [xmlsysnames[id]].rompath

      local romlist_file = WriteTextFile (romlistpath)
		romlist_file.write_line("#Name;Title;Emulator;CloneOf;Year;Manufacturer;Category;Players;Rotation;Control;Status;DisplayCount;DisplayType;AltRomname;AltTitle;Extra;Buttons;Series;Language;Region;Rating\n")
      foreach (id2,item2 in XMLT) {
         local listline = id2+";"
         listline += item2.name+";"
         listline += xmlsysnames[id]+";;"
         listline += (item2.releasedate.len() >= 4 ? item2.releasedate.slice(0,4) : "") +";"
         listline += item2.publisher+";"
         listline += (prefst.USEGENREID ? getgenreid(item2.genreid) : item2.genre)+";"
         listline += item2.players+";"
         listline += ";;;;;;;"
         listline += "‖ XML ‖ "+item2.desc+" ‖;;;;;"
         listline += item2.rating+";"
			if (file_exist(rompath+id2+"."+item2.ext) || !prefst.ONLYAVAILABLE) romlist_file.write_line(listline+"\n")
      }
		romlist_file.close_file()
   }
	//fe.set_display(fe.list.display_index)
}

/// Romlist management functions ///

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

// Table with new romlist fields and their default "empty" data
// z_fields1 is the "slow" fields table, these are defined in scraping or metadata editing
// and are rarely saved during operation
// Some fields like felistindex and filter fields are used only at runtime

local z_fields1 = {
	"z_felistindex" : 0,

	"z_name" : "", 			// rom file name minus extension
	"z_filename" : "", 		// complete rom file name
	"z_system" : "",	 		// system as defined in .cfg emulator file
	"z_emulator" : "",	 	// emulator name = emulator romlist name

	"z_fileisavailable" : true,

	"z_title" : "",
	"z_year" : "",
	"z_manufacturer": "",
	"z_publisher" : "",		// new field only from scraped data
	"z_description" : [],	// new field from scrape or MAME .dat file
	"z_category" : "",
	"z_series" : "",
	"z_region" : "",
	"z_resolution" : "", 	// array for horizontal and vertical size of arcade games
	"z_rotation" : "",
	"z_arcadesystem" : "",

	"z_players" : "",
	"z_control" : "",
	"z_buttons" : "",
	"z_commands" : [], 		// array of button command strings

	"z_rating" : "",

	// values used to check filtering of the game
	"z_inmfz" : true,			// {game in multifilter, filtermetatable}
	"z_insearch" : true,		// true if game is in search results
	"z_infav" : true,		// true if game is in search results
	"z_incat" : true,			// true if game is in category menu selection
	"z_inmots2" : true		// true if game is in "more of the same" results

	"z_scrapestatus" : "NONE"
}

// This is the "fast" fields database, it's saved in a separate file and is faster to
// read/load, it's used more often because tags, faved and date/number of launch are always
// updated
local z_fields2 = {
	"z_name" : "", 			// rom file name minus extension
	"z_filename" : "", 		// complete rom file name
	"z_system" : "",	 		// system as defined in .cfg emulator file
	"z_emulator" : "",	 	// emulator name = emulator romlist name

	"z_favourite" : false,	// favorite status no more external
	"z_completed" : false,	// set status for completed games
	"z_hidden" : false,		// true if the game is hidden from list
	"z_favdate" : "00000000000000", // used for sorting by last favourite
	"z_tags" : [], 			// array of defined tag strings
	"z_playedcount" : 0, 	// number of times the game was played
	"z_rundate" : "00000000000000", // used for sorting by last run
}

/*

dbext is the extension of the db file associated with "slow" and "fast" tier, that is db1 and db2
db1 is associated with z_fields1
db2 is associated with z_fields2

loadromlist loads a romlist from file, it can load the fields1 or fields2 part and returns the table directly
how are the db tables used? In case of multiple romlists there's a DB1 and DB2 table that has an entry for each romlist,
each entry is a table of game name and fields, so to address a game parameter you use:

db1[romlist][gamename].z_parameter

or

db2[romlist][gamename].z_parameter

NOTA!!!
felistindex is updated when the list is created from an existing AM romlist
or when the list is reset from scratch, in this case both the AM romlist
AND AF romlist are created and felistindex is baked in the db

bootlist probably doesn't make any sense anymore, because its only purpose is to fill felistindexes
I can use it as a general data structure with all pointers without
grouping by romlist like in the db, it's just an array of references
to the data (which has the emulator field anyway)

how does the old z_list.gametable work? in principle it only needs to have a romlist+gamename couple,
gamename in itself is not enough because more games can have the same filename from different romlists!

Current gametable is an array, each field having the game metadata. New gametable can be the same kind of array,
but with fields like this:

gametable = [
	{
		gamename = name
		romlist = romlist
	}
]

this means I need to "populate" it someway. OR gametable could also be an array where each field is a REFERENCE to the
original list db entry!

Implication on multifilter

At the current stage levcheck is called on the ifeindex to check
if the game is or is not in the filter, and it does it by elaborating on data
it gets from z_list.boot[ifeidex+fe.list.index].z_parameter

How does this work with db? It can work the same, pass the original index (aka ifeindex or felistindex)
from current game entry and get the results (no more fiddling needed because the romlist has the right data)
and at this point... why not pass just the FIELD pointer instead of referncing it again? That's an idea...

Implication on sorting

At the moment sorting works by arranging the gametable and maps elements of the table
to feed sort2 algorythm. In our case arr_in is the gametable,
arr_key is calculated and it can be done the same way,
arr_ extval the same
No real change here except the values are taken from the
db1 and db2 instead of the table (or use pointers again?)

*/


// Function to return an array with all the recognised roms file names and extensions
// from the current romlist folder
function getlistofroms(romlist){
	// Get emulator data for the current romlist

	// List files in the rom folder
	local romdirlist = DirectoryListing (AF.emulatordata[romlist].rompath,false).results
	local totalroms = 0
	local namelist = []
	local extlist = []

	foreach (id, item in romdirlist){
		local ext = split(item,".").pop() // Get file extension
		local start = item.slice(0,2)
		if ((start != "._") && (AF.emulatordata[romlist].romextarray.find("."+ext)!=null)) { // Check if extension is in the .cfg list
			local filename = item.slice(0,-1*(ext.len()+1))
			totalroms++
			namelist.push (filename)
			extlist.push (ext)
		}
	}
	namelist.reverse()
	extlist.reverse()
	return [namelist,extlist]
}

// Create an empty romlist with zeroed data from the fields table
// this function can be used both for z_fields1 and z_fields2
// NOTA It is a waste to call getlistofroms from this function since it
//      is used once for all roms, but this is a minor detail
function buildcleanromlist(romlist, fields){
	local roms = getlistofroms (romlist)
	local romtable = {}
	foreach (id, item in roms[0]){
		romtable.rawset(item, clone(fields))
		romtable[item].z_name = item
		try{romtable[item].z_title = item}catch(err){} //TEST120 DEBUG ONLY
		romtable[item].z_filename = roms[0][id]+"."+roms[1][id]
		romtable[item].z_system = AF.emulatordata[romlist].mainsysname
		romtable[item].z_emulator = romlist
	}
	return romtable
}

// Exports the rom database, romtable is the current zdb and can be db1 or db2 or both
function saveromdb(romlist,zdb,dbext){
	local dbpath = AF.romlistfolder + romlist + "." + dbext
	local dbfile = file(dbpath,"w")
	local templine = ""
	z_write_line(dbfile, "return({\n")
	foreach (item, value in zdb){
		z_write_line(dbfile, "   "+ap + item + ap + " : {\n")

		foreach (item2, value2 in value){
			if ((typeof value2 == "table") || (item2 == "z_inmfz")){
				templine = "      " + item2 + " = null\n"
			}
			else if ((typeof value2 == "array")) {
				templine = ("      "+item2+" = [")
				foreach (arrayid, arrayval in value2){
					templine += ap + arrayval + ap
					if (arrayid != value2.len()-1) templine += (",")
				}
				templine += ("]\n")
			}
			else templine = "      " + item2 + " = " + (typeof value2 == "string" ? ap + value2 + ap : value2) + "\n"
			z_write_line(dbfile, templine)
		}

		z_write_line(dbfile, "   }\n")
	}
	z_write_line(dbfile,"})\n")
	dbfile.close()
}

function updateallgamescollections(tempprf){
	if (tempprf.ALLGAMES) {
		buildconfig(tempprf.ALLGAMES, tempprf)
		update_allgames_collections(true,tempprf)
	}
}

function resetselectedromlists(tempprf){
	foreach (item, val in z_list.allromlists) {
		local listpath1 = AF.romlistfolder + item + ".db1"
		local listpath2 = AF.romlistfolder + item + ".db2"
		try {remove (listpath1)}catch(err){print("ERROR1\n")}
		try {remove (listpath2)}catch(err){print("ERROR2\n")}
		refreshromlist(item, true)
	}
	updateallgamescollections(tempprf)
}

function eraseselecteddatabase(tempprf){
	foreach (item, val in z_list.allromlists) {
		local listpath1 = AF.romlistfolder + item + ".db1"
		local listpath2 = AF.romlistfolder + item + ".db2"
		try {remove (listpath1)}catch(err){print("ERROR1\n")}
		try {remove (listpath2)}catch(err){print("ERROR2\n")}
	}
}

function resetlastplayed(){
	foreach (i, item in z_list.boot2){
		item.z_rundate = "00000000000000"
		item.z_playedcount = 0
	}

	foreach (item, val in z_list.allromlists) {
		saveromdb (item,z_list.db2[item],"db2")
	}

	//update_thumbdecor (focusindex.new,0,tilez[focusindex.new].AR.current)

	mfz_build(true)
	try {
		mfz_load()
		mfz_populatereverse()
	} catch(err){}
	mfz_apply(false)
}

// This is the function called from the options menu,
// it refreshes the current romlist, or better all the emulator romlists
// that are in the current one
// If the ALLGAMES (that is the collections) is enabled config is rebuild
// collections are updated and the layout is restarted (in update_allgames_collections or manually)
function refreshselectedromlists(tempprf){
	foreach (item, val in z_list.allromlists) {
		refreshromlist(item, false)
	}
	if (tempprf.ALLGAMES) {
		buildconfig(tempprf.ALLGAMES, tempprf)
		update_allgames_collections(true,tempprf)
	}
	// this function doesn't need to reboot the layout
	// since it's run from the options menu where reboot
	// is triggered with the "back back" signal response
}


function regionsfromfile(title){

	local filenameregions = ""
   local filenameregionsarray = []
   local regionnames = ["World","USA","Europe","Japan","Italy","France","Germany","Spain","Korea","Taiwan","Asia","Australia","Brazil","Canada","China","Denmark","Finland","Netherlands","Portugal","United Kingdom","Russia","Sweden","Turkey"]
   local regionshort = ["wor","us","eu","jp","it","fr","de","sp","kr","tw","asi","au","br","ca","cn","dk","fi","nl","pt","uk","ru","se","tr"]

	local regionsubstring = ""
   try{regionsubstring = split(title, "(")[1]}catch(err){}

	   foreach (id, item in regionnames){
      if (regionsubstring.find(item) != null){
         filenameregionsarray.push(regionshort[id])
      }
   }

   for (local i = 0 ; i < filenameregionsarray.len()-1;i++){
      filenameregions = filenameregions + filenameregionsarray[i]+","
   }
   try{filenameregions = filenameregions + filenameregionsarray[filenameregionsarray.len()-1]}catch(err){}

	return (filenameregions)
}

function splitlistline(str_in){

	local intoken = false
	local i = 0
	local str_char = ""
	local str_len = str_in.len()
	local str_out = ""
	local listfields = []

	while (i < str_len){
		str_char = str_in[i].tochar()
		if ((str_char == ";") && (intoken)){
			str_out = str_out + "🧱"
			i++
			continue
		}

		if ((str_char == ap) && (intoken)) {
			if (i == str_len-1) {
				intoken = false
				i++
				continue
			}
			else if(str_in[i+1].tochar()==";"){
				intoken = false
				i++
				continue
			}
			else {
				str_out = str_out + str_char
				i++
				continue
			}
		}

		if ((str_char == ap) && (i == 0)) {
			intoken = true
			i++
			continue
		}

		if ((str_char == ap) && (!intoken)){
			if (str_in[i-1].tochar() == ";") {
				intoken = true
				i++
				continue
			}
			else {
				str_out = str_out + str_char
				i++
				continue
			}
		}

		str_out = str_out + str_char
		i++
	}

	listfields = split_complete(str_out,";")

	foreach (i, item in listfields){
		listfields[i] = subst_replace(item,"🧱",";")
	}


	return listfields

}

// This function updates the AM romlist using attract command line options
// then uses the data from the repopulated romlist to add the new metadata
// It doesn't wipe the existing metadata and is used when adding/removing roms
// If AF collections are enabled it then updates all the collections
function refreshromlist(romlist, fulllist){
	// Update romlist using AM
	if (OS == "Windows") system ("attractplus-console.exe --build-romlist "+ ap + romlist + ap + " -o "+ ap + romlist + ap)
	else if (OS == "OSX") system ("./attractplus --build-romlist "+ ap + romlist + ap + " -o "+ ap + romlist + ap)
	else system ("attractplus --build-romlist "+ ap + romlist + ap + " -o "+ ap + romlist + ap)

	local listpath = AF.romlistfolder + romlist + ".txt"
	local listfile = ReadTextFile(listpath)
	local listline = listfile.read_line() //skip beginning headers
	local listfields = []
	local gamename = ""

	if (!z_list.db1.rawin(romlist)) z_list.db1.rawset(romlist,{})
	if (!z_list.db2.rawin(romlist)) z_list.db2.rawset(romlist,{})

	while (!listfile.eos()){
		listline = listfile.read_line()
		listfields = splitlistline(listline)
		gamename = listfields[0]

		if (fulllist || !z_list.db1[romlist].rawin(gamename)){
			z_list.db1[romlist].rawset(gamename,{})

			z_list.db1[romlist][gamename] = clone (z_fields1)
			z_list.db1[romlist][gamename].z_title = subst_replace(listfields[1],ap,"'")
			z_list.db1[romlist][gamename].z_year = listfields[4]
			z_list.db1[romlist][gamename].z_manufacturer = subst_replace(listfields[5],ap,"'")
			z_list.db1[romlist][gamename].z_category = listfields[6]
			z_list.db1[romlist][gamename].z_players = listfields[7]
			z_list.db1[romlist][gamename].z_rotation = listfields[8]
			z_list.db1[romlist][gamename].z_control = listfields[9]
			z_list.db1[romlist][gamename].z_buttons = subst_replace(listfields[16],ap,"'")
			try{z_list.db1[romlist][gamename].z_series = subst_replace(listfields[17],ap,"'")}catch(err){}
			try{z_list.db1[romlist][gamename].z_region = listfields[19]}catch(err){}
			//if (z_list.db1[romlist][gamename].z_region == "") z_list.db1[romlist][gamename].z_region = regionsfromfile(gamename)

			try{z_list.db1[romlist][gamename].z_rating = listfields[20]}catch(err){}

			z_list.db1[romlist][gamename].z_name = listfields[0]
			//cleanromlist[listfields[0]].z_filename = roms[0][id]+"."+roms[1][id]
		}

		if (fulllist || !z_list.db2[romlist].rawin(gamename)){
			z_list.db2[romlist].rawset(gamename,{})
			z_list.db2[romlist][gamename] = clone (z_fields2)
			z_list.db2[romlist][gamename].z_name = listfields[0]
			//cleanromlist2[listfields[0]].z_filename = roms[0][id]+"."+roms[1][id]
		}

		// Some fields are ALWAYS updated, even if the file is already there
		z_list.db1[romlist][gamename].z_system = AF.emulatordata[romlist].mainsysname
		z_list.db1[romlist][gamename].z_emulator = romlist
		z_list.db2[romlist][gamename].z_system = AF.emulatordata[romlist].mainsysname
		z_list.db2[romlist][gamename].z_emulator = romlist

	}
	saveromdb (romlist,z_list.db1[romlist],"db1")
	saveromdb (romlist,z_list.db2[romlist],"db2")

}


// This function scans the current AM romlist and creates a dedicated db1 and db2 from the fields
// note that this must be run on a non-filtered romlist at the moment.
function portromlist(romlist){

	local favtable = {}
	local favfile = ReadTextFile(AF.romlistfolder + romlist + ".tag")
	while (!favfile.eos()){
		favtable.rawset(favfile.read_line(),true)
	}

	local playctable = {}
	local playclist = DirectoryListing (fe.path_expand(FeConfigDirectory+"stats/"+romlist),false).results
	foreach (id, item in playclist) {
		local playcount = 0
		local playcgamename = split(item,".")[0]
		local statfile = ReadTextFile(fe.path_expand(FeConfigDirectory+"stats/"+romlist+"/"+item))
		try{playcount = statfile.read_line().tointeger()}catch(err){}
		playctable.rawset(playcgamename,playcount)
	}

	local tagtable = {}
	local completedtable = {}
	local hiddentable = {}
	local taglist = DirectoryListing ((AF.romlistfolder + romlist),false).results
	foreach (id, item in taglist) {
		local tagname = split(item,".")[0]
		local tagfile = ReadTextFile (AF.romlistfolder + romlist+"/"+item)
		while (!tagfile.eos()){
			local taggame = tagfile.read_line()
			if (tagname == "COMPLETED") completedtable.rawset(taggame,true)
			else if (tagname == "HIDDEN") hiddentable.rawset(taggame,true)
			else {
				if (tagtable.rawin(taggame)) tagtable[taggame].push (tagname)
				else tagtable.rawset(taggame,[tagname])
			}
		}
	}
	//ReadTextFile(AF.romlistfolder + romlist+".tag"))
	//while (!favfile.eos()){
		//favtable.rawset(favfile.read_line(),true)
	//}

	local cleanromlist = {}
	local cleanromlist2 = {}
	local listpath = AF.romlistfolder + romlist + ".txt"

	if (prf.MASTERLIST) listpath = prf.MASTERPATH //TEST139


	local listfile = ReadTextFile(listpath)
	local listline = listfile.read_line() //skip beginning headers
	local listfields = []
	while (!listfile.eos()){

		listline = listfile.read_line()
		if ((listline == "") || (listline[0].tochar()=="#")){
			print("")
			continue
		}

		listfields = splitlistline(listline)

		listfields[0] = strip(listfields[0])
		if(listfields[2] != romlist) continue
		//if ((listfields.len() == 1 )|| (listfields[2] != romlist)) continue
		cleanromlist[listfields[0]] <- {}
		cleanromlist[listfields[0]] = clone (z_fields1)
		cleanromlist[listfields[0]].z_title = strip(subst_replace(listfields[1],ap,"'"))
		cleanromlist[listfields[0]].z_year = listfields[4]
		cleanromlist[listfields[0]].z_manufacturer = subst_replace(listfields[5],ap,"'")
		cleanromlist[listfields[0]].z_category = listfields[6]
		cleanromlist[listfields[0]].z_players = listfields[7]
		cleanromlist[listfields[0]].z_rotation = listfields[8]
		cleanromlist[listfields[0]].z_control = listfields[9]
		cleanromlist[listfields[0]].z_buttons = subst_replace(listfields[16],ap,"'")
		try{cleanromlist[listfields[0]].z_series = subst_replace(listfields[17],ap,"'")}catch(err){}
		try{cleanromlist[listfields[0]].z_region = listfields[19]}catch(err){}
		try{cleanromlist[listfields[0]].z_rating = listfields[20]}catch(err){}

		cleanromlist[listfields[0]].z_name = listfields[0]
		//cleanromlist[listfields[0]].z_filename = roms[0][id]+"."+roms[1][id]
		cleanromlist[listfields[0]].z_system = AF.emulatordata[romlist].mainsysname
		cleanromlist[listfields[0]].z_emulator = romlist

		cleanromlist2[listfields[0]] <- {}
		cleanromlist2[listfields[0]] = clone (z_fields2)
		cleanromlist2[listfields[0]].z_favourite = favtable.rawin(listfields[0])
		cleanromlist2[listfields[0]].z_playedcount = playctable.rawin(listfields[0]) ? playctable[listfields[0]] : 0
		cleanromlist2[listfields[0]].z_completed = completedtable.rawin(listfields[0])
		cleanromlist2[listfields[0]].z_hidden = hiddentable.rawin(listfields[0])
		if (tagtable.rawin(listfields[0])) cleanromlist2[listfields[0]].z_tags = tagtable[listfields[0]]

		cleanromlist2[listfields[0]].z_name = listfields[0]
		//cleanromlist2[listfields[0]].z_filename = roms[0][id]+"."+roms[1][id]
		cleanromlist2[listfields[0]].z_system = AF.emulatordata[romlist].mainsysname
		cleanromlist2[listfields[0]].z_emulator = romlist

	}

	saveromdb (romlist,cleanromlist,"db1")
	saveromdb (romlist,cleanromlist2,"db2")
}

// Creates an empty romlist from current romlist
function resetromlist(){
	local string0 = "#Name;Title;Emulator;CloneOf;Year;Manufacturer;Category;Players;Rotation;Control;Status;DisplayCount;DisplayType;AltRomname;AltTitle;Extra;Buttons;Series;Language;Region;Rating"
	foreach (item, val in z_list.allromlists){

		local romdirlist = DirectoryListing (AF.emulatordata[item].rompath,false).results
		local totalroms = 0
		local cleanromdirlist = []
		foreach (id2, item2 in romdirlist){
			local ext = split(item2,".").pop() // Get file extension

			local start = item2.slice(0,2)
			if ((start != "._") && (AF.emulatordata[item].romextarray.find("."+ext)!=null)) { // Check if extension is in the .cfg list
				local gname = item2.slice(0,-1*(ext.len()+1))
				totalroms++
				cleanromdirlist.push(gname+";"+gname+";"+item+";;;;;;;;;;;;;;;;;;")
			}
		}
		cleanromdirlist.reverse()
		cleanromdirlist.insert(0,string0)

		//Save romlist
		local outfile = WriteTextFile(AF.romlistfolder + item + ".txt")
		foreach (id4, item4 in cleanromdirlist){
			outfile.write_line(item4+"\n")
		}
		outfile.close_file()
	}
	fe.set_display(fe.list.display_index)
}

function cleandatabase(temppref){

	if (temppref.MASTERLIST) {
		z_edit_dialog("Not possible when master romlist is enabled")
		return
	}

	z_splash_message("Cleanup...")

	local has_emulator = false
	local has_romlist = false
	local filepresent = false
	local todolist = []
	foreach(item, val in z_list.db1){
		z_splash_message(item+"\nCleaning Database")

		// Check if each db entry has an emulator and a romlist
		has_emulator = file_exist(FeConfigDirectory+"emulators/"+item+".cfg")
		has_romlist = file_exist(AF.romlistfolder+item+".txt")

		// If not delete this db main entry
		if (!(has_emulator && has_romlist)) {
			z_list.db1.rawdelete(item)
			z_list.db2.rawdelete(item)
			// Dovrei cancellare il file effettivo
		} else {
			// The entry has emulator and romlist, let's scan games
			foreach (item2, val2 in val){
				filepresent = false
				foreach (i3, item3 in AF.emulatordata[item].romextarray){
					if (file_exist (AF.emulatordata[item].rompath+item2+item3)) {
						filepresent = true
						break
					}
				}
				if (!filepresent) {
					z_list.db1[item].rawdelete(item2)
					z_list.db2[item].rawdelete(item2)
				}
			}
		}
	}

	// Now save the updated db files
	foreach(item, val in z_list.db1){
		z_splash_message(item+"\nRefresh Romlist [ ]\nUpdate Database [ ]")
		refreshromlist(item,false)
		z_splash_message(item+"\nRefresh Romlist [*]\nUpdate Database [ ]")
		saveromdb(item, z_list.db1[item], "db1")
		z_splash_message(item+"\nRefresh Romlist [*]\nUpdate Database [*]")
		saveromdb(item, z_list.db2[item], "db2")
	}
	if (temppref.ALLGAMES) {
		buildconfig(temppref.ALLGAMES, temppref)
		update_allgames_collections(true,temppref)
	}
	z_splash_message("All Done")
	//restartAM()
}


// Routine that returns an emty copy of the game data table
// the result can be applied with rawset
// this might be corrected with reference to the emulator and
// update of the emulator field...
// NOT USED!
function creategametable(){
	timestart("creategametable")
	local out = {}
	foreach (item, val in z_fields1){
		out.rawset (item, val)
	}
	foreach (item, val in z_fields2){
		out.rawset (item, val)
	}
	timestop("creategametable")
	return out
}



local focusindex = {
	new = 0
	old = 0
}

/// Metadata initialisation and functions ///

local catnames = getcatnames()
local catnames_SS = getcatnames_SS()
local yearnames = getyears()

local metadata = {
	path = null
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
				yearnames,
				"string",
				catnames,
				["1","2","3","4","5","6","7","8"],
				["Horizontal","Vertical","0","90","270","180"],
				["1","2","3","4","5","6","7","8"],
				"string",
				["10.0","9.5","9.0","8.5","8.0","7.5","7.1","6.5","6.0","5.5","5.0","4.5","4.0","3.5","3.0","2.5","2.0","1.5","1.0","0.5","0.0"],
				"string",
				"string"
				]
}

metadata.names = ltxtarray(metadata.names,AF.LNG)

local meta_edited = {}
local meta_original = {}
local all_meta_edited = {}
local all_meta_original = {}
local all_scrape = {}

// This routine loads data from the meta_edited file in current romlist (soon to be replaced to sweep all romlists)
// then the data is added to a master all_meta_edited table where each field is the current romlist (emulator) name
// With this change all metadata load/save/update operations must reference the current romlist field to get and save
// data in the correct path
/*
metadata.path = AF.romlistfolder + fe.displays[fe.list.display_index].romlist+".meta")
try {meta_edited = dofile(metadata.path)}catch(err){}
if (meta_edited.len() > 0){
	all_meta_edited[fe.displays[fe.list.display_index].romlist] <- meta_edited
}
*/
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
		try {
			mfz_load()
			mfz_populatereverse()
			} catch(err){}
		mfz_apply(true)
*/


function metachanger(gamename, romlist, meta_new, metavals, metaflag, result){
	local meta_changed = (meta_new != metavals[result])
	if (meta_changed && (meta_new != "")) {

		if ( metaflag[result]) {
			// Caso 1: il metadato era già stato editato in precedenza
			all_meta_edited[romlist][gamename][metadata.ids[result]] <- meta_new
		}
		else {
			// Caso 2: il metadato era in stato "original" e viene editato per la prima volta

			// Aggiungi dato all'original:
			if (!all_meta_original.rawin(romlist)){
				all_meta_original[romlist] <- {}
			}
			if (!all_meta_original[romlist].rawin(gamename)){
				all_meta_original[romlist][gamename] <- {}
			}
			all_meta_original[romlist][gamename][metadata.ids[result]] <- metavals[result]

			// Aggiungi dato all'edited:
			if (!all_meta_edited.rawin(romlist)){
				all_meta_edited[romlist] <- {}
			}
			if (!all_meta_edited[romlist].rawin(gamename)){
				all_meta_edited[romlist][gamename] <- {}
			}
			all_meta_edited[romlist][gamename][metadata.ids[result]] <- meta_new

		}
		metamenu(result)
	}
	if (meta_new == ""){
		try{
			z_list.db1[romlist][gamename].rawset(metadata.ids[result],all_meta_original[romlist][gamename][metadata.ids[result]])
			all_meta_edited[romlist][gamename].rawdelete(metadata.ids[result])
			if (all_meta_edited[romlist][gamename].len() == 0){
				all_meta_edited[romlist].rawdelete(gamename)
			}
		} catch(err){}
		metamenu(result)
	}
}

function metamenu(starter){
	// Initialise metadata structures

	metadata.sub[3] = systemSSarcade(z_list.gametable[z_list.index].z_system) ? catnames : catnames_SS

	local metavals = []
	local metanotes = []
	local metaglyphs = []
	local metaflag = []

	local gamename = z_list.gametable[z_list.index].z_name
	local romlist = z_list.gametable[z_list.index].z_emulator

	foreach (id, item in metadata.ids){
		metavals.push (z_list.gametable[z_list.index][item])
		try {metavals[id] = all_meta_original[romlist][gamename][item]}catch(err){}
		try {metavals[id] = all_meta_edited[romlist][gamename][item]}catch(err){}
		metaglyphs.push(0)

		metaflag.push(false)
		try {
			if (all_meta_edited[romlist][gamename][item] != "") {
				metaglyphs[id] = 0xe905
				metaflag[id] = true
			}
		}catch(err){}
		metanotes.push (metavals[id])
	}
	zmenudraw (metadata.names,metaglyphs,metanotes, ltxt("Game Metadata",AF.LNG),0xe906,starter,false,false,false,false,false,
	function (result){



		if (result != -1) {
			local meta_unedited = ""
			try {meta_unedited = all_meta_original[romlist][gamename][metadata.ids[result]] }catch(err){
				meta_unedited = metavals[result]
			}
			local meta_new = ""
			if (typeof metadata.sub[result] == "string") {
				meta_new = fe.overlay.edit_dialog (metadata.names[result]+" value:\n("+meta_unedited+")",metavals[result])
				metachanger (gamename, romlist, meta_new, metavals, metaflag, result)
			}
			else if (typeof metadata.sub[result] == "array"){

				local current_index = metadata.sub[result].find(metavals[result])
				if (current_index != null) current_index = current_index+2 else current_index = 0
				local metaarray = []
				local metanotes = []
				local metaglyphs = []

				metaarray.push (ltxt("Original",AF.LNG))
				metanotes.push (meta_unedited)
				metaglyphs.push (0xe965)

				metaarray.push (ltxt("Values",AF.LNG))
				metanotes.push ("")
				metaglyphs.push (-1)

				foreach (i, item in metadata.sub[result]) {
					metaarray.push (metadata.sub[result][i])
					metanotes.push ("")
					metaglyphs.push (0)
				}
				zmenudraw(metaarray,metaglyphs,metanotes,metadata.names[result],0xe906,current_index,false,false,false,false,false,
				function (result2){
					if (result2 == -1) {
						metamenu (result)
					}
					else if (result2 == 0){
						meta_new = ""
						metachanger (gamename, romlist, meta_new, metavals, metaflag, result)
					}
					else {
						meta_new = metadata.sub[result][result2 - 2]
						metachanger (gamename, romlist, meta_new, metavals, metaflag, result)
					}
				})
			}
			else if (typeof metadata.sub[result] == "table"){
				local metaarray = []
				local metanotes = []
				local metaglyphs = []

				metaarray.push (ltxt("Original",AF.LNG))
				metanotes.push (meta_unedited)
				metaglyphs.push (0xe965)

				metaarray.push (ltxt("Manual entry",AF.LNG))
				metanotes.push ("")
				metaglyphs.push (0xe955)

				metaarray.push (ltxt("Values",AF.LNG))
				metanotes.push ("")
				metaglyphs.push (-1)

				foreach (i, item in metadata.sub[result].names) {
					metaarray.push (metadata.sub[result].names[i])
					metanotes.push (metadata.sub[result].table[ metadata.sub[result].names[i] ].len() > 1 ? "...":"")
					metaglyphs.push (0)
				}

				zmenudraw(metaarray,metaglyphs,metanotes,metadata.names[result],0xe906,0,false,false,false,false,false,
				function (result2){
					if (result2 == -1) {
						metamenu (result)
					}
					else if (result2 == 0){
						meta_new = ""
						metachanger (gamename, romlist, meta_new, metavals, metaflag, result)
					}
					else if (result2 == 1){ //keyboard entry
						meta_new = fe.overlay.edit_dialog (metadata.names[result]+" value:\n("+meta_unedited+")",metavals[result])
						metachanger (gamename, romlist, meta_new, metavals, metaflag, result)
					}
					else {
						local tempname = metadata.sub[result].names[result2 - 3]
						local temparray = metadata.sub[result].table[tempname]

						if (temparray.len() == 1){
								meta_new = temparray[0]
								metachanger (gamename, romlist, meta_new, metavals, metaflag, result)
						}
						else {
							local metaarray2 = []
							metaarray2.push (tempname)
							foreach (i, item in temparray) {
								metaarray2.push (temparray[i] )
							}
							zmenudraw(metaarray2,null,null,metadata.names[result],0xe906,0,false,false,false,false,false,
							function (result3){
								if (result3 == -1) {
									metamenu (result)
								}
								else {
									meta_new = metaarray2[result3]
									metachanger (gamename, romlist, meta_new, metavals, metaflag, result)
								}
							})
						}

					}
				})

			}
		}
		else {
			frosthide()
			zmenuhide()

			local outfile = WriteTextFile (AF.romlistfolder + romlist+".meta")

			outfile.write_line("return({\n")

			if (all_meta_edited.rawin(romlist)){
				foreach (item, val in all_meta_edited[romlist]){
					outfile.write_line("   " + ap + item + ap + " : {\n")
					foreach (item2, val2 in val){
						outfile.write_line ("      "+item2+" = "+ap+val2+ap+"\n")
					}
					outfile.write_line("   }\n")
				}
			}
			outfile.write_line("})\n")
			outfile.write_line("\n")
			outfile.close_file()

			z_listboot()
			buildcategorytable()
			mfz_build(true)
			try {
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
	local tempemu = ""
	for (local i = 0; i < fe.list.size; i++){
		tempemu = fe.game_info(Info.Emulator,i)
		if (!romlist_table.rawin(tempemu)) romlist_table [tempemu] <- 1
	}
	if (romlist_table.len() == 0) romlist_table[fe.displays[fe.list.display_index].romlist] <- 1
	return romlist_table
}

z_list.allromlists = allromlists()

// Proxy function that replicates in z_list.tagstable the tags folder files
// This is created with each mfz_apply() function so from then on, list creation
// uses the data in memory and not from disk

// When a tag is created or deleted, the system updates the files and the
// disk, then mfz_apply() is used to run z_updatetagstable and after that
// listcreate is run

function z_updatetagstable(){
	timestart("    z_updatetagstable")
	// Clear the tags table
	z_list.tagstable = {}
	z_list.tagstableglobal = {}

	foreach (id, item in z_list.boot2){
		foreach (id2, item2 in item.z_tags){
			z_list.tagstable.rawset(item2,0)
		}
	}

	foreach (itemname, value in z_list.db2){
		foreach (id, item in z_list.db2[itemname]){
			foreach (id2, item2 in item.z_tags){
				z_list.tagstableglobal.rawset(item2,0)
			}
		}
	}
	/*
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
				tagsnamesarray.push (tagsarray[i].slice(0,tagsarray[i].len()-4))
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
	*/
	timestop ("    z_updatetagstable")
}

function z_initfavsfromfiles(){
	// Clear the favs table
	z_list.favsarray = []

	foreach (romlistid, val in z_list.allromlists){
		local favfile = (FeConfigDirectory+"romlists/"+romlistid+".tag")
		local favfilepresent = (fe.path_test( favfile, PathTest.IsFile ))

		// No favs at all are present
		if (!favfilepresent) continue

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

// Initialize tags table, favs table, rundate and favdate data.
// These tables are used in the layout instead of standard fav and
// tag properties with the custom fav and tag menu

z_updatetagstable()

z_list.ratingtable = prf.INI_BESTGAMES_PATH == "" ? {} : extradatatable(prf.INI_BESTGAMES_PATH)


// returns an array of tags for the game at "offset" reading from the list table (faster)
/*
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
*/
// returns favourite state for the game at "offset" reading from the list table (faster)
/*
function z_getfavs(offset){
	local romname = z_list.boot[offset + fe.list.index].z_name
	local emulatorname = z_list.boot[offset + fe.list.index].z_emulator
	// Now check in the whole favs structure
	return ((z_list.favsarray.find(emulatorname + " " + romname) != null) ? "1" : "0")
}
*/
/*
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
*/

function z_getmamerating(gamename){
	local out = ""
	if (z_list.ratingtable.rawin(gamename)){
		out = ratetonumber[z_list.ratingtable[gamename]]
		if ((out.find(".")==null) && (out.len()>0)) out=out+".0" //TEST126 is adding .0 needed?
	}
	return out
}

function parsecommands(instring){
	local str_array = split(instring,";")
	local btn_array = []
	foreach (i,item in str_array) {
		local cleanitem = subst_replace(item,"::",": :")
		if ( cleanitem.find("P1_BUTTON") == 0 ) btn_array.push (split_complete(cleanitem,":")[2] == " " ? "" : split_complete(cleanitem,":")[2])
	}
	return btn_array
}
/*
P1_COIN:White:
P1_START:White:
P1_BUTTON1:Red:
P1_BUTTON2:Yellow:
P1_BUTTON3:Green:
P1_BUTTON4:Blue:
P1_JOYSTICK:Black:
P2_COIN:White:
P2_START:White:
P2_BUTTON1:Red:
P2_BUTTON2:Yellow:
P2_BUTTON3:Green:
P2_BUTTON4:Blue:
P2_JOYSTICK:Black:
*/

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

			local v = z_list.boot2[index+fe.list.index].z_tags // z_gettags(index,false)
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

			local v = z_list.boot[index+fe.list.index].z_manufacturer.tolower()

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

			local v = z_list.boot2[index+fe.list.index].z_favourite//z_getfavs(index) //fe.game_info(Info.Favourite,index)

			return ({
				l1val = (v ? "1 - Favourite" : "2 - Not Favourite")
				l1array = false
				l1name = (v ? "Favourite" : "Not Favourite")
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

			local v = z_list.boot2[index+fe.list.index].z_playedcount
			return ({
				l1val = (v == 0 ? "2 - Not Played" : "1 - Played")
				l1array = false
				l1name = (v == 0 ? "Not Played" : "Played")
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
			local v2 = "??"
			if (v == "") {
				v = "??"
			}
			else {
				try{v2 = format ("%05.1f",v.tofloat())}catch(err){}
			}
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

multifilterz.l0["Scraped"] <- {
		label = ""
		filtered = false
		translate = false
		sort = true
		menu = {}
		levcheck = function(index){
			//local out = {l1val = null, l1array = false, l1name = null, sub = null, l2val = null, l2name = null}

			local v = z_list.boot[index+fe.list.index].z_scrapestatus
			if (v == "") v = "?"

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


multifilterz.l0["Region"] <- {
		label = ""
		filtered = false
		translate = false
		sort = true
		menu = {}
		levcheck = function(index){
			//local out = {l1val = null, l1array = false, l1name = null, sub = null, l2val = null, l2name = null}

			local v = z_list.boot[index+fe.list.index].z_region
			// ALTERNATIVE MODE: splits all and adds the complete, ATTENTION: turn l1array to true
			/*
			local v0 = z_list.boot[index+fe.list.index].z_region
			if (v0 == "") v0 = "None"
			local v = split_complete(v0,",") // z_gettags(index,false)
			if (v.len() != 0) v.insert(0,v0) else v = [v0]
			*/

			if (v == "") v = "None"

			// Return data when no category is selected
			//if (v.len()==0) return {l1val = "None", l1array = false, l1name = "None", sub = false, l2val = null, l2name = null}

			return ( {
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
		if (multifilterz.filter.rawin(item)){
			if (multifilterz.filter[item].len() > 0) return true
		}
	}
	return false
}

function mfz_num(){
	local out = 0
	foreach (item,table in multifilterz.l0){
		if (multifilterz.filter.rawin(item)){
			if (multifilterz.filter[item].len() > 0) out ++
		}
	}
	return out
}

function mfz_build (reset){
	timestart("mfz_build")
	debugpr("mfz_build reset:" + reset+"\n")

	// Reset all menu data
	foreach (item,table in multifilterz.l0){
		if (reset) {
			if (multifilterz.filter.rawin(item)) multifilterz.filter[item] = []
			else multifilterz.filter.rawset(item,[])
		}
		try {table.menu.clear()}catch(err){print("\nERROR!\n")}
		multifilterz.l0[item].label = ltxt(item,AF.LNG)
	}

	// Scan the whole romlist
	for (local i = 0 ; i < fe.list.size ; i++) {
		//testpr(0xeafb+floor(i*10.0/(fe.list.size-1))+"\n")
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
	timestop("mfz_build")
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
		if (multifilterz.filter.rawin(id0)) multifilterz.filter[id0] = []
		else multifilterz.filter.rawset(id0,[])
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
			if (multifilterz.filter.rawin(id0)){
				if (multifilterz.filter[id0].find(table1.filtervalue) != null) {
					table1.filtered = true
				}
			}
			else {table1.filtered = false} //TEST128 questo va qui, o dentro l'if precedente?

			if (table1.submenu != null){
				if (multifilterz.filter.rawin(id0)){ //TEST128
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
	}
	timestop("mfz_populatereverse")
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
	local outAND = true
	local vtemp = null
	local metafilter = {}

	foreach (id0, table0 in multifilterz.l0){
		outOR = false
		metafilter.rawset(id0,outOR)
		if (multifilterz.filter.rawin(id0)){
			if (multifilterz.filter[id0].len() > 0){ //Filter is applied on this category
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
				} // foreach is broken if one match inside the category is true

				// metafilter is populated with the outOR value for current id0
				metafilter.rawset(id0,outOR)

				// This substitutes the outAND check: if at least one outOR is not true,
				// then the outAND is obviously false and the item is not "infilter"
				// but this stops the sweep of id0 for this game!
				/*
				if (outOR == false){
					return (false)
				}
				*/
				outAND = outAND && outOR
			}
		}
	}
	local outtable = {
		inmfz = outAND
		meta = metafilter
	}
	return (outtable)
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
			outindex.sort(@(a,b) ltxt(a,AF.LNG).tolower() <=> ltxt(b,AF.LNG).tolower())
			outnames.sort(@(a,b) ltxt(a,AF.LNG).tolower() <=> ltxt(b,AF.LNG).tolower())
			outglyph.sort(@(a,b) ltxt(a,AF.LNG).tolower() <=> ltxt(b,AF.LNG).tolower())
			outnumbr.sort(@(a,b) ltxt(a,AF.LNG).tolower() <=> ltxt(b,AF.LNG).tolower())
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
			outnames[i] = ltxt(outnames[i],AF.LNG)
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
	debugpr("mfz_refreshnum "+ catin+"\n")
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
		bar_update(i,0,z_list.boot.len())

		foreach (id0, table0 in multifilterz.l0){
			// Call the function that return the menu entry for the current game
			local vals = table0.levcheck(i - fe.list.index)
			local inmfz = true
			if (typeof z_list.boot[i].z_inmfz.meta == "table"){
				foreach (item, val in z_list.boot[i].z_inmfz.meta){
					if (multifilterz.filter.rawin(item)){
						if ((multifilterz.filter[item].len() > 0) && (item != catin))
							inmfz = inmfz && val
					}
				}
			}
			//if ((z_list.boot[i].z_inmfz || (id0 == catin)) && (z_list.boot[i].z_insearch) && (z_list.boot[i].z_incat) && (z_list.boot[i].z_inmots2)) {
			if (inmfz && (z_list.boot[i].z_infav && z_list.boot[i].z_insearch) && (z_list.boot[i].z_incat) && (z_list.boot[i].z_inmots2)) {
			//if (mfz_checkin(i-fe.list.index,catin) && (z_list.boot[i].z_insearch) && (z_list.boot[i].z_incat) && (z_list.boot[i].z_inmots2)) {
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
	timestop("mfz_refreshnum")
}

function mfz_menu2(presel){

	//2nd level menu is never translated and is always sorted by value

	local valcurrent = null

	if (z_list.size > 0) multifilterz.l0[mf.cat0].levcheck(z_list.gametable[z_list.index].z_felistindex - fe.list.index)

	local mfzdat = mfz_menudata(multifilterz.l0[mf.cat0].menu[mf.cat1].submenu , 2, false,true)
	local namearray = mfzdat.names
	local indexarray = mfzdat.index
	local filterarray = mfzdat.glyph
	local numberarray = mfzdat.numbr

	namearray.insert(0,ltxt("ALL",AF.LNG))
	namearray.insert(0,ltxt("CLEAR",AF.LNG))

	indexarray.insert(0,0)
	indexarray.insert(0,0)

	filterarray.insert(0,multifilterz.l0[mf.cat0].menu[mf.cat1].filtered ? 0xea52 : 0)
	filterarray.insert(0,0xea0f)

	numberarray.insert (0,"")
	numberarray.insert (0,"")

	if (valcurrent != null) {
		if ((valcurrent.l1name == mf.cat1) && (presel==0)) presel = indexarray.find(valcurrent.l2name)
	}

	zmenudraw (namearray,filterarray, numberarray,mf.cat1,0xeaed,presel,false,false,false,false,false,
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
			mfz_apply(false)
			mfz_save()

		}
	},
	null, //LEFT
	function(){ //RIGHT
		zmenunavigate_down("right",true)
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

	namearray.insert(0,ltxt("CLEAR",AF.LNG))
	indexarray.insert(0,0)
	filterarray.insert(0,0xea0f)
	numberarray.insert (0,"")


	if(presel == -1) {
		if ((valcurrent != null) && !(valcurrent.l1array)) {
			presel = indexarray.find(valcurrent.l1name)
		}
		else {
			presel = 0
		}
	}

/*
	if (valcurrent == null) {
		if (presel == -1) presel = 0
	}
	else {
		if ((presel == -1) && !(valcurrent.l1array)) presel = indexarray.find(valcurrent.l1name)
		else if (presel == -1) presel = 0
	}
*/
	zmenudraw (namearray,filterarray,numberarray,multifilterz.l0[mf.cat0].label,0xeaed,presel,false,false,false,false,false,
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
				mfz_apply(false)
//				mfz_refreshnum(null)
				mfz_save()

			}
			else { // this is a multilevel entry
				mfz_menu2(0)
			}


		}
	},
	null, //LEFT
	function(){ //RIGHT
		zmenunavigate_down("right",true)
	})
}

function mfz_menu0(presel){
	// Level zero menu is always translated and sorted by value
 	zmenu.mfm = true

	local mfzdat = mfz_menudata(multifilterz.l0, 0,true,true)
	local namearray = mfzdat.names
	local indexarray = mfzdat.index
	local filterarray = mfzdat.glyph

	namearray.insert(0,ltxt("CLEAR",AF.LNG))
	indexarray.insert(0,0)
	filterarray.insert(0,0xea0f)

	zmenudraw (namearray,filterarray,null,ltxt("Multifilter",AF.LNG),0xeaed,presel,false,false,false,false,false,
	function(out){
		if (out == -1){ // Exit from multifilter menu
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
		else if (out == 0) { // First selection: clear the whole filter
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
		else { // Any other selection triggers the level 1 menu
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
	local defresult = loadtablefromfile("mf_"+ aggregatedisplayfilter() +".txt",true)

	if (defresult != null) tempresult = defresult

	if ((tempresult == null) || (!prf.SAVEMFZ)){
		multifilterz.filter = loadtablefromfile("pref_mf_0.txt",true)
	}
	else {
		multifilterz.filter = tempresult
	}
}

function z_list_updategamedata(index){

	// In realtà questo è il current, basta evitare casi di lista vuota
	if (z_list.size == 0) return
	dat.manufacturer_array[dat.stacksize - 1].msg = manufacturer_vec_name (z_list.boot[index].z_manufacturer,z_list.boot[index].z_year)
	dat.cat_array[dat.stacksize - 1].file_name = category_pic_name (z_list.boot[index].z_category)
	if (!prf.CLEANLAYOUT) dat.manufacturername_array[dat.stacksize - 1].visible = (dat.manufacturer_array[dat.stacksize - 1].msg == "")
	dat.but_array[dat.stacksize - 1].file_name = (AF.folder+"metapics/buttons/" + z_list.boot[index].z_buttons+"button.png")
	dat.ply_array[dat.stacksize - 1].file_name = (AF.folder+"metapics/players/players_" + z_list.boot[index].z_players+".png")
	dat.ctl_array[dat.stacksize - 1].file_name = (AF.folder+"metapics/controller/"+controller_pic (z_list.boot[index].z_control))

	dat.mainctg_array[dat.stacksize - 1].msg = maincategorydispl(index)
	dat.gamename_array[dat.stacksize - 1].msg = gamename2(index)

	dat.gamesubname_array[dat.stacksize - 1].msg = gamesubname(index)
	dat.gameyear_array[dat.stacksize - 1].msg = gameyearstring (index)
	dat.manufacturername_array[dat.stacksize - 1].msg = gamemanufacturer (index)
}

// Applies the multifilter to the romlist updating all the tiles
function mfz_apply(startlist){
	timestart("mfz_apply")
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
			try {bootlist_index_remap = z_list.gametable[z_list.index + 1].z_felistindex}catch(err){}
		else
			try {bootlist_index_remap = z_list.gametable[z_list.index - 1].z_felistindex}catch(err){}
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

	data_freeze(false) //TEST142
	//TEST120 THIS WAS ADDED DON't REMEMBER WHY...
	/*
			z_listrefreshtiles()
			updatebgsnap (focusindex.new)
	*/

	timestop("mfz_apply")
}

local searchdata = null

local	search = {
	smart = "" // This is the main search field for smart search
	catg = ["",""] // This is the search field from category menu
	mots = ["",""]
	mots2string = [""]
	fav = false // This is true if favourite filter is on
}

function updatesearchdatamsg(){
	local textarray = [""]
	if (search.catg[0] != "") textarray.push( "📁:"+search.catg[0]+(search.catg[1] == "" ? "" : "/"+search.catg[1]) )
	if (search.smart != "")	textarray.push ( "🔍:"+search.smart )
	if (search.mots2string != "")	textarray.push ( "🔎"+search.mots2string )
	if (search.fav)	textarray.push ( "★" )

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

	checkstr = z_list.boot[index + fe.list.index].z_name.tolower()
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

function z_favfilter(index){

	if (!search.fav) return true

	return (z_list.boot2[index + fe.list.index].z_favourite)
}

function z_mots2filter(index){

	if (search.mots[0] == "") return true //TEST92 DA VERIFICARE
	local currentval = ""

	//TEST110 maybe this can be controlled with a parameter in search.mots
	try{
		currentval = z_list.boot[index + fe.list.index][search.mots[0]]
	} catch (err){
		currentval = z_list.boot2[index + fe.list.index][search.mots[0]]
		if (typeof currentval != "array") currentval = currentval.tostring()
	}

	if (search.mots[0] == "z_tags") return (currentval.find(search.mots[1]) != null)
	else return (currentval.find(search.mots[1]) == 0)

	return false

}

function z_checkhidden(i){
	if (z_list.boot2.len()>0) return z_list.boot2[i + fe.list.index].z_hidden
	return false
}

function getallgamesdb(logopic){
	timestart("GamesDB")
	/*XXXXXX
	local numchars = 15
	local text_ratio = 0.6
	local text_charsize = text_ratio*logopic.width*1.45/numchars
	local textobj = fe.add_text("",logopic.x+logopic.width*(1.0-text_ratio)*0.5,logopic.y+logopic.height-text_charsize*0.5,logopic.width*text_ratio,text_charsize*1.2)
	textobj.char_size = text_charsize
	textobj.font = uifonts.mono
	textobj.word_wrap = false
	//textobj.set_bg_rgb(200,0,0)
*/

	local textobj = null

		local numchars = 12
		local text_ratio = 0.6
		local text_charsize = text_ratio*fl.w*1.45/numchars

	if (prf.SPLASHON) {
		textobj = fe.add_rectangle(fl.x,fl.y,fl.w,fl.h)
		textobj.alpha = 128
		textobj.set_rgb(0,0,0)
	} else {
		//textobj = fe.add_text("",logopic.x+logopic.width*(1.0-text_ratio)*0.5,logopic.y+logopic.height-text_charsize*0.5,logopic.width*text_ratio,text_charsize*1.2)
		textobj = fe.add_text("",fl.x,fl.y,fl.w,fl.h)
		textobj.char_size = text_charsize
		textobj.font = uifonts.mono
		//textobj.set_bg_rgb(255,0,0)
		textobj.word_wrap = true
	}

	local emulatorarray = []
	local emulatorpath = fe.path_expand(FeConfigDirectory + "emulators/")
	local emulatordir = DirectoryListing(emulatorpath,false).results
	local file = ""
	local itemname = ""


	foreach(i, item in emulatordir) {

		if ((item.slice(-3)=="cfg") && (item.slice(0,2) != "._")){
			itemname = item.slice(0,-4)
			AF.emulatordata.rawset(itemname, getemulatordata(item))

			// The originating romlist doesn't exist, it must be created
			/*
			if (!file_exist(AF.romlistfolder + itemname + ".txt")){
				refreshromlist(itemname, true)
			}
			if (!file_exist(AF.romlistfolder + itemname + ".db1")) {
				portromlist(itemname)
			}
			fe.overlay.splash_message("Initialising... "+(i*100/(emulatordir.len()-1))+"%")
			z_list.db1.rawset (itemname, dofile(AF.romlistfolder + itemname + ".db1"))
			z_list.db2.rawset (itemname, dofile(AF.romlistfolder + itemname + ".db2"))
			*/

			// The emulator has a self named romlist
			if (file_exist(AF.romlistfolder + itemname + ".txt") || prf.MASTERLIST) { //TEST139 If we are in masterlist keep scanning for db
				if (!file_exist(AF.romlistfolder + itemname + ".db1")) portromlist(itemname)
				z_splash_message("")//("\n\n\n\n\n\n\n"+"NOW LOADING\n"+textrate (i,(emulatordir.len()-1),numchars)+"\n")//(i*100/(emulatordir.len()-1))+"%")
				//XXXXXX textobj.msg = textrate (i,(emulatordir.len()-1),numchars)

				if (prf.SPLASHON) {
					textobj.x = fl.x+fl.w*i*1.0/(emulatordir.len()-1)
					textobj.width = fl.w - textobj.x + fl.x
				} else {
					textobj.msg = "NOW LOADING\n" + textrate (i,(emulatordir.len()-1),numchars,"|","\\")
				}
				z_list.db1.rawset (itemname, dofile(AF.romlistfolder + itemname + ".db1"))
				z_list.db2.rawset (itemname, dofile(AF.romlistfolder + itemname + ".db2"))

				// Build global tags table
				foreach (id, item in z_list.db2[itemname]){
					foreach (id2, item2 in item.z_tags){
						z_list.tagstableglobal.rawset(item2,0)
					}
				}
			}
		}
	}

	/*
	TEST TO CHECK MULTIEMU ROMLISTS
	local romlistarray = []
	local romlistpath = fe.path_expand(FeConfigDirectory + "romlists/")
	local romlistdir = DirectoryListing(romlistpath,false).results
	local rlfile = ""
	local rlitemname = ""
	foreach(i, item in romlistdir) {
		if ((item.slice(0,3) != "AF ") && (item.slice(-3)=="txt") && (item.slice(0,2) != "._")){
			rlitemname = item.slice(0,-4)
			if (!AF.emulatordata.rawin(rlitemname)) {
				testpr("RLX:"+rlitemname+"\n")
			}
		}
	}
	*/
	textobj.visible = false
	timestop("GamesDB")
}

// create a proxy list, takes a while but should make faster filtering and sorting changes
function z_listboot(){
	timestart("z_listboot")
	debugpr("z_listboot\n")
	z_list.allromlists = allromlists()

	z_updatetagstable()
	//z_initfavsfromfiles()
	//z_initrundatefromfiles()
	//z_initfavdatefromfiles()


	//Reset meta_edited and meta_original
	meta_edited = {}
	meta_original = {}
	all_meta_edited = {}
	all_meta_original = {}
	metadata.path = ""

	//Update metadata editing structures
	foreach(item, val in z_list.allromlists){
		metadata.path = AF.romlistfolder + item + ".meta"
		try {meta_edited = dofile(metadata.path)}catch(err){}
		if (meta_edited.len() > 0){
			all_meta_edited[item] <- meta_edited // Adds a table for edited metadata
			all_meta_original[item] <- {} // Create an empty table that will be populated afterwards
		}
		meta_edited = {}
	}
	timestart("z_rawset")

/*
	foreach (item, val in z_list.allromlists){
		if (!file_exist(AF.romlistfolder + item + ".db1")) {
			portromlist(item)
		}
		z_list.db1.rawset (item, dofile(AF.romlistfolder + item + ".db1"))
		z_list.db2.rawset (item, dofile(AF.romlistfolder + item + ".db2"))
	}
*/
	timestop("z_rawset")

	z_list.boot = []
	z_list.boot2 = []

timestart("boot")
	// Update listboot with zdb data
	local ifeindex = 0
	local currentsystem = ""
	for (local i = 0 ; i < fe.list.size; i++){
		ifeindex = i - fe.list.index
		z_list.boot.push (z_list.db1[fe.game_info(Info.Emulator,ifeindex)][fe.game_info(Info.Name,ifeindex)])
		z_list.boot2.push(z_list.db2[fe.game_info(Info.Emulator,ifeindex)][fe.game_info(Info.Name,ifeindex)])
		z_list.boot[i].z_felistindex = i
		z_list.boot[i].z_fileisavailable = (fe.game_info(Info.FileIsAvailable,ifeindex) == "1")
		currentsystem = z_list.boot[i].z_system.tolower()

		//insert here system overrides, for example change controller and numbuttons using system data fields
		if (system_data.rawin(currentsystem)) {
			if (z_list.boot[i].z_control == "") z_list.boot[i].z_control = system_data[currentsystem].sys_control
			if (z_list.boot[i].z_buttons == "") z_list.boot[i].z_buttons = system_data[currentsystem].sys_buttons
		}
		//TEST126, check if it slows down the boot
			if (z_list.boot[i].z_rating == "") z_list.boot[i].z_rating = z_getmamerating(z_list.boot[i].z_name)
	}

	timestop("boot")

	z_updatetagstable()

	//apply metadata customisation
	for (local i = 0 ; i < fe.list.size; i++){
		local game_edited = false
		try {game_edited = all_meta_edited[z_list.boot[i].z_emulator][z_list.boot[i].z_name]!=null}catch(err){}

		if (game_edited) {
			all_meta_original[z_list.boot[i].z_emulator][z_list.boot[i].z_name] <- {}
			foreach (item, val in all_meta_edited[z_list.boot[i].z_emulator][z_list.boot[i].z_name]){
				all_meta_original[z_list.boot[i].z_emulator][z_list.boot[i].z_name][item] <- z_list.boot[i][item]
				z_list.boot[i][item] = val
			}
		}
	}
	timestop("z_listboot")

	//missing_manufacturer_list_vector(z_list)

}

local nolist_blanker = null
local data_surface = null
// Create the new list from current fe.list
function z_listcreate(){
	timestart("    z_listcreate")
	debugpr("LIST: Create\n")
	z_list.gametable.clear()
	z_list.gametable2.clear()
	z_list.jumptable.clear()
	z_list.index = z_list.newindex = fe.list.index

	local ireal = 0
	local ifilter = 0
	z_list.size = 0

	local felist = array(fe.list.size)

	foreach (i, item in z_list.boot){

		//bar_update(i,0,z_list.boot.len())

		local ifeindex = i - fe.list.index
		local checkfilter = true
		local checkmeta = null
		local mfz_status = {inmfz = true, meta = true}
		if (mfz_on()) {
			mfz_status = mfz_checkin(ifeindex)
			checkfilter = mfz_status.inmfz
		}
		//if (mfz_on()) checkfilter = mfz_checkin(ifeindex).inmfz

		z_list.boot[i].rawset("z_inmfz", mfz_status)
		z_list.boot[i].rawset("z_insearch", z_listsearch(ifeindex))
		z_list.boot[i].rawset("z_incat", z_catfilter(ifeindex))
		z_list.boot[i].rawset("z_inmots2", z_mots2filter(ifeindex))
		z_list.boot[i].rawset("z_infav", z_favfilter(ifeindex))

		if ((checkfilter)){
			ifilter++

			if (z_list.boot[i].z_infav &&z_list.boot[i].z_insearch && z_list.boot[i].z_incat && z_list.boot[i].z_inmots2 && (!z_list.boot2[i].z_hidden || prf.SHOWHIDDEN) ) {
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

				z_list.gametable.push(item)
				z_list.gametable2.push(z_list.boot2[i])
			}
		}
	}

	multifilterglyph.visible = mfz_on()

	nolist_blanker.visible = (z_list.size == 0)
	timestop("    z_listcreate")
}

// scrap articles from names
function nameclean (s){
	if (prf.STRIPARTICLE){
		if (s.find("The ") == 0) s = s.slice(4,s.len())
		else if (s.find("Vs. The ") == 0) s = s.slice(8,s.len())
		else if (s.find("Vs. ") == 0) s = s.slice(4,s.len())
		else if (s.find("Vs ") == 0) s = s.slice(3,s.len())
	}
	return char_replace(s,":"," ")
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
	timestart("    z_listsort")
	local blanker = "                                                            "
	if (z_list.size == 0) return

	debugpr ("LIST: Sort\n")
	z_list.orderby = orderby
	z_list.reverse = reverse

	local z_tempsort = []

	if (orderby == Info.Title)
		z_tempsort = afsortdual( z_list.gametable, z_list.gametable2,
		z_list.gametable.map(function(a){return(nameclean(a.z_title).tolower()+blanker)}),
		z_list.gametable.map(function(a){return("|"+a.z_system.tolower()+blanker)}),
		reverse)

	else if (orderby == Info.Year)
		z_tempsort = afsortdual( z_list.gametable, z_list.gametable2,
		z_list.gametable.map(function(a){return( format("%010s",sortclean(a.z_year).tolower()))}),
		z_list.gametable.map(function(a){return( "|"+nameclean(a.z_title).tolower()+blanker+"|"+a.z_system.tolower()+blanker)}),
		reverse)

	else if (orderby == Info.Manufacturer )
		z_tempsort = afsortdual( z_list.gametable, z_list.gametable2,
		z_list.gametable.map(function(a){return(sortclean(a.z_manufacturer).tolower())}),
		z_list.gametable.map(function(a){return("|"+nameclean(a.z_title).tolower()+blanker+"|"+a.z_system.tolower()+blanker)}),
		reverse)

	else if (orderby == Info.PlayedCount )
		z_tempsort = afsortdual( z_list.gametable, z_list.gametable2,
		z_list.gametable2.map(function(a){return( format("%010s",a.z_playedcount.tostring().tolower()))}),
		z_list.gametable.map(function(a){return( "|"+nameclean(a.z_title).tolower()+blanker+"|"+a.z_system.tolower()+blanker)}),
		reverse)

	else if (orderby == Info.Category )
		z_tempsort = afsortdual( z_list.gametable, z_list.gametable2,
		z_list.gametable.map(function(a){return(sortclean(a.z_category).tolower()+blanker)}),
		z_list.gametable.map(function(a){return("|"+nameclean(a.z_title).tolower()+blanker+"|"+a.z_system.tolower()+blanker)}),
		reverse)

	else if (orderby == Info.Players )
		z_tempsort = afsortdual( z_list.gametable, z_list.gametable2,
		z_list.gametable.map(function(a){return( a.z_players.tolower())}),
		z_list.gametable.map(function(a){return( "|"+nameclean(a.z_title).tolower()+blanker+"|"+a.z_system.tolower()+blanker)}),
		reverse)

	else if (orderby == Info.System)
		z_tempsort = afsortdual( z_list.gametable, z_list.gametable2,
		z_list.gametable.map(function(a){return(a.z_system.tolower()+blanker)}),
		z_list.gametable.map(function(a){return("|"+nameclean(a.z_title).tolower()+blanker)}),
		reverse)

	else if (orderby == z_info.z_rundate)
		z_tempsort = afsortdual( z_list.gametable, z_list.gametable2,
		z_list.gametable2.map(function(a){return(a.z_rundate )}),
		z_list.gametable.map(function(a){return("|"+nameclean(a.z_title).tolower()+blanker)}),
		reverse)

	else if (orderby == z_info.z_favdate)
		z_tempsort = afsortdual( z_list.gametable, z_list.gametable2,
		z_list.gametable2.map(function(a){return(a.z_favdate + a.z_favourite)}),
		z_list.gametable.map(function(a){return("|"+nameclean(a.z_title).tolower()+blanker)}),
		reverse)

	else if (orderby == z_info.z_series) {
		z_tempsort = afsortdual( z_list.gametable, z_list.gametable2,
		z_list.gametable.map(function(a){return(a.z_series.tolower())}),
		z_list.gametable.map(function(a){return(( format("%010s",sortclean(a.z_year).tolower())) + "|"+nameclean(a.z_title).tolower()+blanker + "|"+a.z_system.tolower()+blanker)}),
		reverse)
	}

	else if (orderby == z_info.z_rating) {
		z_tempsort = afsortdual( z_list.gametable, z_list.gametable2,
		z_list.gametable.map(function(a){return((a.z_rating == "" ) ? "0000000000" : format("%010u", a.z_rating.tofloat()*10))}),
		z_list.gametable.map(function(a){return("|"+nameclean(a.z_title).tolower()+blanker + "|"+a.z_system.tolower()+blanker)}),
		reverse)
	}

	z_list.gametable = z_tempsort[0]
	z_list.gametable2 = z_tempsort[1]

	if ((prf.SORTSAVE)){
		SORTTABLE [aggregatedisplayfilter()] <- [orderby,reverse]
		savetabletofile(SORTTABLE,"pref_sortorder.txt")
	}
	timestop("    z_listsort")

}

// Creates an array for prev-next jump
function z_liststops(){
	timestart("    z_liststops")
		local temp = []

	for (local i = 0 ; i < z_list.size ; i++){

		if ((z_list.orderby == Info.Title)) {
			local s = z_list.gametable[i].z_title
			if (prf.STRIPARTICLE) s = nameclean (s)
			if (s.len() > 0) s = s[0].tochar().tolower()
			else s = "#"
			if ("'1234567890".find (s) != null) s = "#"
			temp.push (s )
		}

		else if (z_list.orderby == Info.Year) {
			local s = z_list.gametable[i].z_year.tolower()
			if ((s != "") && (s.len()>3)) s = s.slice(0,3)+"x"
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


		else if (z_list.orderby == Info.PlayedCount ) temp.push( z_list.gametable2[i].z_playedcount.tostring().tolower())

		else if (z_list.orderby == z_info.z_rundate ){
			local rdate = z_list.gametable2[i].z_rundate.tostring()
			if (rdate == "00000000000000") temp.push("?")
			else {
				temp.push( "'"+rdate.slice(2,4)+"/"+(100+(rdate.slice(4,6).tointeger()+1)).tostring().slice(1,3))
			}
		}

		else if (z_list.orderby == z_info.z_favdate ){
			local rdate = z_list.gametable2[i].z_favdate.tostring()
			if (rdate == "00000000000000") temp.push("?")
			else {
				temp.push( "'"+rdate.slice(2,4)+"/"+(100+(rdate.slice(4,6).tointeger()+1)).tostring().slice(1,3))
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

		else if (z_list.orderby == z_info.z_rating ) temp.push( z_list.gametable[i].z_rating == "" ? "??" : z_list.gametable[i].z_rating)
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
	timestop("    z_liststops")
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
	timestart("    z_filteredlistupdateindex")
	if (reindex != null) {
		z_list.newindex = z_list.index = reindex
		fe.list.index = z_list.gametable[reindex].z_felistindex
		return
	}

	if(!mfz_checkin(0).inmfz || !z_favfilter(0) || !z_listsearch(0) || !z_catfilter(0) || (z_checkhidden(0) && !prf.SHOWHIDDEN )){
		z_list.index = 0
		z_list.newindex = 0

		if (z_list.size > 0) fe.list.index = z_list.gametable[0].z_felistindex
	}
	else {
		z_liststupdateindex()
		z_list.newindex = z_list.index
	}
	timestop("    z_filteredlistupdateindex")
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
		if (s0.find(" / ")!=null){

			local s1 = split( s0, "/" )
			if ( s1.len() > 1 ) {
				return strip(s1[0])+"\n"+strip(s1[1])
			}
			else {
				return s0
			}
		}
		else return(s0)
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
		if (testo.find(" / ")!=null){
		testo = split( testo, "/" )
		testo = strip(testo[0])
		}
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
				out.text = out.text + finline.slice(0,colsize)+"\n"
				out.rows ++
				curline = finline = finline.slice(colsize,finline.len())
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

	local amy_ext = split(z_list.boot[offset].z_name,"_")
	local amy_str = ""
	if (amy_ext.len() > 1) {
		for (local i = 1; i < amy_ext.len();i++) amy_str = amy_str+" "+amy_ext[i]
	}

	//local s = split( fe.game_info( Info.Title, offset ), "([" )
	local s = split (s0, "([")
	local s2 = ""
	local s3 = ""

	if (z_list.boot[offset].z_region != "") s3 = s3 + z_list.boot[offset].z_region

	if ((( s.len() > 1 ) || (amy_str != "") || (s3 != "")) && (prf.SHOWSUBNAME)){
		for (local i = 1 ; i<s.len() ; i++){
			s2 = split(s[i],"])")
			s3 = s3 + " " + s2[0]
		}
		s3 = s3 + " " + amy_str
		return ( ((system2 == "") || (!prf.SHOWSYSNAME)) ? strip(s3) : (prf.SHOWSYSART ?  systemfont(system2,false) : system2) + " - " + strip(s3))
	}
	return ( ((system2 == "") || (!prf.SHOWSYSNAME)) ? "" : (prf.SHOWSYSART ?  systemfont(system2,false) : system2))
}

local categorytable = {}

//grey
categorytable[""] <- ["?"," ",[255,255,255]]//
categorytable["UNKNOWN"] <- ["?"," ",[255,255,255]]
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
		return (system_data[sout].logo)
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

local tilez = []

fl.surf = fe.add_surface(fl.w_os,fl.h_os)
fl.surf.redraw = true

// fl.surf.mipmap = 1
// fl.surf.zorder = -1000


/// Controls Overlay Variable Definition ///

local overlay = {
	charsize = null
	rowsize = null
	labelheight = null
	labelcharsize = null
	rows = null
	fullwidth = null
	menuheight = null
	menuheight_temp = null

	background = null
	listbox = null
	label = null
	sidelabel = null
	glyph = null
	shad = []
	wline = null
	filterbg = null
	ex_top = floor(UI.header.h * 0.6)
	ex_bottom = floor(UI.footer.h * 0.5)
	in_side = UI.vertical ? floor(UI.footer.h * 0.5) : floor(UI.footer.h * 0.65)
	x = 0
	y = 0
	w = 0
	h = 0
}

// Define overlay charsize in integer multiple of 2
overlay.charsize = (prf.LOWRES ? floor( 65 * UI.scalerate ) : floor( 50 * UI.scalerate ))
overlay.charsize = overlay.charsize + overlay.charsize%2.0

// First calculation of row size in integer value based on char size
overlay.rowsize = (prf.LOWRES ? (overlay.charsize*2.5) : (overlay.charsize*3.0))
overlay.rowsize = floor(overlay.rowsize)
overlay.labelheight = overlay.rowsize * 1
overlay.labelcharsize = overlay.charsize * 1

// First calculation of menuheight (the space for menu entries) and fullwidth
overlay.menuheight = fl.h - UI.header.h - UI.footer.h - overlay.labelheight + overlay.ex_top + overlay.ex_bottom
overlay.fullwidth = ((overlay.menuheight + overlay.labelheight)*3.0/2.0 < (fl.w - 2 * overlay.in_side) ? (overlay.menuheight + overlay.labelheight)*3.0/2.0 : (fl.w - 2 * overlay.in_side))

// Integer conversion and fullwidth is even
overlay.menuheight = floor(overlay.menuheight)
overlay.fullwidth = floor(overlay.fullwidth)
overlay.fullwidth = overlay.fullwidth + overlay.fullwidth%2.0

// Calculation of number of rows, always odd
overlay.rows = ceil(overlay.menuheight/overlay.rowsize)
if (floor(overlay.rows / 2.0)*2.0 == overlay.rows ) overlay.rows ++

// Recalculation of menuheight based on integer row size and rearrangement of label size
// Maybe this is overcomplicated, better to simplify the part before?
overlay.menuheight_temp = overlay.menuheight
overlay.menuheight = overlay.rows * floor(overlay.menuheight * 1.0/overlay.rows)
overlay.labelheight = overlay.labelheight + overlay.menuheight_temp - overlay.menuheight
overlay.rowsize = overlay.menuheight * 1.0 / overlay.rows

overlay.x = fl.x + 0.5*(fl.w - overlay.fullwidth)
overlay.y = fl.y + UI.header.h - overlay.ex_top
overlay.w = overlay.fullwidth
overlay.h = overlay.menuheight + overlay.labelheight

/// Frosted glass surface ///

local frostpic = {
	size = 64.0 * 0 + 320.0
	w = null
	h = null
	matrix = 0
	sigma = 0
}

frostpic.matrix = floor(frostpic.size*(11.0/64.0))
frostpic.matrix = frostpic.matrix + 1 - frostpic.matrix % 2.0
frostpic.sigma = frostpic.size*(2.5/64.0)

if (!UI.vertical){
	frostpic.w = frostpic.size
	frostpic.h = frostpic.size * fl.h/fl.w
}
else {
	frostpic.w = frostpic.size * fl.w/fl.h
	frostpic.h = frostpic.size
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
	picT = null
}

frost.picT = {
	x = 0,
	y = 0,
	w = frostpic.w,
	h = frostpic.h
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
frost.pic.set_pos (frost.picT.x,frost.picT.y,frost.picT.w,frost.picT.h)


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
frost.surf_rt.redraw = frost.surf_2.redraw = frost.surf_1.redraw = false

shader_fr.alpha.set_texture_param( "texture",frost.surf_rt)
shader_fr.alpha.set_param ( "alpha",0.0 )

frost.surf_rt.shader = shader_fr.alpha
frost.surf_rt.shader = noshader

/// Second Monitor graphics creation ///

local mon2 = {
	pic_array = []
	pic = null
}

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
bglay.whitepic = fe.add_image(AF.folder+"pics/white.png",0,0,1,1)
bglay.whitepic.visible = false

try{bglay.commonground = fl.surf.add_rectangle(0,0,fl.w_os,fl.h_os)}
catch(err){
	fe.overlay.edit_dialog("Arcadeflow needs Attract Mode Plus\nPress enter to quit","")
	fe.signal("exit_to_desktop")
}
bglay.commonground.set_rgb(128,128,128)
bglay.commonground.zorder = -7

bglay.smallsize = 26
bglay.blursize = 1/26.0

bglay.surf_rt = fl.surf.add_surface(bglay.smallsize,bglay.smallsize)
bglay.surf_2 = bglay.surf_rt.add_surface(bglay.smallsize,bglay.smallsize)
bglay.surf_1 = bglay.surf_2.add_surface(bglay.smallsize,bglay.smallsize)

bglay.bgpic = null

for (local i = 0; i < bgs.stacksize; i++){
	bgs.flowalpha.push ([0.0,0.0,0.0,0.0,0.0])
	bglay.bgpic = bglay.surf_1.add_image(AF.folder+"pics/transparent.png",0,0,bglay.smallsize,bglay.smallsize)
	bglay.bgpic.alpha = 255
	bglay.bgpic.trigger = Transition.EndNavigation
	// TEST VA TOLTO DAVVERO?
	//bglay.bgpic.video_flags = Vid.ImagesOnly
	bglay.bgpic.smooth = true
	//bglay.bgpic.mipmap = 1
	bglay.bgpic.preserve_aspect_ratio = false

	bglay.bgpic.shader = colormapper["NONE"].shad

	bgs.bgpic_array.push(bglay.bgpic)
	bgs.bg_lcd.push (false)
	bgs.bg_mono.push ("NONE")
	bgs.bg_aspect.push (0.75)
	bgs.bg_box.push ([false,[255,255,255],[0,0,0]])
	bgs.bg_index.push (z_list.index)
}

prf.MULTIMON <- false
if ((fe.monitors.len() > 1) && (prf.MONITORNUMBER < fe.monitors.len())) prf.MULTIMON = true

if(prf.MULTIMON){
	for (local i=0; i<bgs.stacksize;i++){
		mon2.pic = fe.monitors[prf.MONITORNUMBER].add_image(AF.folder+"pics/transparent.png",0,0,fe.monitors[prf.MONITORNUMBER].width,fe.monitors[prf.MONITORNUMBER].height)
		mon2.pic.preserve_aspect_ratio = prf.MONITORASPECT
		mon2.pic.alpha = 255
		mon2.pic.smooth = true

		mon2.pic_array.push(mon2.pic)
	}
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

function squarebgtop(){

	local ilast = bgs.stacksize - 1
	local remapcolor = bgs.bg_mono[ilast]
	//bgs.bgpic_top.shader = colormapper[remapcolor].shad
	//bgs.bgpic_top.set_rgb (255,255,255)

	local aspect = bgs.bg_aspect[ilast]
	local cropaspect = 1.0

	local vidaspect = getvidAR(0,bgs.bgvid_top,tilez[focusindex.new].refsnapz,0) //getvidAR(bgs.bg_index[ilast]-z_list.index,bgs.bgvid_array[ilast],bgs.bgpic_array[ilast],0)

	if (vidaspect > cropaspect){ // Cut sides
		bgs.bgvid_top.subimg_width =  bgs.bgvid_top.texture_width * (cropaspect/vidaspect)
		bgs.bgvid_top.subimg_height = bgs.bgvid_top.texture_height
		bgs.bgvid_top.subimg_x = 0.5 * (bgs.bgvid_top.texture_width - bgs.bgvid_top.subimg_width)
		bgs.bgvid_top.subimg_y =  0.0
	}
	else { // Cut top and bottom
		bgs.bgvid_top.subimg_width = bgs.bgvid_top.texture_width
		bgs.bgvid_top.subimg_height = bgs.bgvid_top.texture_height * (vidaspect/cropaspect)
		bgs.bgvid_top.subimg_x = 0.0
		bgs.bgvid_top.subimg_y = 0.5*(bgs.bgvid_top.texture_height - bgs.bgvid_top.subimg_height)
	}
}

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
				local vidaspect = getvidAR(bgs.bg_index[i]-z_list.index,bgs.bgvid_array[i],bgs.bgpic_array[i],0)
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

if ((prf.LAYERSNAP) || (prf.LAYERVIDEO)){
	bgvidsurf = fl.surf.add_surface(bglay.bgvidsize,bglay.bgvidsize)

	if (prf.LAYERSNAP){
		for (local i = 0; i < bgs.stacksize; i++){
			local bgvid = null

			bgvid = bgvidsurf.add_clone(bgs.bgpic_array[i])
			/*
			if (i == bgs.stacksize - 1 ){
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
			*/

			bgvid.set_pos(0,0,bglay.bgvidsize,bglay.bgvidsize)
			bgvid.preserve_aspect_ratio = false
			bgvid.trigger = Transition.EndNavigation
			bgvid.smooth = true
			bgs.bgvid_array.push(bgvid)
		}
	}

	if (prf.LAYERVIDEO){
		bgs.bgvid_top = bgvidsurf.add_image("white",0,0,bglay.bgvidsize,bglay.bgvidsize)
		bgs.bgvid_top.video_flags = Vid.NoAudio //TEST150 mettere NoAudio
		bgs.bgvid_top.alpha = 0
	}

	bgvidsurf.smooth = false

	bgvidsurf.alpha = satin.vid

	bgvidsurf.set_pos(bgT.x,bgT.y,bgT.w,bgT.w)

	bglay.pixelgrid = fl.surf.add_image("pics/grid128x.png",bgT.x,bgT.y,bgT.w,bgT.w*128.0/bglay.bgvidsize)
	bglay.pixelgrid.alpha = 50

	bgvidsurf.zorder = bglay.pixelgrid.zorder = -2
}


local picture = {
	bg = null
	bg_hist = null
	fg = null
}

picture.bg = fl.surf.add_image(AF.folder+"pics/transparent.png",0,0,fl.w_os,fl.h_os)
picture.bg.alpha = 255

prf.BGCUSTOM0 <- prf.BGCUSTOM
prf.BGCUSTOMHISTORY0 <- prf.BGCUSTOMHISTORY

bglay.surf_rt.zorder = -6
picture.bg.zorder = -5

/// Display Table Creation ///

// Define new displays array, each item is a table of display data
local z_disp = []

function update_z_disp(){
	// Initialize table entries
	for (local i = 0; i < fe.displays.len(); i++){
		z_disp.push ({
			dispindex = i	// Index of the Display in AM
			dispname = fe.displays[i].name	//Full name of the display as set in AM
			romlist = fe.displays[i].romlist	//proxy of in_cycle value
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
		// data from af_collections is purged from the displays table because they
		// are managed in a different way
		if (z_af_collections.tab.rawin(z_disp[i].dispname)){
			z_af_collections.tab[z_disp[i].dispname].rawset("display_id",i)
		}
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
			try {z_disp[i].group = system_data[item.cleanname.tolower()].group} catch (err) {}
		}
	}
}
update_z_disp()


/// Carrier - variables definition ///


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

/// Carrier - constructor ///

local tiles = {
	count = UI.cols * UI.rows
	offscreen = (UI.vertical ? 3 * UI.rows : 4 * UI.rows)
	total = null
}
tiles.total = tiles.count + 2 * tiles.offscreen

local surfacePosOffset = (tiles.offscreen/UI.rows) * (UI.widthmix + UI.padding)

impulse2.maxoffset = (tiles.offscreen/UI.rows + 1.0) * (UI.widthmix + UI.padding)

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
		hv = fe.add_shader( Shader.VertexAndFragment, "glsl/quadrablur_v.glsl", "glsl/quadrablur_f.glsl" )
	}
	// Define blur shader for the logo shadow
	lg = {
		hv = fe.add_shader( Shader.VertexAndFragment, "glsl/octablur_v.glsl", "glsl/octablur_f.glsl" )
	}

}

shaders.gr.hv.set_texture_param( "texture")
shaders.gr.hv.set_param ("size", gradsizer, gradsizer)

shaders.lg.hv.set_texture_param( "texture")
shaders.lg.hv.set_param ("size", logo.shw*logo.shscale, logo.shh*logo.shscale)



for (local i = 0; i < tiles.total; i++ ) {

	// main tile object at zoomed in size
	local obj = fl.surf.add_surface(UI.zoomedwidth,UI.zoomedheight)

	obj.origin_x = obj.width * 0.5
	obj.origin_y = obj.height * 0.5

	obj.zorder = -2

	local refsnapz = obj.add_image(AF.folder+"pics/transparent.png",0,0,gradsizer,gradsizer)
	refsnapz.visible = false
	refsnapz.redraw = false

	if (prf.SNAPGRADIENT){

		gradsurf_rt = obj.add_surface (gradsizer, gradsizer)
		gradsurf_1 = gradsurf_rt.add_surface (gradsizer, gradsizer)

		gr_snapz = gradsurf_1.add_image(AF.folder+"pics/transparent.png",0,0,gradsizer,gradsizer)
		gr_snapz.preserve_aspect_ratio = false
		gr_snapz.mipmap = 1

		gr_vidsz = gradsurf_1.add_image(AF.folder+"pics/transparent.png",0,0,gradsizer,gradsizer)
		gr_vidsz.preserve_aspect_ratio = false
		gr_vidsz.mipmap = 1

		//gr_vidsz.visible = false
		if (!prf.AUDIOVIDSNAPS) gr_vidsz.video_flags = Vid.NoAudio


		gradsurf_1.shader = shaders.gr.hv

		gradsurf_rt.set_pos (gradsizer*gradscaler*i , 0,gradsizer*gradscaler,gradsizer*gradscaler)
		gradsurf_rt.visible = true
	}
	else {
		gr_snapz = obj.add_image(AF.folder+"pics/transparent.png",0,0,gradsizer,gradsizer)
		gr_snapz.preserve_aspect_ratio = false
		//gr_snapz.video_flags = Vid.ImagesOnly

		gr_vidsz = obj.add_image(AF.folder+"pics/transparent.png",0,0,gradsizer,gradsizer)
		gr_vidsz.preserve_aspect_ratio = false
		gr_vidsz.mipmap = 1

		if (!prf.AUDIOVIDSNAPS) gr_vidsz.video_flags = Vid.NoAudio
	}

	// Place shadow item covering full tile
	local sh_mx = obj.add_image("pics/decor/tile_shadow.png",0,0,UI.zoomedwidth,UI.zoomedheight)
	sh_mx.alpha = prf.LOGOSONLY ? 0 : 230

	// place glow item covering full tile with offset
	local glomx = obj.add_image("pics/decor/tile_glow.png",0,-UI.zoomedvshift,UI.zoomedwidth,UI.zoomedheight)
	glomx.alpha = 0

	// place white border at fake location
	local bd_mx = obj.add_rectangle(0,0,1,1)
	bd_mx.set_rgb(255,255,255)
	bd_mx.alpha = 0

	// add snap at fake location
	local snapz = obj.add_clone(gr_snapz)
	if(!prf.SNAPGRADIENT) gr_snapz.visible = false
	snapz.preserve_aspect_ratio = false
	snapz.set_pos (0,0,1,1)
	snapz.alpha = prf.LOGOSONLY ? 0 : 255

	local gr_overlay = null

	snap_grad.push(null)
	if (prf.SNAPGRADIENT) {
		gr_overlay = obj.add_image(AF.folder+"pics/white.png",gradsurf_rt.width,gradsurf_rt.height)
		gradsurf_rt.visible = false
		gr_overlay.preserve_aspect_ratio = false
		// snapz.video_flags = Vid.ImagesOnly
		gr_overlay.set_pos (0,0,1,1)
		snap_grad[i] = fe.add_shader( Shader.Fragment, "glsl/gradalpha_109.glsl" )
		snap_grad[i].set_texture_param("texturecolor",gradsurf_rt)
		if (prf.LOGOSONLY)
			snap_grad[i].set_param ("limits",0.0,0.0)
		else
			snap_grad[i].set_param ("limits",0.25,0.8)
		gr_overlay.shader = snap_grad[i]
		gr_overlay.alpha = prf.LOGOSONLY ? 0 : 255
	}

	txbox = obj.add_text("XXXXXXXXXXXXXXXXXXXXXXXX",(UI.zoomedwidth - UI.zoomedwidth*44.0/48.0)*0.5,UI.zoomscale*UI.padding*62.0/40.0-UI.zoomedvshift,UI.zoomedwidth*44.0/48.0,UI.zoomedheight*44.0/48.0)
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

		glomx.shader = noshader
	}
	else{
		glomx.visible = false
	}

	local snap_shadow_shape = fe.add_shader( Shader.Fragment, "glsl/shadow.glsl" )
	snap_shadow_shape.set_texture_param("texture")
	sh_mx.shader = snap_shadow_shape

	local vidsz = obj.add_clone(gr_vidsz)
	vidsz.set_pos (0,0,1,1)
	vidsz.preserve_aspect_ratio = false
	//gr_vidsz.visible = false
	if (!prf.SNAPGRADIENT) gr_vidsz.visible = false
	// if (!prf.AUDIOVIDSNAPS) vidsz.video_flags = Vid.NoAudio

	//local nw_mx = obj.add_image("pics/decor/new.png",selectorscale*padding,selectorscale*(padding-verticalshift+height*6.0/8.0),width*selectorscale/8.0,height*selectorscale/8.0)
	//local tg_mx = obj.add_image("pics/decor/tag.png",0,0,width*selectorscale/6.0,height*selectorscale/6.0)

	local nw_mx = obj.add_image("pics/decor/new.png",0,0,UI.zoomedcorewidth/8.0,UI.zoomedcoreheight/8.0)
	nw_mx.visible = false
	nw_mx.alpha = ((prf.NEWGAME == true)? 220 : 0)

	local tg_mx = obj.add_image("pics/decor/tag.png",0,0,UI.zoomedcorewidth/6.0,UI.zoomedcoreheight/6.0)
	tg_mx.visible = false
	tg_mx.mipmap = true
	tg_mx.alpha = ((prf.TAGSHOW == true)? 255 : 0)

	local donez = obj.add_image("pics/decor/completed.png",UI.zoomedpadding,UI.zoomedpadding - UI.zoomedvshift,UI.zoomedcorewidth,UI.zoomedcoreheight)
	donez.visible = false
	donez.preserve_aspect_ratio = false
	donez.mipmap = true

	local availz = obj.add_text("✘",0,0,UI.zoomedwidth,UI.zoomedheight)
	availz.visible = false
	availz.font = uifonts.gui
	availz.char_size = UI.corewidth * 0.7
	availz.align = Align.MiddleCentre
	availz.set_rgb(200,50,0)
	availz.alpha = 150

	local favez = obj.add_image("pics/decor/starred.png",UI.zoomedpadding + UI.zoomedcorewidth/2, UI.zoomedpadding + UI.zoomedcoreheight/2 - UI.zoomedvshift, UI.zoomedcorewidth/2,UI.zoomedcoreheight/2)
	favez.visible = false
	favez.preserve_aspect_ratio = false

	logosurf_rt = obj.add_surface (logo.shw*logo.shscale,logo.shh*logo.shscale)
	logosurf_1 = logosurf_rt.add_surface (logo.shw*logo.shscale,logo.shh*logo.shscale)

	loshz = logosurf_1.add_image(AF.folder+"pics/transparent.png",logo.margin*logo.shscale,logo.margin*logo.shscale,logo.w*logo.shscale,logo.h*logo.shscale)
	loshz.mipmap = 1

	txshz = logosurf_1.add_text("...",loshz.x,loshz.y,loshz.width,loshz.height)
	txshz.char_size = logo.shcharsize * logo.shscale
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
		logosurf_rt.set_pos (UI.zoomscale*UI.padding*0.5,UI.zoomscale*(UI.padding*0.6-UI.verticalshift+UI.coreheight*0.25),UI.zoomscale*(UI.corewidth+UI.padding),UI.zoomscale*(UI.coreheight*0.5+UI.padding))
	}
	else {
		if (!prf.CROPSNAPS)
			logosurf_rt.set_pos (UI.zoomscale*UI.padding*0.5,UI.zoomscale*(UI.padding*0.4*0.5-UI.verticalshift),UI.zoomscale*(UI.corewidth+UI.padding),UI.zoomscale*(UI.coreheight*0.5+UI.padding))
		else
			logosurf_rt.set_pos (UI.zoomscale*UI.padding,UI.zoomscale*(UI.padding-UI.verticalshift),UI.zoomscale*UI.corewidth,UI.zoomscale*UI.corewidth*logo.shh/logo.shw)
	}

	local logoz = obj.add_clone (loshz)

	logoz.preserve_aspect_ratio = true

	if (prf.LOGOSONLY){
		logoz.set_pos (UI.zoomscale*UI.padding,UI.zoomscale*(UI.padding +UI.coreheight*0.25 - UI.verticalshift ),UI.zoomscale*UI.corewidth,UI.zoomscale*UI.coreheight*0.5)
	}
	else {
		if (!prf.CROPSNAPS)
			logoz.set_pos (UI.zoomscale*UI.padding,UI.zoomscale*(UI.padding*0.6-UI.verticalshift),UI.zoomscale*UI.corewidth,UI.zoomscale*UI.coreheight*0.5)
		else
			logoz.set_pos (UI.zoomscale*(UI.padding+UI.corewidth*logo.margin/logo.shw),UI.zoomscale*(UI.padding-UI.verticalshift+UI.corewidth*(15/20.0)*logo.margin/logo.shw),UI.zoomscale*UI.corewidth*logo.w/logo.shw,UI.zoomscale*UI.coreheight*logo.h/logo.shw)
	}

	txt2z = obj.add_text("...",logoz.x,logoz.y,logoz.width,logoz.height)
	txt2z.char_size = logo.shcharsize*(88.0/40.0) * UI.scalerate
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

	//txshz = obj.add_text("[Title]",UI.zoomscale*(UI.padding +height*(1.0/8.0)),UI.zoomscale*(UI.padding+height*(1.0/8.0)),UI.zoomscale*width*3.0/4.0,UI.zoomscale*height*3.0/4.0)
	txt1z = obj.add_text("...",logoz.x,logoz.y,logoz.width,logoz.height)
	txt1z.char_size = logo.shcharsize*(88.0/40.0) * UI.scalerate
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

	tilesTablePos.X.push((UI.corewidth + UI.padding) * (i/UI.rows) + UI.padding + obj.width * 0.5)
	tilesTablePos.Y.push((UI.corewidth + UI.padding) * (i%UI.rows) + UI.padding + carrierT.y + obj.height*0.5)
	tilesTableZoom.push ([0.0,0.0,0.0,0.0,0.0])
	tilesTableUpdate.push ([0.0,0.0,0.0,0.0,0.0])
	gr_vidszTableFade.push ([0.0,0.0,0.0,0.0,0.0])
	aspectratioMorph.push ([0.0,0.0,0.0,0.0,0.0])
	vidpos.push (0)
	vidindex.push (0)

	obj.preserve_aspect_ratio = false

	gr_vidsz.alpha = vidsz.alpha = 0

	tilez.push({
		obj = obj
		refsnapz = refsnapz
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

		surfs = [gradsurf_rt, gradsurf_1, logosurf_rt, logosurf_1]

		offset = 0
		index = 0

		AR = ({snap = 1.0, vids = 1.0, crop = 1.0, current = 1.0})
		offlist = false // True if the tile is outside of the list (and therfore put to visible = false)
		freezecount = 0
		alphazero = 255 // This is the alpha value of the tile, can be 255 or different if it's a "hidden" game
		alphafade = 0 // This is the alpha counter for the tile, when fading happens

		alphalogosonly = prf.LOGOSONLY ? 0.0 : 1.0 // This is an alpha factor that is used to blank items in logos only mode

		sh_mx_alpha = 230
		bd_mx_alpha = bd_mx.alpha
		glomx_alpha = glomx.alpha
	})
}

function tile_redraw(i,status){
	tilez[i].obj.redraw = status
	foreach (item in tilez[i].surfs){
		if (item != null) item.redraw = status //Fixed for low spec mode
	}
}

function tile_clear(i,status){
	tilez[i].obj.clear = status
	foreach (item in tilez[i].surfs){
		if (item != null) item.clear = status //Fixed for low spec mode
	}
}

function tile_freeze(i,status){
	tilez[i].obj.clear = tilez[i].obj.redraw = !status
	foreach (item in tilez[i].surfs){
		if (item != null) item.clear = item.redraw = !status //Fixed for low spec mode
	}
}

impulse2.flow = 0.5

/// No list blanker ///

nolist_blanker = fl.surf.add_text("LIST EMPTY",0,0,fl.w,fl.h)
nolist_blanker.set_bg_rgb(120,120,120)
nolist_blanker.set_rgb(110,110,110)
nolist_blanker.char_size = fl.h*0.1

/// Data surface construction ///

data_surface = fl.surf.add_surface (fl.w_os,fl.h_os)
data_surface.set_pos(0,0)


// Creation of data shadow

local sh_scale = {
	r1 = (UI.vertical ? 400.0 / fl.w : 400.0 / fl.h)
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

data_surface_sh_rt.set_pos( 4 * UI.scalerate,7 * UI.scalerate,data_surface.width,data_surface.height)


function pixelizefont(object, labelfont, margin = 0,linespacing = 0.7, narrow = false){
	if (margin == null) margin = 0
	if (linespacing == null) linespacing = 0.7

	if (floor(labelfont + 0.5) == 5){
		object.char_size = 16
		object.font = "fonts/font_4x3pixel.ttf"
		object.line_spacing = linespacing
		object.margin = margin
	}
	else if (floor(labelfont + 0.5) == 6){
		object.char_size = 16
		object.font = narrow ? "fonts/font_5x3pixel.ttf" : "fonts/font_5x4pixel.ttf"
		object.line_spacing = linespacing
		object.margin = margin
	}
	else if (floor(labelfont + 0.5) == 7){
		object.char_size = 16
		object.font = "fonts/font_6x4pixel.ttf"
		object.line_spacing = linespacing
		object.margin = margin
	}
	else if (floor(labelfont + 0.5) == 8){
		object.char_size = 16
		object.font = "fonts/font_7x5pixel.ttf"
		object.line_spacing = linespacing
		object.margin = margin
	}
	else if (floor(labelfont + 0.5) == 9){
		object.char_size = 16
		object.font = "fonts/font_7x6pixel_2.ttf"
		object.line_spacing = 0.7
		object.margin = margin
	}
	else {
		return
	}
}

local filterdata = data_surface.add_text("footer",fl.x,fl.y+fl.h-UI.footer.h,UI.footermargin,UI.footer.h)
filterdata.align = Align.MiddleCentre
filterdata.margin = 0
filterdata.set_rgb( 255, 255, 255)
filterdata.word_wrap = true
filterdata.char_size = (prf.LOWRES ? 35 * UI.scalerate/uifonts.pixel : 25 * UI.scalerate/uifonts.pixel)
filterdata.visible = true
filterdata.font = uifonts.gui
filterdata.set_rgb(themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)
//filterdata.set_bg_rgb (200,10,10)
pixelizefont(filterdata,(prf.LOWRES ? 35 * UI.scalerate/uifonts.pixel : 25 * UI.scalerate/uifonts.pixel))
/*
testpr(filterdata.font+"\n")
filterdata.font = "fonts/font_5x4pixel.ttf"
filterdata.line_spacing = 0.5
filterdata.align = Align.MiddleCentre
filterdata.margin = 0
*/

local filternumbers = data_surface.add_text( (prf.CLEANLAYOUT ? "" :"[!zlistentry]\n[!zlistsize]"),fl.x+fl.w-UI.footermargin,fl.y+fl.h-UI.footer.h,UI.footermargin,UI.footer.h)
filternumbers.align = Align.MiddleCentre
filternumbers.margin = 0
filternumbers.set_rgb( 255, 255, 255)
filternumbers.word_wrap = true
filternumbers.char_size = (prf.LOWRES ? 35 * UI.scalerate/uifonts.pixel : 25 * UI.scalerate/uifonts.pixel)
filternumbers.visible = true
filternumbers.font = uifonts.gui
filternumbers.set_rgb(themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)
pixelizefont(filternumbers,(prf.LOWRES ? 35 * UI.scalerate/uifonts.pixel : 25 * UI.scalerate/uifonts.pixel))
/*
filternumbers.font = "fonts/font_5x4pixel.ttf"
filternumbers.line_spacing = 0.7
filternumbers.align = Align.MiddleCentre
filternumbers.margin = 0
*/

local separatorline = data_surface.add_rectangle(fl.x+fl.w-UI.footermargin+UI.footermargin*0.3, fl.y+fl.h-UI.footer.h + UI.footer.h*0.5,UI.footermargin*0.4,1)
separatorline.set_rgb(themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)
separatorline.visible = !((prf.CLEANLAYOUT))

multifilterglyph = data_surface.add_text("X",fl.x+fl.w-UI.footermargin,fl.y+fl.h-UI.footer.h,UI.footermargin*0.3,UI.footer.h)
multifilterglyph.margin = 0
multifilterglyph.char_size = UI.scalerate * 45
multifilterglyph.align = Align.MiddleCentre
// multifilterglyph.set_bg_rgb (100,0,0)
multifilterglyph.set_rgb(themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)
multifilterglyph.word_wrap = true
multifilterglyph.msg = ""
multifilterglyph.font = uifonts.glyphs
multifilterglyph.visible = false



// scroller definition
local scrolline = data_surface.add_rectangle(fl.x + UI.footermargin, fl.y + fl.h - UI.footer.h * 0.5 - 1, fl.w-2 * UI.footermargin, 1 )
//scrolline.alpha = 255
scrolline.set_rgb(themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)

local scrollineglow = data_surface.add_image("pics/ui/whitedisc2.png",fl.x+UI.footermargin, fl.y+fl.h - UI.footer.h*0.5 - 10 * UI.scalerate -1 ,fl.w-2*UI.footermargin, 20 * UI.scalerate + 1)
scrollineglow.visible = false
scrollineglow.alpha = 200
scrollineglow.set_rgb(themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)

local scroller = data_surface.add_image("pics/ui/whitedisc.png",fl.x+UI.footermargin - scrollersize*0.5,fl.y+fl.h-UI.footer.h*0.5-(scrollersize + 1 )*0.5,scrollersize,scrollersize)
scroller.set_rgb(themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)

local scroller2 = data_surface.add_image("pics/ui/whitedisc2.png",scroller.x - scrollersize*0.5, scroller.y-scrollersize*0.5,scrollersize*2,scrollersize*2)
scroller2.visible = false
scroller2.alpha = 200
scroller2.set_rgb(themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)

if (prf.SCROLLERTYPE == "labellist") scroller2.alpha = scrollineglow.alpha = scroller.alpha = scrolline.alpha = 0

local labelstrip = data_surface.add_image("pics/ui/wbox2.png")
labelstrip.visible = false

local labelsurf = data_surface.add_surface (fl.w,fl.h)
labelsurf.set_pos (fl.x,fl.y)

searchdata = data_surface.add_text(fe.list.search_rule, fl.x, fl.y+fl.h - UI.footer.h * 0.5, fl.w, UI.footer.h * 0.5)
searchdata.align = Align.MiddleCentre
searchdata.set_rgb( 255, 255, 255)
searchdata.word_wrap = true
searchdata.char_size = 25 * UI.scalerate
searchdata.visible = true
searchdata.font = uifonts.gui
searchdata.set_rgb(themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)


function data_freeze(status){
	data_surface.clear = data_surface.redraw = !status
	data_surface_sh_rt.clear = data_surface_sh_rt.redraw = !status
	data_surface_sh_2.clear = data_surface_sh_2.redraw = !status
	data_surface_sh_1.clear = data_surface_sh_1.redraw = !status
	labelsurf.clear = labelsurf.redraw = !status
}

function bgs_freeze(status){
	bglay.surf_rt.redraw = bglay.surf_rt.clear = !status
	bglay.surf_2.redraw = bglay.surf_2.clear = !status
	bglay.surf_1.redraw = bglay.surf_1.clear = !status
}

function displaynamelogo (offset){
	return systemfont (z_disp[fe.list.display_index].cleanname,false)
}

local displaynamesurf = {
	surf = null
	w = fl.w * 2.0
	h = 0
}
displaynamesurf.h = displaynamesurf.w * 30.0/200.0
displaynamesurf.surf = data_surface.add_surface (displaynamesurf.w,displaynamesurf.h)
displaynamesurf.surf.set_pos (fl.x+0.5*(fl.w - displaynamesurf.w), fl.y+0.5*(fl.h - displaynamesurf.h))
local displayname = displaynamesurf.surf.add_text("...",0,0,displaynamesurf.w,displaynamesurf.h)

displayname.char_size = displaynamesurf.h * 1.01
displayname.margin = 0
displayname.word_wrap = true
displayname.alpha = 0
displayname.font = uifonts.gui
displayname.align = Align.MiddleCentre
displaynamesurf.surf.redraw = false

// fading letter
local letterobjsurf = {
	surf = null
	w = fl.w_os * 1.8 //TEST120 was 3.0!!!
	w3 = fl.w_os * 3.0
	h = carrierT.h
	y0 = carrierT.y - data_surface.y
}
letterobjsurf.surf = data_surface.add_surface(letterobjsurf.w,letterobjsurf.h)
letterobjsurf.surf.set_pos (fl.x+0.5*(fl.w - letterobjsurf.w),letterobjsurf.y0)
local letterobj = letterobjsurf.surf.add_text("...",0.5*(letterobjsurf.w - letterobjsurf.w3),0,letterobjsurf.w3,letterobjsurf.h)
letterobj.alpha = 0
letterobj.char_size = lettersize.name * 2.0
letterobj.font = uifonts.gui
letterobj.set_rgb(themeT.themelettercolor,themeT.themelettercolor,themeT.themelettercolor)
letterobj.margin = 0
letterobj.align = Align.MiddleCentre
letterobjsurf.surf.redraw = false

local blsize = {
	mini = floor (45 * UI.scalerate + 0.5),
	catp = floor (110 * UI.scalerate + 0.5),
	subt = floor (35 * UI.scalerate + 0.5),
	posy = floor (137 * UI.scalerate + 0.5),
	manu = floor (145 * UI.scalerate + 0.5),
	dath = floor (25 * UI.scalerate + 0.5)
}

if (prf.LOWRES) {
	blsize = {
		mini = 60 * UI.scalerate,
		catp = 150 * UI.scalerate,
		subt = 45 * UI.scalerate,
		posy = 180 * UI.scalerate,
		manu = 150 * UI.scalerate,
		dath = 40 * UI.scalerate
	}
}

local gamed = {
	catpicT = {}
	plypicT = {}
	ctlpicT = {}
	butpicT = {}
	maincatT = {}
	manufacturerpicT = {}
	yearT = {}
	mainnameT = {}
	subnameT = {}
}

// category image
gamed.catpicT = {
	x = floor(30 * UI.scalerate + 0.5),
	y = floor(20 * UI.scalerate + 0.5),
	w = blsize.catp,
	h = blsize.catp
}

// players image, controller image, button image
gamed.plypicT = {
	x = blsize.catp + 2.0 * gamed.catpicT.x,
	y = blsize.posy,
	w = blsize.mini,
	h = blsize.mini
}

gamed.ctlpicT = {
	x = gamed.plypicT.x + blsize.mini + floor(10 * UI.scalerate + 0.5),
	y = gamed.plypicT.y,
	w = blsize.mini,
	h = blsize.mini
}

gamed.butpicT = {
	x = gamed.plypicT.x + 2 * (blsize.mini + floor(10 * UI.scalerate + 0.5)),
	y = gamed.plypicT.y,
	w = floor (blsize.mini * 1.25 + 0.5),
	h = blsize.mini
}

// main game category
gamed.maincatT = {
	x = floor (20 * UI.scalerate + 0.5),
	y = UI.header.h - floor (20 * UI.scalerate + 0.5)- blsize.subt,
	w = gamed.plypicT.x - 2 * floor (20 * UI.scalerate + 0.5),
	h = blsize.subt
}

// right side: manufacturer and year
gamed.manufacturerpicT = {
	x = fl.w - 2 * blsize.manu - floor(30 * UI.scalerate + 0.5),
	y = (prf.LOWRES ? floor(20 * UI.scalerate +0.5) : floor(10 * UI.scalerate + 0.5)),
	w = 2 * blsize.manu,
	h = blsize.manu
}
gamed.yearT = {
	x = gamed.manufacturerpicT.x,
	y = UI.header.h - floor (20 * UI.scalerate + 0.5) - blsize.dath,
	w = gamed.manufacturerpicT.w,
	h = blsize.dath
}

// game main name and subname
gamed.mainnameT = {
	x = gamed.plypicT.x,
	y = gamed.catpicT.y,
	w = fl.w - gamed.plypicT.x - gamed.manufacturerpicT.w - floor(30 * UI.scalerate + 0.5) - floor (5 * UI.scalerate + 0.5),
	h = gamed.catpicT.h
}

gamed.subnameT = {
	x = gamed.butpicT.x + gamed.butpicT.w + floor (15 * UI.scalerate + 0.5),
	y = gamed.maincatT.y,
	w = fl.w - gamed.butpicT.x - gamed.butpicT.w - floor (15  * UI.scalerate + 0.5) - gamed.manufacturerpicT.w - floor (30 * UI.scalerate + 0.5) - floor (5 * UI.scalerate + 0.5),
	h = blsize.subt
}

if (prf.CLEANLAYOUT) {
	gamed.mainnameT.x = filterdata.x + filterdata.width
	gamed.mainnameT.w = filternumbers.x - filterdata.x - filterdata.width
	gamed.subnameT.x = gamed.mainnameT.x
	gamed.subnameT.w = gamed.mainnameT.w
}

local bwtoalpha = fe.add_shader( Shader.Fragment, "glsl/bwtoalpha.glsl" )
bwtoalpha.set_texture_param( "texture")

local txtoalpha = fe.add_shader( Shader.Fragment, "glsl/txtoalpha.glsl" )
txtoalpha.set_texture_param( "texture")

for (local i = 0; i < dat.stacksize; i++){

	local game_catpic = data_surface.add_image(AF.folder+"pics/white.png",fl.x+gamed.catpicT.x, fl.y+gamed.catpicT.y, gamed.catpicT.w, gamed.catpicT.h)
	game_catpic.smooth = false
	game_catpic.preserve_aspect_ratio = true
	game_catpic.set_rgb(themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)
	game_catpic.shader = bwtoalpha
	game_catpic.mipmap = 1
	//game_catpic.fix_masked_image()

	// pixel perfect cat pic
	if (game_catpic.width <= 30){
		game_catpic.width = floor(gamed.catpicT.w/16)*16
		game_catpic.height = floor(gamed.catpicT.w/16)*16
		game_catpic.x = fl.x + floor(gamed.catpicT.x + 0.5 * gamed.catpicT.w) - floor(0.5*game_catpic.width)
		game_catpic.y = fl.y + floor(gamed.catpicT.y + 0.5 * gamed.catpicT.h) - floor(0.5*game_catpic.width)
	}

	local game_butpic = data_surface.add_image(AF.folder+"pics/white.png",fl.x+gamed.butpicT.x, fl.y+gamed.butpicT.y, gamed.butpicT.w, gamed.butpicT.h)
	game_butpic.smooth = (gamed.butpicT.h > 10)
	game_butpic.preserve_aspect_ratio = true
	game_butpic.set_rgb(themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)
	game_butpic.shader = bwtoalpha
	game_butpic.mipmap = 1

	local game_plypic = data_surface.add_image(AF.folder+"pics/white.png",fl.x+gamed.plypicT.x, fl.y+gamed.plypicT.y, gamed.plypicT.w, gamed.plypicT.h)
	game_plypic.smooth = (gamed.plypicT.h > 10)
	game_plypic.preserve_aspect_ratio = true
	game_plypic.set_rgb(themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)
	game_plypic.shader = bwtoalpha
	game_plypic.mipmap = 1

	local game_ctlpic = data_surface.add_image(AF.folder+"pics/white.png",fl.x+gamed.ctlpicT.x, fl.y+gamed.ctlpicT.y, gamed.ctlpicT.w, gamed.ctlpicT.h)
	game_ctlpic.smooth = (gamed.ctlpicT.h > 10)
	game_ctlpic.preserve_aspect_ratio = true
	game_ctlpic.set_rgb(themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)
	game_ctlpic.shader = bwtoalpha
	game_ctlpic.mipmap = 1

	local game_maincat = data_surface.add_text("",fl.x+gamed.maincatT.x,fl.y+gamed.maincatT.y,gamed.maincatT.w,gamed.maincatT.h)
	game_maincat.align = Align.MiddleCentre
	game_maincat.word_wrap = true
	game_maincat.set_rgb(themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)
	game_maincat.char_size = (gamed.maincatT.h - 10 * UI.scalerate)/uifonts.pixel
	game_maincat.font = uifonts.condensed
	game_maincat.alpha = 255
	game_maincat.margin = 0
	game_maincat.line_spacing = 0.8
	//	game_maincat.set_bg_rgb (255,0,0)
	pixelizefont(game_maincat, floor((gamed.maincatT.h - 10 * UI.scalerate)/uifonts.pixel)-1,null,null,true)

	local game_mainname = data_surface.add_text("", fl.x + gamed.mainnameT.x, fl.y + gamed.mainnameT.y , gamed.mainnameT.w, gamed.mainnameT.h )
	game_mainname.align = prf.CLEANLAYOUT ? Align.MiddleCentre : Align.MiddleLeft
	game_mainname.word_wrap = true
	game_mainname.set_rgb(themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)
	game_mainname.char_size = (gamed.mainnameT.h - 10 * UI.scalerate)*0.5/uifonts.pixel
	game_mainname.line_spacing = 0.670000068
	game_mainname.margin = 0
	game_mainname.font = uifonts.gui
	game_mainname.alpha = 255
	// game_mainname.set_bg_rgb(200,0,0)
	game_mainname.visible = true

	local game_subname = data_surface.add_text("", fl.x+(prf.CLEANLAYOUT ? gamed.mainnameT.x : gamed.subnameT.x), fl.y+gamed.subnameT.y, gamed.subnameT.w, gamed.subnameT.h )
	game_subname.align = prf.CLEANLAYOUT ? Align.TopCentre : Align.TopLeft
	game_subname.word_wrap = false
	game_subname.set_rgb(themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)
	game_subname.char_size = gamed.subnameT.h/uifonts.pixel
	game_subname.font = uifonts.gui
	game_subname.alpha = 255
	game_subname.margin = 0
	//	game_subname.set_bg_rgb(200,100,0)

	local game_manufacturerpic = data_surface.add_text("",fl.x+gamed.manufacturerpicT.x , fl.y+gamed.manufacturerpicT.y , gamed.manufacturerpicT.w, gamed.manufacturerpicT.h)

	// game_manufacturerpic.mipmap = 1
	//	game_manufacturerpic.smooth = true
	//	game_manufacturerpic.preserve_aspect_ratio = false
	game_manufacturerpic.set_rgb(themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)
	//	game_manufacturerpic.shader = bwtoalpha
	game_manufacturerpic.char_size = gamed.manufacturerpicT.h-5 * UI.scalerate
	game_manufacturerpic.margin = 5 * UI.scalerate
	game_manufacturerpic.align = Align.BottomCentre
	game_manufacturerpic.font = "fonts/font_manufacturers_2.ttf"
	//game_manufacturerpic.set_bg_rgb(255,0,0)


	local game_manufacturername = data_surface.add_text("",fl.x+gamed.manufacturerpicT.x , fl.y+gamed.manufacturerpicT.y, gamed.manufacturerpicT.w, gamed.manufacturerpicT.h)
	// game_manufacturerpic.mipmap = 1
	game_manufacturername.align = Align.MiddleCentre
	game_manufacturername.set_rgb( 255, 255, 255)
	game_manufacturername.word_wrap = true
	game_manufacturername.char_size = 0.2*gamed.manufacturerpicT.h/uifonts.pixel
	game_manufacturername.visible = false
	game_manufacturername.font = uifonts.gui
	game_manufacturername.margin = 0
	game_manufacturername.set_rgb(themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)


	local game_year = data_surface.add_text("", fl.x+gamed.yearT.x, fl.y+gamed.yearT.y, gamed.yearT.w, gamed.yearT.h)
	game_year.align = Align.TopCentre
	game_year.set_rgb( 255, 255, 255)
	game_year.word_wrap = false
	game_year.char_size = gamed.yearT.h/uifonts.pixel
	game_year.visible = true
	game_year.font = uifonts.gui
	game_year.margin = 0
	game_year.set_rgb(themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)
	// game_year.set_bg_rgb(200,000,100)
	pixelizefont(game_year, floor((gamed.yearT.h/uifonts.pixel)-1), null, null, true)

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

//TEST Uncomment this to monitor the cloned surface
/*
fl.surf3 = fl.surf2.add_clone(fl.surf)
fl.surf3.set_pos(0,0,fl.w_os*0.2,fl.h_os*0.2)
*/
//fl.surf2.set_pos(0,0,fl.w_os,fl.h_os)


/// Context Menu ///

//local overmenuwidth = (vertical ? fl.w_os * 0.7 : fl.h_os * 0.7)
local overmenuwidth = UI.zoomedwidth * 0.9
if (((UI.rows == 1) && UI.vertical ) || (!UI.vertical && (UI.rows == 1) && (prf.SLIMLINE == false) && (prf.TILEZOOM == 2) )) overmenuwidth = UI.zoomedwidth * 0.6
local overmenu = fl.surf.add_image("pics/ui/overmenu4.png",fl.x + fl.w*0.5-overmenuwidth*0.5,fl.y + fl.h*0.5-overmenuwidth*0.5,overmenuwidth,overmenuwidth)
overmenu.visible = false
overmenu.alpha = 0

function overmenu_visible(){
	return ((overmenu.visible) && (flowT.overmenu[3] >= 0))
}

function overmenu_show(){
	overmenu.y = fl.y + fl.h*0.5*0 + UI.header.h2 + UI.tileheight*0.5 -overmenuwidth*0.5 - corrector * (UI.tileheight - UI.padding)
	if (UI.rows == 1 ) overmenu.y = fl.y + fl.h*0.5*0 + UI.header.h2 + UI.tileheight*0.5 - overmenuwidth*0.5
	if (prf.SLIMLINE == true) overmenu.y = fl.y + UI.header.h + (fl.h-UI.header.h-UI.footer.h)*0.5 - overmenuwidth*0.5
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
overlay.background = fe.add_rectangle(overlay.x, overlay.y, overlay.w, overlay.h)
overlay.background.set_rgb(themeT.listboxbg,themeT.listboxbg,themeT.listboxbg)
//overlay.background.set_bg_rgb(255,0,0)
overlay.background.alpha = themeT.listboxalpha

overlay.listbox = fe.add_listbox( overlay.x, overlay.y + overlay.labelheight, overlay.w , overlay.menuheight )
overlay.listbox.rows = overlay.rows
overlay.listbox.char_size = overlay.charsize
overlay.listbox.bg_alpha = 0
overlay.listbox.set_rgb(themeT.listboxselbg.r,themeT.listboxselbg.g,themeT.listboxselbg.b)
overlay.listbox.set_bg_rgb( 0, 0, 0 )
overlay.listbox.set_sel_rgb( themeT.listboxseltext, themeT.listboxseltext, themeT.listboxseltext )
overlay.listbox.set_selbg_rgb( themeT.listboxselbg.r,themeT.listboxselbg.g,themeT.listboxselbg.b )
overlay.listbox.selbg_alpha = 255
overlay.listbox.font = uifonts.gui
overlay.listbox.align = Align.MiddleCentre
overlay.listbox.sel_alpha = 255

overlay.label = fe.add_text("LABEL", overlay.x, overlay.y, overlay.w, overlay.labelheight )
overlay.label.char_size = overlay.labelcharsize
overlay.label.set_rgb(themeT.listboxselbg.r,themeT.listboxselbg.g,themeT.listboxselbg.b)
overlay.label.align = Align.MiddleCentre
overlay.label.font = uifonts.gui
overlay.label.set_bg_rgb(0,200,0)
overlay.label.bg_alpha = 0

overlay.sidelabel = fe.add_text("", overlay.x, overlay.y, overlay.w, overlay.labelheight )
overlay.sidelabel.char_size = overlay.labelcharsize*0.6
overlay.sidelabel.set_rgb(themeT.listboxselbg.r,themeT.listboxselbg.g,themeT.listboxselbg.b)
overlay.sidelabel.align = Align.MiddleRight
overlay.sidelabel.font = uifonts.lite
overlay.sidelabel.set_bg_rgb(0,200,0)
overlay.sidelabel.bg_alpha = 0
overlay.sidelabel.word_wrap = true
pixelizefont (overlay.sidelabel, overlay.labelcharsize*0.6,2)

overlay.glyph = fe.add_text("", overlay.x + UI.padding, overlay.y, overlay.labelheight*0.98, overlay.labelheight*0.98 )
overlay.glyph.font = uifonts.glyphs
overlay.glyph.margin = 0
overlay.glyph.char_size = overlay.charsize*1.25
overlay.glyph.align = Align.MiddleCentre
//overlay.glyph.set_bg_rgb (100,0,0)
overlay.glyph.bg_alpha = 0
overlay.glyph.set_rgb(themeT.listboxselbg.r,themeT.listboxselbg.g,themeT.listboxselbg.b)
overlay.glyph.word_wrap = true

overlay.wline = fe.add_rectangle(overlay.x,overlay.y + overlay.labelheight-2,overlay.w,2)

overlay.shad.push (fe.add_image(AF.folder+"pics/grads/wgradientBb.png", overlay.x, fl.y + fl.h-UI.footer.h+overlay.ex_bottom, overlay.w, floor(50 * UI.scalerate)))
overlay.shad.push (fe.add_image(AF.folder+"pics/grads/wgradientTb.png", overlay.x, overlay.y-floor(50 * UI.scalerate), overlay.w, floor(50 * UI.scalerate)))
overlay.shad.push (fe.add_image(AF.folder+"pics/grads/wgradientLb.png", overlay.x-floor(50 * UI.scalerate), overlay.y,floor(50 * UI.scalerate), overlay.h))
overlay.shad.push (fe.add_image(AF.folder+"pics/grads/wgradientRb.png", overlay.x + overlay.w, overlay.y, floor(50 * UI.scalerate), overlay.h))

foreach (item in overlay.shad){
	item.alpha = 0
	item.set_rgb(0,0,0)
}

overlay.wline.alpha = 0
overlay.wline.set_rgb(themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)


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

	frostshaders(true)

	overlay.background.visible = true
	flowT.zmenubg = startfade(flowT.zmenubg,0.08,0.0)
	flowT.frostblur = startfade(flowT.frostblur,0.08,0.0)
}

function frosthide(){
	flowT.zmenubg = startfade(flowT.zmenubg,-0.10,0.0)
	flowT.frostblur = startfade(flowT.frostblur,-0.10,0.0)
}

function frostshaders (turnon){

	if (turnon){
	//	frost.top.shader = flipshader
		frost.surf_rt.visible = true
		frost.surf_rt.redraw = frost.surf_2.redraw = frost.surf_1.redraw = true
		frost.surf_1.shader = shader_fr.h
		frost.pic.shader = shader_fr.v
	}
	else{
	//	frost.top.shader = noshader
		frost.surf_rt.visible = false
		frost.surf_rt.redraw = frost.surf_2.redraw = frost.surf_1.redraw = false
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
	if (prf.LAYERVIDEO) bgs.bgvid_top.video_playing = false

	if (!prf.DMPENABLED) frostshow()

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
	if (prf.LAYERVIDEO) bgs.bgvid_top.video_playing = true

	frosthide()

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
		if 	  (selection == AF.req.keyboard) out.push ("⌨")
		else if ((selection == AF.req.executef) || (selection == AF.req.exenoret) )out.push ("⏩")
		else if (selection == AF.req.filereqs) out.push ("⏏")
		else if (selection == AF.req.menusort) out.push ("☰")
		else if (selection == AF.req.slideint) out.push (AF.prefs.l1[index][i].values)
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
	bg = fe.add_rectangle(0,0,0,0)
	description = fe.add_text("",0,0,100,100)
	helppic = fe.add_image(AF.folder+"pics/transparent.png",0,fl.h_os*0.5,fl.h_os*0.5,fl.h_os*0.5)
	showing = false
	browsershowing = false
	rgbshowing = false
	browserfile = ""
	browserdir = []
	//	picratew = overlay.fullwidth * 0.3
	picrateh = overlay.menuheight * 0.4
	//	picratew = 1.25 * overlay.menuheight * 0.4
	picratew = overlay.fullwidth * 0.3

}

// First calculation of bottom panel
prfmenu.picratew = prfmenu.picrateh = (overlay.menuheight * 1.0 / overlay.rows) * 2.0 - UI.padding * 0.5
prfmenu.picratew = overlay.menuheight - overlay.rows * floor(((overlay.menuheight - prfmenu.picratew)*1.0/overlay.rows))
prfmenu.picrateh = prfmenu.picratew

//prfmenu.description.set_bg_rgb(100,0,0)
prfmenu.description.char_size = 48 * UI.scalerate
prfmenu.description.font = uifonts.lite
prfmenu.description.align = Align.MiddleCentre
prfmenu.description.word_wrap = true
prfmenu.description.margin = 0
prfmenu.description.set_rgb (themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)
//overlay.listbox.set_bg_rgb(80,0,0)
//overlay.listbox.bg_alpha = 128
pixelizefont(prfmenu.description,48 * UI.scalerate-1)

prfmenu.helppic.preserve_aspect_ratio = true

prfmenu.bg.set_rgb (themeT.optionspanelrgb,themeT.optionspanelrgb,themeT.optionspanelrgb)
prfmenu.bg.alpha = themeT.optionspanelalpha

prfmenu.bg.set_pos(overlay.x, overlay.y + overlay.labelheight + overlay.menuheight - prfmenu.picrateh , overlay.fullwidth , prfmenu.picrateh)
prfmenu.helppic.set_pos (prfmenu.bg.x, prfmenu.bg.y, prfmenu.picratew , prfmenu.picrateh)
prfmenu.description.set_pos (prfmenu.bg.x + UI.padding + prfmenu.picratew , prfmenu.bg.y , overlay.fullwidth - prfmenu.picratew - 2*UI.padding , prfmenu.picrateh)
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
		prfmenu.helppic.set_rgb(themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)
	}

	else if (level == 2) {
		prfmenu.helppic.set_rgb(255,255,255)

		try {
			prfmenu.helppic.file_name = AF.folder + AF.prefs.imgpath + AF.prefs.l1[prfmenu.outres0][zmenu.selected].picsel[AF.prefs.l1[prfmenu.outres0][zmenu.selected].selection]
		}
		catch(err){
			try {prfmenu.helppic.file_name = AF.folder + AF.prefs.imgpath + AF.prefs.l1[prfmenu.outres0][var].pic}
			catch (err) {
				prfmenu.helppic.file_name = AF.folder + AF.prefs.imgpath + "gear2.png"
				prfmenu.helppic.set_rgb(themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)
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
				prfmenu.helppic.set_rgb(themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)
			}
		}
	}
}

//Third level menu
function optionsmenu_lev3(){
	prfmenu.description.msg = AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].help
	prfmenu.level = 3

	updatemenu(prfmenu.level,AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].selection)
	if (AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].selection >= 0 ){
		// MULTIPLE CHOICE OPTION (selection >= 0)
		zmenudraw (AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].options, buildselectarray(AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].options,AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].selection),null,AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].title ,0xe991,AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].selection,false,false,true,false,false,
		function(prfmenures2){
			prfmenu.res2 = prfmenures2
			if (prfmenu.res2 != -1) {
				if(prf.THEMEAUDIO) snd.clicksound.playing = true
				AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].selection = prfmenu.res2
				prfmenu.outres2 = prfmenu.res2
				optionsmenu_lev3()
			}
			else {
				optionsmenu_lev2()
			}
		})
	}
	else if (AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].selection == AF.req.keyboard){
		// TEXT INPUT OPTION WITH KEYBOARD (selection = AF.req.keyboard)
		zmenuhide()
		flowT.zmenudecoration = startfade(flowT.zmenudecoration,0.2,0.0)

		keyboard_select (0, UI.vertical ? 1 : 0)

		keyboard_show(AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].title,AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values ,
		function(){ //TYPE
			return
		},
		function(){ //BACK
			optionsmenu_lev2()
			return
		},
		function(){ //DONE
			AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values = keyboard_entrytext
			prfmenu.res2 = -1
			optionsmenu_lev2()
			return
		}
		)

		//AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values = fe.overlay.edit_dialog( AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].title, AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values )
		//prfmenu.res2 = -1
		//optionsmenu_lev2()

	}
	else if (AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].selection == AF.req.textentr){
		// TEXT INPUT OPTION (selection = AF.req.textentr)
		AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values = fe.overlay.edit_dialog( AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].title, AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values )
		prfmenu.res2 = -1
		optionsmenu_lev2()
	}
	else if (AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].selection == AF.req.executef){
		// EXECUTE FUNCTION OPTION (selection = AF.req.executef)
		AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values()
		prfmenu.res2 = -1
		optionsmenu_lev2()
	}
	else if (AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].selection == AF.req.filereqs){
		// FILE REQUESTER OPTION (selection = AF.req.filereqs)
		AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values = filebrowser(AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values)
		prfmenu.res2 = -1
	}
	else if (AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].selection == AF.req.menusort){
		// MENU SORT AND CUSTOMIZE OPTION (selection = AF.req.menusort)
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
	else if (AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].selection == AF.req.exenoret){
		// EXECUTE FUNCTION OPTION WITHOUT GETTING BACK TO MENU (selection = AF.req.exenoret)
		// Useful for options that require data input AND processing
		AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values()
	}
	else if (AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].selection == AF.req.rgbvalue){
		// RGB COLOR SELECTOR
		AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values = rgbselector(split(AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values," "),0,AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values,true)
	}
	else if (AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].selection == AF.req.huevalue){
		// HUE COLOR SELECTOR
		AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values = hueselector(AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values,0,AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values,true)
	}
	else if (AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].selection == AF.req.slideint){
		// SLIDER SELECTOR
		// in this case values is the current value, options is an array with min, max and default
		AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values = sliderval(AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].title,AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values,0,AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values,true,AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].options[0],AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].options[1],AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].options[2])
	}
}

//Second menu level
function optionsmenu_lev2(){

	prfmenu.level = 2
	zmenu.selected = prfmenu.outres1 //TEST143

	updatemenu(prfmenu.level,prfmenu.outres1)


	zmenudraw (getsubmenu(prfmenu.outres0),getsubmenuglyphs(prfmenu.outres0),getsubmenunotes(prfmenu.outres0),AF.prefs.l0[prfmenu.outres0].label,AF.prefs.l0[prfmenu.outres0].glyph,prfmenu.outres1,false,false,false,false,false,
	function(prfmenures1){
		prfmenu.res1 = prfmenures1
		// EXIT FROM SUBMENU 1
		try {prfmenu.description.msg = AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].help}catch(err){prfmenu.description.msg=""}
		if (prfmenu.res1 == -1) {
			prfmenu.outres1 = 0
			optionsmenu_lev1()
		}
		else {
			prfmenu.outres1 = prfmenu.res1
			optionsmenu_lev3()
		}
	}
	function(){//Left
		if (AF.prefs.l1[prfmenu.outres0][zmenu.selected].selection == AF.req.slideint){
			if(prf.THEMEAUDIO) snd.wooshsound.playing = true

			AF.prefs.l1[prfmenu.outres0][zmenu.selected].values = AF.prefs.l1[prfmenu.outres0][zmenu.selected].values - 1
			if (AF.prefs.l1[prfmenu.outres0][zmenu.selected].values < AF.prefs.l1[prfmenu.outres0][zmenu.selected].options[0])
				AF.prefs.l1[prfmenu.outres0][zmenu.selected].values = AF.prefs.l1[prfmenu.outres0][zmenu.selected].options[0]

			prfmenu.outres1 = zmenu.selected
			optionsmenu_lev2()
			return
		}

		if (AF.prefs.l1[prfmenu.outres0][zmenu.selected].selection < 0) return

		if (AF.prefs.l1[prfmenu.outres0][zmenu.selected].selection == 0) {
			if(prf.THEMEAUDIO) snd.wooshsound.playing = true

			AF.prefs.l1[prfmenu.outres0][zmenu.selected].selection = AF.prefs.l1[prfmenu.outres0][zmenu.selected].values.len() - 1
			prfmenu.outres1 = zmenu.selected
			optionsmenu_lev2()
			return
		}
		if (AF.prefs.l1[prfmenu.outres0][zmenu.selected].selection > 0){
			if (prf.THEMEAUDIO) snd.clicksound.playing = true

			AF.prefs.l1[prfmenu.outres0][zmenu.selected].selection --
			prfmenu.outres1 = zmenu.selected
			optionsmenu_lev2()
			return
		}
	}
	function(){//Right
		if (AF.prefs.l1[prfmenu.outres0][zmenu.selected].selection == AF.req.slideint){
			if(prf.THEMEAUDIO) snd.wooshsound.playing = true

			AF.prefs.l1[prfmenu.outres0][zmenu.selected].values = AF.prefs.l1[prfmenu.outres0][zmenu.selected].values + 1
			if (AF.prefs.l1[prfmenu.outres0][zmenu.selected].values > AF.prefs.l1[prfmenu.outres0][zmenu.selected].options[1])
				AF.prefs.l1[prfmenu.outres0][zmenu.selected].values = AF.prefs.l1[prfmenu.outres0][zmenu.selected].options[1]

			prfmenu.outres1 = zmenu.selected
			optionsmenu_lev2()
			return
		}

		if (AF.prefs.l1[prfmenu.outres0][zmenu.selected].selection < 0) return
		if (AF.prefs.l1[prfmenu.outres0][zmenu.selected].selection == AF.prefs.l1[prfmenu.outres0][zmenu.selected].values.len() - 1) {

			if(prf.THEMEAUDIO) snd.wooshsound.playing = true

			AF.prefs.l1[prfmenu.outres0][zmenu.selected].selection = 0
			prfmenu.outres1 = zmenu.selected
			optionsmenu_lev2()

			return
		}
		if (AF.prefs.l1[prfmenu.outres0][zmenu.selected].selection < AF.prefs.l1[prfmenu.outres0][zmenu.selected].values.len() - 1){
			if (prf.THEMEAUDIO) snd.clicksound.playing = true

			AF.prefs.l1[prfmenu.outres0][zmenu.selected].selection ++
			prfmenu.outres1 = zmenu.selected
			optionsmenu_lev2()
		}
	})
}


//First menu level
function optionsmenu_lev1(){
	prfmenu.description.msg = AF.prefs.l0[prfmenu.outres0].description
	prfmenu.level = 1
	updatemenu(prfmenu.level,prfmenu.outres0)

	// First level menu
	zmenudraw (AF.prefs.a0, AF.prefs.gl0,null,ltxt("Layout options",AF.LNG), 0xe991, prfmenu.outres0,false,false,false,false,false,
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

				AF.LNG = prf.LAYOUTLANGUAGE
				savelanguage(AF.LNG)

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
			while (AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].selection == AF.req.liner){
				prfmenu.outres1++
			}
			try {prfmenu.description.msg = AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].help}catch(err){prfmenu.description.msg=""}
			optionsmenu_lev2()
		}
	},
	null,
	function (){
		for (local i = zmenu.selected; i < items.len(); i++){
			if (zmenu.strikelines[i].visible) {
				zmenu.selected = i+1
				break
			}
		}
		//zmenu.selected = 5
		//optionsmenu_lev1()
	})
}

function optionsmenu_boot(){

	prfmenu.res0 = prfmenu.res1 = prfmenu.res2 = prfmenu.outres0 = prfmenu.outres1 = prfmenu.outres2 = prfmenu.level = 0
	prfmenu.showing = true

	prfmenu.bg.visible = prfmenu.description.visible = prfmenu.helppic.visible = true

	selection_pre = generateselectiontable()

	optionsmenu_lev1()
}

function savecurrentoptions(){
	zmenuhide()
	flowT.zmenudecoration = startfade(flowT.zmenudecoration,0.2,0.0)

	keyboard_select (0, UI.vertical ? 1 : 0)

	keyboard_show("Name","",
	function(){ //TYPE
		return
	},
	function(){ //BACK
		prfmenu.res2 = -1
		optionsmenu_lev2()
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
		optionsmenu_lev2()
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
		zmenudraw (optionsnames,null,null,"Options files",null,0,false,false,false,false,false,
		function(out){
			if (out == -1){
				optionsmenu_lev2()
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

/// RGB Selector ///

function rgbselector(rgb,sel,old,start){
	//local r = 128
	//local g = 120
	//local b = 50
	if (start) prfmenu.helppic.file_name = "pics/white.png"
	prfmenu.rgbshowing = true
	local rgbstart = 0
	local rgbstop = rgbstart + 2

	if (start) {
		rgb = split(old," ")
		foreach (i, val in rgb) rgb[i] = rgb[i].tointeger()
	}
	if (rgb.len() == 0) rgb = [255,255,255]
	prfmenu.helppic.set_rgb(rgb[0],rgb[1],rgb[2])

	local spaces = zmenu.items[0].width / (0.5 * uifonts.pixel * overlay.charsize)

	zmenudraw(["R:  "+textrate(rgb[0],255,spaces,"Ⓞ ","Ⓟ "),"G:  "+textrate(rgb[1],255,spaces,"Ⓞ ","Ⓟ "),"B:  "+textrate(rgb[2],255,spaces,"Ⓞ ","Ⓟ "),ltxt("ACTIONS",AF.LNG),ltxt("APPLY",AF.LNG),ltxt("DEFAULT",AF.LNG)],[0,0,0,-1,0,(start && (old=="")) ? 0xea10 : 0xe965],[rgb[0],rgb[1],rgb[2],"","",""],ltxt("RGB Color",AF.LNG),0xe992,sel,false,false,false,false,false,
	function(out){
		if (out == -1) {
			prfmenu.rgbshowing = false
			AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values = old
			optionsmenu_lev2()
			return
		}
		else if (out == 5){
			//SET DEFAULT
			prfmenu.rgbshowing = false
			AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values = ""
			optionsmenu_lev2()
			return
		}
		else {
			//SET RGB
			prfmenu.rgbshowing = false
			AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values = rgb[0]+" "+rgb[1]+" "+rgb[2]
			optionsmenu_lev2()
			return
		}
	}
	function(){
		if ((zmenu.selected >=rgbstart) && (zmenu.selected <=rgbstop)){
			if ( (checkrepeat (count.left)) && (rgb[zmenu.selected - rgbstart] > 0) ){
				rgb[zmenu.selected - rgbstart] = rgb[zmenu.selected - rgbstart] - 1 - round(count.left/5,1)
				if (rgb[zmenu.selected - rgbstart] < 0) rgb[zmenu.selected - rgbstart] = 0
				rgbselector(rgb,zmenu.selected,old,false)
				count.left ++
			}
		}
	}
	function(){
		if ((zmenu.selected >=rgbstart) && (zmenu.selected <=rgbstop)){
			if ( (checkrepeat (count.right)) && (rgb[zmenu.selected - rgbstart] < 255) ){
				rgb[zmenu.selected - rgbstart] = rgb[zmenu.selected - rgbstart] + 1 + round(count.right/5,1)
				if (rgb[zmenu.selected - rgbstart] > 255) rgb[zmenu.selected - rgbstart] = 255
				rgbselector(rgb,zmenu.selected,old,false)
				count.right ++
			}
		}
	}
	)
}

/// HUE Selector ///


function hueselector(hue,sel,old,start){

	if (start) prfmenu.helppic.file_name = "pics/white.png"
	prfmenu.rgbshowing = true

	if (start) hue = old
	if (hue == "") hue = 0 else hue = hue.tointeger()
	local rgbval = hsl2rgb(hue,1.0,0.5)

	prfmenu.helppic.set_rgb(rgbval.R*255,rgbval.G*255,rgbval.B*255)

	local spaces = (zmenu.items[0].width / (0.5 * uifonts.pixel * overlay.charsize)) - 5

	zmenudraw(["HUE:  "+textrate(hue,359,spaces,"Ⓞ ","Ⓟ "),ltxt("ACTIONS",AF.LNG),ltxt("APPLY",AF.LNG),ltxt("DEFAULT",AF.LNG)],[0,-1,0,(start && (old=="")) ? 0xea10 : 0xe965],[hue,"","",""],ltxt("HUE Value",AF.LNG),0xe992,sel,false,false,false,false,false,
	function(out){
		if (out == -1) {
			prfmenu.rgbshowing = false
			AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values = old
			optionsmenu_lev2()
			return
		}
		else if (out == 5){
			//SET DEFAULT
			prfmenu.rgbshowing = false
			AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values = ""
			optionsmenu_lev2()
			return
		}
		else {
			//SET VAL
			prfmenu.rgbshowing = false
			AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values = hue
			optionsmenu_lev2()
			return
		}
	}
	function(){

		if (zmenu.selected == 0){
			if ( (checkrepeat (count.left)) && (hue > 0) ){
				hue = hue - 1 - round(count.left/5,1)
				if (hue < 0) hue = 0
				hueselector(hue,zmenu.selected,old,false)
				count.left ++
			}
		}

	}
	function(){

		if (zmenu.selected == 0){
			if ( (checkrepeat (count.right)) && (hue < 359) ){
				hue = hue + 1 + round(count.right/5,1)
				if (hue > 359) hue = 359
				hueselector(hue,zmenu.selected,old,false)
				count.right ++
			}
		}
	}
	)
}

function sliderval(name,val,sel,old,start,vmin,vmax,def){

	// val: current value during the edit process
	// sel: selected entity
	// old: previous selected value when entering the menu
	// start : boolean true only when the slider is initialised
	// vmin: beginning value
	// vmax: ending value
	// def: default value. Normally the default value is "" but this can be set to show the actual default value

	if (typeof val == "string") val = val.tointeger()
	if (typeof def == "string") def = def.tointeger()
	if (typeof old == "string") old = old.tointeger()

	if (start) val = old

	/*
	if (val == "") {
		val = def
	 } else {
		val = val.tointeger()
	 }
*/
	local spaces = (zmenu.items[0].width / (0.5 * uifonts.pixel * overlay.charsize)) - 8

	zmenudraw([vmin +" "+ textrate(val - vmin,vmax - vmin,spaces,"Ⓞ ","Ⓟ ") + vmax,ltxt("ACTIONS",AF.LNG),ltxt("APPLY",AF.LNG),ltxt("DEFAULT",AF.LNG)],[0,-1,0,(val == def) ? 0xea10 : 0xe965],[val,"","",""],name,0xe992,sel,false,false,false,false,false,
	function(out){
		if (out == -1) {
			AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values = old
			optionsmenu_lev2()
			return
		}
		else if (out == 3){
			//SET DEFAULT
			AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values = def
			//val = ""
			//sliderval(val,zmenu.selected,old,false,vmin,vmax,def)
			optionsmenu_lev2()
			return
		}
		else {
			//SET VAL
			AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values = val
			optionsmenu_lev2()
			return
		}
	}
	function(){

		if (zmenu.selected == 0){
			if ( (checkrepeat (count.left)) && (val > vmin) ){
				val = val - 1 - round(count.left/5,1)
				if (val < vmin) val = vmin
				sliderval(name,val,zmenu.selected,old,false,vmin,vmax,def)
				count.left ++
			}
		}
	}
	function(){

		if (zmenu.selected == 0){
			if ( (checkrepeat (count.right)) && (val < vmax) ){
				val = val + 1 + round(count.right/5,1)
				if (val > vmax) val = vmax
				sliderval(name,val,zmenu.selected,old,false,vmin,vmax,def)
				count.right ++
			}
		}
	}
	)
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

	lastname.push( ltxt ("DEFAULT", AF.LNG) )
	lastname.push( ltxt ("Attract Folder", AF.LNG) )
	lastname.push( ltxt ("Arcadeflow Folder", AF.LNG) )
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

	zmenudraw (lastname,folderappend,null,fb.startdir,0xe930,4+fb.select0,false,false,false,false,false,
	function(out){
		fb.file00 = fb.startdir

		if (out == -1) {
			prfmenu.browsershowing = false
			AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values = file0
			optionsmenu_lev2()
			return
		}
		if (out == 0) {
			prfmenu.browsershowing = false
			AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values = AF.prefs.defaults[AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].varname.toupper()]
			optionsmenu_lev2()
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
				optionsmenu_lev2()
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
		try {prfmenu.helppic.file_name = fb.sortdir[fb.select0]} catch (err) {prfmenu.helppic.file_name = AF.folder+"pics/transparent.png"}

		//decompound directory path
		fb.prevdirarray = split(fb.startdir,"\\/")

		// By default make previous directory equal to actual
		fb.prevdir = fb.startdir

		if (AF.prefs.driveletters.len() > 0) { // Prev directory and fb.root management for Windows
			if (fb.prevdirarray.len() > 1) {
				fb.prevdir = fb.prevdir.slice(0,-1 -1 * fb.prevdirarray[fb.prevdirarray.len()-1].len()) //NEW MAC
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
			if ( fb.prevdirarray.len() > 0 ) fb.prevdir = fb.prevdir.slice(0, -1 -1 * fb.prevdirarray[fb.prevdirarray.len()-1].len())
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
		fb.startdir = fb.file00.slice(0,-1 -1 * startdir0[startdir0.len()-1].len())
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
	fb.prevdir = fb.prevdir.slice(0,-1 -1 * fb.prevdirarray[fb.prevdirarray.len()-1].len())
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

	rt_stringkeys = "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ <"
	rt_keys = {}

	text_base = "" // This is the pre-text to show
	f_type = null // Custom function when key pressed
	f_back = null // Custom fuction when leaving using back
	f_done = null // Custom function when done is selected
}

// Populate the rt_keys structure
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
         kb.rt_keys[letterchar] <- {
               val = letterchar
               prs = false
            }
      }
   }
}

local keyboard_text = null

function keyboard_show(text_base,entrytext,f_type,f_back,f_done){

	keyboard_surface.visible = true
	keyboard_surface.redraw = true

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

	if (kb.keys.rawin(previous)){
		kb.keys[previous].set_rgb( kb.keylow,kb.keylow,kb.keylow )
		kb.keys[previous].alpha = 255
	}
	if (kb.keys.rawin(selected)){
		kb.keys[selected].set_rgb( 255,255,255 )
		kb.keys[selected].alpha = 255
	}
	key_selected = [ col, row ]
}

function keyboard_type(c){
	if ( c == "<" ) //BACKSPACE
		keyboard_entrytext = ( keyboard_entrytext.len() > 0 ) ? keyboard_entrytext.slice( 0, keyboard_entrytext.len() - 1 ) : ""
	else if ( c == "|" ) //CLEAR ALL
		keyboard_entrytext = ""
		//keyboard_clear()
	else if ( c == "~" ){ //DONE applica la ricerca e chiude la sessione.
		kb.f_done()
		keyboard_hide()
	}
	else if (c != "_") // Key pressed is not a FAKE KEY
		keyboard_entrytext = keyboard_entrytext + c

	// GENERAL UPDATE
	keyboard_text.msg = kb.text_base + ": " + keyboard_entrytext
	// Custom update
	kb.f_type()
}

function keyboard_draw() {

	//draw the search surface bg
	local bg = keyboard_surface.add_image("pics/ui/kbg2.png", 0, 0, keyboard_surface.width, keyboard_surface.height)
	bg.alpha = 230

	//draw the search text object
	local osd_search = {
		x = ( keyboard_surface.width * 0 ) * 1.0,
		y = ( keyboard_surface.height * 0.2 ) * 1.0,
		width = ( keyboard_surface.width * 1 ) * 1.0,
		height = ( keyboard_surface.height * 0.1 ) * 1.0
	}

	keyboard_text = keyboard_surface.add_text(keyboard_entrytext, osd_search.x, osd_search.y, osd_search.width, osd_search.height)
	keyboard_text.align = Align.MiddleLeft
	keyboard_text.font = uifonts.gui
	keyboard_text.set_rgb( 255, 255, 255 )
	keyboard_text.alpha = 255
	keyboard_text.char_size = 80 * UI.scalerate


	//draw the search key objects
	foreach ( key,val in key_names ) {

		local key_name = (key == "{") ? " " : (key == "}") ? " " : (key == "_") ? " " : ( key == "|" ) ? "⌧" : ( key == " " ) ? "⎵" : ( key == "<" ) ? "⌫" : ( key == "~" ) ? "DONE" : key.toupper()

		local textkey = keyboard_surface.add_text( key_name, -1, -1, 1, 1 )

		textkey.font = uifonts.gui
		textkey.char_size = (80*0+75) * UI.scalerate

		textkey.set_rgb( kb.keylow,kb.keylow,kb.keylow)
		textkey.alpha = 255

		textkey.set_bg_rgb (60,60,60)
		textkey.bg_alpha = 128
		textkey.align = Align.MiddleCentre

		pixelizefont(textkey,(80*0+75) * UI.scalerate)

		kb.keys[ key ] <- textkey

	}


	//set search key positions
	local row_count = 0
	foreach (idrow, row in key_rows )
	{
		local col_count = 0
		local osd = {
			x = floor( keyboard_surface.width * 0.1 ) * 1.0,
			y = floor( keyboard_surface.height * 0.4 ) * 1.0,
			width = ( keyboard_surface.width * 0.8 ) * 1.0,
			height = ( keyboard_surface.height * 0.5 ) * 1.0
		}
		osd.width = keyboard_surface.width - 2 * osd.x

		local key_width = floor( (osd.width / row.len() ) * 1.0)
		local key_height = floor( (osd.height / key_rows.len() ) * 1.0)

		foreach (idchar, char in row )
		{
			local current_key_width = key_width * key_sizes[idrow][idchar]
			if ((char.tochar() != "{") && (char.tochar() != "}")) {
				local key_image = kb.keys[char.tochar()]
				local pos = {
					x = osd.x + ( key_width * col_count ) + 2,
					y = osd.y + key_height * row_count + 2,
					w = current_key_width - 4,
					h = key_height - 4
				}

				pos.x = pos.x + (osd.width - key_width * row.len() )*0.5

				key_image.set_pos( pos.x, pos.y, pos.w, pos.h )
			}
			col_count = col_count + key_sizes[idrow][idchar]
		}
		row_count++
	}
	keyboard_surface.visible = false
	keyboard_surface.redraw = false
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

	keyboard_select (0, UI.vertical ? 1 : 0)

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
	local tagsnotes = []
	foreach (item, array in z_list.tagstableglobal) {
		//if ((item != "COMPLETED") && (item != "HIDDEN")) {
			tagsarray.push(item)
			tagstatus.push(0)
		//}
	}
	tagsarray.sort (@(a,b) a.tolower()<=>b.tolower())

	foreach (i, item in tagsarray){
		tagsnotes.push(z_list.tagstable.rawin(item) ? "" : "not here")
	}

	tagsarray.insert (0,"USER TAGS")
	tagstatus.insert (0,-1)
	tagsnotes.insert (0,"")

	if (prf.ENABLEHIDDEN){
		tagsarray.insert (0,"HIDDEN")
		tagstatus.insert (0, z_list.boot2[fe.list.index].z_hidden ? 0xea0b : 0xea0a)
		tagsnotes.insert (0,"")
	}

	tagsarray.insert (0,"COMPLETED")
	tagstatus.insert (0,z_list.boot2[fe.list.index].z_completed ? 0xea0b : 0xea0a)
	tagsnotes.insert (0,"")


	for (local i = (prf.ENABLEHIDDEN ? 3 : 2) ; i < tagsarray.len() ; i++){
		tagstatus[i] = (z_list.gametable2[z_list.index].z_tags.find(tagsarray[i]) == null) ? 0xea0a : 0xea0b
	}

	tagsarray.push ("")
	tagstatus.push (-1)
	tagsnotes.push ("")

	if(prf.ENABLEHIDDEN){
		tagsarray.push (prf.SHOWHIDDEN ? ltxt("Hide Hidden",AF.LNG) : ltxt("Show Hidden",AF.LNG))
		tagstatus.push (0)
		tagsnotes.push ("")
	}
	tagsarray.push (ltxt("New Tag",AF.LNG))
	tagstatus.push (0xeaee)
	tagsnotes.push ("")

	zmenudraw (tagsarray,tagstatus,tagsnotes,ltxt("TAGS",AF.LNG),0xeaef,0,false,false,true,false,false,
	function(out){
		if (out == -1) { //BACK
			frosthide()
			zmenuhide()
		}
		else if ((out == tagsarray.len()-2) && (prf.ENABLEHIDDEN)){ //CHANGE HIDDEN STATUS
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

			if (out == 0) z_list.boot2[fe.list.index].z_completed = !z_list.boot2[fe.list.index].z_completed
			else if ((out == 1) && (prf.ENABLEHIDDEN)) z_list.boot2[fe.list.index].z_hidden = !z_list.boot2[fe.list.index].z_hidden
			else {
				if (tagstatus[out] == 0xea0a) {
					z_list.boot2[fe.list.index].z_tags.push (tagsarray[out])
					//add_tag (tagsarray[out])
				}
				else {
					z_list.boot2[fe.list.index].z_tags.remove (z_list.boot2[fe.list.index].z_tags.find(tagsarray[out]))
					//remove_tag (tagsarray[out])
				}
			}
			z_updatetagstable() //TEST141 sposta sopra e fallo solo se il tag non era nella tagstable :O
			saveromdb (z_list.gametable[z_list.index].z_emulator,z_list.db2[z_list.gametable[z_list.index].z_emulator],"db2")

			mfz_build(true)
			try {
				mfz_load()
				mfz_populatereverse()
			} catch(err){}
			mfz_apply(false)

			zmenuhide()
			frosthide()
		}
		return
	})
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
		z_list.boot2[fe.list.index].z_tags.push (keyboard_entrytext)
		saveromdb (z_list.gametable[z_list.index].z_emulator,z_list.db2[z_list.gametable[z_list.index].z_emulator],"db2")

		z_list.tagstableglobal.rawset(keyboard_entrytext,0)
		z_updatetagstable()

		mfz_build(true)
		try {
			mfz_load()
			mfz_populatereverse()
		} catch(err){}
		mfz_apply(false)
		//add_tag (keyboard_entrytext)
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
	x = fl.x + fl.w * hist.split_h + 15 * UI.scalerate,
	y = fl.y + 15 * UI.scalerate,
	w = fl.w * (1.0 - hist.split_h) - 30 * UI.scalerate,
	h = fl.h * 0.25 - 30 * UI.scalerate
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

	charsize = 0
	linesize = 0

	col2 = 0
	split2 = 0
}

if (UI.vertical){

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

	if (hist.panel_ar <= 0.6){ // SMALL PANEL

		hist_titleT.x = fl.x + 0.58 * fl.w
		hist_titleT.w = (1.0 - 0.58) * fl.w
		hist_titleT.h = (1.0 - 0.58) * fl.w * 0.3

		hist_textT.y = fl.y + fl.h * hist.split_h
		hist_textT.h = fl.h * (1.0 - hist.split_h)
	}

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
local hist_bg = history_surface.add_text("",0,0,history_surface.width,history_surface.height)
hist_bg.set_bg_rgb(0,0,0)
hist_bg.bg_alpha = 1
*/

picture.bg_hist = history_surface.add_image(AF.folder+"pics/black.png",0,0,fl.w_os,fl.h_os)
picture.bg_hist.alpha = 1

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
	else picture.bg.file_name = AF.folder+"pics/transparent.png"

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

if (!UI.vertical){
	histgr.black = history_surface.add_image(AF.folder+"pics/black.png",0,0,fl.w*hist.split_h+0.5*(fl.w_os-fl.w) + fl.w_os*fl.overscan_x,fl.h_os)
	histgr.g1 = history_surface.add_image(AF.folder+"pics/grads/wgradientT.png",0,0,fl.w*hist.split_h+0.5*(fl.w_os-fl.w) + fl.w_os*fl.overscan_x,fl.h_os*0.5)
	histgr.g2 = history_surface.add_image(AF.folder+"pics/grads/wgradientB.png",0,fl.h_os*0.5,fl.w*hist.split_h+0.5*(fl.w_os-fl.w) + fl.w_os*fl.overscan_x,fl.h_os*0.5)
}
else{
	histgr.black = history_surface.add_image(AF.folder+"pics/black.png",0,0,fl.w_os,fl.h*hist.split_h+0.5*(fl.h_os-fl.h) + fl.h_os*fl.overscan_y)
	histgr.g1 = history_surface.add_image(AF.folder+"pics/grads/wgradientL.png",0,0,fl.w_os*0.5,fl.h*hist.split_h+0.5*(fl.h_os-fl.h) + fl.h_os*fl.overscan_y)
	histgr.g2 = history_surface.add_image(AF.folder+"pics/grads/wgradientR.png",fl.w_os*0.5,0,fl.w_os*0.5,fl.h*hist.split_h+0.5*(fl.h_os-fl.h) + fl.h_os*fl.overscan_y)
}

histgr.black.set_rgb (0,0,0)
histgr.g1.set_rgb (0,0,0)
histgr.g2.set_rgb (0,0,0)

histgr.g1.alpha = histgr.g2.alpha = (prf.DARKPANEL == null ? 0 : 150)
histgr.black.alpha =  (prf.DARKPANEL == null ? 0 : (prf.DARKPANEL == true ? 180 : 50))


local hist_white = null

if (prf.HISTORYPANEL){
	if (UI.vertical) {
		hist_white = history_surface.add_rectangle(0,fl.y + fl.h*hist.split_h,hist_textT.w+(fl.w_os-fl.w),fl.h-hist_screenT.h+0.5*(fl.h_os-fl.h))
	}
	else{
		hist_white = history_surface.add_rectangle(hist_textT.x,0,hist_textT.w + 0.5*(fl.w_os-fl.w),fl.h_os)
	}
	hist_white.set_rgb(255,255,255)
	hist_white.alpha = 200
}

local hist_title = history_surface.add_image(AF.folder+"pics/transparent.png",hist_titleT.x,hist_titleT.y,hist_titleT.w,hist_titleT.h)
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

	hist_titletxt_bot.char_size = 150 * UI.scalerate
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

hist_titletxt_bd.char_size = hist_titletxt.char_size = 150 * UI.scalerate
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

local pixelpic = fe.add_image("pics/pixel8.png",0,0)
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

hist_textT.charsize = (prf.LOWRES ? 55 * UI.scalerate : (40 * UI.scalerate > 8 ? 40 * UI.scalerate : 8))
hist_textT.linesize = hist_textT.charsize * 1.5
hist_textT.col2 = hist_textT.charsize * 5 * 0.88

local hist_text = null

if (!prf.LOWRES){
	if (!UI.vertical){ // HORIZONTAL SCREEN
		if (hist.panel_ar <= 0.6) { //SMALL PANEL
			hist_text = {
				title = hist_text_surf.add_text("", 0, 0*hist_textT.linesize, hist_textT.w, 2 * hist_textT.linesize)
				manuf = hist_text_surf.add_text("", 0, 2*hist_textT.linesize, hist_textT.w, hist_textT.linesize)
				systm = hist_text_surf.add_text("", 0, 3*hist_textT.linesize, hist_textT.w, hist_textT.linesize)
				categ = hist_text_surf.add_text("", 0, 4*hist_textT.linesize, hist_textT.w, hist_textT.linesize)
				serie = hist_text_surf.add_text("", 0, 5*hist_textT.linesize, hist_textT.w, hist_textT.linesize)

				copy  = hist_text_surf.add_text("", 0, 6*hist_textT.linesize, hist_textT.w*0.5, hist_textT.linesize)
				playr = hist_text_surf.add_text("", hist_textT.w*0.5, 6*hist_textT.linesize, hist_textT.w*0.5, hist_textT.linesize)
				buttn = hist_text_surf.add_text("", 0, 7*hist_textT.linesize, hist_textT.w*0.5, hist_textT.linesize)
				ratng = hist_text_surf.add_text("", hist_textT.w*0.5, 7*hist_textT.linesize, hist_textT.w*0.5, hist_textT.linesize)

				tags  = hist_text_surf.add_text("", 0, 8*hist_textT.linesize, hist_textT.w, hist_textT.linesize)

				descr = hist_text_surf.add_text("", 0, 9*hist_textT.linesize, hist_textT.w, hist_textT.h - 9*hist_textT.linesize)
			}
		}
		else if (hist.panel_ar <= 1.0) { // DEFAULT PANEL STRUCTURE, UP TO AR = 1.0
			hist_text = {
				title = hist_text_surf.add_text("", 0, 0*hist_textT.linesize, hist_textT.w, 2 * hist_textT.linesize)
				manuf = hist_text_surf.add_text("", 0, 2*hist_textT.linesize, hist_textT.w - hist_textT.col2, hist_textT.linesize)
				systm = hist_text_surf.add_text("", 0, 3*hist_textT.linesize, hist_textT.w - hist_textT.col2, hist_textT.linesize)
				categ = hist_text_surf.add_text("", 0, 4*hist_textT.linesize, hist_textT.w - hist_textT.col2, hist_textT.linesize)
				serie = hist_text_surf.add_text("", 0, 5*hist_textT.linesize, hist_textT.w - hist_textT.col2, hist_textT.linesize)
				tags  = hist_text_surf.add_text("", 0, 6*hist_textT.linesize, hist_textT.w, hist_textT.linesize)

				copy  = hist_text_surf.add_text("", hist_textT.w - hist_textT.col2, 2*hist_textT.linesize, hist_textT.col2, hist_textT.linesize)
				playr = hist_text_surf.add_text("", hist_textT.w - hist_textT.col2, 3*hist_textT.linesize, hist_textT.col2, hist_textT.linesize)
				buttn = hist_text_surf.add_text("", hist_textT.w - hist_textT.col2, 4*hist_textT.linesize, hist_textT.col2, hist_textT.linesize)
				ratng = hist_text_surf.add_text("", hist_textT.w - hist_textT.col2, 5*hist_textT.linesize, hist_textT.col2, hist_textT.linesize)

				descr = hist_text_surf.add_text("", 0, 7*hist_textT.linesize, hist_textT.w, hist_textT.h - 7*hist_textT.linesize)
			}

		}
		else { // LARGE PANEL STRUCTURE, FROM AR > 1.0
			// calculation of data panel size for large aspects
			hist_textT.split2 = (fl.h * 0.5)/hist_textT.w
			hist_text = {
				title = hist_text_surf.add_text("", 0, 0, hist_textT.w * hist_textT.split2, 3 * hist_textT.linesize)
				manuf = hist_text_surf.add_text("", 0, 3*hist_textT.linesize, hist_textT.w * hist_textT.split2 , hist_textT.linesize)
				systm = hist_text_surf.add_text("", 0, 4*hist_textT.linesize, hist_textT.w * hist_textT.split2 , hist_textT.linesize)
				categ = hist_text_surf.add_text("", 0, 5*hist_textT.linesize, hist_textT.w * hist_textT.split2 , hist_textT.linesize)
				serie = hist_text_surf.add_text("", 0, 6*hist_textT.linesize, hist_textT.w * hist_textT.split2 , hist_textT.linesize)

				copy  = hist_text_surf.add_text("", 0, 7*hist_textT.linesize, 0.5*(hist_textT.w * hist_textT.split2), hist_textT.linesize)
				playr = hist_text_surf.add_text("", 0.5*(hist_textT.w * hist_textT.split2), 7*hist_textT.linesize, 0.5*(hist_textT.w * hist_textT.split2), hist_textT.linesize)
				buttn = hist_text_surf.add_text("", 0, 8*hist_textT.linesize, 0.5*(hist_textT.w * hist_textT.split2), hist_textT.linesize)
				ratng = hist_text_surf.add_text("", 0.5*(hist_textT.w * hist_textT.split2), 8*hist_textT.linesize, 0.5*(hist_textT.w * hist_textT.split2), hist_textT.linesize)

				tags  = hist_text_surf.add_text("", 0, 9*hist_textT.linesize, hist_textT.w * hist_textT.split2, 3*hist_textT.linesize)

				descr = hist_text_surf.add_text("", hist_textT.w * hist_textT.split2, 0*hist_textT.linesize, hist_textT.w * (1.0 - hist_textT.split2), hist_textT.h )
			}

		}
	}
	else { //VERTICAL SCREEN
		if (hist.panel_ar <= 0.6) { //SMALL PANEL
			hist_textT.split2 = 0.58
			hist_text = {
				title = hist_text_surf.add_text("", 0, 0*hist_textT.linesize, hist_textT.w  * hist_textT.split2, 2*hist_textT.linesize)
				manuf = hist_text_surf.add_text("", 0, 2*hist_textT.linesize, hist_textT.w * hist_textT.split2, hist_textT.linesize)
				systm = hist_text_surf.add_text("", 0, 3*hist_textT.linesize, hist_textT.w * hist_textT.split2, hist_textT.linesize)
				categ = hist_text_surf.add_text("", 0, 4*hist_textT.linesize, hist_textT.w * hist_textT.split2, hist_textT.linesize)
				serie = hist_text_surf.add_text("", 0, 5*hist_textT.linesize, hist_textT.w * hist_textT.split2, hist_textT.linesize)

				copy  = hist_text_surf.add_text("", 0, 6*hist_textT.linesize, hist_textT.w*hist_textT.split2/4.0, hist_textT.linesize)
				playr = hist_text_surf.add_text("", hist_textT.w*hist_textT.split2*1.0/4.0, 6*hist_textT.linesize, hist_textT.w*hist_textT.split2/4.0, hist_textT.linesize)
				buttn = hist_text_surf.add_text("", hist_textT.w*hist_textT.split2*2.0/4.0, 6*hist_textT.linesize, hist_textT.w*hist_textT.split2/4.0, hist_textT.linesize)
				ratng = hist_text_surf.add_text("", hist_textT.w*hist_textT.split2*3.0/4.0, 6*hist_textT.linesize, hist_textT.w*hist_textT.split2/4.0, hist_textT.linesize)


				tags  = hist_text_surf.add_text("", 0, 7*hist_textT.linesize, hist_textT.w * hist_textT.split2, 2.0*hist_textT.linesize)

				descr = hist_text_surf.add_text("", hist_textT.w*hist_textT.split2, hist_titleT.h+0.5*hist_textT.linesize, hist_textT.w*(1.0-hist_textT.split2), hist_textT.h - (hist_titleT.h+0.5*hist_textT.linesize) )
			}

		}
		else if (hist.panel_ar <= 1.0) { // DEFAULT PANEL STRUCTURE, UP TO AR = 1.0
			hist_textT.split2 = 0.58
			hist_text = {
				title = hist_text_surf.add_text("", 0, 0*hist_textT.linesize, hist_textT.w, 1.5*hist_textT.linesize)
				manuf = hist_text_surf.add_text("", 0, 1.5*hist_textT.linesize, hist_textT.w * hist_textT.split2, hist_textT.linesize)
				systm = hist_text_surf.add_text("", 0, 2.5*hist_textT.linesize, hist_textT.w * hist_textT.split2, hist_textT.linesize)
				categ = hist_text_surf.add_text("", 0, 3.5*hist_textT.linesize, hist_textT.w * hist_textT.split2, hist_textT.linesize)
				serie = hist_text_surf.add_text("", 0, 4.5*hist_textT.linesize, hist_textT.w * hist_textT.split2, hist_textT.linesize)

				copy  = hist_text_surf.add_text("", 0, 5.5*hist_textT.linesize, hist_textT.w*hist_textT.split2/4.0, hist_textT.linesize)
				playr = hist_text_surf.add_text("", hist_textT.w*hist_textT.split2*1.0/4.0, 5.5*hist_textT.linesize, hist_textT.w*hist_textT.split2/4.0, hist_textT.linesize)
				buttn = hist_text_surf.add_text("", hist_textT.w*hist_textT.split2*2.0/4.0, 5.5*hist_textT.linesize, hist_textT.w*hist_textT.split2/4.0, hist_textT.linesize)
				ratng = hist_text_surf.add_text("", hist_textT.w*hist_textT.split2*3.0/4.0, 5.5*hist_textT.linesize, hist_textT.w*hist_textT.split2/4.0, hist_textT.linesize)


				tags  = hist_text_surf.add_text("", 0, 6.5*hist_textT.linesize, hist_textT.w * hist_textT.split2, 2.0*hist_textT.linesize)

			//	compl = hist_text_surf.add_text("", hist_textT.w - hist_textT.col2, 6*hist_textT.linesize, hist_textT.col2, hist_textT.linesize)
				descr = hist_text_surf.add_text("", hist_textT.w*hist_textT.split2, 1.5*hist_textT.linesize, hist_textT.w*(1.0-hist_textT.split2), hist_textT.h - hist_textT.linesize )
			}
		}
		else  { // LONG PANEL STRUCTURE AR > 1.0
			hist_textT.split2 = 0.5
			hist_text = {
				title = hist_text_surf.add_text("", 0, 0*hist_textT.linesize, hist_textT.w, 1.5*hist_textT.linesize)
				manuf = hist_text_surf.add_text("", 0, 1.5*hist_textT.linesize, hist_textT.w * hist_textT.split2, hist_textT.linesize)
				systm = hist_text_surf.add_text("", 0, 2.5*hist_textT.linesize, hist_textT.w * hist_textT.split2, hist_textT.linesize)
				categ = hist_text_surf.add_text("", 0, 3.5*hist_textT.linesize, hist_textT.w * hist_textT.split2, hist_textT.linesize)
				serie = hist_text_surf.add_text("", 0, 4.5*hist_textT.linesize, hist_textT.w * hist_textT.split2, hist_textT.linesize)

				copy  = hist_text_surf.add_text("", 0, 5.5*hist_textT.linesize, hist_textT.w*hist_textT.split2/2.0, hist_textT.linesize)
				playr = hist_text_surf.add_text("", hist_textT.w*hist_textT.split2*1.0/2.0, 5.5*hist_textT.linesize, hist_textT.w*hist_textT.split2/2.0, hist_textT.linesize)
				buttn = hist_text_surf.add_text("", 0, 6.5*hist_textT.linesize, hist_textT.w*hist_textT.split2/2.0, hist_textT.linesize)
				ratng = hist_text_surf.add_text("", hist_textT.w*hist_textT.split2*1.0/2.0, 6.5*hist_textT.linesize, hist_textT.w*hist_textT.split2/2.0, hist_textT.linesize)


				tags  = hist_text_surf.add_text("", 0, 7.5*hist_textT.linesize, hist_textT.w * hist_textT.split2, 3.0*hist_textT.linesize)

				descr = hist_text_surf.add_text("", hist_textT.w*hist_textT.split2, 1.5*hist_textT.linesize, hist_textT.w*(1.0-hist_textT.split2), hist_textT.h - hist_textT.linesize )
			}
		}
	}
}
else { //LOW RES MODE
	hist_text = {
		title = null
		manud = null
		systm = null
		categ = null
		serie = null
		copy = null
		playr = null
		buttn = null
		ratng = null
		tags = null
		descr = hist_text_surf.add_text("",0,0,(UI.vertical && ((prf.HISTORYSIZE == 0.45) || (prf.HISTORYSIZE == -1))) ? hist_textT.w*0.58 : hist_textT.w,hist_textT.h)
	}
}
local gradshader = fe.add_shader (Shader.Fragment, "glsl/blackgrad3.glsl")
gradshader.set_texture_param( "texture")
//gradshader.set_param ("limits", 0.2 , 0.05, 0.5)
//gradshader.set_param ("limits", (40 * UI.scalerate * 1.7) / hist_textT.h , 40 * UI.scalerate * 5.0 / hist_textT.h)


function descrshader(enable){
	if (!UI.vertical) {
		gradshader.set_param ("limits", enable ? hist_textT.linesize * 1.25 / hist_textT.h : 0.0, hist_textT.linesize * 3.0 / hist_textT.h)
		gradshader.set_param ("blanker", 0.0, (hist_text.descr.y + 3)*1.0 / hist_textT.h)
	}
	else {
		gradshader.set_param ("limits", enable ? hist_textT.linesize * 1.25 / hist_textT.h : 0.0,hist_textT.linesize * 3.0 / hist_textT.h)
		gradshader.set_param ("blanker",hist_text.descr.x*1.0/hist_textT.w, (hist_text.descr.y + 3)*1.0/ hist_textT.h)
	}
}

descrshader(false)

foreach (item in hist_text){
	if (item != null){
		item.word_wrap = false
		item.char_size = hist_textT.charsize
		item.visible = true
		item.align = Align.MiddleLeft
		item.margin = -1
		//item.set_bg_rgb(0,0,0)
		//item.bg_alpha = 250.0*(item.y/hist_textT.linesize)/10.0
		pixelizefont(item, floor(hist_textT.charsize),0.5*floor(hist_textT.charsize))
	}
}

hist_text.descr.line_spacing = 1.15
pixelizefont(hist_text.descr, floor(hist_textT.charsize),0.5*floor(hist_textT.charsize),0.7*1.15)
hist_text.descr.y = hist_text.descr.y + 0.25*hist_textT.linesize
hist_text.descr.height = hist_text.descr.height - 0.25*hist_textT.linesize

if (hist_text.title != null) {
	hist_text.title.align = Align.MiddleCentre
	hist_text.title.margin = 0
	hist_text.title.word_wrap = true
	//hist_text.tags.align = Align.TopLeft
	hist_text.descr.first_line_hint = 1
	hist_text.title.x = hist_text.title.x + 1 //Add fake 1 pixel margin to title
	hist_text.title.width = hist_text.title.width -2
}

function hist_text_rgb(r,g,b){
	foreach (item in hist_text) {
		if (item != null) item.set_rgb(r,g,b)
	}
}

function hist_text_alpha(a){
	foreach (item in hist_text) {
		if (item != null) item.alpha = a
	}
}

if (!prf.LOWRES){

	if (!UI.vertical){
		hist_text["line_title_bot"] <- hist_text_surf.add_rectangle(20 * UI.scalerate,hist_text.title.y + hist_text.title.height,hist_text.title.width - 40 * UI.scalerate,1)
		hist_text["line_tags_top"] <- hist_text_surf.add_rectangle(20 * UI.scalerate,hist_text.tags.y, hist_text.title.width - 40 * UI.scalerate,1)
		hist_text["line_tags_bot"] <- hist_text_surf.add_rectangle(20 * UI.scalerate,hist_text.tags.y + hist_text.tags.height,hist_text.title.width - 40 * UI.scalerate,1)

		if (hist.panel_ar <= 0.6) { //SMALL PANEL
			hist_text["line_series_bot"] <- hist_text_surf.add_rectangle(20 * UI.scalerate,hist_text.serie.y+hist_text.serie.height, hist_text.serie.width - 40 * UI.scalerate,1)
			hist_text.title.line_spacing = 0.8
			hist_text.title.margin = 0
		}
		else if (hist.panel_ar <= 1.0) { // DEFAULT PANEL STRUCTURE, UP TO AR = 1.0
			hist_text["line_vertical"] <- hist_text_surf.add_rectangle(hist_textT.w - hist_textT.col2, 20 * UI.scalerate + 2 * hist_textT.linesize,1,4*hist_textT.linesize - 40 * UI.scalerate)
		}
	}
	else {
		hist_text["line_title_bot"] <- hist_text_surf.add_rectangle(20 * UI.scalerate,hist_text.title.y + hist_text.title.height,hist_text.title.width - 40 * UI.scalerate,1)
		hist_text["line_series_bot"] <- hist_text_surf.add_rectangle(20 * UI.scalerate,hist_text.serie.y+hist_text.serie.height, hist_text.serie.width - 40 * UI.scalerate,1)
		hist_text["line_tags_top"] <- hist_text_surf.add_rectangle(20 * UI.scalerate,hist_text.tags.y, hist_text.tags.width - 40 * UI.scalerate,1)
		hist_text["line_tags_bot"] <- hist_text_surf.add_rectangle(20 * UI.scalerate,hist_text.tags.y + hist_text.tags.height,hist_text.tags.width - 40 * UI.scalerate,1)

		if (hist.panel_ar <= 0.6) { //SMALL PANEL
			hist_text.title.line_spacing = 0.8
			hist_text.title.margin = 0
		}
	}
}

/*
hist_text.char_size = (prf.LOWRES ? 55 * UI.scalerate : (40 * UI.scalerate > 8 ? 40 * UI.scalerate : 8))
hist_text.align = Align.TopCentre
hist_text.first_line_hint = 1
*/
//TEST126
//hist_text.char_size = 42 * UI.scalerate
//hist_text.font = uifonts.monodata

if (prf.HISTORYPANEL) {
	hist_text_rgb(themeT.themehistorytextcolor,themeT.themehistorytextcolor,themeT.themehistorytextcolor)
	hist_text_surf.set_rgb(themeT.themehistorytextcolor,themeT.themehistorytextcolor,themeT.themehistorytextcolor)
}
else {
	hist_text_rgb(themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)
	hist_text_surf.set_rgb(themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)
}


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
local hist_glow_pic = shadowsurf_1.add_image(AF.folder+"pics/transparent.png",(shadow.radius-0.5*histglow.w*(shadow.enlarge - 1.0))*shadow.downsample,(shadow.radius-0.5*histglow.w*(shadow.enlarge - 1.0))*shadow.downsample,histglow.w*shadow.enlarge*shadow.downsample,histglow.w*shadow.enlarge*shadow.downsample)
hist_glow_pic.mipmap = 1
hist_glow_pic.preserve_aspect_ratio = false

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
hist_screen.preserve_aspect_ratio = false
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

if (prf.CONTROLOVERLAY != "never"){

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
		pic = AF.folder+"pics/transparent.png"
		pica = AF.folder+"pics/transparent.png"
		btxy = [ [0,0],[0,0],[0,0],[0,0],[0,0],[0,0]]
		btalign = [Align.TopLeft,Align.TopLeft,Align.TopLeft,Align.TopLeft,Align.TopLeft,Align.TopLeft]
	}

	hist_over.surface = history_surface.add_surface(hist_screenT.w, floor(hist_screenT.h*(280.0/800.0)))

	hist_over.surface.set_pos (hist_screenT.x, hist_screenT.y+floor(hist_screenT.h*(520.0/800.0)))
	hist_over.overcontrol = hist_over.surface.add_image(AF.folder+"pics/transparent.png",0,0,hist_over.surface.width,hist_over.surface.height)
	hist_over.overbuttons = hist_over.surface.add_image(AF.folder+"pics/transparent.png",0,0,hist_over.surface.width,hist_over.surface.height)
	hist_over.overbuttons2 = hist_over.surface.add_image(AF.folder+"pics/transparent.png",0,0,hist_over.surface.width,hist_over.surface.height)
	hist_over.overbuttons.alpha = hist_over.overcontrol.alpha = 220

	for (local i = 0 ; i < 6 ; i++){
		hist_over.btsh.push (hist_over.surface.add_text(i,0,0,ceil(120 * hist_over.picscale), ceil(65 * hist_over.picscale)))
		hist_over.bt.push (hist_over.surface.add_text(i,0,0,ceil(120 * hist_over.picscale), ceil(65 * hist_over.picscale)))
		hist_over.btsh[i].align = hist_over.bt[i].align = Align.MiddleLeft
		hist_over.btsh[i].char_size = hist_over.bt[i].char_size = 22*hist_over.picscale
		hist_over.btsh[i].word_wrap = hist_over.bt[i].word_wrap = true
		hist_over.btsh[i].margin = hist_over.bt[i].margin = 0
		hist_over.btsh[i].line_spacing = hist_over.bt[i].line_spacing = 0.75
		hist_over.btsh[i].font = hist_over.bt[i].font = uifonts.gui
		hist_over.btsh[i].set_rgb(80,80,80)
		hist_over.btsh[i].alpha = 80
		pixelizefont(hist_over.btsh[i],22*hist_over.picscale,0,0.5)
		pixelizefont(hist_over.bt[i],22*hist_over.picscale,0,0.5)

	//	hist_over.bt[i].set_bg_rgb(200,0,0)
	}
}



function history_updateoverlay(){


	if ((prf.CONTROLOVERLAY == "arcade") && (system_data[z_list.gametable[z_list.index].z_system.tolower()].group != "ARCADE")) {
		hist_over.surface.visible = false
	} else {
		hist_over.surface.visible = true
	}


	try {hist_over.overcontrol.file_name = "metapics/overlaycontroller/"+controller_pic (z_list.gametable[z_list.index].z_control)}catch(err){}

	local commands = []

	local numbuttons = z_list.gametable[z_list.index].z_buttons
	local labeldata = hist_over.overlaybuttonsdata["0"]
	try {labeldata = hist_over.overlaybuttonsdata[numbuttons]}catch(err){}
	for (local i = 0 ; i < 6 ; i++){
		hist_over.bt[i].set_pos (floor(hist_over.picscale*labeldata.btxy[i][0]),floor(hist_over.picscale*labeldata.btxy[i][1]))
		hist_over.btsh[i].set_pos (floor(hist_over.picscale*labeldata.btxy[i][0] + 3 * UI.scalerate),floor(hist_over.picscale*labeldata.btxy[i][1]+5 * UI.scalerate))
		hist_over.btsh[i].align = hist_over.bt[i].align = labeldata.btalign[i]
		hist_over.btsh[i].msg = hist_over.bt[i].msg =""
	}

	local rom = fe.game_info( Info.Name )

	local commands_dat = []
	local commands_scrape = []
	try {commands_dat = commandtable[rom]}catch(err){}
	commands = z_list.gametable[z_list.index].z_commands
	if (commandtable.rawin(rom)) commands = commandtable[rom]
//	if (commands_scrape.len() == 0) commands = commands_dat else commands = commands_scrape

	local commandnull = true
	foreach(i, item in commands){
		if (item != "") commandnull = false
	}

	if ((commands.len() > 0) && !commandnull){
		if (numbuttons == "") numbuttons = "0"
		try {hist_over.overbuttons2.file_name = "metapics/overlaybuttons/"+numbuttons+"over.png"}catch(err){}
		for (local i = 0 ; i < min(commands.len(),min(6,numbuttons.tointeger())) ; i++){
			hist_over.btsh[i].msg = hist_over.bt[i].msg = commands[i].toupper()
		}
	}
	else {
		hist_over.overbuttons2.file_name = AF.folder+"pics/transparent.png"
	}
		try {hist_over.overbuttons.file_name = "metapics/overlaybuttons/"+numbuttons+".png"}catch(err){}
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

	local histAR = getvidAR(0,hist_screen,tilez[focusindex.new].refsnapz,0)
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

	local nativeres = null

	try {
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
	hist_text.descr.first_line_hint = 1

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

	local packcols = 34
	local packside = 6
	local packstring = ""

	if (prf.HISTMININAME) {
		hist_text_tempmessage =  ("\n"+ gamename1(z_list.gametable[z_list.index].z_title) + "\n")
	}
	else if (prf.LOWRES){
		hist_text.descr.msg = z_list.gametable[z_list.index].z_title + "\n\n"
		hist_text.descr.msg = hist_text.descr.msg + "©"+z_list.gametable[z_list.index].z_year + " " + gly(0xe906) + z_list.gametable[z_list.index].z_manufacturer
		hist_text.descr.msg = hist_text.descr.msg + gly(0xe90b) + z_list.gametable[z_list.index].z_system + "\n"
		hist_text.descr.msg = hist_text.descr.msg + gly(0xe902) + z_list.gametable[z_list.index].z_category + " "
		hist_text.descr.msg = hist_text.descr.msg + gly(0xe905) + z_list.gametable[z_list.index].z_series +"\n"
		hist_text.descr.msg = hist_text.descr.msg + gly(0xe903) + " "
		foreach (i, item in z_list.gametable2[z_list.index].z_tags){
			hist_text.descr.msg = hist_text.descr.msg + item
			if (i < z_list.gametable2[z_list.index].z_tags.len()-1)
				hist_text.descr.msg = hist_text.descr.msg +", "
		}

		//hist_text.compl.msg = (z_list.gametable2[z_list.index].z_favourite ? gly(0xe90a) : gly(0xe909)) + "  " + (z_list.gametable2[z_list.index].z_completed ? gly(0xe908) : gly (0xe907))
		hist_text.descr.msg = hist_text.descr.msg + gly(0xe900) + z_list.gametable[z_list.index].z_players+" "+gly(0xe901) + z_list.gametable[z_list.index].z_buttons+" "+gly(0xe904)  + z_list.gametable[z_list.index].z_rating+"\n"

	}
	else {
		hist_text.title.msg = z_list.gametable[z_list.index].z_title
		hist_text.title.word_wrap = true
		hist_text.systm.msg = gly(0xe90b) + " " + z_list.gametable[z_list.index].z_system
		hist_text.manuf.msg = gly(0xe906) + " " + z_list.gametable[z_list.index].z_manufacturer
		hist_text.categ.msg = gly(0xe902) + " " + z_list.gametable[z_list.index].z_category
		hist_text.serie.msg = gly(0xe905) + " " + z_list.gametable[z_list.index].z_series
		hist_text.tags.msg  = gly(0xe903) + " "
		foreach (i, item in z_list.gametable2[z_list.index].z_tags){
			hist_text.tags.msg = hist_text.tags.msg + item
			if (i < z_list.gametable2[z_list.index].z_tags.len()-1)
				hist_text.tags.msg = hist_text.tags.msg +", "
		}
		hist_text.tags.word_wrap = true
		hist_text.copy.msg = "©"+z_list.gametable[z_list.index].z_year
		//hist_text.compl.msg = (z_list.gametable2[z_list.index].z_favourite ? gly(0xe90a) : gly(0xe909)) + "  " + (z_list.gametable2[z_list.index].z_completed ? gly(0xe908) : gly (0xe907))
		hist_text.playr.msg = gly(0xe900) + " " + z_list.gametable[z_list.index].z_players
		hist_text.buttn.msg = gly(0xe901) + " " + z_list.gametable[z_list.index].z_buttons
		hist_text.ratng.msg = gly(0xe904) + " " + z_list.gametable[z_list.index].z_rating
	}

		hist_curr_rom = rom
		local alt = fe.game_info( Info.AltRomname )
		local cloneof = fe.game_info( Info.CloneOf )

		local lookup = af_get_history_offset( sys, rom, alt, cloneof )

		local tempdesc = "" //this description comes from history.dat

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
			else{
				tempdesc = ""
				foreach (i, item in z_list.gametable[z_list.index].z_description)
					tempdesc = tempdesc + item + "\n"
			}
		}

		local tempdesc3 = "" //this comes from the overview
		tempdesc3 = fe.game_info(Info.Overview)

		if(tempdesc3 != "") tempdesc = tempdesc3+"\n\n"

		local tempdesc2 = "" //This comes from the romlist
				foreach (i, item in z_list.gametable[z_list.index].z_description)
					tempdesc2 = tempdesc2 + item + "\n"
		if ((tempdesc2 != "?") && (tempdesc2 != "")){
			tempdesc = tempdesc2 + "\n\n"
		}


		if (prf.LOWRES) tempdesc = hist_text.descr.msg + "\n"+tempdesc

		hist_text.descr.msg = tempdesc+"ROM:"+z_list.gametable[z_list.index].z_name+"\nScrape:"+z_list.gametable[z_list.index].z_scrapestatus+"\n"
		hist_text.descr.align = Align.TopCentre
		hist_text.descr.word_wrap = true
		hist_text.descr.first_line_hint = 1
		hist_text.descr.margin = 0.3 * hist_textT.linesize

		descrshader(false)

		//hist_text.title.msg = hist_text_tempmessage + tempdesc+z_list.gametable[z_list.index].z_name+"\n"+"Scrape: "+z_list.gametable[z_list.index].z_scrapestatus+"\n\n\n"
		//hist_text.msg = "\n"+packtext(packstring,packcols)
//	}
}

function history_show(h_startup)
{
	tilesTableZoom[focusindex.new] = startfade (tilesTableZoom[focusindex.new],-0.035,-5.0)

	if ((prf.AUDIOVIDSNAPS) && (prf.THUMBVIDEO)) tilez[focusindex.new].gr_vidsz.video_flags = Vid.NoAudio
	if (prf.THUMBVIDEO) videosnap_hide()
	if (prf.LAYERVIDEO) bgs.bgvid_top.video_playing = false

	history_updatesnap()
	history_updatetext()
	if (prf.CONTROLOVERLAY != "never") history_updateoverlay()

	if (h_startup) {
		history_surface.visible = true
		history_redraw(true)
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

	if ((prf.AUDIOVIDSNAPS) && (prf.THUMBVIDEO))  tilez[focusindex.new].gr_vidsz.video_flags = Vid.Default
	if (prf.THUMBVIDEO) videosnap_restore()
	if (prf.LAYERVIDEO) bgs.bgvid_top.video_playing = true

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

function af_on_scroll_up() {
	if (hist_text.descr.first_line_hint > 1) hist_text.descr.first_line_hint--
	if (hist_text.descr.first_line_hint == 1) descrshader(false)
}

function af_on_scroll_down() {
	if (hist_text.descr.first_line_hint == 1) descrshader(true)
	hist_text.descr.first_line_hint++
}

function history_exit () {
//	hist_title.file_name = AF.folder+"pics/transparent.png"
//	hist_screen.file_name = AF.folder+"pics/transparent.png"
	history_hide()
}

function history_redraw(status){
	history_surface.redraw = status
	hist_text_surf.redraw = status
	shadowsurf_rt.redraw = status
	shadowsurf_2.redraw = status
	shadowsurf_1.redraw = status
	hist_screensurf.redraw = status
	if(prf.CONTROLOVERLAY != "never") hist_over.surface.redraw = status
}

history_surface.visible = false
history_redraw(false)

history_surface.alpha = 0
history_surface.set_pos(0,0)

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
	h = overlay.menuheight
}

// DISPLAY ARTWORKS (FOR DISPLAYS MENU)
local disp = {
	images = []
	pos0 = []
	noskip = []
	bgshadowt = null
	bgshadowb = null

	tilew =  ((disp0.h > disp0.w * 0.485) ? disp0.w * 0.485 : disp0.h) //TEST120 was 0.5, then 0.485
	tileh =  ((disp0.h > disp0.w * 0.485) ? disp0.w * 0.485 : disp0.h)
	xstart = 0
	xstop = 0
	   bgtileh = 0
	speed = null
	pad = UI.padding
	width = null
	height = overlay.menuheight
	spacing = null
	x = null
	y = overlay.y + overlay.labelheight
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
disp.bgtileh = disp.tilew*9.0/16.0
if (prf.DMPIMAGES == "WALLS") disp.spacing = disp.bgtileh

function update_allgames_collections(verbose, tempprf){
	// Build the table of display data
	builddisplaystructure()

	local allgamesromlist = ""


	// Scan the AF collections table to build the complete romlists
	// AF collections have a "group" that indicates if they are for ARCADE, CONSOLE ecc
	// and then they feature a name to show in grouped mode, and one to show in ungrouped mode
	if (!tempprf.MASTERLIST) {
		foreach (item, val in z_af_collections.tab){
			// The all games collections are generated only if they are not in "OTHER"
			// or "ALL GAMES" or "COLLECTIONS" category and if they have some displays in them
			if ((val.group != "OTHER") && (val.group != "ALL GAMES") && (val.group != "COLLECTIONS") && (disp.structure[val.group].size > 0)) {
				// build the name for the allgames romlist
				local filename = AF.romlistfolder + item + ".txt"
				local strline = ""

				// Add the group romlist to the all games romlsit list
				allgamesromlist += " " + ap + AF.romlistfolder + item+".txt" + ap

				foreach (item2, val2 in disp.structure[val.group].disps){
					if (val2.inmenu) {
						if(verbose)z_splash_message ("Collection:"+item+"\nRomlist:"+val2.romlist+"\n")
						strline+= " "+ap+AF.romlistfolder +  val2.romlist + ".txt" + ap
					}
				}
				system ((OS == "Windows" ? "type" : "cat") + strline + " > " + ap + filename + ap)
			}
		}
	}
	else { //TEST139 READ THE WHOLE MASTERLIST TO CREATE THE CATEGORY ROMLISTS
		local listfile = ReadTextFile(prf.MASTERPATH)
		local listline = listfile.read_line()
		local listfields = []
		local outfiles = {}
		local sysname = ""
		local cursysname = ""
		while (!listfile.eos()){
			listline = listfile.read_line()
			if ((listline == "") || (listline[0].tochar()=="#")){
				print("")
				continue
			}

			listfields = splitlistline(listline)

			foreach (item, val in z_af_collections.tab){
				try {sysname = AF.emulatordata[listfields[2]].mainsysname}catch (err){sysname = ""}
				if ((system_data.rawin(sysname.tolower())) && (system_data[sysname.tolower()].group == val.group)){
					// Create output file handler
						if(verbose && (sysname != cursysname)){
							z_splash_message ("Collection:"+item+"\nSystem:"+sysname+"\n")
							cursysname = sysname
						}
					if (!outfiles.rawin(item)){

						outfiles.rawset(item, WriteTextFile(fe.path_expand(AF.romlistfolder + item + ".txt")))
						outfiles[item].write_line("#Name;Title;Emulator;CloneOf;Year;Manufacturer;Category;Players;Rotation;Control;Status;DisplayCount;DisplayType;AltRomname;AltTitle;Extra;Buttons;Series;Language;Region;Rating\n")
					}
					outfiles[item].write_line(listline+"\n")
				}
			}
		}
		foreach (item in outfiles) item.close_file()
	}

	// Now it's time to create the "AF All Games" collection. How is it done? I'd say it should be done by simply concatenating
	// existing groups
	if (tempprf.MASTERLIST) allgamesromlist = " "+ap+fe.path_expand(tempprf.MASTERPATH)+ap //TEST139 if master romlist is used, just copy that as all games romlist
	system ((OS == "Windows" ? "type" : "cat") + allgamesromlist + " > " + ap + AF.romlistfolder + "AF All Games.txt" + ap)
	system ((OS == "Windows" ? "type" : "cat") + allgamesromlist + " > " + ap + AF.romlistfolder + "AF Favourites.txt" + ap)
	system ((OS == "Windows" ? "type" : "cat") + allgamesromlist + " > " + ap + AF.romlistfolder + "AF Last Played.txt" + ap)

	//fe.set_display(fe.list.display_index)
}


/// Zmenu definition ///

zmenu = {
	items = []
	tilew = overlay.w
	tileh = floor(overlay.menuheight/overlay.rows)
	pos0 = []

	xstart = 0
	xstop = 0
	speed = null
	pad = floor(UI.padding * 0.5)
	width = overlay.w
	fullwidth = overlay.w
	height = overlay.menuheight
	x = overlay.x
	y = overlay.y + overlay.labelheight
	shown = 0 // Number of entry in the list
	selected = 0 // Index of the selected entry
	glyphs = []
	notes = []
	noteitems = []
	glyphw = floor(overlay.menuheight/overlay.rows)
	glyphh = floor(overlay.menuheight/overlay.rows)
	midoffset = 0
	virtualheight = 0
	blanker = null
	singleline = false

	overlaymsg = ""
	selectedbar = null
	sidelabel = null
	strikelines = []
	showing = false // Boolean to tell the layout that menu is showing

	reactfunction = null // Response function
	reactleft = null
	reactright = null

	midscroll = false // True if the menu scroll needs to be centered vertically

	similar = null

	simbg = null
	simpicbg = null
	simpic = null
	simvid = null
	simpicshL = null
	simpicshR = null
	simpicshT = null
	simpicshB = null
	simtxt = null
	simsys = null

	jumplevel = 0 //Level 0 for parent list, level 1 for sub-lists, exit arcadeflow added only on parent list


	dmp = false // True when Display Menu Page is on
	mfm = false // True when multifilter menu is on
	sim = false // True if similar games menu is on

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

zmenu_sh.surf_rt.set_pos(zmenu_surface_container.x + 4 * UI.scalerate,zmenu_surface_container.y + 8 * UI.scalerate,zmenu_surface_container.width,zmenu_surface_container.height)


zmenu.simbg = zmenu_surface_container.add_image(AF.folder+"pics/grads/wgradientRa.png",
										zmenu.tilew -1.0 * disp.width,
										0,//zmenu.y + zmenu.height*0.5 - 0.5*(zmenu.height-2.0*zmenu.pad),
										disp.width*0.25,
										zmenu.height)//(zmenu.height-2.0*zmenu.pad))
zmenu.simbg.alpha = 40
zmenu.simbg.set_rgb(0,0,0)
if (prf.DMPIMAGES == "WALLS") zmenu.simbg.zorder = 1000

// NICE: top 2.0 a150, bot 2.0 a150
// SHAD: top 0.25 a100, bot 0.5 a150
disp.bgshadowt = zmenu_surface_container.add_image(AF.folder+"pics/grads/wgradientTc.png",
										zmenu.tilew -1.0 * disp.width,
										0,
										disp.tilew,
										disp.bgtileh)//0.25
disp.bgshadowb = zmenu_surface_container.add_image(AF.folder+"pics/grads/wgradientBc.png",
										zmenu.tilew -1.0 * disp.width,
										0,
										disp.tilew,
										disp.bgtileh)//0.5

disp.bgshadowt.set_rgb(0,0,0)
disp.bgshadowb.set_rgb(0,0,0)
disp.bgshadowt.alpha = 180 + 0*255 + 0*100
disp.bgshadowb.alpha = 180 + 0*255 + 0*150
disp.bgshadowt.blend_mode = disp.bgshadowb.blend_mode = BlendMode.Overlay
if (prf.DMPIMAGES == "WALLS") disp.bgshadowt.zorder = disp.bgshadowb.zorder = 900


local zmenu_surface = zmenu_surface_container.add_surface (zmenu.width,zmenu.height)

zmenu_surface.add_image(AF.folder+"pics/black.png",0,0,zmenu_surface.width,zmenu_surface.height)
zmenu.selectedbar = zmenu_surface.add_rectangle(0,0,zmenu.width,zmenu.tileh)
zmenu.selectedbar.set_rgb(255,255,255)

zmenu.sidelabel = zmenu_surface.add_text("", zmenu.pad, 0, zmenu.width - 2 * zmenu.pad, zmenu.tileh )
zmenu.sidelabel.char_size = overlay.labelcharsize*0.8
zmenu.sidelabel.margin = 2
zmenu.sidelabel.set_rgb(0,0,0)
zmenu.sidelabel.align = Align.BottomRight
zmenu.sidelabel.font = uifonts.lite
zmenu.sidelabel.set_bg_rgb(0,200,0)
zmenu.sidelabel.bg_alpha = 0
zmenu.sidelabel.word_wrap = true
pixelizefont (zmenu.sidelabel,overlay.labelcharsize*0.8,2)

zmenu.blanker = zmenu_surface.add_rectangle(0,0,1,1)
zmenu.blanker.set_rgb(0,0,0)
zmenu.blanker.visible = false
zmenu_surface.shader = txtoalpha

function zmenudraw (menuarray,glypharray,sidearray,title,titleglyph,presel,shrink,dmpart,center,midscroll,singleline,response,left = null,right = null){
	zmenu.singleline = singleline

	disp.bgshadowb.visible = disp.bgshadowt.visible = zmenu.dmp && (prf.DMPIMAGES == "WALLS")

	if ((!zmenu.showing) && (prf.THEMEAUDIO)) snd.wooshsound.playing = true

	count.skipup = 0
	count.skipdown = count.mfskipdown = menuarray.len() - 1
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

	foreach (i, item in zmenu.notes) try {zmenu.notes[i] = zmenu.notes[i].toupper()} catch(err){}
	foreach (item in disp.images){
		item.file_name = AF.folder+"pics/transparent.png"
	}

	if (overmenu_visible()) overmenu_hide(false)

	// silence snap video sound
	if ((prf.AUDIOVIDSNAPS) && (prf.THUMBVIDEO)) tilez[focusindex.new].gr_vidsz.video_flags = Vid.NoAudio

	// Stops video thumb playback
	if (prf.THUMBVIDEO) videosnap_hide()
	if (prf.LAYERVIDEO) bgs.bgvid_top.video_playing = false

	// Initialize menu
	zmenu.blanker.visible = false
	zmenu.reactfunction = response
	zmenu.reactleft = left
	zmenu.reactright = right
	overlay.label.msg = title
	overlay.glyph.msg = gly(titleglyph)
	overlay.glyph.x = fl.x + fl.w * 0.5 - overlay.label.msg_width * 0.5 - overlay.labelheight

	overlay.sidelabel.visible = overlay.label.visible = overlay.glyph.visible = overlay.wline.visible = true

	flowT.zmenutx = startfade(flowT.zmenutx,0.05,0.0)
	flowT.zmenush = startfade(flowT.zmenush,0.05,0.0)

	// Change menu height if options menu is visible
	if (prfmenu.showing) {
		zmenu.glyphh = zmenu.tileh = ((prfmenu.bg.y - zmenu.y)/overlay.rows)
		zmenu.height = prfmenu.bg.y - zmenu.y
	}
	else {
		zmenu.glyphh = zmenu.tileh = (overlay.menuheight/overlay.rows)
		zmenu.height = overlay.menuheight
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
	local iskip = 0
	for (local i = 0 ; i < menuarray.len() ; i++){
		if (i >= zmenu.items.len()){
			zmenu.strikelines.push(null)
			zmenu.strikelines[i] = zmenu_surface.add_rectangle(0,0,1,1)
		}
		zmenu.strikelines[i].set_pos(shrink ? 0 : zmenu.pad , floor(zmenu.tileh * 0.5) + zmenu.midoffset + i * zmenu.tileh , zmenu.tilew -2*(shrink ? 0 : zmenu.pad) + (shrink ?  -1.0* disp.width : 0), 1)
		zmenu.strikelines[i].visible = false
		zmenu.strikelines[i].set_rgb(255,255,255)
		zmenu.strikelines[i].alpha = 128

		if (i >= zmenu.items.len()){
			zmenu.noteitems.push(null)
			zmenu.noteitems[i] = zmenu_surface.add_text(" ",0,0,1,1)
		}
		zmenu.noteitems[i].set_pos(0, zmenu.midoffset + i * zmenu.tileh , zmenu.tilew - zmenu.pad + (shrink ? zmenu.pad - disp.width : 0), zmenu.tileh)
		zmenu.noteitems[i].visible = true
		zmenu.noteitems[i].msg = zmenu.notes[i]
		zmenu.noteitems[i].font = uifonts.gui
		zmenu.noteitems[i].char_size = overlay.charsize
		zmenu.noteitems[i].word_wrap = true
		zmenu.noteitems[i].margin = 0
		zmenu.noteitems[i].align = Align.MiddleRight
		zmenu.noteitems[i].bg_alpha = 0
		zmenu.noteitems[i].set_rgb(255,255,255)

		if (i >= zmenu.items.len()){
			zmenu.glyphs.push(null)
			zmenu.glyphs[i] = zmenu_surface.add_text(" ",0,0,1,1)
		}
		zmenu.glyphs[i].set_pos (0, zmenu.height*0.5 - zmenu.tileh*0.5 + i * zmenu.tileh , zmenu.glyphw, zmenu.glyphh)

		zmenu.glyphs[i].font = uifonts.glyphs
		zmenu.glyphs[i].margin = 0
		zmenu.glyphs[i].char_size = overlay.charsize*1.25
		zmenu.glyphs[i].align = Align.MiddleCentre
		zmenu.glyphs[i].msg = (glypharray[i] == -1) ? "" : gly(glypharray[i])
		//zmenu.glyphs[i].set_bg_rgb (100,0,0)
		zmenu.glyphs[i].bg_alpha = 0
		zmenu.glyphs[i].set_rgb(255,255,255)
		zmenu.glyphs[i].visible = true
		//zmenu.glyphs[i].set_bg_rgb(200,0,0)


		//Y obj_item = zmenu_surface.add_text(" ",pad, zmenu.height*0.5 - zmenu.tileh*0.5 + i * zmenu.tileh , zmenu.tilew - 2.0*pad, zmenu.tileh)
		if (i >= zmenu.items.len()){
			zmenu.items.push(null)
			zmenu.items[i] = zmenu_surface.add_text(" ",0,0,1,1)
		}
		zmenu.items[i].set_pos(shrink ? 0 : zmenu.glyphw , zmenu.midoffset + i * zmenu.tileh , zmenu.tilew -2*(shrink ? 0 : zmenu.glyphw) + (shrink ?  -1.0* disp.width : 0), zmenu.tileh)
		zmenu.items[i].msg = menuarray[i]
		if (zmenu.items[i].msg == "EXIT ARCADEFLOW") zmenu.items[i].msg = ltxt("EXIT ARCADEFLOW",AF.LNG)
		zmenu.items[i].font = uifonts.gui
		zmenu.items[i].char_size = overlay.charsize
		zmenu.items[i].word_wrap = true
		zmenu.items[i].visible = true
		zmenu.items[i].margin = 0
		zmenu.items[i].align = (center ? Align.MiddleCentre : Align.MiddleLeft)
		zmenu.items[i].bg_alpha = 0
		zmenu.items[i].line_spacing = 1.0
		zmenu.items[i].set_rgb(255,255,255)
		//zmenu.items[i].set_bg_rgb(100,0,0)

		if ((zmenu.mfm) && (zmenu.noteitems[i].msg == "(0)")) {
			zmenu.items[i].set_rgb	(81,81,81)
			zmenu.noteitems[i].set_rgb (81,81,81)
		}

		if (zmenu.dmp || zmenu.sim) zmenu.noteitems[i].visible = false


		if (glypharray[i] == -1) {
			zmenu.items[i].msg = zmenu.items[i].msg.toupper()
			zmenu.items[i].font = uifonts.lite
			zmenu.items[i].align = Align.MiddleCentre
			zmenu.items[i].set_bg_rgb (0,0,0)
			zmenu.items[i].bg_alpha = 255
			zmenu.items[i].x = floor((shrink ? zmenu.tilew - disp.width : zmenu.tilew)*0.5 - zmenu.items[i].msg_width * 0.5 - zmenu.pad)
			zmenu.items[i].width = zmenu.items[i].msg_width + 2 *zmenu.pad
			zmenu.items[i].visible = zmenu.items[i].msg != ""
			zmenu.strikelines[i].visible = true
		}

		// Check if there's space for item _and_ notes
		if (!center){
			while (zmenu.items[i].msg_width + zmenu.noteitems[i].msg_width > (zmenu.tilew - zmenu.items[i].x)) {
				zmenu.items[i].width = zmenu.items[i].width * 0.5
				zmenu.noteitems[i].x = zmenu.items[i].x + zmenu.items[i].width
				zmenu.noteitems[i].width = zmenu.tilew - zmenu.pad + (shrink ? zmenu.pad - disp.width : 0) - zmenu.items[i].width - zmenu.items[i].x
			}
		}

		if (zmenu.dmp && prf.ALLGAMES){
			if (z_af_collections.tab.rawin(menuarray[i])){
				zmenu.items[i].msg = prf.DMPGROUPED ? z_af_collections.tab[menuarray[i]].groupedname : z_af_collections.tab[menuarray[i]].ungroupedname
			}
		}

		if ((prf.DMPIMAGES != null) && zmenu.dmp){
			artname = FeConfigDirectory+"menu-art/snap/"+menuarray[i]
			filename = ""

			local system_art = ""
			if (prf.DMPGENERATELOGO) {
				try {system_art = system_data[menuarray[i].tolower()].sysname}
				catch(err){/*print("system data error")*/}
			}

			if (prf.ALLGAMES){
				if (z_af_collections.tab.rawin(menuarray[i])){
					system_art = z_af_collections.tab[menuarray[i]].filename
				}
			}

			local af_art = null
			local ma_art = null
			if (prf.DMPIMAGES == "ARTWORK"){
				if ( file_exist (AF.folder+ "system_images/" + system_art+".png")) af_art = AF.folder+"system_images/" + system_art+".png"
			}
			else if (prf.DMPIMAGES == "WALLS"){
				if ( file_exist (AF.folder+ "system_bgs/" + system_art+".jpg")) af_art = AF.folder+"system_bgs/" + system_art+".jpg"
				else if ( file_exist (AF.folder+ "system_bgs/" + menuarray[i]+".jpg")) af_art = AF.folder+"system_bgs/" + menuarray[i]+".jpg"
			}

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

        if (glypharray[i] == -1) filename = AF.folder+"pics/transparent.png"

			if (glypharray[i] != -1) iskip = iskip + 1.0 else iskip = iskip + 0.0

			if (i >= disp.images.len()){
				disp.noskip.push(null)
			}

			disp.noskip[i] = iskip

			// Create new image slots if needed
			if (i >= disp.images.len()){

				disp.images.push(null)
            disp.pos0.push(null)
				// Create the image item and apply all default values to that
				if (prf.DMPIMAGES == "ARTWORK"){
					disp.images[i] = zmenu_surface_container.add_image( "", disp.x + pad + disp.width*0.5 - 0.5 * disp.tilew ,  disp.height * 0.5 - disp.tileh * 0.5 +pad + disp.noskip[i] * disp.spacing , disp.tilew  -2.0*pad, disp.tileh-2.0*pad )
				}
				else if (prf.DMPIMAGES == "WALLS"){
					disp.images[i] = zmenu_surface_container.add_image( "", disp.x, disp.noskip[i] * disp.bgtileh , disp.tilew , disp.bgtileh)
				}
				disp.images[i].preserve_aspect_ratio = true
				disp.images[i].video_flags = Vid.NoAudio
				disp.images[i].mipmap = 1
			}

			// Reposition the tiles and apply parameters that can change when a slot is already present
			if (prf.DMPIMAGES == "ARTWORK"){
				disp.images[i].set_pos(disp.x + pad + disp.width*0.5 - 0.5 * disp.tilew ,  disp.height * 0.5 - disp.tileh * 0.5 +pad + disp.noskip[i] * disp.spacing )
			}
			else if (prf.DMPIMAGES == "WALLS"){
				disp.images[i].set_pos(disp.x, disp.noskip[i] * disp.bgtileh )
			}
			disp.images[i].file_name = filename
         disp.images[i].visible = true
			disp.images[i].zorder = 100

			if (z_af_collections.tab.rawin(menuarray[i])) disp.images[i].blend_mode = BlendMode.Premultiplied
				else disp.images[i].blend_mode = 0
			/*
			obj_dispimage = zmenu_surface_container.add_image( "", disp.x + pad + disp.width*0.5 - 0.5 * disp.tilew ,  disp.height * 0.5 - disp.tileh * 0.5 +pad + i * disp.spacing , disp.tilew  -2.0*pad, disp.tileh-2.0*pad )
			obj_dispimage.preserve_aspect_ratio = true
			obj_dispimage.file_name = filename
			obj_dispimage.video_flags = Vid.NoAudio
			obj_dispimage.mipmap = 1
			if (z_af_collections.tab.rawin(menuarray[i])) obj_dispimage.blend_mode = BlendMode.Premultiplied
			*/
			//	try {disp.images[i] = obj_dispimage} catch (err) {disp.images.push (obj_dispimage)}
			disp.pos0[i] = disp.images[i].y + ((prf.DMPIMAGES == "WALLS") ? (zmenu.height - disp.bgtileh)*0.5 : 0)

			// Crop display artwork
			local extension = disp.images[i].file_name.slice(disp.images[i].file_name.len()-3,disp.images[i].file_name.len())
			if (( extension.tolower() == "jpg") && (prf.DMPIMAGES == "ARTWORK") ){
				local sizew = min(disp.images[i].texture_width,disp.images[i].texture_height)
				disp.images[i].subimg_width = sizew
				disp.images[i].subimg_height = sizew
				disp.images[i].subimg_x = (disp.images[i].texture_width - sizew  )*0.5
				disp.images[i].subimg_y = (disp.images[i].texture_height - sizew  )*0.5
			}
		}

		//try { zmenu.glyphs[i] = obj_glyph } catch (err) { zmenu.glyphs.push (obj_glyph) }
		//try { zmenu.items[i] = obj_item } catch (err) { zmenu.items.push (obj_item) }
		//try { zmenu.noteitems[i] = obj_note } catch (err) { zmenu.noteitems.push (obj_note) }
		//try { zmenu.strikelines[i] = obj_strikeline } catch (err) { zmenu.strikelines.push (obj_strikeline) }
		try { zmenu.pos0 [i] = zmenu.items[i].y } catch (err) { zmenu.pos0.push (zmenu.items[i].y) }

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
	if ((prf.DMPIMAGES != null) && zmenu.dmp){
		disp.xstop = - disp.noskip[zmenu.selected] * disp.spacing
		disp.xstart = disp.xstop
		foreach (id, item in disp.images){
			item.y = disp.pos0[id] + disp.xstop
		}
		disp.bgshadowb.y = disp.images[zmenu.selected].y + disp.images[zmenu.selected].height
		disp.bgshadowt.y = disp.images[zmenu.selected].y - disp.bgshadowt.height
		//disp.bgshadowt.visible = disp.bgshadowb.visible = !(disp.images[zmenu.selected].file_name == "")
	}

	zmenu.sidelabel.msg = zmenu.notes[zmenu.selected]
	zmenu.sidelabel.visible = zmenu.dmp || zmenu.sim

	zmenu.items[zmenu.selected].set_rgb(0,0,0)
	zmenu.glyphs[zmenu.selected].set_rgb(0,0,0)
	zmenu.noteitems[zmenu.selected].set_rgb(0,0,0)

	zmenu.selectedbar.y = zmenu.sidelabel.y = zmenu.items[zmenu.selected].y
	zmenu.selectedbar.height = zmenu.items[zmenu.selected].height
	//zmenu.selectedbar.width = zmenu.tilew + ((shrink && zmenu.sim) ?  -1*disp.width : 0)

	//this substitutes the row above to have shorter bar
	zmenu.selectedbar.width = zmenu.tilew + (shrink ?  -1*disp.width : 0)
	zmenu.simbg.visible = shrink


	zmenu.sidelabel.x = shrink ? 0 : zmenu.pad
	zmenu.sidelabel.width = shrink ? zmenu.width - disp.width : zmenu.width - 2 * zmenu.pad

	//TEST123 CHECK IF THIS CAN BE MOVED OUTSIDE OF THE CREATION
	if (prfmenu.showing){
		zmenu.blanker = zmenu_surface.add_image(AF.folder+"pics/black.png",0,zmenu.height,fl.w,prfmenu.picrateh+UI.padding)
		zmenu.blanker.visible = true
	}

	zmenu_surface.set_rgb(themeT.listboxselbg.r,themeT.listboxselbg.g,themeT.listboxselbg.b)

	zmenu_sh.surf_2.shader = (prf.DATASHADOWSMOOTH ? shader_tx2.v : noshader)
	zmenu_sh.surf_1.shader = (prf.DATASHADOWSMOOTH ? shader_tx2.h : noshader)

	zmenu_surface_container.visible = zmenu_sh.surf_rt.visible = true
	zmenu_surface_container.redraw = zmenu_surface.redraw = zmenu_sh.surf_rt.redraw = zmenu_sh.surf_2.redraw = zmenu_sh.surf_1.redraw = true

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
		zmenu.strikelines[i].y = zmenu.pos0[i] + floor(zmenu.tileh*0.5) + zmenu.xstop
	}

	for (local i = 0 ; i < zmenu.shown; i++){
		if (!zmenu.singleline) {
			zmenu.items[i].set_rgb (255,255,255)
			zmenu.noteitems[i].set_rgb (255,255,255)
			zmenu.glyphs[i].set_rgb (255,255,255)
			if ((zmenu.mfm) && (zmenu.notes[i] == "(0)")){
				zmenu.items[i].set_rgb(81,81,81)
			 	zmenu.noteitems[i].set_rgb(81,81,81)
			}
		}
		else {
			zmenu.items[i].set_rgb (0,0,0)
			zmenu.noteitems[i].set_rgb (0,0,0)
			zmenu.glyphs[i].set_rgb (0,0,0)
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
		if ((prf.DMPSORT == "brandname") && prf.DMPENABLED)  overlay.sidelabel.msg = "\n"+ltxt("BY BRAND",AF.LNG)
		if ((prf.DMPSORT == "brandyear") && prf.DMPENABLED)  overlay.sidelabel.msg = "\n"+ltxt("BY BRAND, YEAR",AF.LNG)
		if ((prf.DMPSORT == "year") && prf.DMPENABLED)  overlay.sidelabel.msg = "\n"+ltxt("BY YEAR",AF.LNG)

		if (prf.DMPGENERATELOGO) {
			for (local i=0 ; i < ((prf.DMPEXITAF && (zmenu.jumplevel==0)) ? zmenu.shown -1 : zmenu.shown); i++){
				if (glypharray[i] != -1) {
					zmenu.items[i].font = uifonts.gui
					zmenu.items[i].char_size = ( (UI.vertical && (prf.DMPIMAGES!= null)) ? zmenu.tileh*0.5 : zmenu.tileh*(prf.LOWRES?0.65:0.7))
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
						zmenu.items[i].char_size = zmenu.items[i].height * ((UI.vertical && (prf.DMPIMAGES != null) ) ? 1.25/3.0 : 1.8/3.0)
					}
					else zmenu.items[i].msg = renamer
				}
			}
		}
	}

	// After building menu define skipup limits
	local i = 0
	while (((zmenu.strikelines[i].visible)) && (i < zmenu.shown)){
		count.skipup ++
		i++
	}


}

function zmenuhide(){

	tilesTableZoom[focusindex.new] = startfade (tilesTableZoom[focusindex.new],0.035,-5.0)

	foreach (item in disp.images) item.file_name = AF.folder+"pics/transparent.png"

	if ((prf.AUDIOVIDSNAPS) && (prf.THUMBVIDEO))  tilez[focusindex.new].gr_vidsz.video_flags = Vid.Default
	if (prf.THUMBVIDEO) videosnap_restore()
	if (prf.LAYERVIDEO) bgs.bgvid_top.video_playing = true

	// Fade out zmenu text objects and zmenu shadow objects
	flowT.zmenutx = startfade(flowT.zmenutx,-0.15,0.0)
	flowT.zmenush = startfade(flowT.zmenush,-0.2,0.0)
	flowT.zmenudecoration = startfade(flowT.zmenudecoration,-0.2,0.0)

	zmenu.showing = false
}

function zmenunavigate_up(signal){
	if (zmenu.selected > count.skipup) {
		zmenu.selected = zmenu.selected - 1

		while ((zmenu.strikelines[zmenu.selected].visible) ){
			if (zmenu.selected > count.skipup) {
				zmenu.selected = zmenu.selected - 1
			}
			else {
				zmenu.selected = zmenu.selected + 1
				count.skipup = zmenu.selected
			}
		}
	}
	else if ((count[signal] == 0) ){
		zmenu.selected = zmenu.shown - 1

		while ((zmenu.strikelines[zmenu.selected].visible) ){
			if (zmenu.selected > count.skipup) {
				zmenu.selected = zmenu.selected - 1
			}
		}
		count.forceup = false
		//return true
	}
	else if ((!count.forceup) && (count[signal] !=0)){
		count.forceup = true
		//return true
	}
	zmenu.sidelabel.msg = zmenu.notes[zmenu.selected]
	count[signal] ++
}

function zmenunavigate_down(signal,mfskip = false){
	if ((!mfskip && (zmenu.selected < count.skipdown)) || (mfskip && (zmenu.selected < count.mfskipdown))) {
		zmenu.selected = zmenu.selected + 1

		while ((zmenu.strikelines[zmenu.selected].visible) || (mfskip && (zmenu.notes[zmenu.selected] == "(0)"))){
			if ((!mfskip && (zmenu.selected < count.skipdown)) || (mfskip && (zmenu.selected < count.mfskipdown))) {
				zmenu.selected = zmenu.selected + 1
			}
			else {
				zmenu.selected = zmenu.selected - 1
				if (!mfskip) count.skipdown = zmenu.selected
				else count.mfskipdown = zmenu.selected
			}
		}
	}
	else if (count[signal] == 0){
		zmenu.selected = 0
		//No need to add mfskip check here because mf menu never has first line "(0)"
		while ((zmenu.strikelines[zmenu.selected].visible) ){
			if (zmenu.selected < count.skipdown) {
				zmenu.selected = zmenu.selected + 1
			}
		}
		count.forcedown = false
		//return true
	}
	else if ((!count.forcedown) && (count[signal] !=0)){
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
	count[signal] ++
}

zmenu.xstop = 0

zmenu_surface_container.redraw = zmenu_surface.redraw = zmenu_sh.surf_rt.redraw = zmenu_sh.surf_2.redraw = zmenu_sh.surf_1.redraw = false
zmenu_surface_container.visible = zmenu_sh.surf_rt.visible = false

function gh_branchlist(op){
	if (op.find(ap+"name"+ap) != null) {
		gh.branchlist.push (split(op,ap)[3])
		testpr(split(op,ap)[3]+"\n")
	}
}

function gh_taglist(op){
	if (op.find(ap+"name"+ap) != null) {
		gh.taglist.push (split(op,ap)[3])
		testpr(split(op,ap)[3]+"\n")
	}
}

function gh_latestdata(op){

	if (op.find(ap+"tag_name"+ap) != null) {
		gh.latest_version = split(op,ap)[3]
	}
	else if (op.find(ap+"body"+ap) != null) {
		gh.release_notes = split(op,ap)[3]
		gh.release_notes = split_complete (gh.release_notes,"\\r\\n")
	}
}


function afinstall(zipball,afname){
	// zipball is the git tag to download (e.g. gh.latest_version)
	// afname is the name for the new AF folder and cfg entry (e.g. newafname)

	local newaffolder = fe.path_expand( FeConfigDirectory) + "layouts/"+ afname + "/"
	local newaffolderTEMP = fe.path_expand( FeConfigDirectory) + "layouts/"+ afname + "TEMP/"

	// Download zip of new layout version
	AF.updatechecking = true
	z_splash_message( "Downloading...")
	system ("curl -L -s https://api.github.com/repos/zpaolo11x/Arcadeflow/zipball/" + zipball + " -o " + ap + fe.path_expand(AF.folder) + afname+".zip" + ap)
	// Create target directory
	z_splash_message( "Installing...")
	system ("mkdir "+ ap + newaffolderTEMP + ap)
	system ("mkdir "+ ap + newaffolder + ap)
	// Unpack layout
	unzipfile (AF.folder + afname +".zip", newaffolderTEMP)
	local ghfolder = DirectoryListing(newaffolderTEMP)
	foreach (item in ghfolder.results){
		local ghfolder2 = DirectoryListing(item)
		foreach (item2 in ghfolder2.results){
			system (OS == "Windows" ?
				"move " + char_replace(ap + item2 + ap,"/","\\") + " " + char_replace(ap + newaffolder + ap,"/","\\") :
				"mv " + ap + item2 + ap + " " + ap + newaffolder + ap )
		}
	}

	system (OS == "Windows" ? "rmdir /q /s " + char_replace(ap + newaffolderTEMP + ap,"/","\\")  : "rm -R " + ap + newaffolderTEMP + ap)

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
		try {remove (AF.folder + afname +".zip");rem0 = 1} catch(err){rem0 = 0}
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
			templine = templine.slice(0,index0) + afname + templine.slice(index0 + currentlayout.len(),templine.len())
		}
		outarray.push(templine)
	}

	local outfile = WriteTextFile ( fe.path_expand( FeConfigDirectory + "attract.cfg" ) )
	for (local i = 0 ; i < outarray.len() ; i++){
		outfile.write_line(outarray[i]+"\n")
	}
	outfile.close_file()
	AF.updatechecking = false
	frostshow()
	zmenudraw ([ltxt("Quit",AF.LNG)],null,null, ltxt("Arcadeflow updated to",AF.LNG)+" "+ zipball ,0xe91c,0,false,false,true,false,false,
	function(out){
		zmenuhide()
		frosthide()
		restartAM()
	})
}

function gh_menu(){
}

function checkforupdates(force){

	if (!force && (currentdate().tointeger() <= loaddate().tointeger())) return

	savedate()

	//load latest update version
	z_splash_message( "Checking for updates...")
	AF.updatechecking = true

	local ver_in = ""
	fe.plugin_command("curl","-L -s https://api.github.com/repos/zpaolo11x/Arcadeflow/releases/latest","gh_latestdata")
	ver_in = gh.latest_version

	AF.updatechecking = false

	if (ver_in == "") return
	if ((ver_in == prf.UPDATEDISMISSVER) && (!force)) return
	if (ver_in.tofloat() <= AF.version.tofloat()) {
		if (force){
			zmenudraw (["Ok"],null, null,ltxt("No update available",AF.LNG),0xe91c,0,false,false,true,false,false,
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

	foreach (i, item in gh.release_notes){
		textarray.push(item)
		glypharray.push (0xea08)
	}

	textarray.push (ltxt(prf.AUTOINSTALL ? "Download & install new version" : "Download new version",AF.LNG))
	glypharray.push (0xea36)

	textarray.push (ltxt("Dismiss this update",AF.LNG))
	glypharray.push (0xea0f)

	zmenudraw (textarray,glypharray, null,ltxt("New version:",AF.LNG)+" Arcadeflow "+ver_in,0xe91c,0,false,false,false,false,false,
	function(out){
		if (out == -1) {
			zmenuhide()
			frosthide()
		}

		if (out == textarray.len() - 2){

			// Download latest layout
			local newafname = "Arcadeflow_"+(ver_in.tofloat()*10).tointeger()
			local newaffolder = fe.path_expand( FeConfigDirectory) + "layouts/"+ newafname + "/"
			local newaffolder_noslash = fe.path_expand( FeConfigDirectory) + "layouts/"+ newafname
			local newaffolderTEMP = fe.path_expand( FeConfigDirectory) + "layouts/"+ newafname + "TEMP/"

			if (!prf.AUTOINSTALL){
				// Simply download in your home folder
				AF.updatechecking = true
				z_splash_message( "Downloading...")
				system ("curl -L -s https://api.github.com/repos/zpaolo11x/Arcadeflow/zipball/" + gh.latest_version + " -o " + ap + fe.path_expand(AF.folder) + newafname+".zip" + ap)
				AF.updatechecking = false
				prf.UPDATECHECKED = true
				zmenudraw (["Ok"],null, null,newafname+".zip downloaded",0xe91c,0,false,false,true,false,false,
				function(out){
					zmenuhide()
					frosthide()
				})
			}
			else {
				afinstall (gh.latest_version,newafname)
				/*
				// Download zip of new layout version
				AF.updatechecking = true
				z_splash_message( "Downloading...")
				system ("curl -L -s https://api.github.com/repos/zpaolo11x/Arcadeflow/zipball/" + gh.latest_version + " -o " + ap + fe.path_expand(AF.folder) + newafname+".zip" + ap)
				// Create target directory
				z_splash_message( "Installing...")
				system ("mkdir "+ ap + newaffolderTEMP + ap)
				system ("mkdir "+ ap + newaffolder + ap)
				// Unpack layout
				unzipfile (AF.folder + newafname +".zip", newaffolderTEMP)
				local ghfolder = DirectoryListing(newaffolderTEMP)
				foreach (item in ghfolder.results){
					local ghfolder2 = DirectoryListing(item)
					foreach (item2 in ghfolder2.results){
						system (OS == "Windows" ?
							"move " + char_replace(ap + item2 + ap,"/","\\") + " " + char_replace(ap + newaffolder + ap,"/","\\") :
							"mv " + ap + item2 + ap + " " + ap + newaffolder + ap )
					}
				}

				system (OS == "Windows" ? "rmdir /q /s " + char_replace(ap + newaffolderTEMP + ap,"/","\\")  : "rm -R " + ap + newaffolderTEMP + ap)

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
				outfile.close_file()
				AF.updatechecking = false
				zmenudraw ([ltxt("Quit",AF.LNG)],null,null, ltxt("Arcadeflow updated to",AF.LNG)+" "+ ver_in ,0xe91c,0,false,false,true,false,false,
				function(out){
					zmenuhide()
					frosthide()
					restartAM()
				})
				*/
			}
		}

		if (out == textarray.len() - 1){

			// Dismiss auto updates
			local updpath = fe.path_expand (AF.folder + "pref_update.txt")
   		local updfile = WriteTextFile (updpath)
   		updfile.write_line(ver_in)
			updfile.close_file()
			zmenuhide()
			frosthide()
		}
	}
	)
}

function jumptodisplay(targetdisplay){
	fe.set_display(targetdisplay,false,prf.OLDDISPLAYCHANGE)
	zmenu.dmp = false
	umvisible = false
	frosthide()
	zmenuhide()
}

function displayungrouped (){
	zmenu.dmp = true
	zmenu.jumplevel = 0

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

	if (prf.ALLGAMES){
		foreach (item, val in z_af_collections.arr){
			showarray.insert(0,val.id)
			dispnotes.insert(0,"")
			groupnotes.insert(0,"")
			dispglyphs.insert(0,0)
			menuarray.insert(0,z_disp[val.display_id])
		}
	}

	if (prf.DMPEXITAF && prf.DMPENABLED) {
		showarray.push("SYSTEM") //Will be translated by zmenu drawing
		dispnotes.push(ltxt("",AF.LNG))
		groupnotes.push("")
		dispglyphs.push(-1)
		menuarray.push (null)

		showarray.push("EXIT ARCADEFLOW") //Will be translated by zmenu drawing
		dispnotes.push(ltxt("",AF.LNG))
		groupnotes.push("")
		dispglyphs.push(0)
		menuarray.push (null)
	}

	local currentdisplay = 0
	foreach (i, item in menuarray){
		if (item != null) if (item.dispindex == fe.list.display_index) currentdisplay = i
	}

	zmenudraw (showarray,dispglyphs,dispnotes,ltxt("DISPLAYS",AF.LNG),0xe912,currentdisplay,(prf.DMPIMAGES != null),true,true,(prf.DMPIMAGES != null),false,
	function(displayout){

		if (((displayout == -1) && (prf.DMPOUTEXITAF) ) || ((prf.DMPEXITAF) && (displayout == menuarray.len() - 1)) ) {

			zmenu.dmp = false
			zmenudraw (ltxtarray(prf.POWERMENU ? ["Yes","No","Power","Shutdown","Restart","Sleep"]:["Yes","No"],AF.LNG),prf.POWERMENU ? [0xea10,0xea0f,-1,0xe9b6,0xe984,0xeaf6]:[0xea10,0xea0f],null,ltxt("EXIT ARCADEFLOW?",AF.LNG),0xe9b6,1,false,false,true,false,false,
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

			jumptodisplay(targetdisplay)
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
	zmenu.jumplevel = 0

	// Displays the group menu
	zmenudraw (disp.groupname,null,null,ltxt("DISPLAYS",AF.LNG),0xe912,disp.gmenu0out,(prf.DMPIMAGES != null) && prf.DMCATEGORYART,(prf.DMPIMAGES != null) && prf.DMCATEGORYART,true,(prf.DMPIMAGES != null) && prf.DMCATEGORYART,false,
	function(gmenu0){
		disp.gmenu0 = gmenu0

	// COLLECTIONS!
	/*
		if ((disp.gmenu0 == disp.groupname.len()-(prf.DMPEXITAF?2:1)-2) && prf.ALLGAMES){
			jumptodisplay(z_af_collections.tab["AF All Games"].display_id)
			return
		}
		if ((disp.gmenu0 == disp.groupname.len()-(prf.DMPEXITAF?2:1)-1) && prf.ALLGAMES){
			jumptodisplay(z_af_collections.tab["AF Favourites"].display_id)
			return
		}
		if ((disp.gmenu0 == disp.groupname.len()-(prf.DMPEXITAF?2:1)) && prf.ALLGAMES){
			jumptodisplay(z_af_collections.tab["AF Last Played"].display_id)
			return
		}
		else */
		if (disp.gmenu0 != -1) disp.gmenu0out = disp.gmenu0

		// Code when "ESC" is pressed in Displays Menu page
		if (((disp.gmenu0 == -1) && (prf.DMPOUTEXITAF) ) || ((prf.DMPEXITAF) && (disp.gmenu0 == disp.groupname.len() - 1)) ) {

			zmenu.dmp = false
			zmenudraw (ltxtarray(prf.POWERMENU ? ["Yes","No","Power","Shutdown","Restart","Sleep"]:["Yes","No"],AF.LNG),prf.POWERMENU ? [0xea10,0xea0f,-1,0xe9b6,0xe984,0xeaf6]:[0xea10,0xea0f],null,ltxt("EXIT ARCADEFLOW?",AF.LNG),0xe9b6,1,false,false,true,false,false,
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

			// Sort the display menu according to its sortkey
			if (prf.DMPSORT != "false") {
				menuarray.sort (@(a,b) a.sortkey <=> b.sortkey)
			}

			zmenu.jumplevel = 1

			// Define menu display arrays
			local showarray = []
			local dispnotes = []
			local groupnotes = []

			// At this point all the entries are sorted and ready to be populated
			foreach (i,item in menuarray){
				showarray.push (item.cleanname)
				dispnotes.push (item.notes)
				groupnotes.push (item.groupnotes)
			}

			// Add separators when the note is different from the previous one
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

			// Now it's the right moment to add code for AF Collecitons
			if (prf.ALLGAMES){
				local itemcount = 0
				foreach (ic, itemc in dispglyphs){
					if (itemc != -1) itemcount ++
				}
				foreach (item, val in z_af_collections.arr){
					// Only collection category and categories with more than 1 display show "all games"
					if (((itemcount >1) || (val.group == "COLLECTIONS") ) && (val.group == disp.grouplabel[disp.gmenu0])){
						showarray.insert(0,val.id)
						dispnotes.insert(0,"")
						groupnotes.insert(0,"")
						dispglyphs.insert(0,0)
						menuarray.insert(0,z_disp[val.display_id])
					}
				}
			}

			disp.gmenu1in = 0
			foreach (i, item in menuarray){
				if (item != null) if (item.dispindex == fe.list.display_index) disp.gmenu1in = i
			}

			zmenudraw (showarray,dispglyphs,dispnotes,disp.grouplabel[disp.gmenu0],disp.groupglyphs[disp.gmenu0],disp.gmenu1in,(prf.DMPIMAGES != null),(prf.DMPIMAGES != null),true,(prf.DMPIMAGES != null),false,
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
					jumptodisplay (targetdisplay)


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

function builddisplaystructure(){
	// This function builds the displays structrue categorising games by platform
	// it doesn't take into account the "AF " collections because they are purged from z_disp
	disp.grouplabel = ["ARCADE","CONSOLE","HANDHELD","COMPUTER","PINBALL","COLLECTIONS","OTHER"]
	disp.groupname = ["zmenuarcade","zmenuconsole","zmenuhandheld","zmenucomputer","zmenupinball","zmenucollections","other"]
	if (!prf.DMPGENERATELOGO) disp.groupname = ["arcade","console","handheld","computer","pinball","collections","other"]
	disp.groupglyphs = [0xeaeb,0xeaec,0xe959,0xe956,0xeaf0,0xe912,0xe912]

	// Initialise the variable that builds the menu categorized structure
	disp.structure = {}

	// Add all the group labels to the structure
	foreach (data in disp.grouplabel){
		disp.structure[data] <- {
			size = 0
			disps = []
		}
	}

	// NOTA BENE: Il current display fe.list.display_index considera tutti, anche quelli non mostrati, quindi va bene
	// Goes through the z_disp array of which each entry has the display properties
	foreach (i, item in z_disp){
		// Display "i" is in_menu so group count is increased or initialised
		if (item.inmenu){
			try { disp.structure[item.group].size ++}
			catch (err){
				disp.structure[item.group] <- {
					size = 1
					disps=[]
				}
				disp.grouplabel.push(item.group)
				disp.groupname.push(item.group)
				disp.groupglyphs.push(0)
			}
			// item (the z_disp table with display data) is added to the group
			disp.structure[item.group].disps.push(item)
		}
	}

	// Removes empty groups from the display menu
	local templen = disp.grouplabel.len()
	for (local i = templen - 1 ; i >= 0 ; i--) {
		if (!(prf.ALLGAMES && disp.grouplabel[i] == "COLLECTIONS")){
			if (disp.structure[disp.grouplabel[i]].size == 0) {
				disp.grouplabel.remove(i)
				disp.groupname.remove(i)
				disp.groupglyphs.remove(i)
			}
		}
	}

}

function displaygrouped(){
	zmenu.dmp = true
	zmenu.jumplevel = 0

	builddisplaystructure()

	local cleanlen = disp.groupname.len()

	if (prf.DMPEXITAF) disp.groupname.push("EXIT ARCADEFLOW")

	disp.gmenu0out = disp.grouplabel.len() - 1
	disp.gmenu0 = 0
	disp.gmenu0out = disp.grouplabel.find(z_disp[fe.list.display_index].group)

	//Check if we are in a collection
	if (prf.ALLGAMES){
		foreach (item, val in z_af_collections.tab){
			if (val.rawin("display_id"))
				if (val.display_id == fe.list.display_index)
					disp.gmenu0out = disp.grouplabel.find(val.group)
		}
	}

	//TEST120 CHECK quando non ci sono AF ALL GAMES in attract.cfg

	local getout = false
	// After preparing the structure displaygrouped1 is called, it will manage
	// main list and sublists by sorting, grouping etc
	displaygrouped1()

}


/// Layout fades ///

function hideallbutbg () {
	// Returns true if the file is NOT available
	if (prf.REDCROSS && !z_list.gametable[z_list.index].z_fileisavailable ) return true

	flowT.groupbg = startfade (flowT.groupbg,-2.0,0.0)

	flowT.history = startfade (flowT.history,-2.0,0.0)
	flowT.histtext = startfade (flowT.histtext,-2.0,0.0)

	return false
	//history_hide()
}


function layoutfadein () {

	tilesTableZoom[focusindex.new] = startfade (tilesTableZoom[focusindex.new],0.15,5.0)

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

	if (zmenu.sim) return true

	if (history_visible()) history_hide()
	if (overmenu_visible()) overmenu_hide(false)
	if (zmenu.showing) {
		frosthide()
		zmenuhide()
	}

	if (prf.THUMBVIDEO) videosnap_hide()
	if (prf.LAYERVIDEO) bgs.bgvid_top.video_playing = false

	attract.start = true
	attract.starttimer = false
	attractitem.surface.visible = attractitem.surface.redraw = true
	attractitem.text1.visible = attractitem.text2.visible = true
	attractitem.snap.shader = attractitem.shader_2_lottes

	flowT.attract = startfade (flowT.attract, 0.1,0.0)
	if (prf.AMSHOWLOGO) flowT.logo = startfade (flowT.logo,0.1,0.0)
}

function attractupdatesnap(){
	if (z_list.size == 0) return
	local randload = (z_list.size*rand()/RAND_MAX)
	attractitem.snap.file_name = fe.get_art("snap",z_list.gametable[randload].z_felistindex - fe.list.index)
	if (attractitem.snap.texture_width * attractitem.snap.texture_height == 0) {
		attractitem.snap.file_name = AF.folder+"pics/attractbg.jpg"
	}
	attractitem.refs.file_name = fe.get_art("snap",z_list.gametable[randload].z_felistindex - fe.list.index,0,Art.ImagesOnly)

	local nativeres = null
	local scalexy = [1.0,1.0]
	try {
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
	try {
		scalexy[0] = attractitem.snap.texture_width / nativeres[0]
		scalexy[1] = attractitem.snap.texture_height / nativeres[1]
	}
	catch (err){
		attractitem.snap.file_name = AF.folder+"pics/attractbg.jpg"
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
	attractitem.snap = attractitem.surface.add_image(AF.folder+"pics/attractbg.jpg",0,0,attract.nw,attract.nw)
	attractitem.snap.preserve_aspect_ratio = false
	attractitem.refs = attractitem.surface.add_image(AF.folder+"pics/transparent.png",0,0,1,1)
	attractitem.refs.preserve_aspect_ratio = false
	attractitem.refs.visible = false

	attractitem.black = attractitem.surface.add_rectangle(0,0,attract.nw,attract.nw)
	attractitem.black.set_rgb(0,0,0)
	attractitem.black.alpha = 0

	//attractitem.text_surface = fe.add_surface (attract.w,attract.w)
	//attractitem.text_surface.set_pos(attract.x,attract.y)

	if ((prf.SPLASHON) && (prf.AMSHOWLOGO)){
		attractitem.text1 = fe.add_text(attract.msg,attract.x,attract.y-attractitem.surface.y+fl.h-140 * UI.scalerate,attractitem.surface.width,140 * UI.scalerate)
	}
	else {
		attractitem.text1 = fe.add_text(attract.msg,attract.x,attract.y,attract.w,attract.w)
	}

	attractitem.text1.char_size = 72 * UI.scalerate
	attractitem.text1.font = uifonts.gui
	attractitem.text1.set_rgb (0,0,0)
	attractitem.text1.alpha = attract.textshadow

	attractitem.text2 = fe.add_text(attract.msg,attractitem.text1.x,attractitem.text1.y-10 * UI.scalerate,attractitem.text1.width,attractitem.text1.height)

	attractitem.text2.char_size = 70 * UI.scalerate
	attractitem.text2.font = uifonts.gui
	attractitem.text2.set_rgb(255,255,255)

	attractitem.fade = attractitem.surface.add_image(AF.folder+"pics/attractbg.jpg",0,0,attract.nw,attract.nw)
	attractitem.fade.alpha = 80
	attractitem.fade.blend_mode = BlendMode.Add

	attractitem.vignette = attractitem.surface.add_image(AF.folder+"pics/vignette.png",0,0,attract.nw,attract.nw)
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

		attractitem.snap.file_name = AF.folder+"pics/transparent.png"
		attractitem.snap.shader = noshader
		attractitem.surface.visible = attractitem.surface.redraw = false
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

local aflogo = fe.add_image(prf.SPLASHLOGOFILE,fl.x,fl.y,fl.w,fl.h)
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

if (!prf.CUSTOMLOGO) {
	aflogo.width = (1150.0/10.0) * floor((fl.w * 10.0 / 1150.0)+0.5)
	aflogo.height = aflogo.width*aflogo.texture_height*1.0/aflogo.texture_width
	aflogo.x = fl.x + floor((fl.w - aflogo.width)*0.5)
	aflogo.y = fl.y + floor((fl.h - aflogo.height)*0.5)
}

aflogo.visible = prf.SPLASHON


/// Layout fade from black ///

flowT.blacker = [0.0,0.0,0.0,0.09,1.0]


/// BGM Start ///

if(prf.BACKGROUNDTUNE != "") snd.bgtuneplay = true

/// Similar Games UI ///



zmenu.simpicbg = zmenu_surface_container.add_text("",
										zmenu.simbg.x + disp.width*0.5 - 0.5 * (UI.vertical ? 0.9 : 0.75) * disp.width,
										//zmenu.y + zmenu.height*0.5 - 0.5*0.75*(zmenu.width*0.5-2.0*zmenu.pad),
										0,
										(UI.vertical ? 0.9 : 0.75) * disp.width,
										(UI.vertical ? 0.9 : 0.75) * disp.width)
zmenu.simpicbg.set_bg_rgb(200,0,0)
zmenu.simpicbg.bg_alpha = 0
zmenu.simpicbg.zorder = 10000

zmenu.simpicshB = zmenu_surface_container.add_image(AF.folder+"pics/grads/wgradientBb.png",0,0,0,0)
zmenu.simpicshB.set_rgb(0,0,0)
zmenu.simpicshB.alpha = 90
zmenu.simpicshT = zmenu_surface_container.add_image(AF.folder+"pics/grads/wgradientTb.png",0,0,0,0)
zmenu.simpicshT.set_rgb(0,0,0)
zmenu.simpicshT.alpha = 80
zmenu.simpicshL = zmenu_surface_container.add_image(AF.folder+"pics/grads/wgradientLb.png",0,0,0,0)
zmenu.simpicshL.set_rgb(0,0,0)
zmenu.simpicshL.alpha = 80
zmenu.simpicshR = zmenu_surface_container.add_image(AF.folder+"pics/grads/wgradientRb.png",0,0,0,0)
zmenu.simpicshR.set_rgb(0,0,0)
zmenu.simpicshR.alpha = 80

zmenu.simpic = zmenu_surface_container.add_image(AF.folder+"pics/transparent.png",
										zmenu.simpicbg.x,
										zmenu.simpicbg.y,
										zmenu.simpicbg.width,
										zmenu.simpicbg.height)

zmenu.simvid = zmenu_surface_container.add_image(AF.folder+"pics/transparent.png",
										zmenu.simpicbg.x,
										zmenu.simpicbg.y,
										zmenu.simpicbg.width,
										zmenu.simpicbg.height)

zmenu.simpic.zorder = 10000
zmenu.simpic.video_flags = Vid.NoAudio
zmenu.simpic.preserve_aspect_ratio = false

zmenu.simvid.zorder = 10001
zmenu.simvid.video_flags = Vid.NoAudio
zmenu.simvid.preserve_aspect_ratio = false

zmenu.simsys = zmenu_surface_container.add_text("",
										zmenu.simbg.x,
										zmenu.simpic.y + zmenu.height - 100 * UI.scalerate,
										disp.width,
										100 * UI.scalerate)
zmenu.simsys.zorder = 10000
zmenu.simsys.char_size = 50 * UI.scalerate
zmenu.simsys.word_wrap = true
zmenu.simsys.align = Align.TopRight
zmenu.simsys.font = uifonts.gui
zmenu.simsys.set_rgb(themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)
//zmenu.simsys.set_bg_rgb(200,0,0)

zmenu.simtxt = zmenu_surface_container.add_text("",
										zmenu.simbg.x,
										zmenu.simpic.y + zmenu.simpic.height,
										disp.width,
										zmenu.height - (zmenu.simpic.y + zmenu.simpic.height))
zmenu.simtxt.zorder = 10000
zmenu.simtxt.char_size = 50 * UI.scalerate
zmenu.simtxt.word_wrap = true
zmenu.simtxt.align = Align.TopCentre
zmenu.simtxt.font = uifonts.lite
zmenu.simtxt.set_rgb(themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)

function zmenusimvisible(visibility){
	zmenu.simpicshT.visible = zmenu.simpicshB.visible = zmenu.simpicshL.visible = zmenu.simpicshR.visible = visibility
	zmenu.simvid.visible = zmenu.simpic.visible = zmenu.simpicbg.visible = zmenu.simbg.visible = zmenu.simsys.visible =zmenu.simtxt.visible = visibility
}

zmenusimvisible(false)


function simtitle(in1, in2){

	local in1array = split(in1.tolower()," ")
	local in2array = split(in2.tolower()," ")

	local sameword = 0

	foreach (i1, val1 in in1array){
		if (in2array.find(val1) != null) sameword ++
	}

	local normsim = (sameword *2.0/ (in1array.len() + in2array.len()))

	return (normsim)

}

function updatesimpic(index){
	zmenu.simvid.file_name = AF.folder+"pics/transparent.png"
	zmenu.simpic.file_name = fe.get_art ("snap",zmenu.similar[index].data.z_felistindex - fe.list.index,0,Art.ImagesOnly)

	local gameAR = getAR(zmenu.similar[index].index-z_list.index,zmenu.simpic,0,false)
	local ARdata = ARprocess(gameAR)

	zmenu.simvid.width = zmenu.simpic.width = zmenu.simpicbg.width * ARdata.w * 640.0/500.0
	zmenu.simvid.height = zmenu.simpic.height = zmenu.simpicbg.height * ARdata.h * 640.0/500.0
	zmenu.simvid.x = zmenu.simpic.x = zmenu.simpicbg.x + 0.5 * zmenu.simpicbg.width - 0.5 * zmenu.simpic.width
	zmenu.simvid.y = zmenu.simpic.y = zmenu.simpicbg.y + 0.5 * zmenu.simpicbg.height - 0.5 * zmenu.simpic.height

	local shsize = zmenu.simpicbg.width*0.1

	zmenu.simpicshT.set_pos(zmenu.simpic.x, zmenu.simpic.y - shsize*0.5, zmenu.simpic.width, 2*shsize)
	zmenu.simpicshB.set_pos(zmenu.simpic.x, zmenu.simpic.y + zmenu.simpic.height - 0.5*shsize, zmenu.simpic.width, 2*shsize)
	zmenu.simpicshL.set_pos(zmenu.simpic.x - shsize, zmenu.simpic.y, 2*shsize, zmenu.simpic.height)
	zmenu.simpicshR.set_pos(zmenu.simpic.x + zmenu.simpic.width - shsize, zmenu.simpic.y, 2*shsize, zmenu.simpic.height)
	zmenu.simvid.shader = noshader
	zmenu.simpic.shader = colormapper[recolorise (zmenu.similar[index].index-z_list.index , 0)].shad

}

function similarmenu(){
		local algo = {
			"z_title" : 100
			"z_series" : 18
			"z_category" : 12
			// name similarity : 6
			"z_manufacturer" : 3
			"z_arcadesystem" : 2
			"z_system" : 1
		}

		local currentgame = z_list.gametable[z_list.index]
		local similarray = []
		local i = 0
		foreach (gindex, item in z_list.gametable){
			similarray.push({
				name = item.z_name
				data = item
				similar = 0
				gamenotes = ""
				syslogo = ""
				index = gindex
			})

			// Evaluate base algorythm
			foreach (algo_item, algo_val in algo){
				if ((item[algo_item]!="")&&(item[algo_item] == currentgame[algo_item])) {
					similarray[i].similar = similarray[i].similar + algo_val
				}
			}

			// Add similar name contribution
			similarray[i].similar = similarray[i].similar + 6 * simtitle(split(currentgame.z_title,"([")[0], split(item.z_title,"([")[0])

			i++
		}

		similarray.sort(@(a,b) b.similar <=> a.similar)
		if (similarray.len() > 30) similarray.resize (30)
		local similarray2 = []
		foreach (i, item in similarray){
			if (item.similar >= 12) similarray2.push(item)
		}

		zmenu.similar = similarray2

		local namearray = []
		local notesarray = []
		foreach (i, item in zmenu.similar){
			namearray.push (item.data.z_title)
			notesarray.push (system_data[item.data.z_system.tolower()].sysname)
			zmenu.similar[i].gamenotes = "©"+item.data.z_year+" by "+item.data.z_manufacturer+"\n"+item.data.z_category+"\n"
			zmenu.similar[i].syslogo = system_data[item.data.z_system.tolower()].logo
		}
		zmenu.sim = true
		zmenusimvisible(true)
		updatesimpic(0)
		zmenu.simtxt.msg = zmenu.similar[0].gamenotes
		zmenu.simsys.msg = zmenu.similar[0].syslogo
		/*
		prfmenu.bg.visible = prfmenu.description.visible = prfmenu.helppic.visible = true
		try{prfmenu.description.msg = zmenu.similar[0].data.z_description[0]}catch(err){prfmenu.description.msg = ""}
		prfmenu.helppic.file_name = fe.get_art ("snap",zmenu.similar[0].data.z_felistindex - fe.list.index)
		*/
		frostshow()
		zmenudraw (namearray,null,null,ltxt("Similar Games",AF.LNG),0xeaf7,0,true,false,true,false,false,
			function(out){

				if (out != -1) z_list_indexchange (zmenu.similar[zmenu.selected].index)

				zmenu.sim = false
				zmenusimvisible(false)
				zmenu.simpic.file_name = zmenu.simvid.file_name = AF.folder+"pics/transparent.png"
				/*
				prfmenu.bg.visible = prfmenu.description.visible = prfmenu.helppic.visible = false
				prfmenu.description.msg = ""
				prfmenu.helppic.file_name = AF.folder+"pics/transparent.png"
				*/
				zmenuhide()
				frosthide()
				zmenu.simpic.shader = zmenu.simvid.shader = noshader
				return
			},
			null,
			function(){
				zmenu.simvid.file_name = fe.get_art ("snap",zmenu.similar[zmenu.selected].data.z_felistindex - fe.list.index,0,Vid.NoAudio)
				zmenu.simvid.shader = colormapper[recolorise (zmenu.similar[zmenu.selected].index-z_list.index , 0)].shad
			}

		)
}

/// Custom Foreground ///

local user_fg = null
if (prf.OVERCUSTOM != "pics/") {
	user_fg = fe.add_image(prf.OVERCUSTOM,0,0,fl.w_os,fl.h_os)
	user_fg.zorder = 100000
}

// Character size: 1.7*(width/columns) or 0.78*(height/rows)
AF.messageoverlay = fe.add_text("123456789012345678901234567890123456789012345678901234567890\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13",fl.x,fl.y,fl.w,fl.h)
AF.messageoverlay.margin = 50 * UI.scalerate
AF.messageoverlay.char_size = floor((fl.w-2.0*50 * UI.scalerate)*1.65/AF.scrape.columns) //40 columns text
AF.messageoverlay.word_wrap = true
AF.messageoverlay.set_bg_rgb (40,40,40)
AF.messageoverlay.bg_alpha = 220+0*240
AF.messageoverlay.align = Align.TopLeft
AF.messageoverlay.font = uifonts.mono
AF.messageoverlay.visible = false
AF.messageoverlay.zorder = 100

if (floor(floor((fl.w-2.0*50 * UI.scalerate)*1.65/AF.scrape.columns) + 0.5) == 8) {
	AF.messageoverlay.char_size = 16
	AF.messageoverlay.font = "fonts/font_7x5pixelmono.ttf"
}

/// PROGRESS BAR ///

AF.bar.picbg = fe.add_text("",floor(0.5*(fl.w_os - AF.bar.size*UI.scalerate)) , floor(0.5*(fl.h_os - AF.bar.size*UI.scalerate)), floor(AF.bar.size*UI.scalerate), floor(AF.bar.size*UI.scalerate)) //TEST149 CHECK CENTERING WITH OD
AF.bar.pic = fe.add_text("",AF.bar.picbg.x, AF.bar.picbg.y, AF.bar.picbg.width, AF.bar.picbg.height) //TEST149 CHECK CENTERING WITH OD
AF.bar.pic.font = AF.bar.picbg.font = "fonts/font_glyphs.ttf"
AF.bar.pic.margin = AF.bar.picbg.margin = 0
AF.bar.pic.align = AF.bar.picbg.align = Align.MiddleCentre
AF.bar.pic.charsize = AF.bar.size*UI.scalerate
AF.bar.picbg.charsize = AF.bar.size*UI.scalerate
AF.bar.picbg.zorder = 100000
AF.bar.pic.zorder = 100001
AF.bar.pic.word_wrap = AF.bar.picbg.word_wrap = true
AF.bar.pic.visible = AF.bar.picbg.visible = false
AF.bar.pic.set_rgb(255,255,255)
AF.bar.picbg.set_rgb(AF.bar.dark,AF.bar.dark,AF.bar.dark)

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
fps.monitor = fe.add_text("",fe.layout.width*0.5-550*0.5 * UI.scalerate,0,550 * UI.scalerate,80 * UI.scalerate)
//X fps.monitor = fe.add_text("",0,0,fl.w_os,120)

fps.monitor.set_bg_rgb (50,50,50)
fps.monitor.bg_alpha = 200
fps.monitor.set_rgb (255,255,255)
fps.monitor.char_size = 50 * UI.scalerate
fps.monitor.zorder = 20000
//X fps.monitor.word_wrap = true

fps.monitor2 = fe.add_text("",0,0,10,10)
fps.monitor2.set_bg_rgb (255,0,0)
fps.monitor2.visible = true

fps.tick000 = 0
fps.x0 = 0

fe.add_ticks_callback(this,"monitortick")
}

function monitortick(tick_time){
//X fps.monitor.msg =" var:" + var + " zvar:" + z_var + " offs:" + column.offset + " start:" + column.start + " stop:"+column.stop +" ccval:" +centercorr.val+" ccsh:" +centercorr.shift
//X fps.monitor.msg = fps.monitor.msg + "\n"+"cols:"+cols+" cczero:"+centercorr.zero+"\n"
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
	try {
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
	bgs_freeze(false)
	bgs.bgpic_array[bgs.stacksize-1].file_name  = fe.get_art((prf.BOXARTMODE ? (prf.LAYERSNAP ? "snap" : prf.BOXARTSOURCE) : (prf.TITLEART ? (prf.LAYERSNAP ? "snap" : "title") : "snap")) , tilez[index].offset,0,Art.ImagesOnly)

	if (prf.MULTIMON) {
		mon2.pic_array[bgs.stacksize-1].file_name  = fe.get_art(prf.MONITORMEDIA1, tilez[index].offset,0,Art.ImagesOnly)
		if (mon2.pic_array[bgs.stacksize-1].texture_width == 0)
			mon2.pic_array[bgs.stacksize-1].file_name  = fe.get_art(prf.MONITORMEDIA2, tilez[index].offset,0,Art.ImagesOnly)
	}

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
				bgs.bgpic_array[bgs.stacksize-1].file_name = AF.folder+"pics/grey.png"
			}
		}
		else {
			bgs.bgpic_array[bgs.stacksize-1].shader = colormapper["NONE"].shad
			bgs.bg_box[bgs.stacksize-1] = [false,[255,255,255],[0,0,0]]
		}
	}
	else { // We are not in boxart mode, OR the layersnap is enabled

		if (bgs.bgpic_array[bgs.stacksize-1].texture_width == 0 ) bgs.bgpic_array[bgs.stacksize-1].file_name = "pics/snaps/snapx"+( (fe.game_info(Info.Title,tilez[index].offset).len() % 7))+".png"

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

function getvidAR(tileindex, tile, reftile, var){
	// Nothing in the list, or no image at all: return 1.0
	if (z_list.size == 0) return (1.0)
	if ((tile.texture_height == 0) && (reftile.texture_height)) return 1.0

	local txtAR = 1.0
	if (tile.texture_height != 0) txtAR = (tile.texture_width * 1.0 / tile.texture_height)
	local refAR = reftile.texture_height != 0 ? (reftile.texture_width * 1.0 / reftile.texture_height) : txtAR

	if (txtAR != refAR) txtAR = refAR

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

function getAR(tileindex, tile, var, boxart){
	// Nothing in the list, or no image at all: return 1.0
	if (z_list.size == 0) return (1.0)
	if (tile.texture_height == 0) return 1.0

	local txtAR = (tile.texture_width * 1.0 / tile.texture_height)
	// Boxart enabled, return purely width/height
	if (boxart) return txtAR

	// Get the horizgame parameter, if it's defined then AR is 4:3 or
	//local horizgame = z_list.gametable[ modwrap (z_list.index + tileindex + var, z_list.size) ].z_rotation

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

	if (prf.SNAPGRADIENT) tilez[i].gr_overlay.visible = gradenabled

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
	local w0 = 0
	local h0 = 0

	if (cropaspect == 0){ //INITIALIZE NEW ARTWORK ASPECT
		cropaspect = clampaspect (aspect)
		if (prf.CROPSNAPS && !prf.BOXARTMODE) cropaspect = 1.0
		if (prf.LOGOSONLY) cropaspect = 2.0
		tilez[i].AR.snap = aspect
		tilez[i].AR.crop = cropaspect
		tilez[i].AR.current = tilez[i].AR.crop
	}
	local noboxart = false

	//TEST99 E' GIUSTO TOGLIERE QUESTA PARTE?!?!?
	if (prf.BOXARTMODE){
		//TEST99 tilez[i].snapz.shader.set_param ("lcdcolor",0.0)
		//TEST99 tilez[i].gr_snapz.shader.set_param ("lcdcolor",0.0)
		//tilez[i].snapz.shader = tilez[i].gr_snapz.shader = colormapper["NONE"].shad
	}

	//TEST87 TO DO SPOSTARE QUESTO DOVE VENGONO CARICATI I DATI DELL'IMMAGINE E NON IN CROPSNAP!
	if (prf.BOXARTMODE && (tilez[i].gr_snapz.texture_width == 0 )) {
		noboxart = true
		tilez[i].gr_snapz.file_name = category_pic_10_name (z_list.gametable[indexvar].z_category)

		if (tilez[i].gr_snapz.texture_width == 0 ) tilez[i].gr_snapz.file_name = "metapics/category10/grey.png"

		tilez[i].snapz.shader = tilez[i].gr_snapz.shader = colormapper["BOXART"].shad

		local col1 = categorycolor(z_list.gametable[indexvar].z_felistindex,2)

		tilez[i].snapz.set_rgb(col1[0],col1[1],col1[2])
		tilez[i].gr_snapz.set_rgb(col1[0],col1[1],col1[2])

		tilez[i].txbox.visible = false
		if (!prf.TITLEONBOX) tilez[i].txbox.visible = true
	}
	else if (tilez[i].gr_snapz.file_name.find("metapics/category10") == null) {
		if (prf.BOXARTMODE) {
			noboxart = false
			tilez[i].snapz.shader = tilez[i].gr_snapz.shader = colormapper["NONE"].shad
			tilez[i].snapz.set_rgb (255,255,255)
			tilez[i].gr_snapz.set_rgb (255,255,255)
			tilez[i].txbox.visible = false
		}
		else {
			if (tilez[i].gr_snapz.texture_width == 0 ) tilez[i].gr_snapz.file_name = "pics/snaps/snapx"+( (fe.game_info(Info.Title,indexoffsetvar).len() % 7))+".png"
			tilez[i].snapz.set_rgb (255,255,255)
			tilez[i].gr_snapz.set_rgb (255,255,255)
			tilez[i].txbox.visible = false
		}
	}

	// NO CROPSNAP BUT REAL ARTWORK ASPECT RATIO FITTED AND CROPPED TO BEST RATIO
	// SNAP IS POSITIONED ACCORDING TO FUZZY ORIENTATION OF GAME OR BOXART

	local ARdata = ARprocess(cropaspect)

	tilez[i].snapz.set_pos(0.5*(UI.zoomedwidth - integereven(UI.zoomedwidth * ARdata.w)), 0.5*(UI.zoomedheight - integereven(UI.zoomedheight * ARdata.h)) - UI.zoomedvshift, integereven(UI.zoomedwidth * ARdata.w), integereven(UI.zoomedheight * ARdata.h))

	if (prf.SNAPGRADIENT) tilez[i].gr_overlay.set_pos(tilez[i].snapz.x, tilez[i].snapz.y, tilez[i].snapz.width, tilez[i].snapz.height)

	local vidAR = getvidAR(tilez[i].offset,tilez[i].vidsz,tilez[i].refsnapz,var) //This is the AR of the game video if it was not on boxart mode

	// Select cases where the snap itself needs to be recropped
	if (prf.MORPHASPECT || (!prf.BOXARTMODE && prf.CROPSNAPS)){
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
	}

	// VIDEO SNAPS CROPPER
	if (prf.THUMBVIDEO){
		tilez[i].vidsz.set_pos(tilez[i].snapz.x,tilez[i].snapz.y,tilez[i].snapz.width,tilez[i].snapz.height)

		if (!prf.VID169){
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
		} else {
			// Rotate video

			w0 = tilez[i].vidsz.width
			h0 = tilez[i].vidsz.height

			tilez[i].vidsz.rotation = 90
			tilez[i].vidsz.x = tilez[i].vidsz.x + w0
			tilez[i].vidsz.width = h0
			tilez[i].vidsz.height = w0

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

	local bd_margin = round(UI.zoomedpadding * UI.whiteborder,1)
	local bd_margin2 = UI.padding * (1.0 - UI.whiteborder)
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
	tilez[i].bd_mx.set_pos (tilez[i].snapz.x - bd_margin, tilez[i].snapz.y - bd_margin , tilez[i].snapz.width + 2.0*bd_margin, tilez[i].snapz.height + 2.0*bd_margin)


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
	//if (prf.SNAPGLOW) tilez[i].glomx.set_pos(0,-UI.zoomscale*UI.verticalshift)
}

function update_thumbdecor(i,var,aspect){
	aspect = clampaspect (aspect)

	if (z_list.size == 0) return

	local z_list_target = modwrap(z_list.index + tilez[i].offset + var,z_list.size)
	local fe_list_target = z_list.gametable[ z_list_target ].z_felistindex

	//TEST120z_list.gametable2[ z_list_target ].z_playedcount = fe.game_info(Info.PlayedCount, fe_list_target - fe.list.index)

	tilez[i].donez.visible = z_list.gametable2[z_list_target].z_completed

	tilez[i].availz.visible = prf.REDCROSS && ((z_list.gametable[z_list_target].z_system != "") && (!z_list.gametable[z_list_target].z_fileisavailable))

	tilez[i].alphazero = (prf.SHOWHIDDEN ? (z_list.gametable2[z_list_target].z_hidden ? 80 : 255) : 255)
	tilez[i].obj.alpha = tilez[i].alphazero * tilez[i].alphafade/255.0

	tilez[i].favez.visible = z_list.gametable2[z_list_target].z_favourite

	tilez[i].logoz.visible = tilez[i].loshz.visible = ((!(prf.BOXARTMODE) && prf.TITLEONSNAP) || (prf.BOXARTMODE && prf.TITLEONBOX))

	tilez[i].nw_mx.visible = !prf.LOGOSONLY && (z_list.gametable2[ z_list_target ].z_playedcount == 0)

	//Check if the only tags present are "COMPLETED" or "HIDDEN"
	local tagcheckerlist = z_list.gametable2 [ z_list_target ].z_tags
	/*
	if (
		((tagcheckerlist.len() == 1) && ((tagcheckerlist[0] == "COMPLETED") || (tagcheckerlist[0] == "HIDDEN"))) ||
		((tagcheckerlist.len() == 2) && ((tagcheckerlist[0] == "COMPLETED") && (tagcheckerlist[1] == "HIDDEN"))) ||
		((tagcheckerlist.len() == 2) && ((tagcheckerlist[1] == "COMPLETED") && (tagcheckerlist[0] == "HIDDEN")))
	){
		tilez[i].tg_mx.visible = false
	}
	*/
	if (prf.TAGNAME == "") tilez[i].tg_mx.visible = (tagcheckerlist.len() >= 1)
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

	tilez[i].nw_mx.set_pos (tilez[i].snapz.x , tilez[i].snapz.y + tilez[i].snapz.height - tilez[i].nw_mx.height)
	tilez[i].tg_mx.set_pos (tilez[i].snapz.x + tilez[i].snapz.width - UI.zoomedcoreheight/8.0, tilez[i].snapz.y + tilez[i].snapz.height - UI.zoomedcoreheight/10.0)

}


function switchmode(){
	if (prf.LOGOSONLY) return
	prf.BOXARTMODE = !prf.BOXARTMODE

	z_listrefreshtiles()
	updatebgsnap (focusindex.new)

	DISPLAYTABLE [fe.displays[fe.list.display_index].name] <- (prf.BOXARTMODE ? ["BOXES"] : ["SNAPS"])
	//	try {fe.nv["AF_Display_Type"] <- DISPLAYTABLE} catch (err) {}
	savetabletofile(DISPLAYTABLE,"pref_thumbtype.txt")
}

function new_search(){
	frostshow()

	keyboard_search()

	if (prf.LIVESEARCH) frosthide()
	zmenuhide()
}

function favtoggle(){
	/*
	try {
		if (multifilterz.l0["Favourite"].menu["Favourite"].filtered){
			multifilterz.l0["Favourite"].menu["Favourite"].filtered = null
		}
		else multifilterz.l0["Favourite"].menu["Favourite"].filtered = true

		mfz_populate()
		mfz_apply(false)
		if (zmenu.showing) utilitymenu(umpresel)
	}
	catch (err){return}
	*/
		search.fav = !search.fav

		updatesearchdatamsg()

		//mfz_populate()
		mfz_apply(false)
		if (zmenu.showing) utilitymenu(umpresel)

}

umtable = []

function sortarrays(){
	local out = {
		switcharray_sort = [
			""+ ltxt("Title",AF.LNG) + " ▲",
			""+ ltxt("Title",AF.LNG) + " ▼",
			""+ ltxt("Manufacturer",AF.LNG) + " ▲",
			""+ ltxt("Manufacturer",AF.LNG) + " ▼",
			""+ ltxt("Year",AF.LNG) + " ▲",
			""+ ltxt("Year",AF.LNG) + " ▼",
			""+ ltxt("Category",AF.LNG) + " ▲",
			""+ ltxt("Category",AF.LNG) + " ▼",
			""+ ltxt("System",AF.LNG) + " ▲",
			""+ ltxt("System",AF.LNG) + " ▼",

			""+ ltxt("Rating",AF.LNG),
			""+ ltxt("Series",AF.LNG),

			""+ ltxt("Last Played",AF.LNG),
			""+ ltxt("Last Favourite",AF.LNG),
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
		label = ltxt("Sort and Filter",AF.LNG)
		glyph = -1
		visible = true
		order = 0
		id = 0
		sidenote = function (){return ""}
		command = function (){return}
	})

	umtable.push ({
		label = ltxt("Sort by",AF.LNG)
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

			zmenudraw (dat.switcharray_sort,dat.glypharray_sort,null,"  " + ltxt("Sort by",AF.LNG)+"...",0xea4c,dat.nowsort,false,false,false,false,false,
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
					AF.dat_freezecount = 2 //TEST144
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
		label = ltxt ("Jump to",AF.LNG)
		glyph = 0xea22
		visible = true
		order = 0
		id = 0
		sidenote = function(){
			try {return (z_list.jumptable[z_list.index].key)} catch (err){return("")}
		}
		command = function(){
			if (z_list.size == 0) return
			local currentkey = z_list.jumptable[z_list.index].key

			local textarray = []
			foreach (i,item in labelorder) textarray.push (item)

			local currentindex = textarray.find(currentkey)

			local glypharray = []
			foreach (i,item in textarray) glypharray.push (i == currentindex ? 0xea10 : 0)

			zmenudraw (textarray,glypharray,null, "Jump To",0xea22,currentindex,false,false,false,false,false,
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
		label = ltxt("Favourites Filter",AF.LNG)
		glyph = 0xe9d9
		visible = true
		order = 0
		id = 0
		sidenote = function(){
			local out = ""
			try {out = search.fav ? "FAVOURITES" : "ALL GAMES"} catch(err){}
			return (ltxt(out,AF.LNG))
		}
		command = function(){
			favtoggle()
		}
	})

	umtable.push ({
		label = ltxt("Multifilter",AF.LNG)
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
		label = ltxt("Filters",AF.LNG)
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
		label = ltxt("Displays",AF.LNG)
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
		label = ltxt("Categories",AF.LNG)
		glyph = 0xe916
		visible = true
		order = 0
		id = 0
		sidenote = function(){
		return ((search.catg[0] != "") ? search.catg[0]+(search.catg[1] == "" ? "" : "/"+search.catg[1]) : ltxt("ALL",AF.LNG))
		}
		command = function(){
			categorymenu()
		}
	})

	umtable.push ({
		label = ltxt("Search",AF.LNG)
		glyph = 0xe986
		visible = true
		id = 0
		order = 0
		sidenote = function(){
			return (search.smart == "" ? ltxt("NO SEARCH",AF.LNG) : search.smart)
		}
		command = function(){
			new_search()
		}
	})

	umtable.push ({
		label = ltxt("Screensaver",AF.LNG)
		glyph = -1
		visible = true
		order = 0
		id = 0
		sidenote = function (){return ""}
		command = function (){return}
	})

	umtable.push ({
		label = ltxt("Attract mode",AF.LNG)
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
		label = ltxt("Visuals",AF.LNG)
		glyph = -1
		visible = true
		order = 0
		id = 0
		sidenote = function (){return ""}
		command = function (){return}
	})

	umtable.push ({
		label = ltxt("Snaps or Box-Art",AF.LNG)
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
		label = ltxt("Reset Box Art",AF.LNG)
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
		label = ltxt("RetroArch Integration",AF.LNG)
		glyph = -1
		visible = true
		order = 0
		id = 0
		sidenote = function (){return ""}
		command = function (){return}
	})

	umtable.push ({
		label = ltxt ("Change core assignment",AF.LNG)
		glyph = 0xeafa
		visible = true
		id = 0
		order = 0
		sidenote = function(){
			return (prf.RAENABLED ? "☰" : ltxt("DISABLED",AF.LNG))
		}
		command = function(){
			if (!prf.RAENABLED) return
			umvisible = false
			ra_selectemu(z_list.gametable[z_list.index].z_emulator)
		}
	})

	umtable.push ({
		label = ltxt("System",AF.LNG)
		glyph = -1
		visible = true
		order = 0
		id = 0
		sidenote = function (){return ""}
		command = function (){return}
	})

	umtable.push ({
		label = ltxt("Layout options",AF.LNG)
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
		label = ltxt ("Check for updates",AF.LNG)
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
		label = ltxt ("About Arcadeflow",AF.LNG)
		glyph = 0xea09
		visible = true
		id = 0
		order = 0
		sidenote = function(){
			return "☰"
		}
		command = function(){
			local aboutpath = fe.path_expand( AF.folder + "history/"+(AF.version.tofloat()*10).tostring() + ".txt")
			local aboutfile = ReadTextFile (aboutpath)

			local textarray = []
			local glypharray = []

			while (!aboutfile.eos()){
				textarray.push(aboutfile.read_line())
				glypharray.push (0xea08)
			}

			textarray[0] = "What's New"
			glypharray[0] = 0

			zmenudraw (textarray,glypharray,null, "Arcadeflow "+AF.version,0xea09,0,false,false,false,false,false,
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
	local posarray1 = []
	local idarray1 = []
	local sidearray1 = []

	local i_pos = 0
	local i_id = 0

	foreach (item in umtable){
		if (item.visible){
			switcharray1.push (item.label)
			glypharray1.push (item.glyph)
			posarray1.push (i_pos)
			idarray1.push (i_id)
			sidearray1.push (item.sidenote())
			i_pos++
		}
		i_id++
	}

	/*
	foreach (i,item in sidearray1){
		sidearray1[i] = i.tostring()
	}
	*/

	frostshow()
	zmenudraw (switcharray1, glypharray1, sidearray1, (ltxt("Utility Menu",AF.LNG) ),0xe9bd,presel,false,false,false,false,false,
	function(result1){
		if (result1 == -1){
			umvisible = false
			frosthide()
			zmenuhide()
		}
		else {
			umpresel = posarray1[result1]
			umtable[idarray1[result1]].command()
		}
	})
}

function z_resetthumbvideo(index){
	tilez[index].gr_vidsz.alpha = 0
	tilez[index].vidsz.alpha = 0
	tilez[index].gr_vidsz.file_name = AF.folder+"pics/transparent.png"
	gr_vidszTableFade[index] = [0.0,0.0,0.0,0.0,0.0]
	aspectratioMorph[index] = [0.0,0.0,0.0,0.0,0.0]
	vidpos[index] = 0
}


function updatescrollerposition(){
	scroller.x = fl.x+UI.footermargin + ((z_list.index/UI.rows) * UI.rows*1.0/(z_list.size - 1 ))*(fl.w - 2.0*UI.footermargin-scrollersize)
	scroller2.x = scroller.x-scrollersize*0.5
}

function resetvarsandpositions(){
	var = 0
	tilesTablePos.Offset = 0

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
		picsize (tilez[i].obj , UI.tilewidth, UI.tileheight,0,-UI.zoomedvshift*1.0/UI.zoomedwidth)
		tilez[i].obj.zorder = -2
		tilez[i].obj.visible = false
		tile_clear(i,false)
		tile_redraw(i,false)
		tilesTableZoom[i] = [0.0,0.0,0.0,0.0,0.0]
		tilesTableUpdate[i] = [0.0,0.0,0.0,0.0,0.0]
		tilez[i].bd_mx.alpha = tilez[i].bd_mx_alpha = 0
		tilez[i].glomx.alpha = tilez[i].glomx_alpha = 0
	}
}

function updatetiles() {
	corrector = (UI.rows == 1 ? -1 : -((z_list.index + var) % UI.rows) )

	// Jump start and stop column
	column.stop = floor((z_list.index + var )*1.0/UI.rows)
	column.start = floor((z_list.index)*1.0/UI.rows)

	// Number of effective columns displayed on screen
	column.used = ceil((z_list.size )*1.0/UI.rows)

	column.offset = (column.stop - column.start)


	// This value is used to calculate the offset of the romlist indexes
	// to derermine focusindex.new, .old, indextemp etc
	tilesTablePos.Offset += column.offset * UI.rows

	// Determine center position correction when reaching beginning of list
	centercorr.shift = 0 // correction of jump dimension
	centercorr.val = 0 // correction of target position (it is 0 for centered tiles)

	if ((column.stop < deltacol) && (column.start > deltacol - 1)){
		centercorr.shift = centercorr.zero + (column.stop) * (UI.widthmix + UI.padding)
	}
	else if ((column.stop < deltacol) && (column.start <= deltacol - 1)){
		centercorr.shift = (column.offset < 0 ? -1 : 1) * (UI.widthmix + UI.padding)
	}
	else if ((column.stop >= deltacol) && (column.start <= deltacol - 1)){
		centercorr.shift = - centercorr.zero - (column.start) * (UI.widthmix + UI.padding)
	}

/*
	// check if the target of jump is in the deltacol group going LEFT
	if ((column.stop < deltacol) && (var < 0) ) {
		if (column.stop == deltacol - 1 )
			centercorr.shift = centercorr.zero + (deltacol - 1) * (UI.widthmix + UI.padding)
		else
			centercorr.shift = - (UI.widthmix + UI.padding)
	}
	// check if the start of jump is in the the deltacol group going RIGHT
	else if ((column.start < deltacol) && (var > 0)) {
		if (column.start == deltacol - 1 ){
			centercorr.shift = - centercorr.zero - (deltacol - 1) * (UI.widthmix + UI.padding)
		}
		else {
			centercorr.shift = (UI.widthmix + UI.padding)
		}
	}
*/
	//if ((z_list.index + var <= deltacol * rows - 1)){
	if ((column.stop < deltacol)){
		centercorr.val = centercorr.zero + floor((z_list.index + var)/UI.rows) * (UI.widthmix + UI.padding)
	}

	if (column.offset == 0) {
		centercorr.shift = 0
	}
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
		tilez[indexTemp].refsnapz.file_name = fe.get_art( (prf.TITLEART ? "title" : "snap") , indexoffsetvar,0,Art.ImagesOnly)

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

		update_snapcrop (indexTemp, var, indexoffsetvar, indexvar, gameAR, 0)

		// Update visibility of horizontal or vertical shadows, glow, indicator etc
		update_thumbdecor(indexTemp,var,tilez[indexTemp].AR.crop)
		if (tilez[indexTemp].bd_mx_alpha != 0) update_borderglow(indexTemp,var,tilez[indexTemp].AR.crop)
		tilez[indexTemp].freezecount = 2
	}
	tilez[indexTemp].obj.zorder = -2

	tilesTablePos.X[indexTemp] = (i/UI.rows) * (UI.widthmix + UI.padding) + carrierT.x + centercorr.val + UI.tilewidthmix*0.5
	tilesTablePos.Y[indexTemp] = (i%UI.rows) * (UI.coreheight + UI.padding) + carrierT.y + UI.tileheight * 0.5

	//TEST101 THIS INTERACTS WITH OFF SCREEN VISIBILITY
	//tilez[indexTemp].obj.visible = (( (z_list.index + var + index < 0) || (z_list.index + var + index > z_list.size-1) ) == false)
	tilez[indexTemp].offlist = (( (z_list.index + var + index < 0) || (z_list.index + var + index > z_list.size-1) ))
	//if(tilez[indexTemp].offlist) tile_freeze(indexTemp,true)
	//index++
}

function finaltileupdate(){
		// updates the size and features of the previously selected item and new selected item
		focusindex.new = wrap( floor(tiles.total/2)-1-corrector + tilesTablePos.Offset, tiles.total )
		focusindex.old = wrap( floor(tiles.total/2)-1-corrector -var + tilesTablePos.Offset, tiles.total )

		tile_freeze(focusindex.new,false)
		//tile_clear(focusindex.new,true)
		//tile_redraw(focusindex.new,true)
		tilez[focusindex.new].freezecount = 0

		if (!history_visible() && (scroll.jump == false) && (scroll.sortjump == false) && (zmenu.showing == false)) {
			tilesTableZoom[focusindex.old] = startfade (tilesTableZoom[focusindex.old],-0.055,1.0)
			tilesTableZoom[focusindex.new] = startfade (tilesTableZoom[focusindex.new],0.035,-5.0)
		}

		tilesTableUpdate[focusindex.old] = startfade (tilesTableUpdate[focusindex.old],-0.055,1.0)
		tilesTableUpdate[focusindex.new] = startfade (tilesTableUpdate[focusindex.new],0.035,-5.0)

		//activate video load counter
		if ((prf.THUMBVIDEO)){
			if(focusindex.old != focusindex.new){ //TEST142
				gr_vidszTableFade[focusindex.old] = startfade (gr_vidszTableFade[focusindex.old],prf.LOGOSONLY ? -0.04 : -0.01,1.0)
				aspectratioMorph[focusindex.old] = startfade (aspectratioMorph[focusindex.old],-0.08,1.0)
			}
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
	timestart ("    z_listrefreshtiles")
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
		timestop("    z_listrefreshtiles")
		//}
	}

	function z_updatefilternumbers(idx){
		timestart ("    z_updatefilternumbers")
		filternumbers.msg = (prf.CLEANLAYOUT ? "" : (idx+1)+"\n"+(z_list.size))
		timestop ("    z_updatefilternumbers")
	}

	function z_listrefreshlabels(){
		timestart("    z_listrefreshlabels")
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
	local w0 = fl.w - 2 * UI.footermargin
	local x0 = UI.footermargin
	local x00 = 0
	local label = {
		w = 100 * UI.scalerate,
		h = 40 * UI.scalerate,
		font = 30 * UI.scalerate
	}

	local label_obj = null

	if (prf.SCROLLERTYPE == "labellist"){

		w0 = (fl.w-2*UI.footermargin)*1.0
		x0 = (fl.w-w0) * 0.5
		x00 = 0
		label = {
			w = 100 * UI.scalerate,
			h = 40 * UI.scalerate,
			font = 30 * UI.scalerate
		}

		if (prf.LOWRES){
			label = {
				w = 150 * UI.scalerate,
				h = 70 * UI.scalerate,
				font = 45 * UI.scalerate
			}
		}

		labelstrip.set_pos (fl.x+x0,fl.h-UI.footer.h*0.5-label.h*0.5+fl.y,w0,label.h)
		labelstrip.set_rgb (themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)
		labelstrip.alpha = 100
		//labelstrip.visible = false

		//labelsurf.set_pos (0,0,w0,label.h)
		local labelarrayindex = 0
		foreach (key in labelorder){
			try {
				sortlabelsarray[labelarrayindex].msg = ((z_list.orderby == Info.Category ? categorylabel(key,0) : (z_list.orderby == Info.System ? systemlabel(key) : key) )).toupper()
				sortlabelsarray[labelarrayindex].x = round(x00,1)
				sortlabelsarray[labelarrayindex].y = 0
				sortlabelsarray[labelarrayindex].width = floor(w0/labelorder.len())
				sortlabelsarray[labelarrayindex].height = floor(label.h)
			}
			catch(err){
				sortlabelsarray.push(null)
				sortlabelsarray[labelarrayindex] = labelsurf.add_text( ((z_list.orderby == Info.Category ? categorylabel(key,0) : (z_list.orderby == Info.System ? systemlabel(key) : key) )).toupper() ,round(x00,1),0,w0/labelorder.len(),label.h)
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

			pixelizefont (sortlabelsarray[labelarrayindex],label.font)

			x00 = x00 + w0/labelorder.len()
			sortlabels[key] <- sortlabelsarray[labelarrayindex]
			resetkey (key)
			labelarrayindex ++
		}
		labelsurf.set_rgb(themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)
		labelsurf.shader = txtoalpha

		labelsurf.set_pos(fl.x+x0,fl.y+fl.h-UI.footer.h*0.5-label.h*0.5)
		if ((prf.SCROLLERTYPE == "labellist") && (z_list.size !=0 ) ) upkey (z_list.jumptable[z_list.index].key)
	}

	if (prf.SCROLLERTYPE == "timeline"){
		labelstrip.set_pos(fl.x + x0, fl.y + fl.h - UI.footer.h * 0.5, w0, label.h)
		labelstrip.set_rgb (themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)
		labelstrip.alpha = 100
		//labelstrip.visible = false
		local labelarrayindex = 0
		foreach (key in labelorder){
			i=1 // REMOVE FOR ALTERNATING LETTERS
			local labelspacer = labelcounter[key] * w0 / z_list.size
			try {
				sortlabelsarray[labelarrayindex].x = round(fl.x + x0 + labelspacer*0.5 - label.w*0.5,1)
				sortlabelsarray[labelarrayindex].y = round(fl.y + fl.h - UI.footer.h * 0.5,1)
				sortlabelsarray[labelarrayindex].width = label.w
				sortlabelsarray[labelarrayindex].height = label.h
			}
			catch(err){
				sortlabelsarray.push(null)
				sortlabelsarray[labelarrayindex] = data_surface.add_text("",round(fl.x + x0 + labelspacer*0.5 - label.w*0.5,1), round(fl.y + fl.h - UI.footer.h * 0.5,1) , label.w,label.h)
				sortlabelsarray[labelarrayindex].char_size = label.font
				sortlabelsarray[labelarrayindex].font = uifonts.lite
				sortlabelsarray[labelarrayindex].margin = 0
				sortlabelsarray[labelarrayindex].align = Align.MiddleCentre
				pixelizefont (sortlabelsarray[labelarrayindex],label.font)
			}

			sortlabelsarray[labelarrayindex].msg = ((z_list.orderby == Info.Category ? categorylabel (key,0) : (z_list.orderby == Info.System ? systemlabel(key) : key))).toupper()
			sortlabelsarray[labelarrayindex].set_rgb (themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)

			i++
			sortlabelsarray[labelarrayindex].visible = !( (labelspacer < 0.5*label.h) || ((searchdata.msg != "") && (abs(sortlabelsarray[labelarrayindex].x+sortlabelsarray[labelarrayindex].width*0.5-fl.w*0.5) < searchdata.msg_width)))

			if (labelspacer < sortlabelsarray[labelarrayindex].msg_width * 0.85) sortlabelsarray[labelarrayindex].visible = false

			try {
				sortticksarray[labelarrayindex].set_pos (fl.x+x0,fl.y+fl.h - UI.footer.h * 0.5 - 0.5*label.h*0.5,1,0.5*label.h+1)
			}
			catch (err){
				sortticksarray.push(null)
				sortticksarray[labelarrayindex] = data_surface.add_image(AF.folder+"pics/white.png",fl.x+x0,fl.y+fl.h - UI.footer.h * 0.5 - 0.5*label.h*0.5,1,0.5*label.h+1)
			}
			sortticksarray[labelarrayindex].set_rgb(themeT.themetextcolor.r,themeT.themetextcolor.g,themeT.themetextcolor.b)
			sortticksarray[labelarrayindex].visible = true

			x0 = x0 + labelspacer
			sortlabels[key] <- sortlabelsarray[labelarrayindex]
			sortticks[key] <- sortticksarray[labelarrayindex]
			labelarrayindex ++
		}

		if (labelorder.len() != 0) sortticks[labelorder[0]].visible = false
	}
	timestop("    z_listrefreshlabels")
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

/// Check ALLGAMES status ///

if (prf.ALLGAMES != AF.config.collections){
	buildconfig(prf.ALLGAMES, prf)
	if (prf.ALLGAMES) {
		update_allgames_collections(true,prf)
	}
	//fe.signal("reload")
	restartAM()
}

fe.layout.font = uifonts.mono
getallgamesdb(aflogo)
fe.layout.font = uifonts.general

function checkit2(){
	foreach(item, val in z_af_collections.tab){
		print(item+"\n")
		foreach (item2, val2 in val){
			print(item2+" "+val2+"\n")
		}
	}
}
//checkit2()

fe.add_signal_handler( this, "on_signal" )
fe.add_transition_callback( this, "on_transition" )
fe.add_ticks_callback( this, "tick" )

/*
try {print ("fl.surf:"+fl.surf.parents+"\n")}catch(err){}

try {print ("frost.surf_rt:"+frost.surf_rt.parents+"\n")}catch(err){}
try {print ("frost.surf_2:"+frost.surf_2.parents+"\n")}catch(err){}
try {print ("frost.surf_1:"+frost.surf_1.parents+"\n")}catch(err){}

try {print ("frost.pic:"+frost.pic.parents+"\n")}catch(err){}

try {print ("bglay.surf_rt:"+bglay.surf_rt.parents+"\n")}catch(err){}
try {print ("bglay.surf_2:"+bglay.surf_2.parents+"\n")}catch(err){}
try {print ("bglay.surf_1:"+bglay.surf_1.parents+"\n")}catch(err){}

try {print ("bgvidsurf_1:"+bgvidsurf_1.parents+"\n")}catch(err){}

try {print ("obj:"+tilez[0].obj.parents+"\n")}catch(err){}
try {print ("gradsurf_rt:"+gradsurf_rt.parents+"\n")}catch(err){}
try {print ("gradsurf_1:"+gradsurf_1.parents+"\n")}catch(err){}
try {print ("logosurf_rt:"+logosurf_rt.parents+"\n")}catch(err){}
try {print ("logosurf_1:"+logosurf_1.parents+"\n")}catch(err){}

try {print ("data_surface:"+data_surface.parents+"\n")}catch(err){}
try {print ("data_surface_sh_rt:"+data_surface_sh_rt.parents+"\n")}catch(err){}
try {print ("data_surface_sh_2:"+data_surface_sh_2.parents+"\n")}catch(err){}
try {print ("data_surface_sh_1:"+data_surface_sh_1.parents+"\n")}catch(err){}

try {print ("labelsurf:"+labelsurf.parents+"\n")}catch(err){}
try {print ("displaynamesurf:"+displaynamesurf.parents+"\n")}catch(err){}
try {print ("letterobjsurf:"+letterobjsurf.parents+"\n")}catch(err){}

try {print ("keyboard_surface:"+keyboard_surface.parents+"\n")}catch(err){}

try {print ("history_surface:"+history_surface.parents+"\n")}catch(err){}

try {print ("zmenu_surface_container:"+zmenu_surface_container.parents+"\n")}catch(err){}
try {print ("zmenu_surface:"+zmenu_surface.parents+"\n")}catch(err){}
try {print ("zmenu_sh.surf_rt:"+zmenu_sh.surf_rt.parents+"\n")}catch(err){}
try {print ("zmenu_sh.surf_2:"+zmenu_sh.surf_2.parents+"\n")}catch(err){}
try {print ("zmenu_sh.surf_1:"+zmenu_sh.surf_1.parents+"\n")}catch(err){}

print("\n")
*/

// After setting preferences and loading layout check if collections preference is
// synced with collections displays in attract config, if it's not like this
// regenerate the config file, and in case we have ALLGAMES enabled
// update the colelctions. At the end AF is rebooted


/// On Transition ///

function on_transition( ttype, var0, ttime ) {

	if (ttype == Transition.FromGame) {
		if (prf.RPI) fe.set_display(fe.list.display_index)

		z_list.gametable2[z_list.index].z_playedcount ++
		saveromdb (z_list.gametable[z_list.index].z_emulator,z_list.db2[z_list.gametable[z_list.index].z_emulator],"db2")

		update_thumbdecor (focusindex.new,0,tilez[focusindex.new].AR.current)

		mfz_build(true)
		try {
			mfz_load()
			mfz_populatereverse()
		} catch(err){}
		mfz_apply(false)
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

		z_list.gametable2[z_list.index].z_rundate = datestr
		saveromdb (z_list.gametable[z_list.index].z_emulator,z_list.db2[z_list.gametable[z_list.index].z_emulator],"db2")


//		z_list.rundatetable[emulatorname][gamename] <- datestr

		//save the rundate table to file
//		z_saverundatetofile()
	}

	if (ttype == Transition.FromGame) {
		/*
		flowT.data = startfade (flowT.data,0.06,3.0)
		flowT.fg = startfade (flowT.fg,-0.06,3.0)
		*/
		flowT.groupbg = startfade (flowT.groupbg,0.06,3.0)
	}

	if ((ttype == Transition.ShowOverlay) && (prf.THEMEAUDIO) ) snd.wooshsound.playing = true

	if (prf.LAYERVIDEO) {
		 if (((ttype == Transition.ToNewSelection) || (ttype == Transition.ToNewList) ) && (prf.LAYERVIDEO)) {

		//background video delay load
			vidposbg = vidstarter
			//TEST150 bgs.bgvid_top.alpha = 0
			//TEST150 vidbgfade=[0.0,0.0,0.0,0.0,0.0]
			vidbgfade = startfade (vidbgfade,-0.1,1.0)

			//TEST150 bgs.bgvid_top.file_name = AF.folder+"pics/transparent.png"
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
			search.mots = ["",""]
			search.mots2string = ""
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
		try {
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
		displaynamesurf.surf.redraw = true
		flowT.zoomdisplay = [0.0,0.0,0.0,0.0,0.0]
		flowT.zoomdisplay = startfade (flowT.zoomdisplay,0.015,-2.0)
	}

	// DISPLAY CHANGE REACTION
	if ((ttype == Transition.ToNewList) && (fe.list.display_index != displaystore)){
		// fade.display = fade.displayzoom = 1
		displayname.msg = displaynamelogo(0)

		flowT.alphadisplay = startfade (flowT.alphadisplay,0.04,-2.0)
		displaynamesurf.surf.redraw = true
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

		zmenu_surface_container.redraw = zmenu_surface.redraw = zmenu_sh.surf_rt.redraw = zmenu_sh.surf_2.redraw = zmenu_sh.surf_1.redraw = false
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

				changetiledata(i,index,( (ttype == Transition.ToNewList) || ((ttype == Transition.ToNewSelection) && (( ( (column.stop>column.start) && (i/UI.rows >= tiles.total/UI.rows - column.offset) ) || ( (column.stop < column.start) && (i/UI.rows < -column.offset) ))))))

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

		if (!data_surface.redraw) data_freeze(false)
		if (!bglay.surf_1.redraw) bgs_freeze(false)

		debugpr ("TRANSBLOCK 3.0 - TNS - TRANSITION TO NEW SELECTION ONLY \n")

		local l1 = z_list.jumptable[z_list.index].key
		local l2 = z_list.jumptable[z_list.newindex].key

		if (l1 != l2){
			// Update the letter item, checking if it can use a system font
			letterobj.msg = systemfont (l2,false)
			flowT.alphaletter = startfade (flowT.alphaletter,0.06,-2.0)
			letterobjsurf.surf.redraw = true
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

			if (prf.MULTIMON) mon2.pic_array[i].swap(mon2.pic_array[i+1])
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

			if (!prf.CLEANLAYOUT) dat.manufacturername_array[i].visible = (dat.manufacturer_array[i].msg == "")

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


		// surfacePos is the counter that is used to trigger scroll, when it's not zero, scroll happens
		// normally it's large as a tile, but close to the border centercorr.shift is non zero so it scrolls less or not at all
		surfacePos += (column.offset * (UI.widthmix + UI.padding) ) - centercorr.shift

		impulse2.delta = (column.offset * (UI.widthmix + UI.padding) ) - centercorr.shift
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
	//print (tilez[focusindex.new].obj.x+" "+tilez[focusindex.new].obj.y+" "+tilez[focusindex.new].obj.width+" "+tilez[focusindex.new].obj.height+"\n")
	//print (tilez[focusindex.new].snapz.x+" "+tilez[focusindex.new].snapz.y+" "+tilez[focusindex.new].snapz.width+" "+tilez[focusindex.new].snapz.height+"\n")

//	testpr("zmenu_sh: "+zmenu_sh.surf_rt.redraw+" - zmenu_cont: "+zmenu_surface_container.redraw+"\n")
//	testpr(zmenu.xstart+" "+zmenu.xstop+" "+zmenu.speed+"\n")

	foreach (i, item in tilez){
		if (item.freezecount == 2){
			tile_freeze(i,false)
			tilez[i].freezecount = 1
		}
		else if (item.freezecount == 1){
			tile_freeze(i,true)
			tilez[i].freezecount = 0
		}
	}

	if (AF.dat_freezecount == 2){
		data_freeze(false)
		AF.dat_freezecount = 1
	}
	else if (AF.dat_freezecount == 1){
		data_freeze(true)
		AF.dat_freezecount = 0
	}

	if (AF.bgs_freezecount == 2){
		bgs_freeze(false)
		AF.bgs_freezecount = 1
	}
	else if (AF.bgs_freezecount == 1){
		bgs_freeze(true)
		AF.bgs_freezecount = 0
	}

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

		if (prf.SNAPGLOW) snap_glow[focusindex.new].set_param ("basergb", huecycle.RGB.R, huecycle.RGB.G, huecycle.RGB.B)

		tilez[focusindex.new].bd_mx.set_rgb(255*huecycle.RGB.R,255*huecycle.RGB.G,255*huecycle.RGB.B)
	}

	if (snd.bgtuneplay != snd.bgtune.playing) {
		if (snd.bgtuneplay && prf.RANDOMTUNE) 	snd.bgtune = fe.add_sound(AF.bgsongs[AF.bgsongs.len()*rand()/RAND_MAX])

		snd.bgtune.playing = snd.bgtuneplay
	}

	if (snd.attracttuneplay != snd.attracttune.playing) {
		snd.attracttune.playing = snd.attracttuneplay
	}

	// When the scrapelist is populated, scraper starts running through it
	if (AF.scrape.purgedromdirlist != null){
		// Case 1: scrapelist is empty and dispatched are finished, it's time
		// to close the romlist and save the results
		if ((AF.scrape.purgedromdirlist.len() == 0) && (dispatchernum == 0)){
			// Save current data on respective romlists databases
			foreach (item, val in z_list.allromlists){
				saveromdb (item, z_list.db1[item], "db1")
			}
			AF.scrape.purgedromdirlist = null


			local endreport = ""
			endreport += "SCRAPE STATUS REPORT\n"

			if (AF.scrape.timeoutroms.len()>0){
				endreport += ("TIMEOUT"+":"+AF.scrape.timeoutroms.len()+" ")
			}
			foreach (item,content in AF.scrape.report){
				endreport += (item+":"+content.tot+" ")
			}

			endreport += ("\n")
			if (AF.scrape.timeoutroms.len()>0) endreport += (AF.scrape.separator1+"\n"+"TIMEOUT"+"\n")
			foreach(ix, itemx in AF.scrape.timeoutroms){
				endreport += ("- "+itemx.z_name+"\n")
			}

					foreach (item,content in AF.scrape.report){
				endreport += (AF.scrape.separator1+"\n"+item+"\n")
				foreach (i2, item2 in content.names){
					endreport += ("- "+item2+"\n"+" ["+content.matches[i2]+"]\n")
				}
			}


			local outreport = AF.folder+"scrapelog.txt"
			local outfile = file(outreport,"w")
			z_write_line(outfile,endreport)
			outfile.close()

			AF.boxmessage = messageboxer(AF.scrape.romlist+" "+AF.scrape.totalroms+"/"+AF.scrape.totalroms,"COMPLETED - PRESS ESC TO RELOAD LAYOUT\n"+AF.scrape.separator2+"\n"+endreport+"\n",false,AF.boxmessage)

			AFscrapeclear()
			dispatcher = []

		}
		// Case 2: scraperlist is not null, it's not empty, and threads are not too many
		// we can "dispatch" a new scrape process
		if ((AF.scrape.purgedromdirlist != null) && (AF.scrape.purgedromdirlist.len() != 0) && (AF.scrape.threads < 20)){
			// Increase the number of thread counts
			AF.scrape.threads ++
			// Add a new data structure to the scrape dispatcher
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
				time0 = fe.layout.time
			})


			local t0 = fe.layout.time

			scraprt("ID"+AF.scrape.dispatchid+" DISPATCH "+AF.scrape.purgedromdirlist[AF.scrape.purgedromdirlist.len()-1]+"\n")



			// Run the scrapegame2 function in the currently dispatched scrape
			// passing the last item on the purgedlist to the function
			//dispatcher[AF.scrape.dispatchid].scrapegame2.call(AF.scrape.dispatchid,AF.scrape.purgedromdirlist.pop(),AF.scrape.quit)
			if (AF.scrape.quit){
				AF.scrape.purgedromdirlist = []
				AF.scrape.quit = false
			}
			else {
				// Increase number of dispatch count
				dispatchernum ++
				scraprt("ID"+AF.scrape.dispatchid+" main CALL scrapegame2\n")
				dispatcher[AF.scrape.dispatchid].scrapegame2.call(AF.scrape.dispatchid,AF.scrape.purgedromdirlist.pop(),AF.scrape.quit)
			}
			// Increase the number of the id for the next scrape
			AF.scrape.dispatchid ++
		}
	}

	if (dispatchernum != 0){
		foreach (i, item in dispatcher){
			if (item.done){
				try {remove (AF.folder + "json/" + i + "json.txt")} catch(err){}
				try {remove (AF.folder + "json/" + i + "json.nut")} catch(err){}
				try {remove (AF.folder + "json/" + i + "json_out.nut")} catch(err){}

				if (item.gamedata.scrapestatus != "RETRY") AF.scrape.doneroms ++
				scraprt("ID"+i+" COMPLETED "+item.gamedata.filename+"\n")
				if (item.gamedata.requests != "") AF.scrape.requests = item.gamedata.requests
				AF.boxmessage = messageboxer (patchtext (AF.scrape.romlist+" "+(AF.scrape.totalroms-AF.scrape.purgedromdirlist.len())+"/"+AF.scrape.totalroms, AF.scrape.requests,11,AF.scrape.columns)+"\n"+textrate(AF.scrape.doneroms,AF.scrape.totalroms,AF.scrape.columns,"|","\\"), patchtext(item.gamedata.filename,item.gamedata.scrapestatus,11,AF.scrape.columns)+"\n",true,AF.boxmessage)

				AF.scrape.threads --
				dispatchernum --
				scraprt("ID"+i+" main WAKEUP scrapegame2\n")
				if ((!item.quit) && (!item.skip)) item.scrapegame2.wakeup()
				//scraprt("ID"+i+" main continue second check\n")

				item.time0 = -1
				item.gamedata = null
				item.done = false
			}
			else {
				if (item.pollstatus && file_exist(AF.folder + "json/" + i + "json.txt")){
					try {remove (AF.folder + "json/" + i + "json.txt")} catch(err){}
					item.pollstatus = false
					scraprt("ID"+i+" main WAKEUP createjson\n")
					item.createjson.wakeup()
					scraprt("ID"+i+" main WAKEUP getromdata\n")
					item.getromdata.wakeup()
					scraprt("ID"+i+" main end first check\n")
				}
			 	else if (item.pollstatusA && file_exist(AF.folder + "json/" + i + "jsonA.txt") ){
					try {remove (AF.folder + "json/" + i + "jsonA.txt")} catch(err){}
					item.pollstatusA = false
					scraprt("ID"+i+" main WAKEUP createjsonA\n")
					item.createjsonA.wakeup()
					scraprt("ID"+i+" main WAKEUP getromdata\n")
					item.getromdata.wakeup()
					scraprt("ID"+i+" main end first check\n")
				}
				else if ((item.time0 != -1) && (fe.layout.time - item.time0 >= 10000)){
					AF.scrape.timeoutroms.push(item.rominputitem) //pushes the timeout item in the list
					scraprt("ID"+i+" TIMEOUT\n")

					try {remove (AF.folder + "json/" + i + "json.txt")} catch(err){}
					try {remove (AF.folder + "json/" + i + "json.nut")} catch(err){}
					try {remove (AF.folder + "json/" + i + "json_out.nut")} catch(err){}
					try {remove (AF.folder + "json/" + i + "jsonA.txt")} catch(err){}
					try {remove (AF.folder + "json/" + i + "jsonA.nut")} catch(err){}
					try {remove (AF.folder + "json/" + i + "jsonA_out.nut")} catch(err){}

					item.pollstatusA = item.pollstatus = false
					AF.scrape.threads --
					dispatchernum --

					item.gamedata = null
					item.done = false
					item.time0 = -1
				}
			}
		}
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
			else AF.tsc = 60.0/ScreenRefreshRate
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
			if (prf.LAYERVIDEO) bgs.bgvid_top.video_playing = true

		}
	}

	// prevent attract mode from running when menus are visible
	if ((overlay.listbox.visible == true) || (zmenu.showing) || (AF.messageoverlay.visible)) attract.timer = fe.layout.time

	if ((disp.xstart != disp.xstop) && (prf.DMPIMAGES != null) && (zmenu.dmp) ){
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
				disp.bgshadowb.y = disp.images[zmenu.selected].y + disp.images[zmenu.selected].height
				disp.bgshadowt.y = disp.images[zmenu.selected].y - disp.bgshadowt.height

			}
			else {
				for (local i = 0;i < disp.images.len() ; i++) {
					disp.images[i].y = disp.pos0[i] + disp.xstart + disp.speed
				}
				disp.bgshadowb.y = disp.images[zmenu.selected].y + disp.images[zmenu.selected].height
				disp.bgshadowt.y = disp.images[zmenu.selected].y - disp.bgshadowt.height

				disp.xstart = disp.xstart + disp.speed
			}
		}
		else {
			disp.xstart = disp.xstop
			for (local i = 0;i < disp.images.len() ; i++) {
				disp.images[i].y = disp.pos0[i] + disp.xstop
			}
			disp.bgshadowb.y = disp.images[zmenu.selected].y + disp.images[zmenu.selected].height
			disp.bgshadowt.y = disp.images[zmenu.selected].y - disp.bgshadowt.height
		}
	}


	if (zmenu.xstart != zmenu.xstop){
		zmenu.speed = zmenu.singleline ? (zmenu.xstop - zmenu.xstart) : (0.2 * (zmenu.xstop - zmenu.xstart))
		if (absf(zmenu.speed) > 0.0005*zmenu.tileh) {
			for (local i = 0;i < zmenu.shown ; i++) {
				zmenu.items[i].y = zmenu.pos0[i] + zmenu.xstart + zmenu.speed
				zmenu.noteitems[i].y = zmenu.pos0[i] + zmenu.xstart + zmenu.speed
				zmenu.glyphs[i].y = zmenu.pos0[i] + zmenu.xstart + zmenu.speed
				zmenu.strikelines[i].y = zmenu.pos0[i] + floor(zmenu.tileh*0.5) + zmenu.xstart + zmenu.speed

			}

			zmenu.xstart = zmenu.xstart + zmenu.speed
		}
		else {
			zmenu.xstart = zmenu.xstop
			zmenu.speed = 0
			for (local i = 0;i < zmenu.shown ; i++) {
				zmenu.items[i].y = zmenu.pos0[i] + zmenu.xstop
				zmenu.noteitems[i].y = zmenu.pos0[i] + zmenu.xstop
				zmenu.glyphs[i].y = zmenu.pos0[i] + zmenu.xstop
				zmenu.strikelines[i].y = zmenu.pos0[i] +floor(zmenu.tileh*0.5) + zmenu.xstop
			}
		}
		zmenu.selectedbar.y = zmenu.sidelabel.y = zmenu.items[zmenu.selected].y
	}

	// Attract mode management
	if (prf.AMENABLE) {

		if (attract.start){
			// block theme videos and set snap audio
			if (prf.THUMBVIDEO) tilez[focusindex.new].gr_vidsz.video_playing = false
			if (prf.THUMBVIDEO) videosnap_hide()
			if (prf.LAYERVIDEO) bgs.bgvid_top.video_playing = false
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

	if (squarizertop){
		squarizertop = false
		squarebgtop()
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

	if (bglay.surf_1.redraw && (bgs.bgpic_array[bgs.stacksize-1].alpha == 255)) AF.bgs_freezecount = 1

	if (checkfade(flowT.alphaletter)){
		flowT.alphaletter = fadeupdate(flowT.alphaletter)
		if (endfade(flowT.alphaletter) == 1.0) {
			flowT.alphaletter = startfade (flowT.alphaletter,-0.06,2.0)
		}
		if (endfade(flowT.alphaletter) == 0.0) {
			letterobjsurf.surf.redraw = false
		}
		letterobj.alpha = 255 * flowT.alphaletter[1]
	}

	if (checkfade(flowT.zoomletter)){
		flowT.zoomletter = fadeupdate(flowT.zoomletter)
		local scalesurf = 0.5 + 0.5 * flowT.zoomletter[1]
		//letterobj.charsize = lettersize.name * (1.0+flowT.zoomletter[1])
		letterobjsurf.surf.set_pos(fl.x+0.5*(fl.w-letterobjsurf.w * scalesurf),letterobjsurf.y0 + 0.5*letterobjsurf.h-0.5*letterobjsurf.h*scalesurf,letterobjsurf.w*scalesurf,letterobjsurf.h*scalesurf)

	}

	if (checkfade(flowT.alphadisplay)){
		flowT.alphadisplay = fadeupdate(flowT.alphadisplay)
		if ( (endfade(flowT.alphadisplay) == 1.0) ) {
			flowT.alphadisplay = startfade (flowT.alphadisplay,-0.04,2.0)
		}
		if ( (endfade(flowT.alphadisplay) == 0.0) ) {
			displaynamesurf.surf.redraw = false
		}
		displayname.alpha  = 255 * flowT.alphadisplay[1]
	}

	if (checkfade(flowT.zoomdisplay)){
		flowT.zoomdisplay = fadeupdate(flowT.zoomdisplay)
		//displayname.char_size = lettersize.display * (1.0+flowT.zoomdisplay[1])
		local scalesurf = 0.25 + 0.75 * flowT.zoomdisplay[1]
		displaynamesurf.surf.set_pos(fl.x+0.5*(fl.w-displaynamesurf.w*scalesurf),fl.y+0.5*(fl.h-displaynamesurf.h*scalesurf),displaynamesurf.w*scalesurf,displaynamesurf.h*scalesurf)
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
				if (tilez[i].vidsz.alpha == 0) {
					tilez[i].freezecount = 2
				}
			}

			if (updatetemp[3] < 0){
				tilez[i].glomx_alpha = 255*pow(updatetemp[1],5)
				tilez[i].bd_mx_alpha = 240*pow(updatetemp[1],5)
				tilez[i].bd_mx.alpha = tilez[i].alphalogosonly * tilez[i].bd_mx_alpha
				tilez[i].glomx.alpha = tilez[i].alphalogosonly * tilez[i].glomx_alpha
			}
			else{
				tilez[i].glomx_alpha = 255*(updatetemp[1])
				tilez[i].bd_mx_alpha = 240*(updatetemp[1])
				tilez[i].bd_mx.alpha = tilez[i].alphalogosonly * tilez[i].bd_mx_alpha
				tilez[i].glomx.alpha = tilez[i].alphalogosonly * tilez[i].glomx_alpha
			}
		}
	}

	foreach (i, item in tilesTableZoom){
		if (checkfade(tilesTableZoom[i])){
			tilesTableZoom[i] = fadeupdate(tilesTableZoom[i])
			local zoomtemp = tilesTableZoom[i]

			// update size and glow alpha
			picsize(tilez[i].obj, UI.tilewidth + (UI.zoomedwidth-UI.tilewidth)*(zoomtemp[1]), UI.tilewidth + (UI.zoomedwidth-UI.tilewidth)*(zoomtemp[1]) , 0, -(UI.zoomedvshift*1.0/UI.zoomedwidth ))
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
				tilez[i].vidsz.file_name = tilez[i].gr_vidsz.file_name = AF.folder+"pics/transparent.png"
				tilez[i].gr_vidsz.alpha = 0
				tilez[i].vidsz.alpha = 0
				if (prf.FADEVIDEOTITLE){
					tilez[i].txshz.alpha = tilez[i].loshz.alpha = 150
					tilez[i].txt2z.alpha = tilez[i].txt1z.alpha = tilez[i].donez.alpha = tilez[i].favez.alpha = tilez[i].logoz.alpha = 255
					tilez[i].nw_mx.alpha = ((prf.NEWGAME == true)? 220 : 0)
					tilez[i].tg_mx.alpha = ((prf.TAGSHOW == true)? 255 : 0)
				}
				if (tilez[i].bd_mx_alpha == 0) {
					tilez[i].freezecount = 2
				}//TEST142
			}

			if (prf.LOGOSONLY) {
				tilez[i].alphalogosonly = fadetemp[1]
				tilez[i].bd_mx.alpha = tilez[i].alphalogosonly * tilez[i].bd_mx_alpha
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


	AF.dat_freeze = true
	// crossfade of game data
	for (local i = 0 ; i < dat.stacksize ; i++){
		if (dat.alphapos[i] != 0 ){
			if ((dat.alphapos[i] <0.01) && (dat.alphapos[i] > -0.01)) dat.alphapos[i] = 0

			if (i != dat.stacksize -1){
				dat.alphapos[i] = dat.alphapos[i] * spdT.dataspeedout
				dat.ply_array[i].alpha = dat.ctl_array[i].alpha = dat.but_array[i].alpha = dat.cat_array[i].alpha = dat.mainctg_array[i].alpha = dat.manufacturer_array[i].alpha = dat.gamename_array[i].alpha = dat.gamesubname_array[i].alpha = dat.manufacturername_array[i].alpha = dat.gameyear_array[i].alpha = 255 * (dat.alphapos[i])*1.0
				if (prf.MULTIMON) mon2.pic_array[i].alpha = dat.ply_array[i].alpha
			}
			else {
				dat.alphapos[dat.stacksize -1] = dat.alphapos[dat.stacksize - 1] * spdT.dataspeedin
				dat.ply_array[i].alpha = dat.ctl_array[i].alpha = dat.but_array[dat.stacksize - 1].alpha = dat.cat_array[dat.stacksize - 1].alpha = dat.mainctg_array[dat.stacksize - 1].alpha = dat.manufacturer_array[dat.stacksize - 1].alpha = dat.gamename_array[dat.stacksize - 1].alpha = dat.gamesubname_array[dat.stacksize - 1].alpha = dat.manufacturername_array[dat.stacksize - 1].alpha =dat.gameyear_array[dat.stacksize - 1].alpha = 255 * (1.0 - dat.alphapos[dat.stacksize - 1])*1.0
				if (prf.MULTIMON) mon2.pic_array[i].alpha = dat.ply_array[i].alpha
			}
		}
		if (dat.alphapos[i] != 0) AF.dat_freeze = false
	}
	if (AF.dat_freeze && data_surface.redraw && (displayname.alpha == 0)) {
		AF.dat_freezecount = 1
	}

	//EASE PRINT
/*
	local pippo1 = fe.add_image(AF.folder+"pics/white.png",CCC,fl.h_os*0.5+(impulse2.tilepos)*0.1,3,3) //RED
	local pippo2 = fe.add_image(AF.folder+"pics/white.png",CCC,fl.h_os*0.5+(impulse2.flow)*0.1,3,3) //BLACK
	local pippo3 = fe.add_image(AF.folder+"pics/white.png",CCC,fl.h_os*0.5+(impulse2.maxoffset)*0.1,3,3) //WHITE
	local pippo4 = fe.add_image(AF.folder+"pics/white.png",CCC,fl.h_os*0.5-(impulse2.maxoffset)*0.1,3,3) //BLUE
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
			local to_offscreen = ((tilez[i].obj.x + tilez[i].obj.width * 0.5 < 0) || (tilez[i].obj.x - tilez[i].obj.width * 0.5 > fl.w_os))
			if (tilez[i].obj.visible && tilez[i].offlist) {
				tilez[i].obj.visible = false
				tile_freeze(i,true)
			}
			else if (!tilez[i].offlist){
				if (tilez[i].obj.visible && to_offscreen) {
					tilez[i].obj.visible = false
				}
				if (!tilez[i].obj.visible && !to_offscreen) {
					tilez[i].obj.visible = true
				}
			}

			if (z_list.size == 0) {
				tilez[i].obj.visible = false
				tile_freeze(i,true)

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
	if ((prf.LAYERVIDEO) ){
		if (vidposbg !=0){
			vidposbg = vidposbg - 1
			if (prf.LAYERVIDELAY) {
				if (vidposbg == delayvid){
					bgs.bgvid_top.alpha = 0
					bgs.bgvid_top.file_name = fe.get_art("snap",0)
					squarizertop = true
				}
				if (vidposbg == fadevid){
					vidbgfade = startfade (vidbgfade,0.03,1.0)
					vidposbg = 0
				}
			}
			else {
				if (vidposbg == 10000 - 10){
					bgs.bgvid_top.alpha = 0
					bgs.bgvid_top.file_name = fe.get_art("snap",0)
					squarizertop = true
				}
				if (vidposbg == 10000 - 10 - 10){
					vidbgfade = startfade (vidbgfade,0.03,1.0)
					vidposbg = 0
				}
			}
		}

		if (checkfade(vidbgfade)){
			vidbgfade = fadeupdate(vidbgfade)
			local fadetemp = vidbgfade
			// update size and glow alpha
			bgs.bgvid_top.alpha = 255*(fadetemp[1])
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

					tilez[i].AR.vids = prf.VID169 ? 9.0/16.0 : getvidAR(tilez[i].offset,tilez[i].vidsz,tilez[i].refsnapz,0)

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
		if ((tick_time >= 8000) && (!prf.UPDATECHECKED) && (!zmenu.showing) && (!frost.surf_rt.visible)) {
			prf.UPDATECHECKED = true
			checkforupdates(false)
		}
	}

	if (checkfade (flowT.keyboard)){
		flowT.keyboard = fadeupdate(flowT.keyboard)
		if (endfade (flowT.keyboard) == 0){
			keyboard_surface.visible = false
			keyboard_surface.redraw = false
		}
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
		overlay.background.alpha = themeT.listboxalpha * (flowT.zmenubg[1])
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
			zmenu_sh.surf_rt.redraw = zmenu_sh.surf_2.redraw = zmenu_sh.surf_1.redraw = false
			zmenu_sh.surf_rt.visible = false
		}
		zmenu_sh.surf_rt.alpha = themeT.menushadow * (flowT.zmenush[1])
		prfmenu.bg.alpha = themeT.optionspanelalpha * (flowT.zmenush[1])
	}

	if (checkfade (flowT.zmenutx)){
		flowT.zmenutx = fadeupdate(flowT.zmenutx)
		if (endfade (flowT.zmenutx) == 0) {
			zmenu_surface_container.redraw = zmenu_surface.redraw = false
			zmenu_surface_container.visible = false

			overlay.sidelabel.visible = overlay.label.visible = overlay.glyph.visible = overlay.wline.visible = false
		}
		overlay.sidelabel.alpha = 255 * (flowT.zmenutx[1])
		overlay.label.alpha = 255 * (flowT.zmenutx[1])
		overlay.glyph.alpha = 255 * (flowT.zmenutx[1])
		overlay.wline.alpha = 255 * (flowT.zmenutx[1])
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
			if (!UI.vertical){
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
			if (prf.CONTROLOVERLAY != "never") history_updateoverlay()
			flowT.historydata = startfade (flowT.historydata,-0.101,3.0)
		}

		hist_text_alpha (255 * (1.0 - flowT.historydata[1]))
		if(prf.CONTROLOVERLAY != "never") hist_over.surface.alpha = 255 * (1.0 - flowT.historydata[1])*(1.0 - flowT.historydata[1])*(1.0 - flowT.historydata[1])

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

	if (checkfade(flowT.groupbg)){
		flowT.groupbg = fadeupdate(flowT.groupbg)

		groupalpha(255 * flowT.groupbg[1])
	}

	// attract mode surface fade
	if (checkfade(flowT.attract)){
		flowT.attract = fadeupdate(flowT.attract)

		if (endfade(flowT.attract) == 0) {
			if (prf.THUMBVIDEO) videosnap_restore()
			if (prf.LAYERVIDEO) bgs.bgvid_top.video_playing = true
			attractitem.snap.file_name = AF.folder+"pics/transparent.png"
			attractitem.snap.shader = noshader
			attractitem.surface.visible = attractitem.surface.redraw = false
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

		attractitem.black.alpha = 255 * flowT.gametoblack[1]
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

		//hist_text.y = hist_textT.h * (1.0 - flowT.histtext[1])
	}

	// history page fade in fade out
	if (checkfade(flowT.history)){
		flowT.history = fadeupdate(flowT.history)

		if (endfade(flowT.history) == 0) {
			hist_title.file_name = AF.folder+"pics/transparent.png"
			hist_screen.file_name = AF.folder+"pics/transparent.png"
			hist_screen.shader = noshader
			shadowsurf_1.shader = noshader
			shadowsurf_2.shader = noshader
			shadowsurf_rt.shader = noshader
			hist_text_surf.shader = noshader
			history_surface.visible = false
			history_redraw(false)
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

function buildcategorytable(){
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


	ctgarray.insert(0,ltxt("ALL",AF.LNG))
	ctgarray2.insert(0,ltxt("ALL",AF.LNG))
	ctgarraynum.insert(0,"")

	local currentcat = (search.catg[1] == "*") ? 0 : ctgarray.find( search.catg[1] )

	foreach (i,item in ctgarray) ctgarrayglyph.push (i == currentcat ? 0xea10 : 0)


	zmenudraw (ctgarray2, ctgarrayglyph,ctgarraynum, maincategory, 0xe916,  subcategory == "" ? 0 : ctgarray.find(subcategory), false,false,  false,false,false,
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

	ctgarray.insert (0,ltxt("ALL",AF.LNG))
	ctgarraynum.insert (0,"")
	local currentcat = (search.catg[0] == "") ? 0 : ctgarray.find( search.catg[0] )

	foreach (i,item in ctgarray) ctgarrayglyph.push (i == currentcat ? 0xea10 : 0)

	frostshow()

	zmenudraw (ctgarray, ctgarrayglyph,ctgarraynum, ltxt("Categories",AF.LNG), 0xe916, ctgarray.find(maincategory), false,false, false,false,false,
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

	zmenudraw (labelvector,glyphvector,null,title,glyph,presel,false,false,false,false,false,
	function(out){
		if (out == -1){
			local v0 = ""
			for (local i = 0 ; i < vector.len();i++){
				v0 = v0 + vector[i]+","
			}
			AF.prefs.l1[prfmenu.outres0][prfmenu.outres1].values = v0
			optionsmenu_lev2()
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
	local rompath = AF.emulatordata[emulatorname].rompath
	local gamepath = fe.game_info(Info.Name)
	local romextarray = []

	foreach (i, item in AF.emulatordata[emulatorname].romextarray){
		print ("Deleting " + gamepath + item + "\n")
		try {
			system ("mkdir " + ap + rompath + "deleted" + ap)
		} catch(err){}

		if (item == ".m3u"){
			local readm3u = ReadTextFile(rompath+gamepath+item)
			while (!readm3u.eos()){
				local inm3uline = readm3u.read_line()
				local frompath = ap + rompath + inm3uline + ap
				local topath = ap + rompath + "deleted/" + inm3uline + ap
				try {
					system (OS == "Windows" ?
						"move " + char_replace(frompath,"/","\\") + " " + char_replace(topath,"/","\\") :
						"mv " + frompath + " " + topath )
				}catch(err){}
			}
		}

		try{
			system (OS == "Windows" ?
			"move "+ ap + char_replace(rompath,"/","\\") + "\\"+gamepath + item + ap + " " + ap + char_replace(rompath,"/","\\") + "\\deleted\\" +gamepath + item + ap :
			"mv " + ap + rompath + gamepath + item + ap + " " + ap + rompath + "deleted/" +gamepath + item + ap )
		} catch (err) {print ("skipped\n")}
	}

	z_list.gametable[z_list.index].z_fileisavailable = 0
	//saveromdb (z_list.gametable[z_list.index].z_emulator,z_list.db1[z_list.gametable[z_list.index].z_emulator],"db1")
	z_listrefreshtiles()

}

function buildgamelistxml(){

	local romlist = fe.displays[fe.list.display_index].romlist
	local rompath = AF.emulatordata[romlist].rompath
	local xmlpath = AF.emulatordata[romlist].rompath+"gamelist.xml"
	local extarray = AF.emulatordata[romlist].romextarray
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
		outputfile.write_line("    <desc>")
		foreach (i, val in z_list.gametable[index].z_description)
			outputfile.write_line(val+"\n")
		outputfile.write_line("</desc>\n")
		outputfile.write_line("    <image>"+"./"+AF.emulatordata[romlist].artworktable.snap.slice(AF.emulatordata[romlist].artworktable.snap.find(rompath)+rompath.len())+z_list.gametable[index].z_name+".png"+"</image>\n")
		outputfile.write_line("    <marquee>"+"./"+AF.emulatordata[romlist].artworktable.wheel.slice(AF.emulatordata[romlist].artworktable.wheel.find(rompath)+rompath.len())+z_list.gametable[index].z_name+".png"+"</marquee>\n")
		outputfile.write_line("    <thumbnail>"+"./"+AF.emulatordata[romlist].artworktable.flyer.slice(AF.emulatordata[romlist].artworktable.flyer.find(rompath)+rompath.len())+z_list.gametable[index].z_name+".png"+"</thumbnail>\n")
		outputfile.write_line("    <video>"+"./"+AF.emulatordata[romlist].artworktable.video.slice(AF.emulatordata[romlist].artworktable.video.find(rompath)+rompath.len())+z_list.gametable[index].z_name+".mp4"+"</video>\n")
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
	outputfile.close_file()
}

function parsevolume(op){
	local out = 0
	local out2 = ""
	if (OS == "OSX") {
		out = round((split(op,":,")[1].tofloat()*0.1),1).tointeger()
		AF.soundvolume = out
	}
	else if (OS == "Windows") {
		if (op.find("Master volume level") != null) 	{
			out = op
			out = split (out," ")
			out = out[out.len()-1]
			AF.soundvolume = round(out.tofloat()*0.1,1).tointeger()
		}
	}
	else {
		if (op.find ("Front Left: Playback") != null){
			out = op
			out = split (out,"[%")
			out = out[1]
			AF.soundvolume = round(out.tofloat()*0.1,1).tointeger()
		}
	}
}

/// RetroArch Functions ///

// ra_init initialise the ra table with data regarding RA and cores
local ra = {}
function ra_init(){

	ra.todolist <- {}

	if (OS == "Windows"){
		if (file_exist(fe.path_expand("C:\\RetroArch-Win64\\retroarch.exe"))) {
			ra.basepath <- fe.path_expand("C:\\RetroArch-Win64\\")
		}
		else if (file_exist(fe.path_expand("C:\\RetroArch-Win32\\retroarch.exe"))) {
			ra.basepath <- fe.path_expand("C:\\RetroArch-Win32\\")
		}
		else ra.basepath <- ""

		ra.binpath <- fe.path_expand(ra.basepath+"retroarch.exe")
		ra.corepath <- fe.path_expand(ra.basepath+"cores\\")
		ra.infopath <- fe.path_expand(ra.basepath+"info\\")
	}
	else if (OS == "OSX"){
		ra.binpath <- fe.path_expand("/Applications/RetroArch.app/Contents/MacOS/RetroArch")
		ra.basepath <- fe.path_expand("$HOME/Library/Application Support/RetroArch/")
		ra.corepath <- fe.path_expand(ra.basepath+"cores/")
		ra.infopath <- fe.path_expand(ra.basepath+"info/")
	}
	else {
		ra.binpath <- fe.path_expand("retroarch")
		ra.basepath <- fe.path_expand("$HOME/.config/retroarch/")
		ra.corepath <- fe.path_expand(ra.basepath+"cores/")
		ra.infopath <- fe.path_expand(ra.basepath+"cores/")
	}

	if (prf.RAEXEPATH != "") ra.binpath = fe.path_expand(prf.RAEXEPATH)
	if (prf.RACOREPATH != "") ra.corepath = fe.path_expand(prf.RACOREPATH)
	if (prf.RAINFOPATH != "") ra.infopath = fe.path_expand(prf.RAINFOPATH)

	ra.corelist <- []
	ra.coretable <- {}
	local dirlist = DirectoryListing (ra.corepath,false).results
	foreach (i,item in dirlist){
		if ((item.find("_libretro") != null) && (item.find(".info") == null)) {
			ra.coretable.rawset(item.slice(0,item.find("_libretro")),{})
			ra.corelist.push(item.slice(0,item.find("_libretro")))
		}
	}
	local coreinfofile = null
	local stringline = "#"
	foreach (i,item in ra.corelist){
		stringline = "#"
		coreinfofile = ReadTextFile (fe.path_expand(ra.infopath+item+"_libretro.info"))

		while (stringline[0].tochar() == "#"){
			stringline = coreinfofile.read_line()
		}
		ra.coretable[item].rawset("shortname",item)
		ra.coretable[item].rawset("displayname",stringline.slice(stringline.find(ap)+1,-1))
	}

	ra.corelist.sort(@(a,b) ra.coretable[a].displayname <=> ra.coretable[b].displayname)

}

if (prf.RAENABLED) ra_init()

function ra_updatecfg(emulator,core){
	local filearray = []
	local emufile = ReadTextFile(FeConfigDirectory+"emulators/"+emulator+".cfg")
	while (!emufile.eos()){
		filearray.push (emufile.read_line())
	}
	foreach (i, item in filearray){
		if (item.find("executable") == 0) {
			filearray[i] = "executable           " + ra.binpath
		}
		else if (item.find("args") == 0) {
			filearray[i] = "args                 -L " + core + " "+ap+"[romfilename]"+ap
		}
	}
	local emuoutfile = WriteTextFile(FeConfigDirectory+"emulators/"+emulator+".cfg")
	foreach (i, item in filearray){
		emuoutfile.write_line(item+"\n")
	}
	emuoutfile.close_file()
}

function ra_applychanges(){
	local emuarray = []
	local corearray = []
	local menuarray = []
	local glypharray = []
	foreach (item, val in ra.todolist){
		emuarray.push(item)
		corearray.push(val)
		menuarray.push (item+": "+val)
		glypharray.push(0)
	}
	if (emuarray.len() == 0) {
		frosthide()
		zmenuhide()
	} else {
		menuarray.insert(0,"")
		menuarray.insert(0,ltxt("Discard changes",AF.LNG))
		menuarray.insert(0,ltxt("Apply changes",AF.LNG))

		glypharray.insert(0,-1)
		glypharray.insert(0,0xea0f)
		glypharray.insert(0,0xea10)

		zmenudraw(menuarray,glypharray,null,ltxt("Assigned cores",AF.LNG),0xeafa,0,false,false,false,false,false,
		function (result){
			if ((result == -1) || (result == 1)) {
				ra.todolist = {}
				frosthide()
				zmenuhide()
			}
			else if (result == 0) {
				foreach (i, item in emuarray){
					ra_updatecfg(emuarray[i],corearray[i])
				}
				frosthide()
				zmenuhide()
				restartAM()
			}
		})
	}
}

function ra_selectcore(startemu){
	local oldcore = AF.emulatordata[startemu].racore
	local newcore = ra.todolist.rawin(startemu) ? ra.todolist[startemu] : ""

	local startpos = newcore == "" ? ra.corelist.find(oldcore) : ra.corelist.find(newcore)
	if (startpos == null) startpos = 0

	local coremenulist = []
	local coreglyphs = []
	foreach (i, item in ra.corelist){
		coremenulist.push(ra.coretable[item].displayname)
		if ((oldcore == newcore) || (newcore == "")){
			coreglyphs.push (i == ra.corelist.find(oldcore) ? 0xea10 : 0)
		}
		else {
			coreglyphs.push (i == ra.corelist.find(oldcore) ? 0xea11 : (ra.corelist.find(newcore) == i ? 0xea10 : 0))
		}
	}
	frostshow()
	zmenudraw(coremenulist,coreglyphs,null,ltxt("Select core",AF.LNG),0xeafa,startpos,false,false,false,false,false,
	function (result){
		if (result == -1) {
			ra_selectemu(startemu)
		} else {
			if (oldcore != ra.corelist[result]) ra.todolist.rawset(startemu,ra.corelist[result])
			else ra.todolist.rawdelete(startemu)
			//OLD VERSION: ra_selectemu(startemu)
			ra_selectcore(startemu)
		}
	})
}

function ra_selectemu(startemu){

	local startpos = 0
	local currentemu = startemu

	local emulist = []
	local corelist = []
	local todoglyph = []
	foreach (item, val in AF.emulatordata){
		emulist.push (item)
	}

	emulist.sort()
	startpos = emulist.find(currentemu)

	foreach (i, val in emulist){
		corelist.push (((AF.emulatordata[val].racore == "") && (!ra.todolist.rawin(val))) ? "" : "("+ (ra.todolist.rawin(val) ? ra.todolist[val]: AF.emulatordata[val].racore) +")")
		todoglyph.push ((ra.todolist.rawin(val) ) ? 0xe905 : 0)
	}

	frostshow()
	zmenudraw(emulist,todoglyph,corelist,ltxt("Select emulator",AF.LNG),0xeafa,startpos,false,false,false,false,false,
	function (result){
		if (result == -1){
			ra_applychanges()
		}
		else {
			if (AF.emulatordata[emulist[result]].racore == "") {
				zmenudraw(ltxtarray(["Yes","No"],AF.LNG),[0xea10,0xea0f],null,ltxt("Apply RA core",AF.LNG)+"?",0xeafa,0,false,false,true,false,false,
				function (result2){
					if (result2 == 0) ra_selectcore(emulist[result])
					else if (result2 == 1) {
						ra.todolist.rawdelete(emulist[result])
						ra_selectemu(startemu)
					}
					else ra_selectemu(startemu)
				})
			}
			else ra_selectcore(emulist[result])

		}
	})
}

/// On Signal ///
function on_signal( sig ){
	debugpr ("\n Si:" + sig )

	//TEST150
	if (sig == "custom1"){
		//afinstall("14.6","Arcadeflow_TEST")
		fe.plugin_command("curl","-L -s https://api.github.com/repos/zpaolo11x/Arcadeflow/branches","gh_branchlist")
		fe.plugin_command("curl","-L -s https://api.github.com/repos/zpaolo11x/Arcadeflow/tags","gh_taglist")

	}

	if ((sig == "back") && (zmenu.showing) && (prf.THEMEAUDIO)) snd.mbacksound.playing = true
	if ((((sig == "up") && checkrepeat(count.up))|| ((sig == "down") && checkrepeat(count.down))) && (zmenu.showing) && (prf.THEMEAUDIO)) snd.mplinsound.playing = true

	if (AF.scrape.purgedromdirlist != null) {
		if (sig == "back") {
			AF.scrape.quit = true
		}
		return true
	}

	if ((AF.scrape.purgedromdirlist == null) && (AF.messageoverlay.visible == true)) {
		if (sig == "back") {
			AF.messageoverlay.visible = false
			//TEST120 THIS MUST BE 1 OR 2 DEPENDING ON THE MENU SHOWN!
			if (prfmenu.showing) fe.signal("back")
			fe.signal("back")
			//fe.signal("back")
			//fe.signal("back")

			// This reloads the romlist without reloading the layout, but if the other display is not AF it can cause issues
			local ifplus = modwrap(fe.list.display_index + 1, fe.displays.len())
			local ifminus = modwrap(fe.list.display_index - 1, fe.displays.len())

			try{
				fe.set_display(fe.list.display_index,false,false) //TEST139
			}catch(err){

			//OLD METHOD BEFORE THE NEW SET_DISPLAY
				if (fe.displays[ifplus].layout.tolower().find("arcadeflow") != null){
					fe.signal("next_display")
					fe.signal("prev_display")
				}
				else if (fe.displays[ifminus].layout.tolower().find("arcadeflow") != null){
					fe.signal("prev_display")
					fe.signal("next_display")
				}
				else fe.signal("reload")
			}


			// Alternative method, reloads the whole layout
			// fe.set_display(fe.list.display_index)

			//Third method, with or without getallgamesdb(), doesn't update correctly the artwork
			/*
			getallgamesdb()
			*/
			/*
			z_listboot()
			buildcategorytable()
			mfz_build(true)
			try {
				mfz_load()
				mfz_populatereverse()
				} catch(err){}
			mfz_apply(true)
			*/
		}

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
			if (checkrepeat(count.left)){
				AF.messageoverlay.first_line_hint-=10
				count.left ++
				return true
			}
			else return true
		}

		else if (sig == "right") {
			if (checkrepeat(count.right)){
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

	if (sig == prf.DELETEBUTTON){
		deletecurrentrom()
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

	if ((sig == prf.FAVBUTTON)&& !zmenu.showing ){
		favtoggle()
		return true
	}

	if ((sig == prf.VOLUMEBUTTON) && !zmenu.showing){
		local currvol = 0
		if (OS == "OSX") fe.plugin_command ("osascript", "-e "+ap+"get volume settings "+ap, "parsevolume")
		else if (OS == "Windows") fe.plugin_command (char_replace(AF.folder,"/","\\") + "\\SetVol.exe", "report", "parsevolume")
		else fe.plugin_command ("amixer","get Master","parsevolume")


		local volarray = []
		for (local i = 0; i <=10 ; i++){
			volarray.push (textrate(10-i,10,40,"Ⓞ ","Ⓟ "))
		}
		local amparray = [0xea26,0xea26,0xea26,0xea27,0xea27,0xea27,0xea28,0xea28,0xea28,0xea29,0xea2a]
		frostshow()
		zmenudraw(volarray,amparray,null,"Volume",0xea26,10 - AF.soundvolume,false,false,true,true,true,
			function(out){
				if (out != -1){
					AF.soundvolume = 10 - out
					if (OS == "OSX") system ("osascript -e "+ap+"Set Volume "+(0.7*AF.soundvolume)+ap)
					else if (OS == "Windows") system (ap+char_replace(AF.folder,"/","\\") + "\\SetVol.exe"+ap+" "+AF.soundvolume*10+" unmute")
					else system ("amixer set Master "+AF.soundvolume*10+"%")
				}
				zmenuhide()
				frosthide()
			}
			function(){
				if (checkrepeat (count.left)){
					zmenunavigate_down("left")
				}
			}
			function(){
				if (checkrepeat (count.right)){
					zmenunavigate_up("right")
				}
			}
		)
	}

	if (sig == prf.CATEGORYBUTTON){
		if (zmenu.sim) return true
		if (history_visible()) return true
		if (prfmenu.showing || zmenu.dmp) return true
		if (keyboard_visible()) return true

		categorymenu()
	}

	if (sig == prf.MULTIFILTERBUTTON){
		if (zmenu.sim) return true
		if (history_visible()) return true
		if (prfmenu.showing || zmenu.dmp) return true
		if (keyboard_visible()) return true

		zmenu.mfm = true
		frostshow()
		mfmbgshow()
		mfz_menu0(0)
	}

	if (sig == prf.SEARCHBUTTON){
		if (zmenu.sim) return true
		if (history_visible()) return true
		if (prfmenu.showing || zmenu.dmp) return true

		new_search()
	}

	if (sig == "filters_menu"){

		if (fe.filters.len() == 0) return true //Don't open menu if no filters are available

		if (zmenu.sim) return true
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
		zmenudraw (filterarray,filterglyphs,filternotes,ltxt("FILTERS",AF.LNG),0xea5b,(fe.filters.len() != 0 ? fe.list.filter_index : 0 ),false,false,false,false,false,
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

		if (sig == "up") {
			if (checkrepeat(count.up)){
				zmenunavigate_up("up")
			}
			else return true
		}

		if (sig == "down") {
			if (checkrepeat (count.down)){
				zmenunavigate_down("down")
			}
			else return true
		}

		if (sig == "left") {
			if (checkrepeat(count.left)){
				if (zmenu.reactleft == null) {
					zmenu.selected = count.skipup
					zmenu.sidelabel.msg = zmenu.notes[zmenu.selected]
				}
				else zmenu.reactleft()
				count.left ++
			}
		}

		if (sig == "right") {
			if (checkrepeat(count.right)){
				if (zmenu.reactright != null) zmenu.reactright()
				count.right ++
			}
		}

		if ((sig == "up") || (sig == "down") || (sig == "left") || (sig == "right")) {

			if ((prf.DMPIMAGES != null) && zmenu.dmp) {
				disp.xstop = -disp.noskip[zmenu.selected] * disp.spacing
				//disp.bgshadowt.visible = disp.bgshadowb.visible = !(disp.images[zmenu.selected].file_name == "")
			}
			if ((prfmenu.showing) && (!prfmenu.rgbshowing))	{
				updatemenu(prfmenu.level,zmenu.selected)
      		prfmenu.description.msg =  (prfmenu.level == 1 ? AF.prefs.l0[zmenu.selected].description : (AF.prefs.l1[prfmenu.outres0][(prfmenu.level == 2 ? zmenu.selected : prfmenu.outres1)].help))
			}

			if (zmenu.sim && (sig != "right")){
				//try(prfmenu.description.msg = zmenu.similar[zmenu.selected].data.z_description[0])catch(err){prfmenu.description.msg = ""}
				zmenu.simtxt.msg = zmenu.similar[zmenu.selected].gamenotes
				zmenu.simsys.msg = zmenu.similar[zmenu.selected].syslogo
				updatesimpic(zmenu.selected)
				//z_list_indexchange (zmenu.similar[zmenu.selected].index)
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
				if (!zmenu.singleline){
					zmenu.items[i].set_rgb (255,255,255)
					zmenu.noteitems[i].set_rgb (255,255,255)
					zmenu.glyphs[i].set_rgb (255,255,255)
				}
				else {
					zmenu.items[i].set_rgb (0,0,0)
					zmenu.noteitems[i].set_rgb (0,0,0)
					zmenu.glyphs[i].set_rgb (0,0,0)
				}
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
			zmenudraw (ltxtarray(prf.POWERMENU ? ["Yes","No","Power","Shutdown","Restart","Sleep"]:["Yes","No"],AF.LNG),prf.POWERMENU ? [0xea10,0xea0f,-1,0xe9b6,0xe984,0xeaf6]:[0xea10,0xea0f],null,ltxt("EXIT ARCADEFLOW?",AF.LNG),0xe9b6,1,false,false,true,false,false,
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
		if (zmenu.sim) return true
		if (history_visible()) return true
		if (zmenu.dmp) zmenu.dmp = false
		if (keyboard_visible()) return true


		frostshow()
		optionsmenu_boot() // This is the final part where custom code to manage the signal can be added.

		return true
	}

	if (sig == "add_favourite"){
		// Switch faved and non faved for current game
		z_list.gametable2[z_list.index].z_favourite = !z_list.gametable2[z_list.index].z_favourite

		// If the new game has been set to favourite, update the favdate
		if (z_list.gametable2[z_list.index].z_favourite){
			local datetab = date()
			local datestr = datetab.year * 10000000000 + datetab.month * 100000000 + datetab.day * 1000000+datetab.hour*10000+datetab.min*100 + datetab.sec
			datestr = datestr.tostring()
			z_list.gametable2[z_list.index].z_favdate = datestr
		}

		// Save rhe rom database with new data
		saveromdb (z_list.gametable[z_list.index].z_emulator,z_list.db2[z_list.gametable[z_list.index].z_emulator],"db2")

		// Upgrade the mfz_fields and refresh the mfz filter results
		mfz_build(true)
		try {
			mfz_load()
			mfz_populatereverse()
		} catch(err){}
		mfz_apply(false)

		return true
	}

	if (sig == "displays_menu"){
		if (!prf.DMPENABLED) return false

		if (zmenu.sim) return true
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
		if (zmenu.sim) return true
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



			zmenudraw (ltxtarray(["More of the same...","Similar Games","Scrape selected game","Edit metadata","CAUTION!","Delete ROM"],AF.LNG),[0xe987,0xeaf7,0xe9c2,0xe906,-1,0xe9ac],["","","","","",prf.ENABLEDELETE?"":ltxt("Disabled",AF.LNG)], ltxt("Game Menu",AF.LNG),0xe916,0,false,false,false,false,false,
			function (result){
				if (result == 0) {
					local taglist = z_list.gametable2[z_list.index].z_tags
					local switcharray = []
					local switchnotes = []
					switcharray.push(ltxt("Year",AF.LNG))
					switcharray.push(ltxt("Decade",AF.LNG))
					switcharray.push(ltxt("Manufacturer",AF.LNG))
					switcharray.push(ltxt("Main Category",AF.LNG))
					switcharray.push(ltxt("Sub Category",AF.LNG))
					switcharray.push(ltxt("Orientation",AF.LNG))
					switcharray.push(ltxt("Favourite state",AF.LNG))
					switcharray.push(ltxt("Series",AF.LNG))
					switcharray.push(ltxt("Rating",AF.LNG))
					switcharray.push(ltxt("Arcade System",AF.LNG))

					switchnotes.push( z_list.gametable[z_list.index].z_year)
					switchnotes.push( (z_list.gametable[z_list.index].z_year.len() > 3 ? z_list.gametable[z_list.index].z_year.slice(0,3) : "")+"x")
					switchnotes.push( z_list.gametable[z_list.index].z_manufacturer )
					try {
						switchnotes.push( split(z_list.gametable[z_list.index].z_category,"/")[0] )
					}
					catch (err){
						switchnotes.push("?")
					}
					switchnotes.push( z_list.gametable[z_list.index].z_category )
					switchnotes.push( z_list.gametable[z_list.index].z_rotation )
					switchnotes.push( (z_list.gametable2[z_list.index].z_favourite ? ltxt("Yes",AF.LNG) : ltxt("No",AF.LNG) ))
					switchnotes.push( z_list.gametable[z_list.index].z_series )
					switchnotes.push( z_list.gametable[z_list.index].z_rating )
					switchnotes.push( z_list.gametable[z_list.index].z_arcadesystem )

					local numset = switcharray.len()

					switcharray.extend( taglist.map (function(value){ return ("🏷 "+value)}) )
					foreach(i, item in switcharray) switchnotes.push ("")

					local numtag = switcharray.len()
					//switcharray.push (ltxt("RESET (KEEP FOCUS)",AF.LNG))
					switcharray.push (ltxt("RESET",AF.LNG))

					frostshow()
					zmenudraw (switcharray,null,switchnotes, "  " + ltxt("More of the same",AF.LNG)+"...",0xe987,0,false,false,false,false,false,
					function(result){
						if(result==numtag){
							search.mots2string = ""
							search.mots = ["",""]
							updatesearchdatamsg()
							mfz_apply(false)
						}

						if (result == -1) {
							frosthide()
							zmenuhide()
						}

						if (result == 0) {
							search.mots = ["z_year", z_list.gametable[z_list.index].z_year]
							search.mots2string = ltxt("Year",AF.LNG)+":"+search.mots[1]
						}

						if (result == 1) {
							search.mots = ["z_year", z_list.gametable[z_list.index].z_year.slice(0,3)]
							search.mots2string = ltxt("Year",AF.LNG)+":"+search.mots[1]+"x"

						}

						if (result == 2) {
							search.mots = ["z_manufacturer", z_list.gametable[z_list.index].z_manufacturer]
							search.mots2string = ltxt("Manufacturer",AF.LNG)+":"+search.mots[1]
						}

						if (result == 3) {
							try {
								local s = z_list.gametable[z_list.index].z_category
								local s2 = split( s, "/" )
								search.mots = ["z_category", cleancat(s2[0])]
								search.mots2string = ltxt("Category",AF.LNG)+":"+s2[0]
							}
							catch(err){}
						}

						if (result == 4) {
							search.mots = ["z_category", z_list.gametable[z_list.index].z_category]
							search.mots2string = ltxt("Category",AF.LNG)+":"+search.mots[1]

						}

						if (result == 5) {
							search.mots = ["z_rotation", z_list.gametable[z_list.index].z_rotation]
							search.mots2string = ltxt("Rotation",AF.LNG)+":"+search.mots[1]
						}

						if (result == 6) {
							search.mots = ["z_favourite", z_list.gametable2[z_list.index].z_favourite.tostring()]
							search.mots2string = ltxt("Favourite",AF.LNG)+":"+(search.mots[1])
						}

						if (result == 7) {
							search.mots = ["z_series", z_list.gametable[z_list.index].z_series]
							search.mots2string = ltxt("Series",AF.LNG)+":"+search.mots[1]
						}

						if (result == 8) {
							search.mots = ["z_rating", z_list.gametable[z_list.index].z_rating]
							search.mots2string = ltxt("Rating",AF.LNG)+":"+search.mots[1]
						}

						if (result == 9) {
							search.mots = ["z_arcadesystem", z_list.gametable[z_list.index].z_arcadesystem]
							search.mots2string = ltxt("Arcade Sys",AF.LNG)+":"+search.mots[1]
						}

						if ((result >= numset) && (result < numtag)) {
							search.mots = ["z_tags", taglist[result - numset]]
							search.mots2string = ltxt("Tags",AF.LNG)+":"+search.mots[1]
						}

						// GOOD
						if ((result != numtag) && (result != -1) && (search.mots[1] != "")) {

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
				if (result == 1) { //similar games menu
					similarmenu()
				}
				if (result == 2) { // Scrape current game
					local tempprf = generateprefstable()
					scraperomlist2(tempprf,tempprf.MEDIASCRAPE,true)
				}
				if (result == 3){ // Edit metadata
					metamenu(0)
				}
				if (result == 5){ // Delete ROM
					zmenudraw (ltxtarray(["Delete","Cancel"],AF.LNG),[0xea10,0xea0f],null,"Delete "+fe.game_info(Info.Name)+"?",0xe9ac,1,false,false,true,false,false,
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
					af_on_scroll_up()
					count.up ++
					return true
				}
				else return true
			}

			else if (sig == "down") {
				if (checkrepeat(count.down)){
					af_on_scroll_down()
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
					if (z_list.gametable[z_list.index].z_system == "") {
						debugpr("No system defined, is this a display link?\n")
						return false
					}
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

					if (!data_surface.redraw) data_freeze(false)

					if ((z_list.index % UI.rows > 0) && (scroll.jump == false) && (scroll.sortjump == false)) {
						z_list_indexchange (z_list.index -1)
						if(prf.THEMEAUDIO) snd.plingsound.playing = true
					}
					else if (scroll.jump == true){
						if(prf.THEMEAUDIO) snd.wooshsound.playing = true
						tilesTableZoom[focusindex.new] = startfade (tilesTableZoom[focusindex.new],0.035,-5.0)

						scroll.jump = false
						scroll.step = UI.rows
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

					if (!data_surface.redraw) data_freeze(false)

					if ((scroll.jump == false) && (scroll.sortjump == false) && ((z_list.index % UI.rows < UI.rows -1) && ( ! ( (z_list.index / UI.rows == z_list.size / UI.rows)&&(z_list.index%UI.rows + 1 > (z_list.size -1)%UI.rows) ))) ){
						if ((corrector == 0) && (z_list.index == z_list.size-1)) return true
						z_list_indexchange (z_list.index + 1)
						if(prf.THEMEAUDIO) snd.plingsound.playing = true
					}

					// if you go down and label list is not active, activate scroll.jump
					else if ((scroll.jump == false) && (scroll.sortjump == false) && (prf.SCROLLERTYPE != "labellist")){
						if(prf.THEMEAUDIO) snd.wooshsound.playing = true

						tilesTableZoom[focusindex.new] = startfade (tilesTableZoom[focusindex.new],-0.035,-5.0)

						scroll.jump = true
						scroll.step = UI.rows*(UI.cols-2)
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