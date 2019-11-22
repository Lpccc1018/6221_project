local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'
local inspect = require 'entities.inspect'
local LevelBase = require 'gamestates.LevelBase'
local Entities     = require 'entities.Entities'
local width = 16
local height = 16
local debug = 0

local bonus = Class{
  __includes = Entity -- bonus class inherits our Entity class
}

function bonus:init(world, x, y)
  self.animation = newAnimation(love.graphics.newImage('/assets/crystal.png'), width, height, 1)
  Entity.init(self, world, x+540, y, width, height)

  self.isBonus = true
  self.properties = {}
  self.world:add(self, self:getRect())
end

function bonus:destroy()
  Entities:remove(self)
  self.world:remove(self)
end


function bonus:update(dt)
 
  self.animation.currentTime = self.animation.currentTime + dt
  if self.animation.currentTime >= self.animation.duration then
      self.animation.currentTime = self.animation.currentTime - self.animation.duration
  end

end

function bonus:draw()
    love.graphics.setColor(255, 255, 255)
    local spriteNum = math.floor(self.animation.currentTime / self.animation.duration * #self.animation.quads) + 1
    love.graphics.draw(self.animation.spriteSheet, self.animation.quads[spriteNum], self.x, self.y, 0, 1, 1)
    love.graphics.setColor(255, 255, 255)
    --love.graphics.print(inspect(debug, {depth = 1}), self.x,10)
    
end

return bonus
