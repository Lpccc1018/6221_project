Menu = require 'gamestates.menuSwitch'
--Menu = require 'gamestates.menuScroll'

masterVol = love.audio.getVolume()

settingsMenu = Gamestate.new()

function settingsMenu:enter(from)
    self.from = from -- record previous state

	settingsGrp = Menu.new()

	settingsGrp:addItem{
		name = 'Controls',
		action = function()
            if Gamestate.current() ~= controlMenu then
			    Gamestate.push(controlMenu)
            end
		end
	}

	settingsGrp:addItem{
		name = 'Sound',
		action = function(self)
          vol = self.btPos/10
          love.audio.setVolume(vol)
          settings[2] = vol
		end,
        btSlot = 11,
        btPos = masterVol * 10
	}

	settingsGrp:addItem{
		name = 'Music',
		action = function(self)
          --sources = {}
          if self.btPos == 0 then
            love.audio.stop()
            settings[3] = 0
          else
            love.audio.play(music)
            settings[3] = 1
          end
          --print(sources)
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
  -- draw previous screen
	settingsGrp:draw(10, 10)
end

function settingsMenu:keypressed(key)
	settingsGrp:keypressed(key)
end

return settingsMenu
