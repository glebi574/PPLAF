	
require"/dynamic/pplaf/global_variables.lua"
require"/dynamic/pplaf/math.lua"
require"/dynamic/pplaf/fxmath.lua"
	
	function chance(c)
		return pplaf.math.random(1, 100) < c 
	end
	
	function create_text_line(x, y, text)
		local id = pewpew.new_customizable_entity(x, y)
		pewpew.customizable_entity_set_string(id, text)
		return id
	end
	
	function is_alive(id)
		return pewpew.entity_get_is_alive(id) and not pewpew.entity_get_is_started_to_be_destroyed(id)
	end
	
	function stop_game()
		GAME_STATE = false
		pewpew.stop_game()
	end
	
	function printx(s)
		if type(s) == "boolean" then
			print(s)
		else
			print(string.format(s))
		end
	end
	