
local gui = GuiCreate()
local w, h, cur_y

local module = {}

local function add_info(text)
    local scale = 1
    local tw, th = GuiGetTextDimensions(gui, text, scale)
    GuiText(gui, w - tw - 5, cur_y, text, scale)
    cur_y = cur_y + th
end

function module.update()
    GuiStartFrame(gui)
    GuiZSet(gui, 10)

    w, h = GuiGetScreenDimensions(gui)
    cur_y = 80

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
end

return module