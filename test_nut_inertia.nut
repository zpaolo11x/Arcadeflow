/*
################################################################################

Attract-Mode Frontend - Inertia module v2.40
Adds animation to object's properties

by Oomek - Radek Dutkiewicz 2021
https://github.com/oomek/attract-extra

################################################################################


INITIALIZATION:
--------------------------------------------------------------------------------
object = Inertia( object, time, "property1", "property2", ... )



FUNCTION ARGUMENTS:
--------------------------------------------------------------------------------
object - any drawable, image, text, surface...

time - Time in milliseconds for the animation to complete

property - "x", "y", "width", "alpha", or any other property of the object


You can define all properties in one line,
or you can chain Inertia initializations

object = Inertia( object, time1, "property1", "property2" )
object = Inertia( object, time2, "property3", "property4" )

You can adjust time, or any other property later separately.



OBJECT PROPERTIES: ( examples for "x" property )
--------------------------------------------------------------------------------
to_x - Animates the x to the given value from the current x position

from_x - Animates the x from the given value to the x position set with to_x

x - Sets the x and resets the inertia

mass_x - Works only with Tween.Inertia
         defines the weight of an object 0.0 - 1.0 range. Default: 1.0

time_x - Time in milliseconds for the animation of the x property to complete.

tween_x - Available tween modes:

    Tween.Inertia - Default, Easing.Out only
    Tween.Linear
    Tween.Quad
    Tween.Cubic
    Tween.Quart
    Tween.Quint
    Tween.Expo
    Tween.Back
    Tween.Circle
    Tween.QuartSine - or Tween.Sine for compatibility
    Tween.HalfSine  - Easing.Out only
	Tween.FullSine  - Easing.Out only
    Tween.Bounce    - Easing.Out only
    Tween.Elastic   - Easing.Out only

easing_x - Available easing modes:

    Easing.Out - Default
    Easing.In
    Easing.OutIn
    Easing.InOut

tail_x - Additional time in ms for Tween.Bounce, Tween.Elastic

loop_x - When set to true the animation is looped until set back to false

delay_x - Delay before the animation starts in milliseconds



MULTIPLE PROPERTIES CHANGE:
--------------------------------------------------------------------------------

EXAMPLE 1:
----------
art = Inertia( art, 500, "width", "height" )

art.tween_all = Tween.Linear

is equivalent to:

art.tween_width = Tween.Linear
art.tween_height = Tween.Linear

EXAMPLE 2:
----------
art = Inertia( art, 500, "red", "green", "blue" )

art.set_all = 200

is equivalent to:

art.red = 200
art.green = 200
art.blue = 200

EXAMPLE 3:
----------
art = Inertia( art, 500, "red", "green", "blue" )

art.to_all = 200

is equivalent to:

art.to_red = 200
art.to_green = 200
art.to_blue = 200



EXAMPLES:
--------------------------------------------------------------------------------
fe.load_module("inertia")

local art = fe.add_artwork(...)
art = Inertia( art, 500, "x", "y", "width" )

Then in transitions you can control object's properties with:
art.to_x = 100    animates the x property to 100 from the current position
art.from_x = 200  animates the x property from 200 to the x position set with to_x
art.to_x += 200   advances the current x property by 200 pixels
art.x = 100       sets the x property to 100 and resets the inertia

art.time_x = 1000   sets the animation time of x property to 1000 milliseconds

art.running_x       returns true if x is still animating,
                    false if x reached to_x value

art.running         returns true if any of the properties is still animating,
                    false if all properties reached their to_ values

################################################################################
*/



class InertiaClass
{
	static VERSION = 2.40

	Mode = {} // table with binary flags for Tweens and Easings
	ModeName = {} // mode name look-up table
	Mask = {} // table with bitmasks for Tween, Easing and OutOnly labels
}

// Preserved compatibility with Animate module
// Converted to binary flags to avoid constant string operations
Tween <-
{
	Inertia = "inertia",
	Linear = "linear",
	Cubic = "cubic",
	Quad = "quad",
	Quart = "quart",
	Quint = "quint",
	Sine = "sine",
	QuartSine = "quartsine",
	HalfSine = "quartsine",
	FullSine = "fullsine",
	Expo = "expo",
	Circle = "circle",
	Elastic = "elastic",
	Back = "back",
	Bounce = "bounce"
}

// Preserved compatibility with Animate module
// Converted to binary flags to avoid constant string operations
Easing <-
{
	Out = "out",
	In = "in",
	OutIn = "outin",
	InOut = "inout"
}

class InertiaClass.Property
{
	name = null
	pos = null
	from = null
	to = null
	mode = null
	running = null
	time = null
	tail = null
	timer = null
	mass = null
	velocity = null
	inertia = null
	loop = null
	delay = null

	buffer = null
	coeff = null
}

function InertiaClass::Tween( p, t )
{
	local t2 = t
	local out = 0.0

	// Checks if tween mode is Easing.Out only
	if ( p.mode & ~Mask.OutOnly & Mask.Tween )
	{
		if ( p.mode & Mode.In ) t = 1.0 - t
		else if ( p.mode & Mode.InOut ) t = ::fabs( t * 2.0 - 1.0 )
		else if ( p.mode & Mode.OutIn ) t = 1.0 - ::fabs( t * 2.0 - 1.0 )
	}

	switch ( p.mode & Mask.Tween )
	{
		case Mode.Linear:
			out = 1.0 - t
			break

		case Mode.Cubic:
			out = ::pow( 1.0 - t, 3 )
			break

		case Mode.Quad:
			out = ::pow( 1.0 - t, 2 )
			break

		case Mode.Quart:
			out = ::pow( 1.0 - t, 4 )
			break

		case Mode.Quint:
			out = ::pow( 1.0 - t, 5 )
			break

		case Mode.Sine:
		case Mode.QuartSine:
			out = 1.0 - ::sin( t * ::PI * 0.5 )
			break

		case Mode.HalfSine:
			out = ::cos( t * ::PI ) * 0.5 + 0.5
			break

		case Mode.FullSine:
			out = ::cos( t * ::PI * 2.0 ) * 0.5 + 0.5
			break

		case Mode.Inertia:
		case Mode.Expo:
			local a = 1.0 - t
			a *= a
			a *= a
			local b = a * t
			a *= a
			out = a + b * 0.3
			break

		case Mode.Circle:
			out = 1.0 - ::sqrt( 1.0 - ::pow( t - 1.0, 2 ))
			break

		case Mode.Elastic:
			local e = 1.0 - t / ( p.tail / p.time + 1.0 )
			e *= e
			local i = e
			e *= e; e *= e
			e = 0.1 * ( i - e ) + e
			out = e * ::cos( t * ::PI * ( 2.0 - e ))
			break

		case Mode.Back:
			t = 1.0 - t
			out = t * t * t * ( t * 3.0 - 2.0 ) * ( 2.0 - t )
			break

		case Mode.Bounce:
			if ( p.timer < p.time ) return 1.0 - t * t
			local k = p.tail / p.time
			local n = 2.0 / k + 1.0
			local d = ( n - n * t + t + 1.0 ) * 0.5
			d = ::floor( ::log( d ) / ::log( n ))
			d = ::pow( n, d.tointeger() )
			out = -( d * k - k + t - 1.0 ) * ( d * k + d * 2.0 - k + t - 1.0 )
			break
	}

	// Checks if tween mode is Easing.Out only
	if ( p.mode & ~Mask.OutOnly & Mask.Tween )
	{
		if ( p.mode & Mode.In ) out = 1.0 - out
		else if ( p.mode & Mode.InOut )
		{
			if ( t2 > 0.5 ) out = out * 0.5
			else out = 1.0 - out * 0.5
		}
		else if ( p.mode & Mode.OutIn )
		{
			if ( t2 > 0.5 ) out = ( 1.0 - out ) * 0.5
			else out = 1.0 - ( 1.0 - out ) * 0.5
		}
	}

	return out
}

function InertiaClass::Inertia( p )
{
	local t = p.timer / p.time
	local b = p.buffer

	if ( t < 1.0 )
	{
		// Optimized pow( t, 8 )
		t *= t; t *= t; t *= t
		t = 1.0 - t

		// 3-pole lowpass filter
		local b = p.buffer
		b[0] += p.coeff * ( p.pos - b[0] )
		b[1] += p.coeff * ( b[0] - b[1] )
		b[2] += p.coeff * ( b[1] - b[2] )

		// Compensation of filter's infinite response
		b[0] = t * ( b[0] - p.pos ) + p.pos
		b[1] = t * ( b[1] - p.pos ) + p.pos
		b[2] = t * ( b[2] - p.pos ) + p.pos
	}
	else
	{
		b[0] = p.pos
		b[1] = p.pos
		b[2] = p.pos
	}

	return b[2]
}

function InertiaClass::SetSpeed( prop, time )
{
	// Converts tween time to filter coefficient
	prop.coeff = ::sin(( 4.0 * ::PI ) / ( 8.0 + ScreenRefreshRate * time * 0.000825 * prop.mass ))
}

function InertiaClass::Initialize()
{
	// Recreates Inertia speciffic Tweens in case the table was overriden by the Animate module
	if ( !( "inertia" in ::Tween ))
	{
		::Tween.Inertia <- "inertia"
		::Tween.QuartSine <- "quartsine"
		::Tween.HalfSine <- "halfsine"
		::Tween.FullSine <- "fullsine"
	}

	local shift = 0
	if ( Mode.len() == 0 )
	{
		// Converts modes to binary flags and constructs a bitmask for Tweens
		Mask.Tween <- 0
		foreach ( k, v in ::Tween )
		{
			ModeName.rawset( v, k )
			Mode.rawset( k, 1 << shift )
			Mask.Tween = Mask.Tween | ( 1 << shift )
			shift++
		}

		// Converts modes to binary flags and constructs a bitmask for Easings
		Mask.Easing <- 0
		foreach ( k, v in ::Easing )
		{
			ModeName.rawset( v, k )
			Mode.rawset( k, 1 << shift )
			Mask.Easing = Mask.Easing | ( 1 << shift )
			shift++
		}

		// Constructs a bitmask for Tweens that only support Easing.Out mode
		Mask.OutOnly <- Mode.Inertia | Mode.Bounce | Mode.Elastic | Mode.HalfSine | Mode.FullSine
	}
}

function InertiaClass::Compute( prop )
{
	local out = 0.0

	if ( prop.loop && prop.timer > prop.time ) prop.timer -= prop.time

	local tail = 0.0
	if ( prop.mode & ( Mode.Bounce | Mode.Elastic )) tail = prop.tail

	// Tween has finished
	if ( prop.timer > prop.time + tail && !prop.loop )
	{
		 // Tween.FullSine is the only tween that cycles back to its initial position
		if ( prop.mode & Mode.FullSine ) out = prop.from
		else out = prop.to
		prop.running = false
	}
	// Tween in progress
	else
	{
		local phase = prop.timer / prop.time
		out = Tween( prop, phase )
		out = prop.to - ( prop.to - prop.from ) * out
	}
	return out
}

class InertiaObj extends InertiaClass
{
	object = null
	props = null

	constructor ( _object, _time, vargv )
	{
		Initialize()

		if ( _object instanceof ::InertiaObj )
		{
			object = _object.object
			props = _object.props
		}
		else
		{
			object = _object
			props = {}
			::fe.add_ticks_callback( this, "on_tick" )
		}

		foreach ( p in vargv )
		{
			local prop = ::InertiaClass.Property()
			prop.name = p
			prop.pos = object[p].tofloat()
			prop.from = prop.pos
			prop.to = prop.pos
			prop.inertia = prop.pos
			prop.mode = Mode.Inertia
			prop.running = false
			prop.time = _time
			prop.tail = 0.0
			prop.timer = 0.0
			prop.mass = 1.0
			prop.velocity = 0.0
			prop.loop = false
			prop.delay = 0.0

			prop.buffer = ::array( 3, prop.pos )
			SetSpeed( prop, prop.time )

			props[p] <- prop
		}
	}

	function on_tick( tick_time )
	{
		foreach ( p in props )
		{
			p.timer += 1000.0 / ScreenRefreshRate
			if ( p.running && p.timer > 0.0 )
			{
				p.velocity = -p.inertia
				p.pos = Compute( p )

				if ( p.mode & Mode.Inertia )
					p.inertia = Inertia( p )
				else
					p.inertia = p.buffer[0] = p.buffer[1] = p.buffer[2] = p.pos

				p.velocity += p.inertia
				object[p.name] = p.inertia
			}
			else
				p.velocity = 0.0
		}
	}

	function _set( idx, val )
	{
		if ( idx in props )
		{
			// Resets inertia when property is set directly
			local p = props[idx]
			if ( p.running == true || val != p.inertia )
			{
				p.buffer[0] = val
				p.buffer[1] = val
				p.buffer[2] = val
				p.to = val
				p.from = val
				p.pos = val
				p.inertia = val
				p.velocity = 0.0
				p.timer = -p.delay
				p.running = false
				object[idx] = val
			}
			return null
		}

		if ( idx in object )
		{
			// It's a single word object's property
			object[idx] = val
			return null
		}

		local index = idx.find( "_" )
		local properties = {}
		local prefix = ""

		if ( index == null )
		{
			// Property is a single word
			object[idx] = val
			return null
		}
		else
		{
			// Property is a multi word
			prefix = idx.slice( 0, index )
			local p_name = idx.slice( index + 1 )

			if ( p_name == "all" )
			{
				// Set all properties with inertia assigned
				properties = props
			}
			else if ( !( p_name in props ))
			{
				// It's a multi word object's property
				object[idx] = val
				return null
			}
			else
			{
				// Set single property
				properties[p_name] <- props[p_name]
			}
		}

		switch( prefix )
		{
			case "set":
				// Resets inertia for all properties
				foreach ( p in properties )
				{
					if ( p.running == true || val != p.inertia )
					{
						p.buffer[0] = val
						p.buffer[1] = val
						p.buffer[2] = val
						p.to = val
						p.from = val
						p.pos = val
						p.inertia = val
						p.velocity = 0.0
						p.timer = -p.delay
						p.running = false
						object[p.name] = val
					}
				}
				return null

			case "time":
				foreach( p in properties )
				{
					p.time = val.tofloat()
					SetSpeed( p, p.time )
				}
				return null

			case "to":
				foreach( p in properties )
				{
					if ( val != p.to )
					{
						p.to = val
						p.from = p.pos
						p.running = true
						p.timer = -p.delay
					}
				}
				return null

			case "from":
				foreach( p in properties )
				{
					if ( p.mass == 0.0 )
					{
						p.from = val
						p.inertia = val
					}
					else
					{
						local b = p.buffer
						local delta = val - p.inertia
						p.from = delta + p.pos
						p.inertia += delta
						b[0] += delta
						b[1] += delta
						b[2] += delta
					}
					p.running = true
					p.timer = -p.delay
				}
				return null

			case "mass":
				foreach( p in properties )
				{
					p.mass = val < 0.0 ? 0.0 : val > 1.0 ? 1.0 : val
					SetSpeed( p, p.time )
				}
				return null

			case "tween":
				local t = Mode[ ModeName[ val ]]
				foreach( p in properties )
				{
					if ( t & ( Mode.Bounce | Mode.Elastic ))
					{
						if ( p.tail == 0.0 )
							p.tail = 1000.0
					}
					else
						p.tail = 0.0

					p.mode = p.mode & Mask.Easing | t
				}
				return null

			case "easing":
				local e = Mode[ ModeName[ val ]]
				foreach( p in properties )
					p.mode = p.mode & Mask.Tween | e
				return null

			case "tail":
				if ( val > 10000.0 ) val = 10000.0 // Limits tail to 10 seconds
				foreach( p in properties )
				{
					if ( p.mode & ( Mode.Bounce | Mode.Elastic ))
						p.tail = val.tofloat()
					else
						p.tail = 0.0
				}
				return null

			case "loop":
				foreach( p in properties )
				{
					if ( p.loop != val )
					{
						p.loop = val
						if ( p.running == false )
						{
							p.timer = -p.delay
							p.running = true
						}
					}
				}
				return null

			case "delay":
				foreach( p in properties )
				{
					if ( p.delay != val )
					{
						p.delay = val
						p.timer = -p.delay
					}
				}
				return null
		}

		// It's a fe drawable's property
		object[idx] = val
		return null
	}

	function _get( idx )
	{
		if ( idx in object )
			return object[idx]

		if ( idx == "running" )
		{
			foreach ( p in props )
				if ( p.running ) return true
			return false
		}

		local index = idx.find( "_" )

		if ( index == null )
		{
			return object[idx]
		}
		else
		{
			local prefix = idx.slice( 0, index )
			local p_name = idx.slice( index + 1 )

			switch( prefix )
			{
				case "running":
					return props[p_name].running

				case "time":
					return props[p_name].time

				case "to":
					return props[p_name].to

				case "from":
					return props[p_name].inertia

				case "mass":
					return props[p_name].mass

				case "tail":
					return props[p_name].tail

				case "loop":
					return props[p_name].loop

				case "delay":
					return props[p_name].delay

				case "velocity":
					return props[p_name].velocity
			}
		}

		return object[idx]
	}

	// Functions wrappers
	function swap( obj )
	{
		object.swap( obj )
	}

	function set_rgb( r, g, b )
	{
		object.set_rgb( r, g, b )
	}

	function set_bg_rgb( r, g, b )
	{
		object.set_bg_rgb( r, g, b )
	}

	function set_pos( x, y, width = null, height = null )
	{
		if ( !width && !height )
			object.set_pos( x, y )
		else
			object.set_pos( x, y, width, height )
	}

	function set_sel_rgb( r, g, b )
	{
		object.set_sel_rgb( r, g, b )
	}

	function set_selbg_rgb( r, g, b )
	{
		object.set_selbg_rgb( r, g, b )
	}

	function swap( other_img )
	{
		object.swap( other_img )
	}

	function fix_masked_image()
	{
		object.fix_masked_image()
	}

	function rawset_index_offset( offset )
	{
		object.rawset_index_offset( offset )
	}

	function rawset_filter_offset( offset )
	{
		object.rawset_filter_offset( offset )
	}
}

class InertiaVar extends InertiaClass
{
	prop = null

	constructor ( _val, _time )
	{
		Initialize()

		prop = ::InertiaClass.Property()
		prop.pos = _val
		prop.from = _val
		prop.to = _val
		prop.inertia = _val
		prop.mode = Mode.Inertia
		prop.running = false
		prop.time = _time
		prop.tail = 0.0
		prop.timer = 0.0
		prop.mass = 1.0
		prop.velocity = 0.0
		prop.loop = false
		prop.delay = 0.0

		prop.buffer = ::array( 3, _val )
		SetSpeed( prop, prop.time )

		::fe.add_ticks_callback( this, "on_tick_var" )
	}

	function on_tick_var( tick_time )
	{
		prop.timer += 1000.0 / ScreenRefreshRate
		if ( prop.running && prop.timer > 0.0 )
		{
			prop.velocity = -prop.inertia
			prop.pos = Compute( prop )
			if ( prop.mode & Mode.Inertia )
				prop.inertia = Inertia( prop )
			else
				prop.inertia = prop.pos
			prop.velocity += prop.inertia
		}
		else
			prop.velocity = 0.0
	}

	function _set( idx, val )
	{
		switch ( idx )
		{
			case "time":
				prop.time = val.tofloat()
				SetSpeed( prop, prop.time )
				return null

			case "to":
				if ( val == prop.to ) return null
				prop.to = val
				prop.from = prop.pos
				prop.running = true
				prop.timer = -prop.delay
				return null

			case "from":
				if ( prop.mass == 0.0 )
				{
					prop.from = val
					prop.inertia = val
				}
				else
				{
					local b = prop.buffer
					local delta = val - prop.inertia
					prop.from = delta + prop.pos
					prop.inertia += delta
					b[0] += delta
					b[1] += delta
					b[2] += delta
				}

				prop.running = true
				prop.timer = -prop.delay
				return null

			case "mass":
				prop.mass = val < 0.0 ? 0.0 : val > 1.0 ? 1.0 : val
				SetSpeed( prop, prop.time )
				return null

			case "tween":
				local t = Mode[ ModeName[ val ]]
				if ( t & ( Mode.Bounce | Mode.Elastic ))
				{
					if ( prop.tail == 0.0 )
						prop.tail = 1000.0
				}
				else
					prop.tail = 0.0

				prop.mode = prop.mode & Mask.Easing | t
				return null

			case "easing":
				local e = Mode[ ModeName[ val ]]
				prop.mode = prop.mode & Mask.Tween | e
				return null

			case "tail":
				if ( val > 10000.0 ) val = 10000.0 // Limits tail to 10 seconds
				if ( prop.mode & ( Mode.Bounce | Mode.Elastic ))
					prop.tail = val.tofloat()
				else
					prop.tail = 0.0
				return null

			case "loop":
				if ( prop.loop != val )
				{
					prop.loop = val
					if ( prop.running == false )
					{
						prop.timer = -prop.delay
						prop.running = true
					}
				}
				return null

			case "delay":
				prop.delay = val
				prop.timer = -prop.delay
				return null

			case "set":
				if ( prop.running == true || val != prop.inertia )
				{
					// Resets inertia
					prop.buffer[0] = val
					prop.buffer[1] = val
					prop.buffer[2] = val
					prop.to = val
					prop.from = val
					prop.pos = val
					prop.inertia = val
					prop.velocity = 0.0
					prop.timer = -prop.delay
					prop.running = false
				}
				return null
		}

		throw "Inertia: property " + idx + " not found\n"
	}

	function _get( idx )
	{
		switch ( idx )
		{
			case "running":
				return prop.running

			case "time":
				return prop.time

			case "to":
				return prop.to

			case "from":
				return prop.inertia

			case "mass":
				return prop.mass

			case "tail":
				return prop.tail

			case "loop":
				return prop.loop

			case "delay":
				return prop.delay

			case "velocity":
				return prop.velocity

			case "get":
				return prop.inertia
		}

		throw "Inertia: property " + idx + " not found\n"
	}
}

function Inertia(...)
{
	local obj = vargv.remove(0)
	local time = 1000.0

	if ( vargv.len() > 0 && typeof vargv[0] != "string" ) time = vargv.remove(0)

	if ( typeof obj == "integer" || typeof obj == "float" )
		return InertiaVar( obj, time )
	else
		return InertiaObj( obj, time, vargv )
}
