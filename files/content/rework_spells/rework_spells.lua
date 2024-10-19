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
				if EntityHasTag(GetUpdatedEntityID(), "player_unit") then
					GameAddFlagRun("hahah_fuck_your_mana")
				end
			end
		end,
	},
	["CHAINSAW"] = {
		-- make this dumbass chainsaw pull the player forward.
		action = function()
			add_projectile("data/entities/projectiles/deck/chainsaw.xml")
			c.fire_rate_wait = 0
			c.spread_degrees = c.spread_degrees + 6.0

			
			shot_effects.recoil_knockback = math.min(shot_effects.recoil_knockback - 10, 0)

			local entity_id = GetUpdatedEntityID()
			local controls_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "ControlsComponent")
			if controls_comp ~= nil then
				local character_data_comp = EntityGetFirstComponent(entity_id, "CharacterDataComponent")
				if character_data_comp ~= nil then
					local velocity_x, velocity_y = ComponentGetValueVector2(character_data_comp, "mVelocity")
					local aim_dir_x, aim_dir_y = ComponentGetValueVector2(controls_comp, "mAimingVectorNormalized")


					
					local target_velocity_x = velocity_x + (aim_dir_x * 100)
					local target_velocity_y = velocity_y + (aim_dir_y * 100)
		
					ComponentSetValue2(character_data_comp, "mVelocity", target_velocity_x, target_velocity_y)
				end
			end
			

			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10
		end,
	}
}

local function split_string(input_str)
	local result = {}
	for num in string.gmatch(input_str, "[^,]+") do
		table.insert(result, tonumber(num))
	end
	return result
end

for i = 1, #actions do -- fast as fuck boi
	local action = actions[i]
	if actions_to_edit[action.id] then
		for key, value in pairs(actions_to_edit[action.id]) do
			action[key] = value
		end
		action["unfair_rework"] = true
	end

	-- worst fucking code ensues
	local tiers = split_string(action.spawn_level)
	local probs = split_string(action.spawn_probability)
	local final = {}
	for k = 1, #tiers do
		final[tonumber(tiers[k])] = tonumber(probs[k]) + 0.1
	end
	for k = 0, 6 do
		if final[k] == nil then
			final[k] = 0.2
		end
	end
	if final[10] == nil then
		final[10] = 0.2
	end

	actions[i] = action
end

