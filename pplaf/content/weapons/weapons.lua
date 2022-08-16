
weapons = {
	
	create = function(preset)
		local param = {}
		param.preset = preset
		;(weapons.constructor[weapons.presets[preset].constructor] or NULL_FUNCTION)(id, param)
		return param
	end,
	
	main = function()
		for _, arr in pairs(entities) do
			for id, info in pairs(arr) do
				for _, weapon in ipairs(info.weapons or {}) do
					weapons.ai[weapons.presets[weapon.preset].ai](id, info, weapon)
				end
			end
		end
	end
	
}
