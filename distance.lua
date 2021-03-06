require 'input'
require 'player'
require 'world'
require 'conf'

Distance = {}
Distance.__index = Distance
setmetatable(Distance, {__index = Entity})

function Distance:new(game)
	local newDistance = Entity:new(game)
	newDistance.type = "Distance"
  newDistance.parent_type = "Background"
	newDistance.counter = 0
	game.graphics.setFont(game.graphics.newFont('assets/fonts/Ponyo.otf', DistanceFontSize))
	newDistance.size = {
        x = 0,
        y = 0
    }

	return setmetatable(newDistance, self)
end

function Distance:update(dt)
	self.counter = self.counter + dt
end

function Distance:getDistance()
  return math.floor(self.counter * 5)
end

function Distance:draw()
  distance = self.type .. " travelled: " .. tostring(self:getDistance()).."m"
  self.game.graphics.setColor(0, 0, 0, 255)

  self.game.graphics.print(distance, DistanceMeterXOffset, DistanceMeterYOffset)
  self.game.graphics.setColor(255, 255, 255, 255)
end

function Distance:getDistance()
	return 	math.floor(self.counter * 30)
end
