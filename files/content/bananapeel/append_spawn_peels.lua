local spawn_big_enemies_orig = spawn_big_enemies

function spawn_big_enemies(x, y)
	spawn_big_enemies_orig(x, y)

	if Random(1, 100) < 20 then EntityLoad("mods/noita.fairmod/files/content/bananapeel/bananapeel.xml", x, y) end
end
