
require("/dynamic/pplaf/functions.lua")
	
	player_ships = {
		
	}
	
	player = {
		
		types = {
			player = 1,
			    ai = 2
		},
		
		methods = {
			  main = 1,
			custom = 2
		},
		
		create = function(x, y, type, method)
			type = type or player.types.player
			method = method or player.methods.main
			local id
			if method == player.methods.main then
				id = pewpew.new_player_ship(x, y, 0)
			else
				id = pewpew.new_customizable_entity(x, y)
			end
			table.insert(player_ships, {	
											id = id,
										  type = type,
										method = method
										})
			return id
		end,
		
		camera = {
			
			properties = {
							  x = START_POS_X,
							  y = START_POS_Y,
						  speed = 1fx,
					   x_offset = 0fx,
					   y_offset = 0fx,
					   x_static = false,
					   y_static = false,
				shooting_offset = false,
					do_count_ai = false,
				do_count_custom = true
			},
			
			main = function()
				local mx, my, cdx, cdy, n = 0fx, 0fx, 0fx, 0fx, 0fx
				for _, p in ipairs(player_ships) do
					if 	(p.method == player.methods.main or
						(player.properties.camera.do_count_custom and p.method == player.methods.custom))
					and	(p.type == player.types.player or
						(player.camera.properties.do_count_ai and p.type == player.types.ai))
					then
						local px, py = pewpew.entity_get_position(p.id)
						mx = mx + px
						my = my + py
						n = n + 1fx
					end
				end
				mx = mx / n
				my = my / n
				
				if player.camera.properties.shooting_offset then
					local _, _, ang, a = pewpew.get_player_inputs(0)
					cdy, cdx = fmath.sincos(ang)
					cdx = cdx * a * player.camera.properties.shooting_offset
					cdy = cdy * a * player.camera.properties.shooting_offset
				end
				
				cdx = player.camera.properties.x_static or mx + player.camera.properties.x_offset + cdx
				cdy = player.camera.properties.y_static or my + player.camera.properties.y_offset + cdy
				
				player.camera.properties.x = player.camera.properties.x + (cdx - player.camera.properties.x)
											 * player.camera.properties.speed / 10fx 
				player.camera.properties.y = player.camera.properties.y + (cdy - player.camera.properties.y)
											 * player.camera.properties.speed / 10fx 
				
				pewpew.configure_player(0, {camera_x_override = player.camera.properties.x,
											camera_y_override = player.camera.properties.y})
			end
			
		},
		
		main = function()
			player.camera.main()
		end
		
	}
	