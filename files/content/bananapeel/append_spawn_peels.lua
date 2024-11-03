local spawn_big_enemies_orig = spawn_big_enemies

function spawn_big_enemies(x, y)
	spawn_big_enemies_orig(x, y)

	SetRandomSeed(x * 12 + 5, y / 3 - 7)
	if Random(1, 100) < 20 then EntityLoad("mods/noita.fairmod/files/content/bananapeel/bananapeel.xml", x, y) end
end
