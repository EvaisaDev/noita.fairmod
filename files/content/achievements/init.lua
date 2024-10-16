local notification_time = 420
local notifications = {}
local notification_gui = GuiCreate()

local debug_no_flags = false

local module = {}

local function AddNotification(background_filename, icon, name, description, sound)
    if(sound)then
        GamePlaySound("mods/noita.fairmod/fairmod.bank", "achievements/notification", 0, 0)
    end
    table.insert(notifications, {image = background_filename, icon = icon, name = name, description = description, time_left = notification_time})
end

local function DrawNotifications()
    local screen_w, screen_h = GuiGetScreenDimensions(notification_gui)
    GuiStartFrame( notification_gui )

    local screen_width, screen_height = GuiGetScreenDimensions( notification_gui )
    local _, _, cam_w, cam_h = GameGetCameraBounds()

    local notification_height = 0
    for i = #notifications, 1, -1 do
        local notification = notifications[i]
        notification.time_left = notification.time_left - 1
        if(notification.time_left < 0)then
            table.remove(notifications, i)
        else
            local image = notification.image
            local image_width, image_height = GuiGetImageDimensions( notification_gui, image, 1)

            local x = screen_width - image_width
            local y = screen_height - notification_height - image_height
            if notification.time_left < 30 then
                -- Lerp the notification off the screen
                local lerp_amount = math.min(1, notification.time_left / 30)
                y = y + (1 - lerp_amount) * (image_height)

                GuiZSetForNextWidget( notification_gui, 1000)
            end
            -- Lerp the notification onto the screen
            local lerp_amount = math.min(1, (notification_time - notification.time_left) / 30)
            y = y + (1 - lerp_amount) * (image_height)

            -- update notification height to include the lerp and stuff
            notification_height = notification_height + ((lerp_amount) * (image_height))

			GuiZSet(notification_gui, -999)

            GuiImage(notification_gui, 0, x, y, image, 1, 1, 1, 0)


			local extra_offset = 4
			-- add icon if it exists
			if notification.icon then
				local icon_width, icon_height = GuiGetImageDimensions( notification_gui, notification.icon, 1)
				GuiImage(notification_gui, 0, x + extra_offset, y + (image_height / 2) - (icon_height / 2), notification.icon, 1, 1, 1, 0)
				extra_offset = extra_offset + icon_width + 4
			end

			local text_x = x + extra_offset
			local text_y = y + 4
			local achievement_width, achievement_height = GuiGetTextDimensions( notification_gui, "Achievement unlocked", 0.8)
			local name_width, name_height = GuiGetTextDimensions( notification_gui, notification.name, 0.7)
			local description_width, description_height = GuiGetTextDimensions( notification_gui, notification.description, 0.7)
			
			GuiColorSetForNextWidget(notification_gui, 95 / 255, 119 / 255, 162 / 255, 1)
			GuiZSet(notification_gui, -1000)
			
			GuiText(notification_gui, text_x, text_y, "Achievement unlocked", 0.8)

			text_y = text_y + achievement_height + 0.4


			GuiText(notification_gui, text_x, text_y, notification.name, 0.7)

			text_y = text_y + name_height + 0.2
			
			GuiText(notification_gui, text_x, text_y, notification.description, 0.7)
				

        end
    end

end

local persistent_flag_func_get = HasFlagPersistent
local persistent_flag_func_set = AddFlagPersistent

local function CheckAchievements()
	-- we do a little debugging

	if(debug_no_flags)then
		HasFlagPersistent = GameHasFlagRun
		AddFlagPersistent = GameAddFlagRun
	end

	dofile("mods/noita.fairmod/files/content/achievements/achievements.lua")
	for i, achievement in ipairs(achievements) do
		if(not HasFlagPersistent(achievement.flag or ("achievement_"..achievement.name)) and achievement.unlock())then
			print("Achievement unlocked: "..achievement.name)
			AddNotification(achievement.background or "mods/noita.fairmod/files/content/achievements/backgrounds/background_small.png", achievement.icon, achievement.name, achievement.description, true)
			AddFlagPersistent(achievement.flag or ("achievement_"..achievement.name))
		end
	end
	if(debug_no_flags)then
		HasFlagPersistent = persistent_flag_func_get
		AddFlagPersistent = persistent_flag_func_set
	end
end

module.update = function()
	DrawNotifications()
	CheckAchievements()
end


return module