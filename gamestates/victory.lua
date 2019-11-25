--
-- Created by IntelliJ IDEA.
-- User: pinchao
-- Date: 11/25/19
-- Time: 2:56 上午
-- To change this template use File | Settings | File Templates.
--

victory = Gamestate.new()

function victory:draw()
    local w, l = love.window.getMode()
    local flag = love.window.getFullscreen()
    love.graphics.setColor(1, 1, 1, 1)
    if flag then
        love.graphics.draw(winning, 0, 0)
    else
        love.graphics.draw(winning, 0, 0, 0, w / 1450, l / 990)
    end
    love.graphics.printf('Press "enter" return to mainmenu! ',w/85, l*3/4, w / 2, 'center', 0, 2, 2)
end

function victory:keypressed(key)
    if key=='return' then
        Gamestate.switch(mainMenu)
    end
end

return victory

