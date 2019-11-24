controlMenu = Gamestate.new()

local entering = false
function controlMenu:enter(from)
	-- record previous state
    self.from = from
    love.keyboard.setTextInput(false)
	controlGrp = Menu.new()
	controlGrp:addItem{
		name = 'Move Left',
		action = function(self)
			if love.keyboard.hasTextInput() then
				love.keyboard.setTextInput(false)
			else
				love.keyboard.setTextInput(true)
				function love.textinput(t)
					self.btKey = t
					settings[4] = t
            	end
          end
		end,
		btKey = settings[4]
	}
	controlGrp:addItem{
		name = 'Move Right',
		action = function(self)
			if love.keyboard.hasTextInput() then
				love.keyboard.setTextInput(false)
			else
				love.keyboard.setTextInput(true)
				function love.textinput(t)
					self.btKey = t
					settings[5] = t
				end
			end
		end,
		btKey = settings[5]
	}
	controlGrp:addItem{
		name = 'Jump',
		action = function(self)
			if love.keyboard.hasTextInput() then
				love.keyboard.setTextInput(false)
			else
				love.keyboard.setTextInput(true)
				function love.textinput(t)
					self.btKey = t
					if self.btKey == ' ' then
						self.btKey = 'space'
						settings[6] = 'space'
					else
						settings[6] = t
					end
				end
			end
		end,
		btKey = settings[6]
	}
	controlGrp:addItem{
		name = 'Back',
		action = function()
			return Gamestate.pop()
		end
	}
end

function controlMenu:update(dt)
	controlGrp:update(dt)
end

function controlMenu:draw()
  	local w, l = love.window.getMode()
	local flag = love.window.getFullscreen()
	love.graphics.setColor(1, 1, 1, 1)
	if flag then
		love.graphics.draw(background, 0, 0)
	else
		love.graphics.draw(background, 0, 0, 0, w / 1450, l / 990)
	end
	controlGrp:draw(w / 2 - 75, l / 2 - 20)
end

function controlMenu:keypressed(key)
	controlGrp:keypressed(key)
end

return controlMenu
