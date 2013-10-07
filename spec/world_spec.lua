require 'entity'
require 'world'
require 'spec/mock_spec'

describe("on or off screen", function ()

    local newEntity, world

    before_each(function()
        world     = World:new(mock_game())
        newEntity = Entity:new({})
        newEntity.size = {
            x = 10,
            y = 10
        }

    end)

    it("should return true when an entity is on screen", function()
        assert.is.equal(world:onScreen(newEntity), true)
    end)

   -- it("should return false when an entity is off screen screen to the left", function()
   --      newEntity.x = -11
   --      assert.is.equal(world:onScreen(newEntity), false)

   --  end)

   -- it("should return false when an entity is off screen screen to the right", function()
   --      newEntity.x = 1000
   --      assert.is.equal(world:onScreen(newEntity), false)

   --  end)

end)
