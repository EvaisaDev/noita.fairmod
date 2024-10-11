if GameHasFlagRun("fairmod_perks_monster_wands") then
    local victim = GetUpdatedEntityID()
    local picker = EntityGetFirstComponentIncludingDisabled( victim, "ItemPickUpperComponent" )
    if picker ~= nil then
        local x, y = EntityGetTransform( victim )
		local rarity = tostring(math.random( 1, 3 ))
		if math.random(1,50)== 1 then
			rarity = tostring(math.random( 4, 6 ))
		end
        local file = table.concat{ "data/scripts/streaming_integration/entities/wand_level_0", rarity, ".xml" }
        local wand = EntityLoad( file, x, y )
        GamePickUpInventoryItem(victim, wand, false)

        -- Set 10% drop chance
        ComponentSetValue2(picker, "drop_items_on_death", math.random(1, 10) == 1)
    end
end
