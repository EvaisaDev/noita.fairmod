local old_spawn_sampo_spot = spawn_sampo_spot

spawn_sampo_spot = function(x, y)
	if GameHasFlagRun("kolmi_not_home") then
		local boss = EntityLoad("data/entities/animals/boss_centipede/boss_centipede.xml", x, y + 80)

		EntityAddComponent2(boss, "LuaComponent", {
			script_source_file = "mods/noita.fairmod/files/content/kolmi_not_home/kolmi_angy.lua",
			execute_every_n_frame = 1,
			execute_times = -1,
		})

		EntityLoad("data/entities/animals/boss_centipede/reference_point.xml", x, y)
	end

	old_spawn_sampo_spot(x, y)
end
