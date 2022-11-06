
pplaf.player = {
	
	move_ang = 0fx,
	move_a = 0fx,
	shoot_ang = 0fx,
	shoot_a = 0fx,
	
	create = function(x, y, args)
		local id = pewpew.new_player_ship(x, y, 0)
		local player = {
										id = id,
										type = pplaf.entity.type.pewpew_player
										}
		player.weapons = pplaf.weapon.create(player, 'pewpew_player')
		if pplaf.entity.type.pewpew_player.constructor then
			pplaf.entity.type.pewpew_player.constructor(player, args)
		end
		if pplaf.entity.type.pewpew_player.destructor then
			function player:destroy()
				pplaf.entity.type.pewpew_player.destructor(self)
				pplaf.entities[self.union][self.id] = nil
			end
		end
		pplaf.entities.player[id] = player
		return player
	end,
	
	main = function()
		pplaf.player.move_ang, pplaf.player.move_a, pplaf.player.shoot_ang, pplaf.player.shoot_a = pewpew.get_player_inputs(0)
	end
	
}
