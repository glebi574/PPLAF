
pplaf.entities = {player = {}, enemy = {}, player_bullets = {}, enemy_bullets = {}}

pplaf.entity = {

	type = {},

	add_union = function(union)
		pplaf.entities[union] = {}
	end,

	create = function(x, y, type, args)
		local id = pewpew.new_customizable_entity(x, y)
		pewpew.customizable_entity_set_position_interpolation(id, true)
		pewpew.customizable_entity_configure_wall_collision(id, true)
		pewpew.customizable_entity_set_mesh(id, pplaf.entity.type[type].path .. type .. '/mesh.lua', 0)
		local entity = 	{
										 id = id,
									 type = pplaf.entity.type[type]
										}
		if pplaf.entity.type[type].weapons then
			entity.weapons = pplaf.weapon.create(entity, type)
		end
		if pplaf.entity.type[type].constructor then
			pplaf.entity.type[type].constructor(entity, args)
		end
		if pplaf.entity.type[type].destructor then
			function entity:destroy()
				pplaf.entity.type[type].destructor(self)
				pplaf.entities[self.union][self.id] = nil
			end
			pewpew.customizable_entity_configure_wall_collision(id, true, entity.destroy)
		end
		pplaf.entities[pplaf.entity.type[type].union][id] = entity
		return entity
	end,
	
	main = function()
		for _, union in pairs(pplaf.entities) do
			for _, entity in pairs(union) do
				if entity.type.ai then
					entity.type.ai(entity)
				end
				if not entity.weapons then break end
				for _, weapon in ipairs(entity.weapons) do
					weapon.type.ai(weapon)
				end
			end
		end
	end,

	load = function(path, list)
		for _, name in pairs(list) do
			pplaf.entity.type[name] = require(path .. name .. '/type.lua')
			pplaf.entity.type[name].path = path
		end
	end
	
}

pplaf.entity.load(pplaf.path .. 'entity/', {'pewpew_player', 'pewpew_player_bullet'})
