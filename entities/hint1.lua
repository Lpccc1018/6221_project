--
-- Created by IntelliJ IDEA.
-- User: pinchao
-- Date: 12/3/19
-- Time: 11:36 上午
-- To change this template use File | Settings | File Templates.
--

local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'
local inspect = require 'entities.inspect'
local LevelBase = require 'gamestates.LevelBase'
local Entities     = require 'entities.Entities'
local width=0.1
local height=0.1
local debug = 0
local pick=love.graphics.newImage("assets/hint1.png")
local hint1 = Class{
    __includes = Entity -- bonus class inherits our Entity class
}

function hint1:init(world, x, y)
    Entity.init(self, world, x, y, width, height)
    self.world:add(self, self:getRect())
end

function hint1:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(pick,self.x,self.y)
    --love.graphics.print(inspect(debug, {depth = 1}), self.x,10)

end

return hint1