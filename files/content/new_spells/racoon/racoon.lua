local pedro = {
	id = "FAIRMOD_PEDRO",
	name = "Racoon",
	description = "Racoon?",
	sprite = "mods/noita.fairmod/files/content/new_spells/racoon/icon.png",
	sprite_unidentified = "data/ui_gfx/gun_actions/disc_bullet_unidentified.png",
	related_projectiles = { "mods/noita.fairmod/files/content/new_spells/racoon/racoon.xml" },
	type = ACTION_TYPE_PROJECTILE,
	spawn_level = "2,3,5,10",
	spawn_probability = "0.2,0.6,1,0.4",
	price = 10,
	mana = 80,
	action = function()
		add_projectile("mods/noita.fairmod/files/content/new_spells/racoon/racoon.xml")
		c.fire_rate_wait = c.fire_rate_wait + 240
		current_reload_time = current_reload_time + 240
		c.spread_degrees = c.spread_degrees + 6.4
	end,
}

actions[#actions + 1] = pedro
