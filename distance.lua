require 'input'
require 'player'
require 'obstacle'
require 'world'
require 'conf'

Distance = {}
Distance.__index = Distance
setmetatable(Distance, {__index = Entity})

function Distance:new(game)	
	local newDistance = Entity:new(game)
	newDistance.type = "Distance"
	newDistance.counter = 0
  game.graphics.setFont(game.graphics.newFont('assets/fonts/LilyScriptOne-Regular.ttf', DistanceFontSize))
	newDistance.size = {
        x = 0,
        y = 0
    }

	return setmetatable(newDistance, self)
end

function Distance:update(dt)
	self.counter = self.counter + dt
end

function Distance:draw()
  distance = self.type .. " travelled: " .. tostring(math.floor(self.counter * 30).."m")
	self.game.graphics.print(distance, DistanceMeterXOffset, DistanceMeterYOffset)
end