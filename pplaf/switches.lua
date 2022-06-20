
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
			if i then
				local s = trigger.get(switches[i].id)
				if s then
					switches[i].mode = not switches[i].mode
					trigger.remove(switches[i].id)
					switches[i].id = (switches[i].mode and trigger.create(	switches[i].b2[1], switches[i].b2[2],
																			switches[i].b2[3], switches[i].b2[4]))
														or trigger.create(	switches[i].b1[1], switches[i].b1[2],
																			switches[i].b1[3], switches[i].b1[4])
				end
				return s, switches[i].mode
			end
		end,
		
		remove = function(index)
			local i = switch.find(index)
			if i then
				trigger.remove(switches[i].id)
				table.remove(switches, i)
			end
		end
		
	}
	