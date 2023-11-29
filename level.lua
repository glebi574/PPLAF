
require'/dynamic/pplaf/main.lua'
pplaf.init'/dynamic/pplaf/'

pewpew.set_level_size(6000fx, 6000fx)

pplaf.animation.load_by_typed_files('/dynamic/pplaf/assets/animations/',
  'flamethrower'
)
pplaf.animation.preload_all()

pplaf.entity.add_group'player'
pplaf.entity.load_by_typed_files('/dynamic/pplaf/assets/entities/',
  'test_player',
  'flamethrower_projectile'
)
pplaf.player.reassign_prototypes('test_player')

local player = pplaf.player.create(0fx, 0fx, 'test_player')

local __c_pi_d2 = PI_FX / 2fx -- pi / 2
local function ease_function(v) -- https://www.desmos.com/calculator/ewmoeap5jt
  return __DEF_FMATH_SINCOS(v * __c_pi_d2)
end

pplaf.camera.configure{
  following_param = player.id,
  ease_function = ease_function
}

pewpew.add_update_callback(function()
  pplaf.entity.main()
  pplaf.camera.main()
end)
