
pplaf.entities = {player = {}, enemy = {}, player_bullets = {}, enemy_bullets = {}}

pplaf.entity = {

	type = {},

	add_union = function(union)
		pplaf.entities[union] = {}
	end,

	create = function(x, y, type, ...)
		local id = pewpew.new_customizable_entity(x, y)
		pewpew.customizable_entity_set_position_interpolation(id, true)
		pewpew.customizable_entity_configure_wall_collision(id, true)
		pewpew.customizable_entity_set_mesh(id, pplaf.entity.type[type].path .. '/mesh/normal.lua', 0)
		local entity = 	{
										 id = id,
									 type = pplaf.entity.type[type]
										}
		if entity.type.weapons then
			entity.weapons = pplaf.weapon.create(entity, type)
		end
		--[[if entity.type.animation then
			entity.animation = {
				frame = 1,
				timer = 1
			}
		end]]--
		if entity.type.constructor then
			entity.type.constructor(entity, ...)
		end
		if entity.type.destructor then
			function entity:destroy()
				entity.type.destructor(self)
				pplaf.entities[self.type.union][self.id] = nil
			end
		end
		pplaf.entities[entity.type.union][id] = entity
		return entity
	end,
	
	main = function()
		for _, union in pairs(pplaf.entities) do
			for _, entity in pairs(union) do
				if entity.type.ai then
					entity.type.ai(entity)
					--[[
					if entity.type.animation then
						entity.animation.timer = entity.animation.timer + 1
						if entity.animation.timer == entity.type.animation.frequency then
							entity.animation.timer = 1
							entity.animation.frame = entity.animation.frame + 1
						end
						if entity.animation.frame == entity.type.animation.frames then
							entity.animation.frame = 1
						end
						pewpew.customizable_entity_set_mesh(entity.id, entity.path .. '/mesh/normal.lua', entity.animation.frame - 1)
					end]]--
				end
				if entity.weapons then
					for _, weapon in ipairs(entity.weapons) do
						weapon.type.ai(weapon)
					end
				end
			end
		end
	end,

	load = function(path, ...)
		for _, name in pairs({...}) do
			pplaf.entity.type[name] = require(path .. name .. '/type.lua')
			pplaf.entity.type[name].path = path .. name
		end
	end
	
}

pplaf.entity.load(pplaf.content .. 'entity/', 'pewpew_player', 'pewpew_player_bullet')
