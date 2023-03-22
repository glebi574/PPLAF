
pplaf.camera = {
	
	options = {},
	
	main = function()
		local x, y, dx, dy, n, d = 0fx, 0fx, 0fx, 0fx, 0fx, -BIG_NUMBER_FX
		for id in pairs(pplaf.entities.player) do
			local px, py = pewpew.entity_get_position(id)
			x = x + px
			y = y + py
			n = n + 1fx
		end
		if n == 0fx then --no entities which camera can follow
			dy, dx = fmath.sincos(pplaf.player.move_ang)
			local v = pplaf.player.move_a * pplaf.camera.options.speed
			pplaf.camera.options.x = pplaf.camera.options.x + dx * v
			pplaf.camera.options.y = pplaf.camera.options.y + dy * v
			pplaf.camera.options.heigth = pplaf.camera.options.heigth * 0.3891fx
		else
			x = x / n
			y = y / n
			if pplaf.camera.options.shooting_offset then
				dy, dx = fmath.sincos(pplaf.player.shoot_ang)
				local v = pplaf.player.shoot_a * pplaf.camera.options.shooting_offset
				dx = dx * v
				dy = dy * v
			end
			if pplaf.camera.options.dynamic_heigth then
				for id in pairs(pplaf.entities.player) do
					local px, py = pewpew.entity_get_position(id)
					local l = pplaf.fxmath.length(px, py, x, y)
					if l > d then d = l end
				end
				pplaf.camera.options.heigth = 0.3951fx * pplaf.camera.options.heigth - 0.320fx * d
			end
			pplaf.camera.options.x = pplaf.camera.options.x +
				((pplaf.camera.options.x_static or x + pplaf.camera.options.x_offset + dx) - pplaf.camera.options.x) * pplaf.camera.options.speed
			pplaf.camera.options.y = pplaf.camera.options.y +
				((pplaf.camera.options.y_static or y + pplaf.camera.options.y_offset + dy) - pplaf.camera.options.y) * pplaf.camera.options.speed
		end
		pewpew.configure_player(0, {camera_x_override = pplaf.camera.options.x,
																camera_y_override = pplaf.camera.options.y,
																  camera_distance = pplaf.camera.options.heigth})
	end,
	
	configure = function(args) --change camera options
		for i, f in pairs(args) do
			pplaf.camera.options[i] = f
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
