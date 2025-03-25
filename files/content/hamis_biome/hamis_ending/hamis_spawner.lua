local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local hamis_list = {
	"data/entities/animals/longleg.xml",
	"mods/noita.fairmod/files/content/hamis_biome/entities/lamp_hamis/lamp_hamis.xml",
	-- "mods/noita.fairmod/files/content/hamis_biome/entities/nest_spawner/nest_spawner.xml",
}

SetRandomSeed(x, y + GameGetFrameNum())
EntityLoad(hamis_list[Random(1, #hamis_list)], x + Random(-15, 15), y + Random(0, 30))
