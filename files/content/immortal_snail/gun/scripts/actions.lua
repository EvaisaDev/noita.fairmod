local to_insert = {
    {
		id          = "BULLET_SNAIL",
		name 		= "Snail Gun Bullet",
		description = "yeah.",
		sprite 		= "mods/noita.fairmod/files/content/immortal_snail/gun/ui_gfx/bullet.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,0",
		spawn_probability                 = "0,0",
		price = 170,
		mana = 0,
		max_uses = 170,
		action 		= function()
			add_projectile("data/entities/projectiles/buckshot.xml")
			c.fire_rate_wait = c.fire_rate_wait - 3
			c.screenshake = c.screenshake + 0.2
			c.damage_critical_chance = c.damage_critical_chance + 20
		end,
	},
}

for k, v in ipairs(to_insert) do
    table.insert(actions, v)
end