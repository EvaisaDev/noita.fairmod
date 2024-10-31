-- stylua: ignore start
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
GamePlaySound("data/audio/Desktop/explosion.bank", "explosions/holy", x, y)
for i = 1, 100 do
	EntityInflictDamage( entity_id, 99999999999999999999999999999999999999999999999999999999999999999, "DAMAGE_PHYSICS_BODY_DAMAGED", "KACHOW!!!", "DISINTEGRATED", 0, 0, entity_id, x, y, 0.1 )
end
EntityKill(entity_id)
-- stylua: ignore end
