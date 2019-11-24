wrongAns = Gamestate.new()

function wrongAns:enter(from)
  self.from = from -- record previous state
end

function wrongAns:draw()
  local w, h = love.graphics.getWidth(), love.graphics.getHeight()
  -- draw previous screen
  self.from:draw()

  -- overlay with pause message
  	love.graphics.setColor(1, 0, 0)
  	love.graphics.rectangle('line', w / 2 - 50, h / 2 - 22, 100, 38)
  	love.graphics.setColor(0, 0, 0)
  	love.graphics.rectangle('fill', w / 2 - 50, h / 2 - 22, 100, 38)
  	love.graphics.setColor(1, 1, 1)
  	love.graphics.printf('WRONG', 0, h / 2 - 20, w / 2, 'center', 0, 2, 2)
end

function wrongAns:keypressed(key)
  if key == 'return' then
  	love.event.push("quit")
  end
end

return wrongAns
