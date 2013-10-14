require 'person'
require 'park_ranger'
require 'scary_animal'
require 'imagespecs'
require 'scary_animal_movement_strategies'
require 'screen'

-- more info on cron here http://tannerrogalsky.com/blog/2012/09/19/favourite-lua-libraries/
local cron = require 'cron'

MainGameScreen = {}
MainGameScreen.__index = MainGameScreen
setmetatable(MainGameScreen, {__index = Screen})

local foreground_y_offset = -25

function MainGameScreen:new(game)
    local newMainGameScreen = {}
    newMainGameScreen.game = game
    newMainGameScreen.spawningCrowd = false
    newMainGameScreen.spawningScaryAnimal = false
    newMainGameScreen.entities = {}
    newMainGameScreen.name = "maingamescreen"

    newMainGameScreen.world = World:new(love)
    newMainGameScreen.player = Player:new(love, newMainGameScreen.world)
    newMainGameScreen.park_ranger = ParkRanger:new(love)
    newMainGameScreen.distance = Distance:new(love)
    newMainGameScreen.panicmeter = Panicmeter:new(love)
    newMainGameScreen.leaderboard = LeaderBoard:new(love)

    cron:reset()

    return setmetatable(newMainGameScreen, self)
end

function MainGameScreen:load()
    table.insert(self.entities, self.world)
    table.insert(self.entities, self.player)
    table.insert(self.entities, self.park_ranger)
    table.insert(self.entities, self.distance)
    table.insert(self.entities, self.panicmeter)
end

function MainGameScreen:update(dt)
    cron.update(dt)
    self:doCrowdRemoveSpawn()
    self:doScaryAnimalRemoveSpawn()
    self:doUpateEntitiesAndCollide(dt)
    self.panicmeter:setPanic(self.player)

    if self:isGameOver() then
        self.player:dispose() -- this stops the sound loop; else the sound will 'overlap'
        self.world:dispose()
        screenChange(GameOverScreen:new(self.game, self:getDistance()))
    end
end

function MainGameScreen:doCrowdRemoveSpawn()
    if not self.spawningCrowd and self:removeOutOfBoundsEntities("person") == 0 then
        self.spawningCrowd = true
        cron.after(math.random(1, 3),
            function()
                self.spawnCrowd(self, entities, cron)
                self.spawningCrowd = false
            end
        )
    end
end

function MainGameScreen:doScaryAnimalRemoveSpawn()
    if not self.spawningScaryAnimal and self:removeOutOfBoundsEntities("scary_animal") == 0 then
        self.spawningScaryAnimal = true
        cron.after(math.random(2, 4),
            function()
                self.spawnScaryAnimal(self, entities, cron)
                self.spawningScaryAnimal = false
            end
        )
    end
end

function MainGameScreen:doUpateEntitiesAndCollide(dt)
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

function MainGameScreen:spawnScaryAnimal()
    local r = math.random(0,1)

    local scaryAnimal = nil
    if r == 0 then
        scaryAnimal = ScaryAnimal:new(self.game, graphic_specs.scary_fox)
    else
        scaryAnimal = ScaryAnimal:new(self.game, graphic_specs.scary_porcupine, create_stop_go_strategy())
    end

    table.insert(self.entities, scaryAnimal)
end

function MainGameScreen:removeOutOfBoundsEntities(entity_type)
    local i = 1
    local remaining_entity_count = 0
    while i <= #self.entities do
       if self.entities[i].type ~= nil and self.entities[i].type == entity_type then
          if not self.world:rightOfLeftBorder(self.entities[i]) then
            table.remove(self.entities, i)
          else
            remaining_entity_count = remaining_entity_count + 1
            i = i + 1
          end
        else
          i = i + 1
        end
    end
    return remaining_entity_count
end

function MainGameScreen:getDistance()
    return self.distance:getDistance()
end

function MainGameScreen:spawnCrowd()
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

function MainGameScreen:isGameOver()
    return self.player:isFrozenInPanic() == true or self.player:isCaught()
end

function MainGameScreen:draw()
    for _, e in pairs(self.entities) do
        if e.parent_type == 'Foreground' then
            self.game.graphics.push()
            self.game.graphics.translate(0, foreground_y_offset)
            e:draw()
            self.game.graphics.pop()
        elseif e.parent_type == 'Background' then
            e:draw()
        else
            error("Should have known parent type")
        end
    end
end