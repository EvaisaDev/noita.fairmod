local M = {}

---@param player_entity entity_id
function M.OnPlayerSpawned(player_entity)
	EntityAddComponent2(
		player_entity,
		"LuaComponent",
		{ script_damage_received = "mods/noita.fairmod/files/content/fire/fire.lua" }
	)
end

return M
