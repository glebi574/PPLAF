
bullets = {player = {}, enemy = {}}

bullet = {
	
	meshes = pplaf.path .. 'bullets/meshes/',
	
	create = function(x, y, ang, preset)
		local id = pewpew.new_entity(x, y)
		pewpew.set_mesh(id, bullet.presets[preset].mesh[1], bullet.presets[preset].mesh[2])
		pewpew.start_spawning(id, 0)
		pewpew.set_angle(id, ang, 0fx, 0fx, 1fx)
		pewpew.skip_interpolation(id)
		pewpew.interpolation(id, true)
		local param = {}
		param.preset = preset
		;(bullet.constructor[bullet.presets[preset].constructor] or NULL_FUNCTION)(id, param, ang)
		bullets[bullet.presets[preset].team and 'player' or 'enemy'][id] = param
		return id
	end,
	
	remove = function(id)
		bullets.player[id] = nil
		bullets.enemy[id] = nil
	end,
	
	main = function()
		for id, info in pairs(bullets.player) do
			bullet.ai[bullet.presets[info.preset].ai](id, info)
		end
		for id, info in pairs(bullets.enemy) do
			bullet.ai[bullet.presets[info.preset].ai](id, info)
		end
	end
	
}
