
local old_item_pickup = item_pickup
item_pickup = function(entity_item, entity_who_picked, item_name)
	if entity_who_picked ~= nil then
		local x, y = EntityGetTransform(entity_item)

		local biome_filename = DebugBiomeMapGetFilename(x, y) or ""
		local is_boss_arena = biome_filename:match("boss_arena") ~= nil
		if biome_filename:match("temple_altar") ~= nil or is_boss_arena then
			if ProceduralRandom(x + entity_item, y + GameGetFrameNum(), 1, 100) <= 2 then
				local x_offset = is_boss_arena and 2585 or 0

				local world_width = BiomeMapGetSize()
				local pw_offset_x = 512 * world_width * GetParallelWorldPosition(x, y)

				GamePlaySound("data/audio/Desktop/misc.bank", "misc/temple_collapse", pw_offset_x + x_offset, y - 10)
				EntityLoad("data/entities/particles/image_emitters/magical_symbol.xml", pw_offset_x + x_offset, y - 10)
				EntityLoad("mods/noita.fairmod/files/content/collapse/screen_shaker.xml", pw_offset_x + x_offset, y - 10)
			end
		end
	end
	old_item_pickup(entity_item, entity_who_picked, item_name)
end
