pause = Gamestate.new()
local count = 0

function pause:enter(from)
	-- record previous state
	self.from = from
end

function pause:draw()
	local w, h = love.graphics.getWidth(), love.graphics.getHeight()
	self.from:draw()
	local flag = false
	if count < 30 then
		flag = false
	else
		flag = true
	end
	if flag then
		love.graphics.setColor(1, 0, 0)
		love.graphics.rectangle('line', w / 2 - 50, h / 2 - 22, 100, 38)
		love.graphics.setColor(1, 1, 1)
		love.graphics.printf('PAUSE', 0, h / 2 - 20, w / 2, 'center', 0, 2, 2)
	end
	count = count + 1
	if count == 61 then
		count = 0
	end
end

function pause:keypressed(key)
  if key == 'p' then
    return Gamestate.pop() -- return to previous state
  end
end

return pause
