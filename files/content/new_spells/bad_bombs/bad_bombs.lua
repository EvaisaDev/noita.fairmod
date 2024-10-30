local bad_dynamite = {
	id = "FAIRMOD_DYNAMITE",
	name = "$action_bad_dynamite",
	description = "$actiondesc_dynamite",
	sprite = "data/ui_gfx/gun_actions/dynamite.png",
	sprite_unidentified = "data/ui_gfx/gun_actions/dynamite_unidentified.png",
	related_projectiles = { "mods/noita.fairmod/files/content/new_spells/bad_bombs/tnt.xml" },
	type = ACTION_TYPE_PROJECTILE,
	spawn_level = "0,1,2,3,4", -- DYNAMITE
	spawn_probability = "1,0.9,0.8,0.7,0.6", -- DYNAMITE
	price = 160,
	mana = 50,
	max_uses = 16,
	action = function()
		add_projectile("mods/noita.fairmod/files/content/new_spells/bad_bombs/tnt.xml")
		c.fire_rate_wait = c.fire_rate_wait + 50
		c.spread_degrees = c.spread_degrees + 6.0
	end,
}
actions[#actions + 1] = bad_dynamite

local bad_bomb = {
	id = "FAIRMOD_BOMB",
	name = "$action_bad_bomb_legacy",
	description = "$actiondesc_bomb",
	sprite = "data/ui_gfx/gun_actions/bomb.png",
	sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
	related_projectiles = { "mods/noita.fairmod/files/content/new_spells/bad_bombs/bomb.xml" },
	type = ACTION_TYPE_PROJECTILE,
	spawn_level = "0,1,2,3,4,5,6", -- BOMB
	spawn_probability = "1,1,1,1,0.5,0.5,0.1", -- BOMB
	price = 200,
	mana = 25,
	max_uses = 3,
	action = function()
		add_projectile("mods/noita.fairmod/files/content/new_spells/bad_bombs/bomb.xml")
		c.fire_rate_wait = c.fire_rate_wait + 100
	end,
}
actions[#actions + 1] = bad_bomb

local rocket = {
	id = "FAIRMOD_ROCKET",
	name = "$action_bad_rocket",
	description = "$actiondesc_rocket",
	sprite = "data/ui_gfx/gun_actions/rocket.png",
	sprite_unidentified = "data/ui_gfx/gun_actions/rocket_unidentified.png",
	related_projectiles = { "mods/noita.fairmod/files/content/new_spells/bad_bombs/rocket.xml" },
	type = ACTION_TYPE_PROJECTILE,
	spawn_level = "1,2,3,4,5", -- ROCKET
	spawn_probability = "1,1,1,0.5,0.3", -- ROCKET
	price = 220,
	mana = 70,
	max_uses = 10,
	action = function()
		add_projectile("mods/noita.fairmod/files/content/new_spells/bad_bombs/rocket.xml")
		c.fire_rate_wait = c.fire_rate_wait + 60
		c.ragdoll_fx = 2
		shot_effects.recoil_knockback = 120.0
	end,
}
actions[#actions + 1] = rocket
