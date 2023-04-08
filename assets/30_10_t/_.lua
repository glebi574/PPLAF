origin_k = {1,1,1,1,1,1,1,1,1,1}
origin = {9,9135180263564,157,44783224967,20,108509621186,184,79259982142,22,647304266692,197,52266602829,112,04454026178,49,895746082047,76,488478453509,192,40356849079}
colors = {1689019565,1689609409,1687970968,1687839895,1690461351,1687708847,1688429751,1687971004,1689806024,1690526877,1688954036,1688954034,1687971002,1687577777,1687643334,1688954033,1689150618,1689085124,1688167579,1690461354}
origin_a = {5,6357393070205,3,2080489071711,3,300859594075,1,1747834157036,5,0769160232445,5,3275418391259,5,7322815596618,4,9093603874975,0,21933801429608,2,5733912828794}
frame_amount = 30
file_amount = 30
frames_per_file = 1

particle_amount = 10
TAU = math.pi * 2
d = TAU / frame_amount
l = 2.5
r = 200
function g(N)
	local ang = d * N
	local vertexes = {}
	local segments = {}
	local index = 0
	for i = 1, particle_amount do
		local sin, cos = math.sin(ang * origin_k[i] + origin_a[i]), math.cos(ang * origin_k[i] + origin_a[i])
		local dy, dx = sin * l, cos * l
		local y, x = sin * origin[i], cos * origin[i]
		table.insert(vertexes, {x, y})
		table.insert(vertexes, {x + dx, y + dy})
		table.insert(segments, {index, index + 1})
		index = index + 2
	end
	return {{vertexes = vertexes, segments = segments, colors = colors}}
end

return g