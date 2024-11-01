local joel = {
	id = "FAIRMOD_JOEL",
	name = "Fish",
	description = "Joel?",
	sprite = "mods/noita.fairmod/files/content/new_spells/joel/icon.png",
	sprite_unidentified = "data/ui_gfx/gun_actions/light_bullet_unidentified.png",
	related_projectiles = { "mods/noita.fairmod/files/content/new_spells/joel/joel.xml" },
	type = ACTION_TYPE_PROJECTILE,
	spawn_requires_flag = "fairmod_fish_is_free",
	spawn_level = "0,1,2",
	spawn_probability = "2,1,0.5",
	price = 100,
	mana = 20,
	action = function()
		add_projectile("mods/noita.fairmod/files/content/new_spells/joel/joel.xml")
		c.trail_material = c.trail_material .. "water_salt,"
		c.fire_rate_wait = c.fire_rate_wait + 5
		c.screenshake = c.screenshake + 0.5
	end,
}
actions[#actions + 1] = joel
