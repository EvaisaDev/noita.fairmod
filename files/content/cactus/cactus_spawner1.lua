local x, y = EntityGetTransform(GetUpdatedEntityID())

local idx = ProceduralRandomi(x, y, 2, 5)
EntityLoad("mods/noita.fairmod/files/content/cactus/cactus_" .. tostring(idx) .. ".xml", x, y)
