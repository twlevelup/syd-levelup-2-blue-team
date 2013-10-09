require 'person'
require 'entity'
require 'conf'
require 'spec/mock_spec'

describe("Person", function()
    describe("new person",function()
		it("person should be on the floor, and at the edge of the screen", function()	
            test_img_spec = {
                image = "nan", 
                size = {x = 10, y = 10}
            }

            local person = Person:new(mock_game(), test_img_spec)
            assert.is.equal(person.y, ScreenHeight - person.size.y)
            assert.is.equal(person.x, ScreenWidth)
        end)

    it("person should move at the speed of the camera (not move at all)", function()   
            test_img_spec = {
                image = "nan", 
                size = {x = 10, y = 10}
            }

            local person = Person:new(mock_game(), test_img_spec)
            person:update(0.1)
            assert.is.equal(person.x, ScreenWidth - CameraXSpeed)
        end)

    it("person should have size and image passed through image spec", function()   
            test_img_spec = {
                image = "AnImage.png", 
                size = {x = 10, y = 15}
            }
            local person = Person:new(mock_game(), test_img_spec)
            assert.is.equal("AnImage.png", person.graphics.source)
            assert.is.equal(10, person.size.x)
            assert.is.equal(15, person.size.y)            
        end)

    end)
end)
