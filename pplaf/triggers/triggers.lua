
require("/dynamic/pplaf/player.lua")

	local triggers = {
		
	}
	
	trigger = {
		
		create = function(...)
			local args = {...}
			local id, sx, sy
			if #args == 4 then --x1, y1, x2, y2
				sx = (args[3] - args[1]) / 2fx
				sy = (args[4] - args[2]) / 2fx
				id = pewpew.new_customizable_entity(sx + args[1], sy + args[2])
				table.insert(triggers, {
											 id = id,
										  state = false,
											  v = args
									   })
				pewpew.customizable_entity_set_mesh(id, "/dynamic/pplaf/triggers/meshes/rectangle.lua", 0)
			elseif #args == 3 then --x0, y0, r
				sx, sy = args[3], args[3]
				id = pewpew.new_customizable_entity(args[1], args[2])
				table.insert(triggers, {
										     id = id,
										  state = false,
											  v = args
									   })
				pewpew.customizable_entity_set_mesh(id, "/dynamic/pplaf/triggers/meshes/circle.lua", 0)
			end
			pewpew.customizable_entity_start_spawning(id, 0)
			pewpew.customizable_entity_set_mesh_xyz_scale(id, sx / 100fx, sy / 100fx, 1fx)
			return id
		end,
		
		find = function(id)
			if pewpew.entity_get_is_alive(id) and not pewpew.entity_get_is_started_to_be_destroyed(id) then
				for i, t in ipairs(triggers) do
					if t.id == id then return i end
				end
			end
			return false
		end,
		
		get_state = function(id)
			local b = trigger.find(id)
			if b then return triggers[b].state end
			return false
		end,
		
		remove = function(id)
			local b = trigger.find(id)
			if b then
				table.remove(triggers, b)
				pewpew.customizable_entity_start_exploding(id, 40)
			end
		end,
		
		update = function()
			for _, p in ipairs(player_ships) do
				local px, py = pewpew.entity_get_position(p.id)
				for _, t in ipairs(triggers) do
					if #t.v == 4 then
						t.state = (px >= t.v[1] and px <= t.v[3] and py >= t.v[2] and py <= t.v[4])
					else
						t.state = (fxmath.lenght(t.v[1], t.v[2], px, py) <= t.v[3])
					end
				end
			end
		end
		
	}
	