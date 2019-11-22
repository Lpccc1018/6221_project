This game requires love2d Version 0.9.1 to run 
https://bitbucket.org/rude/love/downloads/
https://love2d.org/wiki/Getting_Started

Bugs
there are bugs all over... brace yourself... you are forewarned!

Credits
all the guys who helped me do this are stated/recognised in the credits.txt file

controls
Move Left - left arrow key
Move Right - right arrow key
Jump - up arrow key
Action (climb/move object) - 'e' key
Portal - 'z' key
Quit - 'escape' key

To climb or move an object 
- press and hold 'e' key + arrow key

To port the player
-the 'z' key must be pressed twice and two boxes colored orange and green will be created
Press 'z' key once and wait till the port box stops moving and press 'z' key again
Jump onto the green box to port to the orange box

Tutorial
This demo is based on Love2d Platformer Tutorial by OSMstudios 
To understand how this works, check out his tutorial at http://www.osmstudios.com/tutorials/love2d-platformer-tutorial-part-1-the-basics


Menu/Game Settings
settings are stored in a settings.txt file
Use the guide here (https://love2d.org/wiki/love.filesystem) to find its location on your system

the main file(main.lua)
Loads your settings - love.filesystem.load or the default setting is used
The game changes state(menu, levels...) with Gamestate.switch, a gamestate system(libs.hump.gamestate)
The music is set with love.audio
The game quits with love.event.push("quit")

the configuration file(conf.lua)
https://love2d.org/wiki/Config_Files

Assets Folder
all images and sound are here
the levels folder contains all levels. check out https://www.mapeditor.org/

Entities Folder
it has all the active objects in the game(player, enemy, ...)
(entity.lua and entities.lua)
the functions in the entity and entities files are responsible for adding the object to the game using
a class system(libs.hump.class). all other objects inherit from them
(player.lua)
movement of the player - love.keyboard.isDown
https://love2d.org/wiki/love.keyboard
collision and response - self.world:move
https://github.com/kikito/bump.lua
creating an object - player:fire
check out kikito's demo http://github.com/kikito/bump.lua/tree/demo
(enemy.lua)
animation - https://love2d.org/wiki/Tutorial:Animation

Gamestates Folder
it contains the level constructors, transition and menus of the game

libs Folder
it contains all the libraries used in the game
collision detection(bump) - https://github.com/kikito/bump.lua
gamestate and class(hump) - https://github.com/vrld/hump
serialization(ser) - https://github.com/bakpakin/binser
simple tile implementation(sti) - https://github.com/karai17/Simple-Tiled-Implementation
camera control - http://ebens.me/post/cameras-in-love2d-part-1-the-basics/


