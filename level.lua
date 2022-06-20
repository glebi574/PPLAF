
require("/dynamic/pplaf/h.lua")

local function stop_game()
	GAME_STATE = false
	pewpew.stop_game()
end
	
	pewpew.set_level_size(L_WIDTH, L_HEIGHT)
	player.create(START_POS_X, START_POS_Y)
	
	local t0 = create_text_line(500fx, 550fx, "Try to use joysticks")
	
	pewpew.configure_player_hud(0,
						{top_left_line = "Current version: 0.6 Changes: "})
	
	local s1 = switch.create({400fx, 600fx, 450fx, 650fx},{550fx, 600fx, 600fx, 650fx})
	local s2 = switch.create({400fx, 700fx, 450fx, 750fx},{550fx, 700fx, 600fx, 750fx})
	local s3 = switch.create({400fx, 800fx, 450fx, 850fx},{550fx, 800fx, 600fx, 850fx})
	local s4 = switch.create({400fx, 900fx, 450fx, 950fx},{550fx, 900fx, 600fx, 950fx})
	
	local t1 = create_text_line(500fx, 675fx, "Add shooting offset:")
	local t2 = create_text_line(500fx, 775fx, "Make X static:")
	local t3 = create_text_line(500fx, 875fx, "Make Y static:")
	local t4 = create_text_line(500fx, 975fx, "Make camera static:")
	
	local t, m
	
	function level_tick()
		if GAME_STATE then
			
			h.main()
			
			t, m = switch.get(s1)
			if t then
				player.camera.properties.shooting_offset = m and 50fx
			end
			
			t, m = switch.get(s2)
			if t then
				player.camera.properties.x_static = m and 500fx
			end
			
			t, m = switch.get(s3)
			if t then
				player.camera.properties.y_static = m and 1000fx
			end
			
			t, m = switch.get(s4)
			if t then
				player.camera.properties.x_static = m and 700fx
				player.camera.properties.y_static = m and 1000fx
			end
			
		end
	end

	pewpew.add_update_callback(level_tick)