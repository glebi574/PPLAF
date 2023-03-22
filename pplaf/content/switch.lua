
pplaf.switch = {

	create = function(triggers, mesh_folder_path)
		local switch = {param = triggers, mesh_folder_path = mesh_folder_path, state = 1, active = false}
		switch.current = pplaf.trigger.create(triggers[1], mesh_folder_path)
		function switch:get(x, y)
			self.active = self.current:get(x, y)
			if self.active then
				self.current:destroy()
				self.state = (self.state < #self.param) and (self.state + 1) or 1
				self.current = pplaf.trigger.create(self.param[self.state], self.mesh_folder_path)
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
