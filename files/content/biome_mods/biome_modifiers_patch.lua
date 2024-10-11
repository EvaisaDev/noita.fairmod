function has_modifiers()
	return true
end
function biome_modifier_applies_to_biome()
	return true
end
local list = { "clouds", "the_end", "the_sky", "dragoncave", "wandcave", "wizardcave" }
for _, v in ipairs(list) do
	table.insert(biomes, { "data/biome/" .. v .. ".xml" })
end
