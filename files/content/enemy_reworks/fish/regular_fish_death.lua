local helper = dofile_once("mods/noita.fairmod/files/content/enemy_reworks/death_helper.lua") --- @type enemy_reworks_helper

--- Hellish creature if killed by player
--- @type script_death
local script_death = function(damage_type_bit_field, damage_message, entity_thats_responsible, drop_items)
	if not EntityGetIsAlive(entity_thats_responsible) then return end

	if helper:is_player_kill(entity_thats_responsible) then
		local value = tonumber(GlobalsGetValue("fairmod_fish_killed")) or 0
		GlobalsSetValue("fairmod_fish_killed", tostring(value + 1))
	end
end
death = script_death
