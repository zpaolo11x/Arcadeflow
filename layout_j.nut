local last_nav1 = 0;
local gtime1 = 0;
local art_flag1 = false;

local fliper3 = fe.add_image( fe.get_art("system"), 0, 0, 100, 100);  //Use add_image so the snap doesn't auto-update while navigating

local text = fe.add_text("",0,100,100,20)

fe.add_transition_callback( "my_transition2" )
function my_transition2( ttype, var, ttime )
{
    if ( ttype == Transition.ToNewSelection )
    {

        last_nav1= gtime1;
        art_flag1 = true;

    }
}

fe.add_ticks_callback( this, "on_tick2" )
function on_tick2( ttime )
{
    gtime1 = ttime;
    if (art_flag1 && (ttime - last_nav1 > 500))  //800ms delay
    {
        print("X\n")
        fliper3.file_name = fe.get_art("wheel")
        text.msg = fe.game_info(Info.Title)
        art_flag1 = true;

    }
}