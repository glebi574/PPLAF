
pplaf.animations = {}

pplaf.animation = {
	
	type = {},
	
	create = function(id, type, cycles_amount)
		local anim = {
			id = id,
			frame = 0,
			type = pplaf.animation.type[type]
		}
		if anim.type.file_amount then
			pewpew.customizable_entity_set_mesh(id, anim.type.path .. '1.lua', 0)
		else
			pewpew.customizable_entity_set_mesh(id, anim.type.path, 0)
		end
		if cycles_amount then anim.cycles_amount = cycles_amount end
		table.insert(pplaf.animations, anim)
		return anim
	end,
	
	main = function()
		for _, anim in pairs(pplaf.animations) do
			if anim.type.file_amount then
				pewpew.customizable_entity_set_mesh(anim.id, anim.type.path .. string.format('%i', pplaf.math.ceil(anim.frame / anim.type.frames_per_file)) .. '.lua', anim.frame % anim.type.frames_per_file)
			else
				pewpew.customizable_entity_set_mesh(anim.id, anim.type.path, anim.frame)
			end
			if anim.frame == anim.type.frame_amount - 1 then
				anim.frame = 0
				if anim.cycles_amount then
					anim.cycles_amount = anim.cycles_amount - 1
					if anim.cycles_amount == 0 then anim = nil end
				end
			else
				anim.frame = anim.frame + 1
			end
		end
	end,
	
	load_folder = function(path, ...)
		for _, name in pairs({...}) do
			local __path = path .. name .. '/'
			pplaf.animation.type[name] = require(__path .. '_type.lua')
			pplaf.animation.type[name].path = __path
		end
	end,
	
	load = function(path, ...)
		for _, name in pairs({...}) do
			local __path = path .. name .. '.lua'
			pplaf.animation.type[name] = require(__path)
			pplaf.animation.type[name].path = __path
		end
	end
	
}
