local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") ---@type nxml

for xml in nxml.edit_file("data/biome/_biomes_all.xml") do
	xml:add_child(nxml.new_element("Biome", {
		biome_filename = "data/biome/fairmod_cauldron.xml",
		height_index = 0,
		color = "ff83cd37",
	}))
end

ModLuaFileAppend("data/scripts/biome_map.lua", "mods/noita.fairmod/files/content/cauldron/biome/append.lua")

ModMaterialsFileAdd("mods/noita.fairmod/files/content/cauldron/materials.xml")
