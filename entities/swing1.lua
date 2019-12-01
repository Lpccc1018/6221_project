--
-- Created by IntelliJ IDEA.
-- User: pinchao
-- Date: 11/30/19
-- Time: 7:29 下午
-- To change this template use File | Settings | File Templates.
--
local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'
local Entities     = require 'entities.Entities'
local inspect = require 'entities.inspect'
local S = 40
local flip = 12
local ox = 600
local oy = 100

local swing1 = Class{
    __includes = Entity -- swing class inherits our Entity class
}

function swing1:init(world, x, y)
    self.img = love.graphics.newImage('/assets/platform.png')
    Entity.init(self, world, x, y, self.img:getWidth(), self.img:getHeight())

    -- Add our unique swing values
    self.swing = true
    self.properties = {}
    self.world:add(self, self:getRect())
    ox, oy = x, y
end

function swing1:getCenter()
end

function swing1:collisionFilter(other)
    local x, y, w, h = self.world:getRect(other)
    local swingBottom = self.y + self.h
    local swingFront = self.x

    return null

end

function swing1:update(dt)
    --change direction clockwork

    local theta, x1,y1, x2,y2
    local r, R = 0, 50
    --local ox, oy = love.graphics.getWidth()*0.5, love.graphics.getHeight()*0.5
    theta = 2*math.pi/60 * (S) +math.pi/2
    x1 = r * math.cos(theta) + ox
    y1 = r * math.sin(theta) + oy
    x2 = R * math.cos(theta) + ox
    y2 = R * math.sin(theta) + oy
    goalX = x2
    goalY = y2
    if S >= 45 then
        flip = -10
    elseif S <= 15 then
        flip = 10
    end
    S = S + flip * dt

    -- Move the player while testing for collisions
    self.x, self.y, collisions, len = self.world:move(self, goalX, goalY, self.collisionFilter)

    ------ Loop through collisions that were Returned Only in Filter !!!----------
    for i, coll in ipairs(collisions) do
        if coll.other.player then
            coll.other.x = coll.other.x - 1
            --flip = 0 - flip
            --if flip < 0 then S = S - 1 else S = S + 1 end
        elseif coll.normal.y < 0 then
            --nothing to do
        end
    end


end

--Note: dropping an object on the swing may cause unexpected behaviour
-- adding trampoline may be causing the swing to stutter

function swing1:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.img, self.x, self.y)
    love.graphics.setColor(255, 255, 255)
end

return swing1

