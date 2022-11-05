
pplaf.camera = {
	
	options = {},
	
	main = function()
		local x, y, dx, dy, n, d = 0fx, 0fx, 0fx, 0fx, 0fx, -BIG_FX
		local options = pplaf.camera.options
		for id in pairs(pplaf.entities.player) do
			local px, py = pewpew.entity_get_position(id)
			x = x + px
			y = y + py
			n = n + 1fx
		end
		if n == 0fx then
			dy, dx = fmath.sincos(pplaf.player.move_ang)
			local v = pplaf.player.move_a * options.speed
			options.x = options.x + dx * v
			options.y = options.y + dy * v
			options.heigth = options.heigth * 0.3891fx
		else
			x = x / n
			y = y / n
			if options.shooting_offset then
				dy, dx = fmath.sincos(pplaf.player.shoot_ang)
				local v = pplaf.player.shoot_a * options.shooting_offset
				dx = dx * v
				dy = dy * v
			end
			if options.dynamic_heigth then
				for id in pairs(pplaf.entities.player) do
					local px, py = pewpew.entity_get_position(id)
					local l = pplaf.fxmath.length(px, py, x, y)
					if l > d then d = l end
				end
				options.heigth = 0.3951fx * options.heigth - 0.320fx * d
			end
			options.x = options.x + ((options.x_static or x + options.x_offset + dx) - options.x) * options.speed
			options.y = options.y + ((options.y_static or y + options.y_offset + dy) - options.y) * options.speed
		end
		pewpew.configure_player(0, {camera_x_override = options.x,
																camera_y_override = options.y,
																  camera_distance = options.heigth})
	end,
	
	configure = function(args)
		for i, f in pairs(args) do
			options[i] = f
		end
	end
	
}

pplaf.camera.configure{
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
					 heigth = 0fx
}

--[[ 0.7.2
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
