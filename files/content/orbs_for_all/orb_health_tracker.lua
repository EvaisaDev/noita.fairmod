dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()

local function get_scaled_health(health, orb_count)
	-- thank you Heinermann
	return health + 2 ^ orb_count + orb_count * (health / 3)
end

local last_orb_comp = get_variable_storage_component(entity_id, "fairmod_orbs")
local last_orb_count = ComponentGetValue2(last_orb_comp, "value_int")
local orb_count = GameGetOrbCountThisRun()

-- short circuit if it doesn't need updating
if orb_count == last_orb_count then return end

-- set its new max health
local max_hp_comp = get_variable_storage_component(entity_id, "fairmod_max_hp")
local original_max_hp = ComponentGetValue2(max_hp_comp, "value_float")

local dmg_comp = EntityGetFirstComponent(entity_id, "DamageModelComponent")
if dmg_comp == nil then return end

local old_max_hp = ComponentGetValue2(dmg_comp, "max_hp")
local new_max_hp = get_scaled_health(original_max_hp, orb_count)
ComponentSetValue2(dmg_comp, "max_hp", new_max_hp)

-- scale up the enemy's current health
local current_hp = ComponentGetValue2(dmg_comp, "hp")
ComponentSetValue2(dmg_comp, "hp", current_hp * new_max_hp / old_max_hp)
