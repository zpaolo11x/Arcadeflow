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

local manufile = file( manufpath, "rb" )
local filelen = manufile.len().tofloat()
local arrayline = ""


while ( !manufile.eos() ) {
   
   local char = manufile.readn( 'b' )
   
   if ((char != 10) && (char != 13)) {
      if (char != 32){
         arrayline = arrayline + char.tochar()
      }
      else {
         manufdata [arrayline] <- manufinc
         arrayline = ""
      }
   }

   else if (char == 13){
      manufdata [arrayline] <- manufinc
      arrayline = ""
      manufinc++
   }
}

function manufacturer_parser(inputstring){
   local s = inputstring
   local s2 = split( s, "*%_/: .()-,<>?&'+’!・~·" )
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
 //  local s = z_list.gametable(offset).z_manufacturer
//	local t = fe.game_info( Info.Title, offset )	
	
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

function manufacturer_vec_name(name){
   local s = name
//	local t = fe.game_info( Info.Title, offset )	
	
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


function manufacturer_pic(offset){
   local s = fe.game_info( Info.Manufacturer, offset )
//	local t = fe.game_info( Info.Title, offset )	
	
   local s2 = split( s, "*%_/: .()-,<>?&+!・~·" )
	local sout =""
	if ( s2.len() > 1 ) {
		for (local i=0;i<s2.len();i++){
		if (s2[i] != "license")sout = sout + s2[i]
		}
		sout = sout.tolower()
	}
	else sout = strip(s).tolower()
	return "manufacturer_images/" + ( (sout == "") ? "unknown" : sout) + ".png"
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

   local catnamesdata = []
   local catnames = {
      names = []
      table = {}
   }
   catnamesdata.push("Action RPG")
   catnamesdata.push("Action/Adventure")
   catnamesdata.push("Action/Breakout games")
   catnamesdata.push("Action/Climbing")
   catnamesdata.push("Action/Labyrinth")
   catnamesdata.push("Adult")
   catnamesdata.push("Adventure/Graphics")
   catnamesdata.push("Adventure/Interactive Movie")
   catnamesdata.push("Adventure/Point and Click")
   catnamesdata.push("Adventure/RealTime 3D")
   catnamesdata.push("Adventure/Survival Horror")
   catnamesdata.push("Adventure/Text")
   catnamesdata.push("Adventure/Visual Novel")
   catnamesdata.push("Asiatic board game")
   catnamesdata.push("Beat'em Up")
   catnamesdata.push("Board game")
   catnamesdata.push("Build And Management")
   catnamesdata.push("Casino/Cards")
   catnamesdata.push("Casino/Lottery")
   catnamesdata.push("Casino/Race")
   catnamesdata.push("Casino/Roulette")
   catnamesdata.push("Casino/Slot machine")
   catnamesdata.push("Casual Game")
   catnamesdata.push("Compilation")
   catnamesdata.push("Demo")
   catnamesdata.push("Dungeon Crawler RPG")
   catnamesdata.push("Educational")
   catnamesdata.push("Fight/ Co-op")
   catnamesdata.push("Fight/2.5D")
   catnamesdata.push("Fight/2D")
   catnamesdata.push("Fight/3D")
   catnamesdata.push("Fight/Versus")
   catnamesdata.push("Fight/Vertical")
   catnamesdata.push("Fishing")
   catnamesdata.push("Go")
   catnamesdata.push("Hanafuda")
   catnamesdata.push("Horses race")
   catnamesdata.push("Hunting")
   catnamesdata.push("Hunting and Fishing")
   catnamesdata.push("Japanese RPG")
   catnamesdata.push("Lightgun Shooter")
   catnamesdata.push("Mahjong")
   catnamesdata.push("Massive Multiplayer Online RPG")
   catnamesdata.push("Motorcycle Race, 1st Pers.")
   catnamesdata.push("Motorcycle Race, 3rd Pers.")
   catnamesdata.push("Music and Dance")
   catnamesdata.push("Othello")
   catnamesdata.push("Pinball")
   catnamesdata.push("Platform/Fighter Scrolling")
   catnamesdata.push("Platform/Run Jump")
   catnamesdata.push("Platform/Run Jump Scrolling")
   catnamesdata.push("Platform/Shooter Scrolling")
   catnamesdata.push("Playing cards")
   catnamesdata.push("Puzzle-Game/Equalize")
   catnamesdata.push("Puzzle-Game/Fall")
   catnamesdata.push("Puzzle-Game/Glide")
   catnamesdata.push("Puzzle-Game/Throw")
   catnamesdata.push("Quiz/English")
   catnamesdata.push("Quiz/French")
   catnamesdata.push("Quiz/German")
   catnamesdata.push("Quiz/Italian")
   catnamesdata.push("Quiz/Japanese")
   catnamesdata.push("Quiz/Korean")
   catnamesdata.push("Quiz/Music English")
   catnamesdata.push("Quiz/Music Japanese")
   catnamesdata.push("Quiz/Spanish")
   catnamesdata.push("Race 1st Pers. view")
   catnamesdata.push("Race 3rd Pers. view")
   catnamesdata.push("Race, Driving/Boat")
   catnamesdata.push("Race, Driving/Hang-glider")
   catnamesdata.push("Race, Driving/Motorcycle")
   catnamesdata.push("Race, Driving/Plane")
   catnamesdata.push("Race, Driving/Race")
   catnamesdata.push("Renju")
   catnamesdata.push("Rhythm")
   catnamesdata.push("Role playing games")
   catnamesdata.push("Shoot'em up/Diagonal")
   catnamesdata.push("Shoot'em up/Horizontal")
   catnamesdata.push("Shoot'em up/Vertical")
   catnamesdata.push("Shooter/1st person")
   catnamesdata.push("Shooter/3rd person")
   catnamesdata.push("Shooter/Horizontal")
   catnamesdata.push("Shooter/Missile Command Like")
   catnamesdata.push("Shooter/Plane")
   catnamesdata.push("Shooter/Plane, 1st person")
   catnamesdata.push("Shooter/Plane, 3rd person")
   catnamesdata.push("Shooter/Run and Gun")
   catnamesdata.push("Shooter/Run and Shoot")
   catnamesdata.push("Shooter/Space Invaders Like")
   catnamesdata.push("Shooter/Vehicle, 1st person")
   catnamesdata.push("Shooter/Vehicle, 3rd person")
   catnamesdata.push("Shooter/Vehicle, Diagonal")
   catnamesdata.push("Shooter/Vehicle, Horizontal")
   catnamesdata.push("Shooter/Vehicle, Vertical")
   catnamesdata.push("Shooter/Vertical")
   catnamesdata.push("Shougi")
   catnamesdata.push("Simulation/Life")
   catnamesdata.push("Simulation/SciFi")
   catnamesdata.push("Simulation/Vehicle")
   catnamesdata.push("Sports with Animals")
   catnamesdata.push("Sports/Arm wrestling")
   catnamesdata.push("Sports/Baseball")
   catnamesdata.push("Sports/Basketball")
   catnamesdata.push("Sports/Bowling")
   catnamesdata.push("Sports/Boxing")
   catnamesdata.push("Sports/Cycling")
   catnamesdata.push("Sports/Darts")
   catnamesdata.push("Sports/Dodgeball")
   catnamesdata.push("Sports/Fighting")
   catnamesdata.push("Sports/Fitness")
   catnamesdata.push("Sports/Football")
   catnamesdata.push("Sports/Golf")
   catnamesdata.push("Sports/Handball")
   catnamesdata.push("Sports/Hockey")
   catnamesdata.push("Sports/Pool")
   catnamesdata.push("Sports/Rugby")
   catnamesdata.push("Sports/Running trails")
   catnamesdata.push("Sports/Shuffleboard")
   catnamesdata.push("Sports/Skateboard")
   catnamesdata.push("Sports/Skiing")
   catnamesdata.push("Sports/Skydiving")
   catnamesdata.push("Sports/Soccer")
   catnamesdata.push("Sports/Sumo")
   catnamesdata.push("Sports/Swimming")
   catnamesdata.push("Sports/Table tennis")
   catnamesdata.push("Sports/Tennis")
   catnamesdata.push("Sports/Volleyball")
   catnamesdata.push("Sports/Wrestling")
   catnamesdata.push("Strategy")
   catnamesdata.push("Tactical RPG")
   catnamesdata.push("Team-as-one RPG")
   catnamesdata.push("Thinking")
   catnamesdata.push("Various/Electro - Mechanical")
   catnamesdata.push("Various/Print Club")
   catnamesdata.push("Various/System")
   catnamesdata.push("Various/Utilities")

   foreach (id, item in catnamesdata){
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

   local catnamesdata = []
   local catnames = {
      names = []
      table = {}
   }
   catnamesdata.push("Ball & Paddle/Breakout")
   catnamesdata.push("Ball & Paddle/Breakout * Mature *")
   catnamesdata.push("Ball & Paddle/Jump and Touch")
   catnamesdata.push("Ball & Paddle/Misc.")
   catnamesdata.push("Ball & Paddle/Pong")
   catnamesdata.push("Board Game/Bridge Machine")
   catnamesdata.push("Board Game/Chess Machine")
   catnamesdata.push("Board Game/Dame Machine")
   catnamesdata.push("Casino/Cards")
   catnamesdata.push("Casino/Cards * Mature *")
   catnamesdata.push("Casino/Horse Racing")
   catnamesdata.push("Casino/Lottery")
   catnamesdata.push("Casino/Misc.")
   catnamesdata.push("Casino/Misc. * Mature *")
   catnamesdata.push("Casino/Multiplay")
   catnamesdata.push("Casino/Racing")
   catnamesdata.push("Casino/Reels")
   catnamesdata.push("Casino/Reels * Mature *")
   catnamesdata.push("Casino/Roulette")
   catnamesdata.push("Climbing/Building")
   catnamesdata.push("Climbing/Mountain - Wall")
   catnamesdata.push("Climbing/Tree - Plant")
   catnamesdata.push("Driving/1st Person")
   catnamesdata.push("Driving/Ambulance Guide")
   catnamesdata.push("Driving/Boat")
   catnamesdata.push("Driving/Catch")
   catnamesdata.push("Driving/Demolition Derby")
   catnamesdata.push("Driving/FireTruck Guide")
   catnamesdata.push("Driving/Guide and Collect")
   catnamesdata.push("Driving/Guide and Shoot")
   catnamesdata.push("Driving/Landing")
   catnamesdata.push("Driving/Misc.")
   catnamesdata.push("Driving/Plane")
   catnamesdata.push("Driving/Race")
   catnamesdata.push("Driving/Race (chase view)")
   catnamesdata.push("Driving/Race (chase view) Bike")
   catnamesdata.push("Driving/Race 1st P Bike")
   catnamesdata.push("Driving/Race 1st Person")
   catnamesdata.push("Driving/Race Bike")
   catnamesdata.push("Driving/Race Track")
   catnamesdata.push("Driving/Truck Guide")
   catnamesdata.push("Electromechanical/Change Money")
   catnamesdata.push("Electromechanical/Misc.")
   catnamesdata.push("Electromechanical/Pinball")
   catnamesdata.push("Electromechanical/Redemption")
   catnamesdata.push("Electromechanical/Reels")
   catnamesdata.push("Electromechanical/Utilities")
   catnamesdata.push("Fighter/2.5D")
   catnamesdata.push("Fighter/2D")
   catnamesdata.push("Fighter/3D")
   catnamesdata.push("Fighter/Asian 3D")
   catnamesdata.push("Fighter/Compilation")
   catnamesdata.push("Fighter/Field")
   catnamesdata.push("Fighter/Misc.")
   catnamesdata.push("Fighter/Multiplay")
   catnamesdata.push("Fighter/Versus")
   catnamesdata.push("Fighter/Versus * Mature *")
   catnamesdata.push("Fighter/Versus Co-op")
   catnamesdata.push("Fighter/Vertical")
   catnamesdata.push("Maze/Ball Guide")
   catnamesdata.push("Maze/Change Surface")
   catnamesdata.push("Maze/Collect")
   catnamesdata.push("Maze/Collect * Mature *")
   catnamesdata.push("Maze/Collect & Put")
   catnamesdata.push("Maze/Cross")
   catnamesdata.push("Maze/Defeat Enemies")
   catnamesdata.push("Maze/Digging")
   catnamesdata.push("Maze/Digging * Mature *")
   catnamesdata.push("Maze/Driving")
   catnamesdata.push("Maze/Escape")
   catnamesdata.push("Maze/Escape * Mature *")
   catnamesdata.push("Maze/Fighter")
   catnamesdata.push("Maze/Integrate")
   catnamesdata.push("Maze/Ladders")
   catnamesdata.push("Maze/Marble Madness")
   catnamesdata.push("Maze/Misc.")
   catnamesdata.push("Maze/Move and Sort")
   catnamesdata.push("Maze/Outline")
   catnamesdata.push("Maze/Paint")
   catnamesdata.push("Maze/Run Jump")
   catnamesdata.push("Maze/Shooter Large")
   catnamesdata.push("Maze/Shooter Small")
   catnamesdata.push("Maze/Surround")
   catnamesdata.push("Medal Game/Action")
   catnamesdata.push("Medal Game/Adventure")
   catnamesdata.push("Medal Game/Cards")
   catnamesdata.push("Medal Game/Casino")
   catnamesdata.push("Medal Game/Compilation")
   catnamesdata.push("Medal Game/Driving")
   catnamesdata.push("Medal Game/Horse Racing")
   catnamesdata.push("Medal Game/Timing")
   catnamesdata.push("Medal Game/Versus")
   catnamesdata.push("Misc./Catch")
   catnamesdata.push("Misc./Clock")
   catnamesdata.push("Misc./Dartboard")
   catnamesdata.push("Misc./Dog Sitter")
   catnamesdata.push("Misc./Educational Game")
   catnamesdata.push("Misc./Electronic Board Game")
   catnamesdata.push("Misc./Electronic Game")
   catnamesdata.push("Misc./Electronic Typewriter")
   catnamesdata.push("Misc./Gambling Board")
   catnamesdata.push("Misc./Hot-air Balloon")
   catnamesdata.push("Misc./Jump and Bounce")
   catnamesdata.push("Misc./Laser Disk Simulator")
   catnamesdata.push("Misc./Mini-Games")
   catnamesdata.push("Misc./Order")
   catnamesdata.push("Misc./Pachinko")
   catnamesdata.push("Misc./Pinball")
   catnamesdata.push("Misc./Pinball * Mature *")
   catnamesdata.push("Misc./Prediction")
   catnamesdata.push("Misc./Print Club")
   catnamesdata.push("Misc./Redemption")
   catnamesdata.push("Misc./Reflex")
   catnamesdata.push("Misc./Response Time")
   catnamesdata.push("Misc./Robot Control")
   catnamesdata.push("Misc./Satellite Receiver")
   catnamesdata.push("Misc./Shoot Photos")
   catnamesdata.push("Misc./Spank * Mature *")
   catnamesdata.push("Misc./Toy Cars")
   catnamesdata.push("Misc./Unknown")
   catnamesdata.push("Misc./Versus")
   catnamesdata.push("Misc./Virtual Environment")
   catnamesdata.push("Misc./VTR Control")
   catnamesdata.push("Multiplay/Cards")
   catnamesdata.push("Multiplay/Compilation")
   catnamesdata.push("Multiplay/Compilation * Mature *")
   catnamesdata.push("Multiplay/Mini-Games")
   catnamesdata.push("Multiplay/Mini-Games * Mature *")
   catnamesdata.push("Multiplay/Misc. * Mature *")
   catnamesdata.push("Platform/2D")
   catnamesdata.push("Platform/Fighter")
   catnamesdata.push("Platform/Fighter Scrolling")
   catnamesdata.push("Platform/Maze")
   catnamesdata.push("Platform/Run Jump")
   catnamesdata.push("Platform/Run Jump * Mature *")
   catnamesdata.push("Platform/Run, Jump & Scrolling")
   catnamesdata.push("Platform/Shooter")
   catnamesdata.push("Platform/Shooter Scrolling")
   catnamesdata.push("Puzzle/Cards")
   catnamesdata.push("Puzzle/Drop")
   catnamesdata.push("Puzzle/Drop * Mature *")
   catnamesdata.push("Puzzle/Match")
   catnamesdata.push("Puzzle/Match * Mature *")
   catnamesdata.push("Puzzle/Maze")
   catnamesdata.push("Puzzle/Misc.")
   catnamesdata.push("Puzzle/Misc. * Mature *")
   catnamesdata.push("Puzzle/Outline")
   catnamesdata.push("Puzzle/Outline * Mature *")
   catnamesdata.push("Puzzle/Paint * Mature *")
   catnamesdata.push("Puzzle/Reconstruction")
   catnamesdata.push("Puzzle/Reconstruction * Mature *")
   catnamesdata.push("Puzzle/Sliding")
   catnamesdata.push("Puzzle/Sliding * Mature *")
   catnamesdata.push("Puzzle/Toss")
   catnamesdata.push("Puzzle/Toss * Mature *")
   catnamesdata.push("Quiz/Questions in Chinese")
   catnamesdata.push("Quiz/Questions in English")
   catnamesdata.push("Quiz/Questions in English * Mature *")
   catnamesdata.push("Quiz/Questions in French")
   catnamesdata.push("Quiz/Questions in German")
   catnamesdata.push("Quiz/Questions in Italian")
   catnamesdata.push("Quiz/Questions in Japanese")
   catnamesdata.push("Quiz/Questions in Japanese * Mature *")
   catnamesdata.push("Quiz/Questions in Korean")
   catnamesdata.push("Quiz/Questions in Spanish")
   catnamesdata.push("Rhythm/Dance")
   catnamesdata.push("Rhythm/Instruments")
   catnamesdata.push("Rhythm/Misc.")
   catnamesdata.push("Shooter/1st Person")
   catnamesdata.push("Shooter/3rd Person")
   catnamesdata.push("Shooter/Command")
   catnamesdata.push("Shooter/Driving")
   catnamesdata.push("Shooter/Driving (chase view)")
   catnamesdata.push("Shooter/Driving 1st Person")
   catnamesdata.push("Shooter/Driving Diagonal")
   catnamesdata.push("Shooter/Driving Horizontal")
   catnamesdata.push("Shooter/Driving Vertical")
   catnamesdata.push("Shooter/Field")
   catnamesdata.push("Shooter/Flying")
   catnamesdata.push("Shooter/Flying (chase view)")
   catnamesdata.push("Shooter/Flying * Mature *")
   catnamesdata.push("Shooter/Flying 1st Person")
   catnamesdata.push("Shooter/Flying Diagonal")
   catnamesdata.push("Shooter/Flying Horizontal")
   catnamesdata.push("Shooter/Flying Horizontal * Mature *")
   catnamesdata.push("Shooter/Flying Vertical")
   catnamesdata.push("Shooter/Flying Vertical * Mature *")
   catnamesdata.push("Shooter/Gallery")
   catnamesdata.push("Shooter/Gallery * Mature *")
   catnamesdata.push("Shooter/Gun")
   catnamesdata.push("Shooter/Misc.")
   catnamesdata.push("Shooter/Misc. Horizontal")
   catnamesdata.push("Shooter/Misc. Vertical")
   catnamesdata.push("Shooter/Outline * Mature *")
   catnamesdata.push("Shooter/Underwater")
   catnamesdata.push("Shooter/Versus")
   catnamesdata.push("Shooter/Walking")
   catnamesdata.push("Sports/Armwrestling")
   catnamesdata.push("Sports/Baseball")
   catnamesdata.push("Sports/Basketball")
   catnamesdata.push("Sports/Bowling")
   catnamesdata.push("Sports/Boxing")
   catnamesdata.push("Sports/Bull Fighting")
   catnamesdata.push("Sports/Cards")
   catnamesdata.push("Sports/Darts")
   catnamesdata.push("Sports/Dodgeball")
   catnamesdata.push("Sports/Fishing")
   catnamesdata.push("Sports/Football")
   catnamesdata.push("Sports/Golf")
   catnamesdata.push("Sports/Gun")
   catnamesdata.push("Sports/Handball")
   catnamesdata.push("Sports/Hang Gliding")
   catnamesdata.push("Sports/Hockey")
   catnamesdata.push("Sports/Horse Racing")
   catnamesdata.push("Sports/Horseshoes")
   catnamesdata.push("Sports/Misc.")
   catnamesdata.push("Sports/Multiplay")
   catnamesdata.push("Sports/Ping Pong")
   catnamesdata.push("Sports/Pool")
   catnamesdata.push("Sports/Pool * Mature *")
   catnamesdata.push("Sports/Rugby Football")
   catnamesdata.push("Sports/Shuffleboard")
   catnamesdata.push("Sports/Skateboarding")
   catnamesdata.push("Sports/Skiing")
   catnamesdata.push("Sports/SkyDiving")
   catnamesdata.push("Sports/Soccer")
   catnamesdata.push("Sports/Sumo")
   catnamesdata.push("Sports/Swimming")
   catnamesdata.push("Sports/Tennis")
   catnamesdata.push("Sports/Track & Field")
   catnamesdata.push("Sports/Volley - Soccer")
   catnamesdata.push("Sports/Volleyball")
   catnamesdata.push("Sports/Wrestling")
   catnamesdata.push("System/BIOS")
   catnamesdata.push("System/Device")
   catnamesdata.push("Tabletop/Cards")
   catnamesdata.push("Tabletop/Chess Machine")
   catnamesdata.push("Tabletop/Go")
   catnamesdata.push("Tabletop/Hanafuda")
   catnamesdata.push("Tabletop/Mahjong")
   catnamesdata.push("Tabletop/Mahjong * Mature *")
   catnamesdata.push("Tabletop/Match * Mature *")
   catnamesdata.push("Tabletop/Misc.")
   catnamesdata.push("Tabletop/Multiplay")
   catnamesdata.push("Tabletop/Othello - Reversi")
   catnamesdata.push("Tabletop/Othello - Reversi * Mature *")
   catnamesdata.push("Tabletop/Renju")
   catnamesdata.push("Tabletop/Shougi")
   catnamesdata.push("Whac-A-Mole/Fighter")
   catnamesdata.push("Whac-A-Mole/Footsteps")
   catnamesdata.push("Whac-A-Mole/Gun")
   catnamesdata.push("Whac-A-Mole/Hammer")
   catnamesdata.push("Whac-A-Mole/Shooter")

   foreach (id, item in catnamesdata){
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


function categorynamepurge(catname){
   local s0 = split (parsecategory(catname), ",")[0]
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

function category_pic_name(name){
   //local s = fe.game_info( Info.Category, offset )
   local s = name
   local sout = categorynamepurge(s)

	return "metapics/category/"+sout+".png"
}

function category_pic(offset){
   local s = fe.game_info( Info.Category, offset )
   local sout = categorynamepurge(s)

	return "metapics/category/"+sout+".png"
}

function category_pic_10_name(s){
   local sout = categorynamepurge(s)
	return "metapics/category10/"+sout+".png"
}

function category_pic_10(offset){
   local s = fe.game_info( Info.Category, offset )
   local sout = categorynamepurge(s)
	return "metapics/category10/"+sout+".png"
}

function manufacturer_list(){
   local zout = ""
   local indexer = 0
   local s = ""
   local t = ""
   for (local i = 0; i<fe.list.size; i++){
      zout = manufacturer_pic(i)
      s = fe.game_info( Info.Manufacturer, i )
	   t = fe.game_info( Info.Title, i )	

      if (!(file_exist(affolder + zout))){
         indexer ++
         print(  indexer + " *** " + s + " *** " + t + "\n")
      }
   }
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

//listbrand()
//listcategory ()
