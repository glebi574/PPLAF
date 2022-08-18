
--[[
	
	options:
		mesh - nil or {path, index}
		team - true or false(nil) / player or enemy
		ai - string with function(entity id, entity parametres) in entity.ai, called every tick for this entity
		weapons - nil or array with weapons presets
		constructor - nil or string with function(entity id, entity parametres) in entity.constructor, called when entity is created
		destructor - nil or string with function(entity id, entity parametres) in entity.destructor, called when entity is destroyed
	
]]--

entity.presets = {
	
	player = { --special version for `player.lua`
		ai = 'player'
	},
	
	p2 = {
		mesh = {entity.meshes .. 'crystal.lua', 0},
		team = true,
		ai = 'p2'
	},
	
	_ai = {
		mesh = {entity.meshes .. 'crystal.lua', 0},
		team = true,
		ai = '_ai',
		constructor = '_ai',
		speed = 10fx
	}
	
}

entity.constructor = {
	
	_ai = function(id, info)
		info.to_x, info.to_y = pewpew.entity_get_position(id)
		info.ang = 0fx
		info.rotate = 0fx
		info.ang_per_tick = 0fx
		info.dx, info.dy = 0fx, 0fx
		info.duration = 100
	end
	
}

entity.destructor = {



}

entity.ai = {
	
	player = NULL_FUNCTION,
	
	p2 = function(id, info)
		local x, y = pewpew.entity_get_position(id)
		local dy, dx = fmath.sincos(player.shoot_ang)
		if player.shoot_a ~= 0fx then pewpew.set_angle(id, player.shoot_ang, 0fx, 0fx, 1fx) end
		local v = player.shoot_a * 10fx
		pewpew.entity_set_position(id, x + dx * v, y + dy * v)
	end,
	
	_ai = function(id, info)
		local x, y = pewpew.entity_get_position(id)
		if fxmath.length(x, y, info.to_x, info.to_y) < 10fx or info.duration == 0 then
			local tx, ty = pewpew.entity_get_position(2)
			local ang, a = fxmath.random(0fx, TAU_FX), fxmath.random(0fx, 500fx)
			local dy, dx = fmath.sincos(ang)
			info.to_x = tx + dx * a
			info.to_y = ty + dy * a
			ang = fmath.atan2(info.to_y - y, info.to_x - x)
			info.rotate = ang - info.ang
			if info.rotate < 0fx then info.rotate = TAU_FX + info.rotate end
			info.dy, info.dx = fmath.sincos(ang)
			info.dx, info.dy = info.dx * entity.presets._ai.speed, info.dy * entity.presets._ai.speed
			info.ang_per_tick = info.rotate / 40fx
			info.duration = 200
		end
		if info.rotate > 0fx then
			info.ang = info.ang + info.ang_per_tick
			if info.ang > TAU_FX then info.ang = info.ang - TAU_FX end
			info.rotate = info.rotate - info.ang_per_tick
			pewpew.set_angle(id, info.ang, 0fx, 0fx, 1fx)
		else
			pewpew.entity_set_position(id, x + info.dx, y + info.dy)
		end
		info.duration = info.duration - 1
	end
	
}
