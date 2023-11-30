
local function setup_flamethrower(entity)
  
end

local function flamethrower(entity)
  local _, _, sa, sd = pewpew.get_player_inputs(0)
  if sd ~= 0fx then
    local x, y = pewpew.entity_get_position(entity.id)
    pplaf.entity.create(x, y, 'flamethrower_projectile', sa)
  end
end

return {
  
  group = 'player',
  
  proto = {
    
  },
  
  constructor = function(entity, x, y, ...)
    entity.id = pewpew.new_player_ship(x, y, 0)
  end,
  
  destructor = function(entity, ...)
    
  end,
  
  ai = function(entity)
    flamethrower(entity)
  end,
  
}
