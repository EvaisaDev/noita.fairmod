local M = {}

---@param player_entity entity_id
function M.OnPlayerSpawned(player_entity)
	EntityAddComponent2(
		player_entity,
		"LuaComponent",
		{ script_source_file = "mods/noita.fairmod/files/content/fire/fire.lua", execute_every_n_frame = 1 }
	)
end

return M
