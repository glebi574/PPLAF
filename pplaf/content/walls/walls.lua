
local walls = {}

wall = {

	G = 0,

	mesh = pplaf.path .. 'walls/mesh.lua',
	
	create = function(x1, y1, x2, y2)
		wall.G = wall.G + 1
		local mesh_id = pewpew.new_entity(x1, y1)
		pewpew.set_mesh(mesh_id, wall.mesh, 0)
		pewpew.set_angle(mesh_id, fmath.atan2(y2 - y1, x2 - x1), 0fx, 0fx, 1fx)
		pewpew.set_xyz_scale(mesh_id, fxmath.length(x1, y1, x2, y2) / 100fx, 1fx, 1fx)
		wall_id = pewpew.add_wall(x1, y1, x2, y2)
		walls[wall.G] = {
			wall_id = wall_id,
			mesh_id = mesh_id
		}
		return wall.G
	end,
	
	remove = function(index)
		pewpew.remove_wall(walls[index].wall_id)
		pewpew.customizable_entity_start_exploding(walls[index].mesh_id, 40)
		walls[index] = nil
	end
	
}
