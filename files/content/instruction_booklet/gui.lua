--- @class instruction_booklet_gui:UI_class
--- @field book instruction_booklet_gui_book
local ui = dofile("mods/noita.fairmod/files/lib/ui_lib.lua")

local pages = {}
for i = 1, 1000 do
	local image =
		string.format("mods/noita.fairmod/files/content/instruction_booklet/pages/instructionbooklet-%02d.png", i)
	if ModImageDoesExist(image) then
		pages[#pages + 1] = image
	else
		break
	end
end

--- @class instruction_booklet_gui_book
local book = {
	current_page_left = 1,
	current_page_right = 2,
	flip_progress = 1, -- Progress of the flip animation (1 = no animation, 0 = full animation)
	flip_speed = 0.1, -- Speed of the flip animation
	images = pages, -- Array of image paths
	width = 163,
	flip_next = false,
	flip_prev = false,
}

ui.book = book
ui.z = -100000

function ui:draw_page(x, y, scale, page)
	-- Get the image of the current page
	local image = self.book.images[page]

	if not image then
		self:Text(x, y, "No image available")
		return
	end

	self:Image(x, y, image, 1, scale * 0.2, 0.2)
end

function ui:draw_navigation_buttons(x, y)
	-- Draw Previous button
	if self:IsButtonClicked(x + 40, y, self.z, "Previous", "") and self.book.flip_progress >= 1 then
		self.book.flip_prev = true
		self.book.current_page_right = self.book.current_page_right - 2
		self.book.current_page_left = self.book.current_page_left - 2
		self.book.flip_progress = -1 -- Start the flip animation
	end

	-- Draw Next button
	if self:IsButtonClicked(x + 40 + self.book.width, y, self.z, "Next", "") and self.book.flip_progress >= 1 then
		self.book.flip_next = true
		self.book.current_page_right = self.book.current_page_right + 2
		self.book.current_page_left = self.book.current_page_left + 2
		self.book.flip_progress = -1 -- Start the flip animation
	end
end

-- Flip animation rendering
function ui:draw_page_right(x, y, page)
	x = x + self.book.width

	if self.book.flip_prev then
		self:draw_page(x, y, 1, page + 2)
		if self.book.flip_progress < 0 then return end

		self:SetZ(self.z - 100)
		self:draw_page(x, y, self.book.flip_progress, page)
		self.book.flip_progress = self.book.flip_progress + self.book.flip_speed
		return
	end

	self:draw_page(x, y, 1, page)

	if self.book.flip_next and self.book.flip_progress < 0 then
		self:SetZ(self.z - 100)
		self:draw_page(x, y, -self.book.flip_progress, page - 2)
		self.book.flip_progress = self.book.flip_progress + self.book.flip_speed
	end
end

-- Flip animation rendering
function ui:draw_page_left(x, y, page)
	if self.book.flip_next then
		self:draw_page(x, y, 1, page - 2)
		if self.book.flip_progress < 0 then return end

		self:SetZ(self.z - 100)
		local flip_pos = x + self.book.width * (1 - self.book.flip_progress) + 1
		self:draw_page(flip_pos, y, self.book.flip_progress, page)
		self.book.flip_progress = self.book.flip_progress + self.book.flip_speed
		return
	end

	self:draw_page(x, y, 1, page)

	if self.book.flip_prev and self.book.flip_progress < 0 then
		self:SetZ(self.z - 100)
		local flip_pos = x + self.book.width * (1 + self.book.flip_progress) + 1
		self:draw_page(flip_pos, y, -self.book.flip_progress, page + 2)
		self.book.flip_progress = self.book.flip_progress + self.book.flip_speed
	end
end

function ui:draw_book(x, y)
	self:draw_page_left(x, y, self.book.current_page_left)
	self:draw_page_right(x, y, self.book.current_page_right)

	if self.book.flip_progress >= 1 then
		self.book.flip_next = false
		self.book.flip_prev = false
	end

	-- Draw "Previous" and "Next" buttons at the bottom
	self:draw_navigation_buttons(x, y - 20)
end

function ui:update()
	self:StartFrame()
	self:AddOption(self.c.options.NonInteractive)
	GuiZSet(self.gui, self.z)
	self:draw_book(200, 40)
end

return ui
