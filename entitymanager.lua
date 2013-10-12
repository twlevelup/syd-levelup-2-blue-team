require 'person'
require 'scary_animal'
require 'imagespecs'
require 'scary_animal_movement_strategies'

local entities = {}

-- more info on cron here http://tannerrogalsky.com/blog/2012/09/19/favourite-lua-libraries/
local cron = require 'cron'
local world = nil
local player = nil
local distance = nil
local panicmeter = nil

EntityManager = {}
EntityManager.__index = EntityManager

function EntityManager:new(game)     
    local newEntityManager = {}
    newEntityManager.game = game
    newEntityManager.spawningCrowd = false
    newEntityManager.spawningScaryAnimal = false

    world = World:new(love)
    player = Player:new(love, world)
    distance = Distance:new(love)
    panicmeter = Panicmeter:new(love)

    return setmetatable(newEntityManager, self)
end

function EntityManager:load()
    table.insert(entities, world)
    table.insert(entities, player)
    table.insert(entities, distance)
    table.insert(entities, panicmeter)
end    

function EntityManager:update(dt)
    cron.update(dt)
    self:doCrowdRemoveSpawn(entities, cron)
    self:doScaryAnimalRemoveSpawn(entities, cron)
    self:doUpateEntitiesAndCollide(dt, entities)
    panicmeter:setPanic(player)
end

function EntityManager:doCrowdRemoveSpawn()
    if not self.spawningCrowd and self:removeOutOfBoundsCrowds(entities, world) == false then
        self.spawningCrowd = true
        cron.after(math.random(1, 3), 
            function()
                self.spawnCrowd(self, entities, cron)
                self.spawningCrowd = false
            end
        )
    end
end

function EntityManager:doScaryAnimalRemoveSpawn()
    if not self.spawningScaryAnimal and self:removeOutOfBoundsScaryAnimals(entities, world) == false then
        self.spawningScaryAnimal = true
        cron.after(math.random(2, 4), 
            function()
                self.spawnScaryAnimal(self, entities, cron)
                self.spawningScaryAnimal = false
            end
        )
    end
end

function EntityManager:doUpateEntitiesAndCollide(dt)
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
end

function EntityManager:spawnScaryAnimal()
    local r = math.random(0,1)
    
    local scaryAnimal = nil
    if r == 0 then        
        scaryAnimal = ScaryAnimal:new(love, graphic_specs.scary_fox)
    else
        scaryAnimal = ScaryAnimal:new(love, graphic_specs.scary_porcupine, create_stop_go_strategy())
    end

    table.insert(entities, scaryAnimal)
end

function EntityManager:removeOutOfBoundsScaryAnimals()
    local i = 1

    local hadScaryAnimal = false
    while i <= #entities do
        local removedItem = false
        if entities[i].type ~= nil and entities[i].type == 'scary_animal'
            then
            if not world:onScreen(entities[i]) then
                table.remove(entities, i)
                removedItem = true
            else
                hadScaryAnimal = true
            end
        end

        if removedItem == false then
            i = i + 1
        end
    end
    return hadScaryAnimal
end

function EntityManager:removeOutOfBoundsCrowds()
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

function EntityManager:spawnCrowd()
    local i = 0
    local lastPerson = nil
    for i=0, math.random(0, 1) do
        local personIndex = math.random(1, table.getn(crowd_specs))
        local image_specs = crowd_specs[personIndex]
        local person = Person:new(love, image_specs)
        if lastPerson ~= nil then
            person.x = (lastPerson.size.x) + lastPerson.x        
        end
        lastPerson = person
        table.insert(entities, person)
    end
end

function EntityManager:isGameOver()
    return player:isCaught() == true or player:isOutOfBounds()
end    

function EntityManager:draw()
    for _, e in pairs(entities) do
        e:draw()
    end
end

function EntityManager:getDistance()
    return distance:getDistance()
end

