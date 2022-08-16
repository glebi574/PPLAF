
fxmath = {
	
	abs = fmath.abs_fixedpoint,
	
	floor = function(a)
		return a // 1fx
	end,
	
	ceil = function(a)
		return (a + 1fx) // 1fx
	end,
	
	round = function(a)
		return (a + 0.2048fx) // 1fx
	end,
	
	random = fmath.random_fixedpoint,
	
	length = function(...)
		local args = {...}
		if #args == 2 then return fmath.sqrt(args[1] * args[1] + args[2] * args[2]) end --dx, dy
		if #args == 4 then --x1, y1, x2, y2
			local dx = args[3] - args[1]
			local dy = args[4] - args[2]
			return fmath.sqrt(dx * dx + dy * dy)
		end
	end
	
}
