# Arcadeflow - Attract Mode theme by zpaolo11x - v 13.8 #

Arcadeflow is an horizontal scrolling, grid based theme for MAME, console and comptuer games, it supports multiple systems and is based on snapshots and game titles or on cartridge boxes / flyers. If you have video snaps they will appear over the selected thumbnail without sound, and you can open larger video preview with sound and game data in a separate "info" page. Multiple Displays are supported with a custom Displays Menu page.

Arcadeflow has some advanced features: you can sort game lists within Arcadeflow user interface, you can create filters on the fly, you can import history.dat and command.dat for richer info page, you can import RetroPie XML lists into AM romlists. It also features its own ScreenScraper backed scraping engine, metadata editor, and all games data are stored outside of the romlist so they are shared with all collection romlists.

The layout adapts to any different aspect ratios (5:4, 4:3, 16:9, 16:10 etc) automatically and reasonably well (external snaps get partially cut but not completely obscured) and a different layout is enabled for vertical aspect ratio.

For best results with thumbnails aspect ratio and cropping, Arcadeflow matches your emulator "System Identifier" to detect if the game has an LCD screen. For example if your System Identifier is "Game Boy" (or gameboy etc) it will be treated as LCD.

Arcadeflow is heavily configurable, please take some time to go through the option and you'll see you can tailor it to most of your needs.

## What's new in v 13.8 #

- Added support for pixel perfect fonts
- Correct UI elements alignment with pixels
- Fixed issue with number of rows in menus
- Fixed issue when converting romlist to db

## Emulator system identifier #

Arcadeflow is not only for arcades, it will work for console and computer games as well as handheld. To better suit each emulator you can add a System Identifier with the name of your console ("Game Boy", "Arcade", "Sega Genesis" etc) so some aspects of the GUI will adapt accordingly.

## Romlist management #

From version 12.0 Arcadeflow has a custom "database" where game data is stored. Game data can be derived by xml lists or AM scraper or AF scraper, if you regenerate the romlist from AF options menu all the data will be transferred to this database and will be shared with every collection romlist.
Arcadeflow can also "automatic" collection for all games, all computer games, all console games etc, this is an experimental feature that is off by default, but you can enable it in the options menu.

## Metadata and media scraping #

Arcadeflow can scrape metadata and/or media files from screenscraper.fr and from adb.arcadeitalia.net, you can scrape each romlist individualy and set different options. Be sure to enter your screenscraper.fr username and password so you can scrape more data.
Scraping match is crc based or filename based, you'll have "name" matches when the file name is identical, or "guess" matches when screenscraper finds a game but the rom name is not exactly the same.
You can stop the scraping process and restart later with only non scraped roms. In this case you can chose what kind of roms to scrape: missing or even non exact matches.
Scraping will overwrite your current romlist, while XML import will overwrite scraped data, but a scraper "cache" will be kept so you can re-scrape using "only missing" and rebuild your romlist from scraped data.

## RetroPie XML games list import #

Arcadeflow can be used to import XML lists generated in RetroPie format into Attract Mode romlists. Normally only Hyperlist based lists can be imported in Attract Mode specifying the path in the import_extras field in emulator configuration. If you specify a RetroPie romlist in that field, you can then build the Attract Mode romlist from Arcadeflow options menu.

## Custom controls #

When you hit the "select" or a "custom" control button (see layout options) an overlay context menu appears, here you can do different things to activate the following functions:

- "SELECT" launches the current game
- "UP" enters an "extension" game menu where you have different options:
- "More of the same..." search function, filtering games with the same year, manufacturer, main category or sub-category of the current game
- "Scrape selected game" is the same as the one in the options menu, but easier to use
- "Edit metadata" this is a metadata editor that you can use to fix metadata issues
- "DOWN" enters the "History" page where you can see and scroll the game history and see a larger game preview
- "LEFT" to enter the Tags menu
- "RIGHT" to add/remove favorites
- "ESC" goes back to the thumbnail list

## Metadata editor #

You can use Arcadeflow to edit metadat for games, this will not overwrite your current rom or scraped data, you can always fall back to the original data by entering an empty string for the metadata you changed. Metadata editor only alters metadata in Arcadeflow, it will not alter the romlist so you won't see those metadata in other layouts.

## General layout menu #

You can access a general menu by going "UP" from the first row of thumbnails. In the options you can disable this menu altogether or tie it to a "custom" button. This menu features:

- "Sort by..." to dynamically sort your game list
- "Multifilter" is a dynamic filtering system for your games
- "Filters" standard AM filters menu
- "Displays" menu enriched by Arcadeflow categorization, system logos etc.
- "Categories" will show you a simple menu of your categories
- "Search" function (see options)
- "Layout options" will allow you to edit Arcadeflow options
- "Attract Mode" to engage an attract mode without waiting the timeout
- "Snaps or Box-Art" to quickly change from screenshot view to box art view, this is persistent after AM relaunch
- "Reset Box Art" clears all preferences set with the above menu and reload the layout
- "Check for updates" can tell you if there's a new version, and even install it
- "About arcadeflow" some infos and news reagarding latest release

You can sort the menu entries and even disable them if you don't need them, for a cleaner look.

## Languages #

Arcadeflow is multi-language, and you can set the language in the options menu.

## Tags #

Arcadeflow has its own tags interface so you can generate new tags using the on-screen keyboard, but there's always a  "COMPLETED" tag available, if you add this to games you will see a "100%" stamp on the thumbnails
You can also show a tag icon on the games if a tag is present, and you can chose in the options to show the icon only for a specific tag.

## Sorting and scrolling #

When your list is sorted by name a large preview letter will appear while scrolling through the list.
If your list is sorted by year, manufacturer, system etc the year, manufacturer,system etc will appear instead of the letter.
You can go "DOWN" from the lower row to enter a "large jumps" scrolling mode which depends on the scrollbar preferences: it can do "page jumps" (one screen at a time) or "label jump" based on your list sort order, or both if you have "timeline" scrollbar activated.
Unique to Arcadeflow, you can also sort your games by last played or last added favourite.

## Displays Menu #

Arcadeflow sports a customizable Displays Menu. You can have it as a single list with just text, or you can let Arcadeflow add a system logo based on the Display name. Arcadeflow can categorize displays in groups automatically (Arcade, Console, Computer, Handheld, Pinball, Other), but if you want to force one display in a category, just add "#arcade", "#console" etc to the Display name. You can also enable artwork from the menu-art folder. You can also force positioning a layout at the top putting "!" at the beginning of the name.

## Search and Multifilter

Arcadeflow supports on-screen keyboard and "real" keyboard based search, search is applied on multiple fields and results can be updated while you type.
Multifilter is a powerful feature that allows you to create custom filters on the fly, filtering by name, brand, year etc, mixing multiple search fields. Multifilter menu voices can be sorted at will or disabled in the options.

## Layout options #

GENERAL
Define the main options of Arcadeflow like number of rows, general layout, control buttons, language, thumbnail source etc

- 'Layout language' : Chose the language of the layout
- 'Power menu' : Enable or disable power options in exit menu
- 'Rows in horizontal' : Number of rows to use in 'horizontal' mode
- 'Rows in vertical' : Number of rows to use in 'vertical' mode
- 'Clean layout' : Reduce game data shown on screen
- 'Low resolution' : Optimize theme for low resolution screens, 1 row layout forced, increased font size and cleaner layout
- 'Screen rotation' : Rotate screen
- 'Custom color' : Define a custom color for UI elements, R G B space separated
- 'Display Game Long Name' : Shows the part of the rom name with version and region data
- 'Display System Name' : Shows the System name under the game title
- 'Display Arcade System Name' : Shows the name of the Arcade system if available
- 'System Name as artwork' : If enabled, the system name under the game title is rendered as a logo instead of plain text
- 'Page jump size' : Page jumps are one screen by default, you can increase it if you want to jump faster
- 'Scrollbar style' : Select how the scrollbar should look
- 'Strip article from sort' : When sorting by Title ignore articles
- 'Enable sorting' : Enable custom realtime sorting, diable to keep romlist sort order
- 'Save sort order' : Custom sort order is saved through Arcadeflow sessions

BUTTONS
Define custom control buttons for different features of Arcadeflow

- 'Context menu button' : Chose the button to open the game context menu
- 'Utility menu button' : Chose the button to open the utility menu
- 'History page button' : Chose the button to open the history or overview page
- 'Thumbnail mode button' : Chose the button to use to switch from snapshot mode to box art mode
- 'Search menu button' : Chose the button to use to directly open the search menu instead of using the utility menu
- 'Category menu button' : Chose the button to use to open the list of game categories
- 'Multifilter menu button' : Chose the button to use to open the menu for dynamic filtering of romlist
- 'Volume button' : Chose the button to use to change system volume.
- 'Delete ROM button' : Chose the button to use to delete the current rom from the disk. Deleted roms are moved to a -deleted- folder

UTILITY MENU
Customize the utility menu entries that you want to see in the menu

- 'Customize Utility Menu' : Sort and select Utility Menu entries: Left/Right to move items up and down, Select to enable/disable item
- 'Reset Utility Menu' : Reset sorting and selection of Utility Menu entries

SCRAPE AND METADATA
You can use Arcadeflow internal scraper to get metadata and media for your games, or you can import XML data in EmulationStation format

- 'Scrape current romlist' : Arcadeflow will scrape your current romlist metadata and media, based on your options
- 'Scrape selected game' : Arcadeflow will scrape only metadata and media for current game
- 'Enable CRC check' : You can enable rom CRC matching (slower) or just name matching (faster)
- 'Rom Scrape Options' : You can decide if you want to scrape all roms, only roms with no scrape data or roms with data that don't pefectly match
- 'Scrape error roms' : When scraping you can include or exclude roms that gave an error in the previous scraping
- 'Media Scrape Options' : You can decide if you want to scrape all media, overwriting existing one, or only missing media. You can also disable media scraping
- 'Region Priority' : Sort the regions used to scrape multi-region media and metadata in order of preference
- 'Reset Region Table' : Reset sorting and selection of Region entries
- 'SS Username' : Enter your screenscraper.fr username
- 'SS Password' : Enter your screenscraper.fr password
- 'History.dat' : History.dat location.
- 'Index clones' : Set whether entries for clones should be included in the index. Enabling this will make the index significantly larger
- 'Generate History index' : Generate the history.dat index now (this can take some time)
- 'Bestgames.ini' : Bestgames.ini location for MAME.
- 'Import XML data for all romlists' : If you specify a RetroPie xml path into emulator import_extras field you can build the romlist based on those data
- 'Import XML data for current romlists' : If you specify a RetroPie xml path into emulator import_extras field you can build the romlist based on those data
- 'Prefer genreid categories' : If GenreID is specified in your games list, use that instead of usual categories
- 'Import only available roms' : Import entrief from the games list only if the rom file is actually available

ROMLIST MANAGEMENT
Manage romlists and collections

- 'Refresh current romlist' : Refresh the romlist with added/removed roms, won't reset current data
- 'Reset current romlist' : Rescan the romlist erasing and regenerating all romlist data
- 'Reset last played' : Remove all last played data from the current romlist
- 'Export to gamelist xml' : You can export your romlist in the XML format used by EmulationStation
- 'Enable all games collections' : If enabled, Arcadeflow will create All Games compilations
- 'Update all games collections' : Force the update of all games collections, use when you remove displays
- 'Enable rom delete' : Enable or disable the options to delete a rom

DISPLAYS MENU PAGE
Arcadeflow has its own Displays Menu page that can be configured here

- 'Enable Arcadeflow Displays Menu page' : If you disable Arcadeflow menu page you can use other layouts as displays menu
- 'Enable Fast Displays Change' : Disable fast display change if you want to use other layouts for different displays
- 'Generate display logo' : Generate displays name related artwork for displays list
- 'Sort displays menu' : Show displays in the menu in your favourite order
- 'Show group separators' : When sorting by brand show separators in the menu for each brand
- 'Displays menu layout' : Chose the style to use when entering displays menu, a simple list or a list plus system artwork taken from the menu-art folder
- 'Artwork Source' : Chose where the displays menu artwork comes from: Arcadeflow own system library or Attract Mode menu-art folder
- 'Enable category artwork' : You can separately enable/disable artwork for categories like console, computer, pinball etc.
- 'Categorized Displays Menu' : Displays menu will be grouped by system categories: Arcades, Computer, Handhelds, Consoles, Pinballs and Others for collections
- 'Add Exit Arcadeflow to menu' : Add an entry to exit Arcadeflow from the displays menu page
- 'Open the Displays Menu at startup' : Show Displays Menu immediately after launching Arcadeflow, this works better than setting it in the general options of Attract Mode
- 'Exit AF when leaving Menu' : The esc button from Displays Menu triggers the exit from Arcadeflow
- 'Enter Menu when leaving display' : The esc button from Arcadeflow brings the displays menu instead of exiting Arcadeflow

PERFORMANCE & FX
Turn on or off special effects that might impact on Arcadeflow performance

- 'Adjust performance' : Tries to adapt speed to system performance. Enable for faster scroll, disable for smoother but slower scroll
- 'Resolution W x H' : Define a custom resolution for your layout independent of screen resolution. Format is WIDTHxHEIGHT, leave blank for default resolution
- 'Raspberry Pi fix' : This applies to systems that gives weird results when getting back from a game, reloading the layout as needed
- 'Width %' : For screens with overscan, define which percentage of the screen will be filled with actual content
- 'Height %' : For screens with overscan, define which percentage of the screen will be filled with actual content
- 'Shift X %' : For screens with overscan, screen will be shifted by the percentage
- 'Shift Y %' : For screens with overscan, screen will be shifted by the percentage
- 'Low Spec mode' : Reduce most visual effects to boost speed on lower spec systems
- 'Smooth shadow' : Enable smooth shadow under game title and data in the GUI
- 'Glow effect' : Add a glowing halo around the selected game thumbnail
- 'Thumb gradient' : Blurs the artwork behind the game logo so it's more readable

THUMBNAILS
Chose the aspect ratio of thumbnails, video thumbnails and decorations

- 'Aspect ratio' : Chose wether you want cropped, square snaps or adaptive snaps depending on game orientation
- 'Morph snap ratio' : Chose if you want the box to morph into the actual game video or if it must be cropped
- 'Optimize vertical arcade' : Enable this option if you have 9:16 vertical artwork from the Vertical Arcade project
- 'Zoom thumbnails' : Chose if you want the selected thumbnail to zoom to a larger size
- 'Show only logos' : If enabled, only game tilte logos will be shown instead of the screenshot
- 'Snapshot artwork source' : Chose if you want the snapshot artwork from gameplay or title screen
- 'Show game title' : Show the title of the game over the thumbnail
- 'Box Art mode' : Show box art or flyers instead of screen captures by default (can be configured with menu or hotkey)
- 'Game title over box art' : Shows the game title artwork overlayed on the box art graphics
- 'Box Art artwork source' : Chose the artwork source for box art graphics
- 'Video thumbs' : Enable video overlay on snapshot thumbnails
- 'Fade title on video' : Fades game title and decoration when the video is playing
- 'Video delay multiplier' : Increase video load delay
- 'Generate missing title art' : If no game title is present, the layout can generate it
- 'Game not available indicator' : Games that are not available will be marked with a red cross overlay
- 'New game indicator' : Games not played are marked with a glyph
- 'Show tag indicator' : Shows a tag attached to thumbnails that contains any tag
- 'Custom tag name' : You can see a tag glyph overlayed to the thumbs, chose the tag name to use
- 'Game Boy color correction' : Apply a colorized palette to Game Boy games based on the system name or forced to your preference
- 'MSX crt color correction' : Apply a palette correction to MSX media that was captured with MSX2 palette

COLOR CYCLE
Enable and edit color cycling animation of tile highlight border

- 'Enable color cycle' : Enable/disable color cycling of the tile higlight border
- 'Cycle speed' : Select the speed of color cycle
- 'Cycle color' : Select a color intensity preset for the cycle
- 'Ping Pong effect' : Enable this if you want the cycle to revert once finished instead of restarting
- 'Start hue' : Define the start value of the hue cycle (0 - 359)
- 'Stop hue' : Define the stop value of the hue cycle (0 - 359)

BACKGROUND
Chose the layout background theme in main page and in History page, or select custom backgrounds

- 'Overlay color' : Setup theme luminosity overlay, Basic is slightly muted, Dark is darker, Light has a white overlay and dark text, Pop keeps the colors unaltered
- 'Custom overlay' : Insert custom PNG to be overlayed over everything
- 'Custom main BG image' : Insert custom background art path (use grey.png for blank background, vignette.png for vignette overlay)
- 'Format of main BG image' : Select if the custom background must be cropped to fill the screen or stretched
- 'Custom history BG image' : Insert custom background art path for history page (leave blank if the same as main background)
- 'Format of history BG image' : Select if the custom background must be cropped to fill the screen or stretched
- 'Background snap' : Add a faded game snapshot to the background
- 'Animate BG snap' : Animate video on background
- 'Delay BG animation' : Don't load immediately the background video animation
- 'Per Display background' : You can have a different background for each display, just put your pictures in menu-art/bgmain and menu-art/bghistory folders named as the display

LOGO
Customize the splash logo at the start of Arcadeflow

- 'Enable splash logo' : Enable or disable the AF start logo
- 'Custom splash logo' : Insert the path to a custom AF splash logo (or keep blank for default logo)

ATTRACT MODE
Arcadeflow has its own attract mode screensaver that kicks in after some inactivity. Configure all the options here

- 'Enable attract mode' : Enable or disable attract mode at layout startup
- 'Attract mode timer (s)' : Inactivity timer before attract mode is enabled
- 'Game change time (s)' : Time interval between each game change
- 'Attract logo' : Show Arcadeflow logo during attract mode
- 'Attract message' : Text to show during attract mode
- 'Background music' : Path to a music file to play in background
- 'Enable game sound' : Enable game sounds during attract mode

SEARCH & FILTERS
Configure the search page and multifilter options

- 'Immediate search' : Live update results while searching
- 'Keyboard layout' : Select the keyboard layout for on-screen keyboard
- 'Save Multifilter sessions' : Save the Multifilter of each display when exiting Arcadeflow or changing list
- 'Customize Multifilter Menu' : Sort and select Multifilter Menu entries: Left/Right to move items up and down, Select to enable/disable item
- 'Reset Multifilter Menu' : Reset sorting and selection of Multifilter Menu entries

HISTORY PAGE
Configure the History page where larger thumbnail and game history data are shown

- 'CRT deformation' : Enable CRT deformation for CRT snaps
- 'Scanline effect' : Select scanline effect: Scanlines = default scanlines, Aperture = aperture mask, Half Resolution = reduced scanline resolution to avoid moiree, None = no scanline
- 'LCD effect' : Select LCD effect for handheld games: Matrix = see dot matrix, Half Resolution = see matrix at half resolution, None = no effect
- 'Text panel size' : Select the size of the history panel at the expense of snapshot area
- 'Text panel style' : Select the look of the history text panel
- 'Game panel style' : Select the look of the history game panel
- 'Detailed game data' : Show extra data after the game name before the history text
- 'Control panel overlay' : Show controller and buttons overlay on history page

MULTIPLE MONITOR
Configure the appearence of a second monitor

- 'Enable multiple monitor' : Enable Arcadeflow multiple monitor suport
- 'Monitor identifier' : Select the identification number for the external monitor
- 'Correct aspect ratio' : Select if the image on the second monitor should be stretched or not
- 'Main media source' : Select the artwork source to be used on secondary monitor
- 'Alternate media source' : Select the artwork source to be used on secondary monitor in case first one is not present

AUDIO
Configure layout sounds and audio options for videos

- 'Enable theme sounds' : Enable audio sounds when browsing and moving around the theme
- 'Audio in videos (thumbs)' : Select wether you want to play audio in videos on thumbs
- 'Audio in videos (history)' : Select wether you want to play audio in videos on history detail page
- 'Layout background music' : Chose a background music file to play while using Arcadeflow
- 'Randomize background music' : If this is enabled, Arcadeflow will play a random mp3 from the folder of the selected background music
- 'Stop bg music in attract mode' : Stops playing the layout background music during attract mode

UPDATES
Configure update notifications

- 'Automatically check for updates' : Will check for updates at each AF launch, if you dismiss one update you won't be notified until the next one
- 'Install update after download' : Arcadeflow allows you to chose if you just want to download updates, or if you want to install them directly

SAVE & LOAD
Save or reload options configurations

- 'Save current options' : Save the current options configuration in a custom named file
- 'Load options from external file' : Restore AF options from a previously saved file

DEBUG
This section is for debug purposes only

- 'FPS counter' : DBGON FPS COUNTER
- 'DEBUG mode' : Enter DBGON mode, increased output logging
- 'AM options page' : Shows the default Attract-Mode options page
- 'Generate readme file' : For developer use only...
- 'Reset all options' : Restore default settings for all layout options, erase sorting options, language options and thumbnail options

## Previous versions history #

*v13.7*

- Added support for multi-monitor setups
- Fixed issue with CRC check of large files on Windows

*v13.6*

- Added new systems: GP32, Game Master
- Reorganised project files

*v13.5*

- Fixed issues with the update routine on Windows

*v13.4*

- Fixed issues with scraper

*v13.3*

- Added new GitHub based update routine
- Reorganised code and folder structure
- Code cleanup

*v13.2*

- Scraping matches roms regardless of WHDLoad version
- Fixed bug with customised utility menu

*v13.1*

- Fixed crc scraping not working when $HOME in rompath
- Fixed "/" breaking game name
- Added warnings for attract.cfg options

*v13.0*

- Added 11 new systems images and logos
- Fixed bugs in display change routine
- Fixed naming of XBox backgrounds
- Fixed bug with non categorised display menu

*v12.9*

- Fixed bug in scraped media folders
- Fixed slow display changing with collections
- Fixed bugs in Region multifilter
- Made multifilter routines more robust

*v12.8*

- Added sliders and graphical feedback for options
- Added option to multifilter by region
- Fixed bug in rating multifilter
- Fixed bug in sorting by rating

*v12.7*

- Added new Naomi related systems and arcade systems
- Added key repeat in keyboard
- Added workdir support in scraper
- Volume control responds to left/right keys
- Centered game title in "clean" layout
- Fixed issue with "clean" layout mode

*v12.6*

- Redesigned history panel with metadata
- Redesigned volume control menu
- Fixed famicom logo that crashed AM
- Fixed scraping issue from ScreenScraper
- Fixed issue with arcade commands

*v12.5*

- Changed the layout boot logo
- Added option and hotkey for volume control
- Added Jaguar CD, C16 and PET systems
- Added an option to customise the UI color
- Added options to shift the area on overscan screen
- Added progress bar when opening layout
- Fixed bugs with overscan centering
- Fixed font rendering for letter boxes

*v12.4*

- Redesigned some system walls
- Added new systems with logos and images
- Fixed bugs in the database generation

*v12.3*

- Added a new context menu to find similar games
- Added an option to reset "last played" data from romlist
- Added new artwork for systems in the displays menu
- Changed the look of the displays menu with artwork
- Fixed issue when refreshing romlists under Linux
- Fixed month numbers starting from "0" instead of "1"
- Fixed AF not deleting roms in Windows 10

*v12.2*

- Fixed bug in update of all games collections
- Fixed issue where collections wouldn't show in menu
- Fixed issue with last played collection filter
- Fixed issue with last line of attract.cfg being stripped
- Fixed bug crashing the database when game title has apices

*v12.1*

- Fixed issue with romlist generation at start
- Fixed paths in commands to delete roms
- Add icons for more than 4 players
- Added new collections for last played and favourite games

*v12.0*

- Introduced a new romlist management system
- - Collections syncronised with source romlists
- - Romlist data is transferred to a "database" holding all games data
- Added an option to add "all games" collections automatically
- Added an embedded command.dat database for arcade games
- Multifilter now shows correct number of games for each selection
- Added scrape status to Multifilter entries
- Improved and faster single game scraping
- Fixed scrolling bugs when reaching begin of list
- Added 40 new manufacturer logos

*v11.0*

- Added multiple selection menus for editing metadata
- Metadata edits are tranferred to "collection" romlists
- Improved keyboard design and layout
- Fixed bug that saved metadata only on the boot display
- Fixed "Delete Rom File" menu that now actually works

*v10.9*

- Added AttractMode+ compatibility
- Added new metadata editor for games
- Added new extension to contextual menu
- Added option to disable AF custom sorting
- Added option to optimise layout for Vertical Arcade artwork
- Improved surface stack for AM+
- Improved label rendering engine
- Fixed timing of history scroll to avoid jumps
- Fixed issue when fading background snaps
- Fixed issue with command.dat file

*v10.8*

- Fixed Hesware supplier logo
- Added Bandai Namco and 80 more supplier logos

*v10.7*

- Added options te enable tile border color cycling
- Added option to show only game titles instead of thumbnails

*v10.6*

- Added options to specify overscan screen width and height
- Added Nintendo VS System and generic arcade Nintendo logo
- Fixed power menu not showing in some cases
- Fixed scraper support for $PROGDIR variable

*v10.5*

- Fixed excessive tile jump when changing list
- Fixed rating when using external bestgames.ini
- Added scraper support for relative artowrk and games paths
- Added a utility menu entry to quick show only favourites
- Added system logos for Naomi GD-ROM and Sega Hikaru
- Added a power menu option in the exit menu
- Updated the sound of tiles scrolling
- Updated italian translation

*v10.4*

- Introduced smoother tile scrolling with ease in
- Added ADB scraping for arcade games
- Added option to reduce or disable tile zoom
- Fixed sort order bug
- Fixed urlencode bug in scraper
- Commands data can be obtained by scraped data
- Changed frost transparency in multifilter menu

*v10.3*

- Added fix for thread limits on screenscraper
- Added option to cutomise page jump
- Added fading and zooming of Filter name
- Added an option to color correct MSX games
- Updated thumbnail gradient shader and effect
- Updated spanish translation thanks to Jate from the forum
- Fixed orientation of Atari Lynx games
- Fixed letters rendering in labels list
- Fixed bugs in tags and favourites in Windows
- Fixed bug in overview description
- Fixed issues with parallel scraping on Windows

*v10.2*

- Changed CRC algorithm to improve speed
- Parallel metadata scraping to improve speed
- Parallel download of scraped media
- Improved parse speed of scrape cache
- Added German language translation thanks to ScherzKeks
- Added option to play random music from folder
- Fixed bug that crashed AM with background music
- Cleaner font for options description

*v10.1*

- Added rom scraping with CRC check
- Added support for arcade games scraping
- Added option to scrape a single game
- Added options to filter by arcade system if available
- Removed options for mame series.ini, unnecessary since AM 2.6.1
- Fixed character correction bug in scraper
- Fixed bug with multifilter update
- Fixed issues with curl and scraping on Windows

*v10.0*

- DON'T AUTO-INSTALL!
- Changed archive format to zip, use manual installation
- Added screenscraper.fr support for scraping media and metadata
- Added options to use images for Displays Menu categories
- Fixed description bug in options menu

*v9.9*

- Improved shaders and layering to reduce load time
- Added new system logos and images (IBM PC, Coleco Adam, Sega SC-3000, Philips Videopac, SAM coupe etc)
- Added 8 new manufacturer logos
- You can now save a set of preferences and recall it
- Fixed bug with lcd coloring in history page
- Fixed some sound playing even if disabled
- Fixed performance issue with off-screen fonts
- Fixed XML import for game names with "."

*v9.8*

- Added an option for importing the XML list only from current romlist
- XML data import works also for collections
- Collection romlists now share tags, favourite and run data with original romlists
- Added an option to chose the image source for Displays Menu page
- Added an option to fix an issue with Raspberry Pi
- Added more categories icons
- Added new manufacturer icons (1125 icons total)
- Improved shader performance for frosted glass effect
- Fixed issue with buttons overlay
- Fixed issue with sorting menu

*v9.7*

- Added option to generate romlists based on RetroPie XML files
- Improved category recognition and management
- Fixed some system logos not showing correctly
- Fixed bug when list contains no entry
- Prevent input when checking for updates
- Fixed bug in tags management

*v9.6*

- Fixed bugs in displays menu
- Fixed window popping up during check for updates
- Improved fade in and fade out transitions
- Fixed issue with some system names
- Fixed size of non-available games red cross
- Added an option to enable/disable missing games highlight
- Added Famicom Disk System and Daphne logos
- Auto update will only check once a day

*v9.5*

- In options menu you can use left and right to change options
- Fixed "Exit from Arcadeflow" menu not centered
- Fixed bug with text size in vertical mode
- Fixed bugs in displays menu sorting and grouping
- Improved text wrap in menu items with long strings
- Default displays sorting by brand/name
- Revamped the displays management backedn
- Displays categories can be user defined

*v9.4*

- Fixed a bug with "Next/Prev Letter" hotkey response
- New "Jump To" menu entry to jump to letters or sort targets
- New memu system with highlight of selected options
- Fixed bugs in category menu and multifilter menu
- Fixed bugs in game launch routines
- New menu headers for sections
- Fixed an issue when entries in a list are linking to displays
- Added ScummVM ans Nintendo Switch system
- Added new manufacturer logos

*v9.3*

- Added "Neo Geo CD", "Odissey 2", "Atari 5200", "PC Engine Duo", "Nintendo DSi", "Acorn Aquarius", "Game Boy Micro"
- Added "Genesis 2", "Super Nintendo Entertainment System EU", "Master System 2", "Turbo Duo" variants
- Fixed bug in the multifilter customizing menu
- Fixed bugs with aspect ratio detection

*v9.2*

- Added options to import series.ini and bestgames.ini for MAME games
- Added series and rating data in history page
- You can now sort by rating or by series
- Multifilter can now filter ratings and series
- Added series and rating to "More of the same..." menu
- Improved "More of the same..." stability
- Fixed bug in controls multifilter entry
- Improved filtering speed with large romlists

*v9.1*

- Added an option to hide logo during screensaver
- Fixed auto-update installation routine
- Fixed bugs with system AR
- Added visual cue for non avilable games

*v9.0*

- Fixed bug in the background crop routine
- Added an option to disable Arcadeflow "fast" display switching
- Fixed display switching when one display is not using Arcadeflow as layout
- Changed the way frosted glass effect is generated
- Changed positioning of tiles to get better balance and avoid overlap with title
- Fixed overlapping labels in timeline scroll bar

*v8.9*

- New color palette for Game Boy screenshots
- Added new option to sort displays by system brand or sistem release year
- Fixed issues with changing displays when some display is not "in cycle"
- Fixed auto update routine for windows systems
- Highlighted snap zooms out when you enter scrollbar
- Displays names starting with "!" will always be at the top of the list
- New option to add an overlay on top of the layout

*v8.8*

- New sorting routine improves speed in sorting large lists
- Increased delay to avoid fade-in of video snaps
- Added tweak to fix Game Gear games aspect ratio
- Fixed history page videos aspect ratios
- New color remap for grayscale LCD snapshots
- Added color correction shaders for GBA games
- WonderSwan game snaps are orientation sensitive
- Fixed aspect correction for snap background
- New options to enable/disable CRT geometry
- You can assign an HIDDEN tag to hide games from the list
- General bug fixes

*v8.7*

- Introduced free aspect ratio for game snaps and box art
- Added an option to morph box art into game video
- Cleaned up code to make it more streamlined
- Fixed a bug that kept updating decorations when not necessary
- Added mipmap to glow effect to simplify shaders
- Added an option to disable displays menu page completely

*v8.6*

- Fixed bugs in the automatic update routine

*v8.5*

- Added system logos for Atomiswave, Sega Model 2 and 3
- Added an option to fade out game decoration when video is played
- Fixed a bug that showed black box on some videos
- Fixed a bug that prevented videos from starting at launch time
- If no video is present, the thumbnail gradient is not faded out
- Reorganized some code to improve stability

*v8.4*

- Bug fixes in the command.dat parser
- Added new option to reduce the video delay load
- Added option to hide the game title over the snapshot
- Slightly darker "Dark" theme
- Fixed vertical centering of thumbnails
- Added options to stretch custom background instead of crop
- Changed starting directory when browsing for background

*v8.3*

- Added an option to chose the size of the text panel in history
- Changed the way the history panel size is calculated
- Fixed a bug in utility menu options page
- Added options to sort utility menu entries
- Added options to customize the multifilter menu
- Fixed history.dat parsing for new dat files
- Added option to read command.dat for MAME
- Added option to show overlay commands in history page
- Revised translations and completed spanish translation by Jate
- Better rendition of Atari 2600 in attract mode

*v8.2*

- Added an option to enable/disable adaptive performance
- Added new display category: Pinball
- Added new system logos (Sega CD, Nintendo 3DS, Pinball FX3, Future Pinball)
- Added an option to enable/disable display name sorting
- New option to reduce the game data in history page
- Attract mode videos are scaled to native game resolution
- Attract mode games shown only from "filtered" list
- Improved routine to update attract.cfg
- Thumb video stops playing when entering history page
- New "Utility Menu" options to enable/disable menu entries

*v8.1*

- Added new manufacturers logos
- Added system logos for Cave and general board manufacturers like Sega, Taito, Capcom
- When entering Displays submenu the current display is preselected
- Give feedback to the user when no update is available after check for updates
- Fixed bug in multifilter glyph display routine
- Tweaked check for updates to avoid shell popup in Windows

*v8.0*

- Changed the QWERTY keyboard layout for better jump between key rows
- Added AZERTY keyboard layout in options
- Games can be sorted by last played date
- Games can be sorted by latest added favourite
- New "Check for updates" system to be notified when a new version is available
- It is now possible to download and install new versions automatically
- Added "About Arcadeflow" with the latest news

