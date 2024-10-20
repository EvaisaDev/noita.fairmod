local ui = dofile("mods/noita.fairmod/files/lib/ui_lib.lua") --- @class achievement_ui:UI_class

local notification_time = 420
local notifications = {}

local background_image = "mods/noita.fairmod/files/content/achievements/backgrounds/background_steam_120x600.png"
local default_icon = "mods/noita.fairmod/files/content/achievements/icons/no_png.png"
local gradient = "mods/noita.fairmod/files/content/achievements/backgrounds/gradient.png"

local offset_from_right = 5
local notification_width = 100
local default_icon_size = 20

local debug_no_flags = false

local function AddNotification(icon, name, description, sound)
	if sound then GamePlaySound("mods/noita.fairmod/fairmod.bank", "achievements/notification", 0, 0) end
	table.insert(notifications, { icon = icon, name = name, description = description, time_left = notification_time })
end

function ui:SplitString(text, length)
	local lines = {}
	local current_line = ""
	for word in text:gmatch("%S+") do
		local test_line = (current_line == "") and word or current_line .. " " .. word
		local width = GuiGetTextDimensions(self.gui, test_line, 0.7)
		if width > length then
			lines[#lines + 1] = current_line
			current_line = word
		else
			current_line = test_line
		end
	end

	-- Add the last line if it's not empty
	if current_line ~= "" then lines[#lines + 1] = current_line end

	return lines
end

function ui:ImageCrop(x, y, width, height)
	width = width + offset_from_right
	self:AnimateB()
	self:AnimateAlpha(0, 0, true)
	GuiBeginAutoBox(self.gui)

	self:SetZ(1000)
	GuiBeginScrollContainer(self.gui, self:id(), x, y, width, height, false, 0, 0) --- @diagnostic disable-line: invisible
	GuiEndAutoBoxNinePiece(self.gui)
	self:AnimateE()

	self:AddOptionForNext(self.c.options.Layout_NoLayouting)
	self:SetZ(1001)
	self:Image(self.dim.x - 120, self.dim.y - 600, background_image)
	self:AddOptionForNext(self.c.options.Layout_NoLayouting)
	self:SetZ(1000)
	self:Image(x + width - 110, y + height - 30, gradient)
	GuiEndScrollContainer(self.gui)
end

function ui:DrawNotifications()
	self:StartFrame()
	self:UpdateDimensions()

	local notification_height = 0
	for i = #notifications, 1, -1 do
		local notification = notifications[i]
		notification.time_left = notification.time_left - 1
		if notification.time_left < 0 then
			table.remove(notifications, i)
		else
			achievement_height = 7

			local name = self:SplitString(notification.name, notification_width - default_icon_size - 8)
			local name_line_count = #name
			local name_height = 7 * name_line_count

			local description = self:SplitString(notification.description, notification_width - default_icon_size - 8)
			local description_line_count = #description
			local description_height = 7 * description_line_count

			local max_height = math.max(30, achievement_height + name_height + description_height + 9)

			notification.icon = notification.icon or default_icon
			local icon_width = GuiGetImageDimensions(self.gui, notification.icon, 1)
			max_height = math.max(max_height, 28)

			local x = self.dim.x - notification_width - offset_from_right
			local y = self.dim.y - notification_height - max_height
			if notification.time_left < 30 then
				-- Lerp the notification off the screen
				local lerp_amount = math.min(1, notification.time_left / 30)
				y = y + (1 - lerp_amount) * max_height

				self:SetZ(1000)
			end
			-- Lerp the notification onto the screen
			local lerp_amount = math.min(1, (notification_time - notification.time_left) / 30)
			y = y + (1 - lerp_amount) * max_height

			-- update notification height to include the lerp and stuff
			notification_height = notification_height + (lerp_amount * max_height)

			GuiZSet(self.gui, -999)

			self:ImageCrop(x, y, notification_width, max_height)

			-- add icon
			local extra_offset = 4
			local icon_x = x + extra_offset + (default_icon_size - icon_width) / 2
			local icon_y = y + (max_height - icon_width) / 2
			self:Image(icon_x, icon_y, notification.icon)
			extra_offset = extra_offset + default_icon_size + 4

			local text_x = x + extra_offset
			local text_y = y + 4

			self:Color(95 / 255, 119 / 255, 162 / 255)
			GuiZSet(self.gui, 800)

			self.text_scale = 0.8
			self:Text(text_x, text_y, "Achievement unlocked")

			text_y = text_y + achievement_height + 0.4

			self.text_scale = 0.7
			for j = 1, name_line_count do
				self:Text(text_x, text_y, name[j])
				text_y = text_y + 7
			end

			text_y = text_y + 0.2

			for j = 1, description_line_count do
				self:Color(0.7, 0.7, 0.7, 0.8)
				self:Text(text_x, text_y, description[j])
				text_y = text_y + 7
			end
		end
	end
end

local persistent_flag_func_get = HasFlagPersistent
local persistent_flag_func_set = AddFlagPersistent

local function CheckAchievements()
	-- we do a little debugging

	if debug_no_flags then
		HasFlagPersistent = GameHasFlagRun
		AddFlagPersistent = GameAddFlagRun
	end

	local achievements_unlocked = 0
	dofile("mods/noita.fairmod/files/content/achievements/achievements.lua")
	for i, achievement in ipairs(achievements) do
		local flag = "fairmod_" .. achievement.flag or ("achievement_" .. achievement.name)
		if not HasFlagPersistent(flag) and achievement.unlock() then
			print("Achievement unlocked: " .. achievement.name)
			AddNotification(achievement.icon, achievement.name, achievement.description, true)
			AddFlagPersistent(flag)
		elseif HasFlagPersistent(flag) then
			achievements_unlocked = achievements_unlocked + 1
		end
	end

	GlobalsSetValue("fairmod_total_achievements", tostring(#achievements))
	GlobalsSetValue("fairmod_achievements_unlocked", tostring(achievements_unlocked))

	if debug_no_flags then
		HasFlagPersistent = persistent_flag_func_get
		AddFlagPersistent = persistent_flag_func_set
	end
end

function ui:update()
	self:DrawNotifications()
	CheckAchievements()
end

return ui
