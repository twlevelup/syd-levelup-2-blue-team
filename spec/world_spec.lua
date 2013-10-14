require 'entity'
require 'world'
require 'spec/mock_spec'

describe("world", function ()

    local newEntity, world

    before_each(function()
        world     = World:new(mock_game())
        newEntity = Entity:new({})
        newEntity.size = {
            x = 10,
            y = 10
        }
        newPlayer = Entity:new(game)
    end)

    it("should return true when an entity is on screen", function()
        assert.is.equal(world:onScreen(newEntity), true)
    end)
end)

