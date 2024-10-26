dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent(entity_id)

local animal_ai_component = EntityGetFirstComponentIncludingDisabled(owner, "AnimalAIComponent")
local vsc = EntityGetFirstComponentIncludingDisabled( entity_id, "VariableStorageComponent" )
if vsc == nil then return end
local strength = tonumber(ComponentGetValue(vsc, "value_float"))

if (EntityGetWithName("MethaneStain") ~= 0) then
	strength = strength + 0.005
else 
	strength = strength - 0.005
end

if (strength > 1) then strength = 1 end

ComponentSetValue2(vsc, "value_float", strength)
GameSetPostFxParameter("grayscale", 0, 0, 0, strength)

if (strength <= 0.0) then
	EntityKill(entity_id)
end