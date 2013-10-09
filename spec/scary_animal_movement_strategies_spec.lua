require 'entity'
require 'conf'
require 'scary_animal_movement_strategies'

describe("scary_animal_movement_strategies", function()
    local dt = 1
    local i = 0

    describe("aaa", function()
	    describe("movement strategy should move animal forward for Ticks_Between_Change ticks", function()
	    	local animal = mock_animal(5)
			local move_strategy = create_stop_go_strategy()
			for i = 1, Ticks_Between_Change do
				move_strategy(animal)
			end
			assert.is.equal(-(CameraXSpeed+animal.speed) * Ticks_Between_Change, animal.x)    	
	    end)

	    describe("movement strategy should stop animal for 50 ticks after moving for Ticks_Between_Change ticks", function()
	    	local animal = mock_animal(5)
	    	assert.is.equal(animal.x, 0)
			local move_strategy = create_stop_go_strategy()
			for i = 1, Ticks_Between_Change * 2 - 1 do
				move_strategy(animal)
			end
			assert.is.equal(-(CameraXSpeed+animal.speed) * Ticks_Between_Change + (-CameraXSpeed * (Ticks_Between_Change-1)), animal.x)    	
	    end)

	    describe("movement strategy should start animal moving again after Ticks_Between_Change ticks", function()
	    	local animal = mock_animal(5)
			local move_strategy = create_stop_go_strategy()
			for i = 1, Ticks_Between_Change*2+1 do
				move_strategy(animal)
			end
			assert.is.equal(-(CameraXSpeed+animal.speed) * (Ticks_Between_Change+1) - CameraXSpeed * Ticks_Between_Change, animal.x)    	
	    end)

	 end)

end)
