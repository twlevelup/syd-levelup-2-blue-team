require 'leaderboard'
require 'spec/mock_spec'

describe("Leaderboard", function()

	-- Not sure what to test for just yet.

	-- Maybe once the leader is implemented into the main game loop we can test it is called at the end of the game.

	-- Could we test to see if leaderboard is reading/writing to a file?
	describe("#updateScores", function()
		it("check updateScores correctly changes the leaderboard", function()
			local leaderboard = LeaderBoard:new({graphics = mock_graphics()})

			leaderboard.scores = {{"RUN", "10"}, {"RAB", "8"}, {"BIT", "6"}, {"RUN", "5"}, {"ONE", "1"}}
			leaderboard:updateScores(9)

			assert.equal(leaderboard.scores[1][1], "RUN")
			assert.equal(leaderboard.scores[1][2], "10")
			assert.equal(leaderboard.scores[2][1], "YOU")
			assert.equal(leaderboard.scores[2][2], 9)
			assert.equal(leaderboard.scores[3][1], "RAB")
			assert.equal(leaderboard.scores[3][2], "8")
			assert.equal(leaderboard.scores[4][1], "BIT")
			assert.equal(leaderboard.scores[4][2], "6")
			assert.equal(leaderboard.scores[5][1], "RUN")
			assert.equal(leaderboard.scores[5][2], "5")
			assert.equal(leaderboard.scores[6][1], "ONE")
			assert.equal(leaderboard.scores[6][2], "1")

		end)
	end)
end)