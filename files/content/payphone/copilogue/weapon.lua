--stylua: ignore start
local entity_id = GetUpdatedEntityID()
local _, _, rad = EntityGetTransform(entity_id)
local sprite_comp = EntityGetComponentIncludingDisabled(entity_id, "SpriteComponent", "item")
if sprite_comp ~= nil then
	for i = 1, #sprite_comp do
		ComponentSetValue2(sprite_comp[i], "special_scale_y", (rad >= -math.pi / 2 and rad <= math.pi / 2) and 0.05 or -0.05)
	end
end



local root = EntityGetRootEntity(entity_id)
local control_comp = EntityGetFirstComponentIncludingDisabled(root, "ControlsComponent")
if not control_comp then return end
if ComponentGetValue2( control_comp, "mButtonDownFire") then
	local x, y = EntityGetTransform(entity_id)
	-- Handle shoot dist
	local dist_x, dist_y = 12, 0
	local HotspotComponent = EntityGetFirstComponentIncludingDisabled(entity_id, "HotspotComponent", "shoot_pos")
	if HotspotComponent then
		local wand_x, wand_y, wand_r = EntityGetTransform(entity_id)
		local ox, oy = ComponentGetValue2(HotspotComponent, "offset")
		local tx = math.cos(wand_r) * ox - math.sin(wand_r) * oy
		local ty = math.sin(wand_r) * ox + math.cos(wand_r) * oy
		dist_x, dist_y = tx, ty
	end

	-- Handle Shooting
	local aim_x, aim_y = ComponentGetValue2(control_comp, "mAimingVectorNormalized")
	local shoot_x, shoot_y = x + dist_x, y + dist_y
	local projectile_id = EntityLoad("mods/noita.fairmod/files/content/payphone/copilogue/proj.xml", shoot_x, shoot_y)
	local projcomp = EntityGetFirstComponent(projectile_id, "ProjectileComponent") --[[@cast projcomp number]]
	local velcomp = EntityGetFirstComponent(projectile_id, "VelocityComponent") --[[@cast velcomp number]]
	local genome = EntityGetFirstComponent(root, "GenomeDataComponent")
	local herd_id = genome and ComponentGetValue2(genome, "herd_id") or -1
	local velocity = math.random(500, 750)
	local vel_x, vel_y = aim_x * velocity, aim_y * velocity
	GameShootProjectile(root, shoot_x, shoot_y, x + vel_x, y + vel_y, projectile_id, true)
	ComponentSetValue2(projcomp, "mWhoShot", root)
	ComponentSetValue2(projcomp, "mShooterHerdId", herd_id)
	ComponentSetValue2(velcomp, "mVelocity", vel_x, vel_y)
end


--stylua: ignore end
