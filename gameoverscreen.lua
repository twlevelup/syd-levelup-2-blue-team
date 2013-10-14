require 'entity'
require 'conf'
require 'screen'
require 'leaderboard'

GameOverScreen = {}
GameOverScreen.__index = GameOverScreen
setmetatable(GameOverScreen, {__index = Screen})

function GameOverScreen:new(_game, _distance)
	local newGameOverScreen = {distance = _distance, game = _game}
  newGameOverScreen.name = "gameoverscreen"
  newGameOverScreen.leaderboard = LeaderBoard:new(_game)
  newGameOverScreen.leaderboard:readScores()
  newGameOverScreen.leaderboard:updateScores(_distance)
  return setmetatable(newGameOverScreen, self)
end

function GameOverScreen:draw()
  local image = love.graphics.newImage( 'assets/images/game-over-screen.png' )
  love.graphics.setColor(255, 255, 255, 255); -- white
  local msg1 = "You were caught! But you made it " .. self.distance .. " meters. "
  local msg2 = "Press Enter to play again..."
  local font = love.graphics.newFont('assets/fonts/Ponyo.otf', DistanceFontSize)
  love.graphics.draw(image, 0, 0)
  -- Draw the leaderboard main box
  love.graphics.rectangle("fill", 50, 50, ScreenWidth - 100, ScreenHeight/6)

  -- Draw the leaderboard black border
  love.graphics.setColor(0, 0, 0, 255) -- black
  love.graphics.rectangle("line", 50, 50, ScreenWidth - 100, ScreenHeight/6)

  love.graphics.print(msg1, ScreenWidth/2-font:getWidth(msg1)/2, 90-font:getHeight());
  love.graphics.print(msg2, ScreenWidth/2-font:getWidth(msg2)/2, 90);
  love.graphics.setColor(255, 255, 255, 255);


  self.leaderboard:draw()
end

function GameOverScreen:update()
    if self.game.input.pressed("enter") then
      local em = MainGameScreen:new(self.game)
      em:load()
      screenChange(em)
    end

end