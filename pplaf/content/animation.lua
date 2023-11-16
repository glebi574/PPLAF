
-- allows you to create animation types and automatically maintain related stuff

local function modify_animation_type(animation_type)
  local frame_offset = 0
  if animation_type.s_skip_angle_interpolation then
    frame_offset = 1
    if animation_type.s_skip_angle_interpolation_add_offset then
      frame_offset = frame_offset - animation_type.frames_per_tick * 2
    end
  end
  animation_type.frame_offset = frame_offset
  if not animation_type.variation_amount then
    animation_type.variation_amount = 1
  end 
end

pplaf.animation = {
  
  template = {
    sf = 0, -- animation is stored in 1 file
    mf_variation = 1, -- every animation file contains 1 variation with B frames; A files
    mf_frame = 2,  -- every animation file contains 1 frame of A variations; B files
    mf_variated_frame = 3, -- every animation file contains 1 frame of 1 variation; A * B files
  },
  
  types = {},
  
  load_by_typed_dir = function(path, ...) -- load animations from folder; animations are stored in folders with type declared as animation.lua
    for _, type_name in ipairs{...} do
      local folder_path = path .. type_name .. '/'
      local file_path = folder_path .. 'animation.lua'
      local animation_type = require(file_path)
      animation_type.folder_path = folder_path
      animation_type.file_path = file_path
      modify_animation_type(animation_type)
      pplaf.animation.types[type_name] = animation_type
    end
  end,
  
  load_by_typed_files = function(path, ...) -- load animations from folder; animation types are stored in one folder with respective names
    for _, type_name in ipairs{...} do
      local file_path = path .. type_name .. '.lua'
      local animation_type = require(file_path)
      animation_type.file_path = file_path
      modify_animation_type(animation_type)
      pplaf.animation.types[type_name] = animation_type
    end
  end,
  
  preload_all = function() -- preloads all meshes to avoid lag/delay on 1st mesh load
    local id = pewpew.new_customizable_entity(1000000fx, 1000000fx)
    pewpew.customizable_entity_set_visibility_radius(id, 0fx)
    for animation_type_name, animation_type in pairs(pplaf.animation.types) do
      if     animation_type.template == 0 then
        pewpew.customizable_entity_set_mesh(id, animation_type.path, 0)
        goto al_pa1
      elseif animation_type.template == 1 then
        for i = 1, animation_type.variation_amount do
          pewpew.customizable_entity_set_mesh(id, animation_type.path .. i .. '.lua', 0)
        end
      elseif animation_type.template == 2 then
        for i = 1, animation_type.frame_amount do
          pewpew.customizable_entity_set_mesh(id, animation_type.path .. i .. '.lua', 0)
        end
      elseif animation_type.template == 3 then
        for i = 1, animation_type.variation_amount * animation_type.frame_amount do
          pewpew.customizable_entity_set_mesh(id, animation_type.path .. i .. '.lua', 0)
        end
      end
      if animation_type.s_skip_angle_interpolation then
        pewpew.customizable_entity_set_mesh(id, animation_type.path .. '0.lua', 0)
      end
      ::al_pa1::
    end
  end,
  
  modify_entity = function(entity) -- adds animation table in entity
    local animation_type = pplaf.animation.types[entity.type.animation]
    local variation_index = pplaf.math.random(1, animation_type.variation_amount) - 1
    local animation = {
      type = animation_type,
      frame = 0,
      variation_index = variation_index,
      variation_offset = variation_index * animation_type.frame_amount,
    }
    entity.animation = animation
  end,
  
  maintain = function(entity) -- maintains entity's animation
    local animation = entity.animation
    local animation_type = animation.type
    
    if animation_type.template == 0 then -- SF animation
    
      if animation_type.s_skip_angle_interpolation and animation.frame <= animation_type.frames_per_tick then -- skip angle interpolation if required
        entity:set_mesh(animation_type.path, 0)
        goto al_m0
      end
      
      local frame = animation.variation_offset + animation.frame + animation_type.frame_offset
      if animation_type.frames_per_tick == 1 then
        entity:set_mesh(animation_type.path, frame)
      else
        entity:set_flipping_meshes(animation_type.path, frame, frame + 1)
      end
      
    else -- MF animation
    
      if animation_type.s_skip_angle_interpolation and animation.frame <= animation_type.frames_per_tick then -- skip angle interpolation if required
        entity:set_mesh(animation_type.path .. '0.lua', 0)
        goto al_m0
      end
      
      if     animation_type.template == 1 then
        
        local frame_path = animation_type.path .. animation.variation_index + 1 .. '.lua'
        if animation_type.frames_per_tick == 1 then
          entity:set_mesh(frame_path, animation.frame)
        else
          entity:set_flipping_meshes(frame_path, animation.frame, animation.frame + 1)
        end
        
      elseif animation_type.template == 2 then
        
        local frame_path = animation_type.path .. animation.frame + 1 .. '.lua'
        if animation_type.frames_per_tick == 1 then
          entity:set_mesh(frame_path, animation.variation_index)
        else
          entity:set_flipping_meshes(frame_path, animation.variation_index * 2, animation.variation_index * 2 + 1) -- OwO
        end
        
      elseif animation_type.template == 3 then
        
        local frame_path = animation_type.path .. animation.variation_offset + animation.frame + animation_type.frame_offset + 1 .. '.lua'
        if animation_type.frames_per_tick == 1 then
          entity:set_mesh(frame_path, 0)
        else
          entity:set_flipping_meshes(frame_path, 0, 1)
        end
        
      end
      
    end
    
    ::al_m0::
    animation.frame = animation.frame + animation_type.frames_per_tick
  end,
  
}

--[[
  
  to use in entity, load animation type and include it in entity type
  to use in mesh, just require animation type
  
  animation type:
    
    static_variable_n   - anything you want
    
    template            - animation template; check pplaf.animation.template for more info
    
    frames_per_tick     - amount of frames per tick; 1 or 2; if you're using MF animation, 2 meshes have to be put in same file in order for 60fps animation to work; yeah, if you're using animations devided by frames, you'll have to use 2 frames per variation, which is a bit confusing, but I don't think anybody will use this one ever anyway, so have fun i guess - same for variated frame MF animations, 2 frames per file
    
    path                - path to mesh(SF) or folder(MF) with meshes, named as N.lua, starting from 1.lua
    
    variation_amount    - amount of different variations of mesh; if not presented, it will be automatically set to 1; animation is chosen randomly between variations
    
    frame_amount        - amount of frames
    
    -- next is list of different settings
    
    s_skip_angle_interpolation - if true, first 2 ticks will be replaced with frame 0 or 0.lua mesh
    s_skip_angle_interpolation_add_offset - after first 2 ticks animation will start from tick 0 instead of tick 2
    
    -- if you're using MF animation and want to skip angle interpolation, add 0.lua file with empty mesh
    
    --TBD
    s_loop - if true, next 4 settings will be used to create loop
    s_loop_intro_first_index - first and last indexes of animation, that will be played before start of the loop
    s_loop_intro_last_index - if these aren't presented, loop will start
    s_loop_first_index - first and last indexes of the loop
    s_loop_last_index
    
    -- next is list of variables created automatically and used by animation framework
  
  
  animation:
    
    type             - type of this animation(table)
    
    frame            - current frame
    
    variation_index  - variation that will be used for this entity
    
    variation_offset - offset, calculated for SF or certain MF animations
  
  
  include animation in entity with all required information and it will be cycled automatically from frame 0 to frame N
  
  
  
  loadSF(path, ...)
  
  animations/
    anim1.lua
    anim2.lua
    ...
    
  loadSF('/dynamic/animations/', 'anim1', 'anim2')
  
  single-file animations are more convinient to maintain, but amount of memory, meshes array can take is limited
  
  
  loadMF(path, ...)
  
  animations/
    anim1/
      _t.lua
      1.lua
      2.lua
      ...
    anim2/
      ...
    ...
  
  loadSF('/dynamic/animations/', 'anim1', 'anim2')
  
  multiple-files animations are less convinient to maintain, but allow you to store bigger meshes; next problem is amount of time it takes to load those meshes :>
  
]]--
