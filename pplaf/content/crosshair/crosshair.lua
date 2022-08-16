--don't
crosshair = {
	
	  id = pewpew.new_entity(START_POS_X, START_POS_Y),
	temp = 0fx,
	
	main = function()
		if crosshair.temp ~= player.shoot_a then
			pewpew.set_color(crosshair.id, player.s == 0fx and 0x00000000 or 0xff333399)
			crosshair.temp = player.shoot_a
		end
		if player.shoot_a ~= 0fx then
			local dy, dx = fmath.sincos(player.shoot_ang)
			local v = camera.options.heigth * player.shoot_a * -0.2000fx
			pewpew.entity_set_position(crosshair.id, camera.options.x + v * dx, camera.options.y + v * dy)
		end
	end
	
}

pewpew.interpolation(crosshair.id, true)
pewpew.set_mesh(crosshair.id, pplaf.path .. "crosshair/mesh.lua", 0)