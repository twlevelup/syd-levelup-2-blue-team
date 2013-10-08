require 'entity'

Person = {}
Person.__index = Person
setmetatable(Person, {__index = Entity})

function Person:createRandomPerson(game)
    local r = math.random(1,5)
    if r == 1 then 
      return Person:createBoy(game)
    elseif r == 2 then 
      return Person:createMan2(game)
    elseif r == 3 then 
      return Person:createWoman1(game)
    elseif r == 4 then 
      return Person:createWoman2(game)
    else
      return Person:createMan1(game)  
    end
end

function Person:createBoy(game)
  
    local size = {
        x = 40,
        y = 121
    }
    local img = "assets/images/boy.png"
    
    return Person:new(game, size, img)
  
end

function Person:createMan1(game)
  
    local size = {
        x = 51,
        y = 110
    }
    local img = "assets/images/SmallPerson.png"
  
    return Person:new(game, size, img)
end

function Person:createMan2(game)
  
    local size = {
        x = 50,
        y = 114
    }
    local img = "assets/images/Person2.png"
  
    return Person:new(game, size, img)
end

function Person:createWoman1(game)
  
    local size = {
        x = 51,
        y = 105
    }
    local img = "assets/images/Person3.png"
  
    return Person:new(game, size, img)
end

function Person:createWoman2(game)
  
    local size = {
        x = 78,
        y = 105
    }
    local img = "assets/images/Celine3.png"
  
    return Person:new(game, size, img)
end


function Person:new(game, size, img)

    local newPerson = Entity:new(game)
    
    newPerson.graphics = {
        source = img
    }
    newPerson.size = size

    newPerson.type = "person"
    newPerson.x = 700
    newPerson.y = ScreenHeight - newPerson.size.y -- - GroundYOffset


    if game.graphics ~= nil and game.animation ~= nil then
        newPerson.graphics.sprites = game.graphics.newImage(newPerson.graphics.source)
        newPerson.graphics.grid = game.animation.newGrid(
            newPerson.size.x, newPerson.size.y,
            newPerson.graphics.sprites:getWidth(),
            newPerson.graphics.sprites:getHeight()
        )
        newPerson.graphics.animation = game.animation.newAnimation(
            newPerson.graphics.grid("1-1", 1),
            0.05
        )
    end

    return setmetatable(newPerson, self)
end

function Person:update(dt)

    self.x = self.x - 4 -- - CameraXSpeed

    if self.graphics.animation ~= nil then
        self.graphics.animation:update(dt)
    end

end
