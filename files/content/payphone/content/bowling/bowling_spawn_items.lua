

local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform(entity_id)

--Do EoE terrain removal
--Spawn bowling ball & pins ontop of the player
--They die to crush damage probably
--lmao

EntityLoad("mods/noita.fairmod/files/content/payphone/content/bowling/prop_pin.xml",x,y)

EntityLoad("mods/noita.fairmod/files/content/payphone/content/bowling/prop_pin.xml",x-32,y-64)
EntityLoad("mods/noita.fairmod/files/content/payphone/content/bowling/prop_pin.xml",x+32,y-64)

EntityLoad("mods/noita.fairmod/files/content/payphone/content/bowling/prop_pin.xml",x-48,y-128)
EntityLoad("mods/noita.fairmod/files/content/payphone/content/bowling/prop_pin.xml",x,y-128)
EntityLoad("mods/noita.fairmod/files/content/payphone/content/bowling/prop_pin.xml",x-48,y-128)

EntityLoad("mods/noita.fairmod/files/content/payphone/content/bowling/prop_pin.xml",x-32,y-192)
EntityLoad("mods/noita.fairmod/files/content/payphone/content/bowling/prop_pin.xml",x+32,y-192)
EntityLoad("mods/noita.fairmod/files/content/payphone/content/bowling/prop_pin.xml",x-64,y-192)
EntityLoad("mods/noita.fairmod/files/content/payphone/content/bowling/prop_pin.xml",x+64,y-192)

EntityLoad("mods/noita.fairmod/files/content/payphone/content/bowling/prop_bowling_ball.xml",x,y-256)
