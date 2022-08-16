
math = {
	
	abs = function(a)
		return a < 0 and -a or a
	end,
	
	floor = function(a)
		return a // 1
	end,
	
	ceil = function(a)
		return (a + 1) // 1
	end,
	
	round = function(a)
		return (a + 0.5) // 1
	end,
	
	random = fmath.random_int
	
}
