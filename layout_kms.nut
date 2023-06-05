local gamename = fe.add_text("[title]",0,0,200,10)
local test = "LOAD"

fe.add_transition_callback(this,"on_transition")

function on_transition (ttype,var,ttime){
   if (ttype == Transition.StartLayout){
      test = "START"
      print ("A: "test+"\n")
   }
   if (ttype == Transition.ToGame){
      test = "TOGAME"
      print ("B: "test+"\n")
   }
   if (ttype == Transition.FromGame){
      print ("C: "test+"\n")
   }
   return false
}