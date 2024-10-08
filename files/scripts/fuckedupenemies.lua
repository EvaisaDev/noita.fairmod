-- Eba made this
-- Makes enemies very fucked up and evil.
-- Idk

local evil = {}

local function MergeTables(...)
	local tables = {...}
	local out = {}
	for _,t in ipairs(tables) do
		for k,v in pairs(t) do
			out[k] = v
		end
	end
	return out
end

local function GetPlayers()
	return MergeTables(EntityGetWithTag("player_unit") or {}, EntityGetWithTag("polymorphed_player") or {}) or {}
end

local function GetEnemiesInRadius(x, y, radius)
	local entities = MergeTables(EntityGetInRadiusWithTag(x, y, radius, "enemy"), EntityGetInRadiusWithTag(x, y, radius, "boss"))
	
	return entities
end

function evil.OnWorldPreUpdate()

	if(GameGetFrameNum() % 30 ~= 0)then
		return
	end

	local players = GetPlayers()
	
	for i, v in ipairs(players)do
		local x, y = EntityGetTransform(v)
		local enemies = GetEnemiesInRadius(x, y, 300)

		for _, enemy in ipairs(enemies)do
			if(not EntityHasTag(enemy, "modified_evil"))then
				local animal_ai = EntityGetFirstComponentIncludingDisabled(enemy, "AnimalAIComponent")

				if(animal_ai)then
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
					local damage_mult = 3
					ComponentSetValue2(animal_ai, "attack_melee_damage_min", melee_damage_min * damage_mult)
					ComponentSetValue2(animal_ai, "attack_melee_damage_max", melee_damage_max * damage_mult)
					ComponentSetValue2(animal_ai, "attack_dash_damage", attack_dash_damage * damage_mult)
					ComponentSetValue2(animal_ai, "attack_dash_speed", attack_dash_speed * damage_mult)
					ComponentSetValue2(animal_ai, "attack_dash_distance", attack_dash_distance * damage_mult)
					local attack_ranged_entity_count_min = ComponentGetValue2(animal_ai, "attack_ranged_entity_count_min")
					local attack_ranged_entity_count_max = ComponentGetValue2(animal_ai, "attack_ranged_entity_count_max")
					ComponentSetValue2(animal_ai, "attack_ranged_entity_count_min", attack_ranged_entity_count_min * damage_mult)
					ComponentSetValue2(animal_ai, "attack_ranged_entity_count_max", attack_ranged_entity_count_max * damage_mult)
				end
				
				EntityAddTag(enemy, "modified_evil")
			end
		end

	end
end

return evil