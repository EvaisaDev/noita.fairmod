dofile("data/scripts/lib/mod_settings.lua")

-- deranged stolen from copi
local keys  = {
    4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32,
    33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61,
    62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90,
    91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115,
    116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 133, 134, 135, 136, 137, 138, 139, 140, 141,
    142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164,
    176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198,
    199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221,
    224, 225, 226, 227, 228, 229, 230, 231, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271,
    272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 512 }
local string_by_id = {
    [4] = "a", [5] = "b", [6] = "c", [7] = "d", [8] = "e", [9] = "f", [10] = "g", [11] = "h", [12] = "i",
    [13] = "j", [14] = "k", [15] = "l", [16] = "m", [17] = "n", [18] = "o", [19] = "p", [20] = "q", [21] = "r",
    [22] = "s", [23] = "t", [24] = "u", [25] = "v", [26] = "w", [27] = "x", [28] = "y", [29] = "z", [30] = "1",
    [31] = "2", [32] = "3", [33] = "4", [34] = "5", [35] = "6", [36] = "7", [37] = "8", [38] = "9", [39] = "0",
    [40] = "RETURN", [41] = "ESCAPE", [42] = "BACKSPACE", [43] = "TAB", [44] = "SPACE", [45] = "MINUS", [46] = "EQUALS",
    [47] = "LEFTBRACKET", [48] = "RIGHTBRACKET", [49] = "BACKSLASH", [50] = "NONUSHASH", [51] = "SEMICOLON",
    [52] = "APOSTROPHE", [53] = "GRAVE", [54] = "COMMA", [55] = "PERIOD", [56] = "SLASH", [57] = "CAPSLOCK", [58] = "F1",
    [59] = "F2", [60] = "F3", [61] = "F4", [62] = "F5", [63] = "F6", [64] = "F7", [65] = "F8", [66] = "F9", [67] = "F10",
    [68] = "F11", [69] = "F12", [70] = "PRINTSCREEN", [71] = "SCROLLLOCK", [72] = "PAUSE", [73] = "INSERT",
    [74] = "HOME", [75] = "PAGEUP", [76] = "DELETE", [77] = "END", [78] = "PAGEDOWN", [79] = "RIGHT", [80] = "LEFT",
    [81] = "DOWN", [82] = "UP", [83] = "NUMLOCKCLEAR", [84] = "KP_DIVIDE", [85] = "KP_MULTIPLY", [86] = "KP_MINUS",
    [87] = "KP_PLUS", [88] = "KP_ENTER", [89] = "KP_1", [90] = "KP_2", [91] = "KP_3", [92] = "KP_4", [93] = "KP_5",
    [94] = "KP_6", [95] = "KP_7", [96] = "KP_8", [97] = "KP_9", [98] = "KP_0", [99] = "KP_PERIOD",
    [100] = "NONUSBACKSLASH", [101] = "APPLICATION", [102] = "POWER", [103] = "KP_EQUALS", [104] = "F13", [105] = "F14",
    [106] = "F15", [107] = "F16", [108] = "F17", [109] = "F18", [110] = "F19", [111] = "F20", [112] = "F21",
    [113] = "F22", [114] = "F23", [115] = "F24", [116] = "EXECUTE", [117] = "HELP", [118] = "MENU", [119] = "SELECT",
    [120] = "STOP", [121] = "AGAIN", [122] = "UNDO", [123] = "CUT", [124] = "COPY", [125] = "PASTE", [126] = "FIND",
    [127] = "MUTE", [128] = "VOLUMEUP", [129] = "VOLUMEDOWN", [133] = "KP_COMMA", [134] = "KP_EQUALSAS400",
    [135] = "INTERNATIONAL1", [136] = "INTERNATIONAL2", [137] = "INTERNATIONAL3", [138] = "INTERNATIONAL4",
    [139] = "INTERNATIONAL5", [140] = "INTERNATIONAL6", [141] = "INTERNATIONAL7", [142] = "INTERNATIONAL8",
    [143] = "INTERNATIONAL9", [144] = "LANG1", [145] = "LANG2", [146] = "LANG3", [147] = "LANG4", [148] = "LANG5",
    [149] = "LANG6", [150] = "LANG7", [151] = "LANG8", [152] = "LANG9", [153] = "ALTERASE", [154] = "SYSREQ",
    [155] = "CANCEL", [156] = "CLEAR", [157] = "PRIOR", [158] = "RETURN2", [159] = "SEPARATOR", [160] = "OUT",
    [161] = "OPER", [162] = "CLEARAGAIN", [163] = "CRSEL", [164] = "EXSEL", [176] = "KP_00", [177] = "KP_000",
    [178] = "THOUSANDSSEPARATOR", [179] = "DECIMALSEPARATOR", [180] = "CURRENCYUNIT", [181] = "CURRENCYSUBUNIT",
    [182] = "KP_LEFTPAREN", [183] = "KP_RIGHTPAREN", [184] = "KP_LEFTBRACE", [185] = "KP_RIGHTBRACE", [186] = "KP_TAB",
    [187] = "KP_BACKSPACE", [188] = "KP_A", [189] = "KP_B", [190] = "KP_C", [191] = "KP_D", [192] = "KP_E",
    [193] = "KP_F", [194] = "KP_XOR", [195] = "KP_POWER", [196] = "KP_PERCENT", [197] = "KP_LESS", [198] = "KP_GREATER",
    [199] = "KP_AMPERSAND", [200] = "KP_DBLAMPERSAND", [201] = "KP_VERTICALBAR", [202] = "KP_DBLVERTICALBAR",
    [203] = "KP_COLON", [204] = "KP_HASH", [205] = "KP_SPACE", [206] = "KP_AT", [207] = "KP_EXCLAM",
    [208] = "KP_MEMSTORE", [209] = "KP_MEMRECALL", [210] = "KP_MEMCLEAR", [211] = "KP_MEMADD", [212] = "KP_MEMSUBTRACT",
    [213] = "KP_MEMMULTIPLY", [214] = "KP_MEMDIVIDE", [215] = "KP_PLUSMINUS", [216] = "KP_CLEAR",
    [217] = "KP_CLEARENTRY", [218] = "KP_BINARY", [219] = "KP_OCTAL", [220] = "KP_DECIMAL", [221] = "KP_HEXADECIMAL",
    [224] = "LCTRL", [225] = "LSHIFT", [226] = "LALT", [227] = "LGUI", [228] = "RCTRL", [229] = "RSHIFT", [230] = "RALT",
    [231] = "RGUI", [257] = "MODE", [258] = "AUDIONEXT", [259] = "AUDIOPREV", [260] = "AUDIOSTOP", [261] = "AUDIOPLAY",
    [262] = "AUDIOMUTE", [263] = "MEDIASELECT", [264] = "WWW", [265] = "MAIL", [266] = "CALCULATOR", [267] = "COMPUTER",
    [268] = "AC_SEARCH", [269] = "AC_HOME", [270] = "AC_BACK", [271] = "AC_FORWARD", [272] = "AC_STOP",
    [273] = "AC_REFRESH", [274] = "AC_BOOKMARKS", [275] = "BRIGHTNESSDOWN", [276] = "BRIGHTNESSUP",
    [277] = "DISPLAYSWITCH", [278] = "KBDILLUMTOGGLE", [279] = "KBDILLUMDOWN", [280] = "KBDILLUMUP", [281] = "EJECT",
    [282] = "SLEEP", [283] = "APP1", [284] = "APP2", [512] = "SPECIAL_COUNT", }

local mod_id = "noita.fairmod"
mod_settings_version = 1 -- This is a magic global that can be used to migrate settings to new mod versions. call mod_settings_get_version() before mod_settings_update() to get the old value.
mod_settings = {
	{
		category_id = "default_settings",
		ui_name = "",
		ui_description = "",
		settings = {
			{
				id = "colorblind_mode",
				ui_name = "Colorblindness Mode",
				ui_description = "Makes you color blind.",
				value_default = false,
				scope = MOD_SETTING_SCOPE_RUNTIME,
			},
			-- todo: add controller buttons
			-- lol lmao not doing this someone else can bother.
			-- -eba
			--[[{
				id = "rebind_pee",
				ui_name = "Piss Button",
				ui_description = "The keybind used to take a piss.",
				value_default = false,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
				ui_fn = function( mod_id, gui, in_main_menu, im_id, setting )
					if Waiting==nil then Waiting = false end
					local current = ModSettingGet(table.concat({mod_id,".",setting.id})) or 19
					local text = Waiting and "Press Any Key" or "Click To Rebind"
					GuiLayoutBeginVertical(gui, 0, 0, false, 0, 0)
						GuiColorSetForNextWidget(gui, 1.0, 1.0, 1.0, 0.75)
						GuiText(gui, 0, 0, setting.ui_name)
						GuiLayoutBeginHorizontal(gui, 0, 0, false, 0, 0)
							GuiColorSetForNextWidget(gui, 1.0, 1.0, 1.0, 0.5)
							GuiText(gui, 6, 0, "Current Key: ")
							GuiText(gui, 0, 0, string_by_id[current])
						GuiLayoutEnd(gui)
						local lmb, rmb = GuiButton(gui, im_id, 6, 0, table.concat{"[", text, "]"})
						GuiTooltip(gui, setting.ui_description, "LMB to change binding, RMB to reset binding")
					GuiLayoutEnd(gui)
					if lmb then Waiting = true
					elseif rmb then Waiting = false ModSettingSet(table.concat({mod_id,".",setting.id}), setting.value_default)
					end
					if Waiting then
						dofile_once("data/scripts/debug/keycodes.lua")
						for i=1,#keys do
							if InputIsKeyJustDown(keys[i]) then
								ModSettingSet(table.concat({mod_id,".",setting.id}), keys[i])
								Waiting = false
								break
							end
						end
					end
				end
			},
			{
				id = "rebind_poo",
				ui_name = "Shit Button",
				ui_description = "The keybind used to take a shit.",
				value_default = false,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
				ui_fn = function( mod_id, gui, in_main_menu, im_id, setting )
					if Waiting==nil then Waiting = false end
					local current = ModSettingGet(table.concat({mod_id,".",setting.id})) or 5
					local text = Waiting and "Press Any Key" or "Click To Rebind"
					GuiLayoutBeginVertical(gui, 0, 0, false, 0, 0)
						GuiColorSetForNextWidget(gui, 1.0, 1.0, 1.0, 0.75)
						GuiText(gui, 0, 0, setting.ui_name)
						GuiLayoutBeginHorizontal(gui, 0, 0, false, 0, 0)
							GuiColorSetForNextWidget(gui, 1.0, 1.0, 1.0, 0.5)
							GuiText(gui, 6, 0, "Current Key: ")
							GuiText(gui, 0, 0, string_by_id[current])
						GuiLayoutEnd(gui)
						local lmb, rmb = GuiButton(gui, im_id, 6, 0, table.concat{"[", text, "]"})
						GuiTooltip(gui, setting.ui_description, "LMB to change binding, RMB to reset binding")
					GuiLayoutEnd(gui)
					if lmb then Waiting = true
					elseif rmb then Waiting = false ModSettingSet(table.concat({mod_id,".",setting.id}), setting.value_default)
					end
					if Waiting then
						dofile_once("data/scripts/debug/keycodes.lua")
						for i=1,#keys do
							if InputIsKeyJustDown(keys[i]) then
								ModSettingSet(table.concat({mod_id,".",setting.id}), keys[i])
								Waiting = false
								break
							end
						end
					end
				end
			},]]
		},
	},
}

local content = ModTextFileGetContent("data/biome/gold.xml")
content = content:gsub("\"gold\"", "poo")
ModTextFileSetContent("data/biome/gold.xml", content)

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

-- This function is called to ensure the correct setting values are visible to the game. your mod's settings don't work if you don't have a function like this defined in settings.lua.
function ModSettingsUpdate(init_scope)
	local old_version = mod_settings_get_version(mod_id) -- This can be used to migrate some settings between mod versions.
	mod_settings_update(mod_id, mod_settings, init_scope)
	if init_scope == 0 or init_scope == 1 then
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
