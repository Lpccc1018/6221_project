-- pull in Gamestate from the HUMP library
Gamestate = require 'libs.hump.gamestate'
-- save settings lib
serialize = require 'libs.Ser.ser'
-- pull in each of our game states
mainMenu = require 'gamestates.mainMenu'
settingsMenu = require 'gamestates.settingsMenu'
controlMenu = require 'gamestates.controlMenu'
gameLevel1 = require 'gamestates.gameLevel1'
gameLevel2 = require 'gamestates.gameLevel2'
gameFinished = require 'gamestates.gameover'
gameTransition = require 'gamestates.gameTransition'
pause = require 'gamestates.pause'
AD = require 'gamestates.AD'
wrongAns = require 'gamestates.wrongAns'
rightAns = require 'gamestates.rightAns'
-- game levels
game = {gameLevel1, gameLevel2, gamefinished}
-- menu base
Menu = require 'gamestates.menuBase'
-- background image
background = love.graphics.newImage("assets/background.png")

function love.load()
	Gamestate.registerEvents()
	Gamestate.switch(mainMenu)
	
	-- get custom settings from file
	if love.filesystem.getInfo('settings.txt') then
		local chunk = love.filesystem.load('settings.txt')
		settings = chunk()
	else
		-- write default settings
		settings = {false, 1, 1, "left", "right", "up"}
	end
	-- set whether full screen
	love.window.setFullscreen(true)
	if settings[1] == false then
		mainMenuGrp.items[2]:action()
	end
	-- set music
	music = love.audio.newSource("/assets/TremLoadingloopl.wav","static")
	music:setLooping(true)
	music:setVolume(settings[2])
	if settings[3] == 0 then
		music:stop()
	else
		music:play(music)
	end
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.push('quit')
	end
end

function love.quit()
	success, message = love.filesystem.write('settings.txt', serialize(settings))
	print('Save Settings. Saved? '..tostring(success))
end
