function damage_received( damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible )

    if message == "$damage_physicshit" then
		if(GameHasFlagRun("hard_hat_worn"))then
			local entity_id = GetUpdatedEntityID()
			local name = EntityGetName(entity_id)
			local damageModelComponent = EntityGetFirstComponentIncludingDisabled( entity_id, "DamageModelComponent" )
			if damageModelComponent ~= nil then
				local health = ComponentGetValue2( damageModelComponent, "hp" )
				if health - damage <= 0 then
					ComponentSetValue2( damageModelComponent, "hp", damage + 0.04 )
				end
			end
		else
			local entity_id = GetUpdatedEntityID()
			local name = EntityGetName(entity_id)

			local x, y = EntityGetTransform(entity_id)

			SetRandomSeed(x + GameGetFrameNum(), y)

			local damageModelComponent = EntityGetFirstComponentIncludingDisabled( entity_id, "DamageModelComponent" )
			if damageModelComponent ~= nil then
				local health = ComponentGetValue2( damageModelComponent, "hp" )
				if(Random(0, 100) < 20 or health - damage <= 0)then
					AddFlagPersistent("should_wear_hardhat")
					print("You should wear a hard hat!")
				end
			end
		end
    end
end