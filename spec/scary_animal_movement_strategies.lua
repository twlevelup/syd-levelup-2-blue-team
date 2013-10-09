require 'entity'
require 'conf'
require 'scary_animal_movement_strategies'
s
describe("scary_animal_movement_strategies", function()
    local dt = 1

    assertEquals(false, true)

    describe("aaa", function()
	    describe("movement strategy should move animal forward for 0.65 seconds", function()
	    	local animal = mock_animal(5)
			local move_strategy = createStopGoStrategy()
			move_strategy(animal, 0.65)
			assertEquals(animal.x, -(1+animal.speed + CameraXSpeed))    	
			assertEquals(true, false)
	    end)

	    describe("movement strategy should stop animal for 0.65 seconds after moving", function()

	    end)

	    describe("movement strategy should start animal moving again after 0.65 seconds", function()

	    end)

	 end)

end)
