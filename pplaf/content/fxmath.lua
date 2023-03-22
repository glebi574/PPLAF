
pplaf.fxmath = {
	
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
	
	sqrt = fmath.sqrt,
	
	to_int = function(a)
		return fmath.to_int(a * 4096fx) / 4096
	end,
	
	__to_int = function(a) --converts the number, but doesn't devides it back
		return fmath.to_int(a * 4096fx)
	end,
	
	to_fx = function()
		return fmath.to_fixedpoint(floor(a)) + fmath.to_fixedpoint(floor(4096 * (a % 1))) / 4096fx
	end,
	
	length = function(...)
		local args = {...}
		if #args == 2 then return fmath.sqrt(args[1] * args[1] + args[2] * args[2]) end --dx, dy
		if #args == 4 then --x1, y1, x2, y2
			return fmath.sqrt((args[3] - args[1]) * (args[3] - args[1]) + (args[4] - args[2]) * (args[4] - args[2]))
		end
	end
	
}
