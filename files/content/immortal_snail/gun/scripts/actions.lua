actions[#actions + 1] = {
	id = "BULLET_SNAIL",
	name = "Freedom Seeds",
	description = "Not actually a seed. It's a 9mm bullet.",
	sprite = "mods/noita.fairmod/files/content/immortal_snail/gun/ui_gfx/bullet.png",
	type = ACTION_TYPE_PROJECTILE,
	spawn_level = "0,0",
	spawn_probability = "0,0",
	price = 170,
	mana = 0,
	action = function()
		if reflecting then
			add_projectile("mods/noita.fairmod/files/content/immortal_snail/gun/entities/bullet.xml")
			c.fire_rate_wait = c.fire_rate_wait - 3
			c.screenshake = c.screenshake + 0.1
		else
			local x, y = EntityGetTransform(GetUpdatedEntityID())
			mag = mag or 17
			if mag == 1 then
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
		end
	end,
}
actions[#actions + 1] = {
	id = "BULLET_SOMA",
	name = "Blatant Warframe Reference",
	description = "Too lazy to add bleed DoT.",
	sprite = "mods/noita.fairmod/files/content/immortal_snail/gun/ui_gfx/bullet.png",
	type = ACTION_TYPE_PROJECTILE,
	spawn_level = "0,0",
	spawn_probability = "0,0",
	price = 170,
	mana = 0,
	action = function()
		if reflecting then
			add_projectile("mods/noita.fairmod/files/content/immortal_snail/gun/entities/bullet_soma.xml")
			c.fire_rate_wait = c.fire_rate_wait - 3
			c.screenshake = c.screenshake + 0.1
			c.damage_critical_chance = 30

		else

			Revs = Revs or 0
			local caster = GetUpdatedEntityID()
			local x, y = EntityGetTransform(caster)
			local controls_component = EntityGetFirstComponentIncludingDisabled(caster, "ControlsComponent")
			if controls_component ~= nil then
				LastShootingStart = LastShootingStart or 0
				local shooting_start = ComponentGetValue2(controls_component, "mButtonFrameFire")
				local shooting_now = ComponentGetValue2(controls_component, "mButtonDownFire")
				if not shooting_now then
					Revs = 0
				else
					if LastShootingStart ~= shooting_start then
						Revs = 0
					else
						Revs = Revs + 1
						local reload_reduce = math.min(7, Revs ^ (1/1.5))
						current_reload_time = current_reload_time - reload_reduce
					end
				end
				LastShootingStart = shooting_start
			end

			mag2 = mag2 or 200
			if mag2 == 1 then
				current_reload_time = current_reload_time + 40
				mag2 = 200
				Revs = 0
				GamePlaySound("mods/noita.fairmod/fairmod.bank", "tenno/reload", x, y)
			end
			--GameCreateParticle("plastic_red", x, y - 4, 1, math.random(-5, 5), -10, false)
			add_projectile("mods/noita.fairmod/files/content/immortal_snail/gun/entities/bullet_soma.xml")
			c.fire_rate_wait = c.fire_rate_wait - 3
			c.screenshake = c.screenshake + 0.1
			-- c.copi_swag = true
			mag2 = mag2 - 1
		end
	end,
}
actions[#actions + 1] = {
	id = "MODIFIER_ONLY_ULTRAFAIR",
	name = "Modifiers Only",
	description = "You can only cast modifiers.",
	sprite = "mods/noita.fairmod/files/content/immortal_snail/gun/ui_gfx/modifier_only.png",
	type = ACTION_TYPE_OTHER,
	spawn_level = "0,0",
	spawn_probability = "0,0",
	price = 170,
	mana = -25,
	action = function()
		if not reflecting then
			for i=#deck, 1, -1 do
				if deck[i].type~=2 then
					table.remove(deck, i)
				end
			end
		end
	end,
}

for i=1, #actions do
	if mana then
		if actions[i].mana > 0 then
			actions[i].mana = actions[i].mana + 1
		end
	end
end