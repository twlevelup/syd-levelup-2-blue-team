require 'input'
require 'player'
require 'world'
require 'distance'
require 'leaderboard'
require 'panicmeter'
require 'conf'
require 'entitymanager'

love.animation = require 'vendor/anim8'

love.filesystem.setIdentity(identityDirName)


local entities = {}
local world = World:new(love)

local player = Player:new(love, world)
local distance = Distance:new(love)
local leaderboard = LeaderBoard:new(love)
local panicmeter = Panicmeter:new(love)

local entity_manager = EntityManager:new(love)

-- more info on cron here http://tannerrogalsky.com/blog/2012/09/19/favourite-lua-libraries/
local cron = require 'cron'

function love.load()
    -- leaderboard:readScores(distance)
    -- leaderboard:writeScores()

    table.insert(entities, world)
    table.insert(entities, player)
    table.insert(entities, distance)
    table.insert(entities, panicmeter)
    -- table.insert(entities, leaderboard)

    love.input.bind('up', 'up')
    love.input.bind('left', 'left')
    love.input.bind('right', 'right')
    love.input.bind('down', 'down')

    math.randomseed(os.time())

end

function love.update(dt)

    cron.update(dt)
    entity_manager:update(dt, entities, world, cron)

    for _, entity in pairs(entities) do
        entity:update(dt)
        for _, other in pairs(entities) do
            if other ~= entity then
                if entity:collidingWith(other) then
                    entity:collide(other)
                end
            end
        end
    end

    -- Need to check for the loose condition if not already.
        -- if 'game over' then 
            -- Load and display the leaderboard using...
            -- leaderboard:readScores(distance)
            -- table.insert(entities, leaderboard)
            -- leaderboard:writeScores()

    panicmeter:setPanic(player)
end

function isGameOver()
    return player:isCaught() == true or player:isOutOfBounds()
end


function love.draw()
    if isGameOver() == true then
        if distance.final_distance == nil then
            distance.final_distance = distance:getDistance()
        end
        world:drawGameOver(distance.final_distance)
    else
        for _, e in pairs(entities) do
            e:draw()
        end
    end
end
