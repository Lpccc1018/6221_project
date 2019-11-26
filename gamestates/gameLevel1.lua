-- Import our libraries.
local Gamestate = require 'libs.hump.gamestate'
local Class = require 'libs.hump.class'

-- Grab our base class
local LevelBase = require 'gamestates.LevelBase'

-- Import the Entities we will build.
Player = require 'entities.player'
local Enemy = require 'entities.enemy'
local Box = require 'entities.box'
local Tramp = require 'entities.tramp'
local Swing = require 'entities.swing'
local Bonus = require 'entities.gem'
local Portal = require 'entities.transition'
local camera = require 'libs.camera'
local fake=require 'entities.fakegem'


-- Declare a couple immportant variables
player = nil
enemy = nil
box = nil
tramp = nil
swing = nil
bonus = nil

gameLevel1 = Class{
  __includes = LevelBase
}

function gameLevel1:init()
  
end

function gameLevel1:enter()
  LevelBase.init(self, 'assets/levels/level_1.lua')
  player = Player(self.world,  32, 32)
  LevelBase.Entities:add(player)
  enemy = Enemy(self.world,  384, 576)
  LevelBase.Entities:add(enemy)
  enemy2 = Enemy(self.world,  256, 864)
  LevelBase.Entities:add(enemy2)
  enemy3 = Enemy(self.world,  2816, 1312)
  LevelBase.Entities:add(enemy3)
  box = Box(self.world,  320, 320)
  LevelBase.Entities:add(box)
  swing = Swing(self.world,  32, 32)
  LevelBase.Entities:add(swing)
  portal1 =Portal(self.world,  416, 1504)
  LevelBase.Entities:add(portal1)
  portal2 =Portal(self.world,  1536, 448)
  LevelBase.Entities:add(portal2)
  portal3 =Portal(self.world,  3872, 1504)
  LevelBase.Entities:add(portal3)
  bonus = Bonus(self.world,  1600, 928)
  LevelBase.Entities:add(bonus)
  bonus1 = Bonus(self.world,  1536, 1344)
  LevelBase.Entities:add(bonus1)
  bonus1 = Bonus(self.world,  3808, 1536)
  LevelBase.Entities:add(bonus1)
  bonus1 = Bonus(self.world,  3488, 128)
  LevelBase.Entities:add(bonus1)
  bonus1 = Bonus(self.world,  2496, 480)
  LevelBase.Entities:add(bonus1)
  fakebonus=fake(self.world,  1376, 480)
  LevelBase.Entities:add(fakebonus)
  fakebonus1=fake(self.world,  1600, 1120)
  LevelBase.Entities:add(fakebonus1)
  fakebonus2=fake(self.world,  1600, 1504)
  LevelBase.Entities:add(fakebonus2)
  fakebonus3=fake(self.world,  4736, 1536)
  LevelBase.Entities:add(fakebonus3)
  tramp1=Tramp(self.world,  3000, 960)
  LevelBase.Entities:add(tramp1)
  tramp2=Tramp(self.world,  3050, 480)
  LevelBase.Entities:add(tramp2)
end

function gameLevel1:update(dt)
  self.map:update(dt) -- remember, we inherited map from LevelBase
  LevelBase.Entities:update(dt) -- this executes the update function for each individual Entity

  LevelBase.positionCamera(self, player, camera)
end

function gameLevel1:draw()
  love.graphics.printf('Choose one!',3584,736,2, 'center', 0, 2, 2)
  -- Attach the camera before drawing the entities
  camera:set()

  self.map:draw(-camera.x, -camera.y) -- Remember that we inherited map from LevelBase
  LevelBase.Entities:draw() -- this executes the draw function for each individual Entity

  camera:unset()
  -- Be sure to detach after running to avoid weirdness
end

-- All levels will have a pause menu
function gameLevel1:keypressed(key)
  LevelBase:keypressed(key)
end

return gameLevel1
