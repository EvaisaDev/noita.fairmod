damage_history = damage_history or {}

-- Script to catch events on the player for achievements
function damage_received(damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible)
	if EntityHasTag(projectile_thats_responsible, "snowball") then GameAddFlagRun("fairmod_snowball_hit") end

	local entity_id = GetUpdatedEntityID()

    if damage > 0 and not GameHasFlagRun("copibuddy.pause_damage_check") then
		local current_frame = GameGetFrameNum()

        -- Record this damage event with the current frame number
        table.insert(damage_history, {frame = current_frame, damage = damage})

        -- Remove events older than 60 frames
        for i = #damage_history, 1, -1 do
            if current_frame - damage_history[i].frame > 240 then
                table.remove(damage_history, i)
            end
        end

        -- Sum the damage from the past 60 frames
        local total_damage = 0
        for _, event in ipairs(damage_history) do
            total_damage = total_damage + event.damage
        end

        -- If the copibuddy flag is set and total damage is above 10, trigger the copibuddy event
        if GameHasFlagRun("copibuddy") and total_damage * 25 > 5 then
			print("skill issue")
            GameAddFlagRun("copibuddy.just_took_damage")
        end
    end

	if(damage > 0)then
		local damage_model = EntityGetFirstComponentIncludingDisabled(entity_id, "DamageModelComponent")
		if(damage_model)then
			local hp = ComponentGetValue2(damage_model, "hp")
			local max_hp = ComponentGetValue2(damage_model, "max_hp")
			local max_hp_cap = ComponentGetValue2(damage_model, "max_hp_cap")
			-- check if hp - damage is under 10% of max hp and current hp is above 10% of max hp

			print("hp: " .. tostring(hp) .. " max_hp: " .. tostring(max_hp) .. " max_hp_cap: " .. tostring(max_hp_cap))
			print("hp - damage: " .. tostring(hp - damage) .. " max_hp * 0.1: " .. tostring(max_hp * 0.1) .. " hp > max_hp * 0.1: " .. tostring(hp > max_hp * 0.1))

			if(hp - damage < max_hp * 0.2 and hp > max_hp * 0.2)then
				GameAddFlagRun("copibuddy.almost_died_clearly")
			end
		end
	end
end
