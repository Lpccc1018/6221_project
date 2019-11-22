Menu = require 'gamestates.menuSwitch'
--Menu = require 'gamestates.menuScroll'
--text = "waiting"

controlMenu = Gamestate.new()

function controlMenu:enter(from)
    self.from = from -- record previous state

    love.keyboard.setTextInput(false)

	controlGrp = Menu.new()

	controlGrp:addItem{
		name = 'Move Left',
		action = function(self)
          if love.keyboard.hasTextInput() then
            love.keyboard.setTextInput(false)
          else
            love.keyboard.setTextInput( true )
			function love.textinput(t)
                --text = t
                --e, a, b, c, d = love.event.wait( )
                --print(e.." "..a)
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
            love.keyboard.setTextInput( true )
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
            love.keyboard.setTextInput( true )
			function love.textinput(t)
                self.btKey = t
                settings[6] = t
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
  -- draw previous screen
	controlGrp:draw(10, 10)
end

function controlMenu:keypressed(key)
	controlGrp:keypressed(key)
end

return controlMenu
