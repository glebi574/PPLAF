
local walls = {}

wall = {
	
	create = function(x1, y1, x2, y2)
		local id = pewpew.new_entity(x1, y1)
		pewpew.set_mesh(id, pplaf.path .. "walls/mesh.lua", 0)
		pewpew.set_angle(id, fmath.atan2(y2 - y1, x2 - x1), 0fx, 0fx, 1fx)
		pewpew.set_scale(id, fxmath.length(x1, y1, x2, y2) / 100fx)
		w_id = pewpew.add_wall(x1, y1, x2, y2)
		table.insert(walls, {
			m_id = id,
			w_id = w_id
		})
		return id
	end,
	
	find = function(id)
		for i, w in ipairs(walls) do
			if w.m_id == id then return i end
		end
	end,
	
	remove = function(id)
		local i = wall.find(id)
		pewpew.remove_wall(walls[i].w_id)
		table.remove(walls, i)
		pewpew.customizable_entity_start_exploding(id, 40)
	end
	
}
