
-- allows you to create animation types and automatically maintain related stuff

local action_list = {}

local function modify_animation_type(animation_type)
  if not animation_type.variation_amount then
    animation_type.variation_amount = 1
  end 
end

local function go_to_next_action(animation, animation_type)
  animation.action = animation.action + 1
  animation.action_param = table.copy(animation_type.actions[animation.action])
end

local function action_wait_base(animation, animation_type)
  local timer = animation.action_param[2]
  if timer == 1 then
    go_to_next_action(animation, animation_type)
  else
    animation.action_param[2] = timer - 1
  end
end

pplaf.animation = {
  
  template = {
    sf = 0, -- animation is stored in 1 file
    mf_variation = 1, -- every animation file contains 1 variation with B frames; A files
    mf_frame = 2,  -- every animation file contains 1 frame of A variations; B files
    mf_variated_frame = 3, -- every animation file contains 1 frame of 1 variation; A * B files
  },
  
  types = {
    wait = 100,
    wait_and_increment = 101,
    wait_and_decrement = 102,
    animate = 200,
    animate_back = 201,
    loop = 300,
    loopW = 301,
    loop_back = 302,
    loop_backW = 303,
    loop_back_forth = 304,
    loop_back_forthW = 305,
    set_frame = 400,
  },
  
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
    end
  end,
  
  modify_entity = function(entity) -- adds animation table in entity
    local animation_type = pplaf.animation.types[entity.type.animation]
    local variation_index = pplaf.math.random(1, animation_type.variation_amount) - 1
    local animation = {
      type = animation_type,
      frame = 0,
      action = 1,
      action_param = table.copy(animation_type.actions[1]),
      variation_index = variation_index,
      variation_offset = variation_index * animation_type.frame_amount,
    }
    entity.animation = animation
  end,
  
  maintain = function(entity) -- maintains entity's animation
    local animation = entity.animation
    local animation_type = animation.type
    local template = animation_type.template
    local current_action = animation_type.actions[animation.action]
    local current_action_param = animation.action_param
    local action_type = current_action[1]
    
    local modify_frame = 0 -- 0 - don't modify, 1 - increment, 2 - decrement
    local path = 0
    local frame = 0
    
    if action_type == action_list.wait then
      action_wait_base(animation, animation_type)
      goto al_me -- if you're confused: Animation Label _ Maintain End / filename label _ function_name index/name
    elseif action_type == action_list.wait_and_increment then
      action_wait_base(animation, animation_type)
      modify_frame = 1
      goto al_mmf
    elseif action_type == action_list.wait_and_decrement then
      action_wait_base(animation, animation_type)
      modify_frame = 2
      goto al_mmf
    elseif action_type == action_list.animate then
      if animation.frame == current_action_param[2] then
        go_to_next_action(animation, animation_type)
      end
      modify_frame = 1
    elseif action_type == action_list.animate_back then
      if animation.frame == current_action_param[2] then
        go_to_next_action(animation, animation_type)
      end
      modify_frame = 2
    elseif action_type == action_list.loop then
      if animation.frame == current_action_param[3] then
        animation.frame = current_action[2]
      end
      modify_frame = 1
    elseif action_type == action_list.loopW then
      if current_action_param[4] == 1 and animation.frame == current_action_param[3] - 1 then
        go_to_next_action(animation, animation_type)
      end
      if animation.frame == current_action_param[3] then
        animation.frame = current_action[2]
        current_action_param[4] = current_action_param[4] - 1
      end
      modify_frame = 1
    elseif action_type == action_list.loop_back then
      if animation.frame == current_action_param[2] then
        animation.frame = current_action[3]
      end
      modify_frame = 2
    elseif action_type == action_list.loop_backW then
      if current_action_param[4] == 1 and animation.frame == current_action_param[2] + 1 then
        go_to_next_action(animation, animation_type)
      end
      if animation.frame == current_action_param[2] then
        animation.frame = current_action[3]
        current_action_param[4] = current_action_param[4] - 1
      end
      modify_frame = 1
    elseif action_type == action_list.loop_back_forth then
      if animation.frame == current_action_param[2] then
        current_action_param.loop_increment_param = 1
      end
      if animation.frame == current_action_param[3] then
        current_action_param.loop_increment_param = 2
      end
      modify_frame = current_action_param.loop_increment_param
    elseif action_type == action_list.loop_back_forthW then
      if animation.frame == current_action_param[2] then
        current_action_param.loop_increment_param = 1
        current_action_param[4] = current_action_param[4] - 1
      end
      if animation.frame == current_action_param[3] then
        current_action_param.loop_increment_param = 2
        current_action_param[4] = current_action_param[4] - 1
      end
      local df = 0
      if current_action_param.loop_increment_param == 1 then
        df = current_action_param[3] - animation.frame
      elseif current_action_param.loop_increment_param == 2 then
        df = animation.frame - current_action_param[2]
      end
      if current_action_param[4] == 1 and df == 1 then
        go_to_next_action(animation, animation_type)
      end
      modify_frame = current_action_param.loop_increment_param
    elseif action_type == action_list.set_frame then
      animation.frame = current_action_param[2]
    end
    
    if     template == 0 then -- SF animation
      path = animation_type.path
      frame = animation.variation_offset + animation.frame
    elseif template == 1 then -- MF animation
      path = animation_type.path .. animation.variation_index + 1 .. '.lua'
      frame = animation.frame
    elseif template == 2 then
      path = animation_type.path .. animation.frame + animation_type.frame_offset + 1 .. '.lua'
      if animation_type.frames_per_tick == 1 then
        frame = animation.variation_index
      else
        frame = animation.variation_index * 2 -- OwO
      end
    elseif template == 3 then
      path = animation_type.path .. animation.variation_offset + animation.frame + animation_type.frame_offset + 1 .. '.lua'
    end
    
    if animation_type.frames_per_tick == 1 then
      entity:set_mesh(path, frame)
    else
      if modify_frame == 1 then
        entity:set_flipping_meshes(path, frame, frame + 1)
      else
        entity:set_flipping_meshes(path, frame + 1, frame) -- we're decrementing frames, so we should use corresponding frames
      end
    end
    
    ::al_mmf::
    if modify_frame == 1 then
      animation.frame = animation.frame + animation_type.frames_per_tick
    elseif modify_frame == 2 then
      animation.frame = animation.frame - animation_type.frames_per_tick
    end
    ::al_me::
  end,
  
}

action_list = pplaf.animation.actions

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
    
    -- old {{{{
    
    -- next is list of different settings
    
    s_skip_angle_interpolation - if true, first 2 ticks will be skipped
    s_skip_angle_interpolation_add_offset - after first 2 ticks animation will start from tick 0 instead of tick 2
    
    --TBD
    s_loop - if true, next 4 settings will be used to create loop
    s_loop_intro_first_index - first and last indexes of animation, that will be played before start of the loop
    s_loop_intro_last_index - if these aren't presented, loop will start
    s_loop_first_index - first and last indexes of the loop
    s_loop_last_index
    
    }}}}
    
    -- new {{{{
    
    sequnce             - sequence of actions
    
    }}}}
    
    -- next is list of variables created automatically and used by animation framework
    
    frame_offset        - offset, automatically calculated depending on settings
  
  
  animation:
    
    type             - type of this animation(table)
    
    frame            - current frame
    
    variation_index  - variation that will be used for this entity
    
    variation_offset - offset, calculated for SF or certain MF animations
  
  
  include animation in entity with all required information and it will be cycled automatically from frame 0 to frame N
  
  
  
  sequence of actions:
  
    table, containing action and parameters: {pplaf.animation.actions.wait, 2}
  
  actions:
    
    wait - {100, 10} - mesh isn't set, waiting for N ticks; frames aren't incremented; after N frames go to next action
    
    wait_and_increment - {101, 10} - mesh isn't set, waiting for N ticks; frames are incremented; after N frames go to next action
    
    wait_and_decrement - {102, 10} - mesh isn't set, waiting for N ticks; frames are decremented; after N frames go to next action
    
    animate - {200, 9} - mesh is set to current frame while frame is in less than A; frames are incremented; after frame is equal to A go to next action
    
    animate_back - {201, 0} - mesh is set to current frame while frame is in more than A; frames are decremented; after frame is equal to A go to next action
    
    loop - {300, 0, 9} - mesh is set to current frame, after frame is equal to B, frame is set to A; frames are incremented
    
    loopW - {301, 0, 9, 2} - mesh is set to current frame, after frame is equal to B, frame is set to A; frames are incremented; after Q loops go to next action(last frame is kept instead of being reset to A)
    
    loop_back - {302, 0, 9} - mesh is set to current frame, after frame is equal to A, frame is set to B; frames are decremented
    
    loop_backW - {303, 0, 9, 2} - mesh is set to current frame, after frame is equal to A, frame is set to B; frames are decremented; after Q loops go to next action(last frame is kept instead of being reset to B)
    
    loop_back_forth - {304, 0, 9} - mesh is set to current frame; mesh is incremented/decremented after reaching corresponding frame
    
    loop_back_forthW - {305, 0, 9, 2} - mesh is set to current frame; mesh is incremented/decremented after reaching corresponding frame; after Q loops(forth-back loops, double for full loops) go to next action(last frame is kept instead of being reset to A/B)
    
    set_frame - {400, 10} - frame is set to A; go to next action
  
  
  
  animation proto functions:
    
    next_action() - stop current action and go to next one
    
  
  
  
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
