local spakr = {
	id = "SPAKR_BOLT",
	name = "$action_spakr_bolt",
	description = "$actiondesc_light_bullet",
	sprite = "data/ui_gfx/gun_actions/light_bullet.png",
	sprite_unidentified = "data/ui_gfx/gun_actions/light_bullet_unidentified.png",
	related_projectiles = { "mods/noita.fairmod/files/content/new_spells/spakr_bolt/light_bullet.xml" },
	type = ACTION_TYPE_PROJECTILE,
	spawn_level = "0,1,2", -- LIGHT_BULLET
	spawn_probability = "2,1,0.5", -- LIGHT_BULLET
	price = 70,
	mana = 6,
	action = function()
		add_projectile("mods/noita.fairmod/files/content/new_spells/spakr_bolt/light_bullet.xml")
		c.fire_rate_wait = c.fire_rate_wait + 3
		c.screenshake = c.screenshake + 0.5
		c.spread_degrees = c.spread_degrees - 1.0
		c.damage_critical_chance = c.damage_critical_chance + 5
	end,
}
actions[#actions + 1] = spakr
