dofile("data/scripts/lib/utilities.lua")
dofile("data/scripts/gun/procedural/gun_action_utils.lua")

function get_random_from(target)
	local rnd = Random(1, #target)

	return tostring(target[rnd])
end

function get_multiple_random_from(target, amount_)
	local amount = amount_ or 1

	local result = {}

	for i = 1, amount do
		local rnd = Random(1, #target)

		table.insert(result, tostring(target[rnd]))
	end

	return result
end

function get_random_between_range(target)
	local minval = target[1]
	local maxval = target[2]

	return Random(minval, maxval)
end

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
SetRandomSeed(x, y + GameGetFrameNum())

local ability_comp = EntityGetFirstComponent(entity_id, "AbilityComponent")

local gun = {}
gun.name = { "Salmon" }
gun.deck_capacity = 1
gun.actions_per_round = 1
gun.reload_time = 45
gun.shuffle_deck_when_empty = 0
gun.fire_rate_wait = { 45, 45 }
gun.spread_degrees = 0
gun.speed_multiplier = 10
gun.mana_charge_speed = { 100, 400 }
gun.mana_max = { 300, 400 }
gun.actions = { "WATER_BEAM" }

local mana_max = get_random_between_range(gun.mana_max)
local deck_capacity = gun.deck_capacity

ComponentSetValue(ability_comp, "ui_name", get_random_from(gun.name))

ComponentObjectSetValue(ability_comp, "gun_config", "reload_time", gun.reload_time)
ComponentObjectSetValue(ability_comp, "gunaction_config", "fire_rate_wait", get_random_between_range(gun.fire_rate_wait))
ComponentSetValue(ability_comp, "mana_charge_speed", get_random_between_range(gun.mana_charge_speed))

ComponentObjectSetValue(ability_comp, "gun_config", "actions_per_round", gun.actions_per_round)
ComponentObjectSetValue(ability_comp, "gun_config", "deck_capacity", deck_capacity)
ComponentObjectSetValue(ability_comp, "gun_config", "shuffle_deck_when_empty", gun.shuffle_deck_when_empty)
ComponentObjectSetValue(ability_comp, "gunaction_config", "spread_degrees", gun.spread_degrees)
ComponentObjectSetValue(ability_comp, "gunaction_config", "speed_multiplier", gun.speed_multiplier)

ComponentSetValue(ability_comp, "mana_max", mana_max)
ComponentSetValue(ability_comp, "mana", mana_max)

AddGunActionPermanent(entity_id, "WATER_BEAM")

local action_count = 0
local gun_action = get_random_from(gun.actions)

for i = 1, action_count do
	--AddGunActionPermanent( entity_id, gun_action )
	AddGunAction(entity_id, gun_action)
end

local item_comp = EntityGetFirstComponent(entity_id, "ItemComponent")
ComponentSetValue2(item_comp, "item_name", "$fairmod_rat_wand")
ComponentSetValue2(item_comp, "always_use_item_name_in_ui", true)
