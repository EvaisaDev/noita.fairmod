local entity_id = GetUpdatedEntityID()

IngestionComp = EntityGetFirstComponent(entity_id, "IngestionComponent")
if IngestionComp then
	local ingestion_size = ComponentGetValue2(IngestionComp, "ingestion_size")
	local ingestion_capacity = ComponentGetValue2(IngestionComp, "ingestion_capacity")

	local min = ingestion_capacity / 2
	local max = ingestion_capacity * 2

	if ingestion_size >= min then
		local percentage = (ingestion_size - min) / (max - min)

		local chance = math.floor(108000 * (1 - percentage))

		SetRandomSeed(math.random() + entity_id, GameGetFrameNum() + GetUpdatedComponentID())
		if Random(1, chance) == 1 then
			--GamePrint(tostring(GameGetFrameNum()))
			local x, y = EntityGetTransform(entity_id)
			-- we do a little murdering
			for i = 1, 100 do
				EntityInflictDamage( entity_id, 99999999999999999999999999999999999999999999999999999999999999999, "DAMAGE_PHYSICS_BODY_DAMAGED", "Heart Attack!", "NORMAL", 0, 0, entity_id, x, y, 0.1 )
			end
			EntityKill(entity_id)
			GameAddFlagRun("heart_attacked")
		end
	end
end
