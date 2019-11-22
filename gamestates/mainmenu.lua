local Menu = require 'gamestates.menuSwitch'
--Menu = require 'gamestates.menuScroll'
local debug = ""
local bg=love.graphics.newImage("assets/background.png")


fullscreen, fstype = love.window.getFullscreen( )

mainMenu = Gamestate.new()

function mainMenu:enter()
	mmenuGrp = Menu.new()
	mmenuGrp:addItem{
		name = 'Start Game',
		action = function()
			Gamestate.switch(gameLevel1)
		end
	}

	mmenuGrp:addItem{
		name = 'Fullscreen',
		action = function(self)
			if not fullscreen then
				fullscreen = true
				self.name = 'Disable fullscreen'
                love.window.setFullscreen( fullscreen, "desktop" )
                settings[1] = fullscreen
			else
				fullscreen = false
				self.name = 'Enable fullscreen'
                love.window.setFullscreen( fullscreen, fstype )
                settings[1] = fullscreen
			end
		end
	}
	if fullscreen then
		mmenuGrp.items[#mmenuGrp.items].name = 'Disable fullscreen'
	else
		mmenuGrp.items[#mmenuGrp.items].name = 'Enable fullscreen'
	end

	mmenuGrp:addItem{
		name = 'Settings',
		action = function()
            if Gamestate.current() ~= settingsMenu then
			    Gamestate.push(settingsMenu)
            end
		end
	}

	mmenuGrp:addItem{
		name = 'Quit',
		action = function()
			love.event.push('quit')
		end
	}
end

function mainMenu:update(dt)
	mmenuGrp:update(dt)
end

function mainMenu:draw()
	love.graphics.draw(bg,0,0)
	mmenuGrp:draw(10, 10)
    --love.graphics.print(string.format("%s "..fstype, fullscreen), 500, 20)
end

function mainMenu:keypressed(key)
	mmenuGrp:keypressed(key)
end

return mainMenu
