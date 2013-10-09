require 'entity'
require 'conf'

ScaryAnimal = {}
ScaryAnimal.__index = ScaryAnimal
setmetatable(ScaryAnimal, {__index = Entity})

function ScaryAnimal:new(game, graphic_spec, movement_strategy)

    local newScaryAnimal = Entity:new(game)
    newScaryAnimal.type = "scary_animal"
    if graphic_spec == nil then
        newScaryAnimal.size = {
            x = 64,
            y = 60
        }
        newScaryAnimal.graphics = {
            source = "assets/images/scary-animal-sprites-wolf.png"
        }
    else        
        newScaryAnimal.size = graphic_spec.size
        newScaryAnimal.graphics = {
            source = graphic_spec.image
        }
    end

    newScaryAnimal.movement_strategy = movement_strategy --may be nill
    newScaryAnimal.x = ScreenWidth
    newScaryAnimal.y = ScreenHeight - newScaryAnimal.size.y

    newScaryAnimal.speed = 5

    if game.graphics ~= nil and game.animation ~= nil then
        newScaryAnimal.graphics.sprites = game.graphics.newImage(newScaryAnimal.graphics.source)
        newScaryAnimal.graphics.grid = game.animation.newGrid(
            newScaryAnimal.size.x, newScaryAnimal.size.y,
            newScaryAnimal.graphics.sprites:getWidth(),
            newScaryAnimal.graphics.sprites:getHeight()
        )
        local frameNr = nil
        if graphic_spec == nil then
            frameNr = 3
        else
            frameNr = graphic_spec.frames
        end
        newScaryAnimal.graphics.animation = game.animation.newAnimation(
            newScaryAnimal.graphics.grid("1-" .. frameNr, 1),
            0.05
        )

    end

    return setmetatable(newScaryAnimal, self)
end

function ScaryAnimal:update(dt)

    if self.movement_strategy == nil then
        self.x = self.x - self.speed - CameraXSpeed
    else
        self.movement_strategy(self, dt)
    end
    if self.graphics.animation ~= nil then
        self.graphics.animation:update(dt)
    end

end
