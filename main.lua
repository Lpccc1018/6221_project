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
reminder= require 'gamestates.reminder'
victory= require 'gamestates.victory'
-- game levels
game = {gameLevel1, gameLevel2, victory}
-- menu base
Menu = require 'gamestates.menuBase'
-- background image
background = love.graphics.newImage("assets/background.png")
-- victory image
winning= love.graphics.newImage("assets/winning.png")

function love.load()
    video = love.graphics.newVideo("assets/adv.ogv",{ audio = true })
	audio = love.audio.newSource("/assets/giant2.wav","static")
    audio1=love.audio.newSource("/assets/coin2.wav","static")
	Gamestate.registerEvents()
	Gamestate.switch(mainMenu)
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.push('quit')
	end
end

function love.quit()
end
