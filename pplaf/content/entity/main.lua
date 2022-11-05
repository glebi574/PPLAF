
pplaf.entities = {player = {}, enemy = {}}

pplaf.entity = {

	type = {},

	add_union = function(union)
		pplaf.entities[union] = {}
	end,

	create = function(x, y, type, args)
		local id = pewpew.new_customizable_entity(x, y)
		pewpew.customizable_entity_set_position_interpolation(id, true)
		pewpew.customizable_entity_configure_wall_collision(id, true)
		pewpew.customizable_entity_set_mesh(id, pplaf.entity[type].path .. type .. '/mesh.lua', 0)
		local entity = 	{
										 id = id,
									 type = type,
								weapons = pplaf.weapon.create(type)
										}
		if pplaf.entity.type[type].constructor then
			pplaf.entity.type[type].constructor(entity, args)
		end
		if pplaf.entity.type[type].destructor then
			function entity:destroy()
				pplaf.entity.type[type].destructor(self)
				pplaf.entities[self.union][self.id] = nil
			end
		end
		pplaf.entities[id] = entity
		return entity
	end,
	
	main = function()
		for _, union in pairs(pplaf.entities) do
			for _, entity in pairs(team) do
				pplaf.entity.type[entity.type].ai(entity)
				if not entity.weapons then break end
				for _, weapon in ipairs(entity.weapons) do
					pplaf.weapon.type[weapon.type].ai(entity)
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

pplaf.entity.load(pplaf.path .. 'entity/types/', require(pplaf.path .. 'entity/types/list.lua'))
