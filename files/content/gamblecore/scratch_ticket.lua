-- scratchoff system

local get_money_func = function(amount)
	return function(player)
		local wallet = EntityGetFirstComponent(player, "WalletComponent")
		if wallet then
			local money = ComponentGetValue2(wallet, "money")
			ComponentSetValue2(wallet, "money", money + amount)
		end
	end
end

local prizes = {
	{
		text = "hämis",
		description = "You won a hämis!",
		weight = 10,
		func = function(player) end,
	},
	{
		text = "$10.00",
		description = "You won 10 gold!",
		weight = 100,
		func = get_money_func(10),
	},
	-- 25
	{
		text = "$25.00",
		description = "You won 25 gold!",
		weight = 50,
		func = get_money_func(25),
	},
	-- 50
	{
		text = "$50.00",
		description = "You won 50 gold!",
		weight = 25,
		func = get_money_func(50),
	},
	-- 100
	{
		text = "$100.00",
		description = "You won 100 gold!",
		weight = 10,
		func = get_money_func(100),
	},
	-- 250
	{
		text = "$250.00",
		description = "You won 250 gold!",
		weight = 5,
		func = get_money_func(250),
	},
	-- 500
	{
		text = "$500.00",
		description = "You won 500 gold!",
		weight = 2,
		func = get_money_func(500),
	},
	-- 1000
	{
		text = "$1000.00",
		description = "You won 1000 gold!",
		weight = 1,
		func = get_money_func(1000),
	},
}

local function GetRandomPrize()
	local total_weight = 0
	for _, v in ipairs(prizes) do
		total_weight = total_weight + v.weight
	end

	local rnd = Random(1, total_weight)
	local current_weight = 0
	for _, v in ipairs(prizes) do
		current_weight = current_weight + v.weight
		if rnd <= current_weight then return v end
	end

	return 0
end

local function color_abgr_merge(r, g, b, a)
	return bit.bor(
		bit.band(r, 0xFF),
		bit.lshift(bit.band(g, 0xFF), 8),
		bit.lshift(bit.band(b, 0xFF), 16),
		bit.lshift(bit.band(a, 0xFF), 24)
	)
end

local function color_abgr_split(abgr_int)
	local r = bit.band(abgr_int, 0xFF)
	local g = bit.band(bit.rshift(abgr_int, 8), 0xFF)
	local b = bit.band(bit.rshift(abgr_int, 16), 0xFF)
	local a = bit.band(bit.rshift(abgr_int, 24), 0xFF)

	return r, g, b, a
end

local function get_mouse_pos(gui)
	local players = EntityGetWithTag("player_unit") or {}

	if #players == 0 then return end

	local player = players[1]

	local b_width = 1280
	local b_height = 720

	local controls_component = EntityGetFirstComponentIncludingDisabled(player, "ControlsComponent")
	local screen_width, screen_height = GuiGetScreenDimensions(gui)
	local mouse_raw_x, mouse_raw_y = ComponentGetValue2(controls_component, "mMousePositionRaw")
	local mx, my = mouse_raw_x * screen_width / b_width, mouse_raw_y * screen_height / b_height

	return mx, my
end

local number_range = { 1, 50 }

local function get_line(x0, y0, x1, y1)
	local points = {}
	x0 = math.floor(x0)
	y0 = math.floor(y0)
	x1 = math.floor(x1)
	y1 = math.floor(y1)
	local dx = math.abs(x1 - x0)
	local dy = math.abs(y1 - y0)
	local sx = x0 < x1 and 1 or -1
	local sy = y0 < y1 and 1 or -1
	local err = dx - dy

	while true do
		table.insert(points, { x = x0, y = y0 })
		if x0 == x1 and y0 == y1 then break end
		local e2 = 2 * err
		if e2 > -dy then
			err = err - dy
			x0 = x0 + sx
		end
		if e2 < dx then
			err = err + dx
			y0 = y0 + sy
		end
	end
	return points
end

local scratch_ticket = {
	new = function(x, y)
		local self = {
			winning_numbers = {},
			scratch_numbers = {},
			winner_lookup = {},
			scratched_pixels = {},
			gui = GuiCreate(),
			prev_mx = nil,
			prev_my = nil,
		}
		local scale_mult = 1.4

		local scratch_area_width = 108 * scale_mult
		local scratch_area_height = 96 * scale_mult

		SetRandomSeed(x + GameGetFrameNum(), y * GameGetFrameNum())

		-- Generate 5 winning numbers that are unique
		local numbers_picked = {}
		while #self.winning_numbers < 5 do
			local number = Random(number_range[1], number_range[2])
			if not numbers_picked[number] then
				numbers_picked[number] = true
				self.winner_lookup[number] = true
				table.insert(self.winning_numbers, number)
			end
		end

		-- Generate 20 scratch numbers that are unique
		numbers_picked = {}
		while #self.scratch_numbers < 16 do
			local number = Random(number_range[1], number_range[2])
			if not numbers_picked[number] then
				numbers_picked[number] = true
				table.insert(self.scratch_numbers, {
					number = number,
					scratched = false,
					prize = GetRandomPrize(),
				})
			end
		end

		self.draw = function(self)
			GuiStartFrame(self.gui)

			local id = 21512
			local function new_id()
				id = id + 1
				return id
			end

			local screen_width, screen_height = GuiGetScreenDimensions(self.gui)

			local background_width, background_height =
				GuiGetImageDimensions(self.gui, "mods/noita.fairmod/files/content/gamblecore/scratchoff.png", 1.4)

			local x, y = screen_width / 2 - background_width / 2, screen_height / 2 - background_height / 2

			GuiImage(
				self.gui,
				new_id(),
				x,
				y,
				"mods/noita.fairmod/files/content/gamblecore/scratchoff.png",
				1,
				1.4,
				1.4
			)

			local mx, my = get_mouse_pos(self.gui)
			local mouse_pressed = InputIsMouseButtonDown(1)

			-- Scratch area coordinates
			local scratch_area_x, scratch_area_y = x + (16 * scale_mult), y + (69 * scale_mult)

			local winning_numbers_string = table.concat(self.winning_numbers, "  ")

			-- Handle scratching
			if mx and my then
				if mouse_pressed then
					if
						mx >= scratch_area_x
						and mx <= scratch_area_x + scratch_area_width
						and my >= scratch_area_y
						and my <= scratch_area_y + scratch_area_height
					then
						if self.prev_mx and self.prev_my then
							-- Interpolate between previous and current mouse positions
							local line_points = get_line(self.prev_mx, self.prev_my, mx, my)
							for _, point in ipairs(line_points) do
								local scratch_x = math.floor(point.x - scratch_area_x)
								local scratch_y = math.floor(point.y - scratch_area_y)

								-- Remove a 5x5 area of pixels
								for x_pix = scratch_x - 4, scratch_x + 4 do
									for y_pix = scratch_y - 4, scratch_y + 4 do
										if
											x_pix >= 0
											and x_pix < scratch_area_width
											and y_pix >= 0
											and y_pix < scratch_area_height
										then
											if not self.scratched_pixels[x_pix] then
												self.scratched_pixels[x_pix] = {}
											end
											self.scratched_pixels[x_pix][y_pix] = true
										end
									end
								end
							end
						else
							local scratch_x = math.floor(mx - scratch_area_x)
							local scratch_y = math.floor(my - scratch_area_y)

							-- Remove a 5x5 area of pixels
							for x_pix = scratch_x - 4, scratch_x + 4 do
								for y_pix = scratch_y - 4, scratch_y + 4 do
									if
										x_pix >= 0
										and x_pix < scratch_area_width
										and y_pix >= 0
										and y_pix < scratch_area_height
									then
										if not self.scratched_pixels[x_pix] then self.scratched_pixels[x_pix] = {} end
										self.scratched_pixels[x_pix][y_pix] = true
									end
								end
							end
						end
						self.prev_mx = mx
						self.prev_my = my
					else
						self.prev_mx = nil
						self.prev_my = nil
					end
				else
					self.prev_mx = nil
					self.prev_my = nil
				end
			end

			local cell_width = 27 * 1.4
			local cell_height = 19 * 1.4
			local cells_per_row = 4
			local number_size = 0.7
			local prize_size = 0.8
			local offset_top = 17 * 1.4

			for i, scratch_number in ipairs(self.scratch_numbers) do
				local col = (i - 1) % cells_per_row
				local row = math.floor((i - 1) / cells_per_row)

				local cell_x = scratch_area_x + 1 + col * cell_width
				local cell_y = scratch_area_y + offset_top + 1 + row * cell_height

				local text_width, text_height =
					GuiGetTextDimensions(self.gui, tostring(scratch_number.number), number_size)

				local text_x = cell_x + cell_width / 2 - text_width / 2
				local text_y = cell_y

				local cell_cleared = false
				-- check if 50% of the cell is scratched
				local scratch_count = 0
				for x_pix = cell_x - scratch_area_x, cell_x + cell_width - scratch_area_x do
					for y_pix = cell_y - scratch_area_y, cell_y + cell_height - scratch_area_y do
						local x_pix = math.floor(x_pix)
						local y_pix = math.floor(y_pix)
						if self.scratched_pixels[x_pix] and self.scratched_pixels[x_pix][y_pix] then
							scratch_count = scratch_count + 1
						end
					end
				end

				if scratch_count >= (cell_width * cell_height) / 1.4 then cell_cleared = true end
				local is_winning_number = false
				if self.winner_lookup[scratch_number.number] then is_winning_number = true end

				-- if cell is cleared, and is a winning number, change color to yellow

				GuiZSetForNextWidget(self.gui, -1)
				GuiColorSetForNextWidget(self.gui, 0, 0, 0, 1)

				if cell_cleared and is_winning_number then
					GuiColorSetForNextWidget(self.gui, 194 / 255, 127 / 255, 27 / 255, 1)
				end

				GuiText(self.gui, text_x, text_y, tostring(scratch_number.number), number_size)

				local text_y = text_y + text_height - 2
				local prize_text = " " .. (scratch_number.prize and scratch_number.prize.text or "") .. " "
				local prize_text_width, prize_text_height = GuiGetTextDimensions(self.gui, prize_text, prize_size)
				local prize_text_x = cell_x + cell_width / 2 - prize_text_width / 2
				local prize_text_y = text_y

				GuiZSetForNextWidget(self.gui, -1)
				GuiColorSetForNextWidget(self.gui, 0, 0, 0, 1)
				if cell_cleared and is_winning_number then
					GuiColorSetForNextWidget(self.gui, 194 / 255, 127 / 255, 27 / 255, 1)
				end
				GuiText(self.gui, prize_text_x, prize_text_y, prize_text, prize_size)
			end

			-- Draw winning numbers at top of scratch area, centered
			local text_width, text_height = GuiGetTextDimensions(self.gui, winning_numbers_string, number_size * 1.5)

			local text_x = scratch_area_x + scratch_area_width / 2 - text_width / 2
			local text_y = scratch_area_y + 4

			GuiZSetForNextWidget(self.gui, -1)
			GuiColorSetForNextWidget(self.gui, 0, 0, 0, 1)
			GuiText(self.gui, text_x, text_y, winning_numbers_string, number_size * 1.5)

			-- Draw scratch overlay
			for y_pix = 0, scratch_area_height - 1 do
				local x_pix = 0
				while x_pix < scratch_area_width do
					if not self.scratched_pixels[x_pix] or not self.scratched_pixels[x_pix][y_pix] then
						local run_start = x_pix
						local run_length = 1
						x_pix = x_pix + 1
						while
							x_pix < scratch_area_width
							and (not self.scratched_pixels[x_pix] or not self.scratched_pixels[x_pix][y_pix])
						do
							run_length = run_length + 1
							x_pix = x_pix + 1
						end
						local draw_x = scratch_area_x + run_start
						local draw_y = scratch_area_y + y_pix
						local width = run_length
						local height = 1
						GuiZSetForNextWidget(self.gui, -2)
						GuiImage(
							self.gui,
							new_id(),
							draw_x,
							draw_y,
							"mods/noita.fairmod/files/content/gamblecore/scratch_pixel.png",
							1,
							width,
							height
						)
					else
						x_pix = x_pix + 1
					end
				end
			end
		end

		return self
	end,
}

return scratch_ticket
