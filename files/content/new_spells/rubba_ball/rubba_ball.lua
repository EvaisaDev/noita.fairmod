local rubba = {
	id = "FAIRMOD_RUBBA_BALL",
	name = "$action_rubba_ball",
	description = "$actiondesc_rubber_ball",
	sprite = "data/ui_gfx/gun_actions/rubber_ball.png",
	sprite_unidentified = "data/ui_gfx/gun_actions/rubber_ball_unidentified.png",
	related_projectiles = { "mods/noita.fairmod/files/content/new_spells/rubba_ball/rubber_ball.xml" },
	type = ACTION_TYPE_PROJECTILE,
	spawn_level = "0,1,6", -- RUBBER_BALL
	spawn_probability = "1,1,0.2", -- RUBBER_BALL
	price = 40,
	mana = 7,
	action = function()
		add_projectile("mods/noita.fairmod/files/content/new_spells/rubba_ball/rubber_ball.xml")
		c.fire_rate_wait = c.fire_rate_wait - 2
		c.spread_degrees = c.spread_degrees - 1.0
	end,
}
actions[#actions + 1] = rubba
