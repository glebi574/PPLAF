
pplaf.switches = {}

pplaf.switch = {
	
	G = 0,

	create = function(triggers, meshes)
		pplaf.switch.G = pplaf.switch.G + 1
		local switch = {param = triggers, meshes = meshes, state = 1, active = false}
		switch.current = pplaf.trigger.create(triggers[1], meshes)
		function switch:get(x, y)
			self.active = self.current:get(x, y)
			if self.active then
				self.current:destroy()
				self.state = (self.state < #self.param) and (self.state + 1) or 1
				self.current = pplaf.trigger.create(self.param[self.state], self.meshes)
			end
			return self.active
		end
		function switch:destroy()
			self.current:destroy()
			self = nil
		end
		return switch
	end
	
}
