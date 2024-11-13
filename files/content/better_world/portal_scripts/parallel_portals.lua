local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform(entity_id)

local tele_comps = EntityGetComponent(entity_id, "TeleportComponent")
if tele_comps == nil then return end

local x_offset = GetParallelWorldPosition(x, y)
if x_offset == 0 then return end

for index, value in ipairs(tele_comps) do
    local target = {ComponentGetValue2(value, "target")}
    ComponentSetValue2(value, "target", target[1] + (x_offset * BiomeMapGetSize() * 512), target[2])
end