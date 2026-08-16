local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform(entity_id)
if InputIsKeyJustDown(8) then
    EntityInflictDamage(entity_id, 100, "NONE", "Self-destruct", "NO_RAGDOLL_FILE", 0, 0)
    EntityLoad("data/entities/projectiles/explosion.xml", x, y)
end