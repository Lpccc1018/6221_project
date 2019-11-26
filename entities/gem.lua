local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'
local inspect = require 'entities.inspect'
local LevelBase = require 'gamestates.LevelBase'
local Entities     = require 'entities.Entities'
local width = 25
local height = 25
local debug = 0

local gem = Class{
  __includes = Entity -- bonus class inherits our Entity class
}

function gem:init(world, x, y)
  self.animation = newAnimation(love.graphics.newImage('/assets/MonedaD.png'), width, height, 1)
  Entity.init(self, world, x, y, width, height)

  self.isBonus = true
  self.properties = {}
  self.world:add(self, self:getRect())
end

function gem:destroy()
  Entities:remove(self)
  self.world:remove(self)
end


function gem:update(dt)
 
  self.animation.currentTime = self.animation.currentTime + dt
  if self.animation.currentTime >= self.animation.duration then
      self.animation.currentTime = self.animation.currentTime - self.animation.duration
  end

end

function gem:draw()
    love.graphics.setColor(255, 255, 255)
    local spriteNum = math.floor(self.animation.currentTime / self.animation.duration * #self.animation.quads) + 1
    love.graphics.draw(self.animation.spriteSheet, self.animation.quads[spriteNum], self.x, self.y, 0, 1, 1)
    love.graphics.setColor(255, 255, 255)
    --love.graphics.print(inspect(debug, {depth = 1}), self.x,10)
    
end

return gem
