local Class = require 'libs.hump.class'
local Entity     = require 'entities.Entity'
local Entities     = require 'entities.Entities'

local Grenade = Class{
  __includes = Entity -- enemy class inherits our Entity class
}

Grenade.radius = 8
local Phi = 0.61803398875

local width             = math.sqrt(2 * Grenade.radius * Grenade.radius)
local height            = width
local bounciness        = 0.4 -- How much energy is lost on each bounce. 1 is perfect bounce, 0 is no bounce
local lifeTime          = 4   -- Lifetime in seconds
local bounceSoundSpeed  = 30  -- How fast must a grenade go to make bouncing noises
local gravityAccel = 500
local debug = 0


function Grenade:init(world, parent, x, y, vx, vy)
  Entity.init(self, world, x, y, width, height)
  self.world, self.l, self.t, self.w, self.h = world, x,y,width,height
  self.world:add(self, x,y,width,height)
  self.created_at = love.timer.getTime()
---------
  self.parent = parent
  self.vx, self.vy  = vx, vy
  self.lived = 0
  self.ignoresParent = true
  self.bomb = true
  self.properties = {}
end

function Grenade:changeVelocityByCollisionNormal(nx, ny, bounciness)
  bounciness = bounciness or 0
  local vx, vy = self.vx, self.vy

  if (nx < 0 and vx > 0) or (nx > 0 and vx < 0) then
    vx = -vx * bounciness
  end

  if (ny < 0 and vy > 0) or (ny > 0 and vy < 0) then
    vy = -vy * bounciness
  end

  self.vx, self.vy = vx, vy
end

function Grenade:getCenter()
  return self.x + width / 2,
         self.y + height * (1 - Phi)
end

function Grenade:changeVelocityByGravity(dt)
  self.vy = self.vy + gravityAccel * dt
end

function Grenade:filter(other)
  local x, y, w, h = self.world:getRect(other)
  local grenadeBottom = self.t + height
  local grenadeFront = self.l

  if other.target == 'Player'
  or grenadeBottom <= y
  or grenadeFront < x and other ~= self.parent or grenadeFront > x and other ~= self.parent
  then
    return "bounce"
  end
end

function Grenade:getBounceSpeed(nx, ny)
  if nx == 0 then return math.abs(self.vy) else return math.abs(self.vx) end
end

function Grenade:moveColliding(dt)
  local world = self.world
  local parent = self.parent

  local future_l = self.l + self.vx * dt
  local future_t = self.t + self.vy * dt

  local next_l, next_t, cols, len = world:move(self, future_l, future_t, self.filter)

  for i=1, len do
    local col = cols[1]
    if col.other.target == 'Player' then
      self:destroy()
      col.other.health = col.other.health - 1
      return
    end

    if col.other ~= parent or not self.ignoresParent then
      local nx, ny = col.normal.x, col.normal.y
      self:changeVelocityByCollisionNormal(nx,ny, bounciness)
    end
  end

  self.l, self.t = next_l, next_t
end

function Grenade:detectExitedParent()
  if self.ignoresParent then
    local parent = self.parent
    local x1,y1,w1,h1 = self.l, self.t, self.w, self.h
    local x2,y2,w2,h2 = parent.x, parent.y, parent.w, parent.h
    self.ignoresParent = x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
  end
end

function Grenade:update(dt)
  self.lived = self.lived + dt
  if self.lived >= lifeTime then
    self:destroy()
  else
    self:changeVelocityByGravity(dt)
    self:moveColliding(dt)
    self:detectExitedParent()
  end
end

function Grenade:draw(drawDebug)
    love.graphics.print(debug, self.x,20)
  if drawDebug then
    love.graphics.setColor(255,55,55)
    love.graphics.rectangle('line', self.l, self.t, self.w, self.h)
    love.graphics.setColor(255,255,255)
  end
end

function Grenade:destroy()
  self.parent.bulletExists = false
  Entities:remove(self)
  self.world:remove(self)
end

return Grenade
