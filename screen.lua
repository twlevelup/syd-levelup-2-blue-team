Screen = {}
Screen.__index = Screen

function Screen:new(game)
    local newScreen = {
        name = "Not set"      
    }

    return setmetatable(newScreen, self)
end

function Screen:getScreenName()
    return this.name
end

function Screen:update(game)
end

function Screen:draw(game)
end