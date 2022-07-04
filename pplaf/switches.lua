
require"/dynamic/pplaf/triggers/triggers.lua"
	
	local switches = {}
	
	switch = {
		
		G = 0,
		
		create = function(t1, t2)
			switch.G = switch.G + 1
			table.insert(switches, 	{
				   i = switch.G,
				  ti = trigger.create({t1[1], t1[2], t1[3], t1[4]}, true),
				  t1 = t1,
				  t2 = t2,
				mode = false
			})
			return switch.G
		end,
		
		find = function(index)
			for v, s in ipairs(switches) do
				if s.i == index then return v end
			end
		end,
		
		get = function(index)
			local i = switch.find(index)
			local s = trigger.get(switches[i].ti)
			if s then
				switches[i].mode = not switches[i].mode
				trigger.remove(switches[i].ti)
				switches[i].ti = (switches[i].mode and trigger.create({switches[i].t2[1], switches[i].t2[2],
																switches[i].t2[3], switches[i].t2[4]}, true))
													or trigger.create({switches[i].t1[1], switches[i].t1[2],
																switches[i].t1[3], switches[i].t1[4]}, true)
			end
			return s, switches[i].mode
		end,
		
		remove = function(index)
			local i = switch.find(index)
			trigger.remove(switches[i].ti)
			table.remove(switches, i)
		end
		
	}
	