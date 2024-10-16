local x, y = EntityGetTransform(GetUpdatedEntityID())

local idx = ProceduralRandomi(x, y, 6, 7)
EntityLoad("mods/noita.fairmod/files/content/cactus/cactus_" .. tostring(idx) .. ".xml", x, y)
