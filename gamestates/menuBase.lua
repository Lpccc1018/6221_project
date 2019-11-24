return {
	new = function()
		return {
			items = {},
			selected = 1,
            btSelected = false,
			animOffset = 0,
			addItem = function(self, item)
				table.insert(self.items, item)
			end,
			update = function(self, dt)
				self.animOffset = self.animOffset / (1 + dt*10)
			end,
			draw = function(self, x, y)
				local height = 20
				local width = 150
				
				love.graphics.setColor(1, 1, 1, 0.5)
				love.graphics.rectangle('fill', x, y + height*(self.selected-1) + (self.animOffset * height), width, height)
                --if text ~= nil then love.graphics.print(text, 500, 40) end
				
				for i, item in ipairs(self.items) do
					if self.selected == i then
						love.graphics.setColor(1, 1, 1, 1)
					else
						love.graphics.setColor(1, 1, 1, 0.5)
					end
					love.graphics.print(item.name, x + 5, y + height*(i-1) + 5)
                    if item.btSlot then
                        if item.btPos == 0 then
                            love.graphics.setColor(1, 1, 1, 0.5)
                        else
                            love.graphics.setColor(0, 1, 1, 1)
                        end
                        love.graphics.rectangle('line', x + width + 4, y + height*(i-1) + 3, 25*item.btSlot, height - 6)
                        love.graphics.rectangle('fill', x + width + 4 + (25*item.btPos), y + (height+0.5)*(i-1) + 1, 25, height - 4)
                    end
                    if item.btKey then
                        if love.keyboard.hasTextInput() and self.selected == i then
                          self.btSelected = true
                          love.graphics.setColor(0, 1, 0, 0.5)
                        elseif not love.keyboard.hasTextInput() then
                          self.btSelected = false
                        else
                          love.graphics.setColor(1, 1, 1, 0.5)
                        end
                        love.graphics.print(item.btKey, x + width + 4, y + height*(i-1) + 3)
                    end
				end
				love.graphics.setColor(1, 1, 1, 1)
			end,
			keypressed = function(self, key)
				if key == 'up' and not self.btSelected then
					if self.selected > 1 then
						self.selected = self.selected - 1
						self.animOffset = self.animOffset + 1
					else
						self.selected = #self.items
						self.animOffset = self.animOffset - (#self.items-1)
					end
				elseif key == 'down' and not self.btSelected then
					if self.selected < #self.items then
						self.selected = self.selected + 1
						self.animOffset = self.animOffset - 1
					else
						self.selected = 1
						self.animOffset = self.animOffset + (#self.items-1)
					end
				elseif key == 'right' and self.items[self.selected].btSlot then
					if self.items[self.selected].btSlot ~= self.items[self.selected].btPos + 1 then
						self.items[self.selected].btPos = self.items[self.selected].btPos + 1
						self.items[self.selected]:action()
					end
				elseif key == 'left' and self.items[self.selected].btSlot then
					if self.items[self.selected].btPos ~= 0 then
						self.items[self.selected].btPos = self.items[self.selected].btPos - 1
						self.items[self.selected]:action()
					end
				elseif key == 'return' then
					if self.items[self.selected].action then
						self.items[self.selected]:action()
					end
				end
			end
		}
	end
}