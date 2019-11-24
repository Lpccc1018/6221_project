gamefinished = Gamestate.new()

function gamefinished:enter(from)
	-- record previous state
	self.from = from
	answerGrp = Menu.new()
	answerGrp:addItem{
		name = 'A. 2',
		action = function()
			Gamestate.push(rightAns)
 	end
	}
	answerGrp:addItem{
	name = 'B. 3',
	action = function()
		Gamestate.push(wrongAns)
	end
	}
	answerGrp:addItem{
	name = 'C. 10',
	action = function()
	Gamestate.push(wrongAns)
	end
	}
end

function gamefinished:update(dt)
	answerGrp:update(dt)
end

function gamefinished:draw()
	local w, h = love.graphics.getWidth(), love.graphics.getHeight()
	self.from:draw()
	love.graphics.setColor(1, 0, 0)
	love.graphics.rectangle('line', w / 2 - 150, h / 2 - 100, 300, 200)
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle('fill', w / 2 - 150, h / 2 - 100, 300, 200)
	love.graphics.setColor(1, 1, 1)
	love.graphics.printf('Revival Question', w / 2 - 150, h / 2 - 80, 300, 'center')
	love.graphics.printf('What is the answer of 1 + 1 ?', w / 2 - 140, h / 2 - 50, 280, 'center')
	answerGrp:draw(w / 2 - 75, h / 2 - 30)
end

function gamefinished:keypressed(key)
	answerGrp:keypressed(key)
end

return gamefinished
