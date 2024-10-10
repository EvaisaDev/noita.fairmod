dofile("data/scripts/lib/utilities.lua")

-- Get the entity's ID and its current position
local entity_id = GetUpdatedEntityID()
local x, y, r, s1, s2 = EntityGetTransform(entity_id)

-- Get the camera bounds: X, Y (top-left corner), and width/height
local camera_x, camera_y, camera_w, camera_h = GameGetCameraBounds()

-- Calculate the distance between the entity and the camera center
local camera_center_x = camera_x + (camera_w / 2)
local camera_center_y = camera_y + (camera_h / 2)

-- calculate the distance from the camera edge of the snail
local direction_x = x - camera_center_x
local direction_y = y - camera_center_y
local len = math.sqrt(direction_x * direction_x + direction_y * direction_y)

-- normalize direction
direction_x = direction_x / len
direction_y = direction_y / len

local edge_x = camera_center_x + direction_x * camera_w / 2
local edge_y = camera_center_y + direction_y * camera_h / 2

-- calculate distance from the edge
local distance_from_edge = math.sqrt((edge_x - x) * (edge_x - x) + (edge_y - y) * (edge_y - y))
-- check if snail is within the camera bounds
if (x > camera_x and x < camera_x + camera_w and y > camera_y and y < camera_y + camera_h) then
	return
end


SetRandomSeed(camera_x + x, camera_y + y)

-- If the entity is further than a certain threshold from the camera
if (distance_from_edge > 100) then
    -- Try to find a valid position outside the player's camera bounds
    local tries = 0
    local max_tries = 100
    local max_distance_from_edge = 10
    local valid = false
    local new_x, new_y = 0, 0

    while (tries < max_tries and not valid) do
        -- Generate a random position outside the camera bounds
        local direction_x = Random(0, 1)
		if(direction_x == 0)then
			direction_x = -1
		end

		new_x = camera_center_x + (camera_w / 2 + max_distance_from_edge) * direction_x
		new_y = Random(camera_y, camera_y + camera_h)

		if not RaytracePlatforms(new_x + 2, new_y + 2, new_x - 2, new_y - 2) then
			valid = true
		end

		-- raycast down until we hit the ground
		local hit, hit_x, hit_y = RaytracePlatforms(new_x, new_y, new_x, new_y + 1000)
		if hit then
			new_y = hit_y - 3
		end

        tries = tries + 1
    end

    -- If a valid position is found, update the entity's position
    if (valid) then
        EntityApplyTransform(entity_id, new_x, new_y)
    end
end