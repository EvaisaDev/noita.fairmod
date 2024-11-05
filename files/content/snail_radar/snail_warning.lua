-- Initialize variables
local x_position = 0
local alpha_value = 0
local last_sound_time = 0
local initial_frame = GameGetFrameNum()
local warning_completed = false
local started = false

local module = {
	gui = GuiCreate()
}

ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/noita.fairmod/files/content/snail_radar/perk.lua")

-- Main function to manage the warning sequence
function module.update()
    -- Create GUI if not already created
    if not module.gui then
        module.gui = GuiCreate()
    end
    GuiStartFrame(module.gui)
    GuiOptionsAdd(module.gui, GUI_OPTION.NonInteractive)

	dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")

	if(not GameHasFlagRun("snail_radar")) then return end

	local players = GetPlayers()
	
	if #players == 0 then return end
	
	local player = players[1]

	if(player == nil) then return end

	local x, y = EntityGetTransform(player)

	if(#EntityGetInRadiusWithTag(x, y, 150, "snail") == 0) then 
		if(not started)then
			return
		else
			warning_completed = true
		end
	end
    local screen_width, screen_height = GuiGetScreenDimensions(module.gui)

	if(warning_completed and x_position > screen_width) then
		GuiDestroy(module.gui)
		module.gui = nil
		x_position = 0
		alpha_value = 0
		last_sound_time = 0
		initial_frame = GameGetFrameNum()
		warning_completed = false
		started = false
		return
	end

    -- Unique ID generator
    local id_counter = 1
    local function get_next_id()
        id_counter = id_counter + 1
        return id_counter
    end

	started = true

    -- Play warning sound periodically
    if last_sound_time < GameGetFrameNum() - 40 then
        last_sound_time = GameGetFrameNum()
        GamePlaySound("mods/noita.fairmod/fairmod.bank", "snail/alert", 0, 0)
    end

    -- Get screen dimensions

    local center_y = screen_height / 2

    -- Load band image dimensions
    local band_width, band_height = GuiGetImageDimensions(module.gui, "mods/noita.fairmod/files/content/snail_radar/band.png")
    GuiZSet(module.gui, -10)

    local top_band_y = center_y - band_height / 2 - 50
    local bottom_band_y = center_y - band_height / 2 + 50

    -- Draw moving bands
    for i = 1, math.ceil(screen_width / band_width) do
        GuiImage(module.gui, get_next_id(), -i * band_width + x_position, top_band_y, "mods/noita.fairmod/files/content/snail_radar/band.png", 1, 1, 1)
        GuiImage(module.gui, get_next_id(), screen_width + (i - 1) * band_width - x_position, bottom_band_y, "mods/noita.fairmod/files/content/snail_radar/band.png", 1, 1, 1)
    end

    -- Update x_position
    if not warning_completed then
        x_position = math.min(screen_width, x_position + 6)
    else
        x_position = x_position + 6
    end

    -- Draw warning text with pulsating alpha
    local warning_text_width, warning_text_height = GuiGetImageDimensions(module.gui, "mods/noita.fairmod/files/content/snail_radar/warning_text.png")
    alpha_value = 0.5 - math.cos((GameGetFrameNum() - initial_frame) * 0.1) * 0.5
    GuiImage(module.gui, get_next_id(), screen_width / 2 - warning_text_width / 2, center_y - warning_text_height / 2, "mods/noita.fairmod/files/content/snail_radar/warning_text.png", alpha_value, 1, 1)

	-- draw shadow
	GuiZSetForNextWidget(module.gui, -9)
	GuiColorSetForNextWidget(module.gui, 0, 0, 0, 0.5)
	GuiImage(module.gui, get_next_id(), screen_width / 2 - warning_text_width / 2 + 2, center_y - warning_text_height / 2 + 2, "mods/noita.fairmod/files/content/snail_radar/warning_text.png", alpha_value, 1, 1)


    -- When bands reach center, display additional signs and scrolling images
    if x_position == screen_width then
        local sign_width, sign_height = GuiGetImageDimensions(module.gui, "mods/noita.fairmod/files/content/snail_radar/sign.png")
        GuiImage(module.gui, get_next_id(), 30, center_y - sign_height / 2, "mods/noita.fairmod/files/content/snail_radar/sign.png", 1, 1, 1)
        GuiImage(module.gui, get_next_id(), screen_width - sign_width - 30, center_y - sign_height / 2, "mods/noita.fairmod/files/content/snail_radar/sign.png", 1, 1, 1)

        -- Use images instead of text for scrolling effect
        local image_width, image_height = GuiGetImageDimensions(module.gui, "mods/noita.fairmod/files/content/snail_radar/snail_detected.png")
        local total_width = image_width + 20  -- Adding some spacing
        local scroll_speed = 2  -- Adjust scroll speed as needed
        local scroll_offset = (GameGetFrameNum() * scroll_speed) % total_width

		top_band_y = top_band_y + (band_height / 2) - (image_height / 2)
		bottom_band_y = bottom_band_y + (band_height / 2) - (image_height / 2)



        for i = -1, math.ceil(screen_width / total_width) do
			GuiZSet(module.gui, -12)
            -- Draw images moving from left to right on the top band
            GuiImage(module.gui, get_next_id(), i * total_width + scroll_offset, top_band_y, "mods/noita.fairmod/files/content/snail_radar/snail_detected.png", 1, 1, 1)

            -- Draw images moving from right to left on the bottom band
            GuiImage(module.gui, get_next_id(), screen_width - (i * total_width + scroll_offset), bottom_band_y, "mods/noita.fairmod/files/content/snail_radar/snail_detected.png", 1, 1, 1)
			
	
			-- draw shadow
			GuiZSet(module.gui, -11)

			GuiColorSetForNextWidget(module.gui, 0, 0, 0, 0.5)
			GuiImage(module.gui, get_next_id(), i * total_width + scroll_offset + 2, top_band_y + 2, "mods/noita.fairmod/files/content/snail_radar/snail_detected.png", 1, 1, 1)
			
			GuiColorSetForNextWidget(module.gui, 0, 0, 0, 0.5)
			GuiImage(module.gui, get_next_id(), screen_width - (i * total_width + scroll_offset) + 2, bottom_band_y + 2, "mods/noita.fairmod/files/content/snail_radar/snail_detected.png", 1, 1, 1)
		end
    end
end

return module