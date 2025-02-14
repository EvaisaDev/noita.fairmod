local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local kill_radius = 5
local status_clear_radius = 50

local snail_timeout = tonumber(GlobalsGetValue("SnailTimeout", "0"))

if snail_timeout > 0 then
	local snail_timeout_frame = tonumber(GlobalsGetValue("SnailTimeoutFrame", "0"))
	if GameGetFrameNum() > snail_timeout_frame then
		snail_timeout = snail_timeout - 1
		GlobalsSetValue("SnailTimeout", tostring(snail_timeout))
		GlobalsSetValue("SnailTimeoutFrame", tostring(GameGetFrameNum()))
	end
	return
end

local nearby_players = EntityGetInRadiusWithTag(x, y, kill_radius, "player_unit") or {}

if #nearby_players <= 0 then 
	nearby_players = EntityGetInRadiusWithTag(x, y, kill_radius, "polymorphed_player") or {}
end

local clearable_players = EntityGetInRadiusWithTag(x, y, status_clear_radius, "player_unit") or {}

if #clearable_players <= 0 then 
	clearable_players = EntityGetInRadiusWithTag(x, y, status_clear_radius, "polymorphed_player") or {}
end

for _, player in ipairs(clearable_players) do
	-- vvvvvvv This line causes an insta crash if entity is unstable polymorphed
	--EntityRemoveStainStatusEffect(player, "PROTECTION_ALL", 1)
	-- ^^^^^^^
	local children = EntityGetAllChildren(player) or {}
	for _, child in ipairs(children) do
		local game_effect_comp = EntityGetFirstComponent(child, "GameEffectComponent")
		if game_effect_comp and ComponentGetValue2(game_effect_comp, "effect") == "PROTECTION_ALL" then
			EntityKill(child)
		end
	end
end

for _, player in ipairs(nearby_players) do

	local hp = 100 / 25
	local damage_model_comp = EntityGetFirstComponentIncludingDisabled(player, "DamageModelComponent")
	if damage_model_comp then
		ComponentSetValue2(damage_model_comp, "wait_for_kill_flag_on_death", false)
		ComponentSetValue2(damage_model_comp, "invincibility_frames", 0)
		hp = ComponentGetValue2(damage_model_comp, "hp")
	end

	EntityInflictDamage(player, hp * 100, "DAMAGE_CURSE", "immortal_snail", "BLOOD_EXPLOSION", 0, 0, entity_id)

	local px, py = EntityGetTransform(player)

	SetRandomSeed(px, py)

	local count = Random(3, 5)
	-- spawn guts
	for i = 1, count do
		EntityLoad("mods/noita.fairmod/files/content/stalactite/entities/guts/guts" .. Random(1, 5) .. ".xml", px, py)
	end

	GlobalsSetValue("SnailTimeout", tostring(120))
end
