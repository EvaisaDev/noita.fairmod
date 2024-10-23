gui = gui or GuiCreate()
GuiStartFrame(gui)
local screen_width, screen_height = GuiGetScreenDimensions(gui)
local image_width, image_height = GuiGetImageDimensions(gui, "mods/noita.fairmod/files/content/hescoming/gameover.png")
local scale_x = screen_width / image_width
local scale_y = screen_height / image_height
local alpha = GetValueNumber("alpha", 1)
alpha = alpha - 0.012
SetValueNumber("alpha", alpha)
GuiZSetForNextWidget(gui, -1000)
GuiImage(gui, 2, (screen_width - image_width * scale_x) / 2, (screen_height - image_height * scale_y) / 2, "mods/noita.fairmod/files/content/hescoming/gameover.png", alpha, scale_x, scale_y)
if alpha <= 0 then
  local entity_id = GetUpdatedEntityID()
  EntityKill(entity_id)
end
