
-- settings for different pplaf features
--[[
  
  type prototype - prototype of any type; basically this is just an entity type
  entity prototype - prototype of entity of this type
  pewpew prototype - prototype with pewpew functions
  
  type prototype can have entity prototype; respective setting can change if type's entity prototype will override type prototype's entity prototype or expand it
  
]]--

pplaf.settings = {
  
  override_entity_prototype = false,      -- type's entity prototype overrides type prototype's entity prototype instead of expanding it
  
}
