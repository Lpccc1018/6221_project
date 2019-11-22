--
-- Created by IntelliJ IDEA.
-- User: pinchao
-- Date: 11/17/19
-- Time: 4:46 下午
-- To change this template use File | Settings | File Templates.
--

ad=Gamestate.new()
local ad={}

function ad.load()
    video=love.graphics.newVideo("/assets/adv.ogv")
    video:play()
end

function ad.draw()
    love.graphics.draw(video,0,0)
end

return ad
