local actions_to_edit = {
    ["MANA_REDUCE"] = {
        description = "Adds up to 30 mana to the wand, scaled by how fast you cast!",
		mana = 0,
        action = function()
			current_reload_time = current_reload_time + 15
			if not reflecting then
				local delta = math.min(30, (GameGetFrameNum() - (LastShootingStart or 0)) * 2)
				mana = mana + delta
				draw_actions(1, true)
				LastShootingStart = GameGetFrameNum()
			end
        end,
    },
}

local function split_string(input_str)
    local result = {}
    for num in string.gmatch(input_str, "[^,]+") do
        table.insert(result, tonumber(num))
    end
    return result
end


for i=1,#actions do -- fast as fuck boi
    local action = actions[i]
    if actions_to_edit[action.id] then
        for key, value in pairs(actions_to_edit[action.id]) do
            action[key] = value
        end
        action['unfair_rework'] = true
    end
    
    -- worst fucking code ensues
    local tiers = split_string(action.spawn_level)
    local probs = split_string(action.spawn_probability)
    local final = {}
    for k=1, #tiers do final[tonumber(tiers[k])] = tonumber(probs[k]) + 0.1 end
    for k=0, 6 do if final[k] == nil then final[k] = 0.2 end end
    if final[10] == nil then final[10] = 0.2 end

    actions[i] = action
end