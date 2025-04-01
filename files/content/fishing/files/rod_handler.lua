--[[

x, y, r, s1, s2 = EntityGetTransform(rod)

EntityApplyTransform(rod, x, y, r + 2.5, s1, s2)

]]

dofile_once("mods/noita.fairmod/files/content/fishing/files/eva_utils.lua")
function has_catch()
	return EntityHasFlag(bobber, "has_catch")
end

dofile_once("data/scripts/lib/utilities.lua")

function enabled_changed(rod, is_enabled)


	bobber = EntityGetVariable(rod, "bobber_entity", "int")
	line = EntityGetVariable(rod, "rope_entity", "int")

	if is_enabled == false then
		if has_catch() then GameAddFlagRun("kill_fishing_challenge_ui") end
		if bobber ~= nil then
			EntityKill(bobber)

			children = EntityGetAllChildren(rod)
			local item_component = EntityGetComponentIncludingDisabled(children[1], "ItemComponent")[1]

			if item_component ~= nil then
				--ComponentSetValue2( item_component, "uses_remaining", ComponentGetValue2(item_component, "uses_remaining" ) + 1 )
				--GamePrint(ComponentGetValue2(item_component, "uses_remaining" ))
			end

			local inventory2 = EntityGetFirstComponent(EntityGetRootEntity(rod), "Inventory2Component")
			if inventory2 ~= nil then
				ComponentSetValue2(inventory2, "mForceRefresh", true)
				ComponentSetValue2(inventory2, "mActualActiveItem", 0)
			end
		end
		if line ~= nil then EntityKill(line) end
	end
end

--print("???????????????")

local rod = GetUpdatedEntityID()
local holder = EntityGetRootEntity(rod)
local bobber = EntityGetVariable(rod, "bobber_entity", "int")

-- distance between rod and holder
if bobber ~= nil then

	if(not EntityGetIsAlive(bobber))then
		--print("bobber is dead")
		EntitySetVariable(rod, "bobber_entity", "int", 0)
		return
	end

	local x, y = EntityGetTransform(bobber)
	local x2, y2 = EntityGetTransform(holder)

	local distance = math.sqrt((x - x2)^2 + (y - y2)^2)
	--print(distance)

	if(holder == rod or distance >= 300)then
		line = EntityGetVariable(rod, "rope_entity", "int")

		if has_catch() then GameAddFlagRun("kill_fishing_challenge_ui") end
		if bobber ~= nil then
			EntityKill(bobber)

			children = EntityGetAllChildren(rod)
			local item_component = EntityGetComponentIncludingDisabled(children[1], "ItemComponent")[1]

			if item_component ~= nil then
				--ComponentSetValue2( item_component, "uses_remaining", ComponentGetValue2(item_component, "uses_remaining" ) + 1 )
				--GamePrint(ComponentGetValue2(item_component, "uses_remaining" ))
			end

			local inventory2 = EntityGetFirstComponent(EntityGetRootEntity(rod), "Inventory2Component")
			if inventory2 ~= nil then
				ComponentSetValue2(inventory2, "mForceRefresh", true)
				ComponentSetValue2(inventory2, "mActualActiveItem", 0)
			end
		end
		if line ~= nil then EntityKill(line) end

	end

end