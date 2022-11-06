
pplaf.weapon = {
	
	type = {},

	create = function(entity, type)
		local weapons = {}
		for _, weapon_type in ipairs(pplaf.entity.type[type].weapons) do
			local weapon = {type = pplaf.weapon.type[weapon_type], entity = entity}
			if pplaf.weapon.type[weapon_type].constructor then
				pplaf.weapon.type[weapon_type].constructor(weapon)
			end
			table.insert(weapons, weapon)
		end
		return weapons
	end,

	load = function(path, list)
		for _, name in pairs(list) do
			pplaf.weapon.type[name] = require(path .. name .. '.lua')
		end
	end
	
}

pplaf.weapon.load(pplaf.path .. 'weapon/', {'pewpew_player_gun'})
