local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

local tramp = Class{
  __includes = Entity -- tramp class inherits our Entity class
}

function tramp:init(world, x, y)
  self.img = love.graphics.newImage('/assets/tramp1.png')
  self.img1 = love.graphics.newImage('/assets/tramp2.png')
  Entity.init(self, world, x, y, self.img:getWidth(), self.img:getHeight())

  -- Add our unique tramp values
  self.yVelocity = 0
  self.speed = 50 -- the acceleration of our tramp
  self.gravity = -30 -- we will accelerate towards the bottom
  self.tramp = true
  self.properties = {}
  self.bounce = false
  self.soundBounce = love.audio.newSource("/assets/shoot_dorkster.ogg","static")
  self.world:add(self, self:getRect())
end

function tramp:getCenter()
end

function tramp:collisionFilter(other)
  local x, y, w, h = self.world:getRect(other)
  local trampBottom = self.y + self.h
  local trampFront = self.x

  if other.isPlayer then
    return 'cross'
  elseif trampBottom <= y then -- bottom of player collides with top of platform.
    return 'slide'
  end

end

function tramp:update(dt)
  
-- Apply gravity
    self.yVelocity = self.yVelocity - self.gravity * dt
 
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
  --------------------

end

function tramp:draw()
    love.graphics.setColor(255, 255, 0)
    if self.bounce then
      self.soundBounce:play()
      love.graphics.draw(self.img1, self.x, self.y)
      self.bounce = false
    else
      love.graphics.draw(self.img, self.x, self.y)
    end
    love.graphics.setColor(255, 255, 255)
    
end

return tramp
