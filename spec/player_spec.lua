require 'player'
require 'entity'

describe("Player", function()
    local dt = 1

    describe("#update", function()
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


        describe("playing the movement sound", function()
            it("should play the movement sound when the player is moving", function()
                local player = Player:new(mock_game())
                player.game.input = mock_input('up').input
                player.sound.moving.sample = mock_sound()
                player:update(dt)

                assert.spy(player.sound.moving.sample.play).was.called()
            end)
        end)

        describe("new player",function()
			it("player should be on the floor", function()	
                local player = Player:new(mock_game())
                player:update(0.1)
                assert.is.equal(player.y, player.game.graphics:getHeight() - player.size.y)
            end)
        end)

        describe("lastPosition", function()
            it("should store the last position before moving vertically", function()
                local player = Player:new(mock_game())
                player.x = 10
                player.y = 10
                player.game.input = mock_input('none').input

                player:update(0.1)
                assert.is_true(player.x == 10)
                assert.is_true(player.y > 10)
                assert.are.same(player.lastPosition, {x = 10, y = 10})
            end)
        end)

        describe("animating the player", function()
            describe("the sprite direction", function()
                it("should point to the right by default", function()
                    local player = Player:new(mock_input('none'))
                    assert.is.equal(player.graphics.facing, "right")
                end)
            end)

            describe("the animation frame", function()
                it("should always be updating the animation state", function ()
                    local player = Player:new(mock_game())
                    player.game.input = mock_input('none').input
                    player.graphics.animation = mock_animation()
                    player:update(dt)
                    assert.spy(player.graphics.animation.update).was.called()
                end)
            end)
        end)

        describe("collide", function()
            local player, collidingEntity

            before_each(function()
                player = Player:new({})
                player.size = {
                    x = 10,
                    y = 10
                }
                player.x = 20
                player.y = 10
                player.graphics.animation = mock_animation()

                collidingEntity = Entity:new({})
                collidingEntity.x = 10
                collidingEntity.y = 10
                collidingEntity.size = {

                    x = 10,
                    y = 10
                }
            end)

            it("should move the player to its last position when colliding on the left side", function()
                player.lastPosition = {x = 21, y = 10}

                player:collide(collidingEntity)

                assert.is.equal(player.x, 21)
                assert.is.equal(player.y, 10)
            end)

            it("should move the player to its last position when colliding on the right side", function()
                player.lastPosition = {x = 9, y = 10}

                player:collide(collidingEntity)

                assert.is.equal(player.x, 9)
                assert.is.equal(player.y, 10)
            end)

            it("should move the player to its last position when colliding on the top side", function()
                player.lastPosition = {x = 10, y = 11}

                player:collide(collidingEntity)

                assert.is.equal(player.x, 10)
                assert.is.equal(player.y, 11)
            end)

            it("should move the player to its last position when colliding on the bottom side", function()
                player.lastPosition = {x = 10, y = 9}

                player:collide(collidingEntity)

                assert.is.equal(player.x, 10)
                assert.is.equal(player.y, 9)
            end)
        end)

        describe("player movement", function()
            it("should decrease the player's y if the up-arrow is pressed", function()
                local player = Player:new(mock_game())
                player.game.input = mock_input('up').input
                local orig_y = player.y

                player:update(0.1)
                assert.is_true(orig_y > player.y)
            end)

            it("should be under the influence of gravity and be falling when no input is pressed", function ()
                local player = Player:new(mock_game())
                player.game.input = mock_input('none').input
                player.y = 0
                local orig_y = player.y
                local orig_dy = player.dy
                player:update(0.1)
                assert.is_true(player.dy > orig_dy)
                assert.is_true(player.y > orig_y)
            end)

            it("should be under the influence of gravity and be falling to the ground after jumping", function ()
                local player = Player:new(mock_game())
                player.game.input = mock_input('up').input
                player:update(0.1)
                player.game.input = mock_input('none').input
                local orig_y = player.y
                local orig_dy = player.dy
                player:update(0.1)
                assert.is_true(player.dy > orig_dy)
            end)

            it("should only be able to jump whilst on the ground", function ()
                local player = Player:new(mock_game())
                player.handleJump = spy.new(function() end)
                player.game.input = mock_input("up").input
                player:update(0.1)
                player.game.input = mock_input("up").input
                player:update(0.1)
                assert.spy(player.handleJump).was.called(1)
            end)
        end)
    end)
end)


