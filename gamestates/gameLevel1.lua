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
local hint=require 'entities.hint'


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
  stagelable=1
  LevelBase.init(self, 'assets/levels/level_1.lua')
  player = Player(self.world,  32, 32)
  LevelBase.Entities:add(player)
  enemy = Enemy(self.world,  50, 580)
  LevelBase.Entities:add(enemy)
  enemy2 = Enemy(self.world,  1408, 480)
  LevelBase.Entities:add(enemy2)
  enemy3 = Enemy(self.world,  4704, 1248)
  LevelBase.Entities:add(enemy3)
  swing = Swing(self.world,  832, 1408)
  LevelBase.Entities:add(swing)
  portal5 =Portal(self.world,  320, 1472)
  LevelBase.Entities:add(portal5)
  portal2 =Portal(self.world,  2304, 544)
  LevelBase.Entities:add(portal2)
  portal3 =Portal(self.world,  3232, 1472)
  LevelBase.Entities:add(portal3)
  portal4 =Portal(self.world,  4512, 768)
  LevelBase.Entities:add(portal4)
  portal1 =Portal(self.world,  64, 1344)
  LevelBase.Entities:add(portal1)
  portal6 =Portal(self.world,  4736, 1472)
  LevelBase.Entities:add(portal6)
  portal7 =Portal(self.world,  2640, 1472)
  LevelBase.Entities:add(portal7)
  bonus = Bonus(self.world,  1600, 800)
  LevelBase.Entities:add(bonus)
  bonus1 = Bonus(self.world,  1600, 1248)
  LevelBase.Entities:add(bonus1)
  bonus1 = Bonus(self.world,  3136, 1536)
  LevelBase.Entities:add(bonus1)
  bonus1 = Bonus(self.world,  4448, 864)
  LevelBase.Entities:add(bonus1)
  bonus1 = Bonus(self.world,  3552, 608)
  LevelBase.Entities:add(bonus1)
  fakebonus=fake(self.world,  1696, 1536)
  LevelBase.Entities:add(fakebonus)
  fakebonus1=fake(self.world,  1696, 1024)
  LevelBase.Entities:add(fakebonus1)
  fakebonus2=fake(self.world,  2816, 1536)
  LevelBase.Entities:add(fakebonus2)
  fakebonus3=fake(self.world,  2080, 256)
  LevelBase.Entities:add(fakebonus3)
  tramp1=Tramp(self.world,  3750, 1344)
  LevelBase.Entities:add(tramp1)
  tramp2=Tramp(self.world,  3840, 1056)
  LevelBase.Entities:add(tramp2)
  hint1=hint(self.world,  2848, 1088)
  LevelBase.Entities:add(hint1)
end

function gameLevel1:update(dt)
  self.map:update(dt) -- remember, we inherited map from LevelBase
  LevelBase.Entities:update(dt) -- this executes the update function for each individual Entity

  LevelBase.positionCamera(self, player, camera)
end

function gameLevel1:draw()
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
