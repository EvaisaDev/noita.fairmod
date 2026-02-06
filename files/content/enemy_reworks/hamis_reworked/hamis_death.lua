local helper = dofile_once("mods/noita.fairmod/files/content/enemy_reworks/death_helper.lua") --- @type enemy_reworks_helper

local hamisits = {
	"data/ragdolls/longleg/head",
	"data/ragdolls/longleg/leg1",
	"data/ragdolls/longleg/foot1",
	"data/ragdolls/longleg/leg2",
	"data/ragdolls/longleg/foot2",
	"data/ragdolls/longleg/leg3",
	"data/ragdolls/longleg/foot3",
}

local function hamis_land(kill_count)
	local hamis = GetUpdatedEntityID()
	local damage_model = EntityGetFirstComponent(hamis, "DamageModelComponent")
	if not damage_model then return end
	ComponentSetValue2(damage_model, "ragdoll_fx_forced", "NO_RAGDOLL_FILE")
	local x, y = EntityGetTransform(hamis)

	for i = 1, kill_count do
		local allhamis = EntityGetWithTag( "spawned_hamis" )
		if ( #allhamis < 50 ) then
			for j, body_part in ipairs(hamisits) do
				SetRandomSeed(x + j, y + i)
				local x_off = Random(-10, 10)
				SetRandomSeed(x + i, y + j)
				local y_off = Random(-10, 10)
				EntityLoad("mods/noita.fairmod/vfs/hamis/" .. body_part .. "/longleg.xml", x + x_off, y + y_off)
			end
		end
	end

	GamePlaySound("data/audio/Desktop/animals.bank", "animals/ghost/death", x, y)
	GameCreateParticle("blood", x, y, 50, 100, 100, false)
	GameCreateParticle("material_darkness", x, y, 10, 10, 10, false)
end



--- Only accept damage from the player
--- @type script_damage_about_to_be_received
local script_damage_about_to_be_received = function(damage, x, y, entity_thats_responsible, critical_hit_chance)
	if entity_thats_responsible and entity_thats_responsible ~= 0 and (
			EntityHasTag(entity_thats_responsible, "player_unit") or
			EntityHasTag(entity_thats_responsible, "polymorphed_player")
 			) then
		return damage,critical_hit_chance
	end
	return 0,0
end
damage_about_to_be_received = script_damage_about_to_be_received


--- Sets flag if was damaged by player
--- @type script_damage_received
local script_damage_received = function(damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible)
	if not EntityGetIsAlive(entity_thats_responsible) then return end

	if helper.is_player_kill(entity_thats_responsible) then SetValueBool("fairmod_damaged_by_player", true) end
end
damage_received = script_damage_received

--- Hellish creature if killed by player
--- @type script_death
local script_death = function(damage_type_bit_field, damage_message, entity_thats_responsible, drop_items)
	local kill_count = (tonumber(GlobalsGetValue("FAIRMOD_HAMIS_KILLED", "0")) or 0) + 1
	if GetValueBool("fairmod_damaged_by_player", false) then GlobalsSetValue("FAIRMOD_HAMIS_KILLED", tostring(kill_count)) end

	hamis_land(kill_count)
end
death = script_death
