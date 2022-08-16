
--[[
	
	options:
		mesh - {path, index}
		team - true or false(nil) / player or enemy
		ai - string with function(entity id, entity parametres) in bullet.ai, called every tick for this entity
		constructor - nil or string with function(entity id, entity parametres) in bullet.constructor, called when entity is created
	
]]--

bullet.presets = {
	
	player = { --used by `player.lua`
		mesh = {bullet.meshes .. 'player.lua', 0},
		team = true,
		ai = 'player',
		speed = 24fx,
		damage = 10,
		constructor = 'player'
	}
	
}

bullet.constructor = {
	
	player = function(id, info, ang)
		local dy, dx = fmath.sincos(ang)
		info.dx = dx * bullet.presets.player.speed
		info.dy = dy * bullet.presets.player.speed
		info.time = 100
	end
	
}

bullet.ai = {
	
	player = function(id, info)
		local x, y = pewpew.entity_get_position(id)
		pewpew.entity_set_position(id, x + info.dx, y + info.dy)
		info.time = info.time - 1
		if info.time == 0 then
			bullet.remove(id)
			pewpew.entity_destroy(id)
		end
	end
	
}
