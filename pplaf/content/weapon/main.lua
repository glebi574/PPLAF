
pplaf.weapon = {
	
	type = {},

	create = function(type)
		local weapons = {}
		for _, type in ipairs(pplaf.entity.type[type]) do
			local weapon = {type = type}
			if pplaf.weapon.type[type].constructor then
				pplaf.weapon.type[type].constructor(weapon)
			end
			table.insert(weapons, weapon)
		end
		if weapons != {} then return weapons end
	end,

	load = function(path, list)
		for _, name in pairs(list) do
			pplaf.weapon.type[name] = require(path .. name .. '.lua')
		end
	end
	
}

pplaf.weapon.load(pplaf.path .. 'weapon/types/', require(pplaf.path .. 'weapon/types/list.lua'))
