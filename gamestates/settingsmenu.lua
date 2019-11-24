settingsMenu = Gamestate.new()

function settingsMenu:enter(from)
    -- record previous state
    self.from = from
    local masterVol = love.audio.getVolume()
	settingsGrp = Menu.new()
	settingsGrp:addItem{
		name = 'Controls',
		action = function()
			Gamestate.push(controlMenu)
		end
	}
	settingsGrp:addItem{
		name = 'Sound',
		action = function(self)
			vol = self.btPos / 10
			love.audio.setVolume(vol)
			settings[2] = vol
		end,
		btSlot = 11,
		btPos = masterVol * 10
	}
	settingsGrp:addItem{
		name = 'Music',
		action = function(self)
			if self.btPos == 0 then
				love.audio.stop()
				settings[3] = 0
			else
				love.audio.play(music)
				settings[3] = 1
			end
		end,
		btSlot = 2,
		btPos = settings[3]
	}
	settingsGrp:addItem{
		name = 'Back',
		action = function()
			return Gamestate.pop()
		end
	}
end

function settingsMenu:update(dt)
	settingsGrp:update(dt)
end

function settingsMenu:draw()
	local w, l = love.window.getMode()
	local flag = love.window.getFullscreen()
	love.graphics.setColor(1, 1, 1, 1)
	if flag then
		love.graphics.draw(background, 0, 0)
	else
		love.graphics.draw(background, 0, 0, 0, w / 1450, l / 990)
	end
	settingsGrp:draw(w / 2 - 75, l / 2 - 20)
end

function settingsMenu:keypressed(key)
	settingsGrp:keypressed(key)
end

return settingsMenu
