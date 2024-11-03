-- Include necessary libraries
dofile_once("data/scripts/lib/coroutines.lua")
dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/noita.fairmod/files/content/fishing/files/eva_utils.lua")
dofile_once("mods/noita.fairmod/files/content/fishing/files/gui_utils.lua")

-- Get the updated entity ID and create a GUI
local entity_id = GetUpdatedEntityID()
local gui = GuiCreate()

-- Get the lifetime component of the entity
local lifetime_component = EntityGetFirstComponent(entity_id, "LifetimeComponent")
if lifetime_component == nil then return end

-- Initialize variables
local reverse = false
local base_speed = 1.5
local bobber = EntityGetVariable(entity_id, "bobber_id", "int") or nil
local speed_add = EntityGetVariable(entity_id, "speed", "int") or 0
local speed = base_speed + ((speed_add / 100) * 2)
local current_frame = 50

local background = "mods/noita.fairmod/files/content/fishing/files/ui/skillcheck/background_test.png"
local background_width, background_height = GuiGetImageDimensions(gui, background)

-- Define frame limits
local FRAME_MIN = 1
local FRAME_MAX = background_width - 1
local CATCH_WINDOW = 8
local catch_frame = Random(0, FRAME_MAX - CATCH_WINDOW)

local going_right = true

if bobber ~= nil then
	async_loop(function()
		local kill_frame = ComponentGetValue2(lifetime_component, "kill_frame")
		if (kill_frame - GameGetFrameNum() <= 1) or GameHasFlagRun("kill_fishing_challenge_ui") then
			GameRemoveFlagRun("kill_fishing_challenge_ui")
			GuiDestroy(gui)
			EntityKill(entity_id)
		else
			local last_frame = current_frame

			-- Start GUI frame
			GuiStartFrame(gui)
			GuiIdPushString(gui, "fishing")

			-- Get screen dimensions
			local screen_w, screen_h = GuiGetScreenDimensions(gui)

			-- Base positions
			local base_x = screen_w / 2
			local base_y = screen_h - 58.5 -- Adjusted for proper alignment

			-- Options
			GuiOptionsAdd(gui, GUI_OPTION.NoPositionTween)

			-- Update current frame
			if not EntityHasFlag(bobber, "return_bobber") then
				if current_frame >= FRAME_MAX then
					reverse = true
				elseif current_frame <= FRAME_MIN then
					reverse = false
				end

				if reverse then
					current_frame = current_frame - speed
				else
					current_frame = current_frame + speed
				end

				if current_frame >= catch_frame and current_frame <= catch_frame + CATCH_WINDOW then
					GameAddFlagRun("allow_catch_fish")
				else
					GameRemoveFlagRun("allow_catch_fish")
				end
			end

			-- Image path and scale
			local square_path = "mods/noita.fairmod/files/content/fishing/files/ui/square.png"

			local alpha = 1
			local scale_x = 1
			local scale_y = background_height - 2
			local rotation = 0

			if current_frame ~= last_frame then going_right = (current_frame - last_frame) > 0 end

			-- Background
			GuiZSetForNextWidget(gui, -509)
			GuiImage(gui, NextID(), base_x - (background_width / 2), base_y, background, alpha, 1, 1, rotation)

			-- Catch window indicator
			GuiColorSetForNextWidget(gui, 1, 0.3, 0.3, 0.5)
			GuiZSetForNextWidget(gui, -512)
			GuiImage(gui, NextID(), base_x - (background_width / 2) + catch_frame, base_y + 1, square_path, 0.5, CATCH_WINDOW, scale_y, rotation)

			-- Current frame indicator
			GuiColorSetForNextWidget(gui, 0.3, 1, 0.3, 0.5)
			GuiZSetForNextWidget(gui, -513)
			GuiImage(gui, NextID(), base_x - (background_width / 2) + current_frame, base_y + 1, square_path, alpha, scale_x, scale_y, rotation)

			local fish_path = "mods/noita.fairmod/files/content/fishing/files/ui/skillcheck/fish.png"
			local fish_width, fish_height = GuiGetImageDimensions(gui, fish_path)

			local fish_x = (base_x - (background_width / 2) + current_frame) - (fish_width / 2)

			if not going_right then fish_x = fish_x + fish_width end

			local fish_width = going_right and 1 or -1

			GuiColorSetForNextWidget(gui, 1, 1, 1, 0.5)
			GuiZSetForNextWidget(gui, -514)
			GuiImage(gui, NextID(), fish_x, base_y, fish_path, alpha, fish_width, 1, rotation)
		end
		wait(0.1)
	end)
end
