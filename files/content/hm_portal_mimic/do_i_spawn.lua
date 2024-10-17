dofile_once("data/scripts/lib/utilities.lua")

local portal = GetUpdatedEntityID()
local x, y = EntityGetTransform(portal)

SetRandomSeed(x, y + tonumber(StatsGetValue("world_seed")))

local doidoit = Random(1, 75)

if doidoit <= 5 then
	EntityLoad("data/entities/animals/noita.fairmod_hm_portal_mimic.xml", x, y)
	EntityKill(portal)
end
