--- @diagnostic disable: missing-global-doc

function damage_received(damage, desc, entity_who_caused, is_fatal)
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform(GetUpdatedEntityID())

	SetRandomSeed(GameGetFrameNum(), x + y + entity_id)

	local dmg_comp = EntityGetFirstComponent(entity_id, "DamageModelComponent")
	if not dmg_comp then return end
	local health = ComponentGetValue2(dmg_comp, "hp")

	if health > 0.3 and health - damage < 0.3 then
		local entity_file = EntityGetFilename(entity_id)
		for _ = 1, 3 do
			local offset_x = Random(-10, 10)
			local offset_y = Random(-10, 10)

			local e = EntityLoad(entity_file, x + offset_x, y + offset_y)

			local new_dmg_comp = EntityGetFirstComponent(e, "DamageModelComponent")
			if new_dmg_comp then
				ComponentSetValue2(new_dmg_comp, "invincibility_frames", 10)
			end
			GameAddFlagRun("FAIRMOD_GIANTSHOOTER_KILLED")
		end
	end
end
