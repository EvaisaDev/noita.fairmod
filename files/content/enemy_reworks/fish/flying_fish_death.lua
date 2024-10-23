--- @diagnostic disable: unused-local, missing-global-doc, undefined-global
dofile_once("data/scripts/biomes/temple_shared.lua")

function death(damage_type_bit_field, damage_message, entity_thats_responsible, drop_items)
	local value = tonumber(GlobalsGetValue("fairmod_fish_killed")) or 0
	if value < 2 then return end

	local dead_fish = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform(dead_fish)

	if GlobalsGetValue("TEMPLE_PEACE_WITH_GODS") == "1" then
		GamePrintImportant("$logdesc_temple_peace_temple_break", "")
		GamePlaySound("data/audio/Desktop/event_cues.bank", "event_cues/angered_the_gods/create", pos_x, pos_y)
		return
	end

	local leak_name = "TEMPLE_LEAKED_" .. temple_pos_to_id(pos_x, pos_y)

	-- spawn workshop guard
	if GlobalsGetValue("TEMPLE_SPAWN_GUARDIAN") ~= "1" then temple_spawn_guardian(pos_x, pos_y) end

	GlobalsSetValue("TEMPLE_SPAWN_GUARDIAN", "1")

	if GlobalsGetValue(leak_name) ~= "1" then
		if tonumber(GlobalsGetValue("STEVARI_DEATHS", "0")) < 3 then
			GamePrintImportant("$logdesc_temple_spawn_guardian", "")
		else
			GamePrintImportant("$logdesc_gods_are_very_angry", "")
			GameGiveAchievement("GODS_ENRAGED")
		end
		GamePlaySound("data/audio/Desktop/event_cues.bank", "event_cues/angered_the_gods/create", pos_x, pos_y)
	end

	GlobalsSetValue(leak_name, "1")
end
