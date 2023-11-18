
-- creates weapons for entities. Basically it just creates arrays and maintains mostly nothing. It devides different parts of entity AI and allows you to use same weapons for different entities tho

local function ensure_proto(type) -- if weapon prototype isn't created, create one
  if not type.proto then
    type.proto = {}
  end
end

local function maintain_prototypes(type)

  ensure_proto(type)
  
  if not pplaf.weapons.type_proto then -- if type prototype wasn't set do nothing
    return nil
  end -- if type prototype was set, assign it to type
  setmetatable(type, {__index = pplaf.weapons.type_proto})
  
  if not pplaf.settings.override_weapons_prototype and pplaf.weapons.type_proto.proto then -- if required and possible, assign type prototype's weapon prototype to type's weapon prototype
    setmetatable(type.proto, {__index = pplaf.weapons.type_proto.proto})
  end
  
end

local function modify_weapon(weapon)
  setmetatable(weapon, {__index = weapon.type.proto})
  if weapon.type.constructor then
    weapon.type.constructor()
  end
end

pplaf.weapons = {
  
  types = {}, -- stores loaded weapon types
  
  set_type_proto = function(path) -- this prototype will be assigned to every new loaded type
    pplaf.weapons.type_proto = require(path)
  end,
  
  -- similar to entity loading methods; check entity.lua for more info
  
  load_by_typed_dir = function(path, ...) -- load weapons from folder; weapons are stored in folders with type declared as weapon.lua
    for _, type_name in pairs({...}) do
      local folder_path = path .. type_name .. '/'
      local file_path = folder_path .. 'weapon.lua'
      local weapon_type = require(file_path)
      weapon_type.folder_path = folder_path
      weapon_type.file_path = file_path
      maintain_prototypes(weapon_type)
      pplaf.weapons.types[type_name] = weapon_type
    end
  end,
  
  load_by_typed_files = function(path, ...) -- load weapons from folder; weapon types are stored in one folder with respective names
    for _, type_name in pairs({...}) do
      local file_path = path .. type_name .. '.lua'
      local weapon_type = require(file_path)
      weapon_type.file_path = file_path
      maintain_prototypes(weapon_type)
      pplaf.weapons.types[type_name] = weapon_type
    end
  end,
  
  create = function(entity) -- creates all entity's weapons
    local weapons = {}
    for weapon_index, weapon_type_str in ipairs(entity.type.weapons) do
      local weapon = {
        type = pplaf.weapons.types[weapon_type_str],
        entity = entity
      }
      modify_weapon(weapon) -- set prototype and call constructor; if possible*
      weapons[weapon_index] = weapon -- insert weapon
    end
    entity.weapons = weapons
  end,
  
}

--[[
  
  weapon structure:
    
    weapon_type = {       - descriptions are kinda same to entity.lua; group isn't required, as you will have access to parent entitie's group
      
      static_variable_n,
      
      constructor,
      
      destructor,         - called upon entity destruction; in most cases you won't use it
      
      ai,
      
      proto,
      
      built_in_stuff
      
    }
    
    
    weapon = {
      
      type,               - type of this weapon(table)
      
      entity,             - entity, this weapon is attached to(weapon.entity.weapons[1].entity.weapons[1]...)
      
      variable_n,         - whatever you want: recharge, damage, counters, etc.; I usually define those in constructor
      
      built_in_stuff
      
    }
  
  
  
  built-in stuff:
    
    no ideas yet
  
]]--
