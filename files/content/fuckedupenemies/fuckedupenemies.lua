-- Eba made this
-- Makes enemies very fucked up and evil.
-- Idk
local effects = { "BERSERK", "REGENERATION", "REGENERATION", "BREATH_UNDERWATER", "WET", "BLOODY",
	"CRITICAL_HIT_BOOST", "MELEE_COUNTER", "KNOCKBACK", "KNOCKBACK", "KNOCKBACK_IMMUNITY",
	"KNOCKBACK_IMMUNITY", "MOVEMENT_FASTER", "STAINS_DROP_FASTER", "SAVING_GRACE",
	"DAMAGE_MULTIPLIER", "RESPAWN", "PROTECTION_FIRE", "PROTECTION_RADIOACTIVITY",
	"PROTECTION_EXPLOSION", "PROTECTION_MELEE", "PROTECTION_ELECTRICITY", "TELEPORTITIS",
	"TELEPORTITIS", "TELEPORTITIS", "STAINLESS_ARMOUR", "NO_SLIME_SLOWDOWN", "MOVEMENT_FASTER_2X",
	"LOW_HP_DAMAGE_BOOST", "MOVEMENT_FASTER_2X", "LOW_HP_DAMAGE_BOOST", "STUN_PROTECTION_ELECTRICITY",
	"STUN_PROTECTION_FREEZE", "PROTECTION_ALL", "INVISIBILITY", "INVISIBILITY", "INVISIBILITY",
	"PROTECTION_DURING_TELEPORT", "PROTECTION_POLYMORPH", "PROTECTION_FREEZE", "FROZEN_SPEED_UP",
	"RAINBOW_FARTS", }

--- @class fuckupenemies
local evil = {
	scanned = {}
}

function evil:TweakDamageModel(enemy, damage_model)
	local hp = ComponentGetValue2(damage_model, "hp")
	local max_hp = ComponentGetValue2(damage_model, "max_hp")
	local hp_mult = 5
	ComponentSetValue2(damage_model, "attack_ranged_entity_count_min", hp * hp_mult)
	ComponentSetValue2(damage_model, "attack_ranged_entity_count_max", max_hp * hp_mult)
	local ex, ey, er, sx, sy = EntityGetTransform(enemy)
	EntitySetTransform(enemy, ex, ey, er, sx * 1.2, sy * 1.2)
	-- todo add particles

	for _ = 1, 3 do
		local comp = GetGameEffectLoadTo(enemy, effects[math.random(1, #effects)], true)
		ComponentSetValue2(comp, "frames", -1)
	end
end

function evil:ItemPickUpperComponent(enemy)
	local item_pickupper_component = EntityGetFirstComponentIncludingDisabled(enemy, "ItemPickUpperComponent")
	if item_pickupper_component then
		ComponentSetValue2(item_pickupper_component, "is_in_npc", true)
		ComponentSetValue2(item_pickupper_component, "pick_up_any_item_buggy", true)
		ComponentSetValue2(item_pickupper_component, "is_immune_to_kicks", false)
		ComponentSetValue2(item_pickupper_component, "drop_items_on_death", true)
		return
	end
	EntityAddComponent2(enemy, "ItemPickUpperComponent", {
		is_in_npc = true,
		pick_up_any_item_buggy = true,
		is_immune_to_kicks = false,
		drop_items_on_death = true,
	})
end

function evil:TweakAnimalComponent(headache, animal_ai)
	ComponentSetValue2(animal_ai, "defecates_and_pees", math.random(1, 50) == 1)
	ComponentSetValue2(animal_ai, "attack_only_if_attacked", false)
	ComponentSetValue2(animal_ai, "creature_detection_range_x", 200)
	ComponentSetValue2(animal_ai, "creature_detection_range_y", 200)
	ComponentSetValue2(animal_ai, "creature_detection_angular_range_deg", 180)
	ComponentSetValue2(animal_ai, "aggressiveness_min", 100)
	ComponentSetValue2(animal_ai, "aggressiveness_max", 100)
	ComponentSetValue2(animal_ai, "attack_melee_enabled", true)
	ComponentSetValue2(animal_ai, "attack_dash_enabled", true)
	local melee_damage_min = ComponentGetValue2(animal_ai, "attack_melee_damage_min")
	local melee_damage_max = ComponentGetValue2(animal_ai, "attack_melee_damage_max")
	local attack_dash_damage = ComponentGetValue2(animal_ai, "attack_dash_damage")
	local attack_dash_speed = ComponentGetValue2(animal_ai, "attack_dash_speed")
	local attack_dash_distance = ComponentGetValue2(animal_ai, "attack_dash_distance")
	local damage_mult = headache and 10 or 3
	ComponentSetValue2(animal_ai, "attack_melee_damage_min", melee_damage_min * damage_mult)
	ComponentSetValue2(animal_ai, "attack_melee_damage_max", melee_damage_max * damage_mult)
	ComponentSetValue2(animal_ai, "attack_dash_damage", attack_dash_damage * damage_mult)
	ComponentSetValue2(animal_ai, "attack_dash_speed", attack_dash_speed * damage_mult)
	ComponentSetValue2(animal_ai, "attack_dash_distance", attack_dash_distance * damage_mult)
	local attack_ranged_use_laser_sight = ComponentGetValue2(animal_ai, "attack_ranged_use_laser_sight")
	local attack_ranged_predict = ComponentGetValue2(animal_ai, "attack_ranged_predict")
	local attack_ranged_entity_count_min = ComponentGetValue2(animal_ai, "attack_ranged_entity_count_min")
	local attack_ranged_entity_count_max = ComponentGetValue2(animal_ai, "attack_ranged_entity_count_max")
	ComponentSetValue2(animal_ai, "attack_ranged_use_laser_sight",
		attack_ranged_use_laser_sight or math.random(1, 100) > 13)
	ComponentSetValue2(animal_ai, "attack_ranged_predict", attack_ranged_predict or math.random(1, 3) ==
		1)
	ComponentSetValue2(animal_ai, "attack_ranged_entity_count_min",
		attack_ranged_entity_count_min * damage_mult)
	ComponentSetValue2(animal_ai, "attack_ranged_entity_count_max",
		attack_ranged_entity_count_max * damage_mult)
end

function evil:BuffEnemy(enemy)
	self.scanned[enemy] = true

	local ex, ey = EntityGetTransform(enemy)
	SetRandomSeed(ex, ey)
	-- Copious bullshit ensues
	local headache = (math.random(0, 10000) / 100) <= 2
	-- Chicanery ends

	local animal_ai = EntityGetFirstComponentIncludingDisabled(enemy, "AnimalAIComponent")
	if animal_ai then
		self:TweakAnimalComponent(headache, animal_ai)
		self:ItemPickUpperComponent(enemy)
	end

	local damage_model = EntityGetFirstComponentIncludingDisabled(enemy, "DamageModelComponent")
	if damage_model and headache then
		self:TweakDamageModel(enemy, damage_model)
	end
end

function evil:OnWorldPreUpdate()
	local enemies = EntityGetWithTag("enemy")

	for _, enemy in ipairs(enemies) do
		if not evil.scanned[enemy] then
			self:BuffEnemy(enemy)
		end
	end
end

return evil
