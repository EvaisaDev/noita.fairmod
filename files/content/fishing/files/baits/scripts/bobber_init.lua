local projectile = GetUpdatedEntityID()

local projectile_comp = EntityGetFirstComponent(projectile, "ProjectileComponent")

if projectile_comp ~= nil then
	local who_shot = ComponentGetValue2(projectile_comp, "mWhoShot")

	if who_shot ~= nil and who_shot ~= 0 and EntityGetIsAlive(who_shot) then
		local controls_comp = EntityGetFirstComponent(who_shot, "ControlsComponent")

		if controls_comp ~= nil then
			local aim_x, aim_y = ComponentGetValue2(controls_comp, "mAimingVectorNormalized")

			-- set the projectile's velocity to the aiming vector
			local velocity = 300
			local vel_x = aim_x * velocity
			local vel_y = aim_y * velocity

			local velocity_comp = EntityGetFirstComponent(projectile, "VelocityComponent")
			if velocity_comp ~= nil then ComponentSetValue2(velocity_comp, "mVelocity", vel_x, vel_y) end
		end
	end
end
