
local variation_amount = 8
local frame_amount = 90
local __frame_t = frame_amount - 2
local mesh = '/dynamic/pplaf/assets/meshes/flamethrower.lua'

return {
  
  group = 'player',
  
  proto = {
    lifetime = 0
  },
  
  constructor = function(entity, ...)
    local args = {...}
    local angle = args[1]
    entity.variation_index = pplaf.math.random(0, variation_amount - 1)
    
    entity:start_spawning(0)
    entity:set_position_interpolation(true)
    entity:set_mesh_angle(angle, 0fx, 0fx, 1fx)
    entity:set_mesh(mesh, 0)
  end,
  
  destructor = function(entity, ...)
    entity:destroy()
  end,
  
  ai = function(entity)
    local offset = entity.variation_index * frame_amount + 1
    if entity.lifetime == 0 then
      entity:set_mesh(mesh, 0)
    else
      entity:set_flipping_meshes(mesh, offset + entity.lifetime, offset + entity.lifetime + 1)
    end
    entity.lifetime = entity.lifetime + 2
    if entity.lifetime == __frame_t then
      entity:destroyA()
    end
  end,
  
}
