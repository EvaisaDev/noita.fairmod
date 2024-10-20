local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

for plyr in nxml.edit_file("data/entities/player_base.xml") do
	local dmgModel = plyr:first_of("DamageModelComponent")
	if dmgModel ~= nil then
		dmgModel:set("materials_that_damage", dmgModel:get("materials_that_damage") .. ",cactus")
		dmgModel:set("materials_how_much_damage", dmgModel:get("materials_how_much_damage") .. ",0.002")
	end
end

for biome in nxml.edit_file("data/biome/desert.xml") do
	local mats = biome:first_of("Materials")
	if mats ~= nil then
		for i = #mats.children, 1, -1 do
			if mats.children[i]:get("tree_material") == "cactus" then mats:remove_child_at(i) end
		end

		mats:add_children({
			nxml.new_element("VegetationComponent", {
				is_visual = "1",
				rand_seed = "8576.86",
				tree_extra_y = "-25",
				tree_probability = "0.228571",
				tree_radius_high = "0.614286",
				tree_radius_low = "0.228571",
				tree_width = "66.1143",
				load_this_xml_instead = "mods/noita.fairmod/files/content/cactus/cactus_spawner1.xml",
				tree_image_visual = "",
			}),
			nxml.new_element("VegetationComponent", {
				is_visual = "1",
				rand_seed = "34676.86",
				tree_extra_y = "-25",
				tree_probability = "0.328571",
				tree_radius_high = "0.414286",
				tree_radius_low = "0.228571",
				tree_width = "58.1143",
				load_this_xml_instead = "mods/noita.fairmod/files/content/cactus/cactus_spawner2.xml",
				tree_image_visual = "",
			}),
		})
	end
end
