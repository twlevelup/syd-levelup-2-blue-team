--require 'input'
require 'entity'
require 'conf'

World = {}
World.__index = World
setmetatable(World, {__index = Entity})

function  World:new(game)
	local newWorld = Entity:new(game)

    newWorld.type = "world"
    newWorld.view_width = 0
    newWorld.view_height = 0

    newWorld.size = {
        x = ScreenWidth,
        y = ScreenHeight
    }

    newWorld.graphics =  {
         source = "assets/images/background.png",
    }
    newWorld.graphics.image = game.graphics.newImage(newWorld.graphics.source)
    newWorld.graphics.quad = game.graphics.newQuad(0,0, newWorld.graphics.image:getWidth(), ScreenHeight, newWorld.graphics.image:getWidth(), newWorld.graphics.image:getHeight())

    return setmetatable(newWorld, self)
end

function World:update(dt)
    if self.view_width > -ScreenWidth then            
        self.view_width = self.view_width - 2
        if self.view_width <= -ScreenWidth then
            self.view_width = 0
        end
    end
end

function World:draw()
    love.graphics.drawq(self.graphics.image, self.graphics.quad, self.view_width, self.view_height)
    love.graphics.drawq(self.graphics.image, self.graphics.quad, ScreenWidth + self.view_width, self.view_height)
end

function World:onScreen(entity)
    return World:rightOfLeftBorder(entity) and World:leftOfRightBorder(entity)
end

function World:rightOfLeftBorder(entity)
    local onScreen = true
    if entity.x + entity.size.x < 0 then
        onScreen = false
    end
    return onScreen
end

function World:leftOfRightBorder(entity)
    local onScreen = true
    if entity.x + entity.size.x < 0 then
        onScreen = false
    end
    return onScreen
end

