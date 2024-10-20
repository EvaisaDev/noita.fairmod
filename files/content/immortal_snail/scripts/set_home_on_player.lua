dofile("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()

local players = get_players()

if players and #players ~= 0 then
	local player = players[1]

	local player_x, player_y = EntityGetTransform(player)

	local ai_component = EntityGetFirstComponent(entity_id, "AnimalAIComponent")

	ComponentSetValue2(ai_component, "mHomePosition", player_x, player_y)

	local entity_x, entity_y = EntityGetTransform(entity_id)

	local distance = math.sqrt((player_x - entity_x) ^ 2 + (player_y - entity_y) ^ 2)

	ComponentSetValue2(ai_component, "max_distance_to_move_from_home", distance + 10)
end
