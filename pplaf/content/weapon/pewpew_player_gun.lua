return {
  recharge = 6,
  constructor = function(weapon)
    weapon.recharge = 0
  end,
  ai = function(weapon)
    if weapon.recharge > 0 then
      weapon.recharge = weapon.recharge - 1
    elseif pplaf.player.shoot_a ~= 0fx then
      weapon.recharge = weapon.type.recharge
      local x, y = pewpew.entity_get_position(weapon.entity.id)
      pplaf.entity.create(x, y, 'pewpew_player_bullet', pplaf.player.shoot_a)
    end
  end
}
