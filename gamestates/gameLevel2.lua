-- Import our libraries.
local Gamestate = require 'libs.hump.gamestate'
local Class = require 'libs.hump.class'

-- Grab our base class
local LevelBase = require 'gamestates.LevelBase'

-- Import the Entities we will build.
local Player = require 'entities.player'
local Enemy = require 'entities.enemy'
local Box = require 'entities.box'
local Tramp = require 'entities.tramp'
local Swing = require 'entities.swing'
local Bonus = require 'entities.gem'
local camera = require 'libs.camera'

-- Declare a couple immportant variables
player = nil
enemy = nil
box = nil
tramp = nil
swing = nil
bonus = nil

gameLevel2 = Class{
  __includes = LevelBase
}

function gameLevel2:init()
  LevelBase.init(self, 'assets/levels/level_2.lua')
end

function gameLevel2:enter()
  player = Player(self.world,  32, 64)
  LevelBase.Entities:add(player)
  enemy = Enemy(self.world,  32, 64)
  LevelBase.Entities:add(enemy)
  box = Box(self.world,  32, 32)
  LevelBase.Entities:add(box)
  tramp = Tramp(self.world,  32, 32)
  LevelBase.Entities:add(tramp)
  swing = Swing(self.world,  32, 32)
  LevelBase.Entities:add(swing)
  bonus4 = Bonus(self.world,  32, 32)
  LevelBase.Entities:add(bonus4)
  bonus5 = Bonus(self.world,  32, 100)
  LevelBase.Entities:add(bonus5)
  bonus6 = Bonus(self.world,  50, 100)
  LevelBase.Entities:add(bonus6)
  bonus7 = Bonus(self.world,  80, 100)
  LevelBase.Entities:add(bonus7)
  bonus8 = Bonus(self.world,  100, 100)
  LevelBase.Entities:add(bonus8)
end

function gameLevel2:update(dt)
  self.map:update(dt) -- remember, we inherited map from LevelBase
  LevelBase.Entities:update(dt) -- this executes the update function for each individual Entity

  LevelBase.positionCamera(self, player, camera)
end

function gameLevel2:draw()
  -- Attach the camera before drawing the entities
  camera:set()

  self.map:draw(-camera.x, -camera.y) -- Remember that we inherited map from LevelBase
  LevelBase.Entities:draw() -- this executes the draw function for each individual Entity

  camera:unset()
  -- Be sure to detach after running to avoid weirdness
end

-- All levels will have a pause menu
function gameLevel2:keypressed(key)
  LevelBase:keypressed(key)
end

return gameLevel2
