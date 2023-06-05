local affolder = fe.script_dir
local tablepath = fe.path_expand( affolder+"data_translations.txt")
local tablefile = ReadTextFile (tablepath)
local languages = {}
local languagetable = {}
local currentstring = tablefile.read_line()
local tempstring = ""
local templabel = ""

while (currentstring != ""){
   tempstring = split(currentstring,"|")
   languages[strip(tempstring[1])] <- strip(tempstring[0])
   currentstring = tablefile.read_line()
}
while (!tablefile.eos()){
   currentstring = tablefile.read_line()
   tempstring = split(currentstring,"|")
   if (tempstring.len() > 1) {
      templabel = strip(tempstring[1])
      currentstring = tablefile.read_line()
      local temptable = {}
      while (currentstring != ""){
         tempstring = split(currentstring,"|")
         temptable [strip(tempstring[0])] <- strip(tempstring[1])
         currentstring = tablefile.read_line()
      }
   languagetable [templabel] <- temptable
   }
}
tablefile.close_file()

function languagearray() {
   local out = []
   foreach (lang,code in languages){
      out.push (lang)   
   }
   out.sort(@(a,b) a <=> b)
   return out
}

function languagelist() {
   local out = languagearray()
   local strout =""
   for (local i = 0 ; i < out.len();i++){
      strout = strout + out[i]
      if (i < out.len()-1) strout = strout+","
   }
   return strout
}

function languagecode(layoutlanguage) {
   return languages[layoutlanguage]
}

function languagetokenarray() {
   local out = languagearray() 
   local out2 = out
   for (local i = 0 ; i < out.len() ; i++){
      out2[i] = languagecode(out[i])
   }
   return out2
}

function loadlanguage(){
   local languagepath = fe.path_expand( affolder+"pref_savedlanguage.txt")
   local languagefile = ReadTextFile (languagepath)
   local out = languagefile.read_line()
   return (out)
}

function savelanguage(savecode){
   local languagepath = fe.path_expand( affolder+"pref_savedlanguage.txt")
   local languagefile = WriteTextFile (languagepath)
   languagefile.write_line(savecode)
}

function ltxt(inputitem,languagestring) {
   local out = inputitem
	if (languagestring == "EN") return (inputitem)
   else {
		if (typeof inputitem != "array"){
			try {return languagetable [inputitem][languagestring]} 
			catch (err) {return(inputitem)}
		}
		else {
			for (local i = 0 ; i < inputitem.len() ; i++) {
				try {out[i] = languagetable [inputitem[i]][languagestring]}
				catch (err) {out[i] = inputitem[i]}
			}
			return out			
		}
	}
}
