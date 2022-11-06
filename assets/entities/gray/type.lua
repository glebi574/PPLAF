return {
	union = 'player',
  constructor = function(entity, args)
    
  end,
  ai = function(entity)
    
  end,
  destructor = function(entity)
		pewpew.customizable_entity_start_exploding(entity.id, 40)
  end
}