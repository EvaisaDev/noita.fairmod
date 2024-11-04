local me = GetUpdatedEntityID()
local parent = EntityGetParent(me)
local platformer = EntityGetFirstComponent(parent, "CharacterPlatformingComponent")
if platformer == nil then return end
local comps = EntityGetComponent(me, "VariableStorageComponent")
if comps == nil or #comps ~= 2 then return end
for _, comp in ipairs(comps) do
	local accel = ComponentGetValue2(comp, "value_float")
	local field = ComponentGetValue2(comp, "name")
	ComponentSetValue2(platformer, field, accel)
end
