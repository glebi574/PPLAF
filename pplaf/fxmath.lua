	
	fxmath = {
		
		abs = function(a) --fx abs
			return fmath.abs_fixedpoint(a)
		end,
		
		floor = function(a) --fx floor
			return fmath.to_fixedpoint(fmath.to_int(a))
		end,
		
		random = function(a, b) --fx random from a to b
			return fmath.random_fixedpoint(a, b)
		end,
		
		lenght = function(...) --fx lenght of vector
			local args, l = {...}
			if #args == 2 then l = fmath.sqrt(args[1] * args[1] + args[2] * args[2]) end
			if #args == 4 then --x1, y1, x2, y2
				local dx = args[3] - args[1]
				local dy = args[4] - args[2]
				l = fmath.sqrt(dx * dx + dy * dy)
			end
			return l
		end
		
	}
	