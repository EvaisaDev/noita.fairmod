-- Funni ui that is shown on the right side of the screen.

local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

for content in nxml.edit_file("data/entities/animals/boss_centipede/sampo.xml") do
    content:add_child(nxml.new_element("LuaComponent", {
        script_item_picked_up="mods/noita.fairmod/files/content/better_ui/append/sampo_pickup.lua",
        remove_after_executed="1"
    }))
end

local gui = GuiCreate()
local w, h, cur_y
local pending_info = {}

local module = {}

local scale = 0.75

local function render_info(info, x_shift)
    GuiText(gui, w - x_shift - 10, cur_y, info.text, scale)
    if info.text2 ~= nil then
        local tw, _th = GuiGetTextDimensions(gui, info.text2, scale)
        GuiText(gui, w - tw - 10, cur_y, info.text2, scale)
    end
    cur_y = cur_y + 9
end

local function add_info(text, text2)
    table.insert(pending_info, {text=text, text2=text2})
end

local function calc_max_length()
    local c_max = 0
    for _, info in ipairs(pending_info) do
        local tw, _ = GuiGetTextDimensions(gui, info.text, scale)
        c_max = math.max(c_max, tw)
    end
    return c_max
end

local function frames_to_time(frames)
    local seconds_f = frames / 60
    local minutes = seconds_f / 60
    seconds_f = seconds_f % 60
    return string.format("%i:%2.3f", minutes, seconds_f)
end

local function add_split(label, id)
    local splt = GlobalsGetValue(id, "--")
    if splt ~= "--" then
        splt = frames_to_time(tonumber(splt))
    end
    add_info(label..": ", splt)
end

local function speedrun_splits()
    add_info("Noita Fairmod           Any%")
    add_split("The Door", "SPEEDRUN_SPLIT_DOOR")
    add_split("Sampo", "SPEEDRUN_SPLIT_SAMPO")
    add_split("Kolmi", "SPEEDRUN_SPLIT_KOLMI")
    add_split("The Work", "SPEEDRUN_SPLIT_WORK")
    add_info("Current time: ", frames_to_time(GameGetFrameNum()))
    add_info("")
end

function module.update()
    GuiStartFrame(gui)
    GuiZSet(gui, 10)

    w, h = GuiGetScreenDimensions(gui)
    cur_y = 80
    pending_info = {}

    local wse = GameGetWorldStateEntity()
    local wsc = EntityGetFirstComponent(wse, "WorldStateComponent")

    if GameHasFlagRun("speedrun_door_used") then
        speedrun_splits()
    end

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
        if times_taken_piss == 1 then
            add_info(times_taken_piss.." piss taken")
        else
            add_info(times_taken_piss.." pisses taken")
        end
    end
    if times_taken_shit > 0 then
        if times_taken_shit == 1 then
            add_info(times_taken_shit.." shit taken")
        else
            add_info(times_taken_shit.." shits taken")
        end
    end
    
    if GameHasFlagRun("gamblecore_found") then
        add_info("")
        add_info("Gamblehelper (tm)")
        local times_won = tonumber(GlobalsGetValue("GAMBLECORE_TIMES_WON", "0")) or 0
        local times_lost_in_a_row = tonumber(GlobalsGetValue("GAMBLECORE_TIMES_LOST_IN_A_ROW", "0")) or 0
        if times_won == 1 then
            add_info("Won "..times_won.. " time")
        else
            add_info("Won "..times_won.. " times")
        end
        
        if times_lost_in_a_row == 1 then
            add_info("Lost "..times_lost_in_a_row.." time since last win")
        else
            add_info("Lost "..times_lost_in_a_row.." times since last win")
        end
        
        if times_lost_in_a_row > 2 then
            local p1 = 0.1
            local p = math.pow((1-p1), times_lost_in_a_row+1)
            local pf = string.format("%.2f %%", p*100)
            add_info("Probability of losing "..(times_lost_in_a_row+1).." times in row is ".. pf)
            add_info("Keep gambling, you're due for a win!")
        end


        add_info("")
    end

    local x_shift = calc_max_length()
    for _, text in ipairs(pending_info) do
        render_info(text, x_shift)
    end
end

return module