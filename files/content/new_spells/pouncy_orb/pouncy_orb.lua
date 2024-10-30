local pouncy = {
	id = "FAIRMOD_POUNCY_ORB",
	name = "$action_pouncy_orb",
	description = "$actiondesc_bouncy_orb",
	sprite = "data/ui_gfx/gun_actions/bouncy_orb.png",
	sprite_unidentified = "data/ui_gfx/gun_actions/disc_bullet_unidentified.png",
	related_projectiles = { "mods/noita.fairmod/files/content/new_spells/pouncy_orb/bouncy_orb.xml" },
	type = ACTION_TYPE_PROJECTILE,
	spawn_level = "0,2,4", -- BOUNCY_ORB
	spawn_probability = "1,1,1", -- BOUNCY_ORB
	price = 120,
	mana = 25,
	action = function()
		add_projectile("mods/noita.fairmod/files/content/new_spells/pouncy_orb/bouncy_orb.xml")
		c.fire_rate_wait = c.fire_rate_wait + 10
		shot_effects.recoil_knockback = 20.0
	end,
}
actions[#actions + 1] = pouncy
