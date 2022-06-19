
	math = {
	
		abs = function(a) --abs
			return (a < 0 and -a) or a
		end,
		
		floor = function(a) --floor
			return ((a // 1 == (a - 0.5) // 1 and a + 1) or a) // 1
		end,
		
		random = function(a, b) --random from a to b
			return fmath.random_int(a, b)
		end
		
	}