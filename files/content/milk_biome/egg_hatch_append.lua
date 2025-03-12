local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

GameCreateParticle("fairmod_egg_white", x, y, 30, 10, 10, false, true, true)
