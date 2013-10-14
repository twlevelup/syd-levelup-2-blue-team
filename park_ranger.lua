require 'entity'

ParkRanger = {}
ParkRanger.__index = ParkRanger
setmetatable(ParkRanger, {__index = Entity})

function ParkRanger:new(game)

    local newParkRanger = Entity:new(game)

    newParkRanger.graphics = {
        source = "assets/images/park_ranger.png"
    }
    newParkRanger.size = {
        x = 80,
        y = 114
    }
    newParkRanger.x = 0
    newParkRanger.parent_type = "Foreground"
    newParkRanger.type = "park_ranger"

    newParkRanger.y = ScreenHeight - newParkRanger.size.y -- - GroundYOffset


    if game.graphics ~= nil and game.animation ~= nil then
        newParkRanger.graphics.sprites = game.graphics.newImage(newParkRanger.graphics.source)
        newParkRanger.graphics.grid = game.animation.newGrid(
            newParkRanger.size.x, newParkRanger.size.y,
            newParkRanger.graphics.sprites:getWidth(),
            newParkRanger.graphics.sprites:getHeight()
        )
        newParkRanger.graphics.animation = game.animation.newAnimation(
            newParkRanger.graphics.grid("1-2", 1),
            0.1
        )
    end

    return setmetatable(newParkRanger, self)
end

function ParkRanger:update(dt)

    -- self.x = self.x - CameraXSpeed

    if self.graphics.animation ~= nil then
        self.graphics.animation:update(dt)
    end

end
