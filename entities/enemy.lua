local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'
local Grenade  = require 'entities.grenade'
local LevelBase = require 'gamestates.LevelBase'
local Phi = 0.61803398875
local fireRange = 150
local debug = 0

local bullet = nil

local enemy = Class{
  __includes = Entity -- enemy class inherits our Entity class
}

function enemy:init(world, x, y)
  self.img = love.graphics.newImage('/assets/e1.png')
  self.animation = newAnimation(love.graphics.newImage('/assets/e1WalkSprite.png'), 54, 48, 1)
  Entity.init(self, world, x+200, y+200, self.img:getWidth(), self.img:getHeight())

  -- Add our unique enemy values
  self.yVelocity = 0
  self.speed = 50 -- the acceleration of our enemy
  self.gravity = -30 -- we will accelerate towards the bottom
  self.jumpHeight = -15 -- how fast do we accelerate towards the top
  self.flip = 1
  self.target = 1
  self.isEnemy = true
  self.bulletExists = false
  self.properties = {}
  self.width = self.img:getWidth()
  self.height = self.img:getHeight()
  self.soundFire = love.audio.newSource("/assets/bang_01.ogg","static")
  self.world:add(self, self:getRect())
end

function newAnimation(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {};
    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end
    animation.duration = duration or 1
    animation.currentTime = 0
 
    return animation
end

function playSound(sound)
    love.audio.play(sound)
    sound:seek(0)
end

function enemy:getCenter()
  return self.x + self.img:getWidth() / 2,
         self.y + self.img:getHeight() * (1 - Phi)
end

function enemy:fire()
  local cx, cy = self:getCenter()
  local tx, ty = self.target:getCenter()
  local vx, vy = (tx - cx) * 3, (ty - cy) * 3
  playSound(self.soundFire)
  bullet = Grenade(self.world, self, cx, cy, vx, vy)
  LevelBase.Entities:add(bullet)
end

function enemy:collisionFilter(other)
  local x, y, w, h = self.world:getRect(other)
  local enemyBottom = self.y + self.h
  local enemyFront = self.x
  -- enemy slides when it lands on a platform.
  if enemyBottom <= y then 
    return 'slide'
  end
 --enemy flips when it hits something on either of its side 
  if enemyFront < x  and enemyFront - x > -self.width and not other.bomb then
    self.flip = -1
  elseif enemyFront > x and enemyFront - x < w and not other.bomb then
    self.flip = 1
  end
end

function enemy:update(dt)
    --move and change direction
    self.x = self.x + (self.speed * dt) * self.flip
  
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
---------------------------
  local items, len = self.world:queryRect(self.x - fireRange, self.y, self.img:getWidth() + fireRange*2, self.img:getHeight())
  for i=1, len do
    info = items[i]
    if info ~= nil and info.isPlayer then
        self.target = info
        if not self.bulletExists then
            self:fire()
            self.bulletExists = true
        end
        return 'bounce'
    end
  end
---------------------------
  self.animation.currentTime = self.animation.currentTime + dt
  if self.animation.currentTime >= self.animation.duration then
      self.animation.currentTime = self.animation.currentTime - self.animation.duration
  end

end

function enemy:draw()
    --love.graphics.draw(self.img, self.x, self.y)
    local spriteNum = math.floor(self.animation.currentTime / self.animation.duration * #self.animation.quads) + 1
    if self.flip == -1 then
      love.graphics.draw(self.animation.spriteSheet, self.animation.quads[spriteNum], self.x, self.y, 0, 1, 1)
    else
      love.graphics.draw(self.animation.spriteSheet, self.animation.quads[spriteNum], self.x, self.y, 0, -1, 1, self.width, 0)
    end
    --love.graphics.rectangle('line', self.x - fireRange, self.y, self.img:getWidth() + fireRange*2, self.img:getHeight())  
end

return enemy
