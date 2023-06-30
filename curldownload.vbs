Dim Arg
Set Arg = WScript.Arguments

Dim sh
Set sh = WScript.CreateObject("WScript.Shell")

'sh.run "cmd /K curl --create-dirs -s """+Arg(0)+""" -o """+Arg(1)+""" & exit",0,false

'arg(0) = item.dldpath + "dldsA.txt"
'arg(1) = item.ADBurl
'arg(2) = item.ADBfileUIX

sh.run "cmd /K echo ok > """+Arg(0)+""" && curl -f --create-dirs -s """+Arg(1)+""" -o """+Arg(2)+""" && del """+Arg(0)+""" & exit",0,false
' FUNZIONA SU LAPTOP sh.run "cmd /K echo okpluto > """+Arg(0)+""" && curl -s """+Arg(1)+""" -o """+Arg(2)+""" && del """+Arg(0)+"""",0,false

Set sh = nothing