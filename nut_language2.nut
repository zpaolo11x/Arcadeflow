local affolder = fe.path_expand(fe.script_dir)
local afuserfolder =  fe.path_expand(fe.script_dir)
local afamfolder = fe.path_expand(FeConfigDirectory)
if (!(affolder.find(afamfolder) == 0)){
	afuserfolder = afamfolder+".arcadeflow/"
}

local languagetable = dofile(fe.path_expand(affolder+"data_translations2.txt"))

function languagearray() {
   local out = []
   foreach (lang,code in languagetable.LNGCODES){
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

function languagetokenarray() {
   local out = languagearray() 
   local out2 = out
   for (local i = 0 ; i < out.len() ; i++){
      out2[i] = languagetable.LNGCODES[out[i]]
   }
   return out2
}

function loadlanguage(){
   local languagepath = fe.path_expand( afuserfolder+"pref_savedlanguage.txt")
   local languagefile = ReadTextFile (languagepath)
   local out = languagefile.read_line()
   return (out)
}

function savelanguage(savecode){
   local languagepath = fe.path_expand( afuserfolder+"pref_savedlanguage.txt")
   local languagefile = WriteTextFile (languagepath)
   languagefile.write_line(savecode)
}

function ltxt(inputitem,languagestring) {
   local out = inputitem
	if ((languagestring == "EN") || (languagestring == "")) return (inputitem)

	if (typeof inputitem != "array"){
		return (languagetable.rawin(inputitem) ? (languagetable[inputitem].rawin(languagestring) ? languagetable[inputitem][languagestring] : inputitem) : inputitem)
	}
	else {
		foreach (i, item in inputitem){
			out[i] = (languagetable.rawin(inputitem[i]) ? (languagetable[inputitem[i]].rawin(languagestring) ? languagetable[inputitem[i]][languagestring] : inputitem[i]) : inputitem[i])
		}
		return out			
	}
}
