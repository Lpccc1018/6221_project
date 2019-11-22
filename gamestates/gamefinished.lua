gamefinished = Gamestate.new()

function gamefinished:enter(from)
  self.from = from -- record previous state
end

function gamefinished:draw()
  local w, h = love.graphics.getWidth(), love.graphics.getHeight()
  -- draw previous screen
  self.from:draw()

  -- overlay with gamefinished message
  love.graphics.setColor(0,0,0, 100)
  love.graphics.rectangle('fill', 0,0, w, h)
  love.graphics.setColor(255,255,255)
  love.graphics.printf('gamefinished', 0, h/2, w, 'center')
end

function gamefinished:keypressed(key)
  if key == 'escape' then
    love.event.push("quit")
  end
end

return gamefinished
