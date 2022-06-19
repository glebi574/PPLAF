
	math = {
	
		abs = function(a) --abs
			if a < 0 then a = -a end
			return a
		end,
		
		floor = function(a) --floor
			if a // 1 == (a - 0.5) // 1 then a = a + 1 end
			return a // 1
		end,
		
		random = function(a, b) --random from a to b
			return fmath.random_int(a, b)
		end
		
	}