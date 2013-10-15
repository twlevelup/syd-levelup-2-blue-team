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
    newPanicmeter.parent_type = "Background"
    newPanicmeter.size = config.size or {
          x = 250,
          y = 25
    }
    newPanicmeter.counter = config.counter or 0
    newPanicmeter.x = config.x or PanicMeterXOffset
    newPanicmeter.y = config.y or PanicMeterYOffset

    return setmetatable(newPanicmeter, self)
end

function Panicmeter:draw()  
    self:drawBackground()
    self:drawFillBar()
    self:drawBorder()
    self:drawLabel()
    self:resetColor()
end

function Panicmeter:drawBackground()
    self.game.graphics.setColor(255, 255, 255, 255);
    self.game.graphics.rectangle("fill", self.x, self.y, self.size.x, self.size.y)
end

function Panicmeter:drawBorder()
    self.game.graphics.setColor(0, 0, 0, 255);
    self.game.graphics.rectangle("line", self.x, self.y, self.size.x, self.size.y)
end

function Panicmeter:drawFillBar()
	local percentage_full = (self.counter/100.0)
	local fill_x = percentage_full * self.size.x
	
	self:drawFillBarFill(fill_x)
	self:drawFillBarBorder(fill_x)
end

function Panicmeter:drawFillBarFill(fill_x)
    self.game.graphics.setColor(255, 0, 0, 255);
    self.game.graphics.rectangle("fill", self.x, self.y, fill_x, self.size.y)
end

function Panicmeter:drawLabel()
    self.game.graphics.print("Panic", PanicMeterLabelXOffset, PanicMeterLabelYOffset)
end

function Panicmeter:drawFillBarBorder(fill_x)
    self.game.graphics.setColor(200, 0, 0, 255);
    self.game.graphics.rectangle("line", self.x, self.y, fill_x, self.size.y)
end

function Panicmeter:resetColor()
    love.graphics.setColor(255, 255, 255,255);
end

function Panicmeter:update(dt)
    if self.counter == nil then
        return 0
    else
        return math.floor(self.counter)
    end
end

function Panicmeter:setPanic(player)
    self.counter = player.panic
end