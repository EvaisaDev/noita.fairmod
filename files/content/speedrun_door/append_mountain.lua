-- eba made this btw

RegisterSpawnFunction(0xffb95ab9, "spawn_speedrunner_door")

function spawn_speedrunner_door(x, y)
	-- spawn if player has atleast one win
	if (ModSettingGet("fairmod_win_count") or 0) > 0 then
		EntityLoad("mods/noita.fairmod/files/content/speedrun_door/door_entrance.xml", x + 26, y)

		LoadBackgroundSprite(
			"mods/noita.fairmod/files/content/speedrun_door/speedrun_sign.png",
			x + 25,
			y - 72,
			-100,
			false
		)
	end
end
