require 'entity'

Person = {}
Person.__index = Person
setmetatable(Person, {__index = Entity})

function Person:new(game, image_spec)

    local newPerson = Entity:new(game)
    
    newPerson.graphics = {
        source = image_spec.image
    }
    newPerson.size = image_spec.size

    newPerson.type = "person"
    newPerson.x = ScreenWidth
    newPerson.y = ScreenHeight - newPerson.size.y -- - GroundYOffset


    if game.graphics ~= nil and game.animation ~= nil then
        newPerson.graphics.sprites = game.graphics.newImage(newPerson.graphics.source)
        newPerson.graphics.grid = game.animation.newGrid(
            newPerson.size.x, newPerson.size.y,
            newPerson.graphics.sprites:getWidth(),
            newPerson.graphics.sprites:getHeight()
        )
        newPerson.graphics.animation = game.animation.newAnimation(
            newPerson.graphics.grid("1-1", 1),
            0.05
        )
    end

    return setmetatable(newPerson, self)
end

function Person:update(dt)

    self.x = self.x - CameraXSpeed

    if self.graphics.animation ~= nil then
        self.graphics.animation:update(dt)
    end

end
