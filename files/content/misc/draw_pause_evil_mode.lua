evil_gui = evil_gui or GuiCreate()
GuiStartFrame(evil_gui)

if GameHasFlagRun("draw_evil_mode_text") then
	local inputs = dofile_once("mods/noita.fairmod/files/content/misc/list_inputs.lua")

	local function isAnyInputPressed()
		local input_checks = {
			{ inputs.mouse, InputIsMouseButtonJustDown },
			{ inputs.key, InputIsKeyJustDown },
			{
				inputs.joy,
				function(id)
					return InputIsJoystickButtonJustDown(0, id)
				end,
			},
			{
				inputs.stick,
				function(id)
					return math.abs(InputGetJoystickAnalogStick(0, id)) > 0.9
				end,
			},
			{
				inputs.trigger,
				function(id)
					return InputGetJoystickAnalogButton(0, id) > 0.9
				end,
			},
		}

		for _, group in ipairs(input_checks) do
			local input_table, check_func = group[1], group[2]
			for _, id in pairs(input_table) do
				if check_func(id) then return true end
			end
		end

		return false
	end

	if isAnyInputPressed() then
		GameRemoveFlagRun("draw_evil_mode_text")
		return
	end

	local screen_w, screen_h = GuiGetScreenDimensions(evil_gui)
	local text_w, text_h = GuiGetTextDimensions(evil_gui, "Noita - Build Aug 12 2024 - 21:48:01 -")

	GuiZSetForNextWidget(evil_gui, -1)
	GuiImage(evil_gui, 21425251, text_w + 10, screen_h - (text_h * 2 + 10), "mods/noita.fairmod/files/content/misc/evil_mode.png", 1, 0.12, 0.12, 0)
end
