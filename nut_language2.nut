local affolder = fe.script_dir
local languagetable = dofile(fe.path_expand(affolder+"data_translations2.txt"))
local languages = datatable.LNGCODES

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

	if (typeof inputitem != "array"){
		return (languagetable.rawin(inputitem) ? languagetable[inputitem][languagestring] : inputitem)
	}
	else {
		foreach (i, item in inputitem){
			out[i] = (languagetable.rawin(inputitem[i]) ? languagetable[inputitem[i]][languagestring] : inputitem[i])
		}
		return out			
	}
}
