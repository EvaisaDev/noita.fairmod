---@diagnostic disable-next-line: lowercase-global
function kick()
	-- stylua: ignore start
	local shooter = GetUpdatedEntityID()
	local controlscomp = EntityGetFirstComponentIncludingDisabled(shooter, "ControlsComponent") --[[@cast controlscomp number]]
	local x, y = EntityGetTransform(shooter)
	local aim_x, aim_y = ComponentGetValue2(controlscomp, "mAimingVectorNormalized")
	local chardatacomp = EntityGetFirstComponent(shooter, "CharacterDataComponent")
	local sh_vx, sh_vy = ComponentGetValueVector2(chardatacomp, "mVelocity")
	ComponentSetValue2(chardatacomp, "mVelocity", sh_vx + aim_x*1000, sh_vy + aim_y*500)
	local projectile_id = EntityLoad("mods/noita.fairmod/files/content/cheats/misc/hamartial_arts.xml", x, y-8)
	local projcomp = EntityGetFirstComponent(projectile_id, "ProjectileComponent") --[[@cast projcomp number]]
	local velcomp = EntityGetFirstComponent(projectile_id, "VelocityComponent") --[[@cast velcomp number]]
	local genome = EntityGetFirstComponent(shooter, "GenomeDataComponent")
	local herd_id = genome and ComponentGetValue2(genome, "herd_id") or -1
	local velocity = 750
	local vel_x, vel_y = aim_x * velocity, aim_y * velocity
	GameShootProjectile(shooter, x, y-8, x+vel_x, y-8+vel_y, projectile_id, true)
	ComponentSetValue2(projcomp, "mWhoShot", shooter)
	ComponentSetValue2(projcomp, "mShooterHerdId", herd_id)
	ComponentSetValue2(velcomp, "mVelocity", vel_x, vel_y)
	local audio_loop = EntityGetFirstComponentIncludingDisabled(shooter, "AudioLoopComponent", "music")
	ComponentSetValue2(audio_loop, "m_volume", math.min(2, ComponentGetValue2(audio_loop, "m_volume") + 0.6))
	local snails = EntityGetInRadiusWithTag(x, y, 128, "snail") or {}
	for i=1, #snails do
		EntityInflictDamage( snails[i], 99999999999999999999999999999999999999999999999999999999999999999, "DAMAGE_PHYSICS_BODY_DAMAGED", "KACHOW!!!", "DISINTEGRATED", 0, 0, shooter, x, y, 0.1 )
		EntityKill(snails[i])
		GameAddFlagRun("snailkill")
	end
	-- stylua: ignore end
end
