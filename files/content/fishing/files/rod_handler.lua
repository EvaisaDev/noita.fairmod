

--[[

x, y, r, s1, s2 = EntityGetTransform(rod)

EntityApplyTransform(rod, x, y, r + 2.5, s1, s2)

]]

dofile_once("mods/noita.fairmod/files/content/fishing/files/eva_utils.lua")
function has_catch() 
	return EntityHasFlag(bobber, "has_catch") 
end


function enabled_changed( rod, is_enabled )
	dofile_once("mods/noita.fairmod/files/content/fishing/files/eva_utils.lua")
	dofile_once("data/scripts/lib/utilities.lua")

	bobber = EntityGetVariable(rod, "bobber_entity", "int")
	line = EntityGetVariable(rod, "rope_entity", "int")

	if(is_enabled == false)then


		if(has_catch())then
			GameAddFlagRun("kill_fishing_challenge_ui")
		end
		if(bobber ~= nil)then
			EntityKill(bobber)


			children = EntityGetAllChildren(rod)
			local item_component = EntityGetComponentIncludingDisabled( children[1], "ItemComponent")[1];
	
			if(item_component ~= nil)then
				--ComponentSetValue2( item_component, "uses_remaining", ComponentGetValue2(item_component, "uses_remaining" ) + 1 )
				--GamePrint(ComponentGetValue2(item_component, "uses_remaining" ))
			end
	
			local inventory2 = EntityGetFirstComponent( EntityGetRootEntity(rod), "Inventory2Component" );
			if inventory2 ~= nil then
				ComponentSetValue2( inventory2, "mForceRefresh", true );
				ComponentSetValue2( inventory2, "mActualActiveItem", 0)
			end
		end
		if(line ~= nil)then
			EntityKill(line)
		end
	end
end