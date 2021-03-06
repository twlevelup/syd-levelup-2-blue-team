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
    newWorld.parent_type = "Background"

    newWorld.size = {
        x = ScreenWidth,
        y = ScreenHeight
    }

    newWorld.graphics =  {
         source = "assets/images/background.png",
    }

    newWorld.sound = {
        play_music = {
            source = "assets/sounds/play_music.mp3"
        }     
    }
    
    newWorld.graphics.image = game.graphics.newImage(newWorld.graphics.source)
    newWorld.graphics.quad = game.graphics.newQuad(0,0, newWorld.graphics.image:getWidth(), ScreenHeight, newWorld.graphics.image:getWidth(), newWorld.graphics.image:getHeight())

    if game.audio ~= nil then
        newWorld.sound.play_music.sample = game.audio.newSource(newWorld.sound.play_music.source, "static")
        newWorld.sound.play_music.sample:setLooping(true)
    end

    return setmetatable(newWorld, self)
end


function World:update(dt)
    self:playGameMusic()
    if self.view_width > -ScreenWidth then            
        self.view_width = self.view_width - 4
        if self.view_width <= -ScreenWidth then
            self.view_width = 0
        end
    end
end

function World:playGameMusic()
    if self.sound.play_music.sample ~= nil and self.sound.play_music.sample:isStopped() then
        self.sound.play_music.sample:play()
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

function World:dispose()
    self.sound.play_music.sample:stop() --else it will crash sooner or later
end