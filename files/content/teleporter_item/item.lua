-- Teleporter range
local STEP_SIZE = 30
local MIN_STEPS = 4
local MAX_STEPS = 8

-- If you were to teleport into a wall, we try to save you by going up
local UPWARP_STEP_SIZE = 15
local UPWARP_MAX_STEPS = 6

local function is_space_occupied(x, y)
	local hit = RaytracePlatforms(x, y, x, y)
	return hit
end

local tp = GetUpdatedEntityID()
local holder = EntityGetRootEntity(tp)

if tp == holder then
	return
end

-- has_special_scale="1" in the SpriteComponent stops the item from flipping
-- it's held and the entity turns around. Reimplement that functionality here.
local sprite_comp = EntityGetFirstComponent(tp, "SpriteComponent")
local sprite_scale_y = ComponentGetValue2(sprite_comp, "special_scale_y")
local _, _, _, holder_scale_x = EntityGetTransform(holder)

if (sprite_scale_y < 0) ~= (holder_scale_x < 0) then
	ComponentSetValue2(sprite_comp, "special_scale_y", -sprite_scale_y)
end

local frame = GameGetFrameNum()

local controls = EntityGetFirstComponent(holder, "ControlsComponent")
if controls then
	if ComponentGetValue2(controls, "mButtonFrameFire") == frame then
		local dir_x, dir_y = ComponentGetValue2(controls, "mAimingVector")
		local length = math.sqrt(dir_x^2+dir_y^2)
		dir_x = dir_x / length
		dir_y = dir_y / length

		local x, y = EntityGetTransform(holder)
		SetRandomSeed(frame, x - y)

		local move_steps = Random(MIN_STEPS, MAX_STEPS)
		local dist = move_steps * STEP_SIZE

		local dest_x, dest_y = x + dir_x * dist, y + dir_y * dist
		if is_space_occupied(dest_x, dest_y) then
			-- Space occupied, try upwarping
			for _=1,UPWARP_MAX_STEPS do
				dest_y = dest_y - UPWARP_STEP_SIZE
				if not is_space_occupied(dest_x, dest_y) then
					goto do_teleport
				end
			end

			-- Couldn't be saved :-(

			local game_stats = EntityGetFirstComponent(holder, "GameStatsComponent")
			if game_stats then
				ComponentSetValue2(game_stats, "extra_death_msg", "Teleporter misadventure")
			end

			if EntityHasTag(holder, "player_unit") then
				GameSetCameraPos(dest_x, dest_y)
			end

			EntityKill(holder)
		end

		::do_teleport::

		EntityApplyTransform(holder, dest_x, dest_y)

		-- Telefrag
		local mortals = EntityGetInRadiusWithTag(dest_x, dest_y, 20, "mortal")
		for _, mortal in ipairs(mortals) do
			if mortal ~= holder then
				EntityInflictDamage(mortal, 1000, "DAMAGE_PHYSICS_HIT", "Telefragged", "BLOOD_EXPLOSION", 0, 0, holder)
			end
		end
	end
end
