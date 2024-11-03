--stylua: ignore start
gui = gui or GuiCreate()
GuiStartFrame(gui)
local screen_width, screen_height = GuiGetScreenDimensions(gui)
local img = "mods/noita.fairmod/files/content/dmca_warning/warning.png"
local image_width, image_height = GuiGetImageDimensions(gui, img)
scale = scale or 0.502
image_width = image_width * scale
image_height = image_height * scale
GuiZSetForNextWidget(gui, -100)
local x = (screen_width - image_width) / 2
local y = (screen_height - image_height) / 2
GuiImage(gui, 2, x, y, img, 1, scale, scale)
GuiZSetForNextWidget(gui, -101)
local text = "Adjust this slider if you can't read the text: "
local text_width = GuiGetTextDimensions(gui, text)
scale = GuiSlider(gui,4,(screen_width - text_width - 100) / 2,screen_height - 20,text,scale,0.25,2,0.502,1000," ",100)
GuiZSetForNextWidget(gui, -102)
local button_img = "mods/noita.fairmod/files/content/dmca_warning/button_close.png"
GuiImage(gui, 3, x + image_width - 20 * scale, y + 5 * scale, button_img, 1, scale, scale)
local clicked, right_clicked, hovered, x, y, width, height, draw_x, draw_y, draw_width, draw_height =
	GuiGetPreviousWidgetInfo(gui)
if clicked then
	local entity_id = GetUpdatedEntityID()
	GuiDestroy(gui)
	EntityKill(entity_id)
end
--stylua: ignore end
