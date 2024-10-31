actions[#actions + 1] = {
	id = "BULLET_SNAIL",
	name = "Snail Gun Bullet",
	description = "yeah.",
	sprite = "mods/noita.fairmod/files/content/immortal_snail/gun/ui_gfx/bullet.png",
	type = ACTION_TYPE_PROJECTILE,
	spawn_level = "0,0",
	spawn_probability = "0,0",
	price = 170,
	mana = 0,
	action = function()
		mag = mag or 17
		if mag == 1 then
			local x, y = EntityGetTransform(GetUpdatedEntityID())
			GameCreateParticle("plastic_red", x, y - 4, 1, math.random(-5, 5), -10, false)
			current_reload_time = current_reload_time + 40
			mag = 17
			GamePlaySound("mods/noita.fairmod/fairmod.bank", "gun/reload", x, y)
		end
		add_projectile("mods/noita.fairmod/files/content/immortal_snail/gun/entities/bullet.xml")
		c.fire_rate_wait = c.fire_rate_wait - 3
		c.screenshake = c.screenshake + 0.1
		-- c.copi_swag = true
		mag = mag - 1
	end,
}
