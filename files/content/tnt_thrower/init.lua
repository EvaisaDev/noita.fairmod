local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

for xml in nxml.edit_file("data/entities/animals/miner.xml") do
	local ai = xml:first_of("Base"):first_of("AnimalAIComponent")

	if ai ~= nil then
		ai:set("attack_ranged_entity_file", "mods/noita.fairmod/files/content/tnt_thrower/tnt_random.xml")
		ai:set("attack_ranged_max_distance", 240)
		ai:set("attack_ranged_entity_count_min", 1)
		ai:set("attack_ranged_entity_count_max", 4)
		ai:set("attack_ranged_frames_between", 50)
		ai:set("attack_ranged_predict", 1)
		ai:set("dont_counter_attack_own_herd", 1)
	end

	xml:add_child(nxml.new_element("GameEffectComponent", {
		effect = "PROTECTION_EXPLOSION",
		frames = "-1",
	}))
end

for xml in nxml.edit_file("data/entities/animals/miner_weak.xml") do
	local base = xml:first_of("Base")

	if base ~= nil then
		base:add_children({
			nxml.new_element("GameEffectComponent", {
				frames = 60,
			}),
			nxml.new_element("AnimalAIComponent", {
				attack_ranged_entity_count_max = 2
			})
		})
	end
end
