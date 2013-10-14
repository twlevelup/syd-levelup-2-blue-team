require 'input'
require 'player'
require 'scary_animal'
require 'obstacle'
require 'world'
require 'distance'
require 'leaderboard'
require 'conf'

love.animation = require 'vendor/anim8'

love.filesystem.setIdentity(identityDirName)


local entities = {}
local world = World:new(love)

local max_view = -450
local view_width = 0
local view_height = 0

local player = Player:new(love)
local distance = Distance:new(love)
local leaderboard = LeaderBoard:new(love)


local cron = require 'cron'


function spawnScaryAnimal()
    local scaryAnimal = ScaryAnimal:new(love)
    table.insert(entities, scaryAnimal)
end

function love.load()

    -- leaderboard:readScores(distance)
    -- leaderboard:writeScores()

    table.insert(entities, world)
    table.insert(entities, player)
    table.insert(entities, distance)
    -- table.insert(entities, leaderboard)

    love.input.bind('up', 'up')
    love.input.bind('left', 'left')
    love.input.bind('right', 'right')
    love.input.bind('down', 'down')

    -- more info on cron here http://tannerrogalsky.com/blog/2012/09/19/favourite-lua-libraries/

    math.randomseed(os.time())

    cron.after(math.random(2, 4), spawnScaryAnimal)

end

function love.update(dt)

    cron.update(dt)

    -- loop over scary animals
        -- if off screen
            -- remove
            -- and respawn

    local i = 1
    
    while i <= #entities do
        local removedItem = false
        if entities[i].type ~= nil and entities[i].type == 'scary_animal'
            and not world:onScreen(entities[i]) then
                table.remove(entities, i)
                cron.after(math.random(2, 4), spawnScaryAnimal)
                removedItem = true
        end

        if removedItem == false then
            i = i + 1
        end
    end
    
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

end



function love.draw()
    for _, e in pairs(entities) do
        e:draw()
    end
end
