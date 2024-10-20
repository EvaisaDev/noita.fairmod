local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local kill_radius = 5

local last_player_to_kill = nil
local last_player_to_kill_time = 0

if
	last_player_to_kill ~= nil
	and GameGetFrameNum() - last_player_to_kill_time > 10
	and EntityGetIsAlive(last_player_to_kill)
then
	EntityKill(last_player_to_kill)
end

local nearby_players = EntityGetInRadiusWithTag(x, y, kill_radius, "player_unit") or {}

if #nearby_players <= 0 then
	nearby_players = EntityGetInRadiusWithTag(x, y, kill_radius, "player_polymorphed") or {}
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

	last_player_to_kill = player
	last_player_to_kill_time = GameGetFrameNum()
end
