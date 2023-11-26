
-- allows creation of pewpew player ships

pplaf.player = {
  
  pewpew_proto = require(pplaf.content .. 'pewpew_proto_player.lua'),
  
  reassign_prototypes = function(...) -- reassigns type prototypes from custom to player functions
    for _, name in ipairs{...} do
      setmetatable(pplaf.entity.types[name].proto, {__index = pplaf.player.pewpew_proto})
    end
  end,
  
  create = function(x, y, type, ...) -- create player ship in position, with type and pass any parameters to constructor(if it exists)
    local id = pewpew.new_player_ship(x, y, 0)
    local player = {
      id = id,
      type = pplaf.entity.types[type],
      is_alive = true,
    }
    __DEF_PPLAF_ENTITY_MODIFY(player, ...)
    __DEF_PPLAF_ENTITY_STORE(player)
    return player
  end,
  
}

--[[
  
  addon for entity.lua to allow you using pewpew player ships
  
  call reassign_prototypes() for every player type you loaded; otherwise you will have access to functions that won't work, will work incorrectly and won't have access to player-specific functions; this also removes inheritance of entity type prototype if one was defined
  
]]--
