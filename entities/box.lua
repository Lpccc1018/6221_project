local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

local box = Class{
  __includes = Entity -- box class inherits our Entity class
}

function box:init(world, x, y)
  self.img = love.graphics.newImage('/assets/crate.png')
  Entity.init(self, world, x, y, self.img:getWidth(), self.img:getHeight())

  -- Add our unique box values
  self.yVelocity = 0
  self.friction = 20 
  self.gravity = -30 -- we will accelerate towards the bottom
  self.isBox = true
  self.isPushPulling =false
  self.speed = 200
  self.properties = {}
  self.world:add(self, self:getRect())
end

function box:collisionFilter(other)
  local x, y, w, h = self.world:getRect(other)
  local boxBottom = self.y + self.h
  local boxFront = self.x

  if boxBottom <= y then 
    return 'slide'
  elseif other.isEnemy then
    return 'cross'
-------it seems it only registers a collide when it moves in a direction
  elseif boxFront < x or boxFront > x then
    return 'slide'
  end

end

function box:update(dt)
-- Apply gravity
    self.yVelocity = self.yVelocity - self.gravity * dt

    if self.isPushPulling then
      if love.keyboard.isDown("left", "a") then
        self.x = self.x - (self.speed * dt)
      elseif love.keyboard.isDown("right", "d") then
        self.x = self.x + (self.speed * dt)
      end
    end
  

  -- these store the location the player should arrive at 
  local goalX = self.x
  local goalY = self.y + self.yVelocity

  -- Move the player while testing for collisions
  self.x, self.y, collisions, len = self.world:move(self, goalX, goalY, self.collisionFilter)

  ------ Loop through collisions that were Returned Only in Filter !!!----------
  for i, coll in ipairs(collisions) do
    if coll.normal.y < 0 then
      self.yVelocity = 0 
    end

  end

end

function box:draw()
    love.graphics.draw(self.img, self.x, self.y)
end

return box
