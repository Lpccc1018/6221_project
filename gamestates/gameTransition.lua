local LevelBase = require 'gamestates.LevelBase'
local inspect = require 'entities.inspect'
local debug = 0
local data = 0

gameTransition = Gamestate.new()

function gameTransition:enter(from)
  self.from = from -- record previous state
  data = from
debug = from
end

function gameTransition:draw()
  local w, h = love.graphics.getWidth(), love.graphics.getHeight()
  -- draw previous screen
  self.from:draw()

  -- overlay with gameTransition message
  love.graphics.setColor(0,0,0, 100)
  love.graphics.rectangle('fill', 0,0, w, h)
  love.graphics.setColor(255,255,255)
  --love.graphics.printf(inspect(debug.__includes.Entities.entityList, {depth = 2}), 0, 0, w, 'center')
  love.graphics.printf('gameTransition', 0, h/2, w, 'center')
  love.graphics.printf('Health: '..data.__includes.Entities.entityList[1].health, -140, h/2 + 20, w, 'center')
  love.graphics.printf('Lives: '..data.__includes.Entities.entityList[1].lives, 0, h/2 + 20, w, 'center')
  love.graphics.printf('Bonus: '..data.__includes.Entities.entityList[1].bonus, 140, h/2 + 20, w, 'center')
  love.graphics.printf('hit \'Enter\' to continue', 0, h/2 + 40, w, 'center')
end

function gameTransition:keypressed(key)
  if key == 'return' then
    Gamestate.pop() -- return to previous state
    LevelBase:switch()
  end
end

return gameTransition
