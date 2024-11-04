local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml


ModMaterialsFileAdd("mods/noita.fairmod/files/content/backrooms/materials.xml")


for xml in nxml.edit_file("data/biome/_biomes_all.xml") do
	for biome in xml:each_of("Biome") do
		local biome_name = biome.attr.biome_filename
		if biome_name == "data/biome/the_end.xml" then biome.attr.biome_filename = "mods/noita.fairmod/files/content/backrooms/backrooms.xml" end
	end
end
