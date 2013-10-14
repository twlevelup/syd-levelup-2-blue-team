require 'input'
require 'entity'
require 'conf'

Player = {}
Player.__index = Player
setmetatable(Player, {__index = Entity})

function Player:new(game, world, config)
    local config = config or {}

    local newPlayer = Entity:new(game)
    newPlayer.type = "player"
    newPlayer.parent_type = "Foreground"
    newPlayer.size = config.size or {
           x = 57,
           y = 59
    }
    newPlayer.world = world
    newPlayer.x = config.x or 100
    newPlayer.y = config.y or ScreenHeight - newPlayer.size.y
    newPlayer.originalX = newPlayer.x
    newPlayer.dy = config.dy or 0
    newPlayer.jump_height = config.jump_height or 1000
    newPlayer.gravity = config.gravity or 2000
    newPlayer.speed = config.speed or 5
    newPlayer.panic = config.panic or 0
    newPlayer.already_collided_with = config.already_collided_with or {}
    newPlayer.isCollidingWithPerson = false

    newPlayer.keys = config.keys or {
        up = "up"
    }

    newPlayer.graphics = config.graphics or {
        source = "assets/images/rabbit.png",
        facing = "right"
    }

    newPlayer.sound = config.sound or {
        moving = {
            source = "assets/sounds/move.wav"
        },
        jumping = {
            source = "assets/sounds/jumping.mp3"
        },
        jumping_2 = {
            source = "assets/sounds/jumping2.mp3"
        }
    }

    newPlayer.lastPosition = {
        x = nil,
        y = nil
    }

    if game.audio ~= nil then
        newPlayer.sound.moving.sample = game.audio.newSource(newPlayer.sound.moving.source)
        newPlayer.sound.moving.sample:setLooping(true)
        newPlayer.sound.jumping.sample = game.audio.newSource(newPlayer.sound.jumping.source)
    end

    if game.graphics ~= nil and game.animation ~= nil then
        newPlayer.graphics.sprites = game.graphics.newImage(newPlayer.graphics.source)
        newPlayer.graphics.grid = game.animation.newGrid(
            newPlayer.size.x, newPlayer.size.y,
            newPlayer.graphics.sprites:getWidth(),
            newPlayer.graphics.sprites:getHeight()
        )
        newPlayer.graphics.animation = game.animation.newAnimation(
            newPlayer.graphics.grid("1-1", 1),
            0.05
        )
    end

    return setmetatable(newPlayer, self)
end

function Player:collide(other)
    if other.type == "scary_animal" then
        if self:firstTimeCollision(other) then
            self:increasePanic()   
            other.already_collided = true
        end
    elseif other.type == "person" then
        self.isCollidingWithPerson = true
    end
end

function Player:firstTimeCollision(colliding_with)
    return colliding_with.already_collided == false
end

function Player:increasePanic()
    self.panic = self.panic + PanicIncrease
end

function Player:stopFallingThroughFloor()
    if self.y > ScreenHeight - self.size.y then
        self.y = ScreenHeight - self.size.y
    end
end

function Player:isOnFloor()
    return self.y == ScreenHeight - self.size.y
end

function Player:handleJump()
    self.dy = -self.jump_height
    if self.sound.jumping.sample ~= nil then
        self.sound.jumping.sample:play()
    end
end

function Player:isCaught()
    return self.panic >= 100
end

function Player:isOutOfBounds()
    return not self.world:onScreen(self)
end

function Player:update(dt)
    if self.game.input.pressed(self.keys.up) and self:isOnFloor() then
        self:handleJump();
    end

    self.lastPosition = {
        x = self.x,
        y = self.y
    }

    if self.isCollidingWithPerson == true then
        self.x = self.x - 2
        self.isCollidingWithPerson = false
    end

    self.dy = self.dy + self.gravity * dt
    self.y = self.y + self.dy * dt

    self:stopFallingThroughFloor()

    if self.graphics.animation ~= nil then
        self.graphics.animation:update(dt)
    end

    if self.sound.moving.sample ~= nil then
        if dy ~= 0 then
            self.sound.moving.sample:play()
        else
            self.sound.moving.sample:stop()
        end
    end
end

function Player:dispose()
    self.sound.moving.sample:stop() --else it will crash sooner or later
end