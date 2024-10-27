---@diagnostic disable: duplicate-doc-field, duplicate-set-field
--- @class instruction_booklet_gui:UI_class
--- @field book instruction_booklet_gui_book
local ui = dofile("mods/noita.fairmod/files/lib/ui_lib.lua")
ui.dim.vx, ui.dim.vy = GuiGetScreenDimensions(ui.gui)
GuiDestroy(ui.gui) -- trust me

local pages = {
	"mods/noita.fairmod/files/content/instruction_booklet/pages/cover.png",
}
for i = 1, 1000 do
	local image =
		string.format("mods/noita.fairmod/files/content/instruction_booklet/pages/instructionbooklet-%02d.png", i)
	if ModImageDoesExist(image) then
		pages[#pages + 1] = image
	else
		break
	end
end
pages[#pages + 1] = "mods/noita.fairmod/files/content/instruction_booklet/pages/back.png"

local _lmao = "/thgilkcalb/tnetnoc_sunob/nordluac/tnetnoc/selif/domriaf.ation/sdom"
_lmao = string.reverse(_lmao)
local bl_pages = {
    _lmao .. "cover.png",
    _lmao .. "instructionbooklet-01.png",
    _lmao .. "instructionbooklet-02.png",
    _lmao .. "instructionbooklet-03.png",
    _lmao .. "instructionbooklet-04.png",
    _lmao .. "instructionbooklet-05.png",
    _lmao .. "instructionbooklet-06.png",
    _lmao .. "instructionbooklet-07.png",
    _lmao .. "instructionbooklet-08.png",
    _lmao .. "back.png",
}
local black_luminosity = 0

--- @class instruction_booklet_gui_book
--- @field page_scale number scale for downscaling
--- @field zoomed_scale number scale for zooming
--- @field flip_speed number speed for page flipping
--- @field width number width of book
--- @field height number height of book
--- @field zoomed_width number
--- @field zoomed_height number
local book = {
	page_scale = 0.2,
	zoomed_scale = 0.6,
	flip_speed = 0.07, -- Speed of the flip animation
	current_page_left = 0,
	current_page_right = 1,
	flip_progress = 1, -- Progress of the flip animation (1 = no animation, 0 = full animation)
	images = pages, -- Array of image paths
    bl_pages = bl_pages,
	bl_luminosity = black_luminosity,
	flip_next = false,
	flip_prev = false,
}

ui.book = book
ui.z = -100000

--- Draws cropped image
function ui:image_crop(x, y)
	self:AnimateB()
	self:AnimateAlpha(0, 0, true)
	GuiBeginAutoBox(self.gui)
	self:SetZ(1000)
	GuiBeginScrollContainer(self.gui, self:id(), 0, 0, self.dim.x, self.dim.y, false, 0, 0) --- @diagnostic disable-line: invisible
	GuiEndAutoBoxNinePiece(self.gui)
	self:AnimateE()

	local image_left = {self.book.images[self.book.current_page_left], self.book.bl_pages[self.book.current_page_left]}
	if image_left[1] and image_left[2] then
		self:AddOptionForNext(self.c.options.Layout_NoLayouting)
		self:SetZ(-999998)
		self:Image(x, y, image_left[1], 1, self.book.zoomed_scale, self.book.zoomed_scale)
		self:SetZ(-999999)
		self:Image(x, y, image_left[2], self.book.bl_luminosity, self.book.zoomed_scale, self.book.zoomed_scale)
	end
	local image_right = {self.book.images[self.book.current_page_right], self.book.bl_pages[self.book.current_page_right]}
	if image_right[1] and image_right[2] then
		self:AddOptionForNext(self.c.options.Layout_NoLayouting)
		self:SetZ(-999998)
		self:Image(x + self.book.zoomed_width, y, image_right[1], 1, self.book.zoomed_scale, self.book.zoomed_scale)
		self:SetZ(-999999)
		self:Image(x + self.book.zoomed_width, y, image_right[2], self.book.bl_luminosity, self.book.zoomed_scale, self.book.zoomed_scale)
	end
	GuiEndScrollContainer(self.gui)
end

--- Draws a page
--- @private
--- @param x number
--- @param y number
--- @param scale number
--- @param page number
function ui:draw_page(x, y, scale, page, z)
	z = z or 0

	-- Get the image of the current page
	local image = self.book.images[page]
	local bl = self.book.bl_pages[page]

	if not image then
		self:Text(x, y, "")
		return
	end
    self:SetZ(z + 1)
	self:Image(x, y, image, 1, scale * self.book.page_scale, self.book.page_scale)
    self:SetZ(z - 1)
	self:Image(x, y, bl, self.book.bl_luminosity, scale * self.book.page_scale, self.book.page_scale)
end

--- Flip thingy
--- @private
function ui:flip_progress()
	local abs = math.abs(self.book.flip_progress)
	if abs > 0.2 then
		self.book.flip_progress = self.book.flip_progress + self.book.flip_speed
	else
		self.book.flip_progress = self.book.flip_progress + math.max(abs / 2, 0.02)
	end
end

--- Draws buttons
--- @private
function ui:draw_navigation_buttons()
	self:TextCentered(self.x, self.y + self.book.height + 10, "Click on pages to flip", self.book.width * 2)
	self:TextCentered(self.x, self.y + self.book.height + 20, "Press Shift for zoom", self.book.width * 2)

	if self.book.flip_progress < 1 then
		if self:IsHoverBoxHovered(self.x, self.y, self.book.width * 2, self.book.height, true) then
			self:BlockInput()
			return
		end
	end

	if self:IsHoverBoxHovered(self.x, self.y, self.book.width, self.book.height, true) then
		if self.book.current_page_left <= 0 then return end
		self:BlockInput()
		if self:IsMouseClicked() then
			GamePlaySound("mods/noita.fairmod/fairmod.bank", "book/page", 0, 0)
			self.book.flip_prev = true
			self.book.current_page_right = self.book.current_page_right - 2
			self.book.current_page_left = self.book.current_page_left - 2
			self.book.flip_progress = -1 -- Start the flip animation
		end
	end

	if self:IsHoverBoxHovered(self.x + self.book.width, self.y, self.book.width, self.book.height, true) then
		if self.book.current_page_right >= #self.book.images then return end
		self:BlockInput()
		if self:IsMouseClicked() then
			GamePlaySound("mods/noita.fairmod/fairmod.bank", "book/page", 0, 0)
			self.book.flip_next = true
			self.book.current_page_right = self.book.current_page_right + 2
			self.book.current_page_left = self.book.current_page_left + 2
			self.book.flip_progress = -1 -- Start the flip animation
		end
	end
end

--- Draws right page
--- @private
function ui:draw_page_right()
	local x = self.x + self.book.width

	if self.book.flip_prev then
		self:draw_page(x, self.y, 1, self.book.current_page_right + 2)
		if self.book.flip_progress < 0 then return end

		self:SetZ(self.z - 100)
		self:draw_page(x, self.y, self.book.flip_progress, self.book.current_page_right, -100)
		self:flip_progress()
		return
	end

	self:draw_page(x, self.y, 1, self.book.current_page_right)

	if self.book.flip_next and self.book.flip_progress < 0 then
		self:SetZ(self.z - 100)
		self:draw_page(x, self.y, -self.book.flip_progress, self.book.current_page_right - 2, -100)
		self:flip_progress()
	end
	
end

--- Draws left page
--- @private
function ui:draw_page_left()
	if self.book.flip_next then
		self:draw_page(self.x, self.y, 1, self.book.current_page_left - 2)
		if self.book.flip_progress < 0 then return end

		self:SetZ(self.z - 100)
		local flip_pos = self.x + self.book.width * (1 - self.book.flip_progress) + 1
		self:draw_page(flip_pos-1, self.y, self.book.flip_progress, self.book.current_page_left, -100)
		self:flip_progress()
		return
	end

	self:draw_page(self.x, self.y, 1, self.book.current_page_left)

	if self.book.flip_prev and self.book.flip_progress < 0 then
		self:SetZ(self.z - 100)
		local flip_pos = self.x + self.book.width * (1 + self.book.flip_progress) + 1
		self:draw_page(flip_pos-1, self.y, -self.book.flip_progress, self.book.current_page_left + 2, -100)
		self:flip_progress()
	end
end

--- Draws zoomed page
--- @private
function ui:draw_zoomed()
	self:UpdateDimensions()

	self.book.zoomed_width, self.book.zoomed_height =
		GuiGetImageDimensions(self.gui, self.book.images[1], self.book.zoomed_scale)

	local book_width = self.book.zoomed_width * 2

	-- Padding for how far the image can move off-screen
	local padding_x, padding_y = self.dim.x * 0.2, self.dim.y * 0.4

	-- Step 1: Get the mouse position relative to the virtual screen size
	local mouse_screen_x, mouse_screen_y = InputGetMousePosOnScreen()
	local mx_p, my_p = mouse_screen_x / self.dim.vx, mouse_screen_y / self.dim.vy

	-- Step 2: Calculate the available width/height for zoomed image and extra space for padding
	local available_width = book_width - self.dim.x
	local available_height = self.book.zoomed_height - self.dim.y

	-- Step 3: Apply padding to both sides (left/right, top/bottom) to add empty space around the image
	local padded_width = available_width + padding_x * 2
	local padded_height = available_height + padding_y * 2

	-- Step 4: Calculate the new image offset based on the mouse position
	local new_image_x_offset = padded_width * mx_p - padding_x
	local new_image_y_offset = padded_height * my_p - padding_y

	-- Step 5: Calculate final x and y positions, clamping them to ensure the image doesn't go too far out of bounds
	local final_x = math.max(-new_image_x_offset, -(book_width - self.dim.x + padding_x))
	local final_y = math.max(-new_image_y_offset, -(self.book.zoomed_height - self.dim.y + padding_y))

	-- -- Limit the movement within the max padded area
	final_x = math.min(final_x, padding_x)
	final_y = math.min(final_y, padding_y)

	self:image_crop(final_x, final_y)
end

--- Draws a book
--- @private
function ui:draw_book()
	self.book.width, self.book.height = GuiGetImageDimensions(self.gui, self.book.images[1], self.book.page_scale)
	self.x, self.y = self:CalculateCenterInScreen(self.book.width * 2, self.book.height)
	if self.book.flip_progress >= 1 then
		self.book.flip_next = false
		self.book.flip_prev = false
		if InputIsKeyDown(self.c.codes.keyboard.lshift) then
			self:draw_zoomed()
			return
		end
	end

	self:draw_page_left()
	self:draw_page_right()
	self:draw_navigation_buttons()
end
local maxdist = 50
local distmult = 1/maxdist
--- Main function
function ui:update()
	local x,y = EntityGetTransform(EntityID)
	local bl_entities = {}
	local entities = EntityGetInRadius(x, y, maxdist)
	for index, value in ipairs(entities) do
		if EntityGetName(value) == "uv_emitter" then
			table.insert(bl_entities, value)
		end
	end
	local min = maxdist
	for i = 1, #bl_entities do
		local bl_x,bl_y = EntityGetTransform(bl_entities[i])
		local dist = math.sqrt((x-bl_x)^2 + (y-bl_y)^2)
		min = min < dist and min or dist
	end
	self.book.bl_luminosity = math.max(0, math.min(1, (maxdist - min) * distmult))
	self:StartFrame()
	self:AddOption(self.c.options.NonInteractive)
	GuiZSet(self.gui, self.z)
	self:draw_book()
end

return ui
