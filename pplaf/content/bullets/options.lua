
--[[
	
	options:
		mesh - {path, index}
		team - true or false(nil) / player or enemy
		ai - string with function(bullet id, bullet parametres) in bullet.ai, called every tick for this bullet
		constructor - nil or string with function(bullet id, bullet parametres) in bullet.constructor, called when bullet is created
		destructor - nil or string with function(bullet id, bullet parametres) in bullet.destructor, called when bullet is destroyed
	
]]--

bullet.presets = {
	
	player = { --used by `player.lua`
		mesh = {bullet.meshes .. 'player.lua', 0},
		team = true,
		ai = 'player',
		speed = 24fx,
		damage = 10,
		constructor = 'player',
		destructor = 'player'
	}
	
}

bullet.constructor = {
	
	player = function(id, info, ang)
		pewpew.wall_collision(id, true, function(id) return bullet.remove(id) end)
		local dy, dx = fmath.sincos(ang)
		info.dx = dx * bullet.presets.player.speed
		info.dy = dy * bullet.presets.player.speed
		info.time = 100
	end
	
}

bullet.destructor = {

	player = function(id, info)
		local x, y = pewpew.entity_get_position(id)
		pewpew.create_explosion(x, y, 0x66ff6699, 0.1024fx, 7)
		pewpew.entity_destroy(id)
	end

}

bullet.ai = {
	
	player = function(id, info)
		local x, y = pewpew.entity_get_position(id)
		pewpew.entity_set_position(id, x + info.dx, y + info.dy)
		info.time = info.time - 1
		if info.time == 0 then bullet.remove(id) end
	end
	
}
