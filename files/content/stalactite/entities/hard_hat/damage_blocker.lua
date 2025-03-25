function damage_received( damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible )

    if message == "$damage_physicshit" then
		if(GameHasFlagRun("hard_hat_worn"))then
			local entity_id = GetUpdatedEntityID()
			local damageModelComponent = EntityGetFirstComponentIncludingDisabled(entity_id, "DamageModelComponent")
			if damageModelComponent ~= nil then
				local health = ComponentGetValue2(damageModelComponent, "hp")
				local new_pre_damage_hp
				if health - (damage * 0.2) >= 0.04 then
					new_pre_damage_hp = health + (damage * 0.8)
				else
					new_pre_damage_hp = damage + 0.04
				end
				ComponentSetValue2(damageModelComponent, "hp", new_pre_damage_hp)
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