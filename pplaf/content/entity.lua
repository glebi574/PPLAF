
-- maintains stuff related to entities, so you don't have to. Simplifies custom entity development

local entities = {} -- entities, stored in their respective groups
local __entities = {} -- entities table, used to actually maintain entities
local __to_destroy = {} -- entities that will be destroyed after every ai function was called

local __group_iter = 1
local __groups = {} -- list of groups' indexes
local __groupsL = {} -- list of groups

local function ensure_proto(type) -- if entity prototype isn't created, create one
  if not type.proto then
    type.proto = {}
  end
end

local function get_groupLE(entity) -- get list of entities from group of this entity
  return __entities[__groups[entity.type.group]]
end

local function maintain_prototypes(type) -- maintains prototype inheritance
  
  ensure_proto(type)
  setmetatable(type.proto, {__index = pplaf.entity.pewpew_proto}) -- assign pewpew prototype to entity prototype; will be overriden by other prototypes if possible and required
  
  if not pplaf.entity.type_proto then -- if type prototype wasn't set, do nothing
    return nil
  end -- if type prototype was set, assign it to type
  setmetatable(type, {__index = pplaf.entity.type_proto})
  
  if not pplaf.settings.override_entity_prototype then -- if required, assign type prototype's entity prototype to type's entity prototype
    setmetatable(type.proto, {__index = pplaf.entity.type_proto.proto})
  end
  
end

local function modify_entity(entity, ...) -- entity modifications during it's init
  setmetatable(entity, {__index = entity.type.proto}) -- assign prototype to entity
  if entity.type.constructor then -- if possible, call constructor
    entity.type.constructor(entity, ...)
  end
  if entity.type.animation then -- if entity has animation, add specific variables to process it automatically
    pplaf.animation.modify_entity(entity)
  end
  if entity.type.weapons then -- if entity has weapons, create them
    pplaf.weapons.create(entity)
  end
  function entity:destroyA(...) -- destroyA maintains entity removal and calls destructor if possible
    if self.type.destructor then
      self.type.destructor(self, ...)
    end
    table.insert(__to_destroy[__groups[self.type.group]], self.__indexP)
    if not self.weapons then
      return nil
    end
    for weapon_index, weapon in ipairs(self.weapons) do
      if weapon.type.destructor then
        weapon.type.destructor(weapon)
      end
    end
  end
  entity.__indexP = #get_groupLE(entity) + 1 -- __indexP is used to identify current position in list of entities
end

local function store_entity(entity) -- store entity in hash table and in list in respective groups
  entities[entity.type.group][entity.id] = entity
  table.insert(get_groupLE(entity), entity)
end

local function maintain_ai() -- call ai function if possible
  for group_index, group in ipairs(__entities) do
    for entity_index, entity in ipairs(group) do
      if not entity.is_alive or entity.is_exploding then -- if entity isn't alive, don't process it
        goto el_ma1
      end
      if entity.type.ai then -- if entity has ai, process it
        entity.type.ai(entity)
      end
      if entity.animation then
        pplaf.animation.maintain(entity)
      end
      if entity.weapons then -- if entity has weapons, process them
        for weapon_index, weapon in ipairs(entity.weapons) do
          weapon.type.ai(weapon)
        end
      end
      ::el_ma1::
    end
  end
end

local function maintain_destruction() -- maintain entity destruction if required
  for group_index, td_group in ipairs(__to_destroy) do
    if #td_group == 0 then -- if there are no entities to destroy, skip
      goto el_md1
    end
    if #td_group == #__entities[group_index] then -- if whole array has to be destroyed, destroy it
      for td_index, entity_index in ipairs(td_group) do
        entities[__groupsL[group_index]][__entities[group_index][entity_index].id] = nil -- remove entity from hash table
        __entities[group_index][entity_index] = nil -- remove entity from entities list
      end
      goto el_md0
    end -- otherwise destroy required entities and replace them with newer entities
    for td_index = #__to_destroy[group_index], 1, -1 do
      local entity_index = td_group[td_index]
      entities[__groupsL[group_index]][__entities[group_index][entity_index].id] = nil -- remove entity from hash table
      if entity_index == #__entities[group_index] then -- if entity is last in the list, remove it
        __entities[group_index][entity_index] = nil
      else -- otherwise replace it with the last one
        __entities[group_index][#__entities[group_index]].__indexP = __entities[group_index][entity_index].__indexP
        __entities[group_index][entity_index] = __entities[group_index][#__entities[group_index]]
        __entities[group_index][#__entities[group_index]] = nil
      end
    end
    ::el_md0:: -- clear group and continue
    __to_destroy[group_index] = {}
    ::el_md1:: -- group is empty, just continue
  end
end

pplaf.entity = {
  
  pewpew_proto = require(pplaf.content .. 'pewpew_proto.lua'),
  
  types = {}, -- stores loaded entity types
  
  add_group = function(group) -- adds group in entities array
    entities[group] = {}
    table.insert(__entities, {})
    table.insert(__to_destroy, {})
    table.insert(__groupsL, group)
    __groups[group] = __group_iter
    __group_iter = __group_iter + 1
  end,
  
  get_entities = function() -- returns entities array
    return entities
  end,
  
  get_group = function(group) -- returns certain group array from entities array
    return entities[group]
  end,
  
  get_groupL = function(group) -- returns certain group array from entities array, possible to iterate through ipairs
    return __entities[__groups[group]]
  end,
  
  set_type_proto = function(path) -- this prototype will be assigned to every new loaded type
    pplaf.entity.type_proto = require(path)
    ensure_proto(pplaf.entity.type_proto)
    setmetatable(pplaf.entity.type_proto.proto, {__index = pplaf.entity.pewpew_proto})
  end,
  
  -- differences in type loading methods are commented below
  
  load_by_typed_dir = function(path, ...) -- load entities from folder; entities are stored in folders with type declared as entity.lua
    for _, type_name in ipairs{...} do
      local folder_path = path .. type_name .. '/'
      local file_path = folder_path .. 'entity.lua'
      local entity_type = require(file_path)
      entity_type.folder_path = folder_path
      entity_type.file_path = file_path
      maintain_prototypes(entity_type)
      pplaf.entity.types[type_name] = entity_type
    end
  end,
  
  load_by_typed_files = function(path, ...) -- load entities from folder; entity types are stored in one folder with respective names
    for _, type_name in ipairs{...} do
      local file_path = path .. type_name .. '.lua'
      local entity_type = require(file_path)
      entity_type.file_path = file_path
      maintain_prototypes(entity_type)
      pplaf.entity.types[type_name] = entity_type
    end
  end,
  
  create = function(x, y, type, ...) -- create entity in position, with type and pass any parameters to constructor(if it exists)
    local id = pewpew.new_customizable_entity(x, y)
    local entity = {
      id = id,
      type = pplaf.entity.types[type],
      is_alive = true,
      is_exploding = false,
    }
    modify_entity(entity, ...) -- set prototype, call constructor, set destruction function, create weapons; if required and possible*
    store_entity(entity)
    return entity
  end,
  
  main = function()
    maintain_ai()
    maintain_destruction()
  end,
  
}

__DEF_PPLAF_ENTITY_MODIFY = modify_entity
__DEF_PPLAF_ENTITY_STORE = store_entity

--[[
  
  entity structure:
    
    entity_type = {       - entity type
    
      static_variable_n,  - can be used to store common parameteres(that can be changed over time), counters or whatever you want
      
      folder_path,        - path of the folder, containing file; filled automatically if you're using load_by_typed_dir
      
      file_path,          - path of the file; filled automatically
      
      group,              - group of the entity; you can define groups yourself; made for simplicity of entity management
      
      constructor,        - called any time you create entity of this type, optional(you want to add it tho); additional args upon creation can be passed to constructor function
      
      destructor,         - called any time you destroy entity, optional(entity isn't automatically destroyed, only removed from entities table); additional args upon destruction can be passed to destructor function
      
      ai,                 - entity's ai, called automatically, optional(this way if you don't control it manually it will do nothing)
      
      animation,          - name of animation type; animation is processed automatically
      
      weapons,            - array with weapon types, that will be added to entity on its creation, optional(made to simplify ai development by separating ai and weapons of entity; you can ignore this one and separate ai functions however you want)
      
      proto,              - entity prototype; better way, than declaring entity parameters/functions in constructor
      
      built_in_stuff      - I'm not sure yet, but there is plenty of stuff I can add
      
    }
    
    
    entity = {            - entity, created using entity_type
      
      type,               - type of this entity(table)
      
      id,                 - pewpew id
      
      weapons,            - weapons, defined earlier; they are processed automatically, but if needed you can modify them or vice versa
      
      variable_n,         - whatever you want: hp, damage, counters, etc.; I usually define those in constructor
      
      built_in_stuff      - I'm not sure yet, but there is plenty of stuff I can add
      
    }
  
  
  
  built-in stuff:
    
    mesh responses        - mesh changes on certain events; like, changing mesh to certain mesh for several ticks; depending on other modules that can be included, that may require you to create different animated meshes to use certain features of this
    
    music responses       - music responses for some basic things, such as creation/destruction; this would be inconsistent though, as you will still have to implement music responses for being damaged or whatever happens with this entity; maybe better way is to make it so you store files in 1 place and just simplify way you can use sounds for certain events; that can be easily implemeted for certain use case, so idk
    
    attached entities     - in case you want several entities to be connected; can be easily done manually
  
  
  
  load_by_typed_dir(path, ...): -- folder path, names
    
    folder/
      entity1/
        entity.lua
        weapon.lua
        mesh.lua
        animation.lua
        sounds.lua
        ...
      entity2/
        entity.lua
        ...
      ...
    
    load_by_typed_dir('/dynamic/folder/', 'entity1', 'entity2')
    
    if you want to store all entity's files in its own directory
  
  load_by_typed_files(path, ...): -- folder path, names
    
    folder/
      entity1.lua
      entity2.lua
      ...
    other_folder/
      weapon1.lua
      weapon2.lua
      ...
    ...
    
    load_by_typed_files('/dynamic/folder/', 'entity1', 'entity2')
    
    if you want to store certain files of entity in respective directories
  
  
  
  check settings to modify prototypes, applied to entity and how prototype inheritance/override will work
  any prototypes are optional
  you can also change if entity's functions ovverride prototype functions or expand them
  
  
  
]]--
