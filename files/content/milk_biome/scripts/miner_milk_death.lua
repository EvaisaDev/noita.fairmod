
--stylua: ignore start
function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	-- kill self
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )

	SetRandomSeed( pos_x + pos_y, pos_x + pos_y + 666)

	-- do some kind of an effect? throw some particles into the air?
	local rng = Random( 1, 5)

	if rng == 1 then
		EntityLoad( "mods/noita.fairmod/files/content/milk_biome/entities/items/pickup/endless_milk_potion.xml", pos_x, pos_y )
	end
		
end
--stylua: ignore end
