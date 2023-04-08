
_G = nil
_ENV.pewpew_old = nil
_ENV.fmath_old = nil

pplaf = {

	require = function(path, ...) --load ... files from certain folder
		if not path then path = pplaf.path end
		for _, lib in ipairs({...}) do
			require(path .. lib .. ".lua")
		end
	end,

	main = function() --main callback
		TIME = TIME + 1
		pplaf.entity.main()
		pplaf.player.main()
		pplaf.camera.main()
		pplaf.animation.main()
	end,
	
	init = function(path) --load pplaf
		pplaf.path = path
		pplaf.content = path .. 'content/'
		pplaf.require(nil,
			'settings',
			'global_variables'
		)
		pplaf.require(pplaf.content,
			'math',
			'fxmath',
			'camera',
			'entity/main',
			'entity/player',
			'weapon/main',
			'trigger',
			'switch',
			'wall',
			'animation'
		)
		pewpew.set_level_size(LEVEL_WIDTH, LEVEL_HEIGTH)
	end

}

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

function table.copy(arr) --copy table by value
	local copy = {}
	for key, value in pairs(arr) do copy[key] = value end
	return copy
end
