require 'entity'
require 'conf'
require 'screen'

GameOverScreen = {}
GameOverScreen.__index = GameOverScreen
setmetatable(GameOverScreen, {__index = Screen})

function GameOverScreen:new(_game, _distance)
	local newGameOverScreen = {distance = _distance, game = _game}
  newGameOverScreen.name = "gameoverscreen"
  return setmetatable(newGameOverScreen, self)
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

function GameOverScreen:update()
    if self.game.input.pressed("enter") then
      local em = MainGameScreen:new(self.game)
      em:load()
      screenChange(em)
    end

end