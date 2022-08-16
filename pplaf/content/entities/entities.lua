
entities = {player = {}, enemy = {}}

entity = {
	
	meshes = pplaf.path .. 'entities/meshes/',
	
	create = function(x, y, preset)
		local id = pewpew.new_entity(x, y)
		pewpew.interpolation(id, true)
		if entity.presets[preset].mesh then
			pewpew.set_mesh(id, entity.presets[preset].mesh[1], entity.presets[preset].mesh[2])
		end
		local param = {}
		param.preset = preset
		if entity.presets[preset].weapons then
			param.weapons = {}
			for _, weapon in ipairs(entity.presets[preset].weapons) do
				table.insert(param.weapons, weapons.create(weapon))
			end
		end
		;(entity.constructor[entity.presets[preset].constructor] or NULL_FUNCTION)(id, param)
		entities[entity.presets[preset].team and 'player' or 'enemy'][id] = param
		return id
	end,
	
	remove = function(id)
		entities.player[id] = nil
		entities.enemy[id] = nil
	end,
	
	main = function()
		for id, info in pairs(entities.player) do
			entity.ai[entity.presets[info.preset].ai](id, info)
		end
		for id, info in pairs(entities.enemy) do
			entity.ai[entity.presets[info.preset].ai](id, info)
		end
	end
	
}
