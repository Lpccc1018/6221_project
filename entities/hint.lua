--
-- Created by IntelliJ IDEA.
-- User: pinchao
-- Date: 11/26/19
-- Time: 3:47 上午
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
local pick=love.graphics.newImage("assets/pick.png")
local hint = Class{
    __includes = Entity -- bonus class inherits our Entity class
}

function hint:init(world, x, y)
    Entity.init(self, world, x, y, width, height)
    self.world:add(self, self:getRect())
end

function hint:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(pick,2848,1088)
    --love.graphics.print(inspect(debug, {depth = 1}), self.x,10)

end

return hint