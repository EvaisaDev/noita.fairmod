
local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform(entity_id)

LoadRagdoll("data/ragdolls/player/filenames.txt", x, y)
EntityKill(entity_id)
