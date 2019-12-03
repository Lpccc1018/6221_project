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
local requirecoins=5
local resetflag=false
local portalflag=false
local OwOflag=0
local isDead = false
local reminderFlag = false
local resetX = 32
local resetY = 32

stagelable=nil

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
  self.jumpHeight = -350 -- how fast do we accelerate towards the top
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
  self.soundPort = love.audio.newSource("/assets/jump.wav","static")
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

function player:reset()
  resetflag=true
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
      self.soundPort:play()
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
      if coll.other.tramp and love.keyboard.isDown("s") then
          self.yVelocity = -350
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
      love.audio.play(audio1)
      self.bonus = self.bonus + 1
      coll.other:destroy()
      reminderFlag = false
    end
    if coll.other.isOwO then
      love.audio.play(audio2)
      OwOflag=OwOflag+1
      coll.other:destroy()

    end
    if coll.other.isFake then
      coll.other:destroy()
      love.audio.play(audio)
    end
    if coll.other.isPortal then
      portalflag = true
    end

    if coll.other.properties ~= nil then
      if coll.other.properties.isRope then
        if love.keyboard.isDown("w")  then
            self.y = self.y - 1
        elseif love.keyboard.isDown("s")  then
            self.y = self.y + 1
        end
      elseif coll.other.properties.isHealth then
          self.health = self.health + 1
          local map = LevelBase:getMap()
          replace_tile(map, 1, 13, 2, 123)
      elseif coll.other.properties.isLife then
          self.lives = self.lives + 1
      elseif coll.other.properties.isExit then
        if(self.bonus==5) then
          resetX = 32
          resetY = 32
          Gamestate.push(gameTransition)
          self.bonus=0
        elseif reminderFlag == false then
        	reminderFlag = true
        	Gamestate.push(reminder)
        end
      elseif coll.other.properties.isDead and not isDead then
        self.health=0
        self.lives=0
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
      if self.lives <= 0 then
        isDead = true
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
  if resetflag then
     resetflag=false
    isDead = false
    self.x=resetX
    self.y=resetY
    self.world:remove(self)
    self.world:add(self,self:getRect())
    self.lives=1
    self.health=3
  end
if stagelable==1 then
  if portalflag then
    if self.x+self.img:getWidth()==portal1.x or self.x==portal1.x+64 then
    portalflag=false
    self.x=portal2.x+100
    self.y=portal2.y
    self.world:remove(self)
    self.world:add(self,self:getRect())
    end
  end
  if portalflag  then
    if self.x+self.img:getWidth()==portal2.x or self.x==portal2.x+64 then
    portalflag=false
    self.x=portal1.x+100
    self.y=portal1.y
    self.world:remove(self)
    self.world:add(self,self:getRect())
      end
  end
  if portalflag then
    if self.x+self.img:getWidth()==portal3.x or self.x==portal3.x+64 then
    portalflag=false
    self.x=3488
    self.y=1312
    self.world:remove(self)
    self.world:add(self,self:getRect())
    end
  end
  if portalflag and stagelable==1  then
    if self.x+self.img:getWidth()==portal4.x or self.x==portal4.x+64 then
      portalflag=false
      self.x=3648
      self.y=160
      resetX = 3648
      resetY = 160
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end
  if portalflag  then
    if self.x+self.img:getWidth()==portal5.x or self.x==portal5.x+64 then
      portalflag=false
      self.x=1409
      self.y=450
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end
    if portalflag  then
        if self.x+self.img:getWidth()==portal6.x or self.x==portal6.x+64 then
            portalflag=false
            self.x=32
            self.y=32
            self.world:remove(self)
            self.world:add(self,self:getRect())
        end
    end
    if portalflag  then
        if self.x+self.img:getWidth()==portal7.x or self.x==portal7.x+64 then
            portalflag=false
            self.x=1409
            self.y=450
            self.world:remove(self)
            self.world:add(self,self:getRect())
        end
    end
end
    -- ————————————————————————————————————————————————————————————————————————————
  if portalflag  then
    if self.x+self.img:getWidth()==portal8.x or self.x==portal8.x+64 then
      portalflag=false
      self.x=1210
      self.y=224
      resetX = 1210
      resetY = 224
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
    end
  if portalflag  then
    if self.x+self.img:getWidth()==portal9.x or self.x==portal9.x+64 then
      portalflag=false
      self.x=2400
      self.y=160
      resetX = 2400
      resetY = 161
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
    end
  if portalflag and self.y==992-50  then
    if self.x+self.img:getWidth()==portal10.x or self.x==portal10.x+64 then
      portalflag=false
      self.x=4480
      self.y=1152
      self.world:remove(self)
      self.world:add(self,self:getRect())
  end
  end
  if portalflag and self.y==704-50 then
    if self.x+self.img:getWidth()==portal11.x or self.x==portal11.x+64 then
      portalflag=false
      self.x=4512
      self.y=928
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
    end
  if portalflag and self.y==704-50 then
    if self.x+self.img:getWidth()==portal12.x or self.x==portal12.x+64 then
      portalflag=false
      self.x=4480
      self.y=1504
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end

  if portalflag and self.y==704-50 then
    if self.x+self.img:getWidth()==portal13.x or self.x==portal13.x+64 then
      portalflag=false
      self.x=4512
      self.y=416
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end

  if portalflag and self.y==704-50 then
    if self.x+self.img:getWidth()==portal14.x or self.x==portal14.x+64 then
      portalflag=false
      self.x=3584
      self.y=1504
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end

  if portalflag and self.y==992-50 then
    if self.x+self.img:getWidth()==portal15.x or self.x==portal15.x+64 then
      portalflag=false
      self.x=4512
      self.y=672
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end

  if portalflag and self.y==992-50 then
    if self.x+self.img:getWidth()==portal16.x or self.x==portal16.x+64 then
      portalflag=false
      self.x=4512
      self.y=416
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end

  if portalflag and self.y==992-50 then
    if self.x+self.img:getWidth()==portal17.x or self.x==portal17.x+64 then
        portalflag=false
        self.x=4000
        self.y=416
        self.world:remove(self)
        self.world:add(self,self:getRect())
    end
  end

  if portalflag and self.y==992-50 then
    if self.x+self.img:getWidth()==portal18.x or self.x==portal18.x+64 then
      portalflag=false
      self.x=3200
      self.y=1504
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end

  if portalflag and self.y==1312-50  then
    if self.x+self.img:getWidth()==portal19.x or self.x==portal19.x+64 then
      portalflag=false
      self.x=4000
      self.y=928
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end

  if portalflag and self.y==1312-50 then
    if self.x+self.img:getWidth()==portal20.x or self.x==portal20.x+64 then
      portalflag=false
      self.x=4512
      self.y=672
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end

  if portalflag and self.y==1312-50 then
    if self.x+self.img:getWidth()==portal21.x or self.x==portal21.x+64 then
      portalflag=false
      self.x=3584
      self.y=1504
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end

  if portalflag and self.y==1312-50 then
    if self.x+self.img:getWidth()==portal22.x or self.x==portal22.x+64 then
      portalflag=false
      self.x=3168
      self.y=928
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end

  if portalflag and self.y==1568-50  then
    if self.x+self.img:getWidth()==portal23.x or self.x==portal23.x+64 then
      portalflag=false
      self.x=4000
      self.y=416
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end
  if portalflag and self.y==1568-50 then
    if self.x+self.img:getWidth()==portal24.x or self.x==portal24.x+64 then
      portalflag=false
      self.x=2656
      self.y=640
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end

  if portalflag and self.y==1568-50  then
    if self.x+self.img:getWidth()==portal25.x or self.x==portal25.x+64 then
        portalflag=false
        self.x=4512
        self.y=416
        self.world:remove(self)
        self.world:add(self,self:getRect())
    end
  end

  if portalflag and self.y==1568-50 then
    if self.x+self.img:getWidth()==portal26.x or self.x==portal26.x+64 then
      portalflag=false
      print("26")
      self.x=3584
      self.y=1248
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end

  if portalflag and self.y==480-50 then
    if self.x+self.img:getWidth()==portal28.x or self.x==portal28.x+64 then
      portalflag=false
      self.x=3616
      self.y=1504
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end

  if portalflag and self.y==480-50 then
    if self.x+self.img:getWidth()==portal29.x or self.x==portal29.x+64 then
      portalflag=false
      self.x=4544
      self.y=928
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end

  if portalflag and self.y==480-50 then
    if self.x+self.img:getWidth()==portal30.x or self.x==portal30.x+64 then
      portalflag=false
      self.x=4000
      self.y=1504
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end

  if portalflag and self.y==480-50 then
    if self.x+self.img:getWidth()==portal31.x or self.x==portal31.x+64 then
      portalflag=false
      self.x=4000
      self.y=672
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end

  if portalflag and self.y==736-50 then
    if self.x+self.img:getWidth()==portal32.x or self.x==portal32.x+64 then
      portalflag=false
      self.x=3584
      self.y=1504
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end

  if portalflag and self.y==736-50 then
    if self.x+self.img:getWidth()==portal33.x or self.x==portal33.x+64 then
      portalflag=false
      self.x=3168
      self.y=928
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end

  if portalflag and self.y==736-50 then
    if self.x+self.img:getWidth()==portal34.x or self.x==portal34.x+64 then
      portalflag=false
      self.x=4000
      self.y=1504
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end

  if portalflag and self.y==736-50 then
    if self.x+self.img:getWidth()==portal35.x or self.x==portal35.x+64 then
      portalflag=false
      self.x=3168
      self.y=640
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end

  if portalflag and self.y==992-50 then
    if self.x+self.img:getWidth()==portal36.x or self.x==portal36.x+64 then
      portalflag=false
      self.x=736
      self.y=1088
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end

  if portalflag and self.y==992-50 then
    if self.x+self.img:getWidth()==portal37.x or self.x==portal37.x+64 then
      portalflag=false
      self.x=4032
      self.y=1504
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end

  if portalflag and self.y==992-50 then
    if self.x+self.img:getWidth()==portal38.x or self.x==portal38.x+64 then
      portalflag=false
      self.x=4000
      self.y=416
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end

  if portalflag and self.y==992-50  then
  if self.x+self.img:getWidth()==portal39.x or self.x==portal39.x+64 then
    portalflag=false
    self.x=736
    self.y=1088
    self.world:remove(self)
    self.world:add(self,self:getRect())
  end
end

  if portalflag and self.y==1216-50 then
    if self.x+self.img:getWidth()==portal40.x or self.x==portal40.x+64 then
      portalflag=false
      self.x=736
      self.y=1088
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end

if portalflag and self.y==1216-50 then
  if self.x+self.img:getWidth()==portal41.x or self.x==portal41.x+64 then
    portalflag=false
    self.x=2688
    self.y=928
    self.world:remove(self)
    self.world:add(self,self:getRect())
  end
end

  if portalflag and self.y==1216-50 then
  if self.x+self.img:getWidth()==portal42.x or self.x==portal42.x+64 then
    portalflag=false
    self.x=736
    self.y=1088
    self.world:remove(self)
    self.world:add(self,self:getRect())
  end
  end

  if portalflag and self.y==1216-50 then
    if self.x+self.img:getWidth()==portal43.x or self.x==portal43.x+64 then
      portalflag=false
      self.x=4000
      self.y=1504
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end

  if portalflag and self.y==1568-50 then
    if self.x+self.img:getWidth()==portal44.x or self.x==portal44.x+64 then
      portalflag=false
      self.x=3200
      self.y=1248
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end
  if portalflag and self.y==1568-50 then
    if self.x+self.img:getWidth()==portal45.x or self.x==portal45.x+64 then
      portalflag=false
      self.x=4512
      self.y=672
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end

  if portalflag and self.y==1568-50 then
    if self.x+self.img:getWidth()==portal46.x or self.x==portal46.x+64 then
      portalflag=false
      self.x=2400
      self.y=160
      self.world:remove(self)
      self.world:add(self,self:getRect())
    end
  end

    if OwOflag==1 then
            self.img=love.graphics.newImage('assets/player2.png')
            self.w=10
            self.h=10
            self.world:remove(self)
            self.world:add(self,self:getRect())
    end
    if OwOflag==2 then
        self.img=love.graphics.newImage('assets/player.png')
        self.w=28
        self.h=50
        self.world:remove(self)
        self.world:add(self,self:getRect())
    end


  love.graphics.draw(self.img, self.x, self.y)
  love.graphics.print("Health: "..self.health, camera.x + 10, camera.y + 10)
  love.graphics.print("Lives: "..self.lives, camera.x + 10, camera.y + 20)
  love.graphics.print("Coins: "..self.bonus, camera.x + 10, camera.y + 30)
  love.graphics.print(message, self.x-50,310)
end

return player
