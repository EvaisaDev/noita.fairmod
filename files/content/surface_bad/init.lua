local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml


ModLuaFileAppend("data/scripts/biomes/mountain/mountain_top.lua", "mods/noita.fairmod/files/content/surface_bad/mountain_append.lua")
ModLuaFileAppend("data/scripts/biomes/mountain_lake.lua", "mods/noita.fairmod/files/content/surface_bad/mountain_lake_append.lua")


local peaceful_biomes = { "hills", "desert", "winter", "lake" }

for _, biome in ipairs(peaceful_biomes) do
	for xml in nxml.edit_file("data/biome/" .. biome .. ".xml") do
		local mats = xml:first_of("Materials")
		if mats ~= nil then
			mats:add_child(nxml.new_element("VegetationComponent",{
				tree_probability="0.9",
				rand_seed="8674.1",
				tree_width="30",
				is_visual="1",
				tree_extra_y="-50",
				load_this_xml_instead="mods/noita.fairmod/files/content/surface_bad/surface_spawner.xml",
				tree_image_visual="",
			}))
		end
	end
end
