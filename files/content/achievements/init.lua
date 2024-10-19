local notification_time = 420
local notifications = {}

local notification_gui = GuiCreate()
local gui_id = 1000
local function id()
	gui_id = gui_id + 1
	return gui_id
end

local background_image = "mods/noita.fairmod/files/content/achievements/backgrounds/background_steam_120x600.png"
local default_icon = "mods/noita.fairmod/files/content/achievements/icons/no_png.png"
local gradient = "mods/noita.fairmod/files/content/achievements/backgrounds/gradient.png"

local offset_from_right = 5
local notification_width = 100
local default_icon_size = 20

local debug_no_flags = false

local module = {}

local function AddNotification(icon, name, description, sound)
	if (sound) then
		GamePlaySound("mods/noita.fairmod/fairmod.bank", "achievements/notification", 0, 0)
	end
	table.insert(notifications, { icon = icon, name = name, description = description, time_left = notification_time })
end

local function SplitString(text, length)
	local lines = {}
	local current_line = ""
	for word in text:gmatch("%S+") do
		local test_line = (current_line == "") and word or current_line .. " " .. word
		local width = GuiGetTextDimensions(notification_gui, test_line, 0.7)
		if width > length then
			lines[#lines + 1] = current_line
			current_line = word
		else
			current_line = test_line
		end
	end

	-- Add the last line if it's not empty
	if current_line ~= "" then
		lines[#lines + 1] = current_line
	end

	return lines
end

local function ImageCrop(x, y, width, height)
	width = width + offset_from_right
	GuiAnimateBegin(notification_gui)
	GuiAnimateAlphaFadeIn(notification_gui, id(), 0, 0, true)
	GuiBeginAutoBox(notification_gui)

	GuiZSetForNextWidget(notification_gui, 1000)
	GuiBeginScrollContainer(notification_gui, id(), x, y, width, height, false, 0, 0)
	GuiEndAutoBoxNinePiece(notification_gui)
	GuiAnimateEnd(notification_gui)

	local screen_width, screen_height = GuiGetScreenDimensions(notification_gui)
	GuiOptionsAddForNextWidget(notification_gui, GUI_OPTION.Layout_NoLayouting)
	GuiZSetForNextWidget(notification_gui, 1001)
	GuiImage(notification_gui, id(), screen_width - 120, screen_height - 600, background_image, 1, 1)
	GuiOptionsAddForNextWidget(notification_gui, GUI_OPTION.Layout_NoLayouting)
	GuiZSetForNextWidget(notification_gui, 1000)
	GuiImage(notification_gui, id(), x + width - 110, y + height - 30, gradient, 1, 1)
	GuiEndScrollContainer(notification_gui)
end

local function DrawNotifications()
	GuiStartFrame(notification_gui)
	gui_id = 1000

	local screen_width, screen_height = GuiGetScreenDimensions(notification_gui)

	local notification_height = 0
	for i = #notifications, 1, -1 do
		local notification = notifications[i]
		notification.time_left = notification.time_left - 1
		if (notification.time_left < 0) then
			table.remove(notifications, i)
		else
			local _, achievement_height = GuiGetTextDimensions(notification_gui, "Achievement unlocked", 0.8)

			local name = SplitString(notification.name, notification_width - default_icon_size - 8)
			local name_line_count = #name
			local name_height = 7 * name_line_count

			local description = SplitString(notification.description, notification_width - default_icon_size - 8)
			local description_line_count = #description
			local description_height = 7 * description_line_count

			local max_height = math.max(30, achievement_height + name_height + description_height + 9)

			notification.icon = notification.icon or default_icon
			local icon_width, _ = GuiGetImageDimensions(notification_gui, notification.icon, 1)
			max_height = math.max(max_height, 28)

			local x = screen_width - notification_width - offset_from_right
			local y = screen_height - notification_height - max_height
			if notification.time_left < 30 then
				-- Lerp the notification off the screen
				local lerp_amount = math.min(1, notification.time_left / 30)
				y = y + (1 - lerp_amount) * (max_height)

				GuiZSetForNextWidget(notification_gui, 1000)
			end
			-- Lerp the notification onto the screen
			local lerp_amount = math.min(1, (notification_time - notification.time_left) / 30)
			y = y + (1 - lerp_amount) * (max_height)

			-- update notification height to include the lerp and stuff
			notification_height = notification_height + ((lerp_amount) * (max_height))

			GuiZSet(notification_gui, -999)

			ImageCrop(x, y, notification_width, max_height)

			-- add icon
			local extra_offset = 4
			local icon_x = x + extra_offset + (default_icon_size - icon_width) / 2
			local icon_y = y + (max_height - icon_width) / 2
			GuiImage(notification_gui, id(), icon_x, icon_y, notification.icon, 1, 1, 1, 0)
			extra_offset = extra_offset + default_icon_size + 4

			local text_x = x + extra_offset
			local text_y = y + 4

			GuiColorSetForNextWidget(notification_gui, 95 / 255, 119 / 255, 162 / 255, 1)
			GuiZSet(notification_gui, 800)

			GuiText(notification_gui, text_x, text_y, "Achievement unlocked", 0.8)

			text_y = text_y + achievement_height + 0.4

			for j = 1, name_line_count do
				GuiText(notification_gui, text_x, text_y, name[j], 0.7)
				text_y = text_y + 7
			end

			text_y = text_y + 0.2

			for j = 1, description_line_count do
				GuiColorSetForNextWidget(notification_gui, 0.7, 0.7, 0.7, 0.8)
				GuiText(notification_gui, text_x, text_y, description[j], 0.7)
				text_y = text_y + 7
			end
		end
	end

end

local persistent_flag_func_get = HasFlagPersistent
local persistent_flag_func_set = AddFlagPersistent

local function CheckAchievements()
	-- we do a little debugging

	if (debug_no_flags) then
		HasFlagPersistent = GameHasFlagRun
		AddFlagPersistent = GameAddFlagRun
	end

	local achievements_unlocked = 0
	dofile("mods/noita.fairmod/files/content/achievements/achievements.lua")
	for i, achievement in ipairs(achievements) do
		local flag = "fairmod_" .. achievement.flag or ("achievement_" .. achievement.name)
		if (not HasFlagPersistent(flag) and achievement.unlock()) then
			print("Achievement unlocked: " .. achievement.name)
			AddNotification(achievement.icon, achievement.name, achievement.description, true)
			AddFlagPersistent(flag)
		elseif(HasFlagPersistent(flag)) then
			achievements_unlocked = achievements_unlocked + 1
		end
	end

	GlobalsSetValue("fairmod_total_achievements", tostring(#achievements))
	GlobalsSetValue("fairmod_achievements_unlocked", tostring(achievements_unlocked))
	
	if (debug_no_flags) then
		HasFlagPersistent = persistent_flag_func_get
		AddFlagPersistent = persistent_flag_func_set
	end
end

module.update = function()
	DrawNotifications()
	CheckAchievements()
end

return module
