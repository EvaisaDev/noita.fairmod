local e = {}

e.OnPlayerSpawned = function(player_entity)
	EntityAddComponent2(player_entity, "LuaComponent", {
		script_source_file = "mods/noita.fairmod/files/content/evil_nuggets/player_update.lua",
		execute_every_n_frame = 1,
		execute_on_added = true,
	})
end

return e
