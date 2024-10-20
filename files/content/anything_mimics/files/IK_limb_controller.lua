local entity = GetUpdatedEntityID()

local entity_x, entity_y = EntityGetTransform(entity)

local children = EntityGetAllChildren(entity) or {}

local debug = false

local old_print = print
print = function(...)
	if debug then old_print(...) end
end

last_frame_position = last_frame_position or { entity_x, entity_y }
limb_targets = limb_targets or {}
tracked_limbs = tracked_limbs or {}
not_first_run = not_first_run or false

local forward_x, forward_y = entity_x - last_frame_position[1], entity_y - last_frame_position[2]
local movement_speed = math.sqrt(forward_x ^ 2 + forward_y ^ 2)

if movement_speed > 100 then movement_speed = 100 end

if movement_speed < 1 then movement_speed = 1 end

local forward_x_normalized, forward_y_normalized = forward_x / movement_speed, forward_y / movement_speed

local limbs = {}
for k, v in ipairs(children) do
	if EntityHasTag(v, "ik_limb") then table.insert(limbs, v) end
end

local limb_count = #limbs
local limb_length = 20
local update_rate = 10
local limb_speed = 0.1
local scan_angle = 90
local scan_distance = 100
local variable_storage_comps = EntityGetComponent(entity, "VariableStorageComponent") or {}
for k, v in ipairs(variable_storage_comps) do
	local name = ComponentGetValue2(v, "name")
	if name == "limb_length" then
		limb_length = ComponentGetValue2(v, "value_int")
	elseif name == "update_rate" then
		update_rate = ComponentGetValue2(v, "value_int")
	elseif name == "limb_speed" then
		limb_speed = ComponentGetValue2(v, "value_float")
	elseif name == "scan_angle" then
		scan_angle = ComponentGetValue2(v, "value_int")
	elseif name == "scan_distance" then
		scan_distance = ComponentGetValue2(v, "value_int")
	elseif name == "limb_count" then
		limb_count = ComponentGetValue2(v, "value_int")
	end
end

SetRandomSeed(GameGetFrameNum() + entity, GameGetFrameNum() + entity_x + entity_y + entity)

local speed_mult = math.max(1, movement_speed * 1.5)

--[[if(speed_mult > 1)then
    print("speed_mult: "..tostring(speed_mult))
end]]
limb_speed = limb_speed * speed_mult

gui = gui or GuiCreate()

GuiStartFrame(gui)

function WorldToScreenPos(gui_input, x, y)
	local virt_x = MagicNumbersGetValue("VIRTUAL_RESOLUTION_X")
	local virt_y = MagicNumbersGetValue("VIRTUAL_RESOLUTION_Y")
	local screen_width, screen_height = GuiGetScreenDimensions(gui_input)
	local scale_x = virt_x / screen_width
	local scale_y = virt_y / screen_height
	local cx, cy = GameGetCameraPos()
	local sx, sy = (x - cx) / scale_x + screen_width / 2 + 1.5, (y - cy) / scale_y + screen_height / 2
	return sx, sy
end

if last_frame_position == nil then
	last_frame_position = { entity_x, entity_y }

	for k, v in ipairs(limbs) do
		local ik_limb_component = EntityGetFirstComponentIncludingDisabled(v, "IKLimbComponent")
		ComponentSetValue2(ik_limb_component, "end_position", entity_x, entity_y)
	end
	return
end

if last_frame_position[1] == entity_x and last_frame_position[2] == entity_y then
	for k, v in ipairs(limbs) do
		local ik_limb_component = EntityGetFirstComponentIncludingDisabled(v, "IKLimbComponent")
		ComponentSetValue2(ik_limb_component, "end_position", entity_x, entity_y)
	end
	return
end

if not not_first_run or (GameGetFrameNum() % update_rate == 0 and movement_speed >= limb_speed) then
	limb_targets = {}

	local checks = {}
	local total_points = limb_count * 2

	-- RaytracePlatforms( entity_x, entity_y, entity_x + x, entity_y + y ), entity_x + x, entity_y + y
	for i = 1, total_points do
		-- Calculate the new angle based on the scan angle and the current point
		local angle = (i / total_points) * scan_angle - scan_angle / 2
		local angle_radians = math.rad(angle)

		-- Calculate the rotational matrix to rotate around the given forward direction
		local cos_angle = math.cos(angle_radians)
		local sin_angle = math.sin(angle_radians)

		-- Rotate the forward direction by the given angle
		local rotated_x = forward_x_normalized * cos_angle - forward_y_normalized * sin_angle
		local rotated_y = forward_x_normalized * sin_angle + forward_y_normalized * cos_angle

		-- Scale the rotated direction by the limb_length
		local raycast_x = entity_x + rotated_x * scan_distance
		local raycast_y = entity_y + rotated_y * scan_distance

		local hit, hit_x, hit_y = RaytracePlatforms(entity_x, entity_y, raycast_x, raycast_y)

		local distance_to_hit = math.sqrt((hit_x - entity_x) ^ 2 + (hit_y - entity_y) ^ 2)

		if distance_to_hit > 1 then table.insert(checks, { hit, hit_x, hit_y }) end
	end

	for i, check in ipairs(checks) do
		local hit, hit_x, hit_y = check[1], check[2], check[3]

		if hit then table.insert(limb_targets, { hit_x, hit_y }) end
	end
	not_first_run = true
end

available_targets = available_targets or {}

if available_targets == 0 then
	for i, v in ipairs(limb_targets) do
		table.insert(available_targets, v)
	end
end
--print("available_targets: "..tostring(#available_targets))
--print("limbs: "..tostring(#limbs))

for k, v in ipairs(limbs) do
	if tracked_limbs[k] ~= nil then
		if debug then
			GameCreateSpriteForXFrames(
				"data/ui_gfx/debug_marker.png",
				tracked_limbs[k][1],
				tracked_limbs[k][2],
				true,
				0,
				0,
				60,
				true
			)
			screen_pos_x, screen_pos_y = WorldToScreenPos(gui, end_x, end_y)

			GuiText(gui, screen_pos_x, screen_pos_y, "Limb " .. tostring(k))
		end

		local ik_limb_component = EntityGetFirstComponentIncludingDisabled(v, "IKLimbComponent")
		local end_x, end_y = ComponentGetValue2(ik_limb_component, "end_position")

		local direction_x = tracked_limbs[k][1] - entity_x
		local direction_y = tracked_limbs[k][2] - entity_y

		local direction_length = math.sqrt(direction_x ^ 2 + direction_y ^ 2)

		local direction_x_normalized = direction_x / direction_length
		local direction_y_normalized = direction_y / direction_length

		local max_position_x = entity_x + direction_x_normalized * limb_length
		local max_position_y = entity_y + direction_y_normalized * limb_length
		local distance_2 = math.sqrt((tracked_limbs[k][1] - entity_x) ^ 2 + (tracked_limbs[k][2] - entity_y) ^ 2)

		if limb_length > distance_2 then
			max_position_x = tracked_limbs[k][1]
			max_position_y = tracked_limbs[k][2]
		end

		local distance = math.sqrt((max_position_x - end_x) ^ 2 + (max_position_y - end_y) ^ 2)

		local leg_distance = math.sqrt((tracked_limbs[k][1] - entity_x) ^ 2 + (tracked_limbs[k][2] - entity_y) ^ 2)

		if leg_distance > limb_length + 2 and distance < 5 then
			tracked_limbs[k] = nil
			--GamePrint("releasing limb: "..tostring(k))
			goto continue
		else
			local distance_x = (max_position_x - end_x) * limb_speed
			local distance_y = (max_position_y - end_y) * limb_speed

			local magnitude = math.sqrt(distance_x ^ 2 + distance_y ^ 2)

			local new_end_x = end_x + distance_x
			local new_end_y = end_y + distance_y

			-- make sure the limb doesn't go past the target
			if magnitude > distance then
				--print("limb "..tostring(k).." reached target")
				new_end_x = max_position_x
				new_end_y = max_position_y
			end

			if debug then
				GameCreateSpriteForXFrames(
					"data/ui_gfx/debug_marker.png",
					max_position_x,
					max_position_y,
					true,
					0,
					0,
					1,
					true
				)

				local screen_pos_x, screen_pos_y = WorldToScreenPos(gui, max_position_x, max_position_y)

				GuiText(gui, screen_pos_x, screen_pos_y, tostring(k))
			end

			ComponentSetValue2(ik_limb_component, "end_position", new_end_x, new_end_y)

			goto continue
		end
	end

	if #available_targets > 0 then
		-- get the furthest target
		local chosen_index = nil
		local furthest_distance = 0
		for i, target in ipairs(available_targets) do
			local distance = math.sqrt((entity_x - target[1]) ^ 2 + (entity_y - target[2]) ^ 2)
			if distance > furthest_distance then
				furthest_distance = distance
				chosen_index = i
			end
		end

		if chosen_index ~= nil then
			tracked_limbs[k] = available_targets[chosen_index]

			table.remove(available_targets, chosen_index)

			--print("tracking limb: "..tostring(k).." to "..tostring(chosen_target[1])..", "..tostring(chosen_target[2]))
		end
	else
		-- Function to convert degrees to radians
		local function deg2rad(deg)
			return deg * (math.pi / 180)
		end

		-- Function to perform 2D vector rotation
		local function rotateVector(x, y, angle_rad)
			local cos_angle = math.cos(angle_rad)
			local sin_angle = math.sin(angle_rad)

			local out_x = x * cos_angle - y * sin_angle
			local out_y = x * sin_angle + y * cos_angle

			return out_x, out_y
		end

		local angle = Random(-scan_angle / 2, scan_angle / 2)

		local random_angle = deg2rad(angle)

		-- Calculate position within forward direction and angle cone
		local angle_x, angle_y = rotateVector(forward_x_normalized, forward_y_normalized, random_angle)

		local x = entity_x + (angle_x * (limb_length / 2))
		local y = entity_y + (angle_y * (limb_length / 2))

		-- raytrace to position
		local hit, hit_x, hit_y = RaytracePlatforms(entity_x, entity_y, x, y)

		local distance_to_hit = math.sqrt((hit_x - entity_x) ^ 2 + (hit_y - entity_y) ^ 2)

		if distance_to_hit > 1 then
			tracked_limbs[k] = { hit_x, hit_y }
		else
			tracked_limbs[k] = { x, y }
		end
	end
	::continue::
end

last_frame_position = { entity_x, entity_y }
