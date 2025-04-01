local nxml = dofile("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

for xml in nxml.edit_file("data/entities/animals/boss_dragon.xml") do
	xml:add_child(nxml.new_element("ParticleEmitterComponent", {
		emitted_material_name = "lava",
		create_real_particles = true,
		count_min = 10,
		count_max = 30,
	}))
	xml:add_child(nxml.new_element("MagicConvertMaterialComponent", {
		is_circle = true,
		from_material_tag = "[gas]",
		to_material = "liquid_fire",
		kill_when_finished = false,
		loop = true,
	}))
	local dragon_comp = xml:first_of("BossDragonComponent")
	if dragon_comp then
		dragon_comp:set("speed", 6)
		dragon_comp:set("speed_hunt", 6)
		dragon_comp:set("direction_adjust_speed", 1)
		dragon_comp:set("direction_adjust_speed_hunt", 0.05)
		dragon_comp:set("acceleration", 5)
		dragon_comp:set("projectile_1_count", 4)
		dragon_comp:set("projectile_2_count", 10)
	end
end

for xml in nxml.edit_file("data/entities/projectiles/orb_green_boss_dragon.xml") do
	xml:add_child(nxml.new_element("ParticleEmitterComponent", {
		emitted_material_name = "acid",
		create_real_particles = true,
		count_min = 1,
		count_max = 10,
	}))
end
