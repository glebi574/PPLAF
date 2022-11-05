
pplaf.player = {
	
	move_ang = 0fx,
	move_a = 0fx,
	shoot_ang = 0fx,
	shoot_a = 0fx,
	
	create = function(x, y)
		local id = pewpew.new_player_ship(x, y, 0)
		pplaf.entities.player[id] = {
			type = 'pewpew_player',
			union = 'player',
		  weapons = pplaf.weapon.create'pewpew_player_gun'
		}
		if pplaf.entity.type.pewpew_player.constructor then
			pplaf.entity.type.pewpew_player.constructor(entity, args)
		end
		if pplaf.entity.type.pewpew_player.destructor then
			function entity:destroy()
				pplaf.entity.type.pewpew_player.destructor(self)
				pplaf.entities[self.union][self.id] = nil
			end
		end
		return pplaf.entities.player[id]
	end,
	
	main = function()
		player.move_ang, player.move_a, player.shoot_ang, player.shoot_a = pewpew.get_player_inputs(0)
	end
	
}
