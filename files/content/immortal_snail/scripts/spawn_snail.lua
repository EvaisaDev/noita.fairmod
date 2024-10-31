local snail = EntityGetWithName("Immortal Snail")
snail_respawn_timer = snail_respawn_timer or 600
if snail == nil or snail == 0 or not EntityGetIsAlive(snail) then
	if snail_respawn_timer <= 0 then
		local camera_x, camera_y, camera_w, camera_h = GameGetCameraBounds()
		local camera_center_x = camera_x + (camera_w / 2)
		local camera_center_y = camera_y + (camera_h / 2)

		SetRandomSeed(camera_x + GameGetFrameNum(), camera_y + GameGetFrameNum())
		local tries = 0
		local max_tries = 100
		local max_distance_from_edge = 10
		local valid = false
		local new_x, new_y = 0, 0

		while tries < max_tries and not valid do
			-- Generate a random position outside the camera bounds
			local direction_x = Random(0, 1)
			if direction_x == 0 then direction_x = -1 end

			new_x = camera_center_x + (camera_w / 2 + max_distance_from_edge) * direction_x
			new_y = Random(camera_y, camera_y + camera_h)

			if not RaytracePlatforms(new_x + 2, new_y + 2, new_x - 2, new_y - 2) then valid = true end

			-- raycast down until we hit the ground
			local hit, hit_x, hit_y = RaytracePlatforms(new_x, new_y, new_x, new_y + 1000)
			if hit then new_y = hit_y - 3 end

			tries = tries + 1
		end

		if valid then
			snail_respawn_timer = Random(60, 300)
			EntityLoad("mods/noita.fairmod/files/content/immortal_snail/entities/snail.xml", new_x, new_y)
			print("Snail was missing, respawning.")
		end
	else
		snail_respawn_timer = snail_respawn_timer - 1
	end
end
