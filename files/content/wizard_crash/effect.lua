local ent = EntityGetRootEntity(GetUpdatedEntityID())
if not EntityHasTag(ent, "player_unit") and not EntityHasTag(ent, "player_polymorphed") then
	EntityKill(ent)
	return
end

local x, y = EntityGetTransform(ent)
SetRandomSeed(x, y)

local effects = {
	function()
		EntityKill(GameGetWorldStateEntity())
	end,
	function()
		local world_width = BiomeMapGetSize() * 512
		if Random(1,2) == 1 then
			world_width = -world_width
		end
		EntitySetTransform(ent, x + world_width, y)
	end,
	function()
		GameDropAllItems(ent)
	end,
	function()
		dofile("data/scripts/newgame_plus.lua")
		do_newgame_plus()
	end,
	function()
		-- Already-fucked-up root growers
		EntityLoad("data/entities/props/root_grower.xml", x+40, y)
		EntityLoad("data/entities/props/root_grower.xml", x-40, y)
		EntityLoad("data/entities/props/root_grower.xml", x, y+30)
		EntityLoad("data/entities/props/root_grower.xml", x, y-55)
		EntityLoad("data/entities/props/root_grower.xml", x+20, y+15)
		EntityLoad("data/entities/props/root_grower.xml", x+20, y-25)
		EntityLoad("data/entities/props/root_grower.xml", x-20, y+15)
		EntityLoad("data/entities/props/root_grower.xml", x-20, y-25)
	end,
	function()
		-- End of Everything
		EntityLoad("data/entities/projectiles/deck/all_spells_loader.xml", x, y)
	end,
	function()
		-- Curse of greed
		local cid = EntityLoad( "data/entities/misc/greed_curse/greed.xml", x, y )
		EntityAddComponent( cid, "UIIconComponent",
		{
			name = "$log_curse",
			description = "$itemdesc_essence_greed",
			icon_sprite_file = "data/ui_gfx/status_indicators/greed_curse.png"
		})
		EntityAddChild( ent, cid )

		GameAddFlagRun( "greed_curse" )
		AddFlagPersistent( "greed_curse_picked" )

		GamePrintImportant( "$log_curse", "$logdesc_greed_curse" )
	end,
	function ()
		-- random essence
		local essences = { "fire", "laser", "air", "water", "alcohol" }

		local id = essences[Random(1, #essences)]

		local ui_icon = "data/ui_gfx/essence_icons/" .. id .. ".png"
		local entity_ui = EntityCreateNew( "" )
		local essence_name = "$item_essence_" .. id
		local essence_desc = "$itemdesc_essence_" .. id
		EntityAddComponent( entity_ui, "UIIconComponent",
		{
			name = essence_name,
			description = essence_desc,
			icon_sprite_file = ui_icon
		})
		EntityAddTag( entity_ui, "essence_effect" )
		EntityAddChild( ent, entity_ui )

		local essence_file = "data/entities/misc/essences/" .. id .. ".xml"
		local essence_id = EntityLoad(essence_file, x, y)
		EntityAddChild(ent, essence_id)

		GameAddFlagRun( "essence_" .. id )
		AddFlagPersistent( "essence_" .. id )

		local globalskey = "ESSENCE_" .. string.upper(id) .. "_PICKUP_COUNT"
		local pickups = tonumber( GlobalsGetValue( globalskey, "0" ) )
		GlobalsSetValue( globalskey, tostring(pickups + 1) )

		GamePrintImportant( GameTextGet( "$log_pickedup_perk", GameTextGetTranslatedOrNot( essence_name ) ), essence_desc )
	end,
}
effects[Random(1, #effects)]()
