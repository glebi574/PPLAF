
require"/dynamic/pplaf/player.lua"

	local triggers = {}
	
	trigger = {
		
		G = 0,
		
		create = function(args, mesh)
			local id, sx, sy, s
			trigger.G = trigger.G + 1
			if #args == 4 then --x1, y1, x2, y2
				sx = (args[3] - args[1]) / 2fx
				sy = (args[4] - args[2]) / 2fx
				if mesh then
					id = pewpew.new_customizable_entity(sx + args[1], sy + args[2])
					s = "rectangle"
				end
			elseif #args == 3 then --x, y, r
				sx, sy = args[3], args[3]
				if mesh then
					id = pewpew.new_customizable_entity(args[1], args[2])
					s = "circle"
				end
			else
				error("pplaf.trigger.create - wrong imput")
			end
			table.insert(triggers, {
				id = id,
				 i = trigger.G,
				 v = args
			})
			if mesh then
				pewpew.customizable_entity_set_mesh(id, "/dynamic/pplaf/triggers/mesh."..s..".lua", 0)
				pewpew.customizable_entity_start_spawning(id, 0)
				pewpew.customizable_entity_set_mesh_xyz_scale(id, sx / 100fx, sy / 100fx, 1fx)
			end
			return trigger.G
		end,
		
		find = function(index)
			for n, t in ipairs(triggers) do
				if t.i == index then return n end
			end
		end,
		
		get = function(index)
			local i = trigger.find(index)
			local k
			for _, p in ipairs(players) do
				local px, py = pewpew.entity_get_position(p.id)
				if #triggers[i].v == 4 then
					k = px >= triggers[i].v[1] and px <= triggers[i].v[3] and py >= triggers[i].v[2] and py <= triggers[i].v[4]
				else
					k = fxmath.lenght(triggers[i].v[1], triggers[i].v[2], px, py) <= triggers[i].v[3]
				end
				if k then return true end
			end
		end,
		
		remove = function(index)
			local i = trigger.find(index)
			if triggers[i].id then
				pewpew.customizable_entity_start_exploding(triggers[i].id, 40) end
			table.remove(triggers, i)
		end
		
	}
	