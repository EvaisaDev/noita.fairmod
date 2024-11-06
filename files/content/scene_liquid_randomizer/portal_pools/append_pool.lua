dofile_once("mods/noita.fairmod/files/content/scene_liquid_randomizer/material_restrictions.lua")

local old_LoadPixelScene = LoadPixelScene
LoadPixelScene = function(materials_filename, colors_filename, x, y, background_file, skip_biome_checks, skip_edge_textures, color_to_material_table, background_z_index, load_even_if_duplicate)
	if materials_filename:match("altar_top") then
		SetRandomSeed(x, y)
		local liquids = HMMaterialsFilter(CellFactory_GetAllLiquids(false, false) or {})
		local random_liquid = liquids[Random(1, #liquids)]

		local color_material = { ["2f554c"] = random_liquid }
		materials_filename = "data/biome_impl/temple/altar_top_water.png"
		return old_LoadPixelScene(materials_filename, colors_filename, x, y, background_file, skip_biome_checks, skip_edge_textures, color_material, background_z_index, load_even_if_duplicate)
	end

	return old_LoadPixelScene(materials_filename, colors_filename, x, y, background_file, skip_biome_checks, skip_edge_textures, color_to_material_table, background_z_index, load_even_if_duplicate)
end
