dofile_once("data/scripts/lib/mod_settings.lua")

local mod_id = "noita.fairmod"
local prfx = mod_id .. "."

local function PatchGamesInitlua()
	local file = "data/scripts/init.lua"
	local patch = "mods/noita.fairmod/files/content/biome_mods/biome_modifiers_patch.lua"
	local file_appends = ModLuaFileGetAppends(file)

	for _, append in ipairs(file_appends) do
		if append == patch then return end
	end

	ModLuaFileAppend(file, patch)
end

local function PrintHamis()
	local function head(text)
		return "\27[38;2;82;49;111m" .. text .. "\27[0m"
	end
	local function eye(text)
		return "\27[38;2;199;239;99m" .. text .. "\27[0m"
	end
	local function leg(text)
		return "\27[38;2;45;27;61m" .. text .. "\27[0m"
	end
	local function toe(text)
		return "\27[38;2;102;78;129m" .. text .. "\27[0m"
	end

	print(head("         ######"))
	print(head("         ######"))
	print(head("      ###" .. eye("###") .. head("######")))
	print(head("      ###" .. eye("###") .. head("######")))
	print(head("      #########" .. eye("###")))
	print(head("      #########" .. eye("###")))
	print(leg("   ###") .. head("###") .. eye("###") .. head("######"))
	print(leg("   ###") .. head("###") .. eye("###") .. head("######"))
	print(leg("   ###   ") .. head("######   ") .. leg("###"))
	print(leg("   ###   ") .. head("######   ") .. leg("###"))
	print(leg("###      ###      ###"))
	print(leg("###      ###      ###"))
	print(leg("###      ###      ###"))
	print(leg("###      ###      ###"))
	print(leg("###      ###      ") .. toe("###"))
	print(leg("###      ###      ") .. toe("###"))
	print(toe("###      ###"))
	print(toe("###      ###"))
end

--- gather keycodes from game file
local function gather_key_codes()
	local arr = {}
	arr["0"] = GameTextGetTranslatedOrNot("$menuoptions_configurecontrols_action_unbound")
	local keycodes_all = ModTextFileGetContent("data/scripts/debug/keycodes.lua")
	for line in keycodes_all:gmatch("Key_.-\n") do
		local _, key, code = line:match("(Key_)(.+) = (%d+)")
		arr[code] = key:upper()
	end
	return arr
end
local keycodes = gather_key_codes()

local function pending_input()
	for code, _ in pairs(keycodes) do
		if InputIsKeyJustDown(code) then return code end
	end
end

local function ui_get_input(_, gui, _, im_id, setting)
	local setting_id = prfx .. setting.id
	local current = tostring(ModSettingGetNextValue(setting_id)) or "0"
	local current_key = "[" .. keycodes[current] .. "]"

	if setting.is_waiting_for_input then
		current_key = GameTextGetTranslatedOrNot("$menuoptions_configurecontrols_pressakey")
		local new_key = pending_input()
		if new_key then
			ModSettingSetNextValue(setting_id, new_key, false)
			setting.is_waiting_for_input = false
		end
	end

	GuiLayoutBeginHorizontal(gui, 0, 0, true, 0, 0)
	GuiText(gui, mod_setting_group_x_offset, 0, setting.ui_name)

	GuiText(gui, 8, 0, "")
	local _, _, _, x, y = GuiGetPreviousWidgetInfo(gui)
	local w, h = GuiGetTextDimensions(gui, current_key)
	GuiOptionsAddForNextWidget(gui, GUI_OPTION.ForceFocusable)
	GuiImageNinePiece(gui, im_id, x, y, w, h, 0)
	local _, _, hovered = GuiGetPreviousWidgetInfo(gui)
	if hovered then
		GuiTooltip(gui, setting.ui_description, GameTextGetTranslatedOrNot("$menuoptions_reset_keyboard"))
		GuiColorSetForNextWidget(gui, 1, 1, 0.7, 1)
		if InputIsMouseButtonJustDown(1) then setting.is_waiting_for_input = true end
		if InputIsMouseButtonJustDown(2) then
			GamePlaySound("ui", "ui/button_click", 0, 0)
			ModSettingSetNextValue(setting_id, setting.value_default, false)
			setting.is_waiting_for_input = false
		end
	end
	GuiText(gui, 0, 0, current_key)

	GuiLayoutEnd(gui)
end

local function break_this_window(_, gui, _, im_id, setting)
	local text = setting.ui_name .. ": " .. GameTextGet(setting.break_it and "$option_on" or "$option_off")

	local clicked, right_clicked = GuiButton(gui, im_id, mod_setting_group_x_offset, 0, text)
	local _, _, _, _, y = GuiGetPreviousWidgetInfo(gui)
	if clicked or right_clicked then setting.break_it = not setting.break_it end

	GuiTooltip(gui, setting.ui_description, "")

	GuiOptionsAddForNextWidget(gui, GUI_OPTION.Layout_NoLayouting)
	GuiImage(gui, im_id, 430, y - 80, "data/enemies_gfx/longleg.xml", 1, 8, 8, 0, GUI_RECT_ANIMATION_PLAYBACK.Loop, "pet")

	if setting.break_it then local lol = nil + 0 end
end

local function mod_setting_integer(_, gui, in_main_menu, im_id, setting)
	local id = prfx .. setting.id
	local value = ModSettingGetNextValue(id)

	local value_new = GuiSlider(
		gui,
		im_id,
		mod_setting_group_x_offset,
		0,
		setting.ui_name,
		value,
		setting.value_min,
		setting.value_max,
		setting.value_default,
		setting.value_display_multiplier or 1,
		setting.value_display_formatting or "",
		64
	)
	value_new = math.floor(value_new + 0.5)
	if value ~= value_new then ModSettingSetNextValue(id, value_new, false) end

	mod_setting_tooltip(mod_id, gui, in_main_menu, setting)
end

local function build_settings()
	local settings = {
		{
			category_id = "game_modes",
			ui_name = "Game Modes",
			ui_description = "Settings related to game modes",
			settings = {
				{
					id = "streamer_mode",
					ui_name = "Streamer mode",
					ui_description = "Replaces content that could cause copyright issues. (Requires restart)",
					value_default = false,
					scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
				},
				{
					id = "colorblind_mode",
					ui_name = "Colorblindness Mode",
					ui_description = "Makes you color blind.",
					value_default = false,
					scope = MOD_SETTING_SCOPE_RUNTIME,
				},
				{
					id = "lower_resolution_rendering",
					ui_name = "Lower Resolution Rendering",
					ui_description = "Will not in-fact improve performance.",
					value_default = false,
					scope = MOD_SETTING_SCOPE_RUNTIME,
				},
				{
					id = "8_bit_color",
					ui_name = "8-Bit Color Mode",
					ui_description = "Will render the game in glorious 8-bit color!",
					value_default = false,
					scope = MOD_SETTING_SCOPE_RUNTIME,
				},
				{
					id = "invert_y_axis",
					ui_name = "Invert Y Axis",
					ui_description = "Down is up and up is down.",
					value_default = false,
					scope = MOD_SETTING_SCOPE_RUNTIME,
				},
				{
					id = "arachnophilia_mode",
					ui_name = "Arachnophilia Mode",
					ui_description = "You will encounter so many spiders.",
					value_default = false,
					scope = MOD_SETTING_SCOPE_RUNTIME,
				},
				{
					id = "discord_pings_enabled",
					ui_name = "Friends",
					ui_description = "Friends will occasionally try to reach out to you.",
					value_default = true,
					scope = MOD_SETTING_SCOPE_RUNTIME,
				},
			},
		},
		{
			category_id = "controls",
			ui_name = "Controls",
			ui_description = "Settings related to controls",
			settings = {

				{
					id = "rebind_pee",
					ui_name = "Piss Button",
					ui_description = "The keybind used to take a piss.",
					value_default = "19",
					ui_fn = ui_get_input,
					is_waiting_for_input = false,
					scope = MOD_SETTING_SCOPE_RUNTIME,
				},
				{
					id = "rebind_poo",
					ui_name = "Shit Button",
					ui_description = "The keybind used to take a shit.",
					value_default = "5",
					ui_fn = ui_get_input,
					is_waiting_for_input = false,
					scope = MOD_SETTING_SCOPE_RUNTIME,
				},
			},
		},
		{
			category_id = "misc",
			ui_name = "Misc",
			ui_description = "Miscellaneous settings",
			settings = {
				{
					id = "cpand_tmtrainer_chance",
					ui_name = "Pandorium TMT%",
					ui_description = "Probability for Pandorium and other random-spell casters to use TM-Trainer spells\nTMT Spells have a tendency to crash, set to max if you aren't a coward\nRanges 0-30%",
					value_default = 0,
					value_min = 0.0,
					value_max = 0.3,
					value_display_multiplier = 100,
					value_display_formatting = " $0%",
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
				{
					id = "max_corpse_count2",
					ui_name = "Maximum Corpse Count",
					ui_description = "How many death position to remember\nReduce it if it's causing lags",
					value_default = 200,
					value_min = 0,
					value_max = 2000,
					ui_fn = mod_setting_integer,
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
				{
					id = "achievements_popup",
					ui_name = "Achievements popup",
					ui_description = "Show the achievements popup",
					value_default = true,
					scope = MOD_SETTING_SCOPE_RUNTIME,
				},
				{
					not_setting = true,
					ui_name = "Move Settings",
					ui_description = "Moves this window",
					break_it = false,
					ui_fn = break_this_window,
				},
			},
		},
		{
			category_id = "reset",
			ui_name = "Reset",
			settings = {
				{
					id = "reset_progress",
					ui_name = "Reset Fair Mod Progress",
					ui_description = "Will reset all fairmod progress on next run",
					value_default = false,
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
			},
		},
	}
	return settings
end
mod_settings = build_settings()

-- This function is called to ensure the correct setting values are visible to the game. your mod's settings don't work if you don't have a function like this defined in settings.lua.
function ModSettingsUpdate(init_scope)
	mod_settings = build_settings()
	mod_settings_update(mod_id, mod_settings, init_scope)
	if init_scope == 0 or init_scope == 1 then
		--running code here cuz it runs before game init 'n' stuff
		if init_scope == 0 then
			--if more than 40 deaths, has not beaten the lovely dream and an extra .5% check
			local is_dreaming = (ModSettingGet("fairmod.deaths") or 0) > 40 and not HasFlagPersistent("fairmod_won_lovely_dream") and math.random() < .005
			is_dreaming = false
			if is_dreaming then
				ModSettingSet("fairmod.is_dreaming", true)
				return
			else
				ModSettingRemove("fairmod.is_dreaming")
			end
		end

		PatchGamesInitlua()
		PrintHamis()
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
