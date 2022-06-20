
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
											  v = args
									   })
				pewpew.customizable_entity_set_mesh(id, "/dynamic/pplaf/triggers/meshes/rectangle.lua", 0)
			elseif #args == 3 then --x0, y0, r
				sx, sy = args[3], args[3]
				id = pewpew.new_customizable_entity(args[1], args[2])
				table.insert(triggers, {
										     id = id,
											  v = args
									   })
				pewpew.customizable_entity_set_mesh(id, "/dynamic/pplaf/triggers/meshes/circle.lua", 0)
			else
				error("trigger.create - wrong imput")
			end
			pewpew.customizable_entity_start_spawning(id, 0)
			pewpew.customizable_entity_set_mesh_xyz_scale(id, sx / 100fx, sy / 100fx, 1fx)
			return id
		end,
		
		find = function(id)
			if is_alive(id) then
				for i, t in ipairs(triggers) do
					if t.id == id then return i end
				end
			end
			return false
		end,
		
		get = function(id)
			local i = trigger.find(id)
			local k = false
			if i then
				for _, p in ipairs(player_ships) do
					local px, py = pewpew.entity_get_position(p.id)
					if 		#triggers[i].v == 4 then
						k = px >= triggers[i].v[1] and px <= triggers[i].v[3] and py >= triggers[i].v[2] and py <= triggers[i].v[4]
					elseif 	#triggers[i].v == 3 then
						k = fxmath.lenght(triggers[i].v[1], triggers[i].v[2], px, py) <= triggers[i].v[3]
					end
					if k then return true end
				end
			end
			return k
		end,
		
		remove = function(id)
			local i = trigger.find(id)
			if i then
				table.remove(triggers, i)
				pewpew.customizable_entity_start_exploding(id, 40)
			end
		end
		
	}
	