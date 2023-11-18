
meshes = {}

a = 0.75
b = 2

particle_mesh = {
  vertexes = {{-a, -a}, {-a, a}, {a, a}, {a, -a},
              {-b, -b}, {-b, b}, {b, b}, {b, -b}},
  segments = {{0, 1, 2, 3, 0}, {4, 5, 6, 7, 4}}
}

particles = {}

param = require'/dynamic/pplaf/assets/animations/flamethrower.lua'

variation_amount = param.variation_amount
particle_amount = 32
spread_angle = 0.36
time = param.frame_amount
min_speed = 12
max_speed = 20
max_rva = 0.08
max_ra = 0.12
min_speed_ratio = 0.88
max_speed_ratio = 0.97

rgba_start  = {255, 255, 128, 255}
rgba_end    = {255, 0, 0, 0 }

rgba_d      = {
  rgba_end[1] - rgba_start[1],
  rgba_end[2] - rgba_start[2],
  rgba_end[3] - rgba_start[3],
  rgba_end[4] - rgba_start[4],
}

index_offset = #particle_mesh.vertexes

function make_color(r, g, b, a)
	return ((r * 256 + g) * 256 + b) * 256 + a
end

function rotate_vertex(x, y, angle)
  local l = (x ^ 2 + y ^ 2) ^ 0.5
  angle = angle + math.atan(y,  x)
  return l * math.cos(angle), l * math.sin(angle)
end

for f = 1, variation_amount do
  
  particles = {}
  for p = 1, particle_amount do
    local vp = math.random(0, 1) * 2 - 1
    local v_angle = math.random() * spread_angle
    local particle = {
      x = 0,
      y = 0,
      v_speed = min_speed + math.random() * (max_speed - min_speed),
      v_angle = v_angle,
      angle = 0,
      vp = vp,
    }
    table.insert(particles, particle)
  end

  for i = 1, time do
    local mesh = {vertexes = {}, segments = {}, colors = {}}
    local index = 0
    for _, particle in ipairs(particles) do
      particle.angle = particle.angle + max_ra * particle.vp
      particle.v_angle = particle.v_angle + (math.random() * 2 - 1) * max_rva
      --particle.v_speed = particle.v_speed + (math.random() * 2 - 1) * max_rvs
      local x = particle.x
      local y = particle.y
      for _, vertex in ipairs(particle_mesh.vertexes) do
        local nx, ny = rotate_vertex(vertex[1], vertex[2], particle.angle)
        table.insert(mesh.vertexes, {nx + x, ny + y})
        table.insert(mesh.colors, make_color(
          math.floor(rgba_start[1] + rgba_d[1] / time * i),
          math.floor(rgba_start[2] + rgba_d[2] / time * i),
          math.floor(rgba_start[3] + rgba_d[3] / time * i),
          math.floor(rgba_start[4] + rgba_d[4] / time * i)
        ))
      end
      for _, segment in ipairs(particle_mesh.segments) do
        local segmentM = {}
        for _, segment_part in ipairs(segment) do
          table.insert(segmentM, segment_part + index)
        end
        table.insert(mesh.segments, segmentM)
      end
      particle.x = x + particle.v_speed * math.cos(particle.v_angle)
      particle.y = y + particle.v_speed * math.sin(particle.v_angle)
      particle.v_speed = particle.v_speed * (min_speed_ratio + math.random() * (max_speed_ratio - min_speed_ratio))
      index = index + index_offset
    end
    table.insert(meshes, mesh)
  end
  
end
