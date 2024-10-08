local entity_id = GetUpdatedEntityID()
SetRandomSeed(math.random()+entity_id, GameGetFrameNum()+GetUpdatedComponentID())
if Random(1,216000) == 1 then
	GamePrint(tostring(GameGetFrameNum()))
	local x, y = EntityGetTransform(entity_id)
	-- we do a little murdering
	for i=1, 100 do
		EntityInflictDamage(entity_id, 99999999999999999999999999999999999999999999999999999999999999999, "DAMAGE_PHYSICS_BODY_DAMAGED", "Heart Attack!", "NORMAL", 0, 0, entity_id, x, y, 0.1)
	end
	EntityKill(entity_id)
end