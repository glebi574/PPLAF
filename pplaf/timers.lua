
require("/dynamic/pplaf/functions.lua")
	
	local timers = {
		
	}
	
	timer = {
		
		G = 0,
		
		create = function(max_v)
			timer.G = timer.G + 1
			table.insert(timers, {
									index = timer.G,
									max_v = max_v,
									   v1 = 0,
									   v2 = 0
								 })
			return timer.G
		end,
		
		find = function(index)
			for i, t in ipairs(timers) do
				if t.index == index then return i end
			end
			return false
		end,
		
		get = function(index)
			local i = timer.find(index)
			if i then return timers[i].v1, timers[i].v2 end
		end,
		
		remove = function(index)
			local i = timer.find(index)
			if i then table.remove(timers, i) end
		end,
		
		update = function()
			for _, t in ipairs(timers) do
				t.v1 = t.v1 + 1
				if t.v1 == t.max_v then
					t.v1 = 0
					t.v2 = t.v2 + 1
				end
			end
		end
		
	}
	