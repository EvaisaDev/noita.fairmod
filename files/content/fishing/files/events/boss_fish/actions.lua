actions[#actions + 1] = {
	id = "WATER_BEAM",
	name = "Water Beam",
	description = "Big beam of water.",
	sprite = "mods/noita.fairmod/files/content/immortal_snail/gun/ui_gfx/bullet.png",
	type = ACTION_TYPE_PROJECTILE,
	spawn_level = "0,0",
	spawn_probability = "0,0",
	price = 170,
	mana = 0,
	action = function()
		--print("WATER_BEAM")
		add_projectile("mods/noita.fairmod/files/content/fishing/files/events/boss_fish/beam.xml")
	end,
}