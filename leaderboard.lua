require 'input'
require 'player'
require 'world'
require 'conf'
require 'distance'

playerName = "YOU" -- needs to be set in the game somehow.

LeaderBoard = {}
LeaderBoard.__index = LeaderBoard
setmetatable(LeaderBoard, {__index = Entity})

function LeaderBoard:new(game)	
	local newLeaderBoard = Entity:new(game)
	newLeaderBoard.type = "LeaderBoard"
	newLeaderBoard.size = {
        x = 0,
        y = 0
    }

	newLeaderBoard.scores = {}

	game.graphics.setFont(game.graphics.newFont('assets/fonts/LilyScriptOne-Regular.ttf', DistanceFontSize))

	return setmetatable(newLeaderBoard, self)
end

function LeaderBoard:readScores(distance)
	-- Read in the contents of the game scores file and save the state in the leaderboard object.
    file = love.filesystem.newFile(gameScoresFile)
	file:open('r')

	local scores = {}

	for line in file:lines() do
		local temp = {}
		for word in string.gmatch(line, "%w+") do
			table.insert(temp, word)
		end
		table.insert(scores, temp)
	end

	file:close()

	for i, x in ipairs(scores) do
		if tonumber(x[2]) < distance.counter then
			-- table.insert(scores, i, {playerName, distance:getDistance()}) -- need player and player score
			table.insert(scores, i, {playerName, distance:getDistance()}) -- need player and player score
			break
		end 
	end

	self.scores = scores
end		

function LeaderBoard:writeScores()
	-- Write the current leaderboard state to the game score file.
    file = love.filesystem.newFile(gameScoresFile)
	file:open('w')

	for i, x in ipairs(self.scores) do
		file:write(x[1]..' '..x[2]..'\n')
	end

	file:close()
end

function LeaderBoard:update(dt)
	-- Do nothing at the moment.
end

function LeaderBoard:draw()
	-- Positions of all strings and boxes are set in relation to the screen height and width and the size of the string to print.	
	local font = love.graphics.getFont()
	local title = "Leaderboard"

	-- Draw the leaderboard main box
	love.graphics.setColor(200, 255, 255, 255) -- white
	love.graphics.rectangle("fill", ScreenWidth/4, ScreenHeight/4, ScreenWidth/2, ScreenHeight/2)

	-- Draw the leaderboard black border
	love.graphics.setColor(0, 0, 0, 255) -- black
	love.graphics.rectangle("line", ScreenWidth/4, ScreenHeight/4, ScreenWidth/2, ScreenHeight/2)

	-- Draw the leaderboard title
	love.graphics.print(title, (ScreenWidth/2) - (font:getWidth(title)/2), (ScreenHeight/4))

	-- Draw the leaderboard entries
	for i, x in ipairs(self.scores) do
		if i <= maxScoresOnLeaderboard then
			-- Draw the name
			love.graphics.print(x[1], (3*ScreenWidth/8) - (font:getWidth(x[1])/2), (ScreenHeight/4) + (i * (ScreenHeight/((maxScoresOnLeaderboard + 1) * 2))))

			-- Draw the score
			love.graphics.print(x[2], (5*ScreenWidth/8) - (font:getWidth(x[2])/2), (ScreenHeight/4) + (i * (ScreenHeight/((maxScoresOnLeaderboard + 1) * 2))))
		else
			break
		end
	end

	-- Reset the current graphics colour.
	love.graphics.setColor(255, 255, 255, 255)
end
