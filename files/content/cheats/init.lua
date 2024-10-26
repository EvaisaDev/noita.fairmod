local module = {}

local current_input_text = ""

module.update = function()
    dofile_once("mods/noita.fairmod/files/scripts/utils/utilities.lua")

    local players = GetPlayers()
    
    if #players == 0 then return end
    
    local player = players[1]

    local cheat_codes = dofile_once("mods/noita.fairmod/files/content/cheats/cheat_codes.lua")
    local keys = dofile_once("mods/noita.fairmod/files/content/cheats/misc/keyboard.lua")

    local key_ranges = keys.key_ranges

    local last_added = ""

    local was_any_pressed = false
    for _, key_range in ipairs(key_ranges) do
        for i = key_range[1], key_range[2] do
            if InputIsKeyJustUp(i) then
                last_added = (keys.key_map[i] or "")
                current_input_text = current_input_text .. last_added
                was_any_pressed = true
            end
        end
    end

    if not was_any_pressed then return end

    -- Function to check if input matches any cheat code
    local function check_input(input)
        for k, v in pairs(cheat_codes) do
            if string.sub(k, 1, string.len(input)) == input then
                if string.len(k) == string.len(input) then
                    GamePrintImportant("Cheat activated: " .. v.name,  v.description)
                    v.func(player)
                    current_input_text = ""
                end
                print("current_cheat_text", input)
                return true
            end
        end
        return false
    end

    local was_any_match = check_input(current_input_text)

    if not was_any_match then
        -- Try all suffixes of current_input_text
        local found = false
        for i = 2, #current_input_text do
            local suffix = current_input_text:sub(i)
            if check_input(suffix) then
                current_input_text = suffix
                found = true
                break
            end
        end
        if not found then
            current_input_text = ""
        end
    end
end

return module
