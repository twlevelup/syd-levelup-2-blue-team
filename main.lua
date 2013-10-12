require 'input'
require 'player'
require 'world'
require 'distance'
require 'panicmeter'
require 'conf'
require 'entitymanager'
require 'gameoverscreen'

love.animation = require 'vendor/anim8'

local entity_manager = EntityManager:new(love)
local gameoverscreen = nil

function love.load()
    entity_manager.load()

    love.input.bind('up', 'up')
    love.input.bind('left', 'left')
    love.input.bind('right', 'right')
    love.input.bind('down', 'down')

    math.randomseed(os.time())
end

function love.update(dt)
    if not entity_manager:isGameOver() then    
        entity_manager:update(dt)
    end
end

function isGameOver()
    return entity_manager:isGameOver()
end

function love.draw()
    if isGameOver() == true then
        if gameoverscreen == nil then
            gameoverscreen = GameOverScreen:new(love)
            gameoverscreen:setDistance(entity_manager:getDistance())
        end
        gameoverscreen:draw()
    else
        entity_manager:draw()
    end
end
