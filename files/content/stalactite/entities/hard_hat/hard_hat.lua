local hat_entity = nil

function item_pickup( entity_item, entity_pickupper, item_name )

	if(EntityHasTag(entity_pickupper, "player_unit"))then
		local entity_id = GetUpdatedEntityID()
		
		local player = entity_pickupper
		local x,  y = EntityGetTransform(player)
		local hat = EntityLoad("mods/noita.fairmod/files/content/stalactite/entities/hard_hat/hat_entity.xml", x, y)

		EntityAddChild(player, hat)

		
		GameAddFlagRun("hard_hat_worn")
	
		hat_entity = hat
	end
end

function throw_item( from_x, from_y, to_x, to_y )
    local entity_id = GetUpdatedEntityID()

    if(hat_entity ~= nil)then
		local player = EntityGetRootEntity(entity_id)

        EntityKill(hat_entity)

		GameRemoveFlagRun("hard_hat_worn")
    end
end