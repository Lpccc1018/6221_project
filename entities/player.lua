local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'
local Entities = require 'entities.Entities'
local inspect = require 'entities.inspect'
local camera = require 'libs.camera'
local LevelBase = require 'gamestates.LevelBase'
local Gamestate = require 'libs.hump.gamestate'
local Portal  = require 'entities.portal'
local message = ""
local Phi = 0.61803398875
local swingX = 0
local portBox = nil
local portHub = {}
local porting = false
local isGravityActive = true
local movableItem = nil

local player = Class{
  __includes = Entity -- Player class inherits our Entity class
}

function player:init(world, x, y)
  self.img = love.graphics.newImage('/assets/player.png')

  Entity.init(self, world, x, y, self.img:getWidth(), self.img:getHeight())

  -- Add our unique player values
  self.yVelocity = 0
  self.speed = 200 -- the acceleration of our player
  self.gravity = -300 -- we will accelerate towards the bottom
  self.jumpHeight = -300 -- how fast do we accelerate towards the top
  self.isPlayer = true
  self.target = "Player"
  self.health = 3
  self.lives = 3
  self.bonus = 0
  self.portalExists = false
  self.portals = 0
  self.flipGun = 1
  self.isJumping = false
  self.isClimbing = false
  self.swingJump = 0
  self.soundPort = love.audio.newSource("/assets/Jump 1_Macro.wav","static")
  self.world:add(self, self:getRect())
end

function replace_tile(map, layer, tilex, tiley, newTileGid)
  layer = map.layers[layer]
  for i, instance in ipairs(map.tileInstances[layer.data[tiley][tilex].gid]) do
    if instance.layer == layer and instance.x/map.tilewidth+1 == tilex and instance.y/map.tileheight+1 == tiley then
      instance.batch:set(instance.id, map.tiles[newTileGid].quad, instance.x, instance.y)
      break
    end
  end
end

function player:getCenter()
  return self.x + self.img:getWidth() / 2,
         self.y + self.img:getHeight() * (1 - Phi)
end

function player:destroyPortals()
    for i=1,#portHub do
        Entities:remove(portHub[i])
        self.world:remove(portHub[i])
    end
    self.portals = 0
    portHub = {}
end

function player:fire()
  local cx, cy = self:getCenter()
  cx = cx + 30 * self.flipGun
  local tx, ty = self.x + 150 * self.flipGun , self.y - 5
  local vx, vy = (tx - cx) * 3, (ty - cy) * 3
  portBox = Portal(self.world, self, cx, cy, vx, vy)
  LevelBase.Entities:add(portBox)
  portHub[#portHub + 1] = portBox
end

function player:collisionFilter(other)
  local x, y, w, h = self.world:getRect(other)
  local playerBottom = self.y + self.h
  local playerFront = self.x

  if porting or other.isBonus then
    return 'cross'
    -- bottom of player collides with top of platform.
  elseif other.swing then
    return 'cross'
  elseif other.isEnemy then
    return 'cross'
  elseif playerBottom <= y and not other.properties.isRope then 
    return 'slide'
  elseif other.properties.isRope then
    return 'cross'
  elseif playerFront < x or playerFront > x then
    return 'slide'
  end

end

function player:update(dt)
  origX = self.x
  origY = self.y

  if love.keyboard.isDown("lshift") then
    self.speed = 300
  else
    self.speed = 200
  end
  
  if love.keyboard.isDown("z") then
    if self.portals == 2 then
        self:destroyPortals()
    elseif not self.portalExists and self.portals ~= 2 then
        self:fire()
        self.portalExists = true
    end
  end

  if love.keyboard.isDown(settings[4], "a") then
    self.x = self.x - (self.speed * dt)
    self.flipGun = -1
  elseif love.keyboard.isDown(settings[5], "d") then
    self.x = self.x + (self.speed * dt)
    self.flipGun = 1
  end

  -- The Jump code gets a lttle bit crazy.  Bare with me.
  if love.keyboard.isDown(settings[6], "w") then
    if self.yVelocity == 0 and not self.isClimbing then
      swingX = 0
      self.yVelocity = self.jumpHeight - self.swingJump
      self.isJumping = true
      self.swingJump = 0
    end
  end

-- Apply gravity if player has "jumped" and left the ground.
    if self.isJumping then                                      		
      self.yVelocity = self.yVelocity - (self.gravity * dt)                
	end
    
  --Apply gravity all the time
    if isGravityActive then
      self.yVelocity = self.yVelocity - (self.gravity * dt)
    end
    isGravityActive = true

  -- these store the location the player should arrive at 
  local goalX = self.x
  local goalY = self.y + self.yVelocity * dt

  -- Move the player while testing for collisions
  self.x, self.y, collisions, len = self.world:move(self, goalX, goalY, self.collisionFilter)


  -- Loop through those collisions to see if anything important is happening
  for i, coll in ipairs(collisions) do

    if coll.other.properties.isRope then
      if coll.other.x - self.x > -10 then
        self.yVelocity = 0
        isGravityActive = false 
        self.isJumping = false
        self.isClimbing = true
      end
    --when player lands on a surface
    elseif coll.normal.y < 0 then
      self.yVelocity = 0
      self.isJumping = false
      self.isClimbing = false
      if coll.other.tramp and love.keyboard.isDown("down") then 
          self.yVelocity = -400
          coll.other.bounce = true
      end
    --when player's head hits an object reduce yVelocity/jump to -1
    elseif coll.normal.y > 0 then
      self.yVelocity = -1 
    elseif coll.other.isBox and love.keyboard.isDown("e") then
      movableItem = coll.other
      movableItem.isPushPulling = true
    end
    -------------------------
    if coll.other.isBonus then
      self.bonus = self.bonus + 1
      coll.other:destroy()
    end

    if coll.other.properties ~= nil then
      if coll.other.properties.isRope then
        if love.keyboard.isDown("up") and love.keyboard.isDown("e") then
            self.y = self.y - 1
        elseif love.keyboard.isDown("down") and love.keyboard.isDown("e") then
            self.y = self.y + 1
        end
      elseif coll.other.properties.isHealth then
          self.health = self.health + 1
          local map = LevelBase:getMap()
          replace_tile(map, 1, 13, 2, 123)
      elseif coll.other.properties.isLife then
          self.lives = self.lives + 1
      elseif coll.other.properties.isExit then
          Gamestate.push(gameTransition)
      end
    end
----------------------------

    if coll.other.swing then
      if self.y > coll.other.y + coll.other.img:getHeight() - 5 then
        self.y = coll.other.y + coll.other.img:getHeight() 
        self.y = self.y + 5
      elseif self.x < coll.other.x and self.y + self.h > coll.other.y + coll.other.img:getHeight() then
        self.x = self.x - 15
        self.y = origY
      elseif self.x > coll.other.x and self.y + self.h > coll.other.y + coll.other.img:getHeight() then
        self.x = self.x + 15
        self.y = origY
      end
      if self.y + self.h <= coll.other.y + coll.other.img:getHeight() then
        self.yVelocity = 0
        if swingX == 0 or love.keyboard.isDown("left", "a") or love.keyboard.isDown("right", "d") then
          swingX = self.x - coll.other.x
        end
        self.x = coll.other.x + swingX
        self.y = coll.other.y - (self.h )
      end
    else
        swingX = 0
    end

--------------------------

    if self.health <= 0 then
      self.lives = self.lives - 1
      if self.lives == 0 then
          Gamestate.push(gamefinished)
      end
      self.health = 3
    end

-----------------------------

    if coll.other.portalBomb then
      if coll.other == portHub[1] then
          porting = false
      else
          porting = true
          self.soundPort:play()
          self.x, self.y = portHub[1].l + (portHub[1].w / 2) - (self.w / 2), portHub[1].t - (self.h + 5)
      end
    end

  end

end

function love.keyreleased(key)
  if key == "e" then
    if movableItem ~= nil then
      movableItem.isPushPulling = false
      movableItem = nil
    end
   end
end

function player:draw()
  love.graphics.draw(self.img, self.x, self.y)
  love.graphics.print("Health: "..self.health, camera.x + 10, camera.y + 10)
  love.graphics.print("Lives: "..self.lives, camera.x + 10, camera.y + 20)
  love.graphics.print("Coins: "..self.bonus, camera.x + 10, camera.y + 30)
  love.graphics.print(message, self.x-50,310)
end

return player
