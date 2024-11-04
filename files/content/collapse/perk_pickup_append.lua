

local old_item_pickup = item_pickup
item_pickup = function(entity_item, entity_who_picked, item_name)
	if entity_who_picked ~= nil then
		local x,y = EntityGetTransform(entity_who_picked)

		if ProceduralRandom(x + entity_item, y + GameGetFrameNum(), 1, 100) <= 2 then
			GamePlaySound("data/audio/Desktop/misc.bank", "misc/temple_collapse", x, y - 40)
			EntityLoad("data/entities/particles/image_emitters/magical_symbol.xml", x, y - 40)
			EntityLoad("mods/noita.fairmod/files/content/collapse/screen_shaker.xml", x, y - 40)
		end
	end
	old_item_pickup(entity_item, entity_who_picked, item_name)
end
