
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
		if pplaf.settings.copy_ppl_methods_to_entities then
			function entity:add_arrow_to_player_ship(ship_id, color)
				return pewpew.add_arrow_to_player_ship(ship_id, self.id, color)
			end
			function entity:get_position()
				return pewpew.entity_get_position(self.id)
			end
			function entity:set_position(x, y)
				return pewpew.entity_set_position(self.id, x, y)
			end
			function entity:get_is_alive()
				return pewpew.entity_get_is_alive(self.id)
			end
			function entity:get_is_started_to_be_destroyed()
				return pewpew.entity_get_is_started_to_be_destroyed(self.id)
			end
			function entity:set_radius(r)
				return pewpew.entity_set_radius(self.id, r)
			end
			function entity:set_update_callback(callback)
				return pewpew.entity_set_update_callback(self.id, callback)
			end
			function entity:destroy()
				return pewpew.entity_destroy(self.id)
			end
			function entity:set_position_interpolation(b)
				return pewpew.customizable_entity_set_position_interpolation(self.id, b)
			end
			function entity:set_mesh(path, index)
				return pewpew.customizable_entity_set_mesh(self.id, path, index)
			end
			function entity:set_mesh_xyz(x, y, z)
				return pewpew.customizable_entity_set_mesh_xyz(self.id, x, y, z)
			end
			function entity:set_mesh_z(z)
				return pewpew.customizable_entity_set_mesh_z(self.id, z)
			end
			function entity:skip_mesh_attributes_interpolation()
				return pewpew.customizable_entity_skip_mesh_attributes_interpolation(self.id)
			end
			function entity:set_flipping_meshes(path, i1, i2)
				return pewpew.customizable_entity_set_flipping_meshes(self.id, path, i1, i2)
			end
			function entity:set_mesh_color(color)
				return pewpew.customizable_entity_set_mesh_color(self.id, color)
			end
			function entity:set_string(str)
				return pewpew.customizable_entity_set_string(self.id, str)
			end
			function entity:set_mesh_scale(scale)
				return pewpew.customizable_entity_set_mesh_scale(self.id, scale)
			end
			function entity:set_mesh_xyz_scale(x, y, z)
				return pewpew.customizable_entity_set_mesh_xyz_scale(self.id, x, y, z)
			end
			function entity:set_mesh_angle(angle, vx, vy, vz)
				return pewpew.customizable_entity_set_mesh_angle(self.id, angle, vx, vy, vz)
			end
			function entity:add_rotation_to_mesh(angle, vx, vy, vz)
				return pewpew.customizable_entity_add_rotation_to_mesh(self.id, angle, vx, vy, vz)
			end
			function entity:configure_music_response(color1, color2, xs1, xs2, ys1, ys2, zs1, zs2)
				return pewpew.customizable_entity_configure_music_response(self.id, {color1, color2, xs1, xs2, ys1, ys2, zs1, zs2})
			end
			function entity:set_visibility_radius(r)
				return pewpew.customizable_entity_set_visibility_radius(self.id, r)
			end
			function entity:configure_wall_collision(collide_with_walls, collision_callback)
				return pewpew.customizable_entity_configure_wall_collision(self.id, collide_with_walls, collision_callback)
			end
			function entity:set_player_collision_callback(collision_callback)
				return pewpew.customizable_entity_set_player_collision_callback(self.id, collision_callback)
			end
			function entity:set_player_weapon_collision_callback(collision_callback)
				return pewpew.customizable_entity_set_player_weapon_collision_callback(self.id, collision_callback)
			end
			function entity:start_spawning(time)
				return pewpew.customizable_entity_start_spawning(self.id, time)
			end
			function entity:start_exploding(time)
				return pewpew.customizable_entity_start_exploding(self.id, time)
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
