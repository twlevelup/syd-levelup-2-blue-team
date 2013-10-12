require 'entity'
require 'conf'

GameOverScreen = {}
GameOverScreen.__index = GameOverScreen

function GameOverScreen:new(game)
	local newGameOverScreen = {}
  return setmetatable(newGameOverScreen, self)
end

function GameOverScreen:setDistance(distance)
  self.distance = distance
end

function GameOverScreen:draw()
  local image = love.graphics.newImage( 'assets/images/game-over-screen.png' )
  love.graphics.setColor(255, 255, 255,255);
  local msg1 = "You were caught! But you made it " .. self.distance .. " meters. " 
  local msg2 = "Press Enter to escape (play) again..."
  local font = love.graphics.newFont('assets/fonts/LilyScriptOne-Regular.ttf', DistanceFontSize)
  love.graphics.draw(image, 0, 0)
  love.graphics.setColor(0, 0, 0,255);
  love.graphics.print(msg1, ScreenWidth/2-font:getWidth(msg1)/2, ScreenHeight/2-font:getHeight());
  love.graphics.print(msg2, ScreenWidth/2-font:getWidth(msg2)/2, ScreenHeight/2);
  love.graphics.setColor(255, 255, 255,255);
end

