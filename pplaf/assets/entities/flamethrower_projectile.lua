
return {
  
  group = 'player',
  
  animation = 'flamethrower',
  
  proto = {
    lifetime = 0
  },
  
  constructor = function(entity, ...)
    local args = {...}
    local angle = args[1]
    
    entity.lifetime = pplaf.animation.types.flamethrower.frame_amount / 2
    
    entity:start_spawning(0)
    entity:set_position_interpolation(true)
    entity:set_mesh_angle(angle, 0fx, 0fx, 1fx)
  end,
  
  destructor = function(entity, ...)
    entity:destroy()
  end,
  
  ai = function(entity)
    entity.lifetime = entity.lifetime - 1
    if entity.lifetime == 0 then
      entity:destroyA()
    end
  end,
  
}
