local init = {}

function findCenteredImagePosition(gui, image_file, scale)
	local width, height = GuiGetScreenDimensions(gui)
	local image_width, image_height = GuiGetImageDimensions(gui, image_file, scale)
	local x = (width - image_width) / 2
	local y = (height - image_height) / 2
	return x, y
end

function init.OnPlayerSpawned(player)
	dofile("data/scripts/lib/utilities.lua")
	dofile("data/scripts/perks/perk.lua")
	dofile("data/scripts/perks/perk_list.lua")

	--[[EntityAddComponent2(player, "LuaComponent", {
        execute_every_n_frame = 1,
        execute_on_added = true,
        script_source_file = "mods/noita.fairmod/files/content/tmtrainer/files/scripts/player_update.lua",
    });]]
end

function init.OnMagicNumbersAndWorldSeedInitialized()
	-- Load necessary scripts to access actions and perks
	dofile("data/scripts/gun/gun_actions.lua")
	dofile("data/scripts/perks/perk_list.lua")

	-- Initialize paths for action and perk icons
	local action_icon_path = "mods/noita.fairmod/files/content/tmtrainer/files/spell_icons/"
	local perk_icon_path = "mods/noita.fairmod/files/content/tmtrainer/files/perk_icons/"

	-- Set the maximum number of icons to process
	local corrupted_sprite_count = #actions + 100 -- Account for additional icons

	-- Make action (spell) icons editable
	for i = 0, corrupted_sprite_count do
		local action_icon_filename = action_icon_path .. i .. ".png"
		ModImageMakeEditable(action_icon_filename, 16, 16)

		-- If the action exists, make its sprite editable
		local action = actions[i]
		if action and action.sprite then ModImageMakeEditable(action.sprite, 16, 16) end
	end

	-- Make perk icons editable (both ui_icon and perk_icon)
	for i = 1, corrupted_sprite_count do
		local ui_icon_filename = perk_icon_path .. "ui_icon_" .. i .. ".png"
		local perk_icon_filename = perk_icon_path .. "perk_icon_" .. i .. ".png"
		ModImageMakeEditable(ui_icon_filename, 16, 16)
		ModImageMakeEditable(perk_icon_filename, 16, 16)

		-- If the perk exists, make its icons editable
		local perk = perk_list[i]
		if perk then
			if perk.ui_icon then ModImageMakeEditable(perk.ui_icon, 16, 16) end
			if perk.perk_icon then ModImageMakeEditable(perk.perk_icon, 16, 16) end
		end
	end

	-- Copy event utilities script to an alternate path
	local alt_event_utils = ModTextFileGetContent("data/scripts/streaming_integration/event_utilities.lua")
	ModTextFileSetContent("data/scripts/streaming_integration/alt_event_utils.lua", alt_event_utils)

	-- Append custom action and perk scripts
	ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/noita.fairmod/files/content/tmtrainer/files/scripts/append/gun_actions.lua")
	ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/noita.fairmod/files/content/tmtrainer/files/scripts/append/perk_list.lua")

	-- Prepend gun_enums to gun_actions.lua for proper initialization
	local gun_actions_content = ModTextFileGetContent("data/scripts/gun/gun_actions.lua")
	gun_actions_content = 'dofile_once("data/scripts/gun/gun_enums.lua")\n\n' .. gun_actions_content
	ModTextFileSetContent("data/scripts/gun/gun_actions.lua", gun_actions_content)
end

return init
