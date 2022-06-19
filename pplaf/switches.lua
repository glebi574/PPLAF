
require("/dynamic/pplaf/triggers/triggers.lua")
	
	local switches = {
		
	}
	
	switch = {
		
		G = 0,
		
		create = function(b1, b2)
			switch.G = switch.G + 1
			table.insert(switches, 	{
										index = switch.G,
										   id = trigger.create(b1[1], b1[2], b1[3], b1[4]),
										   b1 = b1,
										   b2 = b2,
										state = false,
										 mode = false
									})
			return switch.G
		end,
		
		find = function(index)
			for i, t in ipairs(switches) do
				if t.index == index then return i end
			end
			return false
		end,
		
		get = function(index)
			local i = switch.find(index)
			if i then return switches[i].state, switches[i].mode end
		end,
		
		remove = function(index)
			local i = switch.find(index)
			if i then
				trigger.remove(switches[i].id)
				table.remove(switches, i)
			end
		end,
		
		update = function()
			for _, s in ipairs(switches) do
				if s.state then
					s.mode = not s.mode
					trigger.remove(s.id)
					if s.mode then
						s.id = trigger.create(s.b2[1], s.b2[2], s.b2[3], s.b2[4])
					else
						s.id = trigger.create(s.b1[1], s.b1[2], s.b1[3], s.b1[4])
					end
				end
				s.state = trigger.get_state(s.id)
			end
		end
		
	}
	