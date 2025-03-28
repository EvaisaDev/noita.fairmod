-- Logo splash thingy

local module = {
	gui = GuiCreate(),
	was_visible = false,
	current_splash = "",
	frame = 0,
}

local splashes = dofile_once("mods/noita.fairmod/files/content/logo_splash/splashes.lua")

module.update = function()
	local visible = GameHasFlagRun("draw_logo_splash")

	local curr_id = 325
	local function new_id()
		curr_id = curr_id + 1
		return curr_id
	end

	GuiStartFrame(module.gui)

	if visible and not module.was_visible then
		module.current_splash = splashes[math.random(1, #splashes)]
		module.was_visible = true
	elseif not visible and module.was_visible then
		module.was_visible = false
	end

	if visible then
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
			GameRemoveFlagRun("draw_logo_splash")
			return
		end

		local screen_w, screen_h = GuiGetScreenDimensions(module.gui)
		local menu_distance_from_top = tonumber(MagicNumbersGetValue("UI_PAUSE_MENU_LAYOUT_TOP_EDGE_PERCENTAGE")) / 100

		local splash = module.current_splash
		module.frame = module.frame + 1

		-- splash scale sinewave
		local scale = 1.5 + math.sin(module.frame * 0.1) * 0.1

		local offset_x = 100
		local offset_y = 60

		-- Split the splash text by newline into multiple lines
		local lines = {}
		for line in splash:gmatch("([^\n]+)") do
			table.insert(lines, line)
		end

		-- Compute dimensions for each line and determine overall block size
		local max_width = 0
		local total_height = 0
		local line_dims = {}
		for _, line in ipairs(lines) do
			local w, h = GuiGetTextDimensions(module.gui, line)
			w = w * scale
			h = h * scale
			table.insert(line_dims, { w = w, h = h })
			if w > max_width then
				max_width = w
			end
			total_height = total_height + h
		end

		-- Center the block of text and apply offsets
		local block_x = screen_w / 2 - max_width / 2 + offset_x
		local block_y = screen_h * menu_distance_from_top - total_height / 2 + offset_y

		-- Draw each line with proper positioning
		local current_y = block_y
		for i, line in ipairs(lines) do
			local dims = line_dims[i]
			-- Center each line within the block
			local line_x = block_x + (max_width - dims.w) / 2
			
			GuiZSetForNextWidget(module.gui, -1000000)
			GuiColorSetForNextWidget(module.gui, 1, 1, 0, 1)
			GuiText(module.gui, line_x, current_y, line, scale)
			current_y = current_y + dims.h
		end

		local logo_w, logo_h = GuiGetImageDimensions(module.gui, "mods/noita.fairmod/files/content/logo_splash/noita_logo.png")
		local logo_x = screen_w / 2 - logo_w / 2
		local logo_y = screen_h * menu_distance_from_top - logo_h / 2

		local logo_offset_x = 0
		local logo_offset_y = 40

		logo_x = logo_x + logo_offset_x
		logo_y = logo_y + logo_offset_y

		-- Uncomment if you want to draw the logo image
		-- GuiImage(module.gui, new_id(), logo_x, logo_y, "mods/noita.fairmod/files/content/logo_splash/noita_logo.png", 1, 1, 1, 0)

	end
end

return module
