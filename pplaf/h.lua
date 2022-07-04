
require"/dynamic/pplaf/__h.lua"
require"/dynamic/pplaf/global_variables.lua"
require"/dynamic/pplaf/math.lua"
require"/dynamic/pplaf/fxmath.lua"
require"/dynamic/pplaf/functions.lua"
require"/dynamic/pplaf/triggers/triggers.lua"
require"/dynamic/pplaf/switches.lua"
require"/dynamic/pplaf/player.lua"
require"/dynamic/pplaf/camera.lua"
require"/dynamic/pplaf/walls/walls.lua"
	
	pewpew.set_level_size(L_WIDTH, L_HEIGHT)
	
	h = {
		main = function()
			TIME = TIME + 1
			camera.main()
		end
	}
	