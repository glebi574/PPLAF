	
require("/dynamic/pplaf/global_variables.lua")
require("/dynamic/pplaf/math.lua")
require("/dynamic/pplaf/fxmath.lua")
	
	function chance(c)
		if math.random(1, 100) < c then return true end
		return false
	end
	
	function create_text_line(x, y, text)
		local id = pewpew.new_customizable_entity(x, y)
		pewpew.customizable_entity_set_string(id, text)
		return id
	end
	