
require"/dynamic/pplaf/functions.lua"
	
	players = {}
	
	player = {
		
		speed = 10fx,
		
		create = function(x, y)
			local id = pewpew.new_player_ship(x, y, 0)
			pewpew.set_player_ship_speed(id, 1fx, player.speed - 10fx, -1)
			table.insert(players, {
						  id = id,
				transparency = false
			})
			return id
		end,
		
		change_speed = function(s)
			player.speed = s
			for _, p in ipairs(players) do
				pewpew.set_player_ship_speed(p.id, 1fx, s - 10fx, -1)
			end
		end
		
	}
	