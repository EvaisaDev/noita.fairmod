dofile_once("data/scripts/lib/utilities.lua")

local float_range = 5
local float_force = 2
local float_sensor_sector = math.pi * 0.3

frames_ran = frames_ran or 0
frames_ran = frames_ran + 1

if frames_ran < 3 then return end

local debug = false
local old_print = print
print = function(...)
	if debug then old_print(...) end
end

local item = EntityGetRootEntity(GetUpdatedEntityID())

local function GetPlayer()
	local players = EntityGetWithTag("player_unit")
	if #players > 0 then return players[1] end
	return nil
end

local x, y = EntityGetTransform(item)

move_x = move_x or x
move_y = move_y or y

local is_physics = false
local is_physics2 = false
local is_projectile = false
local belongs_to_player = false

initialized = initialized or false

local player = GetPlayer()

if #(EntityGetComponent(item, "PhysicsBodyComponent") or {}) > 0 then is_physics = true end
if #(EntityGetComponent(item, "PhysicsBody2Component") or {}) > 0 then
	is_physics = true
	is_physics2 = true
end
local projectile_comps = EntityGetComponentIncludingDisabled(item, "ProjectileComponent") or {}
if #projectile_comps > 0 then
	is_projectile = true
	local who_shot = ComponentGetValue2(projectile_comps[1], "mWhoShot")
	if who_shot == player then belongs_to_player = true end
end

-- calculate direction alway from player

direction_to_target_x = direction_to_target_x or 0
direction_to_target_y = direction_to_target_y or 0

if GameGetFrameNum() % 30 == 0 then
	local entity_id = GetUpdatedEntityID()
	SetRandomSeed(1, 1)
	if Random(1, 8) == 1 then
		if Random(1, 4) == 1 then
			GameEntityPlaySound(entity_id, "jump")
		else
			GameEntityPlaySound(entity_id, "damage/projectile")
		end
	end

	if player ~= nil then
		local player_x, player_y = EntityGetTransform(player)
		local distance = math.sqrt((player_x - x) ^ 2 + (player_y - y) ^ 2)

		-- GameCreateSpriteForXFrames("data/ui_gfx/debug_marker.png", player_x, player_y, true, 0, 0, 30, true)

		-- GamePrint(tostring(distance))

		local direction_x = (x - player_x) / distance
		local direction_y = (y - player_y) / distance

		if is_projectile and not belongs_to_player then
			direction_x = (player_x - x) / distance
			direction_y = (player_y - y) / distance
		end

		direction_to_target_x = direction_x
		direction_to_target_y = direction_y

		if not is_physics and distance <= 300 then
			-- Calculate angle between the player and the (x, y) coordinates
			local base_angle_rad = math.atan2((y - player_y), (x - player_x))

			if is_projectile and not belongs_to_player then
				base_angle_rad = math.atan2((player_y - y), (player_x - x))
			end

			local ray_distance = 500

			local ray_count = 10
			local max_ray_angle = 200

			local max_distance = 0
			local max_distance_x = 0
			local max_distance_y = 0

			for i = 1, ray_count do
				local angle = (i / ray_count) * max_ray_angle - max_ray_angle / 2

				-- Rotate the ray angle based on the direction the player is facing
				local rotated_angle = base_angle_rad + math.rad(angle)

				local ray_x = x + math.cos(rotated_angle) * ray_distance
				local ray_y = y + math.sin(rotated_angle) * ray_distance

				local hit, hx, hy = RaytraceSurfacesAndLiquiform(x, y, ray_x, ray_y)

				-- GameCreateSpriteForXFrames("data/ui_gfx/debug_marker.png", hx, hy, true, 0, 0, 30, true)

				if hit then
					local distance = math.sqrt((hx - x) ^ 2 + (hy - y) ^ 2)
					if distance > max_distance then
						max_distance = distance
						max_distance_x = hx
						max_distance_y = hy
					end
				end
			end

			move_x = max_distance_x - direction_x * 10
			move_y = max_distance_y - direction_y * 10
		end
	end
end

local function isNearWall()
	local min_distance = float_range
	-- raytrace in cadinal directions, make sure we are within 20 pixels of a wall, otherwise do not apply velocity
	local hit_a = RaytraceSurfacesAndLiquiform(x, y, x + min_distance, y)
	local hit_b = RaytraceSurfacesAndLiquiform(x, y, x - min_distance, y)
	local hit_c = RaytraceSurfacesAndLiquiform(x, y, x, y + min_distance)
	local hit_d = RaytraceSurfacesAndLiquiform(x, y, x, y - min_distance)
	local hit_e = RaytraceSurfacesAndLiquiform(x, y, x + min_distance, y + min_distance)
	local hit_f = RaytraceSurfacesAndLiquiform(x, y, x - min_distance, y - min_distance)
	local hit_g = RaytraceSurfacesAndLiquiform(x, y, x + min_distance, y - min_distance)
	local hit_h = RaytraceSurfacesAndLiquiform(x, y, x - min_distance, y + min_distance)

	return hit_a or hit_b or hit_c or hit_d or hit_e or hit_f or hit_g or hit_h
end

local function isNearPlaform()
	local min_distance = float_range
	-- raytrace in cadinal directions, make sure we are within 20 pixels of a wall, otherwise do not apply velocity
	local hit_a = RaytracePlatforms(x, y, x + min_distance, y)
	local hit_b = RaytracePlatforms(x, y, x - min_distance, y)
	local hit_c = RaytracePlatforms(x, y, x, y + min_distance)
	local hit_d = RaytracePlatforms(x, y, x, y - min_distance)
	local hit_e = RaytracePlatforms(x, y, x + min_distance, y + min_distance)
	local hit_f = RaytracePlatforms(x, y, x - min_distance, y - min_distance)
	local hit_g = RaytracePlatforms(x, y, x + min_distance, y - min_distance)
	local hit_h = RaytracePlatforms(x, y, x - min_distance, y + min_distance)

	return hit_a or hit_b or hit_c or hit_d or hit_e or hit_f or hit_g or hit_h
end

SetRandomSeed(GameGetFrameNum(), x + y + item)

if not is_physics then
	local simple_physics_component = EntityGetFirstComponentIncludingDisabled(item, "SimplePhysicsComponent")

	local item_component = EntityGetFirstComponentIncludingDisabled(item, "ItemComponent")
	local velocity_comp = EntityGetFirstComponentIncludingDisabled(item, "VelocityComponent")
	local projectile_comp = EntityGetFirstComponentIncludingDisabled(item, "ProjectileComponent")

	if not initialized then
		print("initializing")
		if velocity_comp == nil then
			local comp = EntityAddComponent2(item, "VelocityComponent", {})
			ComponentAddTag(comp, "enabled_in_world")
		else
			EntitySetComponentIsEnabled(item, velocity_comp, true)
		end

		if not is_projectile then
			if simple_physics_component ~= nil then
				EntitySetComponentIsEnabled(item, simple_physics_component, true)
			else
				local comp = EntityAddComponent2(item, "SimplePhysicsComponent", {})
				ComponentAddTag(comp, "enabled_in_world")
			end
			if item_component ~= nil then ComponentSetValue2(item_component, "play_hover_animation", false) end
		else
			local lifetime = ComponentGetValue2(projectile_comp, "lifetime")
			lifetime = lifetime + (10 * 60)
			ComponentSetValue2(projectile_comp, "lifetime", lifetime)
			ComponentSetValue2(projectile_comp, "die_on_low_velocity", false)
		end
		initialized = true
	end

	local target_x = move_x
	local target_y = move_y

	local distance = math.max(1, math.sqrt((target_x - x) ^ 2 + (target_y - y) ^ 2))

	local direction_x = (target_x - x) / distance
	local direction_y = (target_y - y) / distance

	local speed = 20

	local vel_x = direction_x * speed
	local vel_y = direction_y * speed

	local velocity_comp = EntityGetFirstComponentIncludingDisabled(item, "VelocityComponent")
	if velocity_comp ~= nil then
		local current_vel_x, current_vel_y = ComponentGetValueVector2(velocity_comp, "mVelocity")

		vel_x = (current_vel_x * 0.8) + vel_x
		vel_y = (current_vel_y * 0.8) + vel_y

		if not isNearWall() then
			vel_x = current_vel_x
			vel_y = current_vel_y
		end

		local dir_x = 0
		local dir_y = float_range

		local did_hit, hit_x, hit_y = RaytraceSurfacesAndLiquiform(x, y, x + dir_x, y + dir_y)
		if did_hit then
			local dist = get_distance(x, y, hit_x, hit_y)
			dist = math.max(6, dist) -- tame a bit on close encounters
			dir_x = -dir_x / dist * float_force
			dir_y = -dir_y / dist * float_force

			if dist >= 7 then
				vel_x = vel_x + dir_x
				vel_y = vel_y + dir_y
			else
				vel_x = current_vel_x + dir_x
				vel_y = current_vel_x + dir_y
			end
		end

		-- raytrace in cadinal directions, make sure we are within 20 pixels of a wall, otherwise do not apply velocity

		ComponentSetValue2(velocity_comp, "mVelocity", vel_x, vel_y)
	end
else
	local player = GetPlayer()

	if player ~= nil then
		local player_x, player_y = EntityGetTransform(player)
		local distance = math.sqrt((player_x - x) ^ 2 + (player_y - y) ^ 2)

		-- GameCreateSpriteForXFrames("data/ui_gfx/debug_marker.png", player_x, player_y, true, 0, 0, 30, true)

		-- GamePrint(tostring(distance))

		local phys_body = nil

		if is_physics2 then
			phys_body = EntityGetFirstComponentIncludingDisabled(item, "PhysicsBody2Component")
		else
			phys_body = EntityGetFirstComponentIncludingDisabled(item, "PhysicsBodyComponent")
		end

		local item_mass = 0.05665
		local item_pixels = ComponentGetValue2(phys_body, "mPixelCount")

		local anti_grav_force = item_pixels * item_mass

		direction_x = (x - player_x) / distance
		direction_y = (y - player_y) / distance

		local max_rotation = 10
		-- rotate direction by random degrees
		local rotation = Random(-max_rotation, max_rotation)
		local rotated_direction_x = direction_x * math.cos(math.rad(rotation))
			- direction_y * math.sin(math.rad(rotation))
		local rotated_direction_y = direction_x * math.sin(math.rad(rotation))
			+ direction_y * math.cos(math.rad(rotation))

		local speed = 1 * anti_grav_force
		if isNearPlaform() then PhysicsApplyForce(item, rotated_direction_x * speed, rotated_direction_y * speed) end

		-- PhysicsApplyForce(item, 0, -anti_grav_force)

		local dir_x = 0
		local dir_y = float_range
		dir_x, dir_y = vec_rotate(
			dir_x,
			dir_y,
			ProceduralRandomf(x, y + GameGetFrameNum(), -float_sensor_sector, float_sensor_sector)
		)

		local did_hit, hit_x, hit_y = RaytracePlatforms(x, y, x + dir_x, y + dir_y)
		if did_hit then
			local dist = get_distance(x, y, hit_x, hit_y)

			if dist <= 1 then return end

			dist = math.max(6, dist) -- tame a bit on close encounters
			dir_x = -dir_x / dist * float_force
			dir_y = -dir_y / dist * float_force
			PhysicsApplyForce(item, dir_x, dir_y)
		end
	end
end
