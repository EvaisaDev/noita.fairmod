module = {}

module.OnPlayerSpawned = function(player)
	EntityAddComponent2(player, "LuaComponent", {
		script_source_file = "mods/noita.fairmod/files/content/dingus/dingus_spawner.lua",
		execute_every_n_frame = 60,
	})
end

return module