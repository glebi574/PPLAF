
local switches = {}

switch = {
	
	G = 0,
	
	create = function(t1, t2)
		switch.G = switch.G + 1
		switches[switch.G] = {
			id = trigger.create({t1[1], t1[2], t1[3], t1[4]}, true),
			t1 = t1,
			t2 = t2,
		  mode = false
		}
		return switch.G
	end,
	
	get = function(index)
		local s = trigger.get(switches[index].id)
		if s then
			switches[index].mode = not switches[index].mode
			trigger.remove(switches[index].id)
			switches[index].id = (switches[index].mode and
			   trigger.create({switches[index].t2[1], switches[index].t2[2], switches[index].t2[3], switches[index].t2[4]}, true))
			or trigger.create({switches[index].t1[1], switches[index].t1[2], switches[index].t1[3], switches[index].t1[4]}, true)
		end
		return s, switches[index].mode
	end,
	
	remove = function(index)
		trigger.remove(switches[index].id)
		switches[index] = nil
	end
	
}
