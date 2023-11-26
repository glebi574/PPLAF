
meshes = {}

a = 5
b = 10

c = a / 2
d = a * math.sqrt(3) / 2
q = d / 3
w = q * 2
u = b / a

particle_mesh = {
  vertexes = {{-q, c}, {-q, -c}, {w, 0},
              {-q * u, c * u}, {-q * u, -c * u}, {w * u, 0}},
  segments = {{0, 1, 2, 0}, {3, 4, 5, 3}}
}

particles = {}

param = require'/dynamic/pplaf/assets/animations/flamethrower.lua'

variation_amount = param.variation_amount
time = param.frame_amount

particle_amount = param.particle_amount

min_spread_angle = param.min_spread_angle
max_spread_angle = param.max_spread_angle

rotation = param.rotation

min_speed = param.min_speed
max_speed = param.max_speed

max_random_speed = param.max_random_speed
max_random_v_angle = param.max_random_v_angle
max_v_angle_offset = param.max_v_angle_offset

min_speed_ratio = param.min_speed_ratio
max_speed_ratio = param.max_speed_ratio

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
  
  local spread_angle = min_spread_angle + math.random() * (max_spread_angle - min_spread_angle)
  
  particles = {}
  for p = 1, particle_amount do
    local sign = math.random(0, 1) * 2 - 1
    local v_angle = (math.random() * 2 - 1) * spread_angle
    local particle = {
      x = 0,
      y = 0,
      v_speed = min_speed + math.random() * (max_speed - min_speed),
      v_angle = v_angle,
      angle = 0,
      sign = sign,
      min_v_angle = -v_angle - max_v_angle_offset,
      max_v_angle = v_angle + max_v_angle_offset,
    }
    table.insert(particles, particle)
  end

  for i = 1, time do
    local mesh = {vertexes = {}, segments = {}, colors = {}}
    local index = 0
    for _, particle in ipairs(particles) do
      
      particle.angle = particle.angle + rotation * particle.sign
      particle.v_angle = particle.v_angle * (1 - i / time * 0.1)
      
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
      index = index + index_offset
    end
    table.insert(meshes, mesh)
  end
  
end
