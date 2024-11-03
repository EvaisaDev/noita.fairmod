dofile_once("data/scripts/lib/coroutines.lua")
dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/noita.fairmod/files/content/fishing/files/eva_utils.lua")
dofile_once("mods/noita.fairmod/files/content/fishing/files/gui_utils.lua")
entity_id = GetUpdatedEntityID()

gui = GuiCreate()

background_sprite = EntityGetVariable(entity_id, "background", "string") or ""
fish_sprite = EntityGetVariable(entity_id, "fish", "string") or ""
fish_size = EntityGetVariable(entity_id, "size", "string") or ""
fish_name = EntityGetVariable(entity_id, "fish_name", "string") or ""
--fish_text_bottom = EntityGetVariable(entity_id, "bottom_text", "string") or ""
animation = EntityGetVariable(entity_id, "animation", "string") or ""

lifetime_component = EntityGetFirstComponent(entity_id, "LifetimeComponent")

--print(background_sprite)
time = 0

height_multiplier = -0.05

--GamePrint("fish_size = "..fish_size)

async_loop(function()
	kill_frame = ComponentGetValue2(lifetime_component, "kill_frame")
	--GamePrint("lifetime: "..tostring(kill_frame - GameGetFrameNum()))
	if kill_frame - GameGetFrameNum() == 1 then
		GuiDestroy(gui)
		--GamePrint("Rawr as heck")
	else
		height_multiplier = height_multiplier + 0.05

		local show_text = false
		if height_multiplier > 1 then
			height_multiplier = 1
			show_text = true
		end

		GuiStartFrame(gui)
		GuiIdPushString(gui, "fishing")

		--time = time + 1
		--GamePrint("timer: "..tostring(time))

		w, h = GuiGetScreenDimensions(gui)

		GuiOptionsAdd(gui, GUI_OPTION.NoPositionTween)

		GuiZSetForNextWidget(gui, -500)
		img_w, img_h = GuiGetImageDimensions(gui, background_sprite, 1)
		img_h = img_h * height_multiplier
		GuiImage(gui, NextID(), ((w / 2) - (img_w / 2)), ((h / 2) - (img_h / 2)) - 100, background_sprite, 1, 1, height_multiplier, 0)

		GuiZSetForNextWidget(gui, -510)
		img_w, img_h = GuiGetImageDimensions(gui, fish_sprite, 1)
		img_h = img_h * height_multiplier
		GuiImage(gui, NextID(), (w / 2) - (img_w / 2), ((h / 2) - (img_h / 2)) - 100, fish_sprite, 1, 1, height_multiplier, 0)

		GuiColorSetForNextWidget(gui, 0, 0, 0, 0.3)
		GuiZSetForNextWidget(gui, -505)
		img_w, img_h = GuiGetImageDimensions(gui, fish_sprite, 1)
		img_h = img_h * height_multiplier
		GuiImage(gui, NextID(), (w / 2) + 1 - (img_w / 2), ((h / 2) + 1 - (img_h / 2)) - 100, fish_sprite, 1, 1, height_multiplier, 0)

		if show_text then
			width, height = TextSize(gui, "mods/noita.fairmod/files/content/fishing/files/ui/characters", 0, 0, 0.4, -525, fish_name, -0.5)
			DrawText(
				gui,
				"mods/noita.fairmod/files/content/fishing/files/ui/characters",
				((w / 2) - (width / 2)),
				(((h / 2) - (height / 2)) - 26) - 100,
				0.4,
				-525,
				fish_name,
				"ff241c11",
				-0.5
			)

			width, height = TextSize(gui, "mods/noita.fairmod/files/content/fishing/files/ui/characters", 0, 0, 0.4, -525, fish_size .. " kg", -0.5)
			DrawText(
				gui,
				"mods/noita.fairmod/files/content/fishing/files/ui/characters",
				((w / 2) - (width / 2)),
				(((h / 2) - (height / 2)) + 25) - 100,
				0.4,
				-525,
				fish_size .. " kg",
				"ff241c11",
				-0.5
			)
		end
	end
	wait(0.1)
end)
