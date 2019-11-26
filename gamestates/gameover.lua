gamefinished = Gamestate.new()
local rightAnsFlag =false
local wrongAnsFlag=false
local questionChoose = 0
function gamefinished:enter(from)
	questionChoose = questionChoose + 1
	if questionChoose > 3 then
		questionChoose = 1
	end
	-- record previous state
	self.from = from
	answerGrp = Menu.new()
	if questionChoose == 1 then
		answerGrp:addItem{
			name = "A. 1993",
			action = function()
				gamefinished:right()
			end
		}
		answerGrp:addItem{
			name = "B. 1994",
			action = function()
				gamefinished:wrong()
			end
		}
		answerGrp:addItem{
			name = "C. 1995",
			action = function()
				gamefinished:wrong()
			end
		}
	elseif questionChoose == 2 then
		answerGrp:addItem{
			name = "A. function",
			action = function()
				gamefinished:wrong()
			end
		}
		answerGrp:addItem{
			name = "B. switch",
			action = function()
				gamefinished:right()
			end
		}
		answerGrp:addItem{
			name = "C. nil",
			action = function()
				gamefinished:wrong()
			end
		}
	else
		answerGrp:addItem{
			name = "A. Sun",
			action = function()
				gamefinished:wrong()
			end
		}
		answerGrp:addItem{
			name = "B. Star",
			action = function()
				gamefinished:wrong()
			end
		}
		answerGrp:addItem{
			name = "C. Moon",
			action = function()
				gamefinished:right()
			end
		}
	end
end

function gamefinished:right()
	if rightAnsFlag then
		rightAnsFlag = false
		Player:reset()
		Gamestate.pop()
	else
		rightAnsFlag=true
	end
end

function gamefinished:wrong()
	if wrongAnsFlag then
		wrongAnsFlag = false
		Player:reset()
		Gamestate.push(AD)
	else
		wrongAnsFlag=true
	end
end

function gamefinished:resume()
	Gamestate.pop()
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
	if questionChoose == 1 then
		love.graphics.printf('Lua first appeared in which year ?', w / 2 - 140, h / 2 - 50, 280, 'center')
	elseif questionChoose == 2 then
		love.graphics.printf("Which is not Lua's keyword?", w / 2 - 140, h / 2 - 50, 280, 'center')
	else
		love.graphics.printf('What does the name Lua mean ?', w / 2 - 140, h / 2 - 50, 280, 'center')
	end
	answerGrp:draw(w / 2 - 75, h / 2 - 30)

	if rightAnsFlag then
		love.graphics.setColor(1, 0, 0)
		love.graphics.rectangle('line', w / 2 - 50, h / 2 - 22, 100, 38)
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle('fill', w / 2 - 50, h / 2 - 22, 100, 38)
		love.graphics.setColor(1, 1, 1)
		love.graphics.printf('RIGHT', 0, h / 2 - 20, w / 2, 'center', 0, 2, 2)
	end

	if wrongAnsFlag then
		love.graphics.setColor(1, 0, 0)
		love.graphics.rectangle('line', w / 2 - 80, h / 2 - 22, 160, 38)
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle('fill', w / 2 - 80, h / 2 - 22, 160, 38)
		love.graphics.setColor(1, 1, 1)
		love.graphics.printf('GAME OVER', 0, h / 2 - 20, w / 2, 'center', 0, 2, 2)
	end
end

function gamefinished:keypressed(key)
	answerGrp:keypressed(key)
end

return gamefinished
