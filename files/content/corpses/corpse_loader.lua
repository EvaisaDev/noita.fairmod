
local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform(entity_id)

GameCreateParticle("blood", x, y, ProceduralRandom(x, y, 10, 40), 0, 0, false)
LoadRagdoll("data/ragdolls/player/filenames.txt", x, y)
EntityKill(entity_id)
