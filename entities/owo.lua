--
-- Created by IntelliJ IDEA.
-- User: pinchao
-- Date: 12/3/19
-- Time: 12:27 下午
-- To change this template use File | Settings | File Templates.
--

local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'
local inspect = require 'entities.inspect'
local LevelBase = require 'gamestates.LevelBase'
local Entities     = require 'entities.Entities'
local width = 25
local height = 25
local debug = 0
local resetflag1=false

local owo = Class{
    __includes = Entity -- bonus class inherits our Entity class
}

function owo:init(world, x, y)
    self.img = love.graphics.newImage('/assets/star.png')
    Entity.init(self, world, x, y, width, height)

    self.isOwO = true
    self.properties = {}
    self.world:add(self, self:getRect())
end

function owo:destroy()
    Entities:remove(self)
    self.world:remove(self)
end

function owo:reset()
    resetflag1=true
end


function owo:draw()
    if resetflag1 then
        resetflag1=false
        self.world:remove(self)
        self.world:add(self,self:getRect())
    end
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.img, self.x, self.y)
    love.graphics.setColor(255, 255, 255)

    --love.graphics.print(inspect(debug, {depth = 1}), self.x,10)

end

return owo