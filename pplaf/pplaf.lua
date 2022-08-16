
_G = nil
_ENV.pewpew_old = nil
_ENV.fmath_old = nil

pewpew.new_entity = pewpew.new_customizable_entity
pewpew.start_spawning = pewpew.customizable_entity_start_spawning
pewpew.start_exploding = pewpew.customizable_entity_start_exploding
pewpew.set_mesh = pewpew.customizable_entity_set_mesh
pewpew.set_color = pewpew.customizable_entity_set_mesh_color
pewpew.set_scale = pewpew.customizable_entity_set_mesh_scale
pewpew.set_angle = pewpew.customizable_entity_set_mesh_angle
pewpew.add_angle = pewpew.customizable_entity_add_rotation_to_mesh
pewpew.interpolation = pewpew.customizable_entity_set_position_interpolation
pewpew.skip_interpolation = pewpew.customizable_entity_skip_mesh_attributes_interpolation


pplaf = {
	
	path = '/dynamic/pplaf/content/',

	require = function(lib)
		return require(pplaf.path .. lib .. ".lua")
	end,

	main = function()
		TIME = TIME + 1
		 entity.main()
		 player.main()
		 camera.main()
		weapons.main()
		 bullet.main()
	end

}

pplaf.require'global_variables'
pplaf.require'math'
pplaf.require'fxmath'
pplaf.require'camera'
pplaf.require'entities/entities'
pplaf.require'entities/options'
pplaf.require'entities/player'
pplaf.require'weapons/weapons'
pplaf.require'weapons/options'
pplaf.require'bullets/bullets'
pplaf.require'bullets/options'
pplaf.require'triggers/triggers'
pplaf.require'triggers/switches'
--pplaf.require''

pewpew.set_level_size(LEVEL_WIDTH, LEVEL_HEIGTH)

function chance(c)
	return pplaf.math.random(1, 100) < c
end

function new_string(x, y, text)
	local id = pewpew.new_customizable_entity(x, y)
	pewpew.customizable_entity_set_string(id, text)
	return id
end

function is_alive(id)
	return pewpew.entity_get_is_alive(id) and not pewpew.entity_get_is_started_to_be_destroyed(id)
end

function stop_game()
	GAME_STATE = false
	pewpew.stop_game()
end

function table.copy(arr)
	local copy = {}
	for key, value in pairs(arr) do copy[key] = value end
	return copy
end
