require 'input'
require 'player'
require 'world'
require 'conf'

Panicmeter = {}
Panicmeter.__index = Panicmeter
setmetatable(Panicmeter, {__index = Entity})

function Panicmeter:new(game, config) 
    local config = config or {}
    local newPanicmeter = Entity:new(game)

    newPanicmeter.type = "Panicmeter"
    newPanicmeter.counter =  config.counter or 0
    game.graphics.setFont(game.graphics.newFont('assets/fonts/LilyScriptOne-Regular.ttf', DistanceFontSize))
    newPanicmeter.size = config.size or {
          x = 250,
          y = 25
      }
    newPanicmeter.x = config.x or PanicMeterXOffset
    newPanicmeter.y = config.y or PanicMeterYOffset

    return setmetatable(newPanicmeter, self)
end

function Panicmeter:update(dt)
    self.counter = self.counter - 0.25 * dt
    if self.counter < 0 then
        self.counter = 0
    end
end

function Panicmeter:draw()  
    self.game.graphics.setColor(255, 255, 255, 255);
    self.game.graphics.rectangle("fill", self.x, self.y, self.size.x, self.size.y)
    
    self.game.graphics.setColor(255, 0, 0, 255);
    self.game.graphics.rectangle("fill", self.x, self.y, ((self.counter/100.0) * self.size.x), self.size.y)

    self.game.graphics.setColor(200, 0, 0, 255);
    self.game.graphics.rectangle("line", self.x, self.y, ((self.counter/100.0) * self.size.x), self.size.y)
    self.game.graphics.setColor(0, 0, 0, 255);
    self.game.graphics.rectangle("line", self.x, self.y, self.size.x, self.size.y)

    love.graphics.setColor(255, 255, 255,255);
end

function Panicmeter:incPanic()
    self.counter = math.min(self.counter + 20, 100)
end

function Panicmeter:getPanic()
    if self.counter == nil then
        return 0
    else
        return math.floor(self.counter)
    end
end