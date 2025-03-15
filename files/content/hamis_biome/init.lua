local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") ---@type nxml

for xml in nxml.edit_file("data/biome/_biomes_all.xml") do
	xml:add_child(nxml.new_element("Biome", {
		biome_filename = "mods/noita.fairmod/files/content/hamis_biome/biome/biome.xml",
		height_index = 0,
		color = "ff83cd36",
	}))
end

ModLuaFileAppend("data/scripts/biome_map.lua", "mods/noita.fairmod/files/content/hamis_biome/biome/biome_map_appends.lua")
