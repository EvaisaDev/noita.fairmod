

local old_spawn_boss_music_and_statues = spawn_boss_music_and_statues
function spawn_boss_music_and_statues(x, y)
	old_spawn_boss_music_and_statues(x, y)

	SetRandomSeed(GameGetFrameNum(), 0)
	if Random(1, 3) == 1 then
		EntityLoad("mods/noita.fairmod/files/content/snowman/snowman.xml", x - 80, y)
	end
end
