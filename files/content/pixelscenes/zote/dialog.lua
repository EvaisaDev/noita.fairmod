local dialog_system = dofile_once("mods/noita.fairmod/files/lib/DialogSystem/dialog_system.lua")
dialog_system.distance_to_close = 35
dialog_system.dialog_box_width = 300

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

SetRandomSeed(x + GameGetFrameNum(), y)

local precepts = dofile_once("mods/noita.fairmod/files/content/pixelscenes/zote/precets.lua")
local bad_choice

local function split_string(text, length)
	local lines = {}
	local current_line = ""
	for word in text:gmatch("%S+") do
		local test_line = (current_line == "") and word or current_line .. " " .. word
		local width = GuiGetTextDimensions(__dialog_system_gui, test_line)
		if width > length then
			lines[#lines + 1] = current_line
			current_line = word
		else
			current_line = test_line
		end
	end

	-- Add the last line if it's not empty
	if current_line ~= "" then lines[#lines + 1] = current_line end

	return table.concat(lines, "\n")
end

local function get_precept(level)
	local text = precepts[level]
	return split_string(text, 220)
end

local function next_dialog(level)
	local options = {}
	if level < #precepts then
		options = {
			{
				text = "Next",
				func = next_dialog(level + 1),
			},
		}
	else
		options = {
			{
				text = "Leave",
				func = function()
					bad_choice = false
				end,
			},
		}
	end

	return function(dialog)
		dialog.show({
			text = get_precept(level),
			options = options,
		})
	end
end

local function set_audio(audio)
	local audio_comp = EntityGetFirstComponent(entity_id, "AudioLoopComponent")
	if not audio_comp then return end
	ComponentSetValue2(audio_comp, "event_name", audio)
	EntitySetComponentIsEnabled(entity_id, audio_comp, false)
	EntitySetComponentIsEnabled(entity_id, audio_comp, true)
end

function interacting(entity_who_interacted, entity_interacted, interactable_name)
	if EntityHasTag(entity_interacted, "viewing") or GameHasFlagRun("fairmod_dialog_interacting") then return end
	if GameHasFlagRun("fairmod_interacted_with_anything_this_frame") then return end
	GameAddFlagRun("fairmod_interacted_with_anything_this_frame")
	GameAddFlagRun("fairmod_dialog_interacting")
	bad_choice = true
	set_audio("zote/talk")

	dialog = dialog_system.open_dialog({
		name = "Zote",
		portrait = "mods/noita.fairmod/files/content/pixelscenes/zote/portrait.png",
		-- typing_sound = "d", -- There are currently 6: default, sans, one, two, three, four and "none" to turn it off, if not specified uses "default"
		text = get_precept(1),
		options = {
			{
				text = "Next",
				func = next_dialog(2),
			},
		},
		on_closed = function()
			GameRemoveFlagRun("fairmod_dialog_interacting")
		end,
		on_closing = function()
			if bad_choice then set_audio("zote/yap") end
		end,
	})
end
