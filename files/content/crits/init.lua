-- Nathan made this
-- Makes you randomly take 5x+ damage

local M = {}

---@param player entity_id
function M.OnPlayerSpawned(player)
	EntityAddComponent2(
		player,
		"LuaComponent",
		{
			execute_every_n_frame = -1,
			script_damage_about_to_be_received = "mods/noita.fairmod/files/content/crits/damage.lua",
		}
	)
end

return M
