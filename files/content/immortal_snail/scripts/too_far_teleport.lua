dofile("data/scripts/lib/utilities.lua")

-- Get the entity's ID and its current position
local entity_id = GetUpdatedEntityID()
local x, y, r, s1, s2 = EntityGetTransform(entity_id)

-- Get the camera bounds: X, Y (top-left corner), and width/height
local camera_x, camera_y, camera_w, camera_h = GameGetCameraBounds()

-- Calculate the distance between the entity and the camera center
local camera_center_x = camera_x + (camera_w / 2)
local camera_center_y = camera_y + (camera_h / 2)
local len = math.abs(x - camera_center_x) + math.abs(y - camera_center_y)


SetRandomSeed(camera_x + x, camera_y + y)
-- If the entity is further than a certain threshold from the camera
if (len > 420) then
    -- Try to find a valid position outside the player's camera bounds
    local tries = 0
    local max_tries = 100
    local max_distance_from_edge = 100
    local valid = false
    local new_x, new_y = 0, 0

    while (tries < max_tries and not valid) do
        -- Generate a random position outside the camera bounds
        local direction_x = Random(0, 1)
		local direction_y = Random(0, 1)
		if(direction_x == 0)then
			direction_x = -1
		end
		if(direction_y == 0)then
			direction_y = -1
		end

		new_x = camera_center_x + (camera_w / 2 + max_distance_from_edge) * direction_x
		new_y = camera_center_y + (camera_h / 2 + max_distance_from_edge) * direction_y

		if not RaytracePlatforms(new_x + 2, new_y + 2, new_x - 2, new_y - 2) then
			valid = true
		end

        tries = tries + 1
    end

    -- If a valid position is found, update the entity's position
    if (valid) then
        EntityApplyTransform(entity_id, new_x, new_y)
    end
end