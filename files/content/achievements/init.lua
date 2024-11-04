--- @alias achievement_data {name:{lines:string[], height:number}, description:{lines:string[],height:number}, icon:{path:string, width:number}, height:number}
local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

local ui = dofile("mods/noita.fairmod/files/lib/ui_lib.lua") --- @class achievement_ui:UI_class
ui.scroll.height_max = 250
ui.scroll.width = 110
ui.scroll.scroll_img = "mods/noita.fairmod/files/content/achievements/ui/ui_9piece_scrollbar.png"
ui.scroll.scroll_img_hl = "mods/noita.fairmod/files/content/achievements/ui/ui_9piece_scrollbar_hl.png"

local achievements_data = setmetatable({}, { __mode = "k" })

fairmod_achievements_displaying_window = false

local notification_time = 420
local notifications = {}

local background_image = "mods/noita.fairmod/files/content/achievements/backgrounds/background_steam_120x600.png"
local default_icon = "mods/noita.fairmod/files/content/achievements/icons/no_png.png"
local gradient = "mods/noita.fairmod/files/content/achievements/backgrounds/gradient.png"

local offset_from_right = 5
local notification_width = 100
local default_icon_size = 20

local achievement_height = 0

local debug_no_flags = false

for xml in nxml.edit_file("data/entities/player.xml") do
	xml:add_child(nxml.new_element("LuaComponent", {
		execute_every_n_frame = -1,
		script_damage_received = "mods/noita.fairmod/files/content/achievements/get_hit.lua",
	}))
	xml:add_child(nxml.new_element("LuaComponent", {
		execute_every_n_frame = 10,
		script_source_file = "mods/noita.fairmod/files/content/achievements/check_materials.lua",
	}))
end

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

function ui:DrawCroppedGradient(x, y, height)
	local width = notification_width + offset_from_right
	self:AnimateB()
	self:AnimateAlpha(0, 0, true)
	GuiBeginAutoBox(self.gui)
	self:SetZ(1000)
	GuiBeginScrollContainer(self.gui, self:id(), x, y, width, height, false, 0, 0) --- @diagnostic disable-line: invisible
	GuiEndAutoBoxNinePiece(self.gui)
	self:AnimateE()

	self:AddOptionForNext(self.c.options.Layout_NoLayouting)
	self:SetZ(900)
	self:Image(x + width - 110, y + height - 30, gradient)
	GuiEndScrollContainer(self.gui)
end

--- Draws cropped background
--- @param x number
--- @param y number
--- @param height number
function ui:DrawCroppedBackground(x, y, height)
	local width = notification_width + offset_from_right
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
	GuiEndScrollContainer(self.gui)
end

--- Gets data about achievement
--- @param achievement table
--- @return achievement_data
function ui:GetAchievementData(achievement)
	if achievements_data[achievement.name] then return achievements_data[achievement.name] end
	achievement_height = 7

	local name = self:SplitString(achievement.name, notification_width - default_icon_size - 8)
	local name_line_count = #name
	local name_height = 7 * name_line_count

	local description = self:SplitString(achievement.description, notification_width - default_icon_size - 8)
	local description_line_count = #description
	local description_height = 7 * description_line_count

	local max_height = math.max(30, achievement_height + name_height + description_height + 9)

	if not achievement.icon or not ModImageDoesExist(achievement.icon) then achievement.icon = default_icon end

	local icon_width = GuiGetImageDimensions(self.gui, achievement.icon, 1)
	max_height = math.max(max_height, 28)

	achievements_data[achievement.name] = {
		name = {
			lines = name,
			height = name_line_count,
		},
		description = {
			lines = description,
			height = description_height,
		},
		icon = {
			path = achievement.icon,
			width = icon_width,
		},
		height = max_height,
	}
	return achievements_data[achievement.name]
end

--- Draw achievement notification
function ui:DrawNotifications()
	local notification_height = 0
	for i = #notifications, 1, -1 do
		local notification = notifications[i]
		notification.time_left = notification.time_left - 1
		if notification.time_left < 0 then
			table.remove(notifications, i)
		else
			local achievement_data = self:GetAchievementData(notification)

			local x = self.dim.x - notification_width - offset_from_right
			local y = self.dim.y - notification_height - achievement_data.height
			if notification.time_left < 30 then
				-- Lerp the notification off the screen
				local lerp_amount = math.min(1, notification.time_left / 30)
				y = y + (1 - lerp_amount) * achievement_data.height

				self:SetZ(1000)
			end
			-- Lerp the notification onto the screen
			local lerp_amount = math.min(1, (notification_time - notification.time_left) / 30)
			y = y + (1 - lerp_amount) * achievement_data.height

			-- update notification height to include the lerp and stuff
			notification_height = notification_height + (lerp_amount * achievement_data.height)

			self:DrawCroppedBackground(x, y, achievement_data.height)
			self:DrawCroppedGradient(x, y, achievement_data.height)

			self:DrawAchievement(x, y, achievement_data)
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
			GameAddFlagRun("fairmod_new_achievement")
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

--- @param x number
--- @param y number
--- @param achievement_data achievement_data
function ui:DrawAchievement(x, y, achievement_data)
	-- add icon
	local extra_offset = 4
	local icon_x = x + extra_offset + (default_icon_size - achievement_data.icon.width) / 2
	local icon_y = y + (achievement_data.height - achievement_data.icon.width) / 2
	self:SetZ(0)
	self:Image(icon_x, icon_y, achievement_data.icon.path)
	extra_offset = extra_offset + default_icon_size + 4

	local text_x = x + extra_offset
	local text_y = y + 4

	self:Color(95 / 255, 119 / 255, 162 / 255)
	GuiZSet(self.gui, 800)

	self.text_scale = 0.8
	self:Text(text_x, text_y, "Achievement unlocked")

	text_y = text_y + 7.4

	self.text_scale = 0.7
	for j = 1, #achievement_data.name.lines do
		self:Text(text_x, text_y, achievement_data.name.lines[j])
		text_y = text_y + 7
	end

	text_y = text_y + 0.2

	for j = 1, #achievement_data.description.lines do
		self:Color(0.7, 0.7, 0.7, 0.8)
		self:Text(text_x, text_y, achievement_data.description.lines[j])
		text_y = text_y + 7
	end
end

--- @param x number
--- @param y number
--- @param achievement_data achievement_data
function ui:DrawLockedAchievements(x, y, achievement_data)
	-- add icon
	local extra_offset = 4
	local icon_x = x + extra_offset + (default_icon_size - achievement_data.icon.width) / 2
	local icon_y = y + (achievement_data.height - achievement_data.icon.width) / 2
	self:SetZ(0)
	self:Color(0.2, 0.2, 0.2, 1)
	self:Image(icon_x, icon_y, achievement_data.icon.path)
	extra_offset = extra_offset + default_icon_size + 4

	local text_x = x + extra_offset
	local text_y = y + 4

	self:Color(0.7, 0.7, 0.7, 0.8)
	GuiZSet(self.gui, 999)

	self.text_scale = 0.8
	self:Text(text_x, text_y, "Locked")

	text_y = text_y + 7.4

	self.text_scale = 0.7
	for j = 1, #achievement_data.name.lines do
		self:Text(text_x, text_y, achievement_data.name.lines[j])
		text_y = text_y + 7
	end

	text_y = text_y + 0.2

	for j = 1, #achievement_data.description.lines do
		local line = achievement_data.description.lines[j]:gsub("%$", "?"):gsub("%w", "?")
		self:Color(0.7, 0.7, 0.7, 0.8)
		self:Text(text_x, text_y, line)
		text_y = text_y + 7
	end
	self:Color(0, 0, 0)
	self:SetZ(998)
	self:Image(x, y, "data/debug/whitebox.png", 0.3, 10, achievement_data.height / 20)
end

function ui:DrawAchievementsScrollbox()
	local y = 0 - self.scroll.y
	self:SetZ(1000)
	self:Image(-10, self.scroll.height_max - 600, background_image)
	for i = 1, #achievements do
		local achievement = achievements[i]
		local flag = "fairmod_" .. achievement.flag or ("achievement_" .. achievement.name)
		local achievement_data = self:GetAchievementData(achievement)

		if y >= 0 - achievement_data.height and y <= self.scroll.height_max then
			if HasFlagPersistent(flag) then
				self:DrawAchievement(0, y, achievement_data)
			else
				self:DrawLockedAchievements(0, y, achievement_data)
			end
		end

		y = y + achievement_data.height
	end
	self:Text(0, y + self.scroll.y, "")
end

function ui:DrawAchievementsWindow()
	GameRemoveFlagRun("fairmod_new_achievement")
	local x = 26
	local y = 50
	self:Draw9Piece(x - 3, y, 1001, self.scroll.width + 6, 8, "mods/noita.fairmod/files/content/achievements/ui/ui_9piece_main.png")
	local unlocked = tonumber(GlobalsGetValue("fairmod_achievements_unlocked")) or 0
	local total = tonumber(GlobalsGetValue("fairmod_total_achievements")) or 1
	local text = string.format("Achievements: %s/%s (%d%%)", unlocked, total, math.floor((unlocked / total) * 100))
	local close_dim = self:GetTextDimension("[Close]")
	local close_x = x + self.scroll.width - close_dim
	local hovered = self:IsHoverBoxHovered(close_x, y, close_dim, 7)
	if hovered then
		self:Color(1, 1, 0.7)
		if self:IsLeftClicked() then fairmod_achievements_displaying_window = false end
	end
	self:Text(close_x, y, "[Close]")

	self:Text(x + 3, y, text)
	self:ScrollBox(x, y + 16, 1001, "mods/noita.fairmod/files/content/achievements/ui/ui_9piece_main.png", 3, 3, self.DrawAchievementsScrollbox)
end

function ui:update()
	CheckAchievements()
	self:StartFrame()
	self.text_scale = 0.7
	self:UpdateDimensions()
	self:AddOption(self.c.options.NonInteractive)
	self:DrawNotifications()
	if fairmod_achievements_displaying_window then self:DrawAchievementsWindow() end
end

return ui
