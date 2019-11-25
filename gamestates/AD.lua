--
-- Created by IntelliJ IDEA.
-- User: pinchao
-- Date: 11/17/19
-- Time: 4:46 下午
-- To change this template use File | Settings | File Templates.
--

ad=Gamestate.new()
local ad={}

function ad:enter()
	music:stop()
    video:play()
end

function ad:draw()
    love.graphics.draw(video,love.graphics.getWidth()/2-video:getWidth()/2 ,love.graphics.getHeight()/2-video:getHeight()/2)
    if not video:isPlaying() then
        love.graphics.clear()
        love.graphics.printf('Press "enter" return to mainmenu! ',love.graphics.getWidth()/4, love.graphics.getHeight()/2, love.graphics.getWidth()/2 / 2, 'center', 0, 2, 2)
    end
end

function ad:keypressed(key)
    if key=='return' and not video:isPlaying() then
        Gamestate.switch(mainMenu)
    end
end

return ad
