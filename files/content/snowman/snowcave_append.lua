

local old_LoadPixelScene = LoadPixelScene
LoadPixelScene = function(materials_filename, colors_filename, x, y, ...)
	if materials_filename == "data/biome_impl/snowperson.png" then
		EntityLoad("mods/noita.fairmod/files/content/snowman/snowman.xml", x, y)
	else
		return old_LoadPixelScene(materials_filename, colors_filename, x, y, ...)
	end
end

table.insert(g_small_enemies, {
	prob = 0.05,
	min_count = 1,
	max_count = 1,
	entity = "mods/noita.fairmod/files/content/snowman/snowman.xml"
})
