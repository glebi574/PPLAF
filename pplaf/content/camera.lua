
camera = {
	
	options = {},
	
	mode = {
		usual = function()
			local x, y, dx, dy, n, d = 0fx, 0fx, 0fx, 0fx, 0fx, -BIG_FX
			for id, info in pairs(entities.player) do
				if camera.options.count_custom or info.player then
					local px, py = pewpew.entity_get_position(id)
					x = x + px
					y = y + py
					n = n + 1fx
				end
			end
			if n == 0fx then pewpew.print('pplaf.camera.main() - bruh') end
			x = x / n
			y = y / n
			if camera.options.shooting_offset then
				dy, dx = fmath.sincos(player.shoot_ang)
				local v = player.shoot_a * camera.options.shooting_offset
				dx = dx * v
				dy = dy * v
			end
			if camera.options.dynamic_heigth then
				for id, info in pairs(entities.player) do
					if camera.options.count_custom or info.player then
						local px, py = pewpew.entity_get_position(id)
						local l = fxmath.length(px, py, x, y)
						if l > d then d = l end
					end
				end
				camera.options.heigth = 0.3951fx * camera.options.heigth - 0.320fx * d
			end
			camera.options.x = camera.options.x +
			((camera.options.x_static or x + camera.options.x_offset + dx) - camera.options.x) * camera.options.speed
			camera.options.y = camera.options.y +
			((camera.options.y_static or y + camera.options.y_offset + dy) - camera.options.y) * camera.options.speed
		end,
		free = function()
			local dy, dx = fmath.sincos(player.move_ang)
			local v = player.move_a * camera.options.speed
			camera.options.x = camera.options.x + dx * v
			camera.options.y = camera.options.y + dy * v
			camera.options.heigth = camera.options.heigth * 0.3891fx
		end
	},
	
	configure = function(args)
		for i, f in pairs(args) do
			camera.options[i] = f
		end
		camera.move = args.free_mode and camera.mode.free or camera.mode.usual
	end,
	
	main = function()
		camera.move()
		pewpew.configure_player(0, {camera_x_override = camera.options.x,
									camera_y_override = camera.options.y,
									  camera_distance = camera.options.heigth})
	end
	
}

camera.configure({
				  x = START_POS_X,
				  y = START_POS_Y,
			  speed = 0.342fx,
		   x_offset = 0fx,
		   y_offset = 0fx,
		   x_static = nil,
		   y_static = nil,
	shooting_offset = nil,
		  free_mode = nil,
	 dynamic_heigth = true,
			 heigth = 0fx,
	   count_custom = true
	})

--[[
Notes:
	get average position
	shooting offset:
		-get player inputs
		-ang, a -> x and y offset
	dynamic heigth:
		-get biggest distance between entities(commit vector magic)
		-change camera's heigth
			-different values for different sizes, 70fx of screen for -100fx of heigth(for approximatly 980 * 1000 screen)
			-> heigth = -1.1756fx * distance
			-make movement smooth
				-current heigth plus difference between current heigth and needed heigth multiplied by smol value
				-> heigth = heigth + (heigth - 1.1700fx(2.3500fx) * distance) * value, value = 0.05?
	change average position:
		-additional offsets(may be helpful for cinematic scenes?)
		-option to make axis static
		-make movement smooth(everything can be counted in one formula)
	free mode:
		-return camera's heigth to 0?
		-no smooth movement, just ability to move camera without players(should speed be changed automatically?)
]]--
