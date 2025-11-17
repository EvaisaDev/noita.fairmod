local files = {
	"data/entities/projectiles/tnt.xml",
	"mods/noita.fairmod/files/content/new_spells/bad_bombs/tnt.xml",
	"mods/noita.fairmod/files/content/new_spells/bad_bombs/tnt_long.xml",
}

local max = 40
local radius = 20

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local entities_all = EntityGetInRadius(x, y, radius)
local count = #entities_all

if count < max then
	SetRandomSeed(x, y + count)
	local file = files[Random(1, #files)]
	EntityLoad(file, x + Random(-10, 10), y + Random(-5, 0))
end

EntityKill(entity_id)
