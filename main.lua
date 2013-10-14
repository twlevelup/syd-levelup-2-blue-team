require 'input'
require 'player'
require 'world'
require 'distance'
require 'leaderboard'
require 'panicmeter'
require 'conf'
require 'maingamescreen'
require 'gameoverscreen'
require 'screen'

love.animation = require 'vendor/anim8'
love.filesystem.setIdentity(identityDirName)

local cur_screen = MainGameScreen:new(love)

function love.load()
    cur_screen:load(this)
    love.input.bind('up', 'up')
    love.input.bind('left', 'left')
    love.input.bind('right', 'right')
    love.input.bind('down', 'down')
    love.input.bind('return', 'enter')
    math.randomseed(os.time())
end

function love.update(dt)
    cur_screen:update(dt)
end


function love.draw()
    cur_screen:draw()
end

function screenChange(screen)
    cur_screen = screen
end
