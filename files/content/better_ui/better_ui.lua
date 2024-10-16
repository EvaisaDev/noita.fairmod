-- Funni ui that is shown on the right side of the screen.
-- written by IQuant, Refactored by Eba

local nxml = dofile_once("mods/noita.fairmod/files/lib/nxml.lua") --- @type nxml

for content in nxml.edit_file("data/entities/animals/boss_centipede/sampo.xml") do
    content:add_child(nxml.new_element("LuaComponent", {
        script_item_picked_up="mods/noita.fairmod/files/content/better_ui/append/sampo_pickup.lua",
        remove_after_executed="1"
    }))
end

ModLuaFileAppend("data/entities/animals/boss_centipede/ending/sampo_start_ending_sequence.lua", "mods/noita.fairmod/files/content/better_ui/append/ending_sequence.lua")

local gui = GuiCreate()
local w, h, cur_y
local pending_info = {}

local module = {}

local scale = 0.75

local function frames_to_time(frames)
    local seconds_f = frames / 60
    local minutes = math.floor(seconds_f / 60)
    seconds_f = seconds_f % 60
    return string.format("%i:%02.3f", minutes, seconds_f)
end

local function has_flag_run(flag)
    return function() return GameHasFlagRun(flag) end
end

local function global_greater_than_zero(global)
    return function() return (tonumber(GlobalsGetValue(global, "0")) or 0) > 0 end
end

local function speedrun_split(label, var)
    return function()
        local splt = GlobalsGetValue(var, "--")
        if splt ~= "--" then
            splt = frames_to_time(tonumber(splt))
        end
        return {label, splt}
    
    end
end

local ui_displays = {
    normal = {
        {
            text = function()
                return {text = "Debt: "..GlobalsGetValue("loan_shark_debt", "0"), color = {1, 0.2, 0.2}}
            end,
            condition = global_greater_than_zero("loan_shark_debt"),
        },
        {
            text = function()
                local wse = GameGetWorldStateEntity()
                local wsc = EntityGetFirstComponent(wse, "WorldStateComponent")
                local time_fraction = ComponentGetValue2(wsc, "time")
                local time_minutes_total = time_fraction * (23 * 60)
                local time_minutes = time_minutes_total % 60
                local time_hours = time_minutes_total / 60
                return string.format("Time: %2.0f:%2.0f", time_hours, time_minutes)
            end,
        },
        {
            text = function()
                local wse = GameGetWorldStateEntity()
                local wsc = EntityGetFirstComponent(wse, "WorldStateComponent")
                local rain = ComponentGetValue2(wsc, "rain")
                local fog = ComponentGetValue2(wsc, "fog")
                if rain > 0.5 then
                    return "Weather: raining"
                elseif fog > 0.5 then
                    return "Weather: foggy"
                else
                    return "Weather: clean"
                end
            end,
        },
        {
            text = "0 Fishing power"
        },
        {
            text = function()
                local x, y = GameGetCameraPos()
                -- +1 to count the player.
                local enemy_count = #(EntityGetInRadiusWithTag(x, y, 300, "enemy") or {}) + 1
                if enemy_count == 1 then
                    return enemy_count.." enemy nearby"
                else
                    return enemy_count.." enemies nearby"
                end
            end
        },
        {
            text = function()
                local times_taken_piss = tonumber(GlobalsGetValue("TIMES_TOOK_PISS", "0")) or 0
                if times_taken_piss == 1 then
                    return times_taken_piss.." piss taken"
                else
                    return times_taken_piss.." pisses taken"
                end
            end,
            condition = global_greater_than_zero("TIMES_TOOK_PISS")
        },
        {
            text = function()
                local times_taken_shit = tonumber(GlobalsGetValue("TIMES_TOOK_SHIT", "0")) or 0
                if times_taken_shit == 1 then
                    return times_taken_shit.." shit taken"
                else
                    return times_taken_shit.." shits taken"
                end
            end,
            condition = global_greater_than_zero("TIMES_TOOK_SHIT")
        },
        {
            text = "",
            condition = has_flag_run("gamblecore_found"),
        },
        {
            text = "Gamblehelper (tm)",
            condition = has_flag_run("gamblecore_found"),
        },
        {
            text = function()
                local times_won = tonumber(GlobalsGetValue("GAMBLECORE_TIMES_WON", "0")) or 0
                if times_won == 1 then
                    return "Won "..times_won.. " time"
                else
                    return "Won "..times_won.. " times"
                end
            end,
            condition = has_flag_run("gamblecore_found"),
        },
        {
            text = function()
                local times_lost_in_a_row = tonumber(GlobalsGetValue("GAMBLECORE_TIMES_LOST_IN_A_ROW", "0")) or 0
                if times_lost_in_a_row == 1 then
                    return "Lost "..times_lost_in_a_row.." time since last win"
                else
                    return "Lost "..times_lost_in_a_row.." times since last win"
                end
            end,
            condition = has_flag_run("gamblecore_found"),
        },
        {
            text = function()
                local times_lost_in_a_row = tonumber(GlobalsGetValue("GAMBLECORE_TIMES_LOST_IN_A_ROW", "0")) or 0
                if times_lost_in_a_row > 2 then
                    local p1 = 0.1
                    local p = math.pow((1-p1), times_lost_in_a_row+1)
                    local pf = string.format("%.2f %%", p*100)
                    return "Probability of losing "..(times_lost_in_a_row+1).." times in row is ".. pf
                else
                    return nil
                end
            end,
            condition = function()
                local times_lost = tonumber(GlobalsGetValue("GAMBLECORE_TIMES_LOST_IN_A_ROW", "0")) or 0
                return GameHasFlagRun("gamblecore_found") and times_lost > 2
            end,
        },
        {
            text = "Keep gambling, you're due for a win!",
            condition = function()
                local times_lost = tonumber(GlobalsGetValue("GAMBLECORE_TIMES_LOST_IN_A_ROW", "0")) or 0
                return GameHasFlagRun("gamblecore_found") and times_lost > 2
            end,
        },
        {
            text = "",
            condition = has_flag_run("gamblecore_found"),
        },
    },
    speedrun = {
        {
            text = "Noita Fairmod           Any%"
        },
        {
            text = speedrun_split("The Door: ", "SPEEDRUN_SPLIT_DOOR"),
        },
        {
            text = speedrun_split("Sampo: ", "SPEEDRUN_SPLIT_SAMPO"),
        },
        -- Maybe do Kolmi later
        -- {
        --     text = speedrun_split("Kolmi: ", "SPEEDRUN_SPLIT_KOLMI"),
        -- },
        {
            text = speedrun_split("Complete The Work: ", "SPEEDRUN_SPLIT_WORK"),
        },
        {
            text = function()
                return {"Current time: ", frames_to_time(GameGetFrameNum())}
            end,
        },
        {
            text = ""
        },
    },
}

local current_display = "normal"

local function render_info(info, x_shift)
    -- Render the first text entry
    local first_entry = info[1]
    local text = ""
	local color = {1, 1, 1, 1}
    if type(first_entry) == "string" then
        text = first_entry
    elseif type(first_entry) == "table" then
        text = first_entry.text or ""
		color = first_entry.color or color
    end
	GuiColorSetForNextWidget(gui, color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    GuiText(gui, w - x_shift - 10, cur_y, text, scale)

    -- Render additional text entries aligned to the right
    local total_width = 10
    for i = #info, 2, -1 do
        local entry = info[i]
        local entry_text = ""
		local entry_color = {1, 1, 1, 1}
        if type(entry) == "string" then
            entry_text = entry
        elseif type(entry) == "table" then
            entry_text = entry.text or ""
			entry_color = entry.color or entry_color
        end
        local tw, _ = GuiGetTextDimensions(gui, entry_text, scale)
		GuiColorSetForNextWidget(gui, entry_color[1] or 1, entry_color[2] or 1, entry_color[3] or 1, entry_color[4] or 1)
        GuiText(gui, w - total_width - tw, cur_y, entry_text, scale)
        total_width = total_width + tw
    end
    cur_y = cur_y + 9
end

local function calc_max_length()
    local c_max = 0
    for _, info in ipairs(pending_info) do
        local first_entry = info[1]
        local text = ""
        if type(first_entry) == "string" then
            text = first_entry
        elseif type(first_entry) == "table" then
            text = first_entry.text or ""
        end
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

    -- Determine which display to use
    if GameHasFlagRun("speedrun_door_used") then
        current_display = "speedrun"
    else
        current_display = "normal"
    end

    local display_entries = ui_displays[current_display]

    for _, entry in ipairs(display_entries) do
        local condition_met = true
        if entry.condition then
            condition_met = entry.condition()
        end

        if condition_met then
            local text = entry.text
            if type(text) == "function" then
                text = text()
            end
            if text ~= nil then
                if type(text) == "string" or type(text) == "table" then
                    -- Handle text being a string or table
                    -- For consistency, wrap single strings in a table
                    if type(text) == "string" then
                        text = {text}
                    end
                    table.insert(pending_info, text)
                end
            end
        end
    end

    local x_shift = calc_max_length()
    for _, info in ipairs(pending_info) do
        render_info(info, x_shift)
    end
end

return module
