local affolder = fe.script_dir

function file_exist(fullpathfilename){
	try {file(fullpathfilename, "r" );return true;}catch(e){return false;}
}
function file_exist_folder(fullpathfilename){
	try {file(fullpathfilename, "a" );return true;}catch(e){return false;}
}

local manufvector = ["","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""]
local manufinc = 0
local manufdata = {}
local manufpath = fe.path_expand( affolder+"data_manufacturers.txt")

local manufile = ReadTextFile( manufpath)
local arrayline = ""
local instr = ""
local vector = []
local datasplit = []
local datemin = 0
local datemax = 0
local namestr = ""

local multilogo = 0
local logoserie = ""

while ( !manufile.eos() ) {
   datemin = 0
   datemax = 10000
   instr = strip(manufile.read_line())
   datasplit = split(instr,"|")

   if (datasplit.len()>1){
      multilogo = multilogo + 1
      datemin = split(datasplit[1],",")[0].tointeger()
      datemax = split(datasplit[1],",")[1].tointeger()
   } else multilogo = 0

   vector = split(datasplit[0]," ")
   foreach (i, item in vector){
      if(!manufdata.rawin(item)) manufdata.rawset(item,[])

      manufdata[item].push({
         logo = manufinc
         dmin = datemin
         dmax = datemax
      })

      if (multilogo>0){
         logoserie = item + "_" + multilogo
         if(!manufdata.rawin(logoserie)) manufdata.rawset(logoserie,[])
         manufdata[logoserie].push({
            logo = manufinc
            dmin = 0
            dmax = 10000
         })
      }
   }
   manufinc++
}
function print_variable(variablein,level,name){
	if (level == "") print ("* "+name+" *\n")
	level = level+"   "
	foreach (item, val in variablein){
		print (level+" "+(typeof val)+" "+item+" "+val+"\n")
		if ((typeof val == "table")||(typeof val == "array")) print_variable(val,level,"")
	}
}

function manufacturer_parser(inputstring){
   local s = inputstring
   local s2 = split( s, "*%/: .()-,<>?&'+’!・~·" )
	local sout = ""

	if ( s2.len() > 1 ) {
		for (local i=0;i<s2.len();i++){
		if (s2[i] != "license") sout = sout + s2[i]
		}
		sout = sout.tolower()
	}
   else if (s2.len() == 1) sout = strip(s2[0]).tolower()
	else sout = strip(s).tolower()
   return (sout)
}

function manufacturer_vec(s){
   local sout = manufacturer_parser (s)

   local valueout = ""
   try {
      valueout = manufvector[manufdata[sout]]
   }
   catch (err){
      valueout = ""
   }

	return  ( (sout == "") ? "" : valueout)
}

// USED ONE
function manufacturer_vec_name(name,year){
   local s = name
   if ((year!="") && (year!="?")) year = year.tointeger() else year = 1990 //ARBITRARY!

   local sout = manufacturer_parser (s)

   local valueout = ""
   if(manufdata.rawin(sout)){
      foreach (item, val in manufdata[sout]){
         if ((year >= val.dmin) && (year <= val.dmax)) {
            valueout = manufvector[val.logo]
            break
         }
      }
   }

	return  ( (sout == "") ? "" : valueout)
}

local controllertable = {
   "joystick (8-way)" : "control_joystick_8way.png",
   "joystick (8-way),joystick (8-way)" : "control_joystick_8way.png",
   "joystick (8-way),joystick (8-way),joystick (8-way)" : "control_joystick_8way.png",
   "joystick (8-way),joystick (8-way),joystick (8-way),joystick (8-way)" : "control_joystick_8way.png",
   "8-way Joystick" : "control_joystick_8way.png",
   "Joystick 8 ways" : "control_joystick_8way.png",
   "8-way Top-Fire Joystick" : "control_joystick_8way.png",
   "8-way Triggerstick" : "control_joystick_8way.png",

   "joystick (8-way),dial" : "control_joystick_8way.png",
   "joystick (8-way),dial,joystick (8-way),dial" : "control_joystick_8way.png",
   "joystick (8-way),dial,joystick (8-way),dial,joystick (8-way),dial" : "control_joystick_8way.png",
   "joystick (8-way),dial,joystick (8-way),dial,joystick (8-way),joystick (8-way)" : "control_joystick_8way.png",
   "Joystick 8 ways, Dial" : "control_joystick_8way.png",

   "joystick (8-way),paddle,joystick (8-way)" : "control_joystick_8way.png",
   "joystick (8-way),paddle" : "control_joystick_8way.png",
   "joystick (8-way),paddle,joystick (8-way),paddle" : "control_joystick_8way.png",
   "joystick (8-way),paddle,joystick (8-way),paddle,joystick (8-way),paddle" : "control_joystick_8way.png",

   "joystick (8-way),joystick (analog)" : "control_joystick_8analog.png",
   "joystick (8-way),joystick (analog),joystick (8-way),joystick (analog)" : "control_joystick_8analog.png",
   "joystick (2-way),joystick (analog)" : "control_joystick_2analog.png",

   "joystick (8-way),trackball" : "control_joystick_8trackball.png",
   "joystick (8-way),trackball,joystick (8-way),trackball" : "control_joystick_8trackball.png",

   "joystick (8-way),positional" : "control_joystick_8way.png",
   "joystick (8-way),positional,joystick (8-way),positional" : "control_joystick_8way.png",
   "joystick (8-way),positional,joystick (8-way),positional,joystick (8-way),positional" : "control_joystick_8way.png",
   "joystick (8-way),positional,joystick (8-way),positional,joystick (8-way)positional,joystick (8-way)positional" : "control_joystick_8way.png",
   "joystick (5 (half8)-way),joystick (5 (half8)-way)" : "control_joystick_8way.png",
   "joystick (5 (half8)-way)" : "control_joystick_8way.png",
   "Joystick 8 ways, Positional" : "control_joystick_8way.png",

   "joystick (4-way)" : "control_joystick_4way.png",
   "joystick (4-way),joystick (4-way)" : "control_joystick_4way.png",
   "joystick (4-way),joystick (4-way),joystick (4-way),joystick (4-way)" : "control_joystick_4way.png",
   "joystick (3 (half4)-way),joystick (3 (half4)-way)" : "control_joystick_4way.png",
   "joystick (3 (half4)-way)" : "control_joystick_4way.png",
   "4-way Joystick" : "control_joystick_4way.png",
   "Joystick 4 ways" : "control_joystick_4way.png",

   "joystick (2-way)" : "control_joystick_2way.png",
   "joystick (vertical2-way)" : "control_joystick_2way.png",
   "joystick (2-way),joystick (2-way)" : "control_joystick_2way.png",
   "joystick (2-way),joystick (2-way),joystick (2-way),joystick (2-way)" : "control_joystick_2way.png",
   "2-way Joystick (Horizontal)" : "control_joystick_2way.png",
   "2-way Joystick (Vertical)" : "control_joystick_2way.png",
   "Joystick 2 ways (horizontal)" : "control_joystick_2way.png",
   "Joystick 2 ways (vertical)" : "control_joystick_2way.png",

   "paddle,pedal" : "control_paddle_pedal.png",
   "paddle,pedal,paddle,pedal" : "control_paddle_pedal.png",
   "Paddle, Pedal" : "control_paddle_pedal.png",

   "dial,pedal" : "control_paddle_pedal.png",
   "dial,pedal,dial,pedal" : "control_paddle_pedal.png",
   "dial,pedal,dial,pedal,dial,pedal" : "control_paddle_pedal.png",
   "dial,pedal,dial,pedal,dial,pedal,dial,pedal" : "control_paddle_pedal.png",

   "dial,paddle,pedal" : "control_paddle_pedal.png",

   "joystick (analog)" : "control_joystick_analog.png",
   "joystick (analog),joystick (analog)" : "control_joystick_analog.png",
   "Analog Stick" : "control_joystick_analog.png",

   "trackball" : "control_trackball.png",
   "trackball,trackball" : "control_trackball.png",
   "trackball,trackball,trackball" : "control_trackball.png",
   "Trackball" : "control_trackball.png",

   "paddle" : "control_paddle.png",
   "paddle,paddle" : "control_paddle.png",

   "dial" : "control_paddle.png",
   "dial,dial" : "control_paddle.png",

   "only_buttons" : "control_buttons.png",
   "only_buttons,only_buttons" : "control_buttons.png",
   "only_buttons,only_buttons,only_buttons,only_buttons" : "control_buttons.png",
   "Buttons only" : "control_buttons.png",
   "Just Buttons" : "control_buttons.png",

   "double joystick" : "control_double_joystick.png",
   "double joystick,double joystick" : "control_double_joystick.png",
   "Dual 8-way Joysticks" : "control_double_joystick.png",

   "lightgun" : "control_lightgun.png",
   "lightgun,lightgun" : "control_lightgun.png",
   "Analog Gun" : "control_lightgun.png",
   "Lightgun" : "control_lightgun.png",
}

function controller_pic(s){
   //local s = fe.game_info( Info.Control, offset )
  // print (s+"\n\n")
   try {
      return (controllertable[s])
   }
   catch ( err ) {
      return ("control_.png")
   }
}


local gIDT = {}
   gIDT[0x0000] <- "None" //  No genre
   gIDT[0x0100] <- "Action" //  Generic Action games
   gIDT[0x0101] <- "Action / Platformer" //  - Action platform game
   gIDT[0x0102] <- "Action / Platform Shooter" //  - Action platform shooter (Turrican, ...)
   gIDT[0x0103] <- "Action / First Person Shooter" //  - First person shooter (007, ...)
   gIDT[0x0104] <- "Action / ShootEmUp" //  - Shoot'em up/all (
   gIDT[0x0105] <- "Action / Shoot With Gun" //  - On-screen shooters (Operation wolf, Duck Hunt, ...)
   gIDT[0x0106] <- "Action / Fighting" //  - Fighting games (mortal kombat, street fighters, ...)
   gIDT[0x0107] <- "Action / BeatEmUp" //  - Beat'em up/all (Renegade, Double Dragon, ...)
   gIDT[0x0108] <- "Action / Stealth" //  - Stealth combat (MGS, Dishonored, ...)
   gIDT[0x0109] <- "Action / Battle Royale" //  - Battle royale survivals (Fortnite, Apex legend, ...)
   gIDT[0x010A] <- "Action / Rythm" //  - Music/Rythm games (Dance Dance Revolution, ...)
   gIDT[0x0200] <- "Adventure" //  Generic Adventure games
   gIDT[0x0201] <- "Adventure / Text" //  - Old-school text adventure (Zork, ...)
   gIDT[0x0202] <- "Adventure / Graphics" //  - Mainly Point-and-clicks
   gIDT[0x0203] <- "Adventure / VisualNovels" //  - Dating & legal simulation (Ace Attornay, ...)
   gIDT[0x0204] <- "Adventure / Interactive Movie" //  - Interactive movies (Tex Murphy, Fahrenheit, RE4, ...)
   gIDT[0x0205] <- "Adventure / Real Time 3D" //  - 3D adventures (Shenmue, Heavy rain, ...)
   gIDT[0x0206] <- "Adventure / Survival Horror" //  - Survivals/Horror Survivals (Lost in blue, Resident evil, ...)
   gIDT[0x0300] <- "RPG" //  Generic RPG (Role Playing Games)
   gIDT[0x0301] <- "RPG / Action" //  - Action RPG (Diablo, ...)
   gIDT[0x0302] <- "RPG / MMO" //  - Massive Multiplayer Online RPG (TESO, WoW, ...)
   gIDT[0x0303] <- "RPG / Dungeon Crawler" //  - Dungeon Crawler (Dungeon Master, Eye of the beholder, ...)
   gIDT[0x0304] <- "RPG / Tactical" //  - Tactical RPG (Ogres Battle, FF Tactics, ...)
   gIDT[0x0305] <- "RPG / Japanese" //  - Japaneese RPG, manga-like (Chrono Trigger, FF, ...)
   gIDT[0x0306] <- "RPG / First Person Party Based" //  - Team-as-one RPG (Ishar, Bard's tales, ...)
   gIDT[0x0400] <- "Simulation" //  Generic simulation
   gIDT[0x0401] <- "Simulation / Build And Management" //  - Construction & Management simulations (Sim-city, ...)
   gIDT[0x0402] <- "Simulation / Life" //  - Life simulation (Nintendogs, Tamagoshi, Sims, ...)
   gIDT[0x0403] <- "Simulation / Fish And Hunt" //  - Fighing and hunting (Deer hunting, Sega bass fishing, ...)
   gIDT[0x0404] <- "Simulation / Vehicle" //  - Car/Planes/Tank/... simulations (Flight Simulator, Sherman M4, ...)
   gIDT[0x0405] <- "Simulation / SciFi" //  - Space Opera (Elite, Homeworld)
   gIDT[0x0500] <- "Strategy" //  Generic strategy games
   gIDT[0x0501] <- "Strategy / 4X" //  - eXplore, eXpand, eXploit, eXterminate (Civilization, ...)
   gIDT[0x0502] <- "Strategy / Artillery" //  - multiplayer artillery games, turn by turn (Scortched Tanks, Worms, ...)
   gIDT[0x0503] <- "Strategy / Auto Battler" //  - Auto-battle tacticals (Dota undergrounds, Heartstone Battlegrounds, ...)
   gIDT[0x0504] <- "Strategy / MOBA" //  - Multiplayer Online Battle Arena (Dota 2, Smite, ...)
   gIDT[0x0505] <- "Strategy / RTS" //  - Real Time Strategy (Warcrafs, Dune, C&C, ...)
   gIDT[0x0506] <- "Strategy / TBS" //  - Turn based strategy (Might & Magic, Making History, ...)
   gIDT[0x0507] <- "Strategy / Tower Defense" //  - Tower defenses!
   gIDT[0x0508] <- "Strategy / Wargame" //  - Military tactics
   gIDT[0x0600] <- "Sports" //  Generic sport games
   gIDT[0x0601] <- "Sport / Racing" //  - All racing games!
   gIDT[0x0602] <- "Sport / Simulation" //  - All physical/simulation sports
   gIDT[0x0603] <- "Sport / Competitive" //  - High competitive factor (Ball Jack, ...)
   gIDT[0x0604] <- "Sport / Fight" //  - Fighting sports/violent sports (SpeedBall, WWE 2K Fight Nights, ...)
   gIDT[0x0700] <- "Pinball" //  Pinball
   gIDT[0x0800] <- "Board" //  Board games (chess, backgammon, othello, ...)
   gIDT[0x0900] <- "Casual" //  Simple interaction games for casual gaming
   gIDT[0x0A00] <- "DigitalCard" //  Card Collection/games (Hearthstone, Magic the Gathering, ...)
   gIDT[0x0B00] <- "Puzzle And Logic" //  Puzzle and logic games (Tetris, Sokoban, ...)
   gIDT[0x0C00] <- "Party" //  Multiplayer party games (Mario party, ...)
   gIDT[0x0D00] <- "Trivia" //  Answer/Quizz games (Family Feud, Are you smarter than a 5th grade, ...)
   gIDT[0x0E00] <- "Casino" //  Casino games
   gIDT[0x0F00] <- "Compilation" //  Multi games
   gIDT[0x1000] <- "Demo Scene" //  Amiga/ST/PC Demo from demo scene
   gIDT[0x1100] <- "Educative" //  Educative games

function getgenreid(string){
   local out = ""
   try (out = gIDT[string.tointeger()]) catch (err) {out = ""}
   return out
}

// Create category data structure for metadata editing
function getyears(){
   local yeartable = {
      names = ["197x","198x","199x","200x","201x"]
      decade = ["197","198","199","200","201"]
      table = {}
   }
   local nums = ["0","1","2","3","4","5","6","7","8","9"]

   foreach (id, val in yeartable.names){
      yeartable.table.rawset(val, [])
      foreach (id2, val2 in nums){
         yeartable.table[val].push(yeartable.decade[id]+val2)
      }
   }
   return (yeartable)
}

function getcatnames_SS(){
   local catnames = {
      names = []
      table = {}
		finder = {}
   }
   local catnamesdata = [
		"Action RPG",
		"Action/Adventure",
		"Action/Breakout games",
		"Action/Climbing",
		"Action/Labyrinth",
		"Adult",
		"Adventure/Graphics",
		"Adventure/Interactive Movie",
		"Adventure/Point and Click",
		"Adventure/RealTime 3D",
		"Adventure/Survival Horror",
		"Adventure/Text",
		"Adventure/Visual Novel",
		"Asiatic board game",
		"Beat'em Up",
		"Board game",
		"Build And Management",
		"Casino/Cards",
		"Casino/Lottery",
		"Casino/Race",
		"Casino/Roulette",
		"Casino/Slot machine",
		"Casual Game",
		"Compilation",
		"Demo",
		"Dungeon Crawler RPG",
		"Educational",
		"Fight/ Co-op",
		"Fight/2.5D",
		"Fight/2D",
		"Fight/3D",
		"Fight/Versus",
		"Fight/Vertical",
		"Fishing",
		"Go",
		"Hanafuda",
		"Horses race",
		"Hunting",
		"Hunting and Fishing",
		"Japanese RPG",
		"Lightgun Shooter",
		"Mahjong",
		"Massive Multiplayer Online RPG",
		"Motorcycle Race, 1st Pers.",
		"Motorcycle Race, 3rd Pers.",
		"Music and Dance",
		"Othello",
		"Pinball",
		"Platform/Fighter Scrolling",
		"Platform/Run Jump",
		"Platform/Run Jump Scrolling",
		"Platform/Shooter Scrolling",
		"Playing cards",
		"Puzzle-Game/Equalize",
		"Puzzle-Game/Fall",
		"Puzzle-Game/Glide",
		"Puzzle-Game/Throw",
		"Quiz/English",
		"Quiz/French",
		"Quiz/German",
		"Quiz/Italian",
		"Quiz/Japanese",
		"Quiz/Korean",
		"Quiz/Music English",
		"Quiz/Music Japanese",
		"Quiz/Spanish",
		"Race 1st Pers. view",
		"Race 3rd Pers. view",
		"Race, Driving/Boat",
		"Race, Driving/Hang-glider",
		"Race, Driving/Motorcycle",
		"Race, Driving/Plane",
		"Race, Driving/Race",
		"Renju",
		"Rhythm",
		"Role playing games",
		"Shoot'em up/Diagonal",
		"Shoot'em up/Horizontal",
		"Shoot'em up/Vertical",
		"Shooter/1st person",
		"Shooter/3rd person",
		"Shooter/Horizontal",
		"Shooter/Missile Command Like",
		"Shooter/Plane",
		"Shooter/Plane, 1st person",
		"Shooter/Plane, 3rd person",
		"Shooter/Run and Gun",
		"Shooter/Run and Shoot",
		"Shooter/Space Invaders Like",
		"Shooter/Vehicle, 1st person",
		"Shooter/Vehicle, 3rd person",
		"Shooter/Vehicle, Diagonal",
		"Shooter/Vehicle, Horizontal",
		"Shooter/Vehicle, Vertical",
		"Shooter/Vertical",
		"Shougi",
		"Simulation/Life",
		"Simulation/SciFi",
		"Simulation/Vehicle",
		"Sports with Animals",
		"Sports/Arm wrestling",
		"Sports/Baseball",
		"Sports/Basketball",
		"Sports/Bowling",
		"Sports/Boxing",
		"Sports/Cycling",
		"Sports/Darts",
		"Sports/Dodgeball",
		"Sports/Fighting",
		"Sports/Fitness",
		"Sports/Football",
		"Sports/Golf",
		"Sports/Handball",
		"Sports/Hockey",
		"Sports/Pool",
		"Sports/Rugby",
		"Sports/Running trails",
		"Sports/Shuffleboard",
		"Sports/Skateboard",
		"Sports/Skiing",
		"Sports/Skydiving",
		"Sports/Soccer",
		"Sports/Sumo",
		"Sports/Swimming",
		"Sports/Table tennis",
		"Sports/Tennis",
		"Sports/Volleyball",
		"Sports/Wrestling",
		"Strategy",
		"Tactical RPG",
		"Team-as-one RPG",
		"Thinking",
		"Various/Electro - Mechanical",
		"Various/Print Club",
		"Various/System",
		"Various/Utilities"
	]

   foreach (id, item in catnamesdata){
		catnames.finder.rawset(item, null)
      local vecn = split(item,"/")
      if (vecn.len() == 2){
         if (catnames.table.rawin(vecn[0])) catnames.table[vecn[0]].push(vecn[0]+" / "+vecn[1])
         else {
            catnames.names.push (vecn[0])
            catnames.table[vecn[0]] <- []
            catnames.table[vecn[0]].push(vecn[0]+" / "+vecn[1])
         }
      } else {
         if (catnames.table.rawin(vecn[0])) catnames.table[vecn[0]].push(vecn[0])
         else {
            catnames.names.push (vecn[0])
            catnames.table[vecn[0]] <- []
            catnames.table[vecn[0]].push(vecn[0])
         }
      }
   }

   return (catnames)
}

function getcatnames(){
   local catnames = {
      names = []
      table = {}
		finder = {}
   }
   local catnamesdata = [
		"Ball & Paddle/Breakout",
		"Ball & Paddle/Breakout * Mature *",
		"Ball & Paddle/Jump and Touch",
		"Ball & Paddle/Misc.",
		"Ball & Paddle/Pong",
		"Board Game/Bridge Machine",
		"Board Game/Chess Machine",
		"Board Game/Dame Machine",
		"Casino/Cards",
		"Casino/Cards * Mature *",
		"Casino/Horse Racing",
		"Casino/Lottery",
		"Casino/Misc.",
		"Casino/Misc. * Mature *",
		"Casino/Multiplay",
		"Casino/Racing",
		"Casino/Reels",
		"Casino/Reels * Mature *",
		"Casino/Roulette",
		"Climbing/Building",
		"Climbing/Mountain - Wall",
		"Climbing/Tree - Plant",
		"Driving/1st Person",
		"Driving/Ambulance Guide",
		"Driving/Boat",
		"Driving/Catch",
		"Driving/Demolition Derby",
		"Driving/FireTruck Guide",
		"Driving/Guide and Collect",
		"Driving/Guide and Shoot",
		"Driving/Landing",
		"Driving/Misc.",
		"Driving/Plane",
		"Driving/Race",
		"Driving/Race (chase view)",
		"Driving/Race (chase view) Bike",
		"Driving/Race 1st P Bike",
		"Driving/Race 1st Person",
		"Driving/Race Bike",
		"Driving/Race Track",
		"Driving/Truck Guide",
		"Electromechanical/Change Money",
		"Electromechanical/Misc.",
		"Electromechanical/Pinball",
		"Electromechanical/Redemption",
		"Electromechanical/Reels",
		"Electromechanical/Utilities",
		"Fighter/2.5D",
		"Fighter/2D",
		"Fighter/3D",
		"Fighter/Asian 3D",
		"Fighter/Compilation",
		"Fighter/Field",
		"Fighter/Misc.",
		"Fighter/Multiplay",
		"Fighter/Versus",
		"Fighter/Versus * Mature *",
		"Fighter/Versus Co-op",
		"Fighter/Vertical",
		"Maze/Ball Guide",
		"Maze/Change Surface",
		"Maze/Collect",
		"Maze/Collect * Mature *",
		"Maze/Collect & Put",
		"Maze/Cross",
		"Maze/Defeat Enemies",
		"Maze/Digging",
		"Maze/Digging * Mature *",
		"Maze/Driving",
		"Maze/Escape",
		"Maze/Escape * Mature *",
		"Maze/Fighter",
		"Maze/Integrate",
		"Maze/Ladders",
		"Maze/Marble Madness",
		"Maze/Misc.",
		"Maze/Move and Sort",
		"Maze/Outline",
		"Maze/Paint",
		"Maze/Run Jump",
		"Maze/Shooter Large",
		"Maze/Shooter Small",
		"Maze/Surround",
		"Medal Game/Action",
		"Medal Game/Adventure",
		"Medal Game/Cards",
		"Medal Game/Casino",
		"Medal Game/Compilation",
		"Medal Game/Driving",
		"Medal Game/Horse Racing",
		"Medal Game/Timing",
		"Medal Game/Versus",
		"Misc./Catch",
		"Misc./Clock",
		"Misc./Dartboard",
		"Misc./Dog Sitter",
		"Misc./Educational Game",
		"Misc./Electronic Board Game",
		"Misc./Electronic Game",
		"Misc./Electronic Typewriter",
		"Misc./Gambling Board",
		"Misc./Hot-air Balloon",
		"Misc./Jump and Bounce",
		"Misc./Laser Disk Simulator",
		"Misc./Mini-Games",
		"Misc./Order",
		"Misc./Pachinko",
		"Misc./Pinball",
		"Misc./Pinball * Mature *",
		"Misc./Prediction",
		"Misc./Print Club",
		"Misc./Redemption",
		"Misc./Reflex",
		"Misc./Response Time",
		"Misc./Robot Control",
		"Misc./Satellite Receiver",
		"Misc./Shoot Photos",
		"Misc./Spank * Mature *",
		"Misc./Toy Cars",
		"Misc./Unknown",
		"Misc./Versus",
		"Misc./Virtual Environment",
		"Misc./VTR Control",
		"Multiplay/Cards",
		"Multiplay/Compilation",
		"Multiplay/Compilation * Mature *",
		"Multiplay/Mini-Games",
		"Multiplay/Mini-Games * Mature *",
		"Multiplay/Misc. * Mature *",
		"Platform/2D",
		"Platform/Fighter",
		"Platform/Fighter Scrolling",
		"Platform/Maze",
		"Platform/Run Jump",
		"Platform/Run Jump * Mature *",
		"Platform/Run, Jump & Scrolling",
		"Platform/Shooter",
		"Platform/Shooter Scrolling",
		"Puzzle/Cards",
		"Puzzle/Drop",
		"Puzzle/Drop * Mature *",
		"Puzzle/Match",
		"Puzzle/Match * Mature *",
		"Puzzle/Maze",
		"Puzzle/Misc.",
		"Puzzle/Misc. * Mature *",
		"Puzzle/Outline",
		"Puzzle/Outline * Mature *",
		"Puzzle/Paint * Mature *",
		"Puzzle/Reconstruction",
		"Puzzle/Reconstruction * Mature *",
		"Puzzle/Sliding",
		"Puzzle/Sliding * Mature *",
		"Puzzle/Toss",
		"Puzzle/Toss * Mature *",
		"Quiz/Questions in Chinese",
		"Quiz/Questions in English",
		"Quiz/Questions in English * Mature *",
		"Quiz/Questions in French",
		"Quiz/Questions in German",
		"Quiz/Questions in Italian",
		"Quiz/Questions in Japanese",
		"Quiz/Questions in Japanese * Mature *",
		"Quiz/Questions in Korean",
		"Quiz/Questions in Spanish",
		"Rhythm/Dance",
		"Rhythm/Instruments",
		"Rhythm/Misc.",
		"Shooter/1st Person",
		"Shooter/3rd Person",
		"Shooter/Command",
		"Shooter/Driving",
		"Shooter/Driving (chase view)",
		"Shooter/Driving 1st Person",
		"Shooter/Driving Diagonal",
		"Shooter/Driving Horizontal",
		"Shooter/Driving Vertical",
		"Shooter/Field",
		"Shooter/Flying",
		"Shooter/Flying (chase view)",
		"Shooter/Flying * Mature *",
		"Shooter/Flying 1st Person",
		"Shooter/Flying Diagonal",
		"Shooter/Flying Horizontal",
		"Shooter/Flying Horizontal * Mature *",
		"Shooter/Flying Vertical",
		"Shooter/Flying Vertical * Mature *",
		"Shooter/Gallery",
		"Shooter/Gallery * Mature *",
		"Shooter/Gun",
		"Shooter/Misc.",
		"Shooter/Misc. Horizontal",
		"Shooter/Misc. Vertical",
		"Shooter/Outline * Mature *",
		"Shooter/Underwater",
		"Shooter/Versus",
		"Shooter/Walking",
		"Sports/Armwrestling",
		"Sports/Baseball",
		"Sports/Basketball",
		"Sports/Bowling",
		"Sports/Boxing",
		"Sports/Bull Fighting",
		"Sports/Cards",
		"Sports/Darts",
		"Sports/Dodgeball",
		"Sports/Fishing",
		"Sports/Football",
		"Sports/Golf",
		"Sports/Gun",
		"Sports/Handball",
		"Sports/Hang Gliding",
		"Sports/Hockey",
		"Sports/Horse Racing",
		"Sports/Horseshoes",
		"Sports/Misc.",
		"Sports/Multiplay",
		"Sports/Ping Pong",
		"Sports/Pool",
		"Sports/Pool * Mature *",
		"Sports/Rugby Football",
		"Sports/Shuffleboard",
		"Sports/Skateboarding",
		"Sports/Skiing",
		"Sports/SkyDiving",
		"Sports/Soccer",
		"Sports/Sumo",
		"Sports/Swimming",
		"Sports/Tennis",
		"Sports/Track & Field",
		"Sports/Volley - Soccer",
		"Sports/Volleyball",
		"Sports/Wrestling",
		"System/BIOS",
		"System/Device",
		"Tabletop/Cards",
		"Tabletop/Chess Machine",
		"Tabletop/Go",
		"Tabletop/Hanafuda",
		"Tabletop/Mahjong",
		"Tabletop/Mahjong * Mature *",
		"Tabletop/Match * Mature *",
		"Tabletop/Misc.",
		"Tabletop/Multiplay",
		"Tabletop/Othello - Reversi",
		"Tabletop/Othello - Reversi * Mature *",
		"Tabletop/Renju",
		"Tabletop/Shougi",
		"Whac-A-Mole/Fighter",
		"Whac-A-Mole/Footsteps",
		"Whac-A-Mole/Gun",
		"Whac-A-Mole/Hammer",
		"Whac-A-Mole/Shooter"
	]

   foreach (id, item in catnamesdata){
      catnames.finder.rawset(item,null)
		local vecn = split(item,"/")
      if (catnames.table.rawin(vecn[0])) catnames.table[vecn[0]].push(vecn[0]+" / "+vecn[1])
      else {
         catnames.names.push (vecn[0])
         catnames.table[vecn[0]] <- []
         catnames.table[vecn[0]].push(vecn[0]+" / "+vecn[1])
      }
   }

   return (catnames)
}

function categorynamepurge(cat){
   local s0 = cat[0] + cat[1]
   local s2 = split( s0, "*_/: .()-,<>?&+'" )
	local sout =""
	if ( s2.len() > 1 ) {
		for (local i=0;i<s2.len();i++){
		 if (s2[i] != "Mature")  sout = sout + s2[i]
		}
		sout = sout.tolower()
	}
	else sout = strip(s0).tolower()
	return sout
}

function category_pic_name(cat){
   local sout = categorynamepurge(cat)
	return "metapics/category/"+sout+".png"
}

function category_pic_10_name(cat){
   local sout = categorynamepurge(cat)
	return "metapics/category10/"+sout+".png"
}

function manufacturer_list_vector(){
   local zout = ""
   local txout = ""
   local indexer = 0
   local s = ""
   local t = ""
   for (local i = 0; i<fe.list.size; i++){
      zout = manufacturer_vec(i)
      s = fe.game_info( Info.Manufacturer, i )
	   t = fe.game_info( Info.Title, i )
      txout = manufacturer_parser(s)

      if (zout == ""){
         indexer ++
         print(  indexer + " *** " + txout + " *** " + s + " *** " + t + "\n")
      }
   }
}

function missing_manufacturer_list_vector(z_list){
   local zout = ""
   local txout = ""
   local indexer = 0
   local s = ""
   local t = ""
   local u = ""
   for (local i = 0; i<z_list.boot.len(); i++){
      print (z_list.boot[i].z_manufacturer+"\n")
      print (z_list.boot[i].z_title+"\n")
      print (z_list.boot[i].z_system+"\n")
   }
   for (local i = 0; i<z_list.boot.len(); i++){
      s = z_list.boot[i].z_manufacturer
	   t = z_list.boot[i].z_title
	   u = z_list.boot[i].z_system
      zout = manufacturer_vec(s)
      txout = manufacturer_parser(s)

      if ((zout == "") && (s != "")){
         indexer ++
         print(  u + "*" + indexer + "*" + txout + "*" + s + "*" + t + "\n")
      }
   }
}

function category_list(){
   local zout = ""
   local indexer = 0
   local s = ""
   local t = ""
   for (local i = 0; i<fe.list.size; i++){
      zout = category_pic(i)
      s = fe.game_info( Info.Category, i )
	   t = fe.game_info( Info.Title, i )

      if (!(file_exist(affolder + zout ))){
         indexer ++
         print(  indexer + " *** " + s + " *** " + t + " " + zout + "\n")
      }
   }
}
