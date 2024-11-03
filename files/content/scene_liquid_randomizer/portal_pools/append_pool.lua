spawn_altar_top = function(x, y, is_solid)
	SetRandomSeed(x, y)
	local file_visual = "data/biome_impl/temple/altar_top_visual.png"

	LoadBackgroundSprite("data/biome_impl/temple/wall_background.png", x - 1, y - 30, 35)

	--[[
	local valid_pools = {}

	local liquids = CellFactory_GetAllLiquids(false, false) or {}

	for k, v in ipairs(liquids) do
		if(ModImageDoesExist("mods/noita.fairmod/custom_hm_pools/hm_pool_"..v..".png"))then
			table.insert(valid_pools, "mods/noita.fairmod/custom_hm_pools/hm_pool_"..v..".png")
		end
	end
	]]

	if y > 12000 then
		LoadPixelScene("data/biome_impl/temple/altar_top_boss_arena.png", file_visual, x, y - 40, "", true)
	else
		--LoadPixelScene( valid_pools[Random(1, #valid_pools)], file_visual, x, y-40, "", true )
		LoadPixelScene("data/biome_impl/temple/altar_top_water.png", file_visual, x, y - 40, "", true)
		EntityLoad("mods/noita.fairmod/files/content/scene_liquid_randomizer/portal_pools/convert_materials.xml", x, y - 40)
	end

	if is_solid then LoadPixelScene("data/biome_impl/temple/solid.png", "", x, y - 40 + 300, "", true) end
end
