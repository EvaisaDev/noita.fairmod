local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local kill_radius = 5

local player_killed_by_snail = tonumber(GlobalsGetValue("PlayerKilledBySnail", "0"))

if player_killed_by_snail ~= 0 and EntityGetIsAlive(player_killed_by_snail)then
	EntityKill(player_killed_by_snail)
	return
end

local nearby_players = EntityGetInRadiusWithTag(x, y, kill_radius, "player_unit") or {}

if #nearby_players <= 0 then
	nearby_players = EntityGetInRadiusWithTag(x, y, kill_radius, "polymorphed_player") or {}
end

for i, player in ipairs(nearby_players) do
	EntityRemoveStainStatusEffect(player, "PROTECTION_ALL", 1)
	local damage_model_comp = EntityGetFirstComponentIncludingDisabled(player, "DamageModelComponent")
	if damage_model_comp then
		ComponentSetValue2(damage_model_comp, "hp", 1)
		ComponentSetValue2(damage_model_comp, "wait_for_kill_flag_on_death", false)
		ComponentSetValue2(damage_model_comp, "invincibility_frames", 0)
	end

	EntityInflictDamage(player, 1000, "DAMAGE_CURSE", "immortal_snail", "BLOOD_EXPLOSION", 0, 0, entity_id)

	local px, py = EntityGetTransform(player)

	SetRandomSeed(px, py)

	local count = Random(3, 5)
	-- spawn guts
	for i = 1, count do
		EntityLoad("mods/noita.fairmod/files/content/stalactite/entities/guts/guts" .. Random(1, 5) .. ".xml", px, py)
	end

	GlobalsSetValue("PlayerKilledBySnail", tostring(player))
end
