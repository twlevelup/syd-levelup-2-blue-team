require 'person'
require 'scary_animal'
require 'imagespecs'
require 'scary_animal_movement_strategies'
require 'screen'

-- more info on cron here http://tannerrogalsky.com/blog/2012/09/19/favourite-lua-libraries/
local cron = require 'cron'

EntityManager = {}
EntityManager.__index = EntityManager
setmetatable(EntityManager, {__index = Screen})

function EntityManager:new(game)     
    local newEntityManager = {}
    newEntityManager.game = game
    newEntityManager.spawningCrowd = false
    newEntityManager.spawningScaryAnimal = false
    newEntityManager.entities = {}

    newEntityManager.world = World:new(love)
    newEntityManager.player = Player:new(love, newEntityManager.world)
    newEntityManager.distance = Distance:new(love)
    newEntityManager.panicmeter = Panicmeter:new(love)

    cron:reset()

    return setmetatable(newEntityManager, self)
end

function EntityManager:load()
    table.insert(self.entities, self.world)
    table.insert(self.entities, self.player)
    table.insert(self.entities, self.distance)
    table.insert(self.entities, self.panicmeter)
end    

function EntityManager:update(dt)
    cron.update(dt)
    self:doCrowdRemoveSpawn()
    self:doScaryAnimalRemoveSpawn()
    self:doUpateEntitiesAndCollide(dt)
    self.panicmeter:setPanic(self.player)

    if self:isGameOver() then 
        self.player:dispose()
        screenChange(GameOverScreen:new(self.game, self:getDistance()))
    end
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
    local t = ""
    for _, entity in pairs(self.entities) do
        entity:update(dt)
        for _, other in pairs(self.entities) do
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
        scaryAnimal = ScaryAnimal:new(self.game, graphic_specs.scary_fox)
    else
        scaryAnimal = ScaryAnimal:new(self.game, graphic_specs.scary_porcupine, create_stop_go_strategy())
    end

    table.insert(self.entities, scaryAnimal)
end

function EntityManager:removeOutOfBoundsScaryAnimals()
    local i = 1

    local hadScaryAnimal = false
    while i <= #self.entities do
        local removedItem = false
        if self.entities[i].type ~= nil and self.entities[i].type == 'scary_animal'
            then
            if not self.world:onScreen(self.entities[i]) then
                table.remove(self.entities, i)
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
    while i <= #self.entities do
       if self.entities[i].type ~= nil and self.entities[i].type == "person" then
          if not self.world:rightOfLeftBorder(self.entities[i]) then
            table.remove(self.entities, i)
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
        local person = Person:new(self.game, image_specs)
        if lastPerson ~= nil then
            person.x = (lastPerson.size.x) + lastPerson.x        
        end
        lastPerson = person
        table.insert(self.entities, person)
    end
end

function EntityManager:isGameOver()
    return self.player:isCaught() == true or self.player:isOutOfBounds()
end    

function EntityManager:draw()
    for _, e in pairs(self.entities) do
        e:draw()
    end
end

function EntityManager:getDistance()
    return self.distance:getDistance()
end