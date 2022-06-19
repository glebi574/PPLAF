
require("/dynamic/ctools/global_variables.lua")

local cv = {}
local cs = {}

local r = 100
local n = 56

local s = 2 * PI / n

local ct = {0, }

for i = n - 1, 0, -1 do
	local x = math.cos(s * i) * r
	local y = math.sin(s * i) * r
	table.insert(cv, {x, y})
	table.insert(ct, i)
end

cs = {ct}

meshes = {
	{
		vertexes = cv,
		segments = cs
	},
}