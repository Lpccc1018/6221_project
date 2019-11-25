--
-- Created by IntelliJ IDEA.
-- User: pinchao
-- Date: 11/24/19
-- Time: 4:51 下午
-- To change this template use File | Settings | File Templates.
--

reminder = Gamestate.new()
local count = 0

function reminder:enter(from)
    -- record previous state
    self.from = from
end

function reminder:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    self.from:draw()
    local flag = false
    if count < 30 then
        flag = true
    elseif count < 60 then
        flag = false
    elseif count < 90 then
    	flag = true
  	elseif count < 120 then 
  		flag = false
  	else
  		flag = true
    end
    if flag then
    	love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle('fill', w / 2 - 250, h / 2 - 22, 500, 38)
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle('line', w / 2 - 250, h / 2 - 22, 500, 38)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf('Collect all coins to the next stage!', 0, h / 2 - 20, w / 2, 'center', 0, 2, 2)
    end
    count = count + 1
    if count == 151 then
        return Gamestate.pop()
    end
end

return reminder