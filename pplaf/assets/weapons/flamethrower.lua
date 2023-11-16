
return {
  
  recharge = 0,
  
  proto = {
    recharge = 0,
  },
  
  constructor = function(weapon, ...)
    
  end,
  
  ai = function(weapon)
    if weapon.recharge > 0 then
      weapon.recharge = weapon.recharge - 1
      return nil
    end
    local _, _, sa, sd = pewpew.get_player_inputs(0)
    if sd ~= 0fx then
      local x, y = pewpew.entity_get_position(weapon.entity.id)
      pplaf.entity.create(x, y, 'flamethrower_projectile', sa)
      weapon.recharge = weapon.type.recharge
    end
  end,
  
}
