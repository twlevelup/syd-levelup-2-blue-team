--How many ticks between changing move/stop for create_stop_go_strategy
Ticks_Between_Change = 25

function create_stop_go_strategy()   
  --local ticksBetweenChange = 50
  local ticksSoFar = 0
  local standingStill = false

  local movement_strategy = 
      function(animal, dt)  
          if ticksSoFar >= Ticks_Between_Change then
            ticksSoFar = 0
            standingStill = not standingStill
          end

          if not standingStill then
            animal.x = animal.x - CameraXSpeed - animal.speed         
          else
            animal.x = animal.x - CameraXSpeed
          end

          ticksSoFar = ticksSoFar + 1
        end

    return movement_strategy
end