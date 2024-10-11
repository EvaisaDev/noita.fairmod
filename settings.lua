dofile("data/scripts/lib/mod_settings.lua")
local mod_id = "noita.fairmod"
mod_settings_version = 1 -- This is a magic global that can be used to migrate settings to new mod versions. call mod_settings_get_version() before mod_settings_update() to get the old value.
mod_settings = {}

local function PatchGamesInitlua()
	local file = "data/scripts/init.lua"
	local patch = "mods/noita.fairmod/files/content/biome_mods/biome_modifiers_patch.lua"
	local file_appends = ModLuaFileGetAppends(file)

	for _, append in ipairs(file_appends) do
		if append == patch then
			return
		end
	end

	ModLuaFileAppend(file, patch)
end

-- This function is called to ensure the correct setting values are visible to the game. your mod's settings don't work if you don't have a function like this defined in settings.lua.
function ModSettingsUpdate(init_scope)
	local old_version = mod_settings_get_version(mod_id) -- This can be used to migrate some settings between mod versions.
	mod_settings_update(mod_id, mod_settings, init_scope)
	if init_scope == 0 or init_scope == 1 then
		PatchGamesInitlua()
	end
	if settings_needs_to_build then
		BuildSettings()
	end
end

-- This function should return the number of visible setting UI elements.
-- Your mod's settings wont be visible in the mod settings menu if this function isn't defined correctly.
-- If your mod changes the displayed settings dynamically, you might need to implement custom logic for this function.
function ModSettingsGuiCount()
	return mod_settings_gui_count(mod_id, mod_settings)
end

-- This function is called to display the settings UI for this mod. your mod's settings wont be visible in the mod settings menu if this function isn't defined correctly.
function ModSettingsGui(gui, in_main_menu)
	mod_settings_gui(mod_id, mod_settings, gui, in_main_menu)
end
