	
require("/dynamic/pplaf/functions.lua")
	
	local walls = {}
	
	wall = {
		
		create = function(x1, y1, x2, y2)
			local id = pewpew.new_customizable_entity(x1, y1)
			pewpew.customizable_entity_set_mesh(id, "/dynamic/pplaf/walls/mesh.lua", 0)
			pewpew.customizable_entity_set_mesh_angle(id, fmath.atan2(y2 - y1, x2 - x1), 0fx, 0fx, 1fx)
			pewpew.customizable_entity_set_mesh_scale(id, fxmath.lenght(x1, y1, x2, y2) / 100fx)
			w_id = pewpew.add_wall(x1, y1, x2, y2)
			table.insert(walls, {
								  id = id,
								w_id = w_id
								})
			return id
		end,
		
		find = function(id)
			for i, w in ipairs(walls) do
				if w.id == id then return i end
			end
			return false
		end,
		
		remove = function(id)
			local b = wall.find(id)
			if b then
				pewpew.remove_wall(walls[b].w_id)
				table.remove(walls, b)
				pewpew.customizable_entity_start_exploding(id, 40)
			end
		end
		
	}
	