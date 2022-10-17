local pic = fe.add_rectangle(0,0,300,100)

local arr = array(100,1)
local trigger = 0
local arrx = 0
local arrtoggle = 0
local time0 = 0


function refresher(){
	print ("start\n")
	local a=0
	print (fe.layout.time)
	arrtoggle = 1
	foreach (i, item in arr){
		if (time0 - time0 >= 18) {
			arrx = floor(300*i*1.0/arr.len())
			suspend()
		}
		a=a+1
		//pic.x = 300*i*1.0/arr.len()
	}
	arrtoggle = 0
	print("stop\n")
}

function refresh2(){
	print ("start\n")
	arrtoggle = 1
	local a=0
	time0 = fe.layout.time
	foreach (i, item in arr){
		if (arrx != floor(300*i*1.0/arr.len())) {
			arrx = floor(300*i*1.0/arr.len())
		}
		a=a+1
		//pic.x = 300*i*1.0/arr.len()
	}
	arrtoggle = 0
	print("stop\n")
}

local refreshthread = newthread(refresher)

fe.add_signal_handler( this, "on_signal" )
fe.add_transition_callback( this, "on_transition" )
fe.add_ticks_callback( this, "tick" )

function on_transition( ttype, var0, ttime ) {
	return false
}

function tick( tick_time ) {
	if (arrtoggle == 1) {
		//print (arrx+"\n")
		pic.width = 300-arrx
		refreshthread.wakeup()
	}
}

function on_signal( sig ){
	if (sig == "custom1"){
		time0 = fe.layout.time
		refreshthread.call()
	}
	if (sig == "custom2"){
		refresh2()
	}
	return false
}