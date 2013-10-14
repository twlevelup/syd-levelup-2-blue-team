mock_input = function(action)
    return {
        input = {
            pressed = function(a)
                if a == action then
                    return true
                else
                    return false
                end
            end
        }
    }
end

mock_animation = function()
    local animation_spy = {
        update = spy.new(function(dt) end),
        flipH = spy.new(function() end),
        gotoFrame = spy.new(function() end)
    }

    return animation_spy
end

mock_sound = function()
    local sound_spy = {
        play = spy.new(function() end),
        stop = spy.new(function() end),
        isStopped = spy.new(function() end)
    }

    return sound_spy
end

mock_graphics = function ()
    return { 
        getHeight = function ()
            return 300
        end,
        newQuad = spy.new(function() end),
        newImage = function ()
            return {
                getWidth = spy.new(function() end),
                getHeight = spy.new(function() end)
            }
        end,
        newFont = function (a, b)
        end,
        setFont = function (a)
        end
    }
end

mock_game = function() 
    return {
        update = mock_animation().update,
        graphics = mock_graphics(),
        input = mock_input("none").input
    }
end

mock_animal = function(aspeed)
    return {
        speed = aspeed,
        x = 0,
        y = 0
    }
end

mock_world = function()
    local mock_world = {}
    
    World2 = {}
    World2.__index = World2

    function World2:onScreen(e)
        local x = 0
        local y = 0
        local w = 400
        local h = 400
        if(e.x > w or e.x + e.size.x < 0 or e.y + e.size.y < 0 or e.y > h) then
            return false
        else
            return true
        end
    end

    return setmetatable(mock_world, World2)
end