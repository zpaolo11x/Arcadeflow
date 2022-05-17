Dim Arg
Set Arg = WScript.Arguments

Dim sh
Set sh = WScript.CreateObject("WScript.Shell")

sh.run "cmd /K curl --create-dirs -s """+Arg(0)+""" -o """+Arg(1)+""" & exit",0,false
Set sh = nothing