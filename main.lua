--set custom settings(conf) from file
if love.filesystem.getInfo( 'settings.txt' ) then
  local chunk = love.filesystem.load( 'settings.txt' )
  settings = chunk()
  love.window.setFullscreen( settings[1] )
  love.audio.setVolume(settings[2])
  --print(settings[3])
else
  -- write default settings
  settings = {false, 1, 1, "left", "right", "up"}
end

--save settings lib
local serialize = require 'libs.Ser.ser'

-- Pull in Gamestate from the HUMP library
Gamestate = require 'libs.hump.gamestate'


-- Pull in each of our game states
local mainMenu = require 'gamestates.mainmenu'
local settingsMenu = require 'gamestates.settingsmenu'
local controlMenu = require 'gamestates.controlmenu'
local gameLevel1 = require 'gamestates.gameLevel1'
local gameLevel2 = require 'gamestates.gameLevel2'
local gameFinished = require 'gamestates.gamefinished'
local gameTransition = require 'gamestates.gameTransition'
local pause = require 'gamestates.pause'
AD=require 'gamestates.AD'

--game levels
game={gameLevel1,gameLevel2,gamefinished}

function love.load()
  Gamestate.registerEvents()
  --Gamestate.switch(gameLevel1)
  Gamestate.switch(mainMenu)
  music = love.audio.newSource("/assets/TremLoadingloopl.wav","static")
  music:setVolume(0.3)
  music:setLooping(true)
  if settings[3] == 0 then
    music:stop()
  else
    music:play()
  end
  print(music)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.push("quit")
  elseif key == "]" then
    love.window.setFullscreen( true )
  elseif key == "[" then
    love.window.setFullscreen( false )
  end
end

function love.quit()
	success, message = love.filesystem.write('settings.txt', serialize(settings))

    print('Hey you! Save why dont you. Fullscreen Enabled? '..tostring(settings[1])..' Saved? '..tostring(success))
end


function love.focus(f)
  if not f  and Gamestate.current() ~= pause then
    Gamestate.push(pause)
  end
end

