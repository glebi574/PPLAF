
pplaf.wall = {

	set_mesh_path = function(path)
		pplaf.wall.path = path
	end,
	
	create = function(x1, y1, x2, y2, mesh_path)
		local mesh_id = pewpew.new_customizable_entity(x1, y1)
		pewpew.customizable_entity_set_mesh(mesh_id, mesh_path, 0)
		pewpew.customizable_entity_set_mesh_angle(mesh_id, fmath.atan2(y2 - y1, x2 - x1), 0fx, 0fx, 1fx)
		pewpew.customizable_entity_set_mesh_xyz_scale(mesh_id, pplaf.fxmath.length(x1, y1, x2, y2), 1fx, 1fx)
		wall_id = pewpew.add_wall(x1, y1, x2, y2)
		local wall = {wall_id = wall_id, mesh_id = mesh_id}
		function wall:destroy()
			pewpew.remove_wall(self.wall_id)
			pewpew.customizable_entity_start_exploding(self.mesh_id, 40)
			self = nil
		end
		return wall
	end
	
}
