
--[[
	
	options:
		ai - string with function(entity id, entity parametres) in weapons.ai, called every tick for this entity
		constructor - nil or string with function(entity id, entity parametres) in weapons.constructor, called when entity is created
	
]]--

weapons.presets = {
	
	player = { --special version for `player.lua`
		ai = 'player',
		recharge = 6
	}
	
}

weapons.constructor = {
	
	
	
}

weapons.ai = {
	
	player = function(id, info, weapon)
		if player.shoot_a ~= 0fx and weapon.recharge > 0 then
			weapon.recharge = weapon.recharge - 1
		end
		if weapon.recharge == 0 then
			local ang = player.shoot_ang + fxmath.random(-0.256fx, 0.256fx)
			local x, y = pewpew.entity_get_position(id)
			local bullet_id = bullet.create(x, y, ang, 'player')
			weapon.recharge = weapons.presets[weapon.preset].recharge
		end
	end
	
}

weapons.ai.player = NULL_FUNCTION
