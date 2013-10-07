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
        stop = spy.new(function() end)
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


