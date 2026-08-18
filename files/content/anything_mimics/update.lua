dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")

local player = GetPlayers()[1]
if player == nil then return end

local min_distance_sq = 100 ^ 2

local x, y = EntityGetTransform(player)

local entities_close = {}
local entities_all = EntityGetInRadius(x, y, 500)

local runner_tag = "mimic"

for _, entity in ipairs(entities_all) do
	if EntityGetRootEntity(entity) == entity then
		if not EntityHasTag(entity, runner_tag) and not EntityHasTag(entity, "no_spiders") then
			local ex, ey = EntityGetTransform(entity)
			local distance_sq = (ex - x) ^ 2 + (ey - y) ^ 2

			local item_comp = EntityGetFirstComponent(entity, "ItemComponent")
			local physics_body_comp = EntityGetFirstComponent(entity, "PhysicsBodyComponent")
			local physics_body2_comp = EntityGetFirstComponent(entity, "PhysicsBody2Component")
			local projectile_comp = EntityGetFirstComponent(entity, "ProjectileComponent")
			if item_comp ~= nil or physics_body_comp or physics_body2_comp then
				if distance_sq < min_distance_sq then table.insert(entities_close, entity) end
			elseif projectile_comp ~= nil then
				table.insert(entities_close, entity)
			end
		end
	end
	::continue::
end

local to_clean = EntityGetWithTag(runner_tag) or {}
for _, entity in ipairs(to_clean) do
	if EntityGetRootEntity(entity) ~= entity then
		local children = EntityGetAllChildren(entity) or {}
		for _, child in ipairs(children) do
			if EntityHasTag(child, "runner_ai") then
				EntityRemoveFromParent(child)
				EntityKill(child)
			end
		end
		EntityRemoveTag(entity, runner_tag)
	end
end

local mimic_chance = 5 -- only every 4 frames

if ModSettingGet("noita.fairmod.arachnophilia_mode") then mimic_chance = 50 end

for _, entity in ipairs(entities_close) do
	if math.random(0, 100) <= mimic_chance then
		local entity_x, entity_y = EntityGetTransform(entity)
		--EntityLoad( "data/entities/particles/polymorph_explosion.xml", entity_x, entity_y )
		--GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/polymorph/create", entity_x, entity_y );
		local ai_entity = EntityLoad("mods/noita.fairmod/files/content/anything_mimics/files/runner_ai.xml", entity_x, entity_y)
		EntityAddChild(entity, ai_entity)
	end
	EntityAddTag(entity, runner_tag)
end
