local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local players = EntityGetInRadiusWithTag(x, y, 9, "player_unit") or {}

for k, v in ipairs(players)do
	local player_id = v
	local px, py = EntityGetTransform(player_id)

	EntityInflictDamage(player_id, 100000, "DAMAGE_PHYSICS_HIT", "Stalactite", "BLOOD_EXPLOSION", 0, 0, entity_id, x, y, 0.1)
end