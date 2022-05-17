///////////////////////////////////////////////////
//
// Attract-Mode Frontend - History.dat plugin
//
// File utilities
//
///////////////////////////////////////////////////
const AF_READ_BLOCK_SIZE=80960
local af_next_ln_overflow=""
local af_idx_path = FeConfigDirectory + "history.idx/"
local af_idx_command_path = FeConfigDirectory + "command.idx/"
local af_loaded_idx = {}

//
// Write a single line of output to f
//
function af_write_ln( f, line )
{
	local b = blob( line.len() )

	for (local i=0; i<line.len(); i++)
		b.writen( line[i], 'b' )

	f.writeblob( b )
}

//
// Get a single line of input from f
//
function af_get_next_ln( f )
{
	local ln = af_next_ln_overflow
	af_next_ln_overflow=""
	while ( !f.eos() )
	{
		local char = f.readn( 'b' )
		if ( char == '\n' )
			return strip( ln )

		ln += char.tochar()
	}

	af_next_ln_overflow=ln
	return ""
}

//
// Scan through f and return the next line starting with a "$"
//
function af_scan_for_ctrl_ln( f )
{
	local char
	while ( !f.eos() )
	{
		char = f.readn( 'b' )
		if (( char == '\n' ) && ( !f.eos() ))
		{
			char = f.readn( 'b' )
			if ( char == '$' )
			{
				af_next_ln_overflow="$"
				return af_get_next_ln( f )
			}
		}
	}
	return ""
}

//
// Generate our command.dat index files
//
function af_generate_command_index( prf )
{
	local histf_name = fe.path_expand( prf.DAT_COMMAND_PATH ) 
	local histf

	try
	{
		histf = file( histf_name, "rb" )
	}
	catch ( e )
	{
		return "Error opening file: " + histf_name
	}

	local datatable = {}

	local last_per=0

	//
	// Get an index for all the entries in history.dat
	//
	while ( !histf.eos() )
	{
		local newline = af_get_next_ln(histf) 

		if (newline.find ("### Mame Command Reference ###") != null) {

			break
		}

		if (newline.find("$info=") != null) {
			local romnames = newline.slice(6,newline.len())

			
			local romarray = split(romnames,",")

			local templine = ""
			while ((templine != "«Buttons»") && (templine != "- CONTROLS -")){
				templine = af_get_next_ln(histf)
			}
			templine = "0"
			local separatorline = af_get_next_ln(histf)
			local commandarray = []

			while ((templine != separatorline) && (templine.len() > 0)){
				templine = af_get_next_ln(histf)
				if ((templine != separatorline) && (templine.len() > 0) ) {
					try{
						local arr = split(templine,":")
						if ((strip(arr[0]) != "_S") && (strip(arr[0]) != "^S")) commandarray.push( strip(split(arr[1],"(")[0]) )
					} catch(err){}
				}
			}

			for (local i = 0 ; i < romarray.len();i++){
				datatable[romarray[i]] <- commandarray
			}
			
		}

		// Update the user with the percentage complete
		local percent = 100.0 * ( histf.tell().tofloat() / histf.len().tofloat() )
		if ( percent.tointeger() > last_per )
		{
			last_per = percent.tointeger()
			if ( fe.overlay.splash_message(
					"Generating index ("
					+ last_per + "%)" ) )
				break
		}
		
	}

	//
	// Make sure the directory we are writing to exists...
	//
	system( "mkdir \"" + af_idx_command_path + "\"" )

	fe.overlay.splash_message( "Writing index file." )
	
	local idx = file( af_idx_command_path + "info.idx", "w" )
	foreach (item,val in datatable){
		local str0 = item+"|"
		for (local i = 0 ; i < val.len();i++){
			str0 = str0 + val[i]+"|"
		}
		af_write_ln(idx, str0+"\n" )
	}
	idx.close()

	histf.close()
	return "Created index in " + af_idx_path
}

function af_create_command_table(){
	local table = {}
	local histf = null
	try {histf = file ( af_idx_command_path + "info.idx", "rb" )} catch(err) {return(null)}
	while ( !histf.eos() ){
		local templine = af_get_next_ln( histf )
		local temparray = split(templine,"|")
		local tempname = temparray[0]
		temparray.remove(0)
		table[tempname] <- temparray
	}
	return table
}

//
// Return the text for the history.dat entry after the given offset
//
function af_get_command_entry( offset, prf )
{
	local skiplines = 0
	local histf = file ( prf.DAT_PATH, "rb" )
	histf.seek( offset )

	local entry = ""
	local open_entry = false

	while ( !histf.eos() )
	{
		local blb = histf.readblob( AF_READ_BLOCK_SIZE )
		while ( !blb.eos() )
		{
			local line = af_get_next_ln( blb )

			if ( !open_entry )
			{
				//
				// forward to the $bio tag
				//
				if (( line.len() < 1 ) || (  line != "$bio" )) continue

				open_entry = true
			}
			else
			{
				if (( line == "$end" ) || (line == "- CONTRIBUTE -"))
				{
					entry += "\n\n"
					return entry
				}
				else if (!(blb.eos() && ( line == "" )))
					skiplines ++
					if (skiplines > 3) entry += line + "\n"
			}
		}
	}

	return entry
}

//
// Generate our history.dat index files
//
function af_generate_index( prf )
{
	local histf_name = fe.path_expand( prf.DAT_PATH )
	local histf

	try
	{
		histf = file( histf_name, "rb" )
	}
	catch ( e )
	{
		return "Error opening file: " + histf_name
	}

	local indices = {}

	local last_per=0

	//
	// Get an index for all the entries in history.dat
	//
	while ( !histf.eos() )
	{
		local base_pos = histf.tell()
		local blb = histf.readblob( AF_READ_BLOCK_SIZE )

		// Update the user with the percentage complete
		local percent = 100.0 * ( histf.tell().tofloat() / histf.len().tofloat() )
		if ( percent.tointeger() > last_per )
		{
			last_per = percent.tointeger()
			if ( fe.overlay.splash_message(
					"Generating index ("
					+ last_per + "%)" ) )
				break
		}
		
		while ( !blb.eos() )
		{
			local line = af_scan_for_ctrl_ln( blb )

			if ( line.len() < 5 ) // skips $bio, $end
				continue

			local eq = line.find( "=", 1 )
			if ( eq != null )
			{
				local systems = split( line.slice(1,eq), "," )
				local roms = split( line.slice(eq+1), "," )

				foreach ( s in systems )
				{
					if ( !indices.rawin( s ) )
						indices[ s ] <- {}

					if ( prf.INDEX_CLONES )
					{
						foreach ( r in roms )
							(indices[ s ])[ r ]
								<- ( base_pos + blb.tell() )
					}
					else if ( roms.len() > 0 )
					{
						(indices[ s ])[ roms[0] ]
							<- ( base_pos + blb.tell() )
					}
				}
			}
		}
	}

	//
	// Make sure the directory we are writing to exists...
	//
	system( "mkdir \"" + af_idx_path + "\"" )

	fe.overlay.splash_message( "Writing index file." )

	//
	// Now write an index file for each system encountered
	//
	foreach ( n,l in indices )
	{
		local idx = file( af_idx_path + n + ".idx", "w" )
		foreach ( rn,ri in l )
			af_write_ln( idx, rn + ";" + ri + "\n" )

		idx.close()
	}

	histf.close()

	return "Created index for " + indices.len()
		+ " systems in " + af_idx_path
}

//
// Return the text for the history.dat entry after the given offset
//
function af_get_history_entry( offset, prf )
{
	local skiplines = 0
	local histf = file ( prf.DAT_PATH, "rb" )
	histf.seek( offset )
	local skiplinelimit = 3

	local entry = ""
	local open_entry = false

	while ( !histf.eos() )
	{
		local blb = histf.readblob( AF_READ_BLOCK_SIZE )
		while ( !blb.eos() )
		{
			local line = af_get_next_ln( blb )

			if ( !open_entry )
			{
				//
				// forward to the $bio tag
				//
				if (( line.len() < 1 ) || (  line != "$bio" )) continue

				open_entry = true
			}
			else
			{
				if (( line == "$end" ) || (line == "- CONTRIBUTE -"))
				{
					entry += "\n\n"
					return entry
				}
				else if (!(blb.eos() && ( line == "" )))
						if (line.find("years ago") != null){
							skiplinelimit = 5
						}
					skiplines ++
					if (skiplines > skiplinelimit) entry += line + "\n"
					
			}
		}
	}

	return entry
}

//
// Load the index for the given system if it is not already loaded
//
function af_load_index( sys )
{
	// check if system index already loaded
	//
	if ( af_loaded_idx.rawin( sys ) )
		return true

	local idx
	try
	{
		idx = file( af_idx_path + sys + ".idx", "r" )
	}
	catch( e )
	{
		af_loaded_idx[sys] <- null
		return false
	}

	af_loaded_idx[sys] <- {}

	while ( !idx.eos() )
	{
		local blb = idx.readblob( AF_READ_BLOCK_SIZE )
		while ( !blb.eos() )
		{
			local line = af_get_next_ln( blb )
			local bits = split( line, ";" )
			if ( bits.len() > 0 )
				(af_loaded_idx[sys])[bits[0]] <- bits[1].tointeger()
		}
	}

	return true
}

//
// Return the index the history.dat entry for the specified system and rom
//
function af_get_history_offset( sys, rom, alt, cloneof )
{
	foreach ( s in sys )
	{
		if (( af_load_index( s ) )
			&& ( af_loaded_idx[s] != null ))
		{
			if ( af_loaded_idx[s].rawin( rom ) )
				return (af_loaded_idx[s])[rom]
			else if ((alt.len() > 0 )
					&& ( af_loaded_idx[s].rawin( alt ) ))
				return (af_loaded_idx[s])[alt]
			else if ((cloneof.len() > 0 )
					&& ( af_loaded_idx[s].rawin( cloneof ) ))
				return (af_loaded_idx[s])[cloneof]
		}

	}

	if (( sys.len() != 1 ) || ( sys[0] != "info" ))
		return af_get_history_offset( ["info"], rom, alt, cloneof )

	return -1
}
