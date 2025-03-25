local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

EntityLoad("mods/noita.fairmod/files/content/hamis_biome/hamis_ending/midas_hamis.xml", x, y)

EntityLoad("data/entities/animals/boss_centipede/ending/midas_sand.xml", x, y)
EntityLoad("data/entities/animals/boss_centipede/ending/midas_chunks.xml", x, y)
GamePlaySound("data/audio/Desktop/event_cues.bank", "event_cues/midas_above/create", x, y)

-- EntityLoad("mods/noita.fairmod/files/content/cauldron/player_killer.xml", x, y)

GameAddFlagRun("ending_game_completed")
-- GameAddFlagRun("poop_ending")

local world_entity_id = GameGetWorldStateEntity()
if world_entity_id then
	local comp_worldstate = EntityGetFirstComponent(world_entity_id, "WorldStateComponent")
	if comp_worldstate then ComponentSetValue2(comp_worldstate, "INFINITE_GOLD_HAPPENING", true) end
end

local player_id = EntityGetWithTag("player_unit")[1]
if not player_id then return end
local children = EntityGetAllChildren(player_id) or {}
for _, child in ipairs(children) do
	local game_effect_comp = EntityGetFirstComponent(child, "GameEffectComponent")
	if game_effect_comp and ComponentGetValue2(game_effect_comp, "effect"):find("PROTECTION") then EntityKill(child) end
end

local spawner = EntityLoad("mods/noita.fairmod/files/content/hamis_biome/hamis_ending/hamis_spawner.xml", x, y)
EntityAddChild(player_id, spawner)
