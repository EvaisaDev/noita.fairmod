dofile_once("mods/noita.fairmod/files/content/scene_liquid_randomizer/material_restrictions.lua")


local function rand_material(x, y)
	SetRandomSeed(x, y + GameGetFrameNum())

	local liquids = HMMaterialsFilter(CellFactory_GetAllLiquids(false, false) or {}, true)
	return liquids[Random(1, #liquids)]
end


local old_LoadPixelScene = LoadPixelScene
function LoadPixelScene(materials_filename, colors_filename, x, y, background_file, skip_biome_checks, skip_edge_textures, color_to_material_table, background_z_index, load_even_if_duplicate)
	if materials_filename:match("altar") then
		color_to_material_table = { ["2F554C"] = rand_material(x, y) }
	end
	old_LoadPixelScene(materials_filename, colors_filename, x, y, background_file, skip_biome_checks, skip_edge_textures, color_to_material_table, background_z_index, load_even_if_duplicate)
end