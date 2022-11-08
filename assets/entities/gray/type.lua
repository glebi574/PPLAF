return {
	union = 'player',
  on_damage = {
    mesh_change_duration = 8,
    sound = true
  },
  animation = {
    frames = 10,
    frequency = 15
  },
  constructor = function(entity, args)
    
  end,
  damage = function(entity)

  end,
  ai = function(entity)
    
  end,
  destructor = function(entity)
		pewpew.customizable_entity_start_exploding(entity.id, 40)
  end
}