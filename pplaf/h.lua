
require("/dynamic/pplaf/global_variables.lua")
require("/dynamic/pplaf/math.lua")
require("/dynamic/pplaf/fxmath.lua")
require("/dynamic/pplaf/functions.lua")
require("/dynamic/pplaf/triggers/triggers.lua")
require("/dynamic/pplaf/switches.lua")
require("/dynamic/pplaf/player.lua")
require("/dynamic/pplaf/walls/walls.lua")
	
	h = {
		main = function()
			TIME = TIME + 1
			player.main()
		end
	}
	