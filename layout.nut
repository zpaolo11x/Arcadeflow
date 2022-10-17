local pic = fe.add_rectangle(0,0,100,100)

local arr = array(1000000,1)
local trigger = 0
function refresher(){
	local a=0
	print ("start\n")
	foreach (i, item in arr){
		a=a+1
		pic.x = 300*i*1.0/arr.len()
	}
	print("stop\n")
}

fe.add_signal_handler( this, "on_signal" )
fe.add_transition_callback( this, "on_transition" )
fe.add_ticks_callback( this, "tick" )

function on_transition( ttype, var0, ttime ) {
	return false
}

function tick( tick_time ) {
	//pic.x++
}

function on_signal( sig ){
	if (sig == "custom1"){
		refresher()
	}
	return false
}