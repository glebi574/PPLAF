return {
	union = 'player_bullets',
  speed = 16fx,
  lifetime = 120,
  constructor = function(bullet, args)
    pewpew.customizable_entity_skip_mesh_attributes_interpolation(bullet.id)
    pewpew.customizable_entity_set_mesh_angle(bullet.id, args, 0fx, 0fx, 1fx)
    bullet.dy, bullet.dx = fmath.sincos(args)
    bullet.dx = bullet.dx * bullet.type.speed
    bullet.dy = bullet.dy * bullet.type.speed
    bullet.lifetime = bullet.type.lifetime
  end,
  ai = function(bullet)
    if bullet.lifetime == 0 then
      bullet:destroy()
      return nil
    end
    bullet.lifetime = bullet.lifetime - 1
    local x, y = pewpew.entity_get_position(bullet.id)
    pewpew.entity_set_position(bullet.id, x + bullet.dx, y + bullet.dy)
  end,
  destructor = function(bullet)
		pewpew.customizable_entity_start_exploding(bullet.id, 6)
  end
}