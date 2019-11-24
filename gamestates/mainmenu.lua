mainMenu = Gamestate.new()

function mainMenu:enter()
	local fullscreen = love.window.getFullscreen( )
	mainMenuGrp = Menu.new()
	mainMenuGrp:addItem{
		name = 'Start Game',
		action = function()
			Gamestate.switch(gameLevel1)
		end
	}
	mainMenuGrp:addItem{
		name = 'Disable Fullscreen',
		action = function(self)
			if fullscreen then
				fullscreen = false
				self.name = 'Enable Fullscreen'
				love.window.setFullscreen(fullscreen)
			else
				fullscreen = true
				self.name = 'Disable Fullscreen'
				love.window.setFullscreen( fullscreen)
			end
			settings[1] = fullscreen
		end
	}
	mainMenuGrp:addItem{
		name = 'Settings',
		action = function()
			Gamestate.push(settingsMenu)
		end
	}
	mainMenuGrp:addItem{
		name = 'Quit',
		action = function()
			love.event.push('quit')
		end
	}
end

function mainMenu:update(dt)
	mainMenuGrp:update(dt)
end

function mainMenu:draw()
	local w, l = love.window.getMode()
	local flag = love.window.getFullscreen()
	love.graphics.setColor(1, 1, 1, 1)
	if flag then
		love.graphics.draw(background, 0, 0)
	else
		love.graphics.draw(background, 0, 0, 0, w / 1450, l / 990)
	end
	mainMenuGrp:draw(w / 2 - 75, l / 2 - 20)
end

function mainMenu:keypressed(key)
	mainMenuGrp:keypressed(key)
end

return mainMenu
