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

local long_dynamite = {
	id = "FAIRMOD_LONG_DYNAMITE",
	name = "$action_bad_long_dynamite",
	description = "$actiondesc_dynamite",
	sprite = "data/ui_gfx/gun_actions/dynamite.png",
	sprite_unidentified = "data/ui_gfx/gun_actions/dynamite_unidentified.png",
	related_projectiles = { "mods/noita.fairmod/files/content/new_spells/bad_bombs/tnt_long.xml" },
	type = ACTION_TYPE_PROJECTILE,
	spawn_level = "0,1,2,3,4", -- DYNAMITE
	spawn_probability = "1,0.9,0.8,0.7,0.6", -- DYNAMITE
	price = 160,
	mana = 50,
	max_uses = 16,
	action = function()
		add_projectile("mods/noita.fairmod/files/content/new_spells/bad_bombs/tnt_long.xml")
		c.fire_rate_wait = c.fire_rate_wait + 50
		c.spread_degrees = c.spread_degrees + 6.0
	end,
}
actions[#actions + 1] = long_dynamite

local beeg_dynamite = {
	id = "FAIRMOD_BEEG_DYNAMITE",
	name = "$action_bad_beeg_dynamite",
	description = "$actiondesc_dynamite",
	sprite = "data/ui_gfx/gun_actions/dynamite.png",
	sprite_unidentified = "data/ui_gfx/gun_actions/dynamite_unidentified.png",
	related_projectiles = { "mods/noita.fairmod/files/content/new_spells/bad_bombs/tnt_beeg.xml" },
	type = ACTION_TYPE_PROJECTILE,
	spawn_level = "0,1,2,3,4", -- DYNAMITE
	spawn_probability = "1,0.9,0.8,0.7,0.6", -- DYNAMITE
	price = 160,
	mana = 50,
	max_uses = 16,
    pandorium_ignore = true,
	ai_never_uses = true,
	action = function()
		add_projectile("mods/noita.fairmod/files/content/new_spells/bad_bombs/tnt_beeg.xml")
		c.fire_rate_wait = c.fire_rate_wait + 50
		c.spread_degrees = c.spread_degrees + 6.0
	end,
}
actions[#actions + 1] = beeg_dynamite

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

local long_bomb = {
	id = "FAIRMOD_LONG_BOMB",
	name = "$action_bad_bomb_long",
	description = "$actiondesc_bomb",
	sprite = "data/ui_gfx/gun_actions/bomb.png",
	sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
	related_projectiles = { "mods/noita.fairmod/files/content/new_spells/bad_bombs/bomb_long.xml" },
	type = ACTION_TYPE_PROJECTILE,
	spawn_level = "0,1,2,3,4,5,6", -- BOMB
	spawn_probability = "1,1,1,1,0.5,0.5,0.1", -- BOMB
	price = 200,
	mana = 25,
	max_uses = 3,
	action = function()
		add_projectile("mods/noita.fairmod/files/content/new_spells/bad_bombs/bomb_long.xml")
		c.fire_rate_wait = c.fire_rate_wait + 100
	end,
}
actions[#actions + 1] = long_bomb

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

-- Very unstable crystal that explodes almost immediately
local very_unstable = {
	id = "FAIRMOD_VERY_UNSTABLE_MINE",
	name = "$action_mine_very_unstable",
	description = "$actiondesc_mine",
	sprite = "data/ui_gfx/gun_actions/mine.png",
	sprite_unidentified = "data/ui_gfx/gun_actions/mine_unidentified.png",
	related_projectiles = { "data/entities/projectiles/deck/mine.xml" },
	type = ACTION_TYPE_PROJECTILE,
	spawn_level = "1,3,4,6", -- MINE
	spawn_probability = "1,0.75,1,0.5", -- MINE
	price = 200,
	mana = 20,
	max_uses = 15,
	action = function()
		add_projectile("mods/noita.fairmod/files/content/new_spells/bad_bombs/very_unstable_mine.xml")
		c.fire_rate_wait = c.fire_rate_wait + 30
		c.child_speed_multiplier = c.child_speed_multiplier * 0.75
		c.speed_multiplier = c.speed_multiplier * 0.75
		shot_effects.recoil_knockback = 60.0

		if c.speed_multiplier >= 20 then
			c.speed_multiplier = math.min(c.speed_multiplier, 20)
		elseif c.speed_multiplier < 0 then
			c.speed_multiplier = 0
		end
	end,
}
actions[#actions + 1] = very_unstable

-- stable crystal, that doesn't react to proximity creatures
local stable = {
	id = "FAIRMOD_STABLE_MINE",
	name = "$action_mine_stable",
	description = "$actiondesc_mine",
	sprite = "data/ui_gfx/gun_actions/mine.png",
	sprite_unidentified = "data/ui_gfx/gun_actions/mine_unidentified.png",
	related_projectiles = { "data/entities/projectiles/deck/mine.xml" },
	type = ACTION_TYPE_PROJECTILE,
	spawn_level = "1,3,4,6", -- MINE
	spawn_probability = "1,0.75,1,0.5", -- MINE
	price = 200,
	mana = 20,
	max_uses = 15,
	action = function()
		add_projectile("mods/noita.fairmod/files/content/new_spells/bad_bombs/stable_mine.xml")
		c.fire_rate_wait = c.fire_rate_wait + 30
		c.child_speed_multiplier = c.child_speed_multiplier * 0.75
		c.speed_multiplier = c.speed_multiplier * 0.75
		shot_effects.recoil_knockback = 60.0

		if c.speed_multiplier >= 20 then
			c.speed_multiplier = math.min(c.speed_multiplier, 20)
		elseif c.speed_multiplier < 0 then
			c.speed_multiplier = 0
		end
	end,
}
actions[#actions + 1] = stable
