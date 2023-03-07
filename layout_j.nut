local last_nav1 = 0;
local gtime1 = 0;
local art_flag1 = false;

local fliper3 = fe.add_image( fe.get_art("system"), 130, 900, 140, 140);  //Use add_image so the snap doesn't auto-update while navigating


fe.add_transition_callback( "my_transition2" );
function my_transition2( ttype, var, ttime )
{
    if ( ttype == Transition.ToNewSelection )
    {

        last_nav1= gtime1;
        art_flag1 = true;

    }
}

fe.add_ticks_callback( this, "on_tick2" );
function on_tick2( ttime )
{
    gtime1 = ttime;
    if (art_flag1 && (ttime - last_nav1 > 2000))  //800ms delay
    {
        fliper3.file_name = fe.get_art("system");
        art_flag1 = true;

    }
}