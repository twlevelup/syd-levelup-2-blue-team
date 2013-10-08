-- Set DEBUG_MODE to true to enable useful debugging output
-- such as drawing the bounding box
--DEBUG_MODE = true

-- See https://love2d.org/wiki/Config_Files for the full list of configuration
-- options and defaults.
ScreenWidth = 700
ScreenHeight = 500

-- Distance meter constants
DistanceFontSize = 20
DistanceMeterYOffset = 30
DistanceMeterXOffset = ScreenWidth - 260

-- Panic meter constants
PanicMeterXOffset = 50
PanicMeterYOffset = 30
DistanceFontSize = 20
-- How much the panic increased by when you collide with a scary animal
PanicIncrease = 20

function love.conf(config)
    config.title = "New Game - Alex's Team"
    config.screen.width = ScreenWidth
    config.screen.height = ScreenHeight
    config.modules.joystick = false
    config.modules.mouse = false
    config.modules.physics = false
end
