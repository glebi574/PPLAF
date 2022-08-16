
player = {
	
	move_ang = 0fx,
	move_a = 0fx,
	shoot_ang = 0fx,
	shoot_a = 0fx,
	
	create = function(x, y)
		local id = pewpew.new_player_ship(x, y, 0)
		entities.player[id] = {
			preset = 'player',
		   weapons = {{preset = 'player', recharge = 10}},
			player = true
		}
		return id
	end,
	
	main = function()
		player.move_ang, player.move_a, player.shoot_ang, player.shoot_a = pewpew.get_player_inputs(0)
	end
	
}
