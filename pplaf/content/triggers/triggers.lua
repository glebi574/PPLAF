
local triggers = {}

trigger = {
	
	create = function(args, mesh)
		local id, x, y, s
		if #args == 4 then --x1, y1, x2, y2
			x = (args[3] - args[1]) / 2fx
			y = (args[4] - args[2]) / 2fx
			id = pewpew.new_customizable_entity(x + args[1], y + args[2])
			if mesh then s = "rectangle" end
		elseif #args == 3 then --x, y, r
			x, y = args[3], args[3]
			id = pewpew.new_customizable_entity(args[1], args[2])
			if mesh then s = "circle" end
		else
			error("pplaf.trigger.create - wrong imput")
		end
		triggers[id] = args
		if mesh then
			pewpew.customizable_entity_set_mesh(id, pplaf.path .. "triggers/mesh." .. s .. ".lua", 0)
			pewpew.customizable_entity_start_spawning(id, 0)
			pewpew.customizable_entity_set_mesh_xyz_scale(id, x / 100fx, y / 100fx, 1fx)
		end
		return id
	end,
	
	get = function(id)
		local k
		for pid, info in pairs(entities.player) do
			if info.player then
				local x, y = pewpew.entity_get_position(pid)
				if #triggers[id] == 4 then
					k = x >= triggers[id][1] and x <= triggers[id][3] and y >= triggers[id][2] and y <= triggers[id][4]
				else
					k = fxmath.length(triggers[id][1], triggers[id][2], x, y) <= triggers[id][3]
				end
				if k then return true end
			end
		end
	end,
	
	remove = function(id)
		pewpew.customizable_entity_start_exploding(id, 40)
		triggers[id] = nil
	end
	
}
