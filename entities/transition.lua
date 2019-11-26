--
-- Created by IntelliJ IDEA.
-- User: pinchao
-- Date: 11/25/19
-- Time: 6:01 下午
-- To change this template use File | Settings | File Templates.
--

local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'
local inspect = require 'entities.inspect'
local LevelBase = require 'gamestates.LevelBase'
local Entities     = require 'entities.Entities'
local width = 64
local height = 64
local debug = 0

local transition = Class{
    __includes = Entity -- bonus class inherits our Entity class
}

function transition:init(world, x, y)
    self.animation = newAnimation(love.graphics.newImage('/assets/Green Portal Sprite Sheet.png'), width, height, 1)
    Entity.init(self, world, x, y, width, height)

    self.isPortal = true
    self.properties = {}
    self.world:add(self, self:getRect())
end


function transition:update(dt)

    self.animation.currentTime = self.animation.currentTime + dt
    if self.animation.currentTime >= self.animation.duration then
        self.animation.currentTime = self.animation.currentTime - self.animation.duration
    end

end

function transition:draw()
    love.graphics.setColor(255, 255, 255)
    local spriteNum = math.floor(self.animation.currentTime / self.animation.duration * #self.animation.quads) + 1
    love.graphics.draw(self.animation.spriteSheet, self.animation.quads[spriteNum], self.x, self.y, 0, 1, 1)
    love.graphics.setColor(255, 255, 255)
    --love.graphics.print(inspect(debug, {depth = 1}), self.x,10)

end

return transition