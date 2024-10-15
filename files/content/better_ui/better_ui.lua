
local gui = GuiCreate()
local w, h, cur_y
local pending_info = {}

local module = {}

local scale = 0.75

local function render_info(text, x_shift)
    local _tw, th = GuiGetTextDimensions(gui, text, scale)
    GuiText(gui, w - x_shift - 10, cur_y, text, scale)
    cur_y = cur_y + th
end

local function add_info(text)
    table.insert(pending_info, text)
end

local function calc_max_length()
    local c_max = 0
    for _, text in ipairs(pending_info) do
        local tw, _ = GuiGetTextDimensions(gui, text, scale)
        c_max = math.max(c_max, tw)
    end
    return c_max
end

function module.update()
    GuiStartFrame(gui)
    GuiZSet(gui, 10)

    w, h = GuiGetScreenDimensions(gui)
    cur_y = 80
    pending_info = {}

    local wse = GameGetWorldStateEntity()
    local wsc = EntityGetFirstComponent(wse, "WorldStateComponent")

    local time_fraction = ComponentGetValue2(wsc, "time")

    local time_minutes_total = time_fraction * (23 * 60)
    local time_minutes = time_minutes_total % 60
    local time_hours = time_minutes_total / 60
    
    add_info(string.format("Time: %2.0f:%2.0f", time_hours, time_minutes))

    local rain = ComponentGetValue2(wsc, "rain")
    local fog = ComponentGetValue2(wsc, "fog")
    
    if rain > 0.5 then
        add_info("Weather: raining")
    elseif fog > 0.5 then
        add_info("Weather: foggy")
    else
        add_info("Weather: clean")
    end

    add_info("0 Fishing power")

    local x, y = GameGetCameraPos()
    -- +1 to count the player.
    local enemy_count = #(EntityGetInRadiusWithTag(x, y, 300, "enemy") or {}) + 1
    if enemy_count == 1 then
        add_info(enemy_count.." enemy nearby")
    else
        add_info(enemy_count.." enemies nearby")
    end

    local times_taken_piss = tonumber(GlobalsGetValue("TIMES_TOOK_PISS", "0")) or 0
    local times_taken_shit = tonumber(GlobalsGetValue("TIMES_TOOK_SHIT", "0")) or 0

    if times_taken_piss > 0 then
        add_info(times_taken_piss.." pisses taken")
    end
    if times_taken_shit > 0 then
        add_info(times_taken_shit.." shits taken")
    end

    local x_shift = calc_max_length()
    for _, text in ipairs(pending_info) do
        render_info(text, x_shift)
    end
end

return module