require 'distance'

describe("Distance", function()
	mock_graphics = function()
        local graphics_spy = {
            print = spy.new(function() end),
            newFont = spy.new(function() end),
            setFont = spy.new(function() end)
        }

        return graphics_spy
    end

	describe("#update", function()
		describe("every tick the timer should increment", function()
      local game = {
        graphics = mock_graphics()
      }
			local distance = Distance:new(game)
			distance:update(0.5)
			assert.is.equal(0.5, distance.counter)
		end)
	end)

	describe("#draw", function()
		describe("fractional distance should print nearest second", function()
			local game = {
				graphics = mock_graphics()
			}
			local distance = Distance:new(game)
			distance:update(1.65)
			distance:draw()

			assert.spy(game.graphics.print).was.called()
		end)
	end)
end)