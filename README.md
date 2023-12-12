# Arcadeflow - Attract Mode theme by zpaolo11x - v 16.6 #

Arcadeflow is an horizontal scrolling, grid based theme for MAME, console and comptuer games, it supports multiple systems and is based on snapshots and game titles or on cartridge boxes / flyers. If you have video snaps they will appear over the selected thumbnail without sound, and you can open larger video preview with sound and game data in a separate "info" page. Multiple Displays are supported with a custom Displays Menu page.

Arcadeflow has some advanced features: you can sort game lists within Arcadeflow user interface, you can create filters on the fly, you can import history.dat and command.dat for richer info page, you can import RetroPie XML lists into AM romlists. It also features its own ScreenScraper backed scraping engine, metadata editor, and all games data are stored outside of the romlist so they are shared with all collection romlists.

The layout adapts to any different aspect ratios (5:4, 4:3, 16:9, 16:10 etc) automatically and reasonably well (external snaps get partially cut but not completely obscured) and a different layout is enabled for vertical aspect ratio.

For best results with thumbnails aspect ratio and cropping, Arcadeflow matches your emulator "System Identifier" to detect if the game has an LCD screen. For example if your System Identifier is "Game Boy" (or gameboy etc) it will be treated as LCD.

Arcadeflow is heavily configurable, please take some time to go through the option and you'll see you can tailor it to most of your needs.

## What's new in v 16.6 #

- Added Sega Model 1, PGM, PGM2 and Namco System 2x6
- Added Pippin, Wondermega, Genesis CDX, Multi-Mega, V Smile, CreatiVision, Action Max and uZebox
- Added N-Gage, Game Pocket Computer, Pocket Challenge V2, Gamate, GameKing
- Added MSX 2+, C 65, ZX80, Alice, ABC80, MicroBee, Videoton TVC
- Added per-display overlay
- Fixed issues with overlay z-order

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

## RetroPie XML games list import #

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
Displays menu is categorised, but if you add #MENU at the end od a display name, it will show in the main menu with categories and not in the submenus.

## Search and Multifilter #

Arcadeflow supports on-screen keyboard and "real" keyboard based search, search is applied on multiple fields and results can be updated while you type.
Multifilter is a powerful feature that allows you to create custom filters on the fly, filtering by name, brand, year etc, mixing multiple search fields. Multifilter menu voices can be sorted at will or disabled in the options.

## Layout options #

#### GENERAL
Define the main options of Arcadeflow like number of rows, general layout, control buttons, language, thumbnail source etc

- 'Layout language' : Chose the language of the layout
- 'Power and Exit menu' : Customise exit menu with power options

*Layout*
- 'Rows in horizontal' : Number of rows to use in 'horizontal' mode
- 'Rows in vertical' : Number of rows to use in 'vertical' mode
- 'Clean layout' : Reduce game data shown on screen
- 'Small screen' : Optimize theme for small size screens, 1 row layout forced, increased font size and cleaner layout
- 'Custom color' : Define a custom color for UI elements using sliders

*Game Data*
- 'Display Game Long Name' : Shows the part of the rom name with version and region data
- 'Display System Name' : Shows the System name under the game title
- 'Display Arcade System Name' : Shows the name of the Arcade system if available
- 'System Name as artwork' : If enabled, the system name under the game title is rendered as a logo instead of plain text

*Scroll & Sort*
- 'Page jump size' : Page jumps are one screen by default, you can increase it if you want to jump faster
- 'Scrollbar style' : Select how the scrollbar should look
- 'Scroll updates' : Immediately updates the tiles while you scroll
- 'Strip article from sort' : When sorting by Title ignore articles
- 'Enable sorting' : Enable custom realtime sorting, diable to keep romlist sort order
- 'Save sort order' : Custom sort order is saved through Arcadeflow sessions

#### THUMBNAILS
Chose the aspect ratio of thumbnails, video thumbnails and decorations

- 'Aspect ratio' : Chose wether you want cropped, square snaps or adaptive snaps depending on game orientation
- 'Morph snap ratio' : Chose if you want the box to morph into the actual game video or if it must be cropped
- 'Optimize vertical arcade' : Enable this option if you have 9:16 vertical artwork from the Vertical Arcade project
- 'Zoom thumbnails' : Chose if you want the selected thumbnail to zoom to a larger size
- 'Show only logos' : If enabled, only game title logos will be shown instead of the screenshot

*Snapshot Options*
- 'Artwork source' : Chose if you want the snapshot artwork from gameplay or title screen
- 'Show game title' : Show the title of the game over the thumbnail

*Box Art Options*
- 'Box Art mode' : Show box art or flyers instead of screen captures by default (can be configured with menu or hotkey)
- 'Game title over box art' : Shows the game title artwork overlayed on the box art graphics
- 'Artwork source' : Chose the artwork source for box art graphics

*Video Snaps*
- 'Video thumbs' : Enable video overlay on snapshot thumbnails
- 'Fade title on video' : Fades game title and decoration when the video is playing
- 'Video delay multiplier' : Increase video load delay
- 'Generate missing title art' : If no game title is present, the layout can generate it
- 'Vertical arcade videos' : Enable this option if you are using 9:16 videos from the Vertical Arcade project

*Decorations*
- 'Game not available indicator' : Games that are not available will be marked with a red cross overlay
- 'New game indicator' : Games not played are marked with a glyph
- 'Show tag indicator' : Shows a tag attached to thumbnails that contains any tag
- 'Custom tag name' : You can see a tag glyph overlayed to the thumbs, chose the tag name to use
- 'Game Boy color correction' : Apply a colorized palette to Game Boy games based on the system name or forced to your preference
- 'MSX crt color correction' : Apply a palette correction to MSX media that was captured with MSX2 palette

#### ! BACKGROUND !
Chose the layout background theme in main page and in History page, or select custom backgrounds

- 'Color theme' : Setup background color theme, Basic is slightly muted, Dark is darker, Light has a white overlay and dark text, Pop keeps the colors unaltered
- 'Custom overlay' : Insert custom PNG to be overlayed over everything
- 'Custom main BG image' : Insert custom background art path (use grey.png for blank background, vignette.png for vignette overlay)
- 'Format of main BG image' : Select if the custom background must be cropped to fill the screen or stretched

*History BG*
- 'Custom history BG image' : Insert custom background art path for history page (leave blank if the same as main background)
- 'Format of history BG image' : Select if the custom background must be cropped to fill the screen or stretched

*BG Snaps*
- 'Background snap' : Add a faded game snapshot to the background
- 'Animate BG snap' : Animate video on background
- 'Delay BG animation' : Don't load immediately the background video animation

*Per Display*
- 'Per Display background' : You can have a different background for each display, just put your pictures in menu-art/bgmain and menu-art/bghistory folders named as the display
- '! Per Display overlay !' : You can have a different overlay for each display, just put your pictures in menu-art/overmain folder named as the display

#### LOGO
Customize the splash logo at the start of Arcadeflow

- 'Enable splash logo' : Enable or disable the AF start logo
- 'Custom splash logo' : Insert the path to a custom AF splash logo (or keep blank for default logo)

#### COLOR CYCLE
Enable and edit color cycling animation of tile highlight border

- 'Enable color cycle' : Enable/disable color cycling of the tile higlight border

*Cycle Options*
- 'Cycle speed' : Select the speed of color cycle
- 'Cycle color' : Select a color intensity preset for the cycle
- 'Ping Pong effect' : Enable this if you want the cycle to revert once finished instead of restarting
- 'Start hue' : Define the start value of the hue cycle (0 - 359)
- 'Stop hue' : Define the stop value of the hue cycle (0 - 359)

#### AUDIO
Configure layout sounds and audio options for videos

- 'Enable theme sounds' : Enable audio sounds when browsing and moving around the theme
- 'Audio in videos (thumbs)' : Select wether you want to play audio in videos on thumbs
- 'Audio in videos (history)' : Select wether you want to play audio in videos on history detail page
- 'Layout background music' : Chose a background music file to play while using Arcadeflow
- 'Randomize background music' : If this is enabled, Arcadeflow will play a random mp3 from the folder of the selected background music
- 'Per display background music' : If this is enabled, Arcadeflow will play the music file that has the same name as the current display
- 'Stop bg music in attract mode' : Stops playing the layout background music during attract mode

#### BUTTONS
Define custom control buttons for different features of Arcadeflow

- 'Context menu button' : Chose the button to open the game context menu
- 'Utility menu button' : Chose the button to open the utility menu
- 'History page button' : Chose the button to open the history or overview page
- 'Thumbnail mode button' : Chose the button to use to switch from snapshot mode to box art mode

*Search and Filters*
- 'Search menu button' : Chose the button to use to directly open the search menu instead of using the utility menu
- 'Category menu button' : Chose the button to use to open the list of game categories
- 'Multifilter menu button' : Chose the button to use to open the menu for dynamic filtering of romlist
- 'Show favorites button' : Chose the button to use to toggle favorite filtering

*Sound*
- 'Volume button' : Chose the button to use to change system volume

*ROM Management*
- 'Delete ROM button' : Chose the button to use to delete the current rom from the disk. Deleted roms are moved to a -deleted- folder

#### UTILITY MENU
Customize the utility menu entries that you want to see in the menu

- 'Customize Utility Menu' : Sort and select Utility Menu entries: Left/Right to move items up and down, Select to enable/disable item
- 'Reset Utility Menu' : Reset sorting and selection of Utility Menu entries

#### DISPLAYS MENU PAGE
Arcadeflow has its own Displays Menu page that can be configured here

- 'Enable Arcadeflow Displays Menu page' : If you disable Arcadeflow menu page you can use other layouts as displays menu
- 'Enable Fast Displays Change' : Disable fast display change if you want to use other layouts for different displays

*Look and Feel*
- 'Generate display logo' : Generate displays name related artwork for displays list
- 'Sort displays menu' : Show displays in the menu in your favourite order
- 'Show group separators' : When sorting by brand show separators in the menu for each brand
- 'Displays menu layout' : Chose the style to use when entering displays menu, a simple list or a list plus system artwork taken from the menu-art folder
- 'Artwork source' : Chose where the displays menu artwork comes from: Arcadeflow own system library or Attract Mode menu-art folder
- 'Enable category artwork' : You can separately enable/disable artwork for categories like console, computer, pinball etc.
- 'Categorized Displays Menu' : Displays menu will be grouped by system categories: Arcades, Computer, Handhelds, Consoles, Pinballs and Others for collections
- 'Add Exit Arcadeflow to menu' : Add an entry to exit Arcadeflow from the displays menu page

*Behavior*
- 'Open on current category' : With categorised displays menu, open in the current category instead of main menu
- 'Open the Displays Menu at startup' : Show Displays Menu immediately after launching Arcadeflow, this works better than setting it in the general options of Attract Mode
- 'Exit AF when leaving Menu' : The esc button from Displays Menu triggers the exit from Arcadeflow
- 'Enter Menu when leaving display' : The esc button from Arcadeflow brings the displays menu instead of exiting Arcadeflow

#### HISTORY PAGE
Configure the History page where larger thumbnail and game history data are shown


*Video Effects*
- 'CRT deformation' : Enable CRT deformation for CRT snaps
- 'Scanline effect' : Select scanline effect: Scanlines = default scanlines, Aperture = aperture mask, Half Resolution = reduced scanline resolution to avoid moiree, None = no scanline
- 'LCD effect' : Select LCD effect for handheld games: Matrix = see dot matrix, Half Resolution = see matrix at half resolution, None = no effect

*Layout*
- 'Text panel size' : Select the size of the history panel at the expense of snapshot area
- 'Text panel style' : Select the look of the history text panel
- 'Game panel style' : Select the look of the history game panel
- 'Text scroll' : Select if you want to manually scroll history text, or automatically scroll
- 'Detailed game data' : Show extra data after the game name before the history text
- 'Control panel overlay' : Show controller and buttons overlay on history page

#### ATTRACT MODE
Arcadeflow has its own attract mode screensaver that kicks in after some inactivity. Configure all the options here

- 'Enable attract mode' : Enable or disable attract mode at layout startup

*Look & Feel*
- 'Attract mode timer (s)' : Inactivity timer before attract mode is enabled
- 'Game change time (s)' : Time interval between each game change
- 'Attract logo' : Show Arcadeflow logo during attract mode
- 'Attract message' : Text to show during attract mode

*Sound*
- 'Background music' : Path to a music file to play in background
- 'Enable game sound' : Enable game sounds during attract mode

#### PERFORMANCE & FX
Turn on or off special effects that might impact on Arcadeflow performance

- 'Adjust performance' : Tries to adapt speed to system performance. Enable for faster scroll, disable for smoother but slower scroll
- 'Resolution W x H' : Define a custom resolution for your layout independent of screen resolution. Format is WIDTHxHEIGHT, leave blank for default resolution
- 'Raspberry Pi fix' : This applies to systems that gives weird results when getting back from a game, reloading the layout as needed

*Overscan*
- 'Width %' : For screens with overscan, define which percentage of the screen will be filled with actual content
- 'Height %' : For screens with overscan, define which percentage of the screen will be filled with actual content
- 'Shift X %' : For screens with overscan, screen will be shifted by the percentage
- 'Shift Y %' : For screens with overscan, screen will be shifted by the percentage

*Effects*
- 'Low Spec mode' : Reduce most visual effects to boost speed on lower spec systems
- 'Smooth shadow' : Enable smooth shadow under game title and data in the GUI
- 'Glow effect' : Add a glowing halo around the selected game thumbnail
- 'Snap border' : Add a white border around the selected game thumbnail
- 'Thumb gradient' : Blurs the artwork behind the game logo so it's more readable

#### MULTIPLE MONITOR
Configure the appearence of a second monitor


*Video Effects*
- 'Enable multiple monitor' : Enable Arcadeflow multiple monitor suport
- 'Monitor identifier' : Select the identification number for the external monitor
- 'Correct aspect ratio' : Select if the image on the second monitor should be stretched or not
- 'Main media source' : Select the artwork source to be used on secondary monitor
- 'Alternate media source' : Select the artwork source to be used on secondary monitor in case first one is not present

#### SCRAPE AND METADATA
You can use Arcadeflow internal scraper to get metadata and media for your games, or you can import XML data in EmulationStation format


*Scraping*
- 'Scrape current romlist' : Arcadeflow will scrape your current romlist metadata and media, based on your options
- 'Scrape selected game' : Arcadeflow will scrape only metadata and media for current game
- 'Enable CRC check' : You can enable rom CRC matching (slower) or just name matching (faster)
- 'Rom Scrape Options' : You can decide if you want to scrape all roms, only roms with no scrape data or roms with data that don't pefectly match
- 'Scrape error roms' : When scraping you can include or exclude roms that gave an error in the previous scraping
- 'Media Scrape Options' : You can decide if you want to scrape all media, overwriting existing one, or only missing media. You can also disable media scraping
- 'Region Priority' : Sort the regions used to scrape multi-region media and metadata in order of preference
- 'Reset Region Table' : Reset sorting and selection of Region entries
- 'Scrape Timeout' : Set the number of seconds to wait for each scrape operation to complete

*ScreenScraper*
- 'SS Username' : Enter your screenscraper.fr username
- 'SS Password' : Enter your screenscraper.fr password

*MAME Data Files*
- 'History.dat' : History.dat location.
- 'Index clones' : Set whether entries for clones should be included in the index. Enabling this will make the index significantly larger
- 'Generate History index' : Generate the history.dat index now (this can take some time)
- 'Bestgames.ini' : Bestgames.ini location for MAME.

*ES XML Import*
- 'Import XML data for all romlists' : If you specify a RetroPie xml path into emulator import_extras field you can build the romlist based on those data
- 'Import XML data for current romlists' : If you specify a RetroPie xml path into emulator import_extras field you can build the romlist based on those data
- 'Prefer genreid categories' : If GenreID is specified in your games list, use that instead of usual categories

#### ROMLIST MANAGEMENT
Manage romlists and collections


*Romlists*
- 'Refresh current romlist' : Refresh the romlist with added/removed roms, won't reset current data
- 'Erase romlist database' : Doesn't rescan the romlist, bur erases all game database information
- 'Reset current romlist' : Rescan the romlist erasing and regenerating all romlist data
- 'Reset last played' : Remove all last played data from the current romlist

*Master Romlist*
- 'Enable Master Romlist' : Turn this on and set master romlist path so AF can manage it
- 'Master Romlist Path' : If you are using a master romlist, locate it here to enable AF master romlist optimisation

*Romlist Export*
- 'Export to gamelist xml' : You can export your romlist in the XML format used by EmulationStation

*Collections*
- 'Enable all games collections' : If enabled, Arcadeflow will create All Games compilations
- 'Update all games collections' : Force the update of all games collections, use when you remove displays

*Danger Zone*
- 'Cleanup database' : Rescans all the romlists adding/removing roms, then purges the database to remove unused entry
- 'Enable game hiding' : Enable or disable the options to hide games using tags menu
- 'Enable rom delete' : Enable or disable the options to delete a rom

#### RETROARCH INTEGRATION
Assign retroarch cores to emulators

- 'Enable RetroArch integration' : Enable or disable the integration of RetroArch
- 'Custom executable path' : Enter the path to RetroArch executable if not installed in your OS default location
- 'Custom Core folder' : Enter a custom folder for RA cores if not using standard locations
- 'Custom Info folder' : Enter a custom folder for RA info files if not using standard locations

#### SEARCH & FILTERS
Configure the search page and multifilter options


*Search*
- 'Immediate search' : Live update results while searching
- 'Keyboard layout' : Select the keyboard layout for on-screen keyboard

*Multifilter*
- 'Save Multifilter sessions' : Save the Multifilter of each display when exiting Arcadeflow or changing list
- 'Customize Multifilter Menu' : Sort and select Multifilter Menu entries: Left/Right to move items up and down, Select to enable/disable item
- 'Reset Multifilter Menu' : Reset sorting and selection of Multifilter Menu entries

#### UPDATES
Configure update notifications

- 'Automatically check for updates' : Will check for updates at each AF launch, if you dismiss one update you won't be notified until the next one
- 'Install update after download' : Arcadeflow allows you to chose if you just want to download updates, or if you want to install them directly

#### SAVE & LOAD
Save or reload options configurations

- 'Save current options' : Save the current options configuration in a custom named file
- 'Load options from external file' : Restore AF options from a previously saved file

#### DEBUG
This section is for debug purposes only

- 'FPS counter' : DBGON FPS COUNTER
- 'DEBUG mode' : Enter DBGON mode, increased output logging
- 'AM options page' : Shows the default Attract-Mode options page
- 'Test message box' : For developer use only...
- 'Generate readme file' : For developer use only...
- 'Reset all options' : Restore default settings for all layout options, erase sorting options, language options and thumbnail options

## Previous versions history #

*v16.5*

- Fixed bugs in the scraper that caused hanging
- Fixed collections update with master romlist
- Fixed CRC extraction from zip files

*v16.4*

- Added option to show only power menu
- Added report message for romlist refresh
- Fixed volume menu jumping

*v16.3*

- Fixed crash when disabling gradient
- Updated translation file
- Completed Italian translation
- Moved warning messages to About Arcadeflow

*v16.2*

- AF requires AM+ 3.0.6
- Added new "slate" color theme
- Added smooth scrolling to game history
- Added option to automatically scroll history
- Added Dirksimple and Gaelco systems
- Added option to open displays menu on current category
- Revamped media downloader for scraper
- Fixed scraped media download hanging
- Fixed scraping credential saving
- Fixed gameslist.xml import

*v16.1*

- Fixed similar games vidoes not playing
- Fixed crash when exiting to desktop
- Fixed scrape hanging on macOS

*v16.0*

- Added option for fullscreen tiles
- Added option for scrape timeout
- Added new zoom rate options
- Redesigned help images for options
- Improved More of the Same menu
- Improved support for multi emulator romlists
- Fixed bug with More of the Same menu
- Fixed zoom ratio for slimline layout
- Fixed support of redirect romlists

*v15.9*

- Added new manufacturer logos
- Updated German translation (thanks ScherzKeks)
- Fixed progress bar with overscan
- Code cleanup

*v15.8*

- Added 12 new retro computer systems
- Fixed issue with CRC scraping

*v15.7*

- Background music stops in history page
- Fixed Sega CD and Sega 32X logos crashing in 4K

*v15.6*

- Added Virtual Console logo
- Fixed wheel animation
- Fixed issue with auto update

*v15.5*

- Changed spacing of menu entries
- Added option for 1 line small thumbs in vertical
- Added option to show 3D box art
- Enabled scraping of 3D box art
- Fixed bug related to menu sizing
- Minor bug fixes

*v15.4*

- Added transparent background to boxart mode
- Added option to enable/disable white border around thumbnails
- Ambient volume set in AM option affects AF background music volume

*v15.3*

- Fixed bug with metadata that crashed AF

*v15.2*

- Added per display background music
- Show specific manufacturer year logo by adding _number to the name
- Fixed case sensitive manufacturer name match
- Fixed issue with metadata saved to game database
- Fixed memory leak when playing random bgm

*v15.1*

- Added new manufacturers logos
- Added animation for download and install
- Fixed issue when a romlist entry is not in the db

*v15.0*

- Added menu entry to install specific versions or branches
- Added new manufacturers logos
- Removed option to rotate screen, it's in AM options
- Improved aspect ratio correction for vertical handhelds
- Improved smoothness of video transition for background
- Video background can be enabled even without background snaps

*v14.9*

- Added progress bar for long filtering operations
- Added timeout check to avoid hanging scraping operations
- Fixed vertical arcade videos
- Increased buttons and players number in metadta editor

*v14.8*

- Added new systems: PC Engine LT, SNES and NES new designs
- Added option for Vertical Arcade video snaps
- Increased line spacing in history page description
- Manufacturer logos are now differentiated by year
- Moved ScreenScraper login data to ss_login.txt file
- Fixed manufacturer multifilter to be case-insensitive
- Fixed SS issue when scraping games with dot in the name

*v14.7*

- Added option to reset database without affecting romlist
- Added new option to remove unused entries in games db
- Added support for RA 32 Bit in Windows
- Added new options for RetroArch custom folders
- Fixed deleted tags showing in list

*v14.6*

- It is now possible to change RA cores from AF UI
- Added option to enable RetroArch integration
- Fixed issue with multifilter jumps

*v14.5*

- Added option to show controls overlay only on arcade games
- Added two new systems: Sega Pico and Acan
- In multifilter menu you can skip void entries with "right"
- Fixed issue with controls overlay

*v14.4*

- Fixed GBA logo issues
- Fixed labels update when sorting
- Fixed number of columns in scraper messages
- Added pixel font on scrape screen

*v14.3*

- Added 4 new systems
- Fixed font path for scraper
- Fixed issue with options menu images
- Fixed menu line spacing
- Fixed similar games text color

*v14.2*

- Improved performance optimising tile redraw
- Fixed Cave background image
- Added new button for favourites filter

*v14.1*

- Reorganised fonts files
- Fixed issue when rom name contains ;
- Tags menu show tags from all romlists
- Added an option to enable-disable game hiding

*v14.0*

- Improved performance by optimizing surface redraw
- Fixed issue with date display

*v13.9*

- Added support for new AM+ display loading
- Category collection not shown if there's only one display
- Added an option to make AF compatible with master romlist setups
- Reorganised options menu main page
- Fixed issue when snaps are not defined

*v13.8*

- Added support for pixel perfect fonts
- Correct UI elements alignment with pixels
- Fixed issue with number of rows in menus
- Fixed issue when converting romlist to db

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

*v7.9*

- Fixed issues when selecting submenus in multifilter
- When using on-screen keyboard search you can type directly with a physical keyboard
- All options with entry text can be used with on-screen keyboard
- New search method: no need to select search field, results for multiple fields will be shown directly
- New category menu backend, integrated with new search method and multifilter
- Added an option to disable saving multifilter when leaving Arcadeflow
- Added tags list to the history page description text
- New tags management backend, now you can add/remove tags from a menu and using on screen keyboard
- New favourites management backend, no more confirmation menu
- Fixed next_favourite and prev_favourite signal response
- Added new QWERTY layout option for on-screen keyboard

*v7.8*

- Arcadeflow now execute your "exit command" on exit if it's set up in Attract Mode preferences
- Tweaked the data shown in the History page with category, buttons, players and other details
- Fixed bugs in multifilter list switching
- Multifilter menu now preselects the current game's data
- Fixed a bug when removing items from multifiltered list (e.g. remove favourite or tag)
- Code cleanup

*v7.7*

- New backend for the multifilter menu
- Multifilter background is now a faded version of the background
- Multifilter menu now mixes "simple" entries and entries leading to a submenu (recognizable by the "...")
- When applying a multifilter, if the currently selected game is present in the filtered list it will be selected
- After applying a multifilter, entries that have 0 games are dimmed and can't be selected
- Multifilter status is saved for each display and each filter
- Updated Italian translation with new menus and options

*v7.6*

- Fixed bugs with multi-level Displays menu and "#" category forcing
- Added a new "Multifilter" menu system, allowing you to dynamically filter a romlist without using a search string.
- Added a new Category menu that allows direct filtering of categories using a search string
- Added new custom buttons options for Category menu and Multifilter menu
- Sorted displays list in alphabetical order

*v7.5*

- Added custom button option for search menu
- You can call the options menu from everywhere in the layout
- Displays images shown also when categorized menu is selected
- Add #console #arcade #handheld #computer or #other to force your display in a category
- Very preliminary support for videos in the displays list with images
- New menu fade routine
- Arcadeflow adapts effects speed to your system framerate, so lower systems won't run slower, just less smooth
- Better menu shading when "No frosted glass" is selected
- In menus, use "left" to jump to the top of the list

*v7.4*
- Whole new (again) menu system
- Added an option to show the displays menu at startup
- Added am option to add "Esit Arcadeflow" in the displays menu (use this instead of the one in Attract Mode options)
- Added an option to enter Displays Menu when leaving a Display (esc button)
- Added an option to exit Arcadeflow when leaving Displays Menu
- Removed options for using Arcadeflow as Displays Menu layout, this is not supported anymore
- Stopped video playing when menu is visible
- Faster engage of fast speed scrolling

*v7.3*
- Added "grouped" displays menu, with Arcade, Computer, Console and Handheld categories
- New version control for preference file that is not completely wiped when new preferences are added
- Added visual cue for options introduced in latest release
- Fixed a bug in the systems list
- Fixed bugs in the name artwork generation

*v7.2*
- All interface except background is hidden when game is launched
- Added "Game & Watch" and "Tiger" to systems list
- Changed the way systems are managed internally
- Added an option to apply game boy colorization based on system name
- Added new glyph system for overall homogeneous look
- Added glyphs to options menu
- Fixed attract mode engaging when new menu is on
- Fixed options menu not stopping attract mode

*v7.1*
- Added back the option to show images from menu-art folder in displays menu list
- Fixed fade issue with new menu system
- Fixed size of system logos in displays menu on vertical layout
- Fixed bug when using AF as displays menu layout
- Glyphs are visible even when no enhanced menu is on
- Improved cleaning of letter labels when search string is visible
- Fixed displays selection when a display is not shown in menu

*v7.0*
- Added a new menu system with smooth scrolling and visual glyphs
- Added an option to enable/disable the new menu system
- When showing the display name upon changing display, system artwork is used instead of plain text
- Changed the "completed" badge with a new one
- Rearranged sound response so no double sounds will be played
- Fixed a bug when the romlist has no content
- Removed Displays Menu Page options

*v6.9*

- Added new manufacturer icons (1000 unique icons total)
- Added tick sound whne jumping letter
- Silenced game audio when entering menus

*v6.8*

- Fixed issues with file browser when navigating folders
- Added new systems logo for game consoles (Odissey, Sega MKIII etc) and arcade systems (CPS1,2,3, Naomi etc)
- Added an option for a custom button to open the history/overview page
- Fixed a bug with name artwork generation
- Fixed a bug interfereing with Rocketlauncher plugin

*v6.7*

- Added French translation thanks to katarak from the forum
- Added an option to completely reset the layout to its default settings
- Added an option to enable video thumbnails in Displays Menu mode if that option is enabled for normal pages
- Fixed a bug that caused saving of preference files in plugins folder
- Added an option to play a background music when using Arcadeflow
- Fixed bugs with displays menu
- File browser now goes up to volumes letters in Windows

*v6.6*

- Added a new options system using Arcadeflow menu system instead of Attract Mode options page.
- Fixed bugs with glyphs on menus
- Added Spanish translation thanks to Jate from the forum
- Added Portugues (BR) translation thanks to ReBirFh from the forum
- Fixed bugs in the LCD filter
- Added different placeholder screnshots when no screenshot is avilable
- Added file browser for chosing custom images and sound
- Fixed a bug with attract mode kicking in when menus are visible
- Fixed displays menu list to take into account hidden displays and "exit" option
- Fixed and translated the search string at the bottom of the layout

*v6.5*

- Added an option to chose the language of the layout. Currently only English and Italian are supported
- Improved the way glyphs are rendered on menus
- Fixed a bug in the signal response routine when showing "attract mode"
- Fixed a bug in the signal response routine when history page is showing
- List is not re-sorted when favorites are added but the list size is not changed
- Changed the way preferences are saved without using fe.nv
- Added manufacturer logos (900 total)

*v6.4*

- Fixed scroll routines and signal response so it works in Attract Mode 2.6.1
- Added progressive acceleration to horizontal scrolling
- Added manufacturer logos (830 total)

*v6.3*

- Added warning: Arcadeflow will work with Attract Mode 2.6.1 but scrolling will not work as espected
- Added more manufacturer logos in vector format (803 unique logos)
- Changed the way manufacturers logos are managed under the hood
- Fixed naming of Wonderswan console

*v6.2*

- Completed the conversion from png manufacturer logos to vector logos
- Fixed a bug in video snaps cropping when video aspect is different from boxart aspect
- In box-art mode, when no box artwork is present, the missing image is substituted with an image of the category logo with the game title overlayed
- Added a placeholder image for missing snapshots
- Fixed many small issues with cropping, glow and aspect ratios
- Fixed scrolling issue with page skipping
- Fixed video fade bug when skipping pages

*v6.1*

- Increased the number of manufacturer vector logos, almost parity with the old bitmap logos
- Changed the way sorting is done at startup to avoid delays when extremely large romlists are used
- Minor improvements and bug fixes

*v6.0*

- Manufacturer images are now in vector format
- Added new options for boxart mode:
- - you can chose if you still want to show the game title artwork on top of the tiles
- - you can chose the source of the box art between flyers and fanart
- Added new option to delay background video loading so it's faster and in sync with thumbnail videos

*v5.9*

- Fixed a bug causing crash when using AF as displays menu layout
- Added new systems logos
- Added an option to hide the second part of the game name after the system name.

*v5.8*

- Introduced new options for the displays menu list:
- - List can be a simple displays name list, or it can show artwork from the menu-art folder
- - If there's no artwork for a displays name Arcadeflow can geerate proper artwork from the system name (system logo) of from the display name using a nice font
- - Instead of a plain text list for displays names you can have a list with system logos generated by Arcadeflow
- Added an option to show the system logo instead of system name under the game title
- Fixed video cropping to account for changes in Attract Mode 2.6
- Added new manufacturer images

*v5.7*

- Fixed bugs when Arcadeflow is used as Displays Menu layout
- Fixed a bug when switching from snapshots to box-art
- Fixed bugs in the game counter and display of system name
- Changed the way history background is used, so it won't interfere with main background
- Added new manufacturer images for computer games (MSX, BBC Micro, NEC PC88, Apple II, PC, Amstrad etc) and japanese computer games (FM Towns, PC-8800, PC-9800, X68000)

*v5.6*

- Fixed bugs in the sorting feature and tile update
- Changed the "Sort by..." menu and reverse sort order
- Fixed an issue with history.dat index generation
- Changed the scrollbar layout so there's more room for filter and sort name
- Added a new glyph to show sort direction
- Added glyphs to "Utility menu" entries and to menu headers
- Added custom background image for history page
- Added option to remove dark gradient under history screenshot
- If no artwork for displays is available in menu-art, displays menu will span the whole screen

*v5.5*

- Added support for custom sort of game lists, from within Arcadeflow utility menu
- New "prev_letter" "next_letter" management allowing to jump to prev/next year, manufacturer etc according to sort order
- When sorting by title a layout options allow stripping of articles "The", "Vs." etc
- Option to save sort order state each time it is changed
- When resetting search results there's an option to keep the current game selected

*v5.4*

- Fixed update of tags and completed overlays
- "More of the same..." menu now shows tags of the current game so you can use them to filter
- The current game is selected when showing the "More of the same..." results list
- Added "Orientation" and "Favourite" to the "More of the same..." current game filter menu
- Each time a romlist is loaded Arcadeflow detects if articles should be stripped or not from the sorting
- Added manufacturer images from the golden era of videogames

*v5.3*

- Game letter or display name zoom while fading
- An optional game title artwork will be generated when no artwork is available
- An optional display name artwork will be generated for Displays Menu mode
- New option to show a tag icon when the game has tags
- New option to chose if you want to show tag icon for a specific tag (blank means all tags)
- Added "1-Small" option when Arcadeflow is used as Displays Menu layout
- Added manufacturer images for more computer and console game manufacturers
- Arcadeflow attract mode is not engaged when games are playing
- Fixed bugs and improved the display list scrolling
- Cleanup and reordering code

*v5.2*

- You can now use hotkeys like prev/next page, letter, random game etc from history page
- Added overlay when changing display
- Utility menu can be disabled or tied to an hotkey
- Added 70 new manufacturer images, mostly console related

*v5.1*

- Fixed the routine that updates thumbnails when scrolling or going to next/prev game

*v5.0*

- Added a color filter for Game Boy games with black and white snaps to make them look green-ish
- New "low spec mode" option to reduce visual effect and improve performance on lower spec systems
- Game list now wraps around:
- - When you reach the end (or the beginning) just press right (or left) again to jump.
- - When reacting to next_game/prev_game signals.
- - In history page when going left/right, fixing a bug in 4.9.
- Fixed an issue with cropping of blurred background snaps
- Fixed the thumbnails overlapping the label list when zooming.
- Reorganized options to include a new "PERFORMANCE & FX" section.

*v4.9*

- Game videos will show even in boxart mode, cropped to the shape of the box art
- Added an option to customize the delay of the overlya videos
- Fixed name display for roms with multiple parenthesis like "(Japan) (Translated)"
- Changed the aspect ratio detector for box art, fixed some issues with cropping
- Fixed an issue in label list when no filters or global filter are present
- Fixed some bugs in the displays artwork scrolling routine
- Rewrote the image loading routine so now dynamic update during search works better

*v4.8*

- Fixed a bug that kept videos (and their audio) playing even when not visible
- Fixed some issues with labels and mame romlists
- New players icons for mame romlists using "2P sim" and "2P alt" players definition

*v4.7*

- Fixed a nasty bug that caused random crashes when using AF 4.6
- More robust routines when dealing with multi-system romlists
- Fixed issues with video fade routine
- Added a visual Displays Menu even when using "Default" displays menu
- Introduced an optional "Cleaner" look with only game title and some data
- Introduced a "Small Thumbnail" option for 1-row themes (thumbs are same size as 2-rows)

*v4.6*

- Box art mode for consoles is now "Box Art - Flyer Mode" and can be enabled for all displays and emulators by default
- Each display can be switched from Box Art to Flyer on the fly using a menu or a hot button, this is persistent
- Ditched "Console, Arcade, Handheld" distinction in favor of automatic LCD sensing. Just set you emulator System Identifier accordingly, so you can have "Game Boy" or even "gameboy" or "Game Gear" etc and the system will react.
- LCD games are now rendered with the title popping out, unless "Square" mode is set in the theme options.
- Custom shader for LCD games, different from CRT shader, there's now a "native resolution" table inside Arcadeflow so pixels effects and scanlines are rendered correctly even on stretched snapshots
- New unified tiles display routine allows the mix of different screen orientation or box art orientation in the same display, so if you have a romlist with Genesis, Snes and Game Boy games all together the system will adapt each artowrk (screenshot or boxart) accordingly
- Games with squarish screen or non 4:3 apect ratios will be cropped accordingly if the system identifier is LCD, games with CRT identifier will be stretched to 4:3 1:1 or 3:4 (to compensate pixel aspect ratio)
- Boxart mode can be configured in theme option, but also changed on the fly with a general menu entry or with a custom control button (no layout reload required)
- When using the "Default" Displays Menu the layout doesn't need to reload at display changes. This is still needed when using Arcadeflow as Displays Menu Layout
- Overlayed videos now fade out instead of just disappearing when changing tile
- If you have a System Identifier defined it will be shown after the ROM main name, before the ROM name details.

*v4.5*

- The layout is not restricted to arcade games anymore, it works and adapts to console games (TV) and handheld games. Just add "Console" and/or "Handheld" to your emulator category in Attract Mode settings
- Added a "Box Art Mode" for console games: Arcadeflow won't show screenshots but box artwork for console games. You can enable it from the menu and it will be applied to emulators that have "Console" added as a category.
- Optimized layout and CRT filters for handheld games, this is enabled when an emulator have "Handheld" as a category.
- Rearrenged the Displays Menu functionality so that now you can use the same Arcadeflow layout for both Displays Menu and normal layout, no need for duplicate folders anymore
- Removed "Displays Menu mode" option, now the theme autodetects if it's in Displays Menu mode or not
- Added options to change the number of rows when Arcadeflow is used as Displays Menu
- Changed parts of the layout so it better copes with console game lists, now it works fine with screenshots for TV consoles (4:3 screen aspect ratio)

*v4.4*

- Added a new "Displays Menu" option. With this option enabled you can use Arcadeflow as a Displays Menu layout without glitches
- Added a voice on the main menu to enter "Displays Menu"
- Added frosted glass effect under "Displays Menu" overlay
- More robust code for filters and labels

*v4.3*

- Fixed some bugs in the label scrollbar, taking into account "Vs. " game sorting, cleaned up the code
- Lighter frosted background in "Light" theme to improve menu readability

*v4.2*

- Introduced different styles for the scrollbar:
- - Scrollbar is a simple scrollbar as before
- - Timeline adds ticks and labels depending on the sorting order
- - Labels List is a simple list of labels without the actual scrollbar
- Changed what happens when you go "down" from the tiles list:
- - In "Scrollbar" mode "page jump" is enabled, as usual, skipping entire screens instead of one game
- - In "Label List" mode you jump to the next or previous label (letter or year depending on the sorting)
- - In "Timeline" mode you jump pages when the scrollbar is highlighted but if you go down again you can jump labels

*v 4.1*

- New "Low Resolution" mode with increased font size and optimized layout for lower resolution screens
- New option to enable Low Resolution mode
- Changed the zooming code of the tiles to avoid jumps and make it smoother, now all tiles zoom out and not just the last one
- Fixed the update routine when tags are changed
- Changed the way horizontal and vertical games are recognized and the way horizontal and vertical artwork (borders, glows etc) are generated, to reduce layering

*v 4.0*

- Frosted glass menu overlay now fades in instead of just appearing
- Text in history page has a minimum size so it's readable even on low res screens
- When changing games in history page the text and logo fades, and the game screens slides/fade into view
- Changed the glow effect under the history screenshot
- Fixed some bugs in the CRT shader
- Fixed two manufacturer images
- Changed the thumbnails update code so now it reponds correctly to all signals like "next_letter", "random_game", "next favourite" ecc both in thumbnail view and in history page view

*v 3.9*

- Fixed some bugs in the signal response code and sound management
- Added a "fade from black" effect when launching the layout
- Revised attract mode:
- - Attract mode is now on by default but not at startup, just after the delay
- - Streamlined the code, improved performance when it's enabled but not running
- - Added black crossfade when changing games
- - New options: chose wether attract mode satrts with the layout, only after delay time, or is disabled
- - Game rendering is done with a fixed number of scanlines (180) for every game
- - For lower resolution screens the number of pixels per scanline is optimized to avoid moiree
- - You can now add a sound file to play during attract mode
- - Added an option in the general menu to manually start attract mode without waiting

*v 3.8*

- Added an "attract mode" that shows random game videos when AF is not active (see options)
- In options if you use "vignette.pmg" as custom background you get a corner vignette effect
- Added a grey shadow under the game title in history page
- Added the option to have a darker background for game preview in history page
- First and last lines of text in history page are now vanishing in the background color
- Text in history page slides up into place
- Changed the routine used for fade in - fade out, code is cleaner and effect is smoother
- Added a "DEBUG" option to enable a FPS counter (for debug purposes only)

*v 3.7*

- Customized CRT shader with vigneting effects.
- Added an option for history page game video: you can have "Aperture" instead of scanlines, half res scanlines or plain video.
- Changed the look of the history text with a white background, you can select it in the options.

*v 3.6*

- Arcadeflow 3.6 requires Attract Mode 2.5.
- Fixed some issues with AM 2.5 when adding or deleting favorites and tags.
- Changed the CRT filter in history page from cgwg shader to lotte shader, now scanlines are vertical for vertical games and aligned to the game actual pixels.
- Added options for history page that halves or removes scanlines so the moiree effect is less prominent.

*v 3.5*

- In layout options you can now choose if you want to use "select" or a "custom" control button to open the context menu.
- Revised the thumbnail glow bitmap and shader (again) so it's subtler and smoother.

*v 3.4*

- Custom control button not needed anymore, now when you hit "select" on a game you'll see the context menu, if you hit "select" again the game will play, otherwise you can use arrows as before for different functions
- Revised the context menu graphics
- Changed the way "color gradient" is calculated: instead of sampling some points on the image it uses an actual smoothed version of the image
- Changed the way "glow color" is calculated, takes its color from actual thumbnail (static or video) isntead of the average as before
- Added glowing effect in history page around the game display video

*v 3.3*

- Bug fixes for 1-row mode and for response to signals like next_game, next_page etc

*v 3.2*

- Revised the smooth shadow under texts, now it's resolution-independent and more optimized
- Added an option to have 1-row layouts for both horizontal and vertical
- Enlarged some elements of the UI for lower resolution screens

*v 3.1*

- Added indicators of number of players, game controls and game buttons
- Fixed some bugs in the category picture function
- Fixed bugs in the pop up letter routine

*v 3.0*

- Changed the way blurred fading backgrounds are layered
- Tweaked some graphics aspects
- Pop up letter now responds to the sort order of the game list
- Cleaned up some code
- Added an option to mute the theme "click" and "woosh" sounds
- Improved transparent PNGs for shadows and glows

*v 2.9*

- Redesigned the game data ribbon on top of the thumbnail grid
- Added category icons for game category
- Added manufacturer icons for game manufacturer
- Added a smooth drop shadow under game title, data and icons
- Streamlined the AF logo so it's just white
- The technique used for background crossfade is used for game data crossfade too
- Frosted glass effect applied to the screen behind the logo

*v 2.8*

- Implemented a new, smoother system for background image crossfade
- Added a "look for the same..." + "Decade" search menu entry

*v 2.7*

- Fixed some bugs in screen rotation
- Added the possibility to define a layout resolution independent from screen resolution

*v 2.6*

- New "frosted glass" effect when you enter overlay menus
- Updated Readme.md with current options

*v 2.5*

- Added a new option to toggle screen rotation permanently

*v 2.4*

- Snapshots aspect ratio is now adapted to 4:3 or 3:4 automatically
- Some improvements to shaders, cleaned up the code
- Revamped the History page adding a CRT-like shader to the game preview
- Tweaked the appearance of themes (dark is now darker) and fixed some bugs in snapshots scaling

*v 2.3*

- Improved the overall speed by optimizing shaders and textures
- Added a new effect on the background where you can get a pixellated version of the snap or video
- Added a new glow effect around selected thumbs with the average thumb color
- Added the possibility to hear audio of the videos in the thumb and/or in the history page
- Revamped the options to make it more clear

*v 2.2*

- The thumbnail art fades to the average thumbnail color in the area behind the title logo, to improve readability
- Added an option "Smooth Gradient Snap" to enable/disable the fade effect
- In "Square" thumbs mode changed the position and aspect ratio of the logo so it's more on the top of the thumb

*v 2.1*

- Added some tweaks to make scrolling more fluid and correct slowdowns
- Fixed a bug in the background scaling blurred snap routine
- Changed the blur shader, now there are three layouts to chose from: layout, layout_noshader, layout_oldshader (with a lighter shader that is faster on some machines)

*v 2.0*

- New feature: you can now change the splash logo
- New feature: background artwork can be a semi-transparent PNG and will show the blurred background behind it
- Under the hood changes: version 2.0 is a huge rewrite of AF, no need to generate blurred backgrounds or blurred logo shadows with xnview, the theme can generate on the fly shadows and backgrounds from your snapshots and wheel artwork. The theme may be a bit slower on your system depending on the size of artworks which is generally larger than xnview generated blurred pictures.
- If you have issues with the new way "blur" is generated you can use the layout_noshader.nut file instead, just chose it from the layout options menu (AM 2.4) or rename it to layout.nut (AM 2.3). This layout file has all the features of the new one, but in a standard framework using xnview generated artwork

*v 1.9*

- AM 2.4 was released while coding AF 1.9, adapted the code so it works both in 2.3 and 2.4:
- - Fixed the zorder management
- - Implemented a new way to crop thumbnails for "square" thumbs layout
- - 2.4 users can access the "Layout Options" menu directly from the "General" menu accessible going "Up" from the game grid
- - Rewritten the scrolling title routine with proper timing
- Custom background picture is not stretched but scaled/cropped to fit the theme aspect ratio
- Thoroughly rewritten the transition response routine, it's cleaner and works much better now.
- Thanks to the above rewrite you can now use "left" and "right" on the History screen to go to the previous/next game, the layout should now respond correctly even to "jump to letter" calls and page jumps.
- "Square" thumbnails layout now responds to the "Blurred Logo Shadow" option, if you enable it you'll get game name overlay with drop shadow, otherwise plain game name with gradient background.
- When a game has a multi-language title separated by "/" (e.g. Fatal Fury / Garou Densetsu) the theme will crossfade the titles so that title scrolling is needed less often.

*v 1.8*

- Introduced a new layout style where game snaps are not horizontal or vertical depending on game orientation, but cropped square. You can chose it in the options menu.

*v 1.7*

- Overhauled the menu and functions system, now it works like this:
- - When going "UP" from the tiles list you get to a "main menu" where you can select Filters Menu or Global Search
- - When on a game using the configurable control button you get a "context menu" overlay with 4 game-specific functions you chose by using your joystick/keys:
-   - "UP" enters the "More of the same..." search menu
-   - "DOWN" enters the "History" page where you can see and scroll the game history and see a larger game preview
-   - "LEFT" to enter the Tags menu
-   - "RIGHT" to add/remove favorites
- Implemented a version of the History.dat plugin so you can see history without the need to enable the plugin (see options)
- Rolled back the way horizontal and vertical games are detected, the "new" one had some issues in many circumstances
- Tweaked and updated search with on-screen keys
- Added a workaround when invoking filters through the filters menu button to fix some tiles update

- New theme options included:
- - "History.dat" is the location of the History.dat file (no need to enable or configure the )
- - "Index Clones" works like the same option in the History.dat plugin.
- - "Generate Index" a one-time function to generate the history index

*v 1.6*

- Changed the way horizontal and vertical games are detected, this time it should work for all users and all games lists
- Changed the way the "vertical" mode is scaled and layed out, clearer and with larger thumbs
- Search features that require tex input now also work with on-screen keys (embedded the KeyboardSearch plugin)
- New theme options included:
- - "Search string entry method" to chose if you want to use a keyboard or a joystick and on screen keys to enter text
- - "Immediate search" will live update results while you enter search text using the on screen keys
- - "Enable AF splash logo" enables/disables the fading splash Arcadeflow logo
- - "Vertical rows" allows to use 2 or 3 rows of icons in vertical mode

*v 1.5*

- New shadows graphics, smoother and more modern-looking
- New and improved search features:
- - use "Custom 2" to filter games with the same year, manufacturer, main category and sub-category of the current game (e.g. shooters, or horizontal shooters)
- - use "Custom 3" to open a menu and search in games titles, years, manufacturers or categories
- When toggling screen rotation using AttractMode hotkeys the screen updates to the vertical layout if needed.

*v 1.4*

- Changed (again) splash screen graphics at startup (new AF logo)
- Introducing theme options:
- - You can chose the theme's... theme :D There are 4 choices: "Default" (greyed blurred background), "Dark", "Light" (dark and light blurred background), "Pop" (blurred background colors unaltered)
- - You can chose whether you want "hard edged" game title shadows or "smooth" game title shadows, the latter requires new artwork (see below)
- - You can chose whether you want to place a marker on unplayed games
- - You can place a background image, this will be affected by the theme choice and will override the blurred background
- Minor tweaks and speedups, now each sections retaines the latest selected game

*v 1.3*

- Key repeat rate limited to allow more fluid scrolling of tiles
- Added selection sound
- Changed splash screen graphics at startup

*v 1.2*

- Scrolling game title when the title size is too big to fit the screen
- If you go "up" from the first row you enter the "Filters" menu
- If you go "down" from the second row the scrollbar highlights and you can jump screens faster
- Improved scrolling speed on some systems
- Added a splash screen at startup

*v 1.1*

- The games list is not repeating
- Tweaked scrolling at the beginning of the list so the first game column is not centered
- Changed the timing so that when the video snapshot is loaded the scrolling doesn't stutter
- Number of columns automatically calculated
- Better support for vertical displays

*v 1.0*

- First release
