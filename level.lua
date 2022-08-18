
require'/dynamic/pplaf/pplaf.lua'

player.create(START_POS_X, START_POS_Y)
entity.create(START_POS_X, START_POS_Y, 'p2')

new_string(1000fx, 900fx, 'Use shooting joystick to control second player')
new_string(1000fx, 1200fx, 'Add bot, following second player')
new_string(1000fx, 1400fx, 'Configure dynamic heigth')
new_string(1000fx, 1600fx, 'Configure type of counted entities')

local s1 = switch.create({930fx, 1100fx, 980fx, 1150fx}, {1020fx, 1100fx, 1070fx, 1150fx})
local s2 = switch.create({930fx, 1300fx, 980fx, 1350fx}, {1020fx, 1300fx, 1070fx, 1350fx})
local s3 = switch.create({930fx, 1500fx, 980fx, 1550fx}, {1020fx, 1500fx, 1070fx, 1550fx})

pewpew.configure_player_hud(0, {top_left_line = "0.8 Changes: "})

local t, m

pewpew.add_update_callback(function()
	if GAME_STATE then
		
		pplaf.main()
		
		t, m = switch.get(s1)
		if t then
			entity.create(1000fx, 1400fx, '_ai')
		end
		
		t, m = switch.get(s2)
		if t then
			camera.configure({dynamic_heigth = not m})
		end
		
		t, m = switch.get(s3)
		if t then
			camera.configure({count_custom = not m})
		end
		
	end
end)
