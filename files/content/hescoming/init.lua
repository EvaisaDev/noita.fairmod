ModMaterialsFileAdd("mods/noita.fairmod/files/content/hescoming/materials.xml")

local M = {}

local function apply_item_changes(message)
	local cx, cy = GameGetCameraPos()
	for i, entity_id in ipairs(EntityGetInRadius(cx, cy, 1000)) do
		local item_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "ItemComponent")
		if item_comp then
			ComponentSetValue2(item_comp, "item_name", message)
			ComponentSetValue2(item_comp, "ui_description", message)
			ComponentSetValue2(item_comp, "always_use_item_name_in_ui", true)
		end
	end
end

local function print_messages(current_frame, message)
	if current_frame % 60 == 0 then GamePrint(message) end
	if current_frame % 300 == 0 then GamePrintImportant(message, message) end
end

local function apply_material_converter()
	local player = EntityGetWithTag("player_unit")[1]
	if player then
		local found = false
		for i, component_id in
			ipairs(EntityGetComponentIncludingDisabled(player, "MagicConvertMaterialComponent") or {})
		do
			if ComponentGetValue2(component_id, "to_material") == CellFactory_GetType("hescoming") then
				found = true
				break
			end
		end
		if not found then
			EntityAddComponent2(player, "MagicConvertMaterialComponent", {
				kill_when_finished = false,
				from_any_material = true,
				steps_per_frame = 1,
				to_material = CellFactory_GetType("hescoming"),
				clean_stains = false,
				is_circle = true,
				radius = 100,
				convert_same_material = false,
			})
		end
	end
end

local function hes_coming(current_frame)
	local message = GlobalsGetValue("hescoming_message", "He's coming") or ""
	if current_frame % 60 == 0 then
		apply_material_converter()
		apply_item_changes(message)
	end
	print_messages(current_frame, message)
end

local function condition_check()
	local year, month, day, hour, minute, second = GameGetDateAndTimeLocal()
	-- Check if it's time to activate "Him"
	if hour == 3 and minute == 33 then return true end
	return false
end

function M.update()
	local current_frame = GameGetFrameNum()
	if GlobalsGetValue("hescoming_spawned", "0") == "0" then
		-- If he has been activated, but not spawned yet, wait until 600 frames (10 seconds) have passed
		if tonumber(GlobalsGetValue("hescoming_startframe", "999999999999")) + 600 < current_frame then
			GlobalsSetValue("hescoming_spawned", "1")
			-- Store the message that should display in globals so it persists over restarts
			GlobalsSetValue("hescoming_message", "He's here")
			-- Spawn "Him"
			local cx, cy = GameGetCameraPos()
			EntityLoad("mods/noita.fairmod/files/content/hescoming/he.xml", cx, cy - 500)
		end
	end
	if GlobalsGetValue("hescoming_startframe", "999999999999") ~= "999999999999" then
		hes_coming(current_frame)
	elseif condition_check() then
		GlobalsSetValue("hescoming_startframe", tostring(current_frame))
	end
end

function M.OnPlayerDied(player_entity)
	GlobalsSetValue("hescoming_message", "He was here")
end

return M
