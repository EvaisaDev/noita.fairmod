dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

SetRandomSeed(GameGetFrameNum(), x + y + entity_id)

if Random(1, 4) > 1 then
	local angle = math.rad(Random(1, 360))
	local vel_x = 0
	local vel_y = 0
	local length = Random(400, 700)

	if Random(1, 4) > 1 then
		local targets = EntityGetWithTag("player_unit")
		local target_id = 0

		if #targets > 0 then
			local valid_targets = {}

			for i, target in ipairs(targets) do
				local tx, ty = EntityGetTransform(target)

				local distance = math.abs(ty - y) + math.abs(tx - x)

				if distance < 72 then table.insert(valid_targets, target) end
			end

			if #valid_targets > 0 then
				local rnd = Random(1, #valid_targets)

				target_id = valid_targets[rnd]

				if target_id ~= 0 then
					local tx, ty = EntityGetTransform(target_id)
					angle = 0 - math.atan2(ty - y, tx - x)
				end
			end
		end
	end

	vel_x = math.cos(angle) * length
	vel_y = 0 - math.sin(angle) * length
	--found out there was no need to write this out since vanilla function wasnt the cause of the issue, but who cares, this is still slightly more streamlined than the vanilla function for our purposes anyway
	local function better_shoot_projectile(shooter, filepath, x, y, vel_x, vel_y) 
		local projectile = EntityLoad( filepath, x, y )
	
		GameShootProjectile( shooter, x, y, x+vel_x, y+vel_y, projectile)

		local proj_comps = EntityGetComponent(projectile, "ProjectileComponent")
		if proj_comps == nil then return end
		for index, value in ipairs(proj_comps) do
			ComponentSetValue2(value, "mWhoShot", shooter or 0)
			ComponentSetValue2(value, "mShooterHerdId", -1)
		end
	
		return projectile
	end

	if #EntityGetInRadiusWithTag(x, y, 25, "player_unit") > 0 then
		
		better_shoot_projectile(entity_id, "mods/noita.fairmod/files/content/hm_portal_mimic/tentacle.xml", x, y, vel_x * 1.1, vel_y * 1.1)
		better_shoot_projectile(entity_id, "mods/noita.fairmod/files/content/hm_portal_mimic/tentacle.xml", x, y, vel_x * 0.9, vel_y * 0.9)
		better_shoot_projectile(entity_id, "mods/noita.fairmod/files/content/hm_portal_mimic/tentacle.xml", x, y, vel_x, vel_y)
	end
end
