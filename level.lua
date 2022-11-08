
require'/dynamic/pplaf/pplaf.lua'

local player = pplaf.player.create(START_POS_X, START_POS_Y)

new_string(1000fx, 1200fx, 'Configure dynamic heigth')

local s1 = pplaf.switch.create({{930fx, 1100fx, 980fx, 1150fx}, {1020fx, 1100fx, 1070fx, 1150fx}}, '/dynamic/assets/trigger_meshes/')

pewpew.configure_player_hud(0, {top_left_line = "0.8 Changes: switches with any amount of triggers, redesigned types system."})

local t

pewpew.add_update_callback(function()
	if GAME_STATE then
		
		pplaf.main()
		
		t = s1:get(pewpew.entity_get_position(player.id))
		if t then
			pplaf.camera.configure({dynamic_heigth = not pplaf.camera.options.dynamic_heigth})
		end
		
	end
end)
