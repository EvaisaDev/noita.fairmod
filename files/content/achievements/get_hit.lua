damage_history = damage_history or {}

-- Script to catch events on the player for achievements
function damage_received(damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible)
	if EntityHasTag(projectile_thats_responsible, "snowball") then GameAddFlagRun("fairmod_snowball_hit") end


    if damage > 0 then
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
		
		print(total_damage * 25)

        -- If the copibuddy flag is set and total damage is above 10, trigger the copibuddy event
        if GameHasFlagRun("copibuddy") and total_damage * 25 > 5 then
			print("skill issue")
            GameAddFlagRun("copibuddy.just_took_damage")
        end
    end
end
