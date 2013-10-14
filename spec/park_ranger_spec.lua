require 'park_ranger'
require 'entity'
require 'conf'
require 'spec/mock_spec'

describe("Park ranger", function()
    describe("new park ranger",function()

        it("should be a foreground entity", function ()
            local park_ranger = ParkRanger:new(mock_game())
            assert.is.equal(park_ranger.parent_type, "Foreground")
        end)

        it("the park ranger should be on the floor", function()
            local park_ranger  = ParkRanger:new(mock_game())
            assert.is.equal(park_ranger.y, ScreenHeight - park_ranger.size.y)
        end)

        it("should be on the left edge of the screen", function()
            local park_ranger  = ParkRanger:new(mock_game())
            assert.is.equal(park_ranger.x, 0)
        end)

        it("park_ranger should have size and image passed through image spec", function()
            local park_ranger = ParkRanger:new(mock_game())
            assert.is.equal("assets/images/park_ranger.png", park_ranger.graphics.source)
            assert.is.equal(80, park_ranger.size.x)
            assert.is.equal(114, park_ranger.size.y)
        end)

    end)
end)
