require 'scary_animal'
require 'entity'
require 'conf'
require 'spec/mock_spec'

describe("Scary Animals", function()
-- should appear on screen every 2-4s
    describe("new scary animal",function()

        it("should be on the ground right hand side of the screen", function()
            local scaryAnimal = ScaryAnimal:new({})
            assert.is.equal(scaryAnimal.x, ScreenWidth)
            assert.is.equal(scaryAnimal.y, ScreenHeight - scaryAnimal.size.y)
        end)

        it("should be moving at speed 9 from right to left", function()

            local scaryAnimal = ScaryAnimal:new({})
            local origin_x = scaryAnimal.x

            scaryAnimal:update(dt)

            assert.is.equal(scaryAnimal.speed, 9)
            assert.is.equal(scaryAnimal.x, origin_x - scaryAnimal.speed)

        end)
    end)

    describe("scary animal spawning and unspawning", function()

        it("should appear on screen within 4s", function()
            -- Need to check to see if spawnScaryAnimal() from main.lua is called after a 4s of updates.
        end)
    end)


    describe("drawing the scary animal", function()

        it("should look like a scary animal", function()
            local scaryAnimal = ScaryAnimal:new({})
            assert.is.equal(scaryAnimal.graphics.source, "assets/images/scary-animal-sprites-wolf.png")
        end)

        it("should always be updating the animation state", function ()
            local scaryAnimal = ScaryAnimal:new({})
            scaryAnimal.graphics.animation = mock_animation()
            scaryAnimal:update(dt)
            assert.spy(scaryAnimal.graphics.animation.update).was.called()
        end)

    end)

end)
