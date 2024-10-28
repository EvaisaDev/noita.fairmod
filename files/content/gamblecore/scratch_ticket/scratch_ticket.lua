-- scratchoff system
-- horribly written prototype that i cannot be bothered to refactor!! :D

local funcs = dofile_once("mods/noita.fairmod/files/content/gamblecore/scratch_ticket/spawn_functions.lua")

local get_money_func = function(amount)
    return function(player)
        local wallet = EntityGetFirstComponent(player, "WalletComponent")
        if wallet then
            local money = ComponentGetValue2(wallet, "money")
            ComponentSetValue2(wallet, "money", money + amount)
        end
    end
end

local get_spawn_func = function(func)
	return function(player)
		local x, y = EntityGetTransform(player)
		func(player, x, y)
	end
end

local prizes = {
    {
        text = "hämis",
        description = "You won a hämis!",
        weight = 10,
        instant_prize = true,
        func = function(player)
            local x, y = EntityGetTransform(player)
            EntityLoad("data/entities/animals/longleg.xml", x, y)
        end,
    },
	{
		text = "potion",
		description = "You won a potion!",
		weight = 10,
		func = get_spawn_func(funcs.spawn_potion),
	},
	{
		text = "wand",
		description = "You won a wand!",
		weight = 10,
		func = get_spawn_func(funcs.spawn_wand),
	},
	{
		text = "spell",
		description = "You won a spell!",
		weight = 10,
		func = get_spawn_func(funcs.spawn_spell),
	},
	{
		text = "perk",
		description = "You won a perk!",
		weight = 10,
		func = get_spawn_func(funcs.spawn_perk),
	},
	{
		text = "free",
		description = "You won a free scratch ticket!",
		weight = 10,
		func = function(player)
			local x, y = EntityGetTransform(player)
			EntityLoad("mods/noita.fairmod/files/content/gamblecore/scratch_ticket/scratch_ticket.xml", x, y)
		end,
	},
	{
		text = "$0.01",
		weight = 50,
		description = "You won 1 cent!",
		func = function(player)
			local x, y = EntityGetTransform(player)
			local nugget = EntityLoad("data/entities/items/pickup/goldnugget.xml", x, y)
			local storage_comps = EntityGetComponent(nugget, "VariableStorageComponent")
			for k, v in pairs(storage_comps or {})do
				if(ComponentGetValue2(v, "name") == "gold_value")then
					ComponentSetValue2(v, "value_int", 1) 
				end
			end
		end,
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
        weight = 25,
        func = get_money_func(25),
    },
    -- 50
    {
        text = "$50.00",
        description = "You won 50 gold!",
        weight = 15,
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
    for idx, v in ipairs(prizes) do
        current_weight = current_weight + v.weight
        if rnd <= current_weight then
            return v, idx
        end
    end

    return nil, nil
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

local scratch_ticket_methods = {}

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
            particles = {},
            redeemed = false,
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

        -- Generate 16 scratch numbers that are unique
        numbers_picked = {}
        while #self.scratch_numbers < 16 do
            local number = Random(number_range[1], number_range[2])
            if not numbers_picked[number] then
                numbers_picked[number] = true
                local prize, prize_index = GetRandomPrize()
                table.insert(self.scratch_numbers, {
                    number = number,
                    scratched = false,
                    prize = prize,
                    prize_index = prize_index,
                    particle_spawned = false,
                })
            end
        end

        self.frame_counter = 0  -- Keep track of frames

        -- Assign methods
        self.draw = scratch_ticket_methods.draw
        self.redeem = scratch_ticket_methods.redeem
        self.save = scratch_ticket_methods.save

        return self
    end,
    load = function(data_string, uid)
		local path = "mods/noita.fairmod/scratch_ticket_"..tostring(uid).."_data.lua"
		ModTextFileSetContent(path, data_string)
        local data = dofile(path)
        local self = {
            winning_numbers = data.winning_numbers,
            scratch_numbers = {},
            winner_lookup = {},
            scratched_pixels = data.scratched_pixels,
            gui = GuiCreate(),
            prev_mx = nil,
            prev_my = nil,
            particles = {},
            redeemed = data.redeemed,
        }
		
        -- Reconstruct winner_lookup
        for _, number in ipairs(self.winning_numbers) do
            self.winner_lookup[number] = true
        end

        -- Reconstruct scratch_numbers
        for i, sn_data in ipairs(data.scratch_numbers) do
            local prize_index = sn_data.prize_index
            local prize = prizes[prize_index]
            local scratch_number = {
                number = sn_data.number,
                scratched = sn_data.scratched,
                prize = prize,
                prize_index = prize_index,
                particle_spawned = false,
            }
            table.insert(self.scratch_numbers, scratch_number)
        end

		self.frame_counter = 0

        -- Assign methods
        self.draw = scratch_ticket_methods.draw
        self.redeem = scratch_ticket_methods.redeem
        self.save = scratch_ticket_methods.save

        return self
    end,
}

function scratch_ticket_methods.draw(self)
    GuiStartFrame(self.gui)

    local id = 21512
    local function new_id()
        id = id + 1
        return id
    end

    local screen_width, screen_height = GuiGetScreenDimensions(self.gui)

    local background_width, background_height =
        GuiGetImageDimensions(self.gui, "mods/noita.fairmod/files/content/gamblecore/scratch_ticket/scratchoff.png", 1.4)

    local x, y = screen_width / 2 - background_width / 2, screen_height / 2 - background_height / 2

    GuiImage(
        self.gui,
        new_id(),
        x,
        y,
        "mods/noita.fairmod/files/content/gamblecore/scratch_ticket/scratchoff.png",
        1,
        1.4,
        1.4
    )

    local mx, my = get_mouse_pos(self.gui)
    local mouse_pressed = InputIsMouseButtonDown(1)

    -- Scratch area coordinates
    local scratch_area_x, scratch_area_y = x + (16 * 1.4), y + (69 * 1.4)

    local winning_numbers_string = table.concat(self.winning_numbers, "  ")

    -- Handle scratching
    if mx and my then
        if mouse_pressed then
            if
                mx >= scratch_area_x
                and mx <= scratch_area_x + (108 * 1.4)
                and my >= scratch_area_y
                and my <= scratch_area_y + (96 * 1.4)
            then

                if (GameGetFrameNum() % 20 == 0) then
                    GamePlaySound("mods/noita.fairmod/fairmod.bank", "scratchoff/scratch", 0, 0)
                end

				local changed = false

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
                                    and x_pix < (108 * 1.4)
                                    and y_pix >= 0
                                    and y_pix < (96 * 1.4)
                                then
                                    if not self.scratched_pixels[x_pix] then
                                        self.scratched_pixels[x_pix] = {}
                                    end
                                    self.scratched_pixels[x_pix][y_pix] = true
									changed = true
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
                                and x_pix < (108 * 1.4)
                                and y_pix >= 0
                                and y_pix < (96 * 1.4)
                            then
                                if not self.scratched_pixels[x_pix] then self.scratched_pixels[x_pix] = {} end
                                self.scratched_pixels[x_pix][y_pix] = true
								changed = true
                            end
                        end
                    end
                end

				if changed and self.scratch_callback then
					self.scratch_callback()
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

        -- If cell is cleared and it's a winning number, spawn particles
        if cell_cleared and is_winning_number and not scratch_number.scratched then
            local num_particles = 20  -- Number of particles
            local cell_center_x = cell_x + cell_width / 2
            local cell_center_y = cell_y + cell_height / 2
            for i = 1, num_particles do
                local angle = math.random() * 2 * math.pi
                local speed = math.random() * 100 + 50  -- Adjust speed range
                local vx = math.cos(angle) * speed
                local vy = math.sin(angle) * speed
                local particle = {
                    x = cell_center_x,
                    y = cell_center_y,
                    vx = vx,
                    vy = vy,
                    gravity = 200,  -- Gravity acceleration (pixels per second squared)
                    life_frames = 120,  -- Total life time in frames (~2 seconds at 60 FPS)
                    max_life_frames = 120,  -- Used for alpha calculation
                    angle = math.random() * 360,  -- Random initial angle in degrees
                    angular_velocity = (math.random() - 0.5) * 360,  -- Random angular velocity (-180 to 180 degrees per second)
                }
                table.insert(self.particles, particle)
            end

            GamePlaySound("mods/noita.fairmod/fairmod.bank", "scratchoff/win", 0, 0)

            -- Check if instant redeem
            if (scratch_number.prize.instant_prize) then
                local players = EntityGetWithTag("player_unit") or {}

                if #players > 0 then
                    local player = players[1]

                    scratch_number.prize.func(player)
                end
            end

            scratch_number.scratched = true
        end

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

    local text_x = scratch_area_x + (108 * 1.4) / 2 - text_width / 2
    local text_y = scratch_area_y + 4

    GuiZSetForNextWidget(self.gui, -1)
    GuiColorSetForNextWidget(self.gui, 0, 0, 0, 1)
    GuiText(self.gui, text_x, text_y, winning_numbers_string, number_size * 1.5)

    -- Draw scratch overlay
    for y_pix = 0, (96 * 1.4) - 1 do
        local x_pix = 0
        while x_pix < (108 * 1.4) do
            if not self.scratched_pixels[x_pix] or not self.scratched_pixels[x_pix][y_pix] then
                local run_start = x_pix
                local run_length = 1
                x_pix = x_pix + 1
                while
                    x_pix < (108 * 1.4)
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
                    "mods/noita.fairmod/files/content/gamblecore/scratch_ticket/scratch_pixel.png",
                    1,
                    width,
                    height
                )
            else
                x_pix = x_pix + 1
            end
        end
    end

    local delta_time = 1 / 60  -- Time per frame

    for i = #self.particles, 1, -1 do  -- Iterate backwards to remove particles
        local particle = self.particles[i]
        -- Update particle position and velocity
        particle.vy = particle.vy + particle.gravity * delta_time
        particle.x = particle.x + particle.vx * delta_time
        particle.y = particle.y + particle.vy * delta_time
        particle.life_frames = particle.life_frames - 1

        -- Update particle angle
        particle.angle = particle.angle + particle.angular_velocity * delta_time

        local alpha = particle.life_frames / particle.max_life_frames
        GuiZSetForNextWidget(self.gui, -3)
        GuiImage(
            self.gui,
            new_id(),
            particle.x,
            particle.y,
            "mods/noita.fairmod/files/content/gamblecore/scratch_ticket/star.png",
            alpha,
            1,
            1,
            math.rad(particle.angle)
        )

        -- Remove particle if its life time is over
        if particle.life_frames <= 0 then
            table.remove(self.particles, i)
        end
    end

    self.frame_counter = self.frame_counter + 1
end

function scratch_ticket_methods.redeem(self)
    if (self.redeemed) then return end
    local players = EntityGetWithTag("player_unit") or {}
    if #players == 0 then return end
    local player = players[1]

    -- Only redeem uncovered prizes
    for i, scratch_number in ipairs(self.scratch_numbers) do
        if
            self.winner_lookup[scratch_number.number]
            and scratch_number.scratched
            and scratch_number.prize
            and not scratch_number.prize.instant_prize
        then
            scratch_number.prize.func(player)
        end
    end
    self.redeemed = true
end

function scratch_ticket_methods.save(self)
    local data = {
        winning_numbers = self.winning_numbers,
        scratch_numbers = {},
        scratched_pixels = self.scratched_pixels,
        redeemed = self.redeemed,
    }
    for i, scratch_number in ipairs(self.scratch_numbers) do
        data.scratch_numbers[i] = {
            number = scratch_number.number,
            scratched = scratch_number.scratched,
            prize_index = scratch_number.prize_index,
        }
    end

    local data_string = 'return ' .. serialize(data)
    return data_string
end

function serialize(o)
    if type(o) == 'number' then
        return tostring(o)
    elseif type(o) == 'boolean' then
        return tostring(o)
    elseif type(o) == 'string' then
        return string.format("%q", o)
    elseif type(o) == 'table' then
        local s = '{'
        local first = true
        for k, v in pairs(o) do
            if first then
                first = false
            else
                s = s .. ','
            end
            local key
            if type(k) == 'string' and string.match(k, '^[_%a][_%w]*$') then
                key = k
            else
                key = '[' .. serialize(k) .. ']'
            end
            s = s .. key .. '=' .. serialize(v)
        end
        s = s .. '}'
        return s
    else
        error("cannot serialize a " .. type(o))
    end
end

return scratch_ticket
