
require"/dynamic/pplaf/player.lua"
	
	camera = {
		
		options = {
					  x = START_POS_X,
					  y = START_POS_Y,
				  speed = 0.342fx,
			   x_offset = 0fx,
			   y_offset = 0fx,
			   x_static = nil,
			   y_static = nil,
		shooting_offset = nil,
			  free_mode = nil
		},
		
		configure = function(args)
			for i, f in pairs(args) do
				camera.options[i] = f
			end
		end,
		
		main = function()
			if camera.options.free_mode then
				local ang, a = pewpew.get_player_inputs(0)
				local cdy, cdx = fmath.sincos(ang)
				camera.options.x = camera.options.x + cdx * a * camera.options.speed
				camera.options.y = camera.options.y + cdy * a * camera.options.speed
			else
				local mx, my, cdx, cdy, n = 0fx, 0fx, 0fx, 0fx, 0fx
				for _, p in ipairs(players) do
					local px, py = pewpew.entity_get_position(p.id)
					mx = mx + px
					my = my + py
					n = n + 1fx
				end
				if camera.options.shooting_offset then
					local _, _, ang, a = pewpew.get_player_inputs(0)
					cdy, cdx = fmath.sincos(ang)
					cdx = cdx * a * camera.options.shooting_offset
					cdy = cdy * a * camera.options.shooting_offset
				end
				camera.options.x = camera.options.x +
				((camera.options.x_static or mx / n + camera.options.x_offset + cdx) - camera.options.x) * camera.options.speed
				camera.options.y = camera.options.y +
				((camera.options.y_static or my / n + camera.options.y_offset + cdy) - camera.options.y) * camera.options.speed
			end
			pewpew.configure_player(0, {camera_x_override = camera.options.x,
										camera_y_override = camera.options.y})
		end
		
	}
	