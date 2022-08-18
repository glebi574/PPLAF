
local vertexes, segments = {}, {{0,}}

local radius = 100
local iterator = 56

local angle = 6.283185 / iterator

for i = iterator - 1, 0, -1 do
	local x = math.cos(angle * i) * radius
	local y = math.sin(angle * i) * radius
	table.insert(vertexes, {x, y})
	table.insert(segments[1], i)
end

meshes = {
	{
		vertexes = vertexes,
		segments = segments
	},
}