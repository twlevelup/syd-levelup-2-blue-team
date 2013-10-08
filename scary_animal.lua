require 'entity'
require 'conf'

ScaryAnimal = {}
ScaryAnimal.__index = ScaryAnimal
setmetatable(ScaryAnimal, {__index = Entity})

function ScaryAnimal:new(game)

    local newScaryAnimal = Entity:new(game)
    newScaryAnimal.type = "scary_animal"
    newScaryAnimal.size = {
        x = 64,
        y = 60
    }
    newScaryAnimal.x = ScreenWidth
    newScaryAnimal.y = ScreenHeight - newScaryAnimal.size.y

    newScaryAnimal.speed = 9

    newScaryAnimal.graphics = {
        source = "assets/images/scary-animal-sprites-wolf.png"
    }

    if game.graphics ~= nil and game.animation ~= nil then
        newScaryAnimal.graphics.sprites = game.graphics.newImage(newScaryAnimal.graphics.source)
        newScaryAnimal.graphics.grid = game.animation.newGrid(
            newScaryAnimal.size.x, newScaryAnimal.size.y,
            newScaryAnimal.graphics.sprites:getWidth(),
            newScaryAnimal.graphics.sprites:getHeight()
        )
        newScaryAnimal.graphics.animation = game.animation.newAnimation(
            newScaryAnimal.graphics.grid("1-3", 1),
            0.05
        )
    end

    return setmetatable(newScaryAnimal, self)
end

function ScaryAnimal:update(dt)

    self.x = self.x - self.speed

    if self.graphics.animation ~= nil then
        self.graphics.animation:update(dt)
    end

end
