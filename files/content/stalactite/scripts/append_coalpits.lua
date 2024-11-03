local old_spawn_big_enemies = spawn_big_enemies
spawn_big_enemies = function(x, y)
	SetRandomSeed(x, y)

	if Random(1, 100) > 60 then
		local hit, hit_x, hit_y = RaytracePlatforms(x, y, x, y - 1000)
		if hit then
			EntityLoad(
				"mods/noita.fairmod/files/content/stalactite/entities/triggers/generic/stalactite_generic_" .. Random(1, 3) .. ".xml",
				hit_x,
				hit_y
			)
		end
	end

	old_spawn_big_enemies(x, y)
end
