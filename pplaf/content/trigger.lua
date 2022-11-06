
pplaf.triggers = {}

pplaf.trigger = {

	G = 0,

	create = function(param, meshes)
		pplaf.trigger.G = pplaf.trigger.G + 1
		local trigger = {param = param}
		local x, y, mesh
		if #param == 4 then -- x1, y1, x2, y2
			x = (param[3] - param[1]) / 2fx
			y = (param[4] - param[2]) / 2fx
			trigger.id = pewpew.new_customizable_entity(x + param[1], y + param[2])
			function trigger:get(x, y)
				return x >= self.param[1] and x <= self.param[3] and y >= self.param[2] and y <= self.param[4]
			end
			mesh = 'rectangle'
		elseif #param == 3 then -- x, y, r
			x, y = param[3], param[3]
			trigger.id = pewpew.new_customizable_entity(param[1], param[2])
			function trigger:get(x, y)
				return pplaf.fxmath.length(x, y, self.param[1], self.param[2]) <= self.param[3]
			end
			mesh = 'circle'
		end
		if mesh_path then
			pewpew.customizable_entity_set_mesh(trigger.id, meshes .. mesh .. '.lua', 0)
			pewpew.customizable_entity_start_spawning(trigger.id, 0)
			pewpew.customizable_entity_set_mesh_xyz_scale(trigger.id, x / 100fx, y / 100fx, z)
		end
		function trigger:destroy()
			pewpew.customizable_entity_start_exploding(self.id, 40)
			self = nil
		end
		pplaf.triggers[pplaf.trigger.G] = trigger
		return trigger
	end
	
}
