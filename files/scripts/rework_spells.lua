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

for i=1,#actions do -- fast as fuck boi
    if actions_to_edit[actions[i].id] then
        for key, value in pairs(actions_to_edit[actions[i].id]) do
            actions[i][key] = value
        end
        actions[i]['unfair_rework'] = true
    end
end