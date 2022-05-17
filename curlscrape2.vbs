Dim Arg
Set Arg = WScript.Arguments

Dim sh
Set sh = WScript.CreateObject("WScript.Shell")

sh.run "cmd /K curl -s """+Arg(0)+""" -o """+Arg(1)+""" && echo OK > """+Arg(2)+""" & exit",0,false
Set sh = nothing