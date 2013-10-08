require 'input'
require 'player'
require 'scary_animal'
require 'obstacle'
require 'world'
require 'distance'
require 'panicmeter'
require 'conf'
require 'person'

love.animation = require 'vendor/anim8'

local entities = {}
local world = World:new(love)

local max_view = -450
local view_width = 0
local view_height = 0

local player = Player:new(love)
local distance = Distance:new(love)
local panicmeter = Panicmeter:new(love)

local cron = require 'cron'

local spawningCrowd = false

function spawnScaryAnimal()
    local scaryAnimal = ScaryAnimal:new(love)
    table.insert(entities, scaryAnimal)
end

function removeOutOfBoundsCrowds()
    local i = 1
    local hadPerson = false
    while i <= #entities do
       if entities[i].type ~= nil and entities[i].type == "person" then
          if not world:rightOfLeftBorder(entities[i]) then
            table.remove(entities, i)
          else
            hadPerson = true
            i = i + 1
          end
        else
          i = i + 1
        end
    end      
    return hadPerson
end

function spawnCrowd()
    local i = 0
    local lastPerson = nil
    for i=0, math.random(0, 1) do
      local person = Person:createRandomPerson(love)
      if lastPerson ~= nil then
        person.x = (lastPerson.size.x) + lastPerson.x        
      end
      lastPerson = person
      table.insert(entities, person)
    end
    spawningCrowd = false
end

function love.load()
    table.insert(entities, world)
    table.insert(entities, player)
    table.insert(entities, distance)
    table.insert(entities, panicmeter)

    love.input.bind('up', 'up')
    love.input.bind('left', 'left')
    love.input.bind('right', 'right')
    love.input.bind('down', 'down')

    math.randomseed(os.time())

    -- more info on cron here http://tannerrogalsky.com/blog/2012/09/19/favourite-lua-libraries/
    cron.after(math.random(2, 4), spawnScaryAnimal)

end

function love.update(dt)

    cron.update(dt)

    local i = 1
    
    if spawningCrowd or removeOutOfBoundsCrowds() == false then
      spawnCrowd()
    end

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
    panicmeter:setPanic(player)
end

function isGameOver()
    return player:isCaught() == true
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
