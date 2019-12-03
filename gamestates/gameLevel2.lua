--
-- Created by IntelliJ IDEA.
-- User: pinchao
-- Date: 11/28/19
-- Time: 11:17 上午
-- To change this template use File | Settings | File Templates.
--

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
local Swing1 = require 'entities.swing1'
local Bonus = require 'entities.gem'
local Portal = require 'entities.transition'
local camera = require 'libs.camera'
local fake=require 'entities.fakegem'
local hint=require 'entities.hint1'
local pick=love.graphics.newImage("assets/hint1.png")
OwO=require'entities.owo'

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

end

function gameLevel2:enter()
    stagelable=2
    LevelBase.init(self, 'assets/levels/level_2.lua')
    player = Player(self.world,  32, 32)
    LevelBase.Entities:add(player)
    enemy4 = Enemy(self.world,  1920, 1504)
    LevelBase.Entities:add(enemy4)
    enemy5 = Enemy(self.world,  2560, 1504)
    LevelBase.Entities:add(enemy5)
    enemy6 = Enemy(self.world,  4384, 384)
    LevelBase.Entities:add(enemy6)
    portal8 =Portal(self.world,  2208, 50)
    LevelBase.Entities:add(portal8)
    portal9 =Portal(self.world,  1184, 608)
    LevelBase.Entities:add(portal9)
    portal10 =Portal(self.world,  3712, 928)
    LevelBase.Entities:add(portal10)

    portal11 =Portal(self.world,  2432, 608)
    LevelBase.Entities:add(portal11)
    portal12 =Portal(self.world,  2848, 608)
    LevelBase.Entities:add(portal12)
    portal13 =Portal(self.world,  2976, 608)
    LevelBase.Entities:add(portal13)
    portal14 =Portal(self.world,  3328, 608)
    LevelBase.Entities:add(portal14)

    portal15 = Portal(self.world,  2432, 896)
    LevelBase.Entities:add(portal15)
    portal16 = Portal(self.world,  2848, 896)
    LevelBase.Entities:add(portal16)
    portal17 = Portal(self.world,  2976, 896)
    LevelBase.Entities:add(portal17)
    portal18 = Portal(self.world,  3328, 896)
    LevelBase.Entities:add(portal18)

    portal19 = Portal(self.world,  3040, 1216)
    LevelBase.Entities:add(portal19)
    portal20 = Portal(self.world,  3328, 1216)
    LevelBase.Entities:add(portal20)
    portal21 = Portal(self.world,  3456, 1216)
    LevelBase.Entities:add(portal21)
    portal22 = Portal(self.world,  3712, 1216)
    LevelBase.Entities:add(portal22)

    portal23 = Portal(self.world,  3040, 1472)
    LevelBase.Entities:add(portal23)
    portal24 = Portal(self.world,  3328, 1472)
    LevelBase.Entities:add(portal24)
    portal25 = Portal(self.world,  3456, 1472)
    LevelBase.Entities:add(portal25)
    portal26 = Portal(self.world,  3712, 1472)
    LevelBase.Entities:add(portal26)

    portal28 = Portal(self.world,  3840, 384)
    LevelBase.Entities:add(portal28)
    portal29 = Portal(self.world,  4160, 384)
    LevelBase.Entities:add(portal29)
    portal30 = Portal(self.world,  4288, 384)
    LevelBase.Entities:add(portal30)
    portal31 = Portal(self.world,  4704, 384)
    LevelBase.Entities:add(portal31)

    portal32 = Portal(self.world,  3840, 640)
    LevelBase.Entities:add(portal32)
    portal33 = Portal(self.world,  4160, 640)
    LevelBase.Entities:add(portal33)
    portal34 = Portal(self.world,  4288, 640)
    LevelBase.Entities:add(portal34)
    portal35 = Portal(self.world,  4704, 640)
    LevelBase.Entities:add(portal35)

    portal36 = Portal(self.world,  3840, 896)
    LevelBase.Entities:add(portal36)
    portal37 = Portal(self.world,  4160, 896)
    LevelBase.Entities:add(portal37)
    portal38 = Portal(self.world,  4288, 896)
    LevelBase.Entities:add(portal38)
    portal39 = Portal(self.world,  4704, 896)
    LevelBase.Entities:add(portal39)

    portal40 = Portal(self.world,  3840, 1152)
    LevelBase.Entities:add(portal40)
    portal41 = Portal(self.world,  4160, 1152)
    LevelBase.Entities:add(portal41)
    portal42 = Portal(self.world,  4288, 1152)
    LevelBase.Entities:add(portal42)
    portal43 = Portal(self.world,  4704, 1152)
    LevelBase.Entities:add(portal43)

    portal44 = Portal(self.world,  3840, 1472)
    LevelBase.Entities:add(portal44)
    portal45 = Portal(self.world,  4160, 1472)
    LevelBase.Entities:add(portal45)
    portal46 = Portal(self.world,  4288, 1472)
    LevelBase.Entities:add(portal46)


    bonus2 = Bonus(self.world,  3200, 1184)
    LevelBase.Entities:add(bonus2)
    bonus2 = Bonus(self.world,  4000, 608)
    LevelBase.Entities:add(bonus2)
    bonus2 = Bonus(self.world,  4608, 1088)
    LevelBase.Entities:add(bonus2)
    bonus2 = Bonus(self.world,  4000, 352)
    LevelBase.Entities:add(bonus2)
    bonus2 = Bonus(self.world,  3616, 1440)
    LevelBase.Entities:add(bonus2)
    fakebonus=fake(self.world,  1024, 384)
    LevelBase.Entities:add(fakebonus)
    fakebonus1=fake(self.world,  960, 384)
    LevelBase.Entities:add(fakebonus1)
    fakebonus2=fake(self.world,  224, 256)
    LevelBase.Entities:add(fakebonus2)
    fakebonus3=fake(self.world,  288, 992)
    LevelBase.Entities:add(fakebonus3)
    fakebonus3=fake(self.world,  1632, 736)
    LevelBase.Entities:add(fakebonus3)
    tramp3=Tramp(self.world,  2895, 1536)
    LevelBase.Entities:add(tramp3)
    tramp3=Tramp(self.world,  2885, 1248)
    LevelBase.Entities:add(tramp3)
    tramp3=Tramp(self.world,  2016, 736)
    LevelBase.Entities:add(tramp3)
    tramp3=Tramp(self.world,  1888, 512)
    LevelBase.Entities:add(tramp3)
    tramp3=Tramp(self.world,  1696, 352)
    LevelBase.Entities:add(tramp3)
    tramp3=Tramp(self.world,  1984, 224)
    LevelBase.Entities:add(tramp3)

    swing3=Swing1(self.world,  2564, 288)
    LevelBase.Entities:add(swing3)
    swing2=Swing(self.world,  3040, 288)
    LevelBase.Entities:add(swing2)
    hint2=hint(self.world,  1504, 32)
    LevelBase.Entities:add(hint2)
    OwO1=OwO(self.world,  718, 462)
    LevelBase.Entities:add(OwO1)
    OwO1=OwO(self.world,  1298, 590)
    LevelBase.Entities:add(OwO1)
    OwO1=OwO(self.world,  1202, 356)
    LevelBase.Entities:add(OwO1)
    OwO1=OwO(self.world,  992, 480)
    LevelBase.Entities:add(OwO1)


end

function gameLevel2:update(dt)
    love.graphics.draw(pick,3040,130)
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