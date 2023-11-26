
local frame_amount = 90

return {
  
  template = 0,
  frames_per_tick = 2,
  variation_amount = 10,
  frame_amount = frame_amount,
  path = '/dynamic/pplaf/assets/meshes/flamethrower.lua',
  
  actions = {
    {'wait_and_increment', 2},
    {'animate', frame_amount}
  },
  
  particle_amount = 24,
  
  min_spread_angle = 0.07,
  max_spread_angle = 0.43,
  
  rotation = 0.08,
  
  min_speed = 1.6,
  max_speed = 2.6,
  
  max_random_speed = 0.01,
  max_random_v_angle = 0.11,
  max_v_angle_offset = 0.32,
  
  min_speed_ratio = 0.98,
  max_speed_ratio = 0.99,
  
}
