local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local idx = ProceduralRandomi(x, y, 2, 5)
EntityLoad("mods/noita.fairmod/files/content/cactus/cactus_" .. tostring(idx) .. ".xml", x, y)
EntityKill(entity_id)
